#!/usr/bin/env node

import {
  closeSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  openSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { spawn, spawnSync } from "node:child_process";

const root = resolve(import.meta.dirname, "..");
const settingsPath = join(root, "inputs", "settings.md");
const outputPath = join(root, "inputs", "strategy-narrative.json");
const chromePath = process.env.CHROME_PATH;

function readSetting(source, name) {
  const match = source.match(new RegExp(`^\\s{2}${name}:\\s*(.*?)\\s*$`, "m"));
  if (!match) throw new Error(`Missing ${name} in inputs/settings.md.`);
  const value = match[1].trim();
  if (
    value.length >= 2 &&
    ((value.startsWith("'") && value.endsWith("'")) ||
      (value.startsWith('"') && value.endsWith('"')))
  ) {
    return value.slice(1, -1);
  }
  return value;
}

function utcNow() {
  return new Date().toISOString().replace(/\.\d{3}Z$/, "Z");
}

function headingRecords(lines) {
  const records = [];
  let inCode = false;
  lines.forEach((line, index) => {
    if (/^\s*```/.test(line)) {
      inCode = !inCode;
      return;
    }
    if (inCode) return;
    const match = line.match(/^(#{1,6})\s+/);
    if (match) records.push({ index, level: match[1].length });
  });
  return records;
}

// The report already supplies the "Strategy Narrative" heading. Drop a lone title
// from the imported brief and put the remaining hierarchy directly beneath it.
function nestNarrativeHeadings(markdown, topLevel = 3) {
  const lines = markdown.split("\n");
  let headings = headingRecords(lines);
  if (!headings.length) return markdown.trim();

  const minimum = Math.min(...headings.map(({ level }) => level));
  if (
    headings.length > 1 &&
    headings[0].level === minimum &&
    headings.filter(({ level }) => level === minimum).length === 1
  ) {
    lines.splice(headings[0].index, 1);
    if (lines[headings[0].index]?.trim() === "") lines.splice(headings[0].index, 1);
    headings = headingRecords(lines);
  }
  if (!headings.length) return lines.join("\n").trim();

  const shift = topLevel - Math.min(...headings.map(({ level }) => level));
  for (const { index, level } of headings) {
    const adjusted = Math.max(1, Math.min(6, level + shift));
    lines[index] = lines[index].replace(/^#{1,6}/, "#".repeat(adjusted));
  }
  return lines.join("\n").trim();
}

class DevToolsSession {
  static async connect(url) {
    const session = new DevToolsSession(url);
    await session.opened;
    return session;
  }

  constructor(url) {
    this.nextId = 1;
    this.pending = new Map();
    this.socket = new WebSocket(url);
    this.opened = new Promise((resolveOpen, rejectOpen) => {
      this.socket.addEventListener("open", resolveOpen, { once: true });
      this.socket.addEventListener("error", rejectOpen, { once: true });
    });
    this.socket.addEventListener("message", ({ data }) => {
      const message = JSON.parse(data);
      if (!message.id || !this.pending.has(message.id)) return;
      const { resolveRequest, rejectRequest } = this.pending.get(message.id);
      this.pending.delete(message.id);
      if (message.error) rejectRequest(new Error(message.error.message));
      else resolveRequest(message.result);
    });
  }

  send(method, params = {}) {
    const id = this.nextId++;
    return new Promise((resolveRequest, rejectRequest) => {
      this.pending.set(id, { resolveRequest, rejectRequest });
      this.socket.send(JSON.stringify({ id, method, params }));
    });
  }

  async evaluate(expression) {
    const response = await this.send("Runtime.evaluate", {
      expression,
      returnByValue: true,
      awaitPromise: true,
    });
    if (response.exceptionDetails) {
      throw new Error(response.exceptionDetails.text || "Browser evaluation failed.");
    }
    return response.result.value;
  }

  close() {
    this.socket.close();
  }
}

async function waitForBrowser(timeoutMs = 30_000) {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    try {
      const response = await fetch("http://127.0.0.1:9222/json/version");
      if (response.ok) return;
    } catch {
      // Chrome is still starting.
    }
    await new Promise((resolveWait) => setTimeout(resolveWait, 500));
  }
  throw new Error("Headless Chrome did not start on debugging port 9222.");
}

async function readMessages(url, timeoutMs = 60_000) {
  const targetResponse = await fetch(
    `http://127.0.0.1:9222/json/new?${encodeURIComponent(url)}`,
    { method: "PUT" },
  );
  if (!targetResponse.ok) {
    throw new Error(`Chrome could not open the shared conversation (${targetResponse.status}).`);
  }
  const target = await targetResponse.json();
  const session = await DevToolsSession.connect(target.webSocketDebuggerUrl);
  try {
    await session.send("Page.enable");
    const deadline = Date.now() + timeoutMs;
    while (Date.now() < deadline) {
      const ready = await session.evaluate(
        "document.querySelectorAll('[data-message-author-role]').length > 0",
      );
      if (ready) break;
      await new Promise((resolveWait) => setTimeout(resolveWait, 500));
    }
    const messages = await session.evaluate(`Array.from(
      document.querySelectorAll('[data-message-author-role="assistant"]')
    ).map((node) => {
      const body = node.querySelector(".markdown") || node;
      return { text: node.innerText || "", html: body.innerHTML || "" };
    })`);
    if (!messages?.length) {
      throw new Error("The shared conversation contained no assistant messages.");
    }
    return messages;
  } finally {
    session.close();
  }
}

function convertHtmlToMarkdown(html, temporaryDirectory) {
  const sourcePath = join(temporaryDirectory, "strategy-narrative.html");
  const markdownPath = join(temporaryDirectory, "strategy-narrative.md");
  writeFileSync(sourcePath, html, "utf8");
  const result = spawnSync(
    "quarto",
    [
      "pandoc",
      sourcePath,
      "--from=html",
      "--to=gfm",
      "--wrap=none",
      `--output=${markdownPath}`,
    ],
    { encoding: "utf8" },
  );
  if (result.status !== 0 || !existsSync(markdownPath)) {
    throw new Error(`Converting the strategy narrative to Markdown failed.\n${result.stderr}`);
  }
  return readFileSync(markdownPath, "utf8").trim();
}

async function main() {
  if (!chromePath) throw new Error("CHROME_PATH was not provided by the workflow.");

  const settings = readFileSync(settingsPath, "utf8");
  const url = readSetting(settings, "strategy_narrative_url");
  const patternText = readSetting(settings, "strategy_narrative_pattern");
  const pattern = new RegExp(patternText);
  const temporaryDirectory = mkdtempSync(join(tmpdir(), "strategy-narrative-"));
  const chromeLogPath = join(temporaryDirectory, "chrome.log");
  const chromeLog = openSync(chromeLogPath, "a");
  const chrome = spawn(
    chromePath,
    [
      "--headless=new",
      "--no-sandbox",
      "--disable-dev-shm-usage",
      "--remote-debugging-address=127.0.0.1",
      "--remote-debugging-port=9222",
      `--user-data-dir=${join(temporaryDirectory, "chrome-profile")}`,
      "about:blank",
    ],
    { stdio: ["ignore", chromeLog, chromeLog] },
  );

  try {
    await waitForBrowser();
    console.log("Reading the strategy narrative from the shared conversation.");
    const messages = await readMessages(url);
    const matching = messages
      .map((message, index) => ({ message, index }))
      .filter(({ message }) => pattern.test(message.text));
    if (!matching.length) {
      throw new Error(
        `No message matched strategy_narrative_pattern (${patternText}).`,
      );
    }
    const { message } = matching.at(-1);
    const periodMatch = message.text.match(
      /Week of\s+([A-Za-z]+\s+\d{1,2},\s+\d{4})/,
    );
    const body = nestNarrativeHeadings(
      convertHtmlToMarkdown(message.html, temporaryDirectory),
    );
    if (!body) throw new Error("The strategy narrative was empty after conversion.");

    const fetchedAt = utcNow();
    const snapshot = {
      schema: 1,
      source_url: url,
      fetched_at: fetchedAt,
      period: periodMatch?.[1] ?? null,
      exported_at: fetchedAt,
      body,
    };
    mkdirSync(dirname(outputPath), { recursive: true });
    const stagedPath = `${outputPath}.tmp`;
    writeFileSync(stagedPath, `${JSON.stringify(snapshot, null, 2)}\n`, "utf8");
    renameSync(stagedPath, outputPath);
    console.log(`Wrote ${outputPath.slice(root.length + 1)}.`);
  } finally {
    chrome.kill("SIGTERM");
    closeSync(chromeLog);
    rmSync(temporaryDirectory, { recursive: true, force: true });
  }
}

main().catch((error) => {
  console.error(error.stack || error.message);
  process.exitCode = 1;
});
