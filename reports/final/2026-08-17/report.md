# Healthcare Intel Digest

<div class="report-meta"><span><strong>Week of August 17, 2026</strong></span><span>Market data through: August 14, 2026</span><span>Narrative created: August 17, 2026</span></div>

Weekly review of healthcare services, technology, distribution, and diagnostic company performance, changes, earnings activity, and strategy narrative.

## Strategy Narrative

<nav class="strategy-narrative-links" aria-label="Strategy narrative sections">
<ul>
<li><a href="#strategy-executive-1-prior-authorization-transparency-has-moved-from-theoretical-reputational-risk-to-measurable-payer-differentiation">1. Prior-authorization transparency has moved from theoretical reputational risk to measurable payer differentiation</a></li>
<li><a href="#strategy-executive-2-the-no-surprises-act-ruling-shifts-dollars-toward-providers-and-increases-the-value-of-contract-rate-intelligence">2. The No Surprises Act ruling shifts dollars toward providers and increases the value of contract-rate intelligence</a></li>
<li><a href="#strategy-executive-3-epic-is-turning-interoperability-from-document-exchange-into-workflow-infrastructure">3. Epic is turning interoperability from document exchange into workflow infrastructure</a></li>
<li><a href="#strategy-executive-4-the-administration-is-linking-coverage-policy-coding-analytics-and-fraud-enforcement">4. The administration is linking coverage policy, coding analytics and fraud enforcement</a></li>
</ul>
</nav>

This week produced four developments worth carrying forward. The most consequential is **new empirical prior-authorization data that turns the transparency regime discussed in prior briefs into an actual competitive benchmark**. Separately, the Fifth Circuit materially altered No Surprises Act economics, Epic extended its interoperability platform into diagnostic imaging, and the administration converted a Medicaid coverage policy into a payment-integrity enforcement campaign.

I am intentionally **not** giving Aetna, Humana or UnitedHealth standalone earnings updates this week. Their recent-quarter theses remain largely unchanged, and I found no company-specific disclosure in the last seven days significant enough to justify repeating them. The one exception is UnitedHealth's appearance in the new cross-payer prior-authorization data.

<h3 id="strategy-executive-1-prior-authorization-transparency-has-moved-from-theoretical-reputational-risk-to-measurable-payer-differentiation">1. Prior-authorization transparency has moved from theoretical reputational risk to measurable payer differentiation</h3>

Prior briefs identified CMS's new authorization reporting regime as likely to create external comparisons among insurers. This week, KFF performed essentially that first large-scale comparison using federally required 2025 disclosures across Medicare Advantage, Medicaid managed care and ACA plans. [KFF+1](https://www.kff.org/patient-consumer-protections/prior-authorization-metrics-provide-new-insights-into-insurer-practices-but-gaps-remain/)

**What changed:** The differences are large enough to matter strategically. Standard-request denial rates averaged **12% in Medicare Advantage, 14% in Medicaid managed care and 18% in ACA Marketplace plans**. Within MA, rates among six major insurers ranged from **5% for Elevance to 17% for UnitedHealth Group**. UnitedHealth's reported standard denial rates also varied significantly by business: 17% in MA, 11% in Medicaid managed care and 21% in the ACA Marketplace. [KFF+1](https://www.kff.org/patient-consumer-protections/prior-authorization-metrics-provide-new-insights-into-insurer-practices-but-gaps-remain/)

The more consequential figure may be appeals. **67% of appealed MA authorization denials were eventually overturned**, versus 47% in Medicaid managed care and 43% in the Marketplace. UnitedHealth overturned 81% of appealed Medicaid managed-care denials in KFF's dataset. [KFF](https://www.kff.org/patient-consumer-protections/prior-authorization-metrics-provide-new-insights-into-insurer-practices-but-gaps-remain/)

