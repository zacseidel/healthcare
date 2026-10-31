Start the report with exactly this title on its own line:

# Life Sciences Strategy Brief

Then include a heading of the form `## Week of Month D, YYYY` using the report run date supplied in the request.

## Purpose and scope

Produce an executive weekly briefing on consequential developments across pharmaceuticals,
biotechnology, life sciences, and medical devices. Use a strategy lens rather than a news-summary
format.

Focus on developments involving:

- Specific drugs, biologics, therapeutic modalities, disease states, and clinical interventions
- Clinical trials, study updates, safety and efficacy signals, and treatment paradigms
- FDA decisions, reimbursement, access, and material regulatory or policy changes
- Emerging technologies, diagnostics, surgical technologies, devices, and AI-enabled clinical tools
- Company strategy, competitive dynamics, licensing, partnerships, M&A, and venture investment

The report should identify information that could change how an informed executive, strategist,
investor, manufacturer, payer, provider, or other industry participant thinks about a therapeutic
market, technology, or company.

## Clinical and scientific analysis

Give substantial attention when material to Phase 1, 2, and 3 trials; pivotal readouts; longer-term
follow-up; safety and efficacy; endpoint and subgroup interpretation; failures and discontinuations;
label expansions; submissions; FDA approvals and complete response letters; advisory committees;
accelerated approval and confirmatory trials; real-world evidence; guidelines; standards of care;
and comparative effectiveness.

Evaluate clinical significance rather than accepting a press release's description. Where relevant,
assess:

- Absolute versus relative efficacy and clinical meaningfulness
- Durability, tolerability, safety, convenience, dosing, administration, and adherence
- Target and eligible populations
- Competitive differentiation and standards-of-care implications
- Probability of approval and regulatory risk
- Reimbursement, access, and commercial potential

Do not overstate preliminary, exploratory, post hoc, or company-promoted findings. Explicitly
distinguish scientific significance from commercial significance. A statistically significant result
may have limited strategic value if its effect is modest, safety or administration is problematic, a
superior competitor exists, or reimbursement is poor. A modest clinical advance may be commercially
important if it expands the treatable population, improves convenience or safety, changes sequencing,
moves treatment earlier, or improves reimbursement.

## Therapeutic and technology coverage

Follow meaningful developments across areas and modalities including oncology; obesity and metabolic
disease; diabetes; cardiovascular disease; neurology and Alzheimer's disease; immunology and
autoimmune disease; rare and infectious disease; vaccines; gene and cell therapy; RNA therapeutics;
antibody-drug conjugates; bispecific antibodies; radiopharmaceuticals; precision medicine;
diagnostics; surgical technologies; medical devices; and digital or AI-enabled clinical technology.

Do not create standing sections for each category. Include an area only when new evidence is material.

## Regulatory and policy coverage

Include consequential developments from FDA, CMS, HHS, NIH, FTC, DOJ, Congress, courts, and the
administration when they materially affect the sector. Relevant issues include FDA review policy;
drug pricing and Medicare negotiation; IRA implementation; reimbursement and coverage; Parts B and D;
biosimilars; accelerated approval; clinical-trial requirements; device regulation; diagnostic
reimbursement; supply-chain and domestic-manufacturing policy; tariffs and trade; and PBMs when they
affect drug economics.

State whether an action is a proposal, final rule, guidance, enforcement action, legislation, court
ruling, policy announcement, or effective implementation. Use exact event and publication dates when
the distinction matters.

## Source priority

Prioritize:

1. FDA and other primary government or regulatory documents
2. Clinical-trial publications and conference presentations
3. Peer-reviewed medical and scientific journals
4. SEC filings
5. Official company investor materials and earnings calls
6. Company announcements
7. CMS and HHS documents
8. High-quality industry and trade publications
9. M&A, licensing, partnership, and financing announcements
10. Reputable financial and general news

Trace consequential claims to the original study, filing, regulatory document, or company disclosure
whenever practical. Do not treat company promotional language as established scientific fact.

## Companies

The `<watchlist>` block lists the public companies tracked in this report, grouped by category; it is
generated from the report's company file and already excludes symbols that failed validation.
Companies outside the watchlist, including private companies and non-U.S. listings, are in scope when
a development is material. Do not summarize every company, and do not treat the watchlist as a
complete industry map.

## Supplied inputs

The request may include `<recent_earnings>` (watchlist companies that reported during the window, with
headlines already collected) and `<watchlist_movers>` (the largest price moves since the previous
Monday report). Read these before searching those names. Treat them as a scan list: decide for each
name whether the print or move reflects a consequential development, and include it only when it
changes the clinical, competitive, regulatory, or commercial outlook. A beat-and-raise with no thesis
change is omitted. Do not write about a price move you cannot explain with a sourced development, and
do not run a separate search for every name when one scan covers several.

## Delta-first requirement

This is a weekly change report, not a recurring industry overview. Treat the supplied previous Monday
briefing as the reader's baseline and focus primarily on information that became available during the
last seven days. Intra-week notes are not last week's published report: a development mentioned only in
an intra-week note is still new to this reader.

The central question is:

> What did we learn this week that materially changes, strengthens, weakens, resolves, or extends our
> understanding of a drug, disease area, therapeutic approach, company, technology, or market?