At the same time, the data weaken a simple “payers are too slow” narrative: median standard decision time was about **one day** across all three markets, materially faster than regulatory maximums. CVS/Aetna, Humana and Kaiser reported MA median standard response times of less than one day. [KFF+1](https://www.kff.org/patient-consumer-protections/prior-authorization-metrics-provide-new-insights-into-insurer-practices-but-gaps-remain/)

**What it tells us:** Our prior thesis needs refinement. **Decision speed is becoming less differentiated than decision quality.** As electronic authorization accelerates, the strategic battleground shifts toward what gets denied, why it gets denied and whether the initial determination survives appeal.

A high overturn rate can reflect missing documentation rather than an incorrect initial decision, and KFF warns that current reporting lacks enough service-level detail to separate those explanations. But that limitation itself identifies the next technology opportunity: payer systems need to connect **coverage requirements → submitted evidence → initial decision → additional documentation → appeal outcome**. [KFF](https://www.kff.org/patient-consumer-protections/prior-authorization-metrics-provide-new-insights-into-insurer-practices-but-gaps-remain/)

**Strategic implication:** Payment Integrity, UM and EDI increasingly share the same KPI: **first-pass decision accuracy**. A system that makes an authorization decision in minutes but creates appeals and provider rework has automated latency without solving administrative cost.

**Watch next:** CMS reporting enhancements requiring numeric volumes and more standardized metrics would dramatically increase benchmarking value. Also watch whether health systems and employer groups begin using insurer-level denial and overturn data in contracting.

---

<h3 id="strategy-executive-2-the-no-surprises-act-ruling-shifts-dollars-toward-providers-and-increases-the-value-of-contract-rate-intelligence">2. The No Surprises Act ruling shifts dollars toward providers and increases the value of contract-rate intelligence</h3>

On August 11, the en banc Fifth Circuit invalidated key elements of the federal methodology for calculating the No Surprises Act's **Qualifying Payment Amount (QPA)**. The court ruled that insurers may not incorporate “ghost rates”—contracted prices for services a provider does not actually perform—and must include bonus and incentive payments when calculating the benchmark. It allowed insurers to continue excluding one-off agreements such as individual air-ambulance arrangements. [Reuters+1](https://www.reuters.com/legal/litigation/us-appeals-court-voids-formula-used-avert-surprise-medical-bills-2026-08-12/)

**Why it matters:** This is a substantive payer/provider financial delta rather than another procedural NSA lawsuit. QPAs influence the independent dispute-resolution process for out-of-network claims; removing artificially low contractual rates and adding incentive payments should generally push the relevant benchmark upward. The ruling therefore favors providers economically and weakens one lever insurers have used to constrain out-of-network reimbursement. [Reuters](https://www.reuters.com/legal/litigation/us-appeals-court-voids-formula-used-avert-surprise-medical-bills-2026-08-12/)

The magnitude could be meaningful. CMS recently said arbitration awards grew from **$4.1 billion in 2024 to $14.9 billion in 2025**, while arguing that parts of the dispute process were being gamed. [Reuters](https://www.reuters.com/legal/litigation/us-appeals-court-voids-formula-used-avert-surprise-medical-bills-2026-08-12/)

**What it tells us:** Contract intelligence is becoming a more strategic capability on both sides. Payers need defensible QPA construction and stronger visibility into actual contracted-rate distributions; providers need sufficient reimbursement analytics to identify claims where arbitration has positive expected value.

This also intersects with payment integrity. As out-of-network settlements become more valuable, payers have greater incentive to scrutinize eligibility, coding, bundling and documentation surrounding disputed claims—while providers have greater incentive to automate identification and pursuit of underpayments.

**Watch next:** Federal agency guidance is the immediate catalyst. The court specifically noted that agencies can use enforcement discretion while replacing the methodology, so operational disruption may be limited initially. The new formula—and whether litigation follows it—will determine the longer-run economics. [Reuters](https://www.reuters.com/legal/litigation/us-appeals-court-voids-formula-used-avert-surprise-medical-bills-2026-08-12/)

---

<h3 id="strategy-executive-3-epic-is-turning-interoperability-from-document-exchange-into-workflow-infrastructure">3. Epic is turning interoperability from document exchange into workflow infrastructure</h3>

On August 13, Epic made **Care Everywhere Diagnostic Image Exchange** broadly available, allowing clinicians to retrieve full diagnostic-quality CTs, MRIs, X-rays and other images from participating Epic health systems with one click. Previously, Epic could exchange radiology reports and lower-resolution reference images; full diagnostic images frequently required separate retrieval processes or physical media. [Epic](https://www.epic.com/epic/post/diagnostic-image-exchange-helps-clinicians-and-patients-get-answers-sooner/)

**Why it matters:** Last week's brief argued that the strategic value in health technology is increasingly accruing to platforms controlling shared infrastructure and adjacent workflows. Epic's move strengthens that thesis.

Diagnostic imaging has historically sat partly outside the EHR in PACS and image-archive systems. Epic is now using its installed interoperability network and open image-sharing standards to bridge those systems directly. Epic says its existing duplicate-order checks already prevent more than **21,000 repeat scans annually**; direct image access potentially extends that benefit. [Epic](https://www.epic.com/epic/post/diagnostic-image-exchange-helps-clinicians-and-patients-get-answers-sooner/)

**What it tells us:** Epic's moat is expanding beyond the medical record itself toward the **network connecting clinical organizations**. Every workflow that migrates into Care Everywhere makes the installed ecosystem more useful and potentially reduces the role of standalone exchange vendors.

For payers, there is an indirect but important implication. As richer clinical evidence becomes electronically portable, imaging increasingly becomes available to authorization, quality and payment-integrity workflows without bespoke medical-record retrieval.

**Watch next:** Epic is advocating inclusion of open image-sharing standards within TEFCA. If diagnostic imaging becomes a routine national exchange capability rather than an Epic-to-Epic feature, the bigger opportunity shifts toward software that can interpret and operationalize the images and associated metadata. [Epic](https://www.epic.com/epic/post/diagnostic-image-exchange-helps-clinicians-and-patients-get-answers-sooner/)

---

<h3 id="strategy-executive-4-the-administration-is-linking-coverage-policy-coding-analytics-and-fraud-enforcement">4. The administration is linking coverage policy, coding analytics and fraud enforcement</h3>

CMS finalized a rule on August 11 ending federal Medicaid and CHIP funding for specified gender-transition procedures for minors, effective **October 13, 2026**, with a limited six-month transition for certain existing hormone-therapy patients. The policy applies to federal matching funds rather than prohibiting states from financing care themselves. [Centers for Medicare & Medicaid Services+1](https://www.cms.gov/newsroom/press-releases/cms-ends-federal-medicaid-chip-funding-sex-rejecting-procedures-children-youth)

Two days later, HHS escalated the issue from coverage policy to payment integrity. It referred more than 200 hospitals, physician groups, pharmacies, PBMs and other organizations to federal investigators after alleging anomalous billing patterns, including use of endocrine or other diagnosis codes in claims associated with gender-related treatment. HHS cited roughly $120 million in related billing since 2019; targeted providers and advocates dispute the administration's underlying characterization of this care, and investigations have not established fraud. [Reuters+1](https://www.reuters.com/legal/litigation/trump-administration-accuses-hospitals-improper-billing-over-gender-care-minors-2026-08-13/?utm_source=chatgpt.com)

**What it tells us:** Whatever one's view of the underlying clinical policy, the operational lesson for payers and providers is significant: **the administration is willing to use claims analytics to convert a policy priority into targeted coding and payment investigations.**

That strengthens the broader thesis from recent Medicaid Fraud War Room activity: diagnosis-code integrity, clinical indication and coverage policy are becoming tightly coupled enforcement domains.

For providers, coding governance therefore needs to answer not only “does this code support reimbursement?” but “does the longitudinal clinical record support why this code was selected?” For Medicaid plans and PBMs, new exclusions also require benefit configuration, edits and clinical-policy changes before October 13. [Centers for Medicare & Medicaid Services](https://www.cms.gov/newsroom/press-releases/cms-ends-federal-medicaid-chip-funding-sex-rejecting-procedures-children-youth)

**Watch next:** Legal challenges are highly likely to determine the policy's durability. Separately, watch whether OIG/DOJ investigations substantiate the billing allegations. That distinction matters: a policy disagreement becoming an investigation is not the same as evidence ultimately demonstrating improper claims.

---

<h3 id="strategic-synthesis">Strategic synthesis</h3>

The strongest new inference this week is that **transparency is beginning to change the value of automation**.

Until now, payer automation could be evaluated primarily internally: faster decisions, lower administrative cost, more savings. The new prior-authorization disclosures allow outsiders to observe outputs—denial rates, response times and overturned decisions. The NSA decision increases financial consequences when payer reimbursement methodology is successfully challenged. Meanwhile, federal investigators are using claims data to scrutinize diagnosis selection.

That shifts competitive advantage from **“automate more decisions”** toward **“make automated decisions that remain defensible when someone else can inspect the outcome.”**

For Payment Integrity, Risk, Quality and EDI, that means evidence provenance, explainability, consistent policy logic and appeal feedback loops are moving from compliance features toward core product capabilities.

On the provider side, Epic's image exchange illustrates the complementary trend: the data needed to support those decisions are becoming easier to move.

Taken together, the architecture becoming more valuable is not merely:

**data → AI → decision**

but:

**clinical evidence → policy → decision → external scrutiny → outcome → feedback into the next decision.**

That is the incremental strategic thesis I would carry into next week.

## Notable Changes

Comparison with the final report dated August 10, 2026 (market data through August 7, 2026).

### Sectors

#### Top-three comparison

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Entity</th><th class="sortable-heading" data-column="1" data-type="number">Previous</th><th class="sortable-heading" data-column="2" data-type="number">Current</th><th class="sortable-heading" data-column="3" data-type="number">Change</th><th class="sortable-heading" data-column="4" data-type="number">Current return</th></tr></thead><tbody><tr><td class="text" data-sort="precision diagnostics" style=""><a href="#category-precision-diagnostics">Precision Diagnostics</a></td><td class="" data-sort="2" style="">#2</td><td class="" data-sort="1" style="">#1</td><td class="rank-change-up" data-sort="-1" style="">↑ 1</td><td class="" data-sort="0.806611434939" style="background:#1a7a3c;color:#ffffff;">+80.7%</td></tr><tr><td class="text" data-sort="value-based care" style=""><a href="#category-value-based-care">Value-Based Care</a></td><td class="" data-sort="1" style="">#1</td><td class="" data-sort="2" style="">#2</td><td class="rank-change-down" data-sort="1" style="">↓ 1</td><td class="" data-sort="0.806406698893" style="background:#1a7a3c;color:#ffffff;">+80.6%</td></tr><tr><td class="text" data-sort="inpatient non-acute providers" style=""><a href="#category-inpatient-non-acute-providers">Inpatient Non-Acute Providers</a></td><td class="" data-sort="3" style="">#3</td><td class="" data-sort="3" style="">#3</td><td class="" data-sort="0" style="">— 0</td><td class="" data-sort="0.744697156406" style="background:#1a7a3c;color:#ffffff;">+74.5%</td></tr></tbody></table></div>


### Stocks

#### Top-three comparison

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Entity</th><th class="sortable-heading" data-column="1" data-type="number">Previous</th><th class="sortable-heading" data-column="2" data-type="number">Current</th><th class="sortable-heading" data-column="3" data-type="number">Change</th><th class="sortable-heading" data-column="4" data-type="number">Current return</th></tr></thead><tbody><tr><td class="text" data-sort="10x genomics" style="">10x Genomics (<a href="#company-txg">TXG</a>)</td><td class="" data-sort="3" style="">#3</td><td class="" data-sort="1" style="">#1</td><td class="rank-change-up" data-sort="-2" style="">↑ 2</td><td class="" data-sort="3.19835329341" style="background:#1a7a3c;color:#ffffff;">+319.8%</td></tr><tr><td class="text" data-sort="pacs group" style="">PACS Group (<a href="#company-pacs">PACS</a>)</td><td class="" data-sort="2" style="">#2</td><td class="" data-sort="2" style="">#2</td><td class="" data-sort="0" style="">— 0</td><td class="" data-sort="2.86434782609" style="background:#1a7a3c;color:#ffffff;">+286.4%</td></tr><tr><td class="text" data-sort="agilon health" style="">Agilon Health (<a href="#company-agl">AGL</a>)</td><td class="" data-sort="1" style="">#1</td><td class="" data-sort="3" style="">#3</td><td class="rank-change-down" data-sort="2" style="">↓ 2</td><td class="" data-sort="2.49189189189" style="background:#2f9e44;color:#111820;">+249.2%</td></tr></tbody></table></div>


#### Largest rank changes

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Entity</th><th class="sortable-heading" data-column="1" data-type="number">Previous</th><th class="sortable-heading" data-column="2" data-type="number">Current</th><th class="sortable-heading" data-column="3" data-type="number">Change</th><th class="sortable-heading" data-column="4" data-type="number">Current return</th></tr></thead><tbody><tr><td class="text" data-sort="astrana health" style="">Astrana Health (<a href="#company-asth">ASTH</a>)</td><td class="" data-sort="34" style="">#34</td><td class="" data-sort="25" style="">#25</td><td class="rank-change-up" data-sort="-9" style="">↑ 9</td><td class="" data-sort="0.391408114558" style="background:#1a7a3c;color:#ffffff;">+39.1%</td></tr><tr><td class="text" data-sort="unitedhealth" style="">UnitedHealth (<a href="#company-unh">UNH</a>)</td><td class="" data-sort="17" style="">#17</td><td class="" data-sort="30" style="">#30</td><td class="rank-change-down" data-sort="13" style="">↓ 13</td><td class="" data-sort="0.321436794842" style="background:#1a7a3c;color:#ffffff;">+32.1%</td></tr><tr><td class="text" data-sort="solventum" style="">Solventum (<a href="#company-solv">SOLV</a>)</td><td class="" data-sort="46" style="">#46</td><td class="" data-sort="35" style="">#35</td><td class="rank-change-up" data-sort="-11" style="">↑ 11</td><td class="" data-sort="0.240408849062" style="background:#2f9e44;color:#111820;">+24.0%</td></tr></tbody></table></div>


### Subcategory movement since the previous report

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Subcategory</th><th class="sortable-heading" data-column="1" data-type="number">Move</th><th class="sortable-heading" data-column="2" data-type="number">Last Report, 12m Ret</th><th class="sortable-heading" data-column="3" data-type="number">Current Report, 12m Ret</th></tr></thead><tbody><tr><td class="text" data-sort="health it and data" style=""><a href="#category-health-it-and-data">Health IT and Data</a></td><td class="" data-sort="0.14529637693820402" style="background:#1a7a3c;color:#ffffff;">+14.5%</td><td class="" data-sort="-0.316780857156" style="background:#f5aead;color:#111820;">-31.7%</td><td class="" data-sort="-0.303148912292" style="background:#f5aead;color:#111820;">-30.3%</td></tr><tr><td class="text" data-sort="value-based care" style=""><a href="#category-value-based-care">Value-Based Care</a></td><td class="" data-sort="0.04879338734059127" style="background:#a9d9a4;color:#111820;">+4.9%</td><td class="" data-sort="1.05235726491" style="background:#1a7a3c;color:#ffffff;">+105.2%</td><td class="" data-sort="0.806406698893" style="background:#1a7a3c;color:#ffffff;">+80.6%</td></tr><tr><td class="text" data-sort="inpatient non-acute providers" style=""><a href="#category-inpatient-non-acute-providers">Inpatient Non-Acute Providers</a></td><td class="" data-sort="0.04165026400878604" style="background:#a9d9a4;color:#111820;">+4.2%</td><td class="" data-sort="0.900251012903" style="background:#1a7a3c;color:#ffffff;">+90.0%</td><td class="" data-sort="0.744697156406" style="background:#1a7a3c;color:#ffffff;">+74.5%</td></tr><tr><td class="text" data-sort="digital health, specialty, benefits" style=""><a href="#category-digital-health-specialty-benefits">Digital Health, Specialty, Benefits</a></td><td class="" data-sort="0.0403270128263293" style="background:#a9d9a4;color:#111820;">+4.0%</td><td class="" data-sort="0.10782356663" style="background:#d6ecd4;color:#111820;">+10.8%</td><td class="" data-sort="0.091407915079" style="background:#d6ecd4;color:#111820;">+9.1%</td></tr><tr><td class="text" data-sort="precision diagnostics" style=""><a href="#category-precision-diagnostics">Precision Diagnostics</a></td><td class="" data-sort="0.02811909868930254" style="background:#d6ecd4;color:#111820;">+2.8%</td><td class="" data-sort="0.9562101026" style="background:#1a7a3c;color:#ffffff;">+95.6%</td><td class="" data-sort="0.806611434939" style="background:#1a7a3c;color:#ffffff;">+80.7%</td></tr><tr><td class="text" data-sort="pharma distribution" style=""><a href="#category-pharma-distribution">Pharma Distribution</a></td><td class="" data-sort="0.01440231574872148" style="background:#d6ecd4;color:#111820;">+1.4%</td><td class="" data-sort="0.301601906138" style="background:#a9d9a4;color:#111820;">+30.2%</td><td class="" data-sort="0.300068673074" style="background:#a9d9a4;color:#111820;">+30.0%</td></tr><tr><td class="text" data-sort="health system providers" style=""><a href="#category-health-system-providers">Health System Providers</a></td><td class="" data-sort="0.013941480139320356" style="background:#d6ecd4;color:#111820;">+1.4%</td><td class="" data-sort="0.161300007794" style="background:#d6ecd4;color:#111820;">+16.1%</td><td class="" data-sort="0.106456369394" style="background:#d6ecd4;color:#111820;">+10.6%</td></tr><tr><td class="text" data-sort="payers" style=""><a href="#category-payers">Payers</a></td><td class="" data-sort="-0.010119278506951658" style="background:#fbd5d4;color:#111820;">-1.0%</td><td class="" data-sort="0.531294337324" style="background:#7cc077;color:#111820;">+53.1%</td><td class="" data-sort="0.351948184652" style="background:#7cc077;color:#111820;">+35.2%</td></tr><tr><td class="text" data-sort="health care real estate" style=""><a href="#category-health-care-real-estate">Health Care Real Estate</a></td><td class="" data-sort="-0.013455785022063441" style="background:#fbd5d4;color:#111820;">-1.3%</td><td class="" data-sort="0.364251877603" style="background:#a9d9a4;color:#111820;">+36.4%</td><td class="" data-sort="0.372038086192" style="background:#7cc077;color:#111820;">+37.2%</td></tr><tr><td class="text" data-sort="outpatient and home providers" style=""><a href="#category-outpatient-and-home-providers">Outpatient and Home Providers</a></td><td class="" data-sort="-0.045829542924277156" style="background:#f5aead;color:#111820;">-4.6%</td><td class="" data-sort="0.616279890136" style="background:#7cc077;color:#111820;">+61.6%</td><td class="" data-sort="0.518902426763" style="background:#2f9e44;color:#111820;">+51.9%</td></tr></tbody></table></div>


### Largest company moves

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Direction</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Move</th></tr></thead><tbody><tr><td class="text" data-sort="0" style="">Gain</td><td class="text" data-sort="evolent health" style="">Evolent Health</td><td class="text text" data-sort="evh" style=""><a href="#company-evh">EVH</a></td><td class="" data-sort="0.5145631067961165" style="background:#1a7a3c;color:#ffffff;">+51.5%</td></tr><tr><td class="text" data-sort="0" style="">Gain</td><td class="text" data-sort="aveanna healthcare" style=""><a href="#earnings-avah">Aveanna Healthcare</a></td><td class="text text" data-sort="avah" style=""><a href="#company-avah">AVAH</a></td><td class="" data-sort="0.31203407880724177" style="background:#2f9e44;color:#111820;">+31.2%</td></tr><tr><td class="text" data-sort="0" style="">Gain</td><td class="text" data-sort="goodrx" style="">GoodRx</td><td class="text text" data-sort="gdrx" style=""><a href="#company-gdrx">GDRX</a></td><td class="" data-sort="0.21498371335504896" style="background:#7cc077;color:#111820;">+21.5%</td></tr><tr><td class="text" data-sort="1" style="">Decline</td><td class="text" data-sort="accendra health" style="">Accendra Health</td><td class="text text" data-sort="ahco" style=""><a href="#company-ahco">AHCO</a></td><td class="" data-sort="-0.46203703703703713" style="background:#c0302f;color:#ffffff;">-46.2%</td></tr><tr><td class="text" data-sort="1" style="">Decline</td><td class="text" data-sort="billiontoone" style="">BillionToOne</td><td class="text text" data-sort="blln" style=""><a href="#company-blln">BLLN</a></td><td class="" data-sort="-0.3266233766233766" style="background:#e34948;color:#111820;">-32.7%</td></tr><tr><td class="text" data-sort="1" style="">Decline</td><td class="text" data-sort="davita" style="">Davita</td><td class="text text" data-sort="dva" style=""><a href="#company-dva">DVA</a></td><td class="" data-sort="-0.2500312382856429" style="background:#ee8483;color:#111820;">-25.0%</td></tr></tbody></table></div>


## Subcategory Performance

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Subcategory</th><th class="sortable-heading" data-column="1" data-type="number">Companies</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="payers" style=""><a href="#category-payers">Payers</a></td><td class="" data-sort="10" style="">10</td><td class="" data-sort="769783972395.0" style="">$769.8B</td><td class="" data-sort="0.0426670980521" style="background:#d6ecd4;color:#111820;">+4.3%</td><td class="" data-sort="0.351948184652" style="background:#7cc077;color:#111820;">+35.2%</td><td class="" data-sort="-0.0692561963074" style="background:#fbd5d4;color:#111820;">-6.9%</td></tr><tr><td class="text" data-sort="health system providers" style=""><a href="#category-health-system-providers">Health System Providers</a></td><td class="" data-sort="5" style="">5</td><td class="" data-sort="119831113197.0" style="">$119.8B</td><td class="" data-sort="0.0324636421947" style="background:#d6ecd4;color:#111820;">+3.2%</td><td class="" data-sort="0.106456369394" style="background:#d6ecd4;color:#111820;">+10.6%</td><td class="" data-sort="0.154536781621" style="background:#d6ecd4;color:#111820;">+15.5%</td></tr><tr><td class="text" data-sort="inpatient non-acute providers" style=""><a href="#category-inpatient-non-acute-providers">Inpatient Non-Acute Providers</a></td><td class="" data-sort="4" style="">4</td><td class="" data-sort="31441382422.3" style="">$31.4B</td><td class="" data-sort="0.123166111549" style="background:#a9d9a4;color:#111820;">+12.3%</td><td class="" data-sort="0.744697156406" style="background:#1a7a3c;color:#ffffff;">+74.5%</td><td class="" data-sort="0.21507869941" style="background:#d6ecd4;color:#111820;">+21.5%</td></tr><tr><td class="text" data-sort="health care real estate" style=""><a href="#category-health-care-real-estate">Health Care Real Estate</a></td><td class="" data-sort="8" style="">8</td><td class="" data-sort="266432919584.0" style="">$266.4B</td><td class="" data-sort="0.070882384272" style="background:#d6ecd4;color:#111820;">+7.1%</td><td class="" data-sort="0.372038086192" style="background:#7cc077;color:#111820;">+37.2%</td><td class="" data-sort="0.787393680745" style="background:#2f9e44;color:#111820;">+78.7%</td></tr><tr><td class="text" data-sort="value-based care" style=""><a href="#category-value-based-care">Value-Based Care</a></td><td class="" data-sort="5" style="">5</td><td class="" data-sort="7199786717.83" style="">$7.2B</td><td class="" data-sort="0.0611654291943" style="background:#d6ecd4;color:#111820;">+6.1%</td><td class="" data-sort="0.806406698893" style="background:#1a7a3c;color:#ffffff;">+80.6%</td><td class="" data-sort="-0.0947416879046" style="background:#fbd5d4;color:#111820;">-9.5%</td></tr><tr><td class="text" data-sort="outpatient and home providers" style=""><a href="#category-outpatient-and-home-providers">Outpatient and Home Providers</a></td><td class="" data-sort="11" style="">11</td><td class="" data-sort="64788787758.1" style="">$64.8B</td><td class="" data-sort="0.123379759069" style="background:#a9d9a4;color:#111820;">+12.3%</td><td class="" data-sort="0.518902426763" style="background:#2f9e44;color:#111820;">+51.9%</td><td class="" data-sort="0.979466509081" style="background:#2f9e44;color:#111820;">+97.9%</td></tr><tr><td class="text" data-sort="digital health, specialty, benefits" style=""><a href="#category-digital-health-specialty-benefits">Digital Health, Specialty, Benefits</a></td><td class="" data-sort="10" style="">10</td><td class="" data-sort="26312964338.3" style="">$26.3B</td><td class="" data-sort="0.238011985332" style="background:#7cc077;color:#111820;">+23.8%</td><td class="" data-sort="0.091407915079" style="background:#d6ecd4;color:#111820;">+9.1%</td><td class="" data-sort="0.499253980766" style="background:#a9d9a4;color:#111820;">+49.9%</td></tr><tr><td class="text" data-sort="health it and data" style=""><a href="#category-health-it-and-data">Health IT and Data</a></td><td class="" data-sort="12" style="">12</td><td class="" data-sort="470568402022.0" style="">$470.6B</td><td class="" data-sort="-0.0922876267273" style="background:#fbd5d4;color:#111820;">-9.2%</td><td class="" data-sort="-0.303148912292" style="background:#f5aead;color:#111820;">-30.3%</td><td class="" data-sort="0.104340175233" style="background:#d6ecd4;color:#111820;">+10.4%</td></tr><tr><td class="text" data-sort="pharma distribution" style=""><a href="#category-pharma-distribution">Pharma Distribution</a></td><td class="" data-sort="5" style="">5</td><td class="" data-sort="222577856249.0" style="">$222.6B</td><td class="" data-sort="0.179712911409" style="background:#a9d9a4;color:#111820;">+18.0%</td><td class="" data-sort="0.300068673074" style="background:#a9d9a4;color:#111820;">+30.0%</td><td class="" data-sort="0.632957569658" style="background:#7cc077;color:#111820;">+63.3%</td></tr><tr><td class="text" data-sort="precision diagnostics" style=""><a href="#category-precision-diagnostics">Precision Diagnostics</a></td><td class="" data-sort="12" style="">12</td><td class="" data-sort="168611092169.0" style="">$168.6B</td><td class="" data-sort="0.473482583224" style="background:#1a7a3c;color:#ffffff;">+47.3%</td><td class="" data-sort="0.806611434939" style="background:#1a7a3c;color:#ffffff;">+80.7%</td><td class="" data-sort="1.26603374331" style="background:#1a7a3c;color:#ffffff;">+126.6%</td></tr></tbody></table></div>

Subcategory returns use the most recently saved market capitalizations as weights.

## Stock Performance vs. SPY

The same selected stocks appear in every chart. Each line is labeled at the right with its ticker and return for the displayed window.
### Last 6 months

![6-month indexed performance](assets/performance-6m.webp)

### Last 12 months

![12-month indexed performance](assets/performance-12m.webp)

### Last 24 months

![24-month indexed performance](assets/performance-24m.webp)


## Current Top Stocks

### Last 3 months

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="number">Rank</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">Return</th></tr></thead><tbody><tr><td class="" data-sort="1" style="">1</td><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="1.64575471698" style="background:#1a7a3c;color:#ffffff;">+164.6%</td></tr><tr><td class="" data-sort="2" style="">2</td><td class="text" data-sort="neogenomics" style="">NeoGenomics</td><td class="text text" data-sort="neo" style=""><a href="#company-neo">NEO</a></td><td class="" data-sort="2092864917.6" style="">$2.1B</td><td class="" data-sort="0.934466019417" style="background:#7cc077;color:#111820;">+93.4%</td></tr><tr><td class="" data-sort="3" style="">3</td><td class="text" data-sort="certara" style="">Certara</td><td class="text text" data-sort="cert" style=""><a href="#company-cert">CERT</a></td><td class="" data-sort="1189802484.0" style="">$1.2B</td><td class="" data-sort="0.785714285714" style="background:#7cc077;color:#111820;">+78.6%</td></tr><tr><td class="" data-sort="4" style="">4</td><td class="text" data-sort="natera" style="">Natera</td><td class="text text" data-sort="ntra" style=""><a href="#company-ntra">NTRA</a></td><td class="" data-sort="39411440972.6" style="">$39.4B</td><td class="" data-sort="0.663071474565" style="background:#7cc077;color:#111820;">+66.3%</td></tr><tr><td class="" data-sort="5" style="">5</td><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="0.656236831016" style="background:#a9d9a4;color:#111820;">+65.6%</td></tr></tbody></table></div>

### Last 12 months

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="number">Rank</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">Return</th></tr></thead><tbody><tr><td class="" data-sort="1" style="">1</td><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="3.19835329341" style="background:#1a7a3c;color:#ffffff;">+319.8%</td></tr><tr><td class="" data-sort="2" style="">2</td><td class="text" data-sort="pacs group" style="">PACS Group</td><td class="text text" data-sort="pacs" style=""><a href="#company-pacs">PACS</a></td><td class="" data-sort="7282112019.76" style="">$7.3B</td><td class="" data-sort="2.86434782609" style="background:#1a7a3c;color:#ffffff;">+286.4%</td></tr><tr><td class="" data-sort="3" style="">3</td><td class="text" data-sort="agilon health" style="">Agilon Health</td><td class="text text" data-sort="agl" style=""><a href="#company-agl">AGL</a></td><td class="" data-sort="2073627800.0" style="">$2.1B</td><td class="" data-sort="2.49189189189" style="background:#2f9e44;color:#111820;">+249.2%</td></tr><tr><td class="" data-sort="4" style="">4</td><td class="text" data-sort="brightspring health services" style="">BrightSpring Health Services</td><td class="text text" data-sort="btsg" style=""><a href="#company-btsg">BTSG</a></td><td class="" data-sort="12419938407.6" style="">$12.4B</td><td class="" data-sort="1.75" style="background:#7cc077;color:#111820;">+175.0%</td></tr><tr><td class="" data-sort="5" style="">5</td><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="1.67000679348" style="background:#7cc077;color:#111820;">+167.0%</td></tr></tbody></table></div>

### Last 24 months

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="number">Rank</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">Return</th></tr></thead><tbody><tr><td class="" data-sort="1" style="">1</td><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="4.62468694097" style="background:#1a7a3c;color:#ffffff;">+462.5%</td></tr><tr><td class="" data-sort="2" style="">2</td><td class="text" data-sort="brightspring health services" style="">BrightSpring Health Services</td><td class="text text" data-sort="btsg" style=""><a href="#company-btsg">BTSG</a></td><td class="" data-sort="12419938407.6" style="">$12.4B</td><td class="" data-sort="4.13821815154" style="background:#1a7a3c;color:#ffffff;">+413.8%</td></tr><tr><td class="" data-sort="3" style="">3</td><td class="text" data-sort="talkspace" style="">Talkspace</td><td class="text text" data-sort="talk" style=""><a href="#company-talk">TALK</a></td><td class="" data-sort="874415594.52" style="">$874.4M</td><td class="" data-sort="1.98295454545" style="background:#7cc077;color:#111820;">+198.3%</td></tr><tr><td class="" data-sort="4" style="">4</td><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="1.57885057471" style="background:#a9d9a4;color:#111820;">+157.9%</td></tr><tr><td class="" data-sort="5" style="">5</td><td class="text" data-sort="natera" style="">Natera</td><td class="text text" data-sort="ntra" style=""><a href="#company-ntra">NTRA</a></td><td class="" data-sort="39411440972.6" style="">$39.4B</td><td class="" data-sort="1.49983868366" style="background:#a9d9a4;color:#111820;">+150.0%</td></tr></tbody></table></div>


## Companies by Subcategory

<h3 id="category-payers"><a href="#subcategory-performance">Payers</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +4.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="unitedhealth" style="">UnitedHealth</td><td class="text text" data-sort="unh" style=""><a href="#company-unh">UNH</a></td><td class="" data-sort="380076600000.0" style="">$380.1B</td><td class="" data-sort="0.0200076171131" style="background:#d6ecd4;color:#111820;">+2.0%</td><td class="" data-sort="0.321436794842" style="background:#a9d9a4;color:#111820;">+32.1%</td><td class="" data-sort="-0.304580390528" style="background:#ee8483;color:#111820;">-30.5%</td></tr><tr><td class="text" data-sort="cvs health" style="">CVS Health</td><td class="text text" data-sort="cvs" style=""><a href="#company-cvs">CVS</a></td><td class="" data-sort="135133460000.0" style="">$135.1B</td><td class="" data-sort="0.0132443424758" style="background:#d6ecd4;color:#111820;">+1.3%</td><td class="" data-sort="0.416326530612" style="background:#a9d9a4;color:#111820;">+41.6%</td><td class="" data-sort="0.665124250214" style="background:#1a7a3c;color:#ffffff;">+66.5%</td></tr><tr><td class="text" data-sort="humana" style="">Humana</td><td class="text text" data-sort="hum" style=""><a href="#company-hum">HUM</a></td><td class="" data-sort="43692420868.9" style="">$43.7B</td><td class="" data-sort="0.275072102779" style="background:#2f9e44;color:#111820;">+27.5%</td><td class="" data-sort="0.35846223681" style="background:#a9d9a4;color:#111820;">+35.8%</td><td class="" data-sort="0.110429272748" style="background:#d6ecd4;color:#111820;">+11.0%</td></tr><tr><td class="text" data-sort="oscar health" style="">Oscar Health</td><td class="text text" data-sort="oscr" style=""><a href="#company-oscr">OSCR</a></td><td class="" data-sort="9412611460.0" style="">$9.4B</td><td class="" data-sort="0.404802744425" style="background:#1a7a3c;color:#ffffff;">+40.5%</td><td class="" data-sort="1.09462915601" style="background:#1a7a3c;color:#ffffff;">+109.5%</td><td class="" data-sort="0.751871657754" style="background:#1a7a3c;color:#ffffff;">+75.2%</td></tr><tr><td class="text" data-sort="molina healthcare" style="">Molina Healthcare</td><td class="text text" data-sort="moh" style=""><a href="#company-moh">MOH</a></td><td class="" data-sort="10211364000.0" style="">$10.2B</td><td class="" data-sort="0.148332342289" style="background:#a9d9a4;color:#111820;">+14.8%</td><td class="" data-sort="0.26831452624" style="background:#d6ecd4;color:#111820;">+26.8%</td><td class="" data-sort="-0.393005114724" style="background:#ee8483;color:#111820;">-39.3%</td></tr><tr><td class="text" data-sort="cigna" style="">Cigna</td><td class="text text" data-sort="ci" style=""><a href="#company-ci">CI</a></td><td class="" data-sort="73736307618.3" style="">$73.7B</td><td class="" data-sort="-0.00949977214569" style="background:#fbd5d4;color:#111820;">-0.9%</td><td class="" data-sort="-0.0481708549485" style="background:#fbd5d4;color:#111820;">-4.8%</td><td class="" data-sort="-0.174573498481" style="background:#f5aead;color:#111820;">-17.5%</td></tr><tr><td class="text" data-sort="elevance" style="">Elevance</td><td class="text text" data-sort="elv" style=""><a href="#company-elv">ELV</a></td><td class="" data-sort="81508153953.6" style="">$81.5B</td><td class="" data-sort="0.0194560456351" style="background:#d6ecd4;color:#111820;">+1.9%</td><td class="" data-sort="0.293148560907" style="background:#a9d9a4;color:#111820;">+29.3%</td><td class="" data-sort="-0.263711605665" style="background:#f5aead;color:#111820;">-26.4%</td></tr><tr><td class="text" data-sort="clover health" style="">Clover Health</td><td class="text text" data-sort="clov" style=""><a href="#company-clov">CLOV</a></td><td class="" data-sort="2196273631.08" style="">$2.2B</td><td class="" data-sort="0.325648414986" style="background:#1a7a3c;color:#ffffff;">+32.6%</td><td class="" data-sort="0.735849056604" style="background:#7cc077;color:#111820;">+73.6%</td><td class="" data-sort="0.625441696113" style="background:#1a7a3c;color:#ffffff;">+62.5%</td></tr><tr><td class="text" data-sort="centene" style="">Centene</td><td class="text text" data-sort="cnc" style=""><a href="#company-cnc">CNC</a></td><td class="" data-sort="30736368900.0" style="">$30.7B</td><td class="" data-sort="0.157885704479" style="background:#a9d9a4;color:#111820;">+15.8%</td><td class="" data-sort="1.3681993682" style="background:#1a7a3c;color:#ffffff;">+136.8%</td><td class="" data-sort="-0.136218153886" style="background:#fbd5d4;color:#111820;">-13.6%</td></tr><tr><td class="text" data-sort="alignment health" style="">Alignment Health</td><td class="text text" data-sort="alhc" style=""><a href="#company-alhc">ALHC</a></td><td class="" data-sort="3080411962.65" style="">$3.1B</td><td class="" data-sort="-0.112523839797" style="background:#f5aead;color:#111820;">-11.3%</td><td class="" data-sort="-0.0724252491694" style="background:#fbd5d4;color:#111820;">-7.2%</td><td class="" data-sort="0.604597701149" style="background:#1a7a3c;color:#ffffff;">+60.5%</td></tr></tbody></table></div>

<h3 id="category-health-system-providers"><a href="#subcategory-performance">Health System Providers</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +3.2%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="hca healthcare" style="">HCA Healthcare</td><td class="text text" data-sort="hca" style=""><a href="#company-hca">HCA</a></td><td class="" data-sort="87161338885.0" style="">$87.2B</td><td class="" data-sort="-0.0433096926714" style="background:#fbd5d4;color:#111820;">-4.3%</td><td class="" data-sort="0.0224614063013" style="background:#d6ecd4;color:#111820;">+2.2%</td><td class="" data-sort="0.0826979158306" style="background:#d6ecd4;color:#111820;">+8.3%</td></tr><tr><td class="text" data-sort="tenet health" style="">Tenet Health</td><td class="text text" data-sort="thc" style=""><a href="#company-thc">THC</a></td><td class="" data-sort="20514630820.0" style="">$20.5B</td><td class="" data-sort="0.362249567782" style="background:#1a7a3c;color:#ffffff;">+36.2%</td><td class="" data-sort="0.55737704918" style="background:#1a7a3c;color:#ffffff;">+55.7%</td><td class="" data-sort="0.710072769054" style="background:#1a7a3c;color:#ffffff;">+71.0%</td></tr><tr><td class="text" data-sort="universal health services" style="">Universal Health Services</td><td class="text text" data-sort="uhs" style=""><a href="#company-uhs">UHS</a></td><td class="" data-sort="10196742962.4" style="">$10.2B</td><td class="" data-sort="0.00818311195446" style="background:#d6ecd4;color:#111820;">+0.8%</td><td class="" data-sort="-0.0473468930352" style="background:#fbd5d4;color:#111820;">-4.7%</td><td class="" data-sort="-0.249160925632" style="background:#f5aead;color:#111820;">-24.9%</td></tr><tr><td class="text" data-sort="community health systems" style="">Community Health Systems</td><td class="text text" data-sort="cyh" style=""><a href="#company-cyh">CYH</a></td><td class="" data-sort="417387696.72" style="">$417.4M</td><td class="" data-sort="0.063829787234" style="background:#d6ecd4;color:#111820;">+6.4%</td><td class="" data-sort="0.0989010989011" style="background:#d6ecd4;color:#111820;">+9.9%</td><td class="" data-sort="-0.40119760479" style="background:#ee8483;color:#111820;">-40.1%</td></tr><tr><td class="text" data-sort="ardent health partners" style="">Ardent Health Partners</td><td class="text text" data-sort="ardt" style=""><a href="#company-ardt">ARDT</a></td><td class="" data-sort="1541012833.25" style="">$1.5B</td><td class="" data-sort="0.080198019802" style="background:#a9d9a4;color:#111820;">+8.0%</td><td class="" data-sort="-0.125801282051" style="background:#f5aead;color:#111820;">-12.6%</td><td class="" data-sort="-0.355962219599" style="background:#ee8483;color:#111820;">-35.6%</td></tr></tbody></table></div>

<h3 id="category-inpatient-non-acute-providers"><a href="#subcategory-performance">Inpatient Non-Acute Providers</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +12.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="the ensign group" style="">The Ensign Group</td><td class="text text" data-sort="ensg" style=""><a href="#company-ensg">ENSG</a></td><td class="" data-sort="10383598441.4" style="">$10.4B</td><td class="" data-sort="0.0224010806551" style="background:#d6ecd4;color:#111820;">+2.2%</td><td class="" data-sort="0.0931576096768" style="background:#d6ecd4;color:#111820;">+9.3%</td><td class="" data-sort="0.286017699115" style="background:#7cc077;color:#111820;">+28.6%</td></tr><tr><td class="text" data-sort="acadia healthcare" style="">Acadia Healthcare</td><td class="text text" data-sort="achc" style=""><a href="#company-achc">ACHC</a></td><td class="" data-sort="2757630145.5" style="">$2.8B</td><td class="" data-sort="0.19449825649" style="background:#1a7a3c;color:#ffffff;">+19.4%</td><td class="" data-sort="0.469494756911" style="background:#d6ecd4;color:#111820;">+46.9%</td><td class="" data-sort="-0.586007788371" style="background:#c0302f;color:#ffffff;">-58.6%</td></tr><tr><td class="text" data-sort="encompass health" style="">Encompass Health</td><td class="text text" data-sort="ehc" style=""><a href="#company-ehc">EHC</a></td><td class="" data-sort="11018041815.6" style="">$11.0B</td><td class="" data-sort="0.158945986497" style="background:#1a7a3c;color:#ffffff;">+15.9%</td><td class="" data-sort="0.026665559063" style="background:#d6ecd4;color:#111820;">+2.7%</td><td class="" data-sort="0.394606183706" style="background:#2f9e44;color:#111820;">+39.5%</td></tr><tr><td class="text" data-sort="pacs group" style="">PACS Group</td><td class="text text" data-sort="pacs" style=""><a href="#company-pacs">PACS</a></td><td class="" data-sort="7282112019.76" style="">$7.3B</td><td class="" data-sort="0.185699039488" style="background:#1a7a3c;color:#ffffff;">+18.6%</td><td class="" data-sort="2.86434782609" style="background:#1a7a3c;color:#ffffff;">+286.4%</td><td class="" data-sort="0.145656096932" style="background:#a9d9a4;color:#111820;">+14.6%</td></tr></tbody></table></div>

<h3 id="category-health-care-real-estate"><a href="#subcategory-performance">Health Care Real Estate</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +7.1%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="healthpeak properties" style="">Healthpeak properties</td><td class="text text" data-sort="doc" style=""><a href="#company-doc">DOC</a></td><td class="" data-sort="15050032094.7" style="">$15.1B</td><td class="" data-sort="0.0738636363636" style="background:#7cc077;color:#111820;">+7.4%</td><td class="" data-sort="0.201039861352" style="background:#7cc077;color:#111820;">+20.1%</td><td class="" data-sort="-0.0321229050279" style="background:#fbd5d4;color:#111820;">-3.2%</td></tr><tr><td class="text" data-sort="ventas, inc" style="">Ventas, Inc</td><td class="text text" data-sort="vtr" style=""><a href="#company-vtr">VTR</a></td><td class="" data-sort="47965614030.1" style="">$48.0B</td><td class="" data-sort="0.0465408805031" style="background:#a9d9a4;color:#111820;">+4.7%</td><td class="" data-sort="0.350450051645" style="background:#2f9e44;color:#111820;">+35.0%</td><td class="" data-sort="0.566586785347" style="background:#7cc077;color:#111820;">+56.7%</td></tr><tr><td class="text" data-sort="medical properties trust" style=""><a href="#earnings-mpt">Medical Properties Trust</a></td><td class="text text" data-sort="mpt" style=""><a href="#company-mpt">MPT</a></td><td class="" data-sort="2769203000.0" style="">$2.8B</td><td class="" data-sort="-0.172277227723" style="background:#c0302f;color:#ffffff;">-17.2%</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td></tr><tr><td class="text" data-sort="national health investors" style=""><a href="#earnings-nhi">National Health Investors</a></td><td class="text text" data-sort="nhi" style=""><a href="#company-nhi">NHI</a></td><td class="" data-sort="3715308205.35" style="">$3.7B</td><td class="" data-sort="-0.0225110545357" style="background:#fbd5d4;color:#111820;">-2.3%</td><td class="" data-sort="-0.0229038306992" style="background:#fbd5d4;color:#111820;">-2.3%</td><td class="" data-sort="-0.018037420918" style="background:#fbd5d4;color:#111820;">-1.8%</td></tr><tr><td class="text" data-sort="omega healthcare investors" style="">Omega Healthcare Investors</td><td class="text text" data-sort="ohi" style=""><a href="#company-ohi">OHI</a></td><td class="" data-sort="15143989930.0" style="">$15.1B</td><td class="" data-sort="-0.0169025987746" style="background:#fbd5d4;color:#111820;">-1.7%</td><td class="" data-sort="0.134601316752" style="background:#a9d9a4;color:#111820;">+13.5%</td><td class="" data-sort="0.243120491584" style="background:#a9d9a4;color:#111820;">+24.3%</td></tr><tr><td class="text" data-sort="welltower" style="">Welltower</td><td class="text text" data-sort="well" style=""><a href="#company-well">WELL</a></td><td class="" data-sort="166862860587.0" style="">$166.9B</td><td class="" data-sort="0.10189950407" style="background:#7cc077;color:#111820;">+10.2%</td><td class="" data-sort="0.445794966237" style="background:#1a7a3c;color:#ffffff;">+44.6%</td><td class="" data-sort="1.03174603175" style="background:#1a7a3c;color:#ffffff;">+103.2%</td></tr><tr><td class="text" data-sort="caretrust reit" style="">CareTrust REIT</td><td class="text text" data-sort="ctre" style=""><a href="#company-ctre">CTRE</a></td><td class="" data-sort="9648051197.4" style="">$9.6B</td><td class="" data-sort="-0.0576081672338" style="background:#f5aead;color:#111820;">-5.8%</td><td class="" data-sort="0.143657817109" style="background:#a9d9a4;color:#111820;">+14.4%</td><td class="" data-sort="0.393100970176" style="background:#a9d9a4;color:#111820;">+39.3%</td></tr><tr><td class="text" data-sort="sabra health care reit" style="">Sabra Health Care REIT</td><td class="text text" data-sort="sbra" style=""><a href="#company-sbra">SBRA</a></td><td class="" data-sort="5277860538.96" style="">$5.3B</td><td class="" data-sort="-0.0169327527818" style="background:#fbd5d4;color:#111820;">-1.7%</td><td class="" data-sort="0.100758396533" style="background:#a9d9a4;color:#111820;">+10.1%</td><td class="" data-sort="0.25509573811" style="background:#a9d9a4;color:#111820;">+25.5%</td></tr></tbody></table></div>

<h3 id="category-value-based-care"><a href="#subcategory-performance">Value-Based Care</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +6.1%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="privia health group" style="">Privia Health Group</td><td class="text text" data-sort="prva" style=""><a href="#company-prva">PRVA</a></td><td class="" data-sort="2982712892.58" style="">$3.0B</td><td class="" data-sort="-0.041394335512" style="background:#f5aead;color:#111820;">-4.1%</td><td class="" data-sort="0.0343206393982" style="background:#d6ecd4;color:#111820;">+3.4%</td><td class="" data-sort="0.105527638191" style="background:#d6ecd4;color:#111820;">+10.6%</td></tr><tr><td class="text" data-sort="astrana health" style="">Astrana Health</td><td class="text text" data-sort="asth" style=""><a href="#company-asth">ASTH</a></td><td class="" data-sort="1763186344.08" style="">$1.8B</td><td class="" data-sort="0.0666492420282" style="background:#a9d9a4;color:#111820;">+6.7%</td><td class="" data-sort="0.391408114558" style="background:#d6ecd4;color:#111820;">+39.1%</td><td class="" data-sort="-0.153846153846" style="background:#fbd5d4;color:#111820;">-15.4%</td></tr><tr><td class="text" data-sort="agilon health" style="">Agilon Health</td><td class="text text" data-sort="agl" style=""><a href="#company-agl">AGL</a></td><td class="" data-sort="2073627800.0" style="">$2.1B</td><td class="" data-sort="0.185611158693" style="background:#1a7a3c;color:#ffffff;">+18.6%</td><td class="" data-sort="2.49189189189" style="background:#1a7a3c;color:#ffffff;">+249.2%</td><td class="" data-sort="-0.200824742268" style="background:#f5aead;color:#111820;">-20.1%</td></tr><tr><td class="text" data-sort="evolent health" style="">Evolent Health</td><td class="text text" data-sort="evh" style=""><a href="#company-evh">EVH</a></td><td class="" data-sort="347566497.03" style="">$347.6M</td><td class="" data-sort="0.181818181818" style="background:#1a7a3c;color:#ffffff;">+18.2%</td><td class="" data-sort="-0.496774193548" style="background:#fbd5d4;color:#111820;">-49.7%</td><td class="" data-sort="-0.829072315559" style="background:#c0302f;color:#ffffff;">-82.9%</td></tr><tr><td class="text" data-sort="p3 health" style="">P3 Health</td><td class="text text" data-sort="piii" style=""><a href="#company-piii">PIII</a></td><td class="" data-sort="32693184.14" style="">$32.7M</td><td class="" data-sort="-0.0535872453499" style="background:#f5aead;color:#111820;">-5.4%</td><td class="" data-sort="0.577121771218" style="background:#a9d9a4;color:#111820;">+57.7%</td><td class="" data-sort="-0.643119572478" style="background:#e34948;color:#111820;">-64.3%</td></tr></tbody></table></div>

<h3 id="category-outpatient-and-home-providers"><a href="#subcategory-performance">Outpatient and Home Providers</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +12.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="davita" style="">Davita</td><td class="text text" data-sort="dva" style=""><a href="#company-dva">DVA</a></td><td class="" data-sort="15410176650.0" style="">$15.4B</td><td class="" data-sort="-0.0985280865125" style="background:#fbd5d4;color:#111820;">-9.9%</td><td class="" data-sort="0.330033978431" style="background:#d6ecd4;color:#111820;">+33.0%</td><td class="" data-sort="0.198003992016" style="background:#d6ecd4;color:#111820;">+19.8%</td></tr><tr><td class="text" data-sort="fresenius" style="">Fresenius</td><td class="text text" data-sort="fms" style=""><a href="#company-fms">FMS</a></td><td class="" data-sort="13782736811.6" style="">$13.8B</td><td class="" data-sort="0.100462962963" style="background:#d6ecd4;color:#111820;">+10.0%</td><td class="" data-sort="-0.0522328548644" style="background:#fbd5d4;color:#111820;">-5.2%</td><td class="" data-sort="0.25303110174" style="background:#d6ecd4;color:#111820;">+25.3%</td></tr><tr><td class="text" data-sort="surgery partners" style=""><a href="#earnings-sgry">Surgery Partners</a></td><td class="text text" data-sort="sgry" style=""><a href="#company-sgry">SGRY</a></td><td class="" data-sort="2014137694.8" style="">$2.0B</td><td class="" data-sort="0.0774193548387" style="background:#d6ecd4;color:#111820;">+7.7%</td><td class="" data-sort="-0.340789473684" style="background:#fbd5d4;color:#111820;">-34.1%</td><td class="" data-sort="-0.482081323225" style="background:#fbd5d4;color:#111820;">-48.2%</td></tr><tr><td class="text" data-sort="option care health" style="">Option Care Health</td><td class="text text" data-sort="opch" style=""><a href="#company-opch">OPCH</a></td><td class="" data-sort="3449554146.29" style="">$3.4B</td><td class="" data-sort="0.22669057377" style="background:#a9d9a4;color:#111820;">+22.7%</td><td class="" data-sort="-0.154484463277" style="background:#fbd5d4;color:#111820;">-15.4%</td><td class="" data-sort="-0.236691106152" style="background:#fbd5d4;color:#111820;">-23.7%</td></tr><tr><td class="text" data-sort="lifestance health" style="">Lifestance Health</td><td class="text text" data-sort="lfst" style=""><a href="#company-lfst">LFST</a></td><td class="" data-sort="4001624847.36" style="">$4.0B</td><td class="" data-sort="0.623529411765" style="background:#1a7a3c;color:#ffffff;">+62.4%</td><td class="" data-sort="1.28308823529" style="background:#2f9e44;color:#111820;">+128.3%</td><td class="" data-sort="1.1982300885" style="background:#a9d9a4;color:#111820;">+119.8%</td></tr><tr><td class="text" data-sort="chemed (vitas)" style="">Chemed (Vitas)</td><td class="text text" data-sort="che" style=""><a href="#company-che">CHE</a></td><td class="" data-sort="7054119350.92" style="">$7.1B</td><td class="" data-sort="0.226336501507" style="background:#a9d9a4;color:#111820;">+22.6%</td><td class="" data-sort="0.19718721215" style="background:#d6ecd4;color:#111820;">+19.7%</td><td class="" data-sort="-0.0753106128965" style="background:#fbd5d4;color:#111820;">-7.5%</td></tr><tr><td class="text" data-sort="addus homecare" style="">Addus HomeCare</td><td class="text text" data-sort="adus" style=""><a href="#company-adus">ADUS</a></td><td class="" data-sort="2121438440.16" style="">$2.1B</td><td class="" data-sort="0.275664981315" style="background:#7cc077;color:#111820;">+27.6%</td><td class="" data-sort="0.00825297541482" style="background:#d6ecd4;color:#111820;">+0.8%</td><td class="" data-sort="-0.116406547392" style="background:#fbd5d4;color:#111820;">-11.6%</td></tr><tr><td class="text" data-sort="pennant group" style="">Pennant Group</td><td class="text text" data-sort="pntg" style=""><a href="#company-pntg">PNTG</a></td><td class="" data-sort="1342375375.77" style="">$1.3B</td><td class="" data-sort="0.106047819972" style="background:#d6ecd4;color:#111820;">+10.6%</td><td class="" data-sort="0.556611243072" style="background:#a9d9a4;color:#111820;">+55.7%</td><td class="" data-sort="0.238815374921" style="background:#d6ecd4;color:#111820;">+23.9%</td></tr><tr><td class="text" data-sort="us physical therapy" style="">US Physical Therapy</td><td class="text text" data-sort="usph" style=""><a href="#company-usph">USPH</a></td><td class="" data-sort="1154497333.54" style="">$1.2B</td><td class="" data-sort="0.293424613915" style="background:#7cc077;color:#111820;">+29.3%</td><td class="" data-sort="-0.0529260899977" style="background:#fbd5d4;color:#111820;">-5.3%</td><td class="" data-sort="-0.0352689704311" style="background:#fbd5d4;color:#111820;">-3.5%</td></tr><tr><td class="text" data-sort="brightspring health services" style="">BrightSpring Health Services</td><td class="text text" data-sort="btsg" style=""><a href="#company-btsg">BTSG</a></td><td class="" data-sort="12419938407.6" style="">$12.4B</td><td class="" data-sort="0.0658031088083" style="background:#d6ecd4;color:#111820;">+6.6%</td><td class="" data-sort="1.75" style="background:#1a7a3c;color:#ffffff;">+175.0%</td><td class="" data-sort="4.13821815154" style="background:#1a7a3c;color:#ffffff;">+413.8%</td></tr><tr><td class="text" data-sort="aveanna healthcare" style=""><a href="#earnings-avah">Aveanna Healthcare</a></td><td class="text text" data-sort="avah" style=""><a href="#company-avah">AVAH</a></td><td class="" data-sort="2038188700.08" style="">$2.0B</td><td class="" data-sort="0.59585492228" style="background:#1a7a3c;color:#ffffff;">+59.6%</td><td class="" data-sort="0.74011299435" style="background:#7cc077;color:#111820;">+74.0%</td><td class="" data-sort="1.47887323944" style="background:#a9d9a4;color:#111820;">+147.9%</td></tr></tbody></table></div>

<h3 id="category-digital-health-specialty-benefits"><a href="#subcategory-performance">Digital Health, Specialty, Benefits</a><span class="return-badge category-return" style="background:#7cc077;color:#111820;">Last 3m: +23.8%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="teladoc" style="">Teladoc</td><td class="text text" data-sort="tdoc" style=""><a href="#company-tdoc">TDOC</a></td><td class="" data-sort="1219099780.91" style="">$1.2B</td><td class="" data-sort="0.0707547169811" style="background:#d6ecd4;color:#111820;">+7.1%</td><td class="" data-sort="-0.094414893617" style="background:#fbd5d4;color:#111820;">-9.4%</td><td class="" data-sort="-0.042194092827" style="background:#fbd5d4;color:#111820;">-4.2%</td></tr><tr><td class="text" data-sort="amwell" style="">Amwell</td><td class="text text" data-sort="amwl" style=""><a href="#company-amwl">AMWL</a></td><td class="" data-sort="179616192.25" style="">$179.6M</td><td class="" data-sort="0.64464993395" style="background:#1a7a3c;color:#ffffff;">+64.5%</td><td class="" data-sort="0.741258741259" style="background:#2f9e44;color:#111820;">+74.1%</td><td class="" data-sort="0.437644341801" style="background:#a9d9a4;color:#111820;">+43.8%</td></tr><tr><td class="text" data-sort="talkspace" style="">Talkspace</td><td class="text text" data-sort="talk" style=""><a href="#company-talk">TALK</a></td><td class="" data-sort="874415594.52" style="">$874.4M</td><td class="" data-sort="0.00961538461538" style="background:#d6ecd4;color:#111820;">+1.0%</td><td class="" data-sort="1.05078125" style="background:#1a7a3c;color:#ffffff;">+105.1%</td><td class="" data-sort="1.98295454545" style="background:#1a7a3c;color:#ffffff;">+198.3%</td></tr><tr><td class="text" data-sort="hims &amp; hers" style=""><a href="#earnings-hims">Hims &amp; Hers</a></td><td class="text text" data-sort="hims" style=""><a href="#company-hims">HIMS</a></td><td class="" data-sort="6427580190.15" style="">$6.4B</td><td class="" data-sort="0.12375249501" style="background:#d6ecd4;color:#111820;">+12.4%</td><td class="" data-sort="-0.388309430682" style="background:#f5aead;color:#111820;">-38.8%</td><td class="" data-sort="0.806803594352" style="background:#7cc077;color:#111820;">+80.7%</td></tr><tr><td class="text" data-sort="lifemd" style="">LifeMD</td><td class="text text" data-sort="lfmd" style=""><a href="#company-lfmd">LFMD</a></td><td class="" data-sort="169268785.0" style="">$169.3M</td><td class="" data-sort="-0.203233256351" style="background:#f5aead;color:#111820;">-20.3%</td><td class="" data-sort="-0.463452566096" style="background:#ee8483;color:#111820;">-46.3%</td><td class="" data-sort="-0.337811900192" style="background:#fbd5d4;color:#111820;">-33.8%</td></tr><tr><td class="text" data-sort="omada health" style="">Omada Health</td><td class="text text" data-sort="omda" style=""><a href="#company-omda">OMDA</a></td><td class="" data-sort="1179458378.88" style="">$1.2B</td><td class="" data-sort="0.451690821256" style="background:#2f9e44;color:#111820;">+45.2%</td><td class="" data-sort="0.1709693132" style="background:#d6ecd4;color:#111820;">+17.1%</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td></tr><tr><td class="text" data-sort="goodrx" style="">GoodRx</td><td class="text text" data-sort="gdrx" style=""><a href="#company-gdrx">GDRX</a></td><td class="" data-sort="1039733395.11" style="">$1.0B</td><td class="" data-sort="0.534979423868" style="background:#1a7a3c;color:#ffffff;">+53.5%</td><td class="" data-sort="0.0" style="background:#f0efec;color:#111820;">+0.0%</td><td class="" data-sort="-0.479776847978" style="background:#f5aead;color:#111820;">-48.0%</td></tr><tr><td class="text" data-sort="progyny" style="">Progyny</td><td class="text text" data-sort="pgny" style=""><a href="#company-pgny">PGNY</a></td><td class="" data-sort="2465903007.6" style="">$2.5B</td><td class="" data-sort="0.130322580645" style="background:#a9d9a4;color:#111820;">+13.0%</td><td class="" data-sort="0.123076923077" style="background:#d6ecd4;color:#111820;">+12.3%</td><td class="" data-sort="0.249049429658" style="background:#d6ecd4;color:#111820;">+24.9%</td></tr><tr><td class="text" data-sort="concentra group" style="">Concentra Group</td><td class="text text" data-sort="con" style=""><a href="#company-con">CON</a></td><td class="" data-sort="3982170593.6" style="">$4.0B</td><td class="" data-sort="0.369540007731" style="background:#7cc077;color:#111820;">+37.0%</td><td class="" data-sort="0.524526678141" style="background:#7cc077;color:#111820;">+52.5%</td><td class="" data-sort="0.513455788125" style="background:#a9d9a4;color:#111820;">+51.3%</td></tr><tr><td class="text" data-sort="healthequity" style="">HealthEquity</td><td class="text text" data-sort="hqy" style=""><a href="#company-hqy">HQY</a></td><td class="" data-sort="8775718420.29" style="">$8.8B</td><td class="" data-sort="0.27455275648" style="background:#7cc077;color:#111820;">+27.5%</td><td class="" data-sort="0.16509066637" style="background:#d6ecd4;color:#111820;">+16.5%</td><td class="" data-sort="0.398637820513" style="background:#a9d9a4;color:#111820;">+39.9%</td></tr></tbody></table></div>

<h3 id="category-health-it-and-data"><a href="#subcategory-performance">Health IT and Data</a><span class="return-badge category-return" style="background:#fbd5d4;color:#111820;">Last 3m: -9.2%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="oracle-cerner" style="">Oracle-Cerner</td><td class="text text" data-sort="orcl" style=""><a href="#company-orcl">ORCL</a></td><td class="" data-sort="374086768770.0" style="">$374.1B</td><td class="" data-sort="-0.219901528893" style="background:#f5aead;color:#111820;">-22.0%</td><td class="" data-sort="-0.393748993072" style="background:#ee8483;color:#111820;">-39.4%</td><td class="" data-sort="0.0949298028661" style="background:#d6ecd4;color:#111820;">+9.5%</td></tr><tr><td class="text" data-sort="veradigm" style="">Veradigm</td><td class="text text" data-sort="mdrx" style=""><a href="#company-mdrx">MDRX</a></td><td class="" data-sort="n/a" style="">n/a</td><td class="" data-sort="-0.04" style="background:#fbd5d4;color:#111820;">-4.0%</td><td class="" data-sort="0.0434782608696" style="background:#d6ecd4;color:#111820;">+4.3%</td><td class="" data-sort="-0.5" style="background:#ee8483;color:#111820;">-50.0%</td></tr><tr><td class="text" data-sort="waystar" style="">Waystar</td><td class="text text" data-sort="way" style=""><a href="#company-way">WAY</a></td><td class="" data-sort="4047809061.76" style="">$4.0B</td><td class="" data-sort="0.382041271612" style="background:#2f9e44;color:#111820;">+38.2%</td><td class="" data-sort="-0.313192904656" style="background:#f5aead;color:#111820;">-31.3%</td><td class="" data-sort="-0.0384167636787" style="background:#fbd5d4;color:#111820;">-3.8%</td></tr><tr><td class="text" data-sort="solventum" style="">Solventum</td><td class="text text" data-sort="solv" style=""><a href="#company-solv">SOLV</a></td><td class="" data-sort="13571702000.0" style="">$13.6B</td><td class="" data-sort="0.192970643684" style="background:#a9d9a4;color:#111820;">+19.3%</td><td class="" data-sort="0.240408849062" style="background:#a9d9a4;color:#111820;">+24.0%</td><td class="" data-sort="0.491414141414" style="background:#7cc077;color:#111820;">+49.1%</td></tr><tr><td class="text" data-sort="phreesia" style="">Phreesia</td><td class="text text" data-sort="phr" style=""><a href="#company-phr">PHR</a></td><td class="" data-sort="663241568.97" style="">$663.2M</td><td class="" data-sort="0.400228050171" style="background:#2f9e44;color:#111820;">+40.0%</td><td class="" data-sort="-0.57212543554" style="background:#e34948;color:#111820;">-57.2%</td><td class="" data-sort="-0.493608247423" style="background:#ee8483;color:#111820;">-49.4%</td></tr><tr><td class="text" data-sort="consensus cloud solutions" style="">Consensus Cloud Solutions</td><td class="text text" data-sort="ccsi" style=""><a href="#company-ccsi">CCSI</a></td><td class="" data-sort="669685380.0" style="">$669.7M</td><td class="" data-sort="0.37959039548" style="background:#2f9e44;color:#111820;">+38.0%</td><td class="" data-sort="0.509659969088" style="background:#2f9e44;color:#111820;">+51.0%</td><td class="" data-sort="0.937035200793" style="background:#1a7a3c;color:#ffffff;">+93.7%</td></tr><tr><td class="text" data-sort="definitive healthcare" style=""><a href="#earnings-dh">Definitive Healthcare</a></td><td class="text text" data-sort="dh" style=""><a href="#company-dh">DH</a></td><td class="" data-sort="85548500.0" style="">$85.5M</td><td class="" data-sort="-0.208812971902" style="background:#f5aead;color:#111820;">-20.9%</td><td class="" data-sort="-0.834832041344" style="background:#c0302f;color:#ffffff;">-83.5%</td><td class="" data-sort="-0.840995024876" style="background:#c0302f;color:#ffffff;">-84.1%</td></tr><tr><td class="text" data-sort="iqvia" style="">Iqvia</td><td class="text text" data-sort="iqv" style=""><a href="#company-iqv">IQV</a></td><td class="" data-sort="38684292000.0" style="">$38.7B</td><td class="" data-sort="0.399361400189" style="background:#2f9e44;color:#111820;">+39.9%</td><td class="" data-sort="0.238474017479" style="background:#a9d9a4;color:#111820;">+23.8%</td><td class="" data-sort="-0.0123941075825" style="background:#fbd5d4;color:#111820;">-1.2%</td></tr><tr><td class="text" data-sort="health catalyst" style="">Health Catalyst</td><td class="text text" data-sort="hcat" style=""><a href="#company-hcat">HCAT</a></td><td class="" data-sort="154438501.8" style="">$154.4M</td><td class="" data-sort="0.554621848739" style="background:#1a7a3c;color:#ffffff;">+55.5%</td><td class="" data-sort="-0.366438356164" style="background:#ee8483;color:#111820;">-36.6%</td><td class="" data-sort="-0.726128793486" style="background:#e34948;color:#111820;">-72.6%</td></tr><tr><td class="text" data-sort="doximity" style="">Doximity</td><td class="text text" data-sort="docs" style=""><a href="#company-docs">DOCS</a></td><td class="" data-sort="3812680930.62" style="">$3.8B</td><td class="" data-sort="0.307327358988" style="background:#7cc077;color:#111820;">+30.7%</td><td class="" data-sort="-0.619223092277" style="background:#e34948;color:#111820;">-61.9%</td><td class="" data-sort="-0.306293706294" style="background:#f5aead;color:#111820;">-30.6%</td></tr><tr><td class="text" data-sort="veeva systems" style="">Veeva Systems</td><td class="text text" data-sort="veev" style=""><a href="#company-veev">VEEV</a></td><td class="" data-sort="33102693840.0" style="">$33.1B</td><td class="" data-sort="0.534369885434" style="background:#1a7a3c;color:#ffffff;">+53.4%</td><td class="" data-sort="-0.131356687217" style="background:#fbd5d4;color:#111820;">-13.1%</td><td class="" data-sort="0.266233766234" style="background:#a9d9a4;color:#111820;">+26.6%</td></tr><tr><td class="text" data-sort="omnicell" style="">Omnicell</td><td class="text text" data-sort="omcl" style=""><a href="#company-omcl">OMCL</a></td><td class="" data-sort="1689541469.35" style="">$1.7B</td><td class="" data-sort="-0.134972170686" style="background:#f5aead;color:#111820;">-13.5%</td><td class="" data-sort="0.177027453455" style="background:#a9d9a4;color:#111820;">+17.7%</td><td class="" data-sort="-0.123384253819" style="background:#fbd5d4;color:#111820;">-12.3%</td></tr></tbody></table></div>

<h3 id="category-pharma-distribution"><a href="#subcategory-performance">Pharma Distribution</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +18.0%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="mckesson" style="">McKesson</td><td class="text text" data-sort="mck" style=""><a href="#company-mck">MCK</a></td><td class="" data-sort="97224871780.3" style="">$97.2B</td><td class="" data-sort="0.142564129534" style="background:#a9d9a4;color:#111820;">+14.3%</td><td class="" data-sort="0.29113735978" style="background:#7cc077;color:#111820;">+29.1%</td><td class="" data-sort="0.586606050647" style="background:#7cc077;color:#111820;">+58.7%</td></tr><tr><td class="text" data-sort="cardinal health" style=""><a href="#earnings-cah">Cardinal Health</a></td><td class="text text" data-sort="cah" style=""><a href="#company-cah">CAH</a></td><td class="" data-sort="54698777435.2" style="">$54.7B</td><td class="" data-sort="0.204764344262" style="background:#7cc077;color:#111820;">+20.5%</td><td class="" data-sort="0.571886905955" style="background:#1a7a3c;color:#ffffff;">+57.2%</td><td class="" data-sort="1.14082840237" style="background:#1a7a3c;color:#ffffff;">+114.1%</td></tr><tr><td class="text" data-sort="cencora" style="">Cencora</td><td class="text text" data-sort="cor" style=""><a href="#company-cor">COR</a></td><td class="" data-sort="59590161456.8" style="">$59.6B</td><td class="" data-sort="0.2177253502" style="background:#7cc077;color:#111820;">+21.8%</td><td class="" data-sort="0.0717164128133" style="background:#d6ecd4;color:#111820;">+7.2%</td><td class="" data-sort="0.317962286338" style="background:#a9d9a4;color:#111820;">+31.8%</td></tr><tr><td class="text" data-sort="accendra health" style="">Accendra Health</td><td class="text text" data-sort="ahco" style=""><a href="#company-ahco">AHCO</a></td><td class="" data-sort="912923359.92" style="">$912.9M</td><td class="" data-sort="-0.454971857411" style="background:#c0302f;color:#ffffff;">-45.5%</td><td class="" data-sort="-0.387453874539" style="background:#e34948;color:#111820;">-38.7%</td><td class="" data-sort="-0.444550669216" style="background:#f5aead;color:#111820;">-44.5%</td></tr><tr><td class="text" data-sort="henry schein" style="">Henry Schein</td><td class="text text" data-sort="hsic" style=""><a href="#company-hsic">HSIC</a></td><td class="" data-sort="10151122216.3" style="">$10.2B</td><td class="" data-sort="0.234460946095" style="background:#7cc077;color:#111820;">+23.4%</td><td class="" data-sort="0.323260613208" style="background:#7cc077;color:#111820;">+32.3%</td><td class="" data-sort="0.28628743373" style="background:#a9d9a4;color:#111820;">+28.6%</td></tr></tbody></table></div>

<h3 id="category-precision-diagnostics"><a href="#subcategory-performance">Precision Diagnostics</a><span class="return-badge category-return" style="background:#1a7a3c;color:#ffffff;">Last 3m: +47.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="natera" style="">Natera</td><td class="text text" data-sort="ntra" style=""><a href="#company-ntra">NTRA</a></td><td class="" data-sort="39411440972.6" style="">$39.4B</td><td class="" data-sort="0.663071474565" style="background:#7cc077;color:#111820;">+66.3%</td><td class="" data-sort="0.901177769599" style="background:#a9d9a4;color:#111820;">+90.1%</td><td class="" data-sort="1.49983868366" style="background:#a9d9a4;color:#111820;">+150.0%</td></tr><tr><td class="text" data-sort="neogenomics" style="">NeoGenomics</td><td class="text text" data-sort="neo" style=""><a href="#company-neo">NEO</a></td><td class="" data-sort="2092864917.6" style="">$2.1B</td><td class="" data-sort="0.934466019417" style="background:#7cc077;color:#111820;">+93.4%</td><td class="" data-sort="1.56682769726" style="background:#7cc077;color:#111820;">+156.7%</td><td class="" data-sort="-0.0148331273177" style="background:#fbd5d4;color:#111820;">-1.5%</td></tr><tr><td class="text" data-sort="billiontoone" style="">BillionToOne</td><td class="text text" data-sort="blln" style=""><a href="#company-blln">BLLN</a></td><td class="" data-sort="6542857599.0" style="">$6.5B</td><td class="" data-sort="0.129492920247" style="background:#d6ecd4;color:#111820;">+12.9%</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td></tr><tr><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="0.656236831016" style="background:#a9d9a4;color:#111820;">+65.6%</td><td class="" data-sort="1.67000679348" style="background:#7cc077;color:#111820;">+167.0%</td><td class="" data-sort="4.62468694097" style="background:#1a7a3c;color:#ffffff;">+462.5%</td></tr><tr><td class="text" data-sort="tempus ai" style="">Tempus AI</td><td class="text text" data-sort="tem" style=""><a href="#company-tem">TEM</a></td><td class="" data-sort="8489455269.8" style="">$8.5B</td><td class="" data-sort="0.185977691782" style="background:#d6ecd4;color:#111820;">+18.6%</td><td class="" data-sort="-0.293846570886" style="background:#fbd5d4;color:#111820;">-29.4%</td><td class="" data-sort="0.0239779874214" style="background:#d6ecd4;color:#111820;">+2.4%</td></tr><tr><td class="text" data-sort="illumina" style="">Illumina</td><td class="text text" data-sort="ilmn" style=""><a href="#company-ilmn">ILMN</a></td><td class="" data-sort="30654510000.0" style="">$30.7B</td><td class="" data-sort="0.339203030728" style="background:#a9d9a4;color:#111820;">+33.9%</td><td class="" data-sort="0.906802517231" style="background:#a9d9a4;color:#111820;">+90.7%</td><td class="" data-sort="0.464891412785" style="background:#d6ecd4;color:#111820;">+46.5%</td></tr><tr><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="1.64575471698" style="background:#1a7a3c;color:#ffffff;">+164.6%</td><td class="" data-sort="3.19835329341" style="background:#1a7a3c;color:#ffffff;">+319.8%</td><td class="" data-sort="1.57885057471" style="background:#a9d9a4;color:#111820;">+157.9%</td></tr><tr><td class="text" data-sort="pacbio" style="">PacBio</td><td class="text text" data-sort="pacb" style=""><a href="#company-pacb">PACB</a></td><td class="" data-sort="447266430.72" style="">$447.3M</td><td class="" data-sort="0.0267857142857" style="background:#d6ecd4;color:#111820;">+2.7%</td><td class="" data-sort="-0.12213740458" style="background:#fbd5d4;color:#111820;">-12.2%</td><td class="" data-sort="-0.262820512821" style="background:#fbd5d4;color:#111820;">-26.3%</td></tr><tr><td class="text" data-sort="quidelortho" style="">QuidelOrtho</td><td class="text text" data-sort="qdel" style=""><a href="#company-qdel">QDEL</a></td><td class="" data-sort="1198797586.62" style="">$1.2B</td><td class="" data-sort="0.385658914729" style="background:#a9d9a4;color:#111820;">+38.6%</td><td class="" data-sort="-0.44851523332" style="background:#fbd5d4;color:#111820;">-44.9%</td><td class="" data-sort="-0.674556213018" style="background:#fbd5d4;color:#111820;">-67.5%</td></tr><tr><td class="text" data-sort="quest diagnostics" style="">Quest Diagnostics</td><td class="text text" data-sort="dgx" style=""><a href="#company-dgx">DGX</a></td><td class="" data-sort="25796461699.2" style="">$25.8B</td><td class="" data-sort="0.25609560045" style="background:#d6ecd4;color:#111820;">+25.6%</td><td class="" data-sort="0.303888301719" style="background:#d6ecd4;color:#111820;">+30.4%</td><td class="" data-sort="0.548421191703" style="background:#d6ecd4;color:#111820;">+54.8%</td></tr><tr><td class="text" data-sort="labcorp holdings" style="">Labcorp Holdings</td><td class="text text" data-sort="lh" style=""><a href="#company-lh">LH</a></td><td class="" data-sort="25268306000.0" style="">$25.3B</td><td class="" data-sort="0.270487220447" style="background:#d6ecd4;color:#111820;">+27.0%</td><td class="" data-sort="0.176603299061" style="background:#d6ecd4;color:#111820;">+17.7%</td><td class="" data-sort="0.398373626374" style="background:#d6ecd4;color:#111820;">+39.8%</td></tr><tr><td class="text" data-sort="certara" style="">Certara</td><td class="text text" data-sort="cert" style=""><a href="#company-cert">CERT</a></td><td class="" data-sort="1189802484.0" style="">$1.2B</td><td class="" data-sort="0.785714285714" style="background:#7cc077;color:#111820;">+78.6%</td><td class="" data-sort="-0.274047186933" style="background:#fbd5d4;color:#111820;">-27.4%</td><td class="" data-sort="-0.335548172757" style="background:#fbd5d4;color:#111820;">-33.6%</td></tr></tbody></table></div>


## Upcoming Earnings

No saved earnings dates fall within the next seven days.

## Recent Earnings Highlights — 3m Ret

Companies covered in this section:
<ul class="section-jump-list">
<li><a href="#earnings-cah">Cardinal Health (CAH)</a></li>
<li><a href="#earnings-hims">Hims &amp; Hers (HIMS)</a></li>
<li><a href="#earnings-nhi">National Health Investors (NHI)</a></li>
<li><a href="#earnings-mpt">Medical Properties Trust (MPT)</a></li>
<li><a href="#earnings-avah">Aveanna Healthcare (AVAH)</a></li>
<li><a href="#earnings-sgry">Surgery Partners (SGRY)</a></li>
<li><a href="#earnings-dh">Definitive Healthcare (DH)</a></li>
</ul>
<h3 id="earnings-cah">Cardinal Health (<a href="#company-cah">CAH</a>) <span class="return-badge" style="background:#a9d9a4;color:#111820;">+20.5%</span></h3>

**Reported:** August 11, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/CAH:NYSE?tab=earnings&hl=en)

![Cardinal Health versus category peers and the S&P 500](assets/earnings-cah-3m.webp)

#### Earnings Call Summary

Cardinal Health reported strong Q4 fiscal 2026 performance with total company revenue growing 6% to $63.7B, driven by the Pharmaceutical and Specialty Solutions segment. Enterprise operating income grew 30% to $935M, and diluted EPS increased 40% to $2.91, which included a $0.31 one-time benefit from IEEPA tariff refunds.

#### At a Glance

- **Cardinal Health Delivers Mixed Financial Results:** Cardinal Health reported an adjusted EPS of $1.68, which fell short of the estimated $2.421, while reported quarterly revenue reached $63.67 billion, missing the projected $65.11 billion despite growing 6% year-over-year.
- **Pharma Core Drives Steady Performance Growth:** The Pharmaceutical and Specialty Solutions segment drove overall momentum with a 6% revenue increase to $58.8 billion and a 21% jump in profit, contrasting with a 2% volume-driven revenue decline in Global Medical Products and Distribution.
- **Guidance Outpaces Long-Term Targets:** Management issued an upbeat outlook for fiscal year 2027, projecting non-GAAP EPS growth of 13% to 15% ($12.40 to $12.60) which sits comfortably above the company&#x27;s long-term annual target of 12% to 14%.
- **Tariff Winds Yield Temporary Profit Gain:** The bottom line benefited from a non-recurring $100 million net operating profit impact from an IEEPA tariff refund, which added an extra $0.31 to the company&#x27;s baseline diluted EPS.
- **Massive New Share Buyback Authorized:** Fueled by full-year adjusted free cash flow generation of $5 billion, the company&#x27;s board approved a substantial $5 billion increase to its share repurchase program.
- **Higher-Margin Growth Businesses Accelerate Portfolio:** Cardinal Health&#x27;s smaller growth businesses, including at-Home Solutions and OptiFreight Logistics, delivered an aggregate 14% profit increase, supported by secular care trends and strategic capacity expansions.

#### Key Moments from the Call

- **11m 41s — Strong Fiscal 2027 Guidance Above Long-Term Targets:** Management projected fiscal 2027 EPS growth of 13% to 15% ($12.40-$12.60), outpacing its reconfirmed long-term growth rate of 12% to 14%. This strong outlook reassures investors of continued growth durability, supported by solid core volume demand and strategic multi-year investments across segments.
- **13m 37s — Pharma Margin Profile Aided by Generic Launches:** The Pharmaceutical segment profit is guided to grow 8% to 11% in fiscal 2027, driven by higher-margin specialty expansions and carryover generic launches. Investors will appreciate that expected IRA price changes will create top-line headwinds without adversely impacting bottom-line profitability.
- **15m 25s — Geopolitical Conflicts Threaten Lower-End GMPD Targets:** While the GMPD segment profit is guided to $200M-$220M, management explicitly highlighted that a protracted conflict in Iran and subsequent commodity or fuel cost escalation would push performance to the lower end of expectations, creating an area of macro concern for investors.
- **26m 57s — Massive $5 Billion Increase in Share Repurchase Authorization:** Cardinal Health announced a new $5B increase to its share repurchase authority, bringing the total program availability to $6.4B. Backed by a baseline commitment of at least $1B in buybacks for fiscal 2027, this aggressive capital deployment signals deep management confidence in sustained cash generation.
<h3 id="earnings-hims">Hims &amp; Hers (<a href="#company-hims">HIMS</a>) <span class="return-badge" style="background:#a9d9a4;color:#111820;">+12.4%</span></h3>

**Reported:** August 10, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/HIMS:NYSE?tab=earnings&hl=en)

![Hims &amp; Hers versus category peers and the S&P 500](assets/earnings-hims-3m.webp)

#### Earnings Call Summary

Hims & Hers reported Q2 2026 revenue of $753.2M, up nearly 40% year-over-year, beating the estimated $730.1M. Subscriptions grew to nearly 3 million with 300,000 net additions. However, the company posted a GAAP net loss of $86M (-$0.089 EPS vs. $0.091 estimated) due to $81M in non-recurring acquisition, restructuring, and legal contingency costs.

#### At a Glance

- **Revenue Beats but EPS Deeply Misses:** Hims &amp; Hers Health reported Q2 2026 revenue of $753,214,000, which beat the estimated $730,124,130, but its reported Adjusted EPS of -$0.37 missed the estimated 0.091 due to surging non-recurring costs.
- **Strong Growth in Subscriber KPIs:** The company&#x27;s subscriber base expanded 19% year-over-year to nearly 2.9 million, while monthly online revenue per average subscriber rose 21% to $92, driven by product mix and weight-loss offerings.
- **Full-Year 2026 Guidance Upgraded Significantly:** Management raised its full-year 2026 revenue guidance to a range of $3.1 billion to $3.3 billion, highlighting strong underlying demand for its personalized consumer health offerings.
- **Acquisitions Drive Explosive International Growth:** Rest of the World revenue surged over 17-fold year-over-year to $131.4 million, fueled directly by the strategic closure of the Eucalyptus acquisition in June 2026.
- **Surging Expenses Compress Gross Margins:** Gross margin fell to 64% from 76% in the prior year&#x27;s quarter, severely impacted by a strategic shift toward branded weight-loss solutions alongside legal, acquisition, and restructuring expenses.
- **Market Reacts Negatively to Profitability Concerns:** Shares declined following the announcement as investors prioritized the wider-than-expected net loss and compressed margins over the substantial top-line outperformance.

#### Key Moments from the Call

- **24m 4s — GAAP Net Loss and FTC Litigation:** Investors may be disappointed by the GAAP net loss of $86M and missed EPS expectations. This was driven by $81M in one-time costs, including legal contingency accruals after the FTC filed a complaint on July 29 following failed settlement talks. Management intends to defend its position vigorously.
- **24m 53s — Gross Margin Compression from Mix Shift:** Adjusted gross margins compressed by 6 points quarter-over-quarter to 64%. This contraction will please long-term growth investors as it reflects deliberate scaling of high-demand branded weight loss products and lower-margin international operations, though gross margins are expected to remain below historical levels.
- **30m 33s — AI Efficiency Gains Drive Deflationary Strategy:** An AI rollout for Hers weight loss users reduced non-clinical support tasks by 50% while tripling user messaging. Management plans to pass these cost savings back to consumers via lower weight loss subscription prices and new tools by year-end, echoing a proven market-expansion playbook used in hair and sexual health.
- **36m 35s — Peptides Pipeline and Regulatory Strategy:** Management revealed they are preparing a U.S.-manufactured peptides portfolio. They are currently running validation and stability testing on APIs at their Menlo Park facility, positioning them to launch immediately if and when the FDA issues final 503A compounding regulations, while offering allowed wellness options by year-end.
<h3 id="earnings-nhi">National Health Investors (<a href="#company-nhi">NHI</a>) <span class="return-badge" style="background:#fbd5d4;color:#111820;">-2.3%</span></h3>

**Reported:** August 11, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/NHI:NYSE?tab=earnings&hl=en)

![National Health Investors versus category peers and the S&P 500](assets/earnings-nhi-3m.webp)

#### Earnings Call Summary

NHI advanced its strategy by completing the sale of the NHC portfolio on July 1, expanding its SHOP platform, and strengthening its balance sheet. The SHOP portfolio performed as expected, and the full-year 2026 outlook remains unchanged, supported by improving sequential same-store results and investments collectively tracking within original underwriting assumptions.

#### At a Glance

- **NHI Missing Revenue and EPS Estimates:** National Health Investors reported an Adjusted EPS of $1.15, missing the estimated $4.567, while its reported revenue of $121,319,000 beat the estimated $112,511,740.
- **SHOP NOI Experiences Extreme Surge:** Total Senior Housing Operating Portfolio (SHOP) Net Operating Income (NOI) surged 188.5% year-over-year to $11 million, driven by the acquisition and transition of 27 properties.
- **Management Set Multi-Year SHOP Target:** Management outlined its most significant forward guidance target to increase SHOP exposure to 40% to 50% of total assets over the next three years, up from 24% at the end of June.
- **NHC Portfolio Sale Completes Successfully:** NHI completed the sale of its NHC portfolio on July 1, 2026, for $560 million in cash, and expects to recognize a massive real estate gain of $541.6 million in the third quarter.
- **Board Raises Quarterly Dividend Payout:** Signaling strong confidence in cash flow and capital returns, the Board of Directors approved a $0.02 per share increase to the quarterly dividend, bringing it to $0.94.

#### Key Moments from the Call

- **15m 20s — NHC Sale Proceeds Deployment:** The $560 million cash sale of the NHC portfolio closed in July. NHI deployed $221 million via reverse Section 1031 exchanges for previous replacements and holds $334 million for future tax-deferred reinvestments, aiming to avoid a special dividend.
- **19m 46s — Accelerated SHOP Platform Goals:** Management plans to grow its SHOP portfolio from 24% to 40%–50% of the total mix over three years. With a new COO onboard, NHI intends to boost its annual acquisition run rate from $200M–$400M to $500M–$700M.
- **26m 11s — Same-Store SHOP Guidance Bridge:** Management maintained its 1% to 3% full-year same-store SHOP NOI guidance despite negative first-half results. Meeting this target implies back-half growth of 8% to 9%, driven by pricing improvements, pipeline rebuilding, and resolving offline unit issues.
- **36m 56s — Triple Net to SHOP Conversions:** NHI sees avenues to convert triple net properties to SHOP before lease expirations. Operators facing CapEx needs or seeking to unlock value and eliminate guarantees create potential negotiation opportunities to capture greater cash flow upside.
<h3 id="earnings-mpt">Medical Properties Trust (<a href="#company-mpt">MPT</a>) <span class="return-badge" style="background:#f5aead;color:#111820;">-17.2%</span></h3>

**Reported:** August 10, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/MPT:NYSE?tab=earnings&hl=en)

![Medical Properties Trust versus category peers and the S&P 500](assets/earnings-mpt-3m.webp)

#### Earnings Call Summary

MPT announced a comprehensive refinancing transaction extending $2.4 billion of debt maturities to 2032, addressing near-term obligations. Post-acute operators led portfolio growth with an EBITDARM increase of over $70 million year-over-year, including a 24% rise at MEDIAN and 13% at Ernest Health, while behavioral health remains under pressure.

#### At a Glance

- **Revenue Beats Expectations While EPS Misses:** Medical Properties Trust reported Q2 2026 revenue of $270,691,000, beating the estimated $253,284,750, while its reported adjusted EPS of -$0.01 missed the analyst consensus estimate of $0.00.
- **Normalized FFO Remains Relatively Stable:** The company recorded Normalized Funds From Operations (NFFO) of $0.15 per share, matching consensus expectations and improving slightly from $0.14 per share in the prior quarter.
- **Ambitious Long-Term Cash Rent Targets Reaffirmed:** Management highlighted forward targets expecting to achieve an annualized cash rent run-rate exceeding $1 billion by the end of 2026 as collections from key tenants ramp up.
- **Massive Refinancing Package Executed Subsequentially:** The company announced a privately negotiated $2.4 billion refinancing transaction that captures a discount of approximately $123 million and successfully extends major debt maturities.
- **Segment Performance Shows Mixed Operational Results:** Post-acute operators drove the strongest portfolio gains with year-over-year EBITDARM growth of over $70 million, though performance was partially offset by margin pressures in the behavioral health segment.
- **Negative Market Reaction Triggers Share Slide:** Shares of Medical Properties Trust dropped over 12% in immediate trading following the release as investors focused on international market challenges and ongoing tenant execution risks.

#### Key Moments from the Call

- **12m 11s — Comprehensive Two-Step Debt Refinancing:** MPT initiated a two-step refinancing of $2.7 billion in 2026-2027 maturities. Step one issues $2.4 billion in 9.25% secured notes to redeem immediate debt and exchange longer-dated notes, clearing the runway until late 2028 and boosting its unencumbered asset covenant ratio from ~160% toward 300%. This relieves critical near-term liquidity pressure.
- **15m 18s — Asset Sales Validate Private Market Premium:** Management highlighted that third-party transactions demonstrate asset values well above net book values. An imminent asset sale will yield $172 million in net cash proceeds, reflecting a 60% premium over MPT's original investment and a 34% IRR. Further pipeline sales could generate an additional $200 million to $400 million.
- **21m 13s — HSA Cash Collections Lag Operational Strength:** Analysts pressed for details on HSA, which generated a healthy 2x operational coverage but lagged in cash collections (stuck in the 80% range). Temporary billing disruptions from an EMR conversion and state funding delays strained liquidity, though August funding allowed HSA to begin repaying MPT's working capital advances.
- **35m 45s — Secured Debt Capacity Restrictions:** Management acknowledged that the new phase 1 financing pushes MPT's secured debt ratio from 25% to near its 40% covenant ceiling. To regain secured debt capacity for phase 2 and continue deleveraging without dilutive equity issuance, MPT remains highly dependent on completing its ongoing pipeline of asset sales.
<h3 id="earnings-avah">Aveanna Healthcare (<a href="#company-avah">AVAH</a>) <span class="return-badge" style="background:#1a7a3c;color:#ffffff;">+59.6%</span></h3>

**Reported:** August 13, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/AVAH:NASDAQ?tab=earnings&hl=en)

![Aveanna Healthcare versus category peers and the S&P 500](assets/earnings-avah-3m.webp)

#### Earnings Call Summary

Aveanna Healthcare reported Q2 2026 revenue of $670.5 million, up 13.7% year-over-year, and adjusted EBITDA of $95.4 million, an 8% increase driven by improved rates, volume growth, and operational efficiencies. Performance beat estimates, indicating a stable return to organic growth across all three operating segments.

#### At a Glance

- **Aveanna Beats EPS and Revenue Estimates:** Aveanna Healthcare reported Q2 2026 Adjusted EPS of $0.18, beating the estimated $0.167, and delivered revenue of $670.48 million, which surpassed the estimated $638.63 million.
- **Segment Growth Drives Key KPIs Higher:** The company delivered robust performance across core KPIs, with Private Duty Services revenue increasing 14.0% year-over-year and Home Health and Hospice revenue climbing 14.8% due to higher volumes and improved reimbursement rates.
- **Management Significantly Raises Full-Year Guidance:** Aveanna raised its full-year 2026 outlook, now expecting revenue to exceed $2.68 billion and Adjusted EBITDA to top $365 million, driven by organic strength rather than its recent acquisition.
- **Strong Cash Flow Strengthens Liquidity Position:** The company generated $75.4 million in positive free cash flow year-to-date and exited the quarter with solid total liquidity of approximately $433 million.
- **Market Welcomes Strong Results with Surge:** Following the earnings release, Aveanna&#x27;s stock surged more than 18% to nearly touch its 52-week high, prompting multiple Wall Street banks to lift their price targets.

#### Key Moments from the Call

- **4m 41s — Long-Awaited California Rate Breakthrough:** Securing a significant private duty nursing rate increase in California for 2027 marks a major legislative milestone. This allows Aveanna to resolve sub-market caregiver wages and unlock substantial latent volume demand in a previously stagnant state.
- **12m 50s — Guidance Raised and Outlook Enhanced:** Management increased full-year 2026 revenue and EBITDA guidance due to strong core performance. It also raised long-term organic growth expectations across core segments, signaling long-term structural tailwinds from government advocacy.
- **21m 44s — Successful Term Loan Repricing:** Aveanna capitalized on recent credit rating upgrades to reprice its variable term loan, reducing the interest rate by 75 basis points. This move structurally improves the bottom line by lowering annual interest expenses by $10 million.
- **30m 31s — M&A Acceleration and De-leveraging Focus:** The integration of Family First remains ahead of schedule. Fueled by strong free cash flow, management expressed enhanced appetite for future adult Home Health acquisitions while maintaining a strict commitment to reduce leverage below 3x by 2027.
<h3 id="earnings-sgry">Surgery Partners (<a href="#company-sgry">SGRY</a>) <span class="return-badge" style="background:#d6ecd4;color:#111820;">+7.7%</span></h3>

**Reported:** August 10, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/SGRY:NASDAQ?tab=earnings&hl=en)

![Surgery Partners versus category peers and the S&P 500](assets/earnings-sgry-3m.webp)

#### Earnings Call Summary

Surgery Partners delivered Q2 2026 results ahead of internal expectations, posting net revenue of approximately $849 million (up 2.7% year-over-year) and adjusted EBITDA of $125 million, yielding a 14.7% margin. For the first half of 2026, net revenue reached $1.66 billion (+3.6% YoY) while adjusted EBITDA was $228 million.

#### At a Glance

- **Revenue Beats While EPS Misses:** Surgery Partners reported Q2 2026 revenue of $848.90 million, beating the estimated $830.32 million, while reporting an adjusted EPS loss of -$0.12 which missed the estimated profit of $0.063.
- **Same-Facility Growth Driven by Acuity:** Same-facility revenues increased by 5.0% year-over-year, supported by a 4.8% surge in revenue per case despite flat same-facility case volume growth of 0.3%.
- **Full-Year Guidance Reaffirmed Amid Divestitures:** Management maintained its full-year 2026 revenue guidance of $3.35 billion to $3.45 billion and adjusted EBITDA of at least $530 million, excluding the upcoming impact of its Idaho Falls facility divestiture.
- **Idaho Falls Portfolio Optimization Announced:** The company highlighted a significant portfolio optimization via the pending $795 million divestiture of its Idaho Falls market operations to Intermountain Health to sharpen focus on short-stay surgical facilities.
- **Profitability Squeezed by Margin Compression:** Adjusted EBITDA decreased to $125.2 million from $129.0 million in the prior-year quarter, causing adjusted EBITDA margins to compress to 14.7% due to rising salary expenses and a lack of volume leverage.
- **Elevated Debt Burden Limits Cash Flow:** Operating cash flow dropped 27% year-over-year to $59.3 million, weighed down by high net interest expenses as net leverage remained elevated at 4.4x.

#### Key Moments from the Call

- **1m 19s — Strategic Divestiture of Idaho Falls Assets:** Surgery Partners announced the sale of its Idaho Falls market interests to Intermountain Health for $795 million in gross proceeds. This major portfolio optimization simplifies operations into a pure-play short-stay surgical model, removes capital-intensive non-core acute services, and allows net proceeds to pay down debt, reducing leverage by 0.3 turns.
- **5m 3s — Payer Mix Moderation Impacts Operating Margins:** Commercial payer mix fell 350 basis points year-over-year to 49% of net revenue in Q2, driven by shifts toward government payers in larger surgical hospitals. This anticipated trend increased salaries and wages to 29.8% of revenue (up from 28.5% YoY), though seasonal volume step-ups drove sequential expense improvements.
- **6m 48s — Missing 2026 Annual M&A Target:** Management acknowledged the company will not reach its $200 million average annual M&A investment target in 2026. While disappointing to growth-focused investors, executives clarified that resources were intentionally diverted toward core portfolio optimization, and disciplined, highly strategic integrations will resume late in the year.
- **19m 41s — Acuity Gains and Outpatient Migration Tailwinds:** High-acuity case growth in orthopedics (total joints), spine, and vascular procedures continues to shift from traditional hospitals to ASCs. This structural migration, supported by positive secular regulatory environments like Medicare's inpatient-only list removals, drove an outstanding 4.8% expansion in net revenue per case.
<h3 id="earnings-dh">Definitive Healthcare (<a href="#company-dh">DH</a>) <span class="return-badge" style="background:#f5aead;color:#111820;">-20.9%</span></h3>

**Reported:** August 10, 2026 · [Google Finance earnings page](https://www.google.com/finance/quote/DH:NASDAQ?tab=earnings&hl=en)

![Definitive Healthcare versus category peers and the S&P 500](assets/earnings-dh-3m.webp)

#### Earnings Call Summary

Definitive Healthcare reported Q2 2026 revenue of $55.2 million, down 9% year-over-year, which met guidance. Adjusted EBITDA was $14.6 million with a 26% margin, exceeding expectations. The company sustained solid cash flow, generating approximately $50 million of unlevered free cash flow for the trailing 12 months.

#### At a Glance

- **EPS Beats While Revenue Misses:** Definitive Healthcare reported a Reported Adjusted EPS of 0, which surpassed the estimated Adjusted EPS of 0.043, while Reported Revenue of 55,195,000 slightly missed the estimated 55,385,730.
- **Subscription and EBITDA Metrics Stabilize:** Subscription revenues fell 9% year-over-year to $52.8 million, while adjusted EBITDA reached $14.6 million, representing a 26% margin that landed slightly above the high end of internal company guidance.
- **Full-Year Guidance Midpoint Raised:** Management tightened its full-year 2026 revenue visibility to $220 million-$222 million due to lower professional services bookings, but raised the midpoint of its full-year adjusted EBITDA profit outlook to $57 million-$59 million.
- **AI Platform Pilot Program Launched:** The company launched a pilot for Turbo, its new AI-powered healthcare intelligence platform, aiming for general availability by year-end to boost long-term customer retention.
- **Segment Performance and Customer Retention:** The provider and diversified segments represented over 60% of total revenue and paced ahead in returning to growth, whereas the life sciences segment recovery continued to face a prolonged timeline.

#### Key Moments from the Call

- **4m 29s — Biopharma New Logo Growth Amidst Headwinds:** Despite ongoing macro pressures and slower deployment in the life sciences segment, the biopharma business delivered its strongest new logo acquisition quarter in three years outside of a standard Q4 spike, highlighted by four key customer win-backs.
- **12m 45s — Launch of AI Platform Turbo:** Definitive Healthcare announced the pilot launch of Turbo, an AI-native decision-making platform. While no material revenue impact is projected for 2026, management expects the platform to significantly boost customer retention during critical late-year renewal cycles and drive monetization through usage tiered pricing and module upsells in 2027.
- **16m 58s — Professional Services Bookings Underperform:** Professional services revenue fell short of internal expectations in Q2 2026 due to lighter bookings for traditional analytics engagements. This weakness is expected to create short-term revenue headwinds, impacting the company's sequential top-line outlook into Q3.
- **20m 27s — Full-Year Revenue Guidance Cut and Profitability Raise:** Management tightened and effectively lowered its full-year 2026 revenue guidance to $220 million-$222 million, citing light professional services bookings. However, proactive expense controls allowed them to raise full-year adjusted EBITDA guidance to $57 million-$59 million, expanding the full-year margin outlook by 100 basis points.

## Company Overviews

<h3 id="company-unh">UnitedHealth (UNH)</h3>

*Payers · $380.1B · 3m +2.0% · 12m +32.1% · 24m -30.5%*

[Google Finance](https://www.google.com/finance/quote/UNH:NYSE?tab=earnings&hl=en)

Diversified healthcare company operating UHC insurance businesses and the Optum health services platform.

UnitedHealth Group is one of the largest private health insurers and provides medical benefits to about 51 million members globally, including 1 million outside the US as of December 2025. As a leader in employer-sponsored, self-directed, and government-backed insurance plans, UnitedHealth has obtained massive scale in medical insurance. Along with its insurance assets, UnitedHealth's Optum franchises help create a healthcare services colossus that spans everything from pharmaceutical benefits to providing outpatient care and analytics to affiliates and third parties.

<h3 id="company-cvs">CVS Health (CVS)</h3>

*Payers · $135.1B · 3m +1.3% · 12m +41.6% · 24m +66.5%*

[Google Finance](https://www.google.com/finance/quote/CVS:NYSE?tab=earnings&hl=en)

Healthcare retail ecosystem.

CVS Health offers a diverse set of healthcare services. Its roots are in its retail pharmacy operations, where it operates around 9,000 stores primarily in the US. CVS is also a large pharmacy benefit manager (acquired through Caremark), processing about 2 billion adjusted claims annually. It operates a top-tier health insurer (acquired through Aetna) through which it serves about 27 million medical members. The acquisition of Oak Street Health added primary care services to the mix, which could have significant synergies with all existing business lines.

<h3 id="company-hum">Humana (HUM)</h3>

*Payers · $43.7B · 3m +27.5% · 12m +35.8% · 24m +11.0%*

[Google Finance](https://www.google.com/finance/quote/HUM:NYSE?tab=earnings&hl=en)

Large payer, Medicare and Medicare Advantage focused.

Humana is one of the largest private health insurers in the US, and the firm has built a niche specializing in government-sponsored programs, with nearly all its medical membership stemming from Medicare, Medicaid, and the military's Tricare program. Beyond medical insurance, the company provides other healthcare services, including primary-care services, at-home services, and pharmacy benefit management.

<h3 id="company-oscr">Oscar Health (OSCR)</h3>

*Payers · $9.4B · 3m +40.5% · 12m +109.5% · 24m +75.2%*

[Google Finance](https://www.google.com/finance/quote/OSCR:NYSE?tab=earnings&hl=en)

Tech-focused payer with large exposure to exchange products and ICHRAs.

Oscar Health Inc is a healthcare technology company built around a full stack technology platform and a relentless focus on serving its members. It offers Individual & Family plans and health technology solutions that power the healthcare industry. Oscar operates as one segment to sell insurance to individuals, families and employees through the federal and state-run healthcare exchanges formed in conjunction with the Patient Protection and Affordable Care Act (ACA) and leverages its technology platform to provide services via its Oscar offering.

<h3 id="company-moh">Molina Healthcare (MOH)</h3>

*Payers · $10.2B · 3m +14.8% · 12m +26.8% · 24m -39.3%*

[Google Finance](https://www.google.com/finance/quote/MOH:NYSE?tab=earnings&hl=en)

Managed-care company providing health insurance through government programs.

Molina Healthcare Inc provides medical insurance plans through Medicaid, the individual exchanges, and Medicare. The company operates in four reportable segments consisting of: 1) Medicaid; 2) Medicare; 3) Marketplace; and 4) Other. It manages health benefit risks for more than 5 million people, with more than 85% of those members coming through contracts with state governments for their Medicaid programs. Medicaid contracts in four states-California, New York, Texas, and Washington-account for over half of its enrollees.

<h3 id="company-ci">Cigna (CI)</h3>

*Payers · $73.7B · 3m -0.9% · 12m -4.8% · 24m -17.5%*

[Google Finance](https://www.google.com/finance/quote/CI:NYSE?tab=earnings&hl=en)

Employer-focused health insurance company.

Cigna primarily provides pharmacy benefit management and health insurance services. Its PBM and specialty pharmacy services, which were greatly expanded by its 2018 merger with Express Scripts, are mostly sold to health insurance plans and employers. Its largest PBM contract is with the Department of Defense, and it recently won a multiyear deal with top-tier insurer Centene. In health insurance and other benefits, Cigna primarily serves employers through self-funding arrangements, and the company operates mostly in the US with 16 million US and 2 million international medical members covered as of December 2025.

<h3 id="company-elv">Elevance (ELV)</h3>

*Payers · $81.5B · 3m +1.9% · 12m +29.3% · 24m -26.4%*

[Google Finance](https://www.google.com/finance/quote/ELV:NYSE?tab=earnings&hl=en)

Health insurance company, previously named Anthem.

Elevance Health remains one of the leading health insurers in the US, providing medical benefits to 45 million medical members at the end of 2025. The company offers employer, individual, and government-sponsored coverage plans. Elevance differs from its peers in its unique position as the largest single provider of Blue Cross Blue Shield branded coverage, operating as the licensee for the Blue Cross Blue Shield Association in 14 states. Through acquisitions, such as the Amerigroup deal in 2012 and MMM in 2021, Elevance's reach expands beyond those states in government-sponsored programs, such as Medicaid and Medicare Advantage plans, too. It is also an emerging player in pharmacy benefit management and other healthcare services.

<h3 id="company-clov">Clover Health (CLOV)</h3>

*Payers · $2.2B · 3m +32.6% · 12m +73.6% · 24m +62.5%*

[Google Finance](https://www.google.com/finance/quote/CLOV:NASDAQ?tab=earnings&hl=en)

American healthcare company company providing Medicare Advantage insurance plans.

Clover Health Investments Corp is a healthcare technology company. It focuses on empowering Medicare physicians to proactively manage chronic diseases through its proprietary software platform, Clover Assistant. This cloud-based solution provides personalized insights to physicians, enabling early detection and management of chronic conditions. It operates in one segment: Insurance, through which it offers PPO and HMO plans to Medicare Advantage members in several states.

<h3 id="company-cnc">Centene (CNC)</h3>

*Payers · $30.7B · 3m +15.8% · 12m +136.8% · 24m -13.6%*

[Google Finance](https://www.google.com/finance/quote/CNC:NYSE?tab=earnings&hl=en)

Health insurance for government and privately insured healthcare programs.

Centene is a managed care organization that focuses on government-sponsored healthcare plans, including Medicaid, Medicare, and the individual exchanges. Centene served 20 million medical members as of December 2025, mostly in Medicaid (about 64% of membership), the individual exchanges (about 28%), and Medicare (about 5%). The company also provides Medicare Part D pharmaceutical plans.

<h3 id="company-alhc">Alignment Health (ALHC)</h3>

*Payers · $3.1B · 3m -11.3% · 12m -7.2% · 24m +60.5%*

[Google Finance](https://www.google.com/finance/quote/ALHC:NASDAQ?tab=earnings&hl=en)

Tech-enabled Medicare Advantage Company.

Alignment Healthcare Inc is a next-generation, consumer-centric platform that is revolutionizing the healthcare experience for seniors through Medicare Advantage plans. These plans are marketed and sold direct-to-consumer, allowing seniors to select the manner in which customers receive healthcare coverage and services on an annual basis. The company combines a technology platform and clinical model for more effective health outcomes.

<h3 id="company-hca">HCA Healthcare (HCA)</h3>

*Health System Providers · $87.2B · 3m -4.3% · 12m +2.2% · 24m +8.3%*

[Google Finance](https://www.google.com/finance/quote/HCA:NYSE?tab=earnings&hl=en)

Largest for-profit hospital and outpatient care operator in the United States.

HCA Healthcare is a Nashville-based healthcare provider organization operating the largest collection of acute-care hospitals in the United States. As of December 2025, the firm owned and operated 190 hospitals and over 2,500 outpatient facillities across 19 states and a small foothold in the United Kingdom.

<h3 id="company-thc">Tenet Health (THC)</h3>

*Health System Providers · $20.5B · 3m +36.2% · 12m +55.7% · 24m +71.0%*

[Google Finance](https://www.google.com/finance/quote/THC:NYSE?tab=earnings&hl=en)

Diversified healthcare provider with hospitals and a leading ambulatory surgery center platform through USPI.

Tenet Healthcare is a Dallas-based healthcare services organization. It operates acute and specialty hospitals (50 as of December 2025) and hundreds of ambulatory surgery centers and other outpatient facilities across the US, primarily in the South. Through its Conifer segment, Tenet also provides revenue cycle management solutions.

<h3 id="company-uhs">Universal Health Services (UHS)</h3>

*Health System Providers · $10.2B · 3m +0.8% · 12m -4.7% · 24m -24.9%*

[Google Finance](https://www.google.com/finance/quote/UHS:NYSE?tab=earnings&hl=en)

Hospital operator with significant acute care and behavioral health business.

Universal Health Services Inc offers healthcare services through its behavioral health centers, acute care hospitals, and related outpatient facilities. As of late 2025, the company operated 346 inpatient behavioral health centers, 29 acute care hospitals, and many supportive outpatient facilities. Its operations are concentrated in the U.S, particularly in Nevada (21% of 2025 operating profits), Texas (19%), and California (13%), although it does have some exposure to the UK behavioral health market (6% of 2025 sales) too. While its acute care services account for over 55% of revenue, the behavioral health centers sport higher margins and account for over 55% of pretax profits.

<h3 id="company-cyh">Community Health Systems (CYH)</h3>

*Health System Providers · $417.4M · 3m +6.4% · 12m +9.9% · 24m -40.1%*

[Google Finance](https://www.google.com/finance/quote/CYH:NYSE?tab=earnings&hl=en)

Operator of community hospitals primarily serving non-urban and regional markets.

Community Health Systems Inc is a publicly owned hospital operator in the United States. The company also owns four home health agencies and provides management and consulting services to independent hospitals. The firm derives revenue through a broad range of general and specialized hospital healthcare services and outpatient services.

<h3 id="company-ardt">Ardent Health Partners (ARDT)</h3>

*Health System Providers · $1.5B · 3m +8.0% · 12m -12.6% · 24m -35.6%*

[Google Finance](https://www.google.com/finance/quote/ARDT:NYSE?tab=earnings&hl=en)

Regional hospital operator focused on integrated health systems across mid-sized US markets.

Ardent Health Inc is a provider of healthcare in growing mid-sized urban communities across the U.S and operating in eight growing mid-sized urban markets across six states Texas, Oklahoma, New Mexico, New Jersey, Idaho, and Kansas. The main focus on people and investments in services and technologies.

<h3 id="company-ensg">The Ensign Group (ENSG)</h3>

*Inpatient Non-Acute Providers · $10.4B · 3m +2.2% · 12m +9.3% · 24m +28.6%*

[Google Finance](https://www.google.com/finance/quote/ENSG:NASDAQ?tab=earnings&hl=en)

Leading operator of skilled nursing facilities, rehabilitation centers, and senior-care services.

Ensign Group Inc provides post-acute healthcare services in the United States. Its regional subsidiaries oversee skilled nursing, assisted living, home health and hospice, mobile ancillary, and urgent care operations. Medicare and Medicaid programs contribute majority of revenue received for Ensign's services. The firm operates through two segments, Skilled services, and Standard Bearer. The skilled services segment includes the operation of skilled nursing facilities and rehabilitation therapy services. The Standard Bearer segment comprises of properties owned by the company through its captive REIT and leased to skilled nursing and assisted living operations. The majority of the revenue is generated from the skilled services segment.

<h3 id="company-achc">Acadia Healthcare (ACHC)</h3>

*Inpatient Non-Acute Providers · $2.8B · 3m +19.4% · 12m +46.9% · 24m -58.6%*

[Google Finance](https://www.google.com/finance/quote/ACHC:NASDAQ?tab=earnings&hl=en)

Largest provider of behavioral health and addiction treatment services.

Acadia Healthcare Co Inc acquires and develops behavioral healthcare facilities. Its facilities and services are classified into the following categories: acute inpatient psychiatric facilities; specialty treatment facilities; CTCs; and residential treatment centers. In which Acute inpatient psychiatric facilities contribute the majority of revenue in the United States. The Company has one reportable segment, behavioral healthcare services. The behavioral healthcare services segment provides inpatient and outpatient behavioral healthcare services.

<h3 id="company-ehc">Encompass Health (EHC)</h3>

*Inpatient Non-Acute Providers · $11.0B · 3m +15.9% · 12m +2.7% · 24m +39.5%*

[Google Finance](https://www.google.com/finance/quote/EHC:NYSE?tab=earnings&hl=en)

In-patient post-acute rehabilitation services.

Encompass Health Corp provides post-acute healthcare services in the United States through a network of inpatient rehabilitation hospitals, which is the company's sole segment. Inpatient rehabilitation contributes the majority of the firm's revenue and provides specialized rehabilitative treatment through a network of inpatient hospitals. The company's inpatient rehabilitation hospitals provide a higher level of rehabilitative care to patients who are recovering from conditions such as stroke and other neurological disorders, cardiac and pulmonary conditions, brain and spinal cord injuries, complex orthopedic conditions, and amputations.

<h3 id="company-pacs">PACS Group (PACS)</h3>

*Inpatient Non-Acute Providers · $7.3B · 3m +18.6% · 12m +286.4% · 24m +14.6%*

[Google Finance](https://www.google.com/finance/quote/PACS:NYSE?tab=earnings&hl=en)

Post-acute care and skilled nursing company.

PACS Group Inc is a post-acute healthcare company mainly focused on delivering skilled nursing care through a portfolio of independently operated facilities. The post-acute care ecosystem serves individuals who need additional help recuperating from acute conditions, illnesses, or serious medical procedures after getting discharged from the hospital. It also provides senior care, assisted living, and independent living options in some of the communities. The company has one reportable segment.

<h3 id="company-doc">Healthpeak properties (DOC)</h3>

*Health Care Real Estate · $15.1B · 3m +7.4% · 12m +20.1% · 24m -3.2%*

[Google Finance](https://www.google.com/finance/quote/DOC:NYSE?tab=earnings&hl=en)

Healthcare industry real estate investment trust focused on outpatient medical offices, life science properties, an senior housing.

Healthpeak owns a diversified healthcare portfolio of approximately 700 in-place properties spread across mainly medical office and life science assets, plus a handful of senior housing, hospital, and skilled nursing/post-acute care assets, as well.

<h3 id="company-vtr">Ventas, Inc (VTR)</h3>

*Health Care Real Estate · $48.0B · 3m +4.7% · 12m +35.0% · 24m +56.7%*

[Google Finance](https://www.google.com/finance/quote/VTR:NYSE?tab=earnings&hl=en)

Real estate investment trust focused  on ownership and management of senior housing, research, medicine office buildings, and healthcare facilities.

Ventas owns a diversified healthcare portfolio of almost 1,400 in-place properties spread across the senior housing, medical office, hospital, life science, and skilled nursing/post-acute care. The portfolio includes almost 100 properties in Canada and the United Kingdom as the company looks for additional investment opportunities in countries with mature healthcare systems that operate similarly to the United States. The firm also owns mortgages and other loans, contributing about 1% of net operating income.

<h3 id="company-mpt">Medical Properties Trust (MPT)</h3>

*Health Care Real Estate · $2.8B · 3m -17.2% · 12m n/a · 24m n/a*

[Google Finance](https://www.google.com/finance/quote/MPT:NYSE?tab=earnings&hl=en)

Real estate investment trust for healthcare facilities in the US and Europe.

Medical Properties Trust Inc acquires and develops net-leased healthcare facilities. Its investments in healthcare real estate, other loans, and any investments in tenants are considered a single reportable segment. Its business strategy is to acquire and develop healthcare facilities and lease the facilities to healthcare operating companies under long-term net leases, which require the tenant to bear of the costs associated with the property. The group's geographic areas are the United States, the United Kingdom, and All other countries.

<h3 id="company-nhi">National Health Investors (NHI)</h3>

*Health Care Real Estate · $3.7B · 3m -2.3% · 12m -2.3% · 24m -1.8%*

[Google Finance](https://www.google.com/finance/quote/NHI:NYSE?tab=earnings&hl=en)

Healthcare REIT focused on senior housing, skilled nursing, and long-term care properties.

National Health Investors Inc is a self-managed REIT that owns, leases, operates, and finances the development of senior housing communities and medical facilities. It operates through two segments: Real Estate Investments and Senior Housing Operating Portfolio (SHOP). The Real Estate Investments segment, which generates the majority of revenue, includes real estate leases, mortgages, and other notes receivable related to independent living facilities, assisted living facilities, entrance fee communities, senior living campuses, skilled nursing facilities, and a hospital. The SHOP segment consists of ventures that own and operate independent living facilities. The company's revenues are derived from rental income, interest and other income, and resident fees and services.

<h3 id="company-ohi">Omega Healthcare Investors (OHI)</h3>

*Health Care Real Estate · $15.1B · 3m -1.7% · 12m +13.5% · 24m +24.3%*

[Google Finance](https://www.google.com/finance/quote/OHI:NYSE?tab=earnings&hl=en)

Healthcare REIT healthcare REIT focused on skilled nursing and assisted living facilities.

Omega Healthcare Investors Inc is a real estate investment trust that invests in healthcare-related real estate properties located in the United States (U.S.), the United Kingdom (U.K.), and Canada. The company's objective is to provide attractive returns to investors while serving as the preferred capital partner to its third-party healthcare operating companies and affiliates, as well as other third-party healthcare operators, allowing them to focus on delivering a high level of care to their resident patients. Omega's investment portfolio mainly consists of skilled nursing facilities, assisted living facilities (ALFs), including care homes in the U.K., independent living facilities, rehabilitation and acute care facilities, and continuing care retirement communities.

<h3 id="company-well">Welltower (WELL)</h3>

*Health Care Real Estate · $166.9B · 3m +10.2% · 12m +44.6% · 24m +103.2%*

[Google Finance](https://www.google.com/finance/quote/WELL:NYSE?tab=earnings&hl=en)

Largest healthcare REIT, focused on senior housing, outpatient medical, and wellness-oriented healthcare properties.

Welltower owns a diversified healthcare portfolio of 2,800 in-place properties spread across the senior housing, medical office, and skilled nursing/postacute care sectors. The portfolio includes over 900 properties in Canada and the United Kingdom as the company looks for additional investment opportunities in countries with mature healthcare systems that operate similarly to that of the United States.

<h3 id="company-ctre">CareTrust REIT (CTRE)</h3>

*Health Care Real Estate · $9.6B · 3m -5.8% · 12m +14.4% · 24m +39.3%*

[Google Finance](https://www.google.com/finance/quote/CTRE:NYSE?tab=earnings&hl=en)

Healthcare REIT focused on skilled nursing, senior housing, and other post-acute care facilities.

CareTrust REIT Inc is a self-administered, publicly traded REIT engaged in the ownership, acquisition, financing, development, and leasing of skilled nursing, seniors housing, and other healthcare-related properties. The company has one reportable segment consisting of investments in healthcare-related real estate assets. It generates revenues by leasing healthcare-related properties to healthcare operators under triple-net lease arrangements, in which the tenant is solely responsible for property-related costs. The company operates in Domestic and Foreign markets, with the majority of revenue coming from Domestic operations.

<h3 id="company-sbra">Sabra Health Care REIT (SBRA)</h3>

*Health Care Real Estate · $5.3B · 3m -1.7% · 12m +10.1% · 24m +25.5%*

[Google Finance](https://www.google.com/finance/quote/SBRA:NASDAQ?tab=earnings&hl=en)

healthcare REIT focused on skilled nursing, senior housing, and behavioral health properties.

Sabra Health Care REIT Inc is a healthcare facility real estate investment trust. The company operates one segment that owns and invests in healthcare real estate. All of the company's revenue is generated in the United States. Sabra's operations consist of nursing facilities, assisted living centers, and mental health facilities.

<h3 id="company-prva">Privia Health Group (PRVA)</h3>

*Value-Based Care · $3.0B · 3m -4.1% · 12m +3.4% · 24m +10.6%*

[Google Finance](https://www.google.com/finance/quote/PRVA:NASDAQ?tab=earnings&hl=en)

Value-based care company focusing on physician enablement for independent practices.

Privia Health Group Inc is one of the physician enablement companies in the United States with a presence in around 24 states and the District of Columbia. The group builds scaled provider networks with primary-care centric medical groups, risk-bearing entities, a physician-led governance structure, and the Privia Platform comprising an extensive suite of technology and service solutions. It collaborates with medical groups, health plans, and health systems to optimize approximately 1,300+ physician practices, improve the patient experience for over 5.8+ million patients, and reward around 5,300+ physicians and practitioners for delivering high-value care.

<h3 id="company-asth">Astrana Health (ASTH)</h3>

*Value-Based Care · $1.8B · 3m +6.7% · 12m +39.1% · 24m -15.4%*

[Google Finance](https://www.google.com/finance/quote/ASTH:NASDAQ?tab=earnings&hl=en)

Physician centric management company that operates and coordinates provider networks to take on risk contracts.

Astrana Health Inc is a patient-centered, physician-centric integrated population health management company. The company is working to provide coordinated, outcomes-based medical care cost-effectively. It is focused on physicians providing high-quality medical care, population health management, and care coordination for patients, particularly senior patients and patients with multiple chronic conditions. The company's three reportable segments are Care Partners, Care Delivery, and Care Enablement. It generates the majority of its revenue from the Care Partners segment.

<h3 id="company-agl">Agilon Health (AGL)</h3>

*Value-Based Care · $2.1B · 3m +18.6% · 12m +249.2% · 24m -20.1%*

[Google Finance](https://www.google.com/finance/quote/AGL:NYSE?tab=earnings&hl=en)

Value-based care company focused on partnerships with primary care physicians for Medicare Advantage seniors.

Agilon Health Inc is a healthcare services company that partners with primary care physicians to support value-based care for senior patients. The company provides a platform that enables physician groups to manage healthcare outcomes and costs through a Medicare-centric, capitated care model and long-term partnerships with community-based physicians.

<h3 id="company-evh">Evolent Health (EVH)</h3>

*Value-Based Care · $347.6M · 3m +18.2% · 12m -49.7% · 24m -82.9%*

[Google Finance](https://www.google.com/finance/quote/EVH:NYSE?tab=earnings&hl=en)

Specialty-care management and healthcare-services company focused on oncology, cardiology, and musculoskeletal care.

Evolent Health Inc is engaged in healthcare delivery and payment. The company supports health systems and physician organizations in their migration toward value-based care and population health management. It provides specialty care management services in oncology, cardiology, musculoskeletal markets and holistic total cost of care management along with an integrated platform for health plan administration and value-based business infrastructure under one go to market package. The solutions provided by the company includes: Oncology, Cardiology, Musculoskeletal, Administrative Services, Advanced Illness, Genetic Testing, Physical Medicine, Radiology, and Surgical Management.

<h3 id="company-piii">P3 Health (PIII)</h3>

*Value-Based Care · $32.7M · 3m -5.4% · 12m +57.7% · 24m -64.3%*

[Google Finance](https://www.google.com/finance/quote/PIII:NASDAQ?tab=earnings&hl=en)

Physician-led population ehalth company focused on coordinating care for Medicare Advantage Patients.

P3 Health Partners Inc is a patient-centered and physician-led population health management company. P3's model aggregates and supports the community's existing healthcare resources to build a network of community providers working together to deliver coordinated and integrated care to patients with a shared commitment to improving patient outcomes, lowering cost, and delivering experience for all. It includes utilization management, care management, disease education, and maintenance of a quality improvement and quality management program for members assigned to the Company. The Company is also responsible for the credentialing of its providers, processing and payment of claims, and the establishment of a provider network for certain health plans.

<h3 id="company-dva">Davita (DVA)</h3>

*Outpatient and Home Providers · $15.4B · 3m -9.9% · 12m +33.0% · 24m +19.8%*

[Google Finance](https://www.google.com/finance/quote/DVA:NYSE?tab=earnings&hl=en)

One of two dominant US dialysis providers.

DaVita is one of the largest providers of dialysis services in the United States, boasting a market share of about 35%. The firm operates over 3,200 facilities worldwide, mostly in the US, and treats about 300,000 patients annually. Government payers dominate US dialysis reimbursement. DaVita receives about two-thirds of US sales at government (primarily Medicare) reimbursement rates, with the remainder coming from commercial insurers. While commercial insurers represent only about 10% of US patients treated, they represent nearly all of the profits generated by DaVita in the US dialysis business.

<h3 id="company-fms">Fresenius (FMS)</h3>

*Outpatient and Home Providers · $13.8B · 3m +10.0% · 12m -5.2% · 24m +25.3%*

[Google Finance](https://www.google.com/finance/quote/FMS:NYSE?tab=earnings&hl=en)

Global leaders in dialysis clinics, equipment, and renal services.

Fresenius Medical Care is the largest dialysis company in the world, treating nearly 300,000 patients from about 3,600 clinics worldwide as of December 2025. In addition to providing dialysis services, the firm is a leading supplier of dialysis products, including machines, dialyzers, and concentrates. Fresenius accounts for about 35% of the global dialysis products market, creating the world's only fully integrated dialysis business. Services account for about three-fourths of sales, while the balance is generated from medical technology products that enable dialysis treatments.

<h3 id="company-sgry">Surgery Partners (SGRY)</h3>

*Outpatient and Home Providers · $2.0B · 3m +7.7% · 12m -34.1% · 24m -48.2%*

[Google Finance](https://www.google.com/finance/quote/SGRY:NASDAQ?tab=earnings&hl=en)

Operator of Ambulatory Surgery Centers.

Surgery Partners Inc is a healthcare services company with an integrated outpatient delivery model focused on providing quality, cost-effective solutions for surgical and related ancillary care in support of both patients and physicians. It has one reportable segment: Surgical Facilities, which includes the operation of ASCs, surgical hospitals, anesthesia services, and multi-specialty physician practices, which earn revenues from contracts with patients in which the performance obligations are to provide health care services.

<h3 id="company-opch">Option Care Health (OPCH)</h3>

*Outpatient and Home Providers · $3.4B · 3m +22.7% · 12m -15.4% · 24m -23.7%*

[Google Finance](https://www.google.com/finance/quote/OPCH:NASDAQ?tab=earnings&hl=en)

Largest independent provider of home and alternate-site infusion therapy services in the United States.

Option Care Health Inc is the provider of home and alternate-site infusion services. It provides treatment for bleeding disorders, neurological disorders, heart failure, anti-infectives, and chronic inflammatory disorders, among others. The Company operates in one segment, infusion services.

<h3 id="company-lfst">Lifestance Health (LFST)</h3>

*Outpatient and Home Providers · $4.0B · 3m +62.4% · 12m +128.3% · 24m +119.8%*

[Google Finance](https://www.google.com/finance/quote/LFST:NASDAQ?tab=earnings&hl=en)

Outpatient behavioral-health providers of psychiatry and therapy services.

LifeStance Health Group Inc is a mental healthcare company that operates as a provider of outpatient mental health services, spanning psychiatric evaluations and treatment, psychological and neuropsychological testing, and individual, family, and group therapy. It treats a broad range of mental health conditions, including anxiety, depression, bipolar disorder, eating disorders, psychotic disorders, and post-traumatic stress disorder, using evidence-based approaches to ensure effective treatment. The group has a single operating and reportable segment of mental health services.

<h3 id="company-che">Chemed (Vitas) (CHE)</h3>

*Outpatient and Home Providers · $7.1B · 3m +22.6% · 12m +19.7% · 24m -7.5%*

[Google Finance](https://www.google.com/finance/quote/CHE:NYSE?tab=earnings&hl=en)

Hospice and end of life provider through VITAS healthcare.

Chemed Corp purchases, operates, and divests subsidiaries engaged in diverse business activities to maximize shareholder value. The company operates in the following segments: VITAS and Roto-Rooter. The VITAS segment generates the majority of the firm's revenue and provides hospice and palliative care services to patients with terminal illnesses through a network of physicians, registered nurses, home health aides, social workers, and volunteers. The Roto-Rooter segment provides plumbing, drain cleaning, water restoration, and related services to residential and commercial customers.

<h3 id="company-adus">Addus HomeCare (ADUS)</h3>

*Outpatient and Home Providers · $2.1B · 3m +27.6% · 12m +0.8% · 24m -11.6%*

[Google Finance](https://www.google.com/finance/quote/ADUS:NASDAQ?tab=earnings&hl=en)

Provider of personal care, hospice, and home health services.

Addus HomeCare Corp is engaged in the provision of in-home care services. The Company has three reportable segments: Personal Care, Hospice, and Home Health. The Personal Care segment provides non-medical assistance with activities of daily living, mainly to the elderly, chronically ill, and disabled individuals. The Hospice segment provides physical, emotional, and spiritual care for terminally ill patients and their families. The Home Health segment provides medical services to individuals requiring care during illness or recovery. It generates the majority of its revenue from the Personal Care segment.

<h3 id="company-pntg">Pennant Group (PNTG)</h3>

*Outpatient and Home Providers · $1.3B · 3m +10.6% · 12m +55.7% · 24m +23.9%*

[Google Finance](https://www.google.com/finance/quote/PNTG:NASDAQ?tab=earnings&hl=en)

provider of home health, hospice, and senior living services.

Pennant Group Inc is engaged in providing healthcare services to patients of all ages, including the growing senior population, in the United States. It operates in multiple lines of business including home health, hospice, and senior living which includes the company's assisted living, independent living, and memory care communities across Arizona, California, Colorado, Idaho, Montana, Nevada, Oklahoma, Oregon, Texas, Utah, Washington, Wisconsin, and Wyoming. It operates in two segments; home health and hospice services and senior living services. The company generates majority of its revenue from home health and hospice services segment, which includes its home health, hospice and home care businesses.

<h3 id="company-usph">US Physical Therapy (USPH)</h3>

*Outpatient and Home Providers · $1.2B · 3m +29.3% · 12m -5.3% · 24m -3.5%*

[Google Finance](https://www.google.com/finance/quote/USPH:NYSE?tab=earnings&hl=en)

operator of outpatient physical therapy clinics and industrial injury prevention services.

US Physical Therapy Inc through its subsidiaries operate outpatient physical therapy clinics that provide pre-and post-operative care and treatment for orthopedic-related disorders, sports-related injuries, preventative care, rehabilitation of injured workers, and neurological-related injuries. The principal payment sources for the clinics' services are managed care programs, commercial health insurance, Medicare/Medicaid, workers' compensation insurance, and proceeds from personal injury cases. Its operating segment includes Physical therapy operations and Industrial injury prevention services. The company generates maximum revenue from the Physical therapy operations segment.

<h3 id="company-btsg">BrightSpring Health Services (BTSG)</h3>

*Outpatient and Home Providers · $12.4B · 3m +6.6% · 12m +175.0% · 24m +413.8%*

[Google Finance](https://www.google.com/finance/quote/BTSG:NASDAQ?tab=earnings&hl=en)

provider of home and community-based healthcare services, including pharmacy, rehabilitation, primary care, and hospice.

BrightSpring Health Services Inc is a home and community-based healthcare services platform, focused on delivering complementary pharmacy and provider services to complex patients. Its platform delivers clinical services and pharmacy solutions across Medicare, Medicaid, and commercially insured populations. Its segments include Pharmacy Solutions, Provider Services, and others. It generates the majority of its revenue from the Pharmacy Solutions segment.

<h3 id="company-avah">Aveanna Healthcare (AVAH)</h3>

*Outpatient and Home Providers · $2.0B · 3m +59.6% · 12m +74.0% · 24m +147.9%*

[Google Finance](https://www.google.com/finance/quote/AVAH:NASDAQ?tab=earnings&hl=en)

provider of pediatric and adult home healthcare, private-duty nursing, and hospice services.

Aveanna Healthcare Holdings Inc is a diversified home care platform that provides care to medically complex, high-cost patient populations. It directly addresses the pressing challenges facing the U.S. healthcare system by providing safe, high-quality care in the home. The firm provides its services through three segments: Private Duty Services (PDS); Home Health & Hospice (HHH); and Medical Solutions (MS). The Private Duty Services segment generates the majority of revenue, which includes private duty skilled nursing services, non-clinical and personal care services, and pediatric therapy services, and is principally reimbursed by Medicaid and Medicaid MCO.

<h3 id="company-tdoc">Teladoc (TDOC)</h3>

*Digital Health, Specialty, Benefits · $1.2B · 3m +7.1% · 12m -9.4% · 24m -4.2%*

[Google Finance](https://www.google.com/finance/quote/TDOC:NYSE?tab=earnings&hl=en)

Largest pure-play virtual care platform, offering telemedicine, chronic-care management, and specialty virtual health services.

Teladoc Health Inc is engaged in the provision of virtual healthcare services, connecting patients, providers, and healthcare systems through technology-enabled platforms. The company has two reportable segments: Integrated Care and BetterHelp. The Integrated Care segment provides virtual healthcare solutions, including primary care, mental health, chronic care management, and telehealth enablement services for employers, insurers, and healthcare systems, mainly on a business-to-business basis, while the BetterHelp segment offers direct-to-consumer online mental health services, including counseling and therapy delivered through digital platforms. It generates the majority of its revenue from the Integrated Care segment.

<h3 id="company-amwl">Amwell (AMWL)</h3>

*Digital Health, Specialty, Benefits · $179.6M · 3m +64.5% · 12m +74.1% · 24m +43.8%*

[Google Finance](https://www.google.com/finance/quote/AMWL:NYSE?tab=earnings&hl=en)

Telehealth infrastructure company providing virtual-care technology.

American Well Corp is an enterprise platform and software company digitally enabling hybrid care by offering payers and health systems a technology-enabled care platform. The Amwell Platform, its cloud-based enablement platform, digitally enables a scalable healthcare experience across all care settings by enabling critical services like virtual primary care, urgent care, clinical partner programs, scheduling visits, etc. Additionally, the healthcare providers can use the platform to access familiar workflows for taking notes, prescribing, referencing clinical treatment guidelines, and other related activities. The firm also offers various paid services, including licensed clinical staffing, implementation support, workflow design, etc, to help clients execute their hybrid care strategies.

<h3 id="company-talk">Talkspace (TALK)</h3>

*Digital Health, Specialty, Benefits · $874.4M · 3m +1.0% · 12m +105.1% · 24m +198.3%*

[Google Finance](https://www.google.com/finance/quote/TALK:NASDAQ?tab=earnings&hl=en)

Digital behavioral-health company providing online therapy and mental-health services through employers and health-plans.

Talkspace Inc is a virtual behavioral healthcare company offering its members convenient and affordable access to a fully-credentialed network of qualified providers across a wide and growing spectrum of care through virtual psychotherapy and psychiatry. It is a single destination for comprehensive mental health care, including therapy for individuals, couples, and teens, as well as psychiatric treatment and medication management (18+), and self-guided tools and resources. The company's customers include Health insurance plans from commercial and government institutions, and employee assistance programs, Direct-to-Enterprise, and Individual subscribers. The company operates as a single segment.

<h3 id="company-hims">Hims &amp; Hers (HIMS)</h3>

*Digital Health, Specialty, Benefits · $6.4B · 3m +12.4% · 12m -38.8% · 24m +80.7%*

[Google Finance](https://www.google.com/finance/quote/HIMS:NYSE?tab=earnings&hl=en)

Direct-to-Consumer telehealth platform for primary care, weight management, mental health, sexual health, and wellness.

Hims & Hers, launched in 2017, is a telehealth platform that connects patients and healthcare providers to offer treatment options for specialties like erectile dysfunction, hair loss, skin care, mental health, and weight loss. Its offerings include generic, branded, and compounded prescription drugs as well as over-the-counter medicines, cosmetics, and supplements. The platform, which has more than 2 million subscribers, is available in all 50 states and certain European markets like the UK. It includes provider networks, electronic medical records, cloud pharmacy fulfillment, and personalization capabilities. Hims does not take insurance and only accepts payments directly from customers.

<h3 id="company-lfmd">LifeMD (LFMD)</h3>

*Digital Health, Specialty, Benefits · $169.3M · 3m -20.3% · 12m -46.3% · 24m -33.8%*

[Google Finance](https://www.google.com/finance/quote/LFMD:NASDAQ?tab=earnings&hl=en)

Virtual primary-care and telehealth company known for chronic condition management.

LifeMD Inc is a patient-centric, direct-to-patient healthcare company providing a high-quality, cost-effective, and convenient way for patients to access virtual medical care and pharmacy services. The Company's portfolio of brands within continuing operations is now managed as a single operating segment, Telehealth. Telehealth platform integrates core capabilities, includes: A nationwide pharmacy network, A wholly-owned commercial pharmacy, A fully integrated patient care center, A direct-to-patient marketing infrastructure for acquisition and retention, and AI-enabled clinical and operational technologies.

<h3 id="company-omda">Omada Health (OMDA)</h3>

*Digital Health, Specialty, Benefits · $1.2B · 3m +45.2% · 12m +17.1% · 24m n/a*

[Google Finance](https://www.google.com/finance/quote/OMDA:NASDAQ?tab=earnings&hl=en)

Virtual chronic-care platform focused on diabetes, hypertension, obesity, and musculoskeletal conditions through employers and health plans.

Omada Health Inc empowers individuals to make lasting health changes through personalized, virtual care between doctor's visits. The integrated platform of the company supports members with cardiometabolic conditions like prediabetes, diabetes, hypertension, musculoskeletal issues, and behavioral health needs. The company's specialized care tracks also assist members using GLP-1 medications. The company delivers measurable health outcomes and value for employers, health plans, health systems, and pharmacy benefit managers.

<h3 id="company-gdrx">GoodRx (GDRX)</h3>

*Digital Health, Specialty, Benefits · $1.0B · 3m +53.5% · 12m +0.0% · 24m -48.0%*

[Google Finance](https://www.google.com/finance/quote/GDRX:NASDAQ?tab=earnings&hl=en)

Prescription-pricing and healthcare-shopping platform that helps consumers find discounts on medications and healthcare services.

GoodRx Holdings Inc is a consumer-focused digital healthcare platform that aims to lower the cost of healthcare in the United States. It operates a price comparison platform that provides consumers with curated, geographically relevant prescription pricing, and provides access to negotiated prices through codes that can be used to save money on prescriptions across the United States. GoodRx generates revenue from core business from pharmacy benefit managers (PBMs) that manage formularies and prescription transactions including establishing pricing between consumers and pharmacies. It also offers various healthcare products and services, including pharma manufacturer solutions, subscriptions, and telehealth services.

<h3 id="company-pgny">Progyny (PGNY)</h3>

*Digital Health, Specialty, Benefits · $2.5B · 3m +13.0% · 12m +12.3% · 24m +24.9%*

[Google Finance](https://www.google.com/finance/quote/PGNY:NASDAQ?tab=earnings&hl=en)

fertility and family-building benefits manager that provides employer-sponsored fertility, maternity, and women's health programs.

Progyny Inc is a benefits management company specializing in fertility, family building, and women's health benefits solutions. Its clients include employers across various industries. The fertility benefits solution consists of treatment services (Smart Cycles), access to the Progyny network of high-quality fertility specialists that perform the Smart Cycle treatments, and active management of the selective network of high-quality provider clinics.

<h3 id="company-con">Concentra Group (CON)</h3>

*Digital Health, Specialty, Benefits · $4.0B · 3m +37.0% · 12m +52.5% · 24m +51.3%*

[Google Finance](https://www.google.com/finance/quote/CON:NYSE?tab=earnings&hl=en)

leading provider of occupational health, workers’ compensation, and employer health services.

Concentra Group Holdings Parent Inc is a provider of occupational health services in the USA. The business is organized into three operating segments: occupational health centers, onsite health clinics, and other businesses.

<h3 id="company-hqy">HealthEquity (HQY)</h3>

*Digital Health, Specialty, Benefits · $8.8B · 3m +27.5% · 12m +16.5% · 24m +39.9%*

[Google Finance](https://www.google.com/finance/quote/HQY:NASDAQ?tab=earnings&hl=en)

administrator of health savings accounts (HSAs) and consumer-directed healthcare benefits.

HealthEquity Inc provides solutions that allow consumers to make healthcare saving and spending decisions. It provides payment processing services, personalized benefit information, the ability to earn wellness incentives, and investment advice to grow their tax-advantaged healthcare savings. It manages consumers' tax-advantaged health savings accounts (HSAs) and other consumer-directed benefits (CDBs) offered by employers, including flexible spending accounts and health reimbursement arrangements (FSAs and HRAs), and administers Consolidated Omnibus Budget Reconciliation Act (COBRA), commuter and other benefits. It also provides investment advisory services to customers whose account balances exceed a certain threshold. HealthEquity generates its revenue in the United States.

<h3 id="company-orcl">Oracle-Cerner (ORCL)</h3>

*Health IT and Data · $374.1B · 3m -22.0% · 12m -39.4% · 24m +9.5%*

[Google Finance](https://www.google.com/finance/quote/ORCL:NYSE?tab=earnings&hl=en)

Largest healthcare IT platform vendor, providing EHRs, clinical workflow software, and healthcare data infrastructure.

Oracle provides enterprise applications and infrastructure offerings through a variety of flexible IT deployment models, including on-premises, cloud-based, and hybrid. Founded in 1977, Oracle pioneered the first commercial SQL-based relational database management system, which is commonly used by the world's largest companies for high-volume online transaction processing workloads. Besides databases, Oracle also sells enterprise resource planning platforms and cloud infrastructure that play an increasingly important role in large language model training and inferencing.

<h3 id="company-mdrx">Veradigm (MDRX)</h3>

*Health IT and Data · n/a · 3m -4.0% · 12m +4.3% · 24m -50.0%*

[Google Finance](https://www.google.com/finance/quote/MDRX:NYSE?tab=earnings&hl=en)

Healthcare data, EHR (AllScripts) and interoperability.

VERADIGM INC

<h3 id="company-way">Waystar (WAY)</h3>

*Health IT and Data · $4.0B · 3m +38.2% · 12m -31.3% · 24m -3.8%*

[Google Finance](https://www.google.com/finance/quote/WAY:NASDAQ?tab=earnings&hl=en)

Healthcare payments and revenue cycle platform.

Waystar Holding Corp is a provider of mission-critical cloud technology to healthcare organizations. Its enterprise-grade platform transforms the complex and disparate processes comprising healthcare payments received by healthcare providers from payers and patients, from pre-service engagement through post-service remittance and reconciliation. its platform enhances data integrity, eliminates manual tasks, and improves claim and billing accuracy, which results in transparency, reduced labor costs, and faster, more accurate reimbursement and cash flow. The market for solutions extends throughout the United States and includes Puerto Rico and other USA Territories.

<h3 id="company-solv">Solventum (SOLV)</h3>

*Health IT and Data · $13.6B · 3m +19.3% · 12m +24.0% · 24m +49.1%*

[Google Finance](https://www.google.com/finance/quote/SOLV:NYSE?tab=earnings&hl=en)

Revenue-cycle, clinical documentation, coding, and healthcare workflow solutions.

Solventum Corp is a healthcare company developing, manufacturing, and commercializing solutions leveraging material science, data science, and digital capabilities to address customer and patient needs. Its segments include MedSurg, which earns maximum revenue and provides wound therapy, I.V. site management, surgical supplies, medical tapes and wraps, stethoscopes, medical electrodes, and OEM medical technologies; Dental Solutions, offering dental and orthodontic products such as brackets, restorative cements, and bonding agents; and Health Information Systems, providing software solutions including physician documentation, coding automation, speech recognition, and data visualization platforms. It operates in the United States, which earns the majority of revenue, and internationally.

<h3 id="company-phr">Phreesia (PHR)</h3>

*Health IT and Data · $663.2M · 3m +40.0% · 12m -57.2% · 24m -49.4%*

[Google Finance](https://www.google.com/finance/quote/PHR:NYSE?tab=earnings&hl=en)

Patient-intake and engagement platform that digitizes registration, scheduling, intake forms, payments, and communications.

Phreesia Inc is a provides an integrated software, payments, and engagement platform designed to address three foundational challenges in healthcare delivery: access to care, affordability of care, and patient health outcomes. Its platform is embedded directly into provider workflows and patient interactions, enabling healthcare organizations to activate patients, streamline administrative processes, and improve financial performance across the care continuum. The group serves a diverse group of healthcare organizations, including ambulatory practices, health systems, and hospitals, as well as life sciences companies, government entities, patient advocacy, public interest, and not-for-profit and other organizations.

<h3 id="company-ccsi">Consensus Cloud Solutions (CCSI)</h3>

*Health IT and Data · $669.7M · 3m +38.0% · 12m +51.0% · 24m +93.7%*

[Google Finance](https://www.google.com/finance/quote/CCSI:NASDAQ?tab=earnings&hl=en)

Healthcare-focused cloud communications company known for secure-faxing, interoperability, and clinical document exchange.

Consensus Cloud Solutions Inc is a provider of secure information delivery services with a scalable Software-as-a-Service SaaS platform. It is engaged in the fax cloud business. The company's offerings include communication, data extraction, and digital signature solutions that enable users to securely access, exchange, and manage information across organizational and geographic boundaries. It serves multiple industry verticals, including healthcare, government, financial services, legal, and education. Geographically, the company operates in the United States, Canada, Ireland, and other countries. It derives the maximum revenue from the United States.

<h3 id="company-dh">Definitive Healthcare (DH)</h3>

*Health IT and Data · $85.5M · 3m -20.9% · 12m -83.5% · 24m -84.1%*

[Google Finance](https://www.google.com/finance/quote/DH:NASDAQ?tab=earnings&hl=en)

Healthcare data providers for provider, hospital, physician, and payer intelligence databases.

Definitive Healthcare Corp is a provider of healthcare commercial intelligence. Its SaaS-based healthcare commercial intelligence platform is designed to provide comprehensive and accurate information on the healthcare ecosystem in the U.S. The platform uses deep analytics and data science to help customers develop data-driven strategic decisions, such as finding new markets to enter, building comprehensive go-to-market strategies, accessing tactical information to help target the right decision makers, and improving win rates with detailed contextual information. The company derives substantially all of its revenue from the sale of subscription fees for access to its platform and stand-ready support. Geographically, it derives a majority of its revenue from the United States.

<h3 id="company-iqv">Iqvia (IQV)</h3>

*Health IT and Data · $38.7B · 3m +39.9% · 12m +23.8% · 24m -1.2%*

[Google Finance](https://www.google.com/finance/quote/IQV:NYSE?tab=earnings&hl=en)

Dominant healthcare data, analytics, and contract research organization, supplying pharmaceutical companies with clinical reearch and commercial intelligence.

Iqvia is a global leader in clinical research and technology solutions for the life science industry. Formed in 2016 from the merger of Quintiles and IMS Health, it combined clinical trial services with extensive healthcare data and analytics. Its research and development solutions segment provides outsourced clinical development services spanning drug discovery, trial design, patient recruitment, site management, clinical testing, real-world studies, and the regulatory approval process. Its commercial solutions segment helps companies optimize product commercialization through analytics, technology, and outsourced sales and medical services. Together, Iqvia supports customers across the life science industry, and it serves biopharmaceutical firms, providers, payers, and policymakers.

<h3 id="company-hcat">Health Catalyst (HCAT)</h3>

*Health IT and Data · $154.4M · 3m +55.5% · 12m -36.6% · 24m -72.6%*

[Google Finance](https://www.google.com/finance/quote/HCAT:NASDAQ?tab=earnings&hl=en)

Healthcare analytics and data-platform company that helps providers improve clinical, operational, and financial performance.

Health Catalyst Inc provides data and analytics technology and services to healthcare organizations. It has two operating segments. The Technology segment, the key revenue driver, includes data platform, analytics applications and support services and generates revenues mainly from contracts that are cloud-based subscription arrangements, time-based license arrangements, and maintenance and support fees; the Professional Services segment is generally the combination of analytics, implementation, strategic advisory, outsourcing, and improvement services to deliver expertise to its customers to more fully configure and utilize the benefits of the technology offerings.

<h3 id="company-docs">Doximity (DOCS)</h3>

*Health IT and Data · $3.8B · 3m +30.7% · 12m -61.9% · 24m -30.6%*

[Google Finance](https://www.google.com/finance/quote/DOCS:NYSE?tab=earnings&hl=en)

Professional network for physicians, combining recruiting, communications, telehealth, and workflow tools.

Doximity Inc provides an online platform, which enables physicians and other healthcare professionals to collaborate with colleagues, stay up to date with the latest medical news and research, manage their careers and on-call schedules, streamline documentation and administrative paperwork, and conduct virtual patient visits. The Company's customers include pharmaceutical companies and health systems that connect with healthcare professionals through the Company's digital Marketing, Hiring, and Workflow Solutions. Marketing Solutions provide customers with the ability to share tailored content on the network. Hiring Solutions enable customers to identify, connect with, and hire from the network of both active and passive potential medical professional candidates.

<h3 id="company-veev">Veeva Systems (VEEV)</h3>

*Health IT and Data · $33.1B · 3m +53.4% · 12m -13.1% · 24m +26.6%*

[Google Finance](https://www.google.com/finance/quote/VEEV:NYSE?tab=earnings&hl=en)

Leading cloud-software provider for life sciences companies, supporting CRM, clinical trails, regulatory processes, and commercialization.

Veeva is the global leading supplier of cloud-based software solutions for the life sciences industry. The company's best-of-breed offerings address operating and regulatory requirements for customers ranging from small, emerging biotechnology companies to departments of global pharmaceutical manufacturers. The company leverages its domain expertise to improve the efficiency and compliance of the underserved life sciences industry, displacing large, highly customized and dated enterprise resource planning systems that have limited flexibility. Its two main products are Veeva CRM, a customer relationship management platform for companies with a salesforce, and Veeva Vault, a content management platform that tackles various functions within any life sciences company.

<h3 id="company-omcl">Omnicell (OMCL)</h3>

*Health IT and Data · $1.7B · 3m -13.5% · 12m +17.7% · 24m -12.3%*

[Google Finance](https://www.google.com/finance/quote/OMCL:NASDAQ?tab=earnings&hl=en)

Pharmacy automation, medication management, and healthcare workflow software.

Omnicell Inc provides automation and business analytics software for healthcare providers. The company is engaged in transforming the pharmacy and nursing care delivery model. The company helps its customers define and deliver cost-effective medication management designed to equip and empower pharmacists and nurses to focus on patient care rather than administrative tasks and drive improved clinical, operational, and financial outcomes across all care settings. The company derives the majority of its revenue from the United States.

<h3 id="company-mck">McKesson (MCK)</h3>

*Pharma Distribution · $97.2B · 3m +14.3% · 12m +29.1% · 24m +58.7%*

[Google Finance](https://www.google.com/finance/quote/MCK:NYSE?tab=earnings&hl=en)

Largest pharmaceutical distributor in North America.

McKesson is one of three leading pharmaceutical wholesalers in the US engaged in sourcing and distributing branded, generic, and specialty pharmaceutical products to pharmacies (retail chains, independent, and mail order), hospitals networks, and healthcare providers. Along with Cencora and Cardinal Health, the three account for over 90% of the US pharmaceutical wholesale industry. Outside the US market, McKesson engages in pharmaceutical wholesale and distribution in Canada. Additionally, the company supplies medical-surgical products and equipment to healthcare facilities and provides a variety of technology solutions for pharmacies.

<h3 id="company-cah">Cardinal Health (CAH)</h3>

*Pharma Distribution · $54.7B · 3m +20.5% · 12m +57.2% · 24m +114.1%*

[Google Finance](https://www.google.com/finance/quote/CAH:NYSE?tab=earnings&hl=en)

One of the big three drug wholesalesrs, providing pharma distribution, medical products, and supply chain services.

Cardinal Health is one of three leading pharmaceutical wholesalers in the US, engaged in sourcing and distributing of branded, generic, and specialty pharmaceutical products to pharmacies (retail chains, independent, and mail order), hospital networks, and healthcare providers. Cardinal, Cencora, and McKesson hold well over 90% of the US pharmaceutical wholesale industry. Cardinal Health also supplies medical-surgical products and equipment to healthcare facilities in North America, Europe, and Asia.

<h3 id="company-cor">Cencora (COR)</h3>

*Pharma Distribution · $59.6B · 3m +21.8% · 12m +7.2% · 24m +31.8%*

[Google Finance](https://www.google.com/finance/quote/COR:NYSE?tab=earnings&hl=en)

Formerly AmerisourceBergen, Global pharmaceutical distribution and specialty-services leader.

Cencora is one of three leading domestic pharmaceutical wholesalers. It sources and distributes branded, generic, and specialty pharmaceutical products to pharmacies (retail chains, independent, and mail order), hospital networks, and healthcare providers. It and McKesson and Cardinal Health hold over 90% share of the US pharmaceutical wholesale industry. Cencora also provides commercialization services for manufacturers of pharmaceuticals and medical devices, global specialty drug logistics (World Courier), and animal health product distribution (MWI Animal Health). Cencora expanded its international presence in 2021 by purchasing Alliance Healthcare, one of the leading drug wholesalers in Europe.

<h3 id="company-ahco">Accendra Health (AHCO)</h3>

*Pharma Distribution · $912.9M · 3m -45.5% · 12m -38.7% · 24m -44.5%*

[Google Finance](https://www.google.com/finance/quote/AHCO:NASDAQ?tab=earnings&hl=en)

Medical and Surgical supply distributor with a significant healthcare logistics business.

AdaptHealth Corp is engaged in providing patient-centered, healthcare-at-home solutions including home medical equipment (HME), medical supplies, and related services. The Company operates under four reportable segments that align with its product categories: (i) Sleep Health, (ii) Respiratory Health, (iii) Diabetes Health, and (iv) Wellness at Home. The company generates majority of its revenue from the Sleep Health segment. The Sleep Health segment provides sleep therapy equipment, supplies and related services (including continuous positive airway pressure and BiLevel services) to individuals for the treatment of obstructive sleep apnea.

<h3 id="company-hsic">Henry Schein (HSIC)</h3>

*Pharma Distribution · $10.2B · 3m +23.4% · 12m +32.3% · 24m +28.6%*

[Google Finance](https://www.google.com/finance/quote/HSIC:NASDAQ?tab=earnings&hl=en)

Leading dental product, tech, and physician office supply distributor.

Henry Schein Inc is a solutions company for healthcare professionals. It offers healthcare equipment, products, and services to office-based dental and medical practitioners, as well as alternative sites of care. The company's reportable segments are: Global Distribution and Value-Added Services, Global Specialty Products, and Global Technology. It generates maximum revenue from the Global Distribution and Value-Added Services segment, which includes distribution to the dental and medical markets of national brand and corporate brand merchandise, as well as equipment and related technical services. This segment also includes value-added services such as financial services, continuing education services, consulting, and other practice services.

<h3 id="company-ntra">Natera (NTRA)</h3>

*Precision Diagnostics · $39.4B · 3m +66.3% · 12m +90.1% · 24m +150.0%*

[Google Finance](https://www.google.com/finance/quote/NTRA:NASDAQ?tab=earnings&hl=en)

molecular diagnostics leader using cell-free DNA testing for prenatal screening, oncology monitoring, and transplant surveillance.

Natera Inc is a diagnostic and research company with proprietary molecular and bioinformatics technology. The company's key product offerings include its Panorama Non-Invasive Prenatal Test (NIPT) which screens for chromosomal abnormalities of a fetus as well as in twin pregnancies, typically with a blood draw from the mother, Horizon Carrier Screening (HCS) to determine carrier status for a large number of severe genetic diseases that could be passed on to the carrier's children, Signatera molecular residual disease (MRD) test, which detects circulating tumor DNA in patients previously diagnosed with cancer to assess molecular residual disease and monitor for recurrence; and Prospera, to assess organ transplant rejection.

<h3 id="company-neo">NeoGenomics (NEO)</h3>

*Precision Diagnostics · $2.1B · 3m +93.4% · 12m +156.7% · 24m -1.5%*

[Google Finance](https://www.google.com/finance/quote/NEO:NASDAQ?tab=earnings&hl=en)

precision oncology diagnostics company providing cancer testing, genomic profiling, and biomarker services.

NeoGenomics Inc provides oncology diagnostic testing and consultative services which include technical laboratory services and professional interpretation of laboratory test results by licensed physicians or molecular experts in pathology and oncology. The company operates a network of cancer-focused testing laboratories in the United States and the United Kingdom. The company operates in a single segment and derives revenue from clients by providing clinical cancer testing, interpretation, and consultative services, molecular and NGS testing, comprehensive technical and professional services offerings, clinical trials and research, validation laboratory services, and oncology data solutions.

<h3 id="company-blln">BillionToOne (BLLN)</h3>

*Precision Diagnostics · $6.5B · 3m +12.9% · 12m n/a · 24m n/a*

[Google Finance](https://www.google.com/finance/quote/BLLN:NASDAQ?tab=earnings&hl=en)

molecular diagnostics company focused on prenatal screening and precision oncology testing.

BillionToOne Inc is a molecular diagnostics company. It offers a portfolio of ultrasensitive tests covering prenatal genetic testing, cancer therapy selection, and response monitoring, which are based on its Quantitative Counting Templates (QCT) molecular counting platform. The company's product portfolio comprises UNITY, a portfolio of prenatal testing products that can conduct fetal risk analysis without requiring a paternal sample; Northstar Select, a ultrasensitive liquid biopsy test that provides insights into appropriate therapies for stage III or IV cancer patients; and Northstar Response, a tissue-free, pan-cancer, liquid biopsy test that measures several genomic loci uniquely methylated in cancer to provide insight into dynamic changes in therapy response.

<h3 id="company-gh">Guardant Health (GH)</h3>

*Precision Diagnostics · $21.4B · 3m +65.6% · 12m +167.0% · 24m +462.5%*

[Google Finance](https://www.google.com/finance/quote/GH:NASDAQ?tab=earnings&hl=en)

liquid-biopsy leader using blood-based genomic testing for cancer detection, treatment selection, and disease monitoring.

Guardant Health, based in Redwood City, California, is a leader in liquid-based cancer tests for clinical and research use. The company's main franchises are Guardant360 for genomic profiling of tumors, Reveal for molecular residual disease testing, and Shield for colorectal cancer screening. Additionally, Guardant offers research development services such as regulatory approval consultancy and clinical trial referrals.

<h3 id="company-tem">Tempus AI (TEM)</h3>

*Precision Diagnostics · $8.5B · 3m +18.6% · 12m -29.4% · 24m +2.4%*

[Google Finance](https://www.google.com/finance/quote/TEM:NASDAQ?tab=earnings&hl=en)

precision medicine company combining genomic testing, clinical data, and artificial intelligence to support treatment decisions and drug development.

Tempus AI Inc is a technology company. It has built the Tempus Platform, which comprises both a technology platform to free healthcare data from silos and an operating system to make the resulting data useful. Its Intelligent Diagnostics use AI, including generative AI, to make laboratory tests more accurate, tailored, and personal.

<h3 id="company-ilmn">Illumina (ILMN)</h3>

*Precision Diagnostics · $30.7B · 3m +33.9% · 12m +90.7% · 24m +46.5%*

[Google Finance](https://www.google.com/finance/quote/ILMN:NASDAQ?tab=earnings&hl=en)

leading DNA sequencing platform company providing foundational technology for genomics research and clinical testing.

Illumina provides tools and services to analyze genetic material with life science and clinical lab applications. The company generates over 90% of its revenue from sequencing instruments, consumables, and services. Illumina's high-throughput technology enables whole genome sequencing in humans and other large organisms. Its lower throughput tools enable applications that require smaller data outputs, such as viral and cancer tumor screening. Illumina also sells microarrays that enable lower-cost, focused genetic screening with primarily consumer and agricultural applications.

<h3 id="company-txg">10x Genomics (TXG)</h3>

*Precision Diagnostics · $6.1B · 3m +164.6% · 12m +319.8% · 24m +157.9%*

[Google Finance](https://www.google.com/finance/quote/TXG:NASDAQ?tab=earnings&hl=en)

leader in single-cell and spatial biology technologies used in genomics research and drug discovery.

10x Genomics Inc is a life science technology company based in the United States. Its solutions include instruments, consumables, and software for analyzing biological systems. The company's integrated solutions include instruments, consumables, and software for analyzing biological systems at a resolution and scale that matches the complexity of biology. Its product offerings include a Chromium platform comprising microfluidic chips and related consumables, Chromium X series, Visium and Xenium platforms, and others, which are predominantly used for the study of biological components. Geographically, the company derives operates from the United States and the rest from Americas (excluding the United States), Europe, Middle East and Africa, China, and Asia-Pacific (excluding China).

<h3 id="company-pacb">PacBio (PACB)</h3>

*Precision Diagnostics · $447.3M · 3m +2.7% · 12m -12.2% · 24m -26.3%*

[Google Finance](https://www.google.com/finance/quote/PACB:NASDAQ?tab=earnings&hl=en)

developer of long-read DNA sequencing technologies used to analyze complex genomes.

Pacific Biosciences of California Inc is a biotechnology company focused on designing, developing, and manufacturing sequencing solutions that enable scientists and clinical researchers to improve their understanding of the genome and ultimately, resolve genetically complex problems. It operates in, one reportable segment: the development, manufacturing, and marketing of an integrated platform for genetic analysis. The majority of the company's revenue is derived from Americas, followed by Europe Middle East, and Africa and Asia-Pacific.

<h3 id="company-qdel">QuidelOrtho (QDEL)</h3>

*Precision Diagnostics · $1.2B · 3m +38.6% · 12m -44.9% · 24m -67.5%*

[Google Finance](https://www.google.com/finance/quote/QDEL:NASDAQ?tab=earnings&hl=en)

diagnostics company providing clinical laboratory, immunoassay, and point-of-care testing solutions.

QuidelOrtho Corp is engaged in the development, manufacturing, and marketing of rapid diagnostic testing solutions. The company is engaged in immunoassay and molecular testing, clinical chemistry, and transfusion medicine, which helps clinicians and patients to make decisions across the globe. Geographically, the company has its presence in North America, EMEA, China, and Other countries. It generates the majority of its revenue from North America.

<h3 id="company-dgx">Quest Diagnostics (DGX)</h3>

*Precision Diagnostics · $25.8B · 3m +25.6% · 12m +30.4% · 24m +54.8%*

[Google Finance](https://www.google.com/finance/quote/DGX:NYSE?tab=earnings&hl=en)

largest U.S. independent clinical laboratory and diagnostic testing company.

Quest Diagnostics is a leading independent provider of diagnostic testing, information, and services in the US. The company generates over 97% of its revenue through clinical testing, anatomic pathology, esoteric testing, and substance abuse testing with specimens collected at its national network of roughly 2,400 patient service centers, as well as multiple doctors offices and hospitals. The firm also runs a much smaller diagnostic solutions segment that provides clinical trials testing, risk-assessment services, and information technology solutions.

<h3 id="company-lh">Labcorp Holdings (LH)</h3>

*Precision Diagnostics · $25.3B · 3m +27.0% · 12m +17.7% · 24m +39.8%*

[Google Finance](https://www.google.com/finance/quote/LH:NYSE?tab=earnings&hl=en)

leading diagnostics and laboratory services company with substantial genomic and specialty testing capabilities.

Labcorp is one of the nation's two largest independent clinical laboratories, with roughly 20% of the independent lab market. The company operates approximately 2,000 patient-service centers, offering a broad range of 5,000 clinical lab tests, ranging from uncomplicated routine blood and urine screens to complex oncology and genomic testing.

<h3 id="company-cert">Certara (CERT)</h3>

*Precision Diagnostics · $1.2B · 3m +78.6% · 12m -27.4% · 24m -33.6%*

[Google Finance](https://www.google.com/finance/quote/CERT:NASDAQ?tab=earnings&hl=en)

biosimulation and data-driven drug development company supporting precision medicine and clinical development.

Certara Inc accelerates medicines to patients using biosimulation software and technology to transform traditional drug discovery and development. It provides modeling and simulation, regulatory science, and assessment software and services to help clients reduce clinical trials, accelerate regulatory approval, and increase patient access to medicines. The company has its business presence in the Americas, which is also its key revenue-generating market, EMEA, and the Asia Pacific region.