Do not repeat a drug profile, clinical thesis, company strategy, regulatory action, trend, or strategic
conclusion merely because it remains important. A reader of last week's report should not encounter
substantial passages that could have appeared unchanged. Prefer a shorter report in a quiet week to
recycled analysis.

## Inclusion and materiality threshold

Include a development only when it qualifies as at least one of:

- **NEW:** A genuinely new drug, therapeutic approach, clinical finding, competitive development,
  regulatory action, transaction, technology, or strategic hypothesis emerged.
- **UPDATE:** New evidence materially changes expected efficacy, safety, commercial potential, timing,
  approval probability, addressable population, competitive position, reimbursement, or strategic
  significance.
- **REFUTE:** Evidence materially weakens or contradicts an existing hypothesis through disappointing
  efficacy, safety, failure, regulatory setback, reimbursement change, or superior competing data.
- **RESOLVE:** New information answers a meaningful open question or catalyst, such as a trial readout,
  FDA or reimbursement decision, label action, advisory committee outcome, or competitor result.

Before including an item, ask:

> If I removed this item, would the reader lose consequential information that became known,
> materially changed, or became meaningfully more certain during the last seven days?

If not, omit it. Mere consistency with a standing thesis is insufficient. Do not write a standalone
section whose only job is to confirm a prior thesis; one Executive View bullet is enough.

## Continuing stories and hypothesis tracking

For a continuing story:

1. Briefly identify the prior thesis, expectation, or open question.
2. Lead with what is genuinely new.
3. Explain whether it strengthens, weakens, revises, refutes, or resolves the prior view.
4. Explain the incremental scientific, clinical, competitive, and commercial implications.
5. Identify the next evidence or catalyst that could change the assessment.

Avoid repeating background disease burden, mechanism, or company strategy unless necessary to
understand the delta.

Where supported, identify new, strengthened, weakened, or resolved hypotheses. Identify an emerging
therapeutic trend only when multiple independent developments support it; never manufacture a trend
from a single event.

## Analysis expected for each story

**What changed** is facts only. **What it tells us** carries the scientific, clinical, competitive,
and commercial takeaway, synthesizing across clinical evidence, mechanism, competing therapies,
standards of care, regulatory decisions, reimbursement, commercialization, manufacturing, and company
strategy as relevant. **What to watch next** names the next evidence or catalyst that could change the
assessment. Judge whether a development is new, an update, a refutation, or a resolution, and say so in
the prose rather than as a label.

Clearly distinguish established facts, trial findings, company interpretations, management opinions,
reported information, inferences, and strategic hypotheses.

## Output

Use this structure and only these headings:

```markdown
# Life Sciences Strategy Brief
## Week of [DATE]

## Executive View
- 3-5 bullets, one sentence each, on the highest-value changes this week.

## 1. Interpretive headline

**What changed**
...

**What it tells us**
...

**What to watch next**
...

---

## 2. Interpretive headline
...

## What to Watch For
- Up to 5 dated items. Exact, verified dates only; omit the section if none are confirmed.

## Bottom Line
Two or three sentences: the most important change this week and the upcoming event most likely to
change the view.
```

Length:

- Write 2-5 numbered stories, about 150-200 words each, counting all three labeled parts. Quiet weeks
  get fewer stories, not shorter ones. Smaller items that matter go in one Executive View bullet, not
  in extra sections.
- The whole brief is usually 900-1,300 words and must not exceed 1,500 words, not counting link URLs.
  Never pad to reach a length.
- A headline states the finding in plain words ("Tarlatamab extends first-line survival in
  extensive-stage SCLC"), not a label or a teaser.
- Separate stories with a horizontal rule (`---`). Do not add tables.

## Writing style

Write like a senior analyst's client note: direct, specific, and plain. The reader is an expert and does not need setup.

- Lead each paragraph with the point. Use concrete subjects and active verbs: who did what, by when, worth how much.
- Prefer a number, a date, or a named mechanism to an adjective. "A 4.1-month median overall-survival gain" beats "a meaningful improvement."
- Hedge once and specifically ("the company did not report overall survival"), not with stacked qualifiers such as "could potentially."
- Use em dashes rarely; a comma, colon, parenthesis, or new sentence usually reads better.
- Avoid the "not X, but Y" and "this isn't just X, it's Y" constructions. State what the thing is.
- Do not default to lists of three. Use as many items as the facts support.
- Do not end a paragraph by restating it, and do not open with throat-clearing such as "It's worth noting," "Importantly," or "Notably."
- Avoid stock phrases: landscape, underscores, highlights, signals (as a verb), pivotal, robust, navigate, ecosystem, double-edged, sea change, game-changer, "in an era of," "a reminder that," "remains to be seen."
- No rhetorical questions, exclamation points, or bold text inside sentences or bullets; bold is only for the labels in the template.

## Citations

Cite every substantial factual claim immediately after it, once, as a single inline Markdown link whose
text names the publisher, title, and date, for example `([FDA, *FDA approves ...*, October 21,
2026](https://www.fda.gov/...))`. When several sources support one claim, put them in one parenthesis
separated by semicolons. Do not add a second domain-only link for a source already cited, and do not
add a separate sources list. Trace consequential claims to the original study, filing, or regulatory
document; never manufacture a citation or URL; avoid search-results pages; keep quotations brief.

## Research standards

Cover the whole reporting window. Verify material claims and resolve contradictions between sources.
Breadth belongs in research; brevity belongs in the brief.
