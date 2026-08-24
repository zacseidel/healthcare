# Healthcare Intel Digest

<div class="report-meta"><span><strong>Week of August 24, 2026</strong></span><span>Market data through: August 21, 2026</span><span>Narrative created: August 24, 2026</span></div>

Weekly review of healthcare services, technology, distribution, and diagnostic company performance, changes, earnings activity, and strategy narrative.

## In the News

<nav class="strategy-narrative-links" aria-label="Strategy narrative sections">
<ul>
<li><a href="#strategy-executive-view-1-epic-s-prior-authorization-advance-confirms-its-moat-and-raises-the-stakes-of-the-ftc-inquiry">1. Epic’s prior-authorization advance confirms its moat—and raises the stakes of the FTC inquiry</a></li>
<li><a href="#strategy-executive-view-2-r1-s-humata-acquisition-pulls-prior-authorization-into-the-revenue-cycle-operating-system">2. R1’s Humata acquisition pulls prior authorization into the revenue-cycle operating system</a></li>
<li><a href="#strategy-executive-view-3-aetna-is-selectively-suppressing-ma-growth-through-broker-economics">3. Aetna is selectively suppressing MA growth through broker economics</a></li>
<li><a href="#strategy-executive-view-4-the-2027-employer-cost-outlook-increases-demand-for-intervention-but-raises-the-roi-bar">4. The 2027 employer-cost outlook increases demand for intervention—but raises the ROI bar</a></li>
<li><a href="#strategy-executive-view-5-cityblock-homeward-shows-where-value-based-care-capital-remains-available">5. Cityblock-Homeward shows where value-based-care capital remains available</a></li>
<li><a href="#strategy-executive-view-6-rural-health-transformation-funding-is-becoming-an-addressable-technology-market">6. Rural Health Transformation funding is becoming an addressable technology market</a></li>
</ul>
</nav>

<h3 id="executive-view">Executive View</h3>

- **Prior authorization moved from disclosure to production infrastructure.** Epic activated real-time coverage-requirement checks at four health systems, while R1 agreed to acquire Humata Health to integrate authorization automation into its revenue-cycle platform. This strengthens demand for end-to-end workflows and weakens the position of isolated point solutions. ([epic.com](https://www.epic.com/epic/newsroom/?_rsc=1g62m&utm_source=openai))
- **Epic’s expanding workflow control now carries greater regulatory risk.** Reports of an early-stage FTC antitrust inquiry into data access and interoperability qualify last week’s thesis that Epic’s network is becoming an increasingly powerful moat. No charges have been brought, but access policies are now a strategic variable for vendors and health-system customers. ([statnews.com](https://www.statnews.com/2026/08/14/epic-systems-ftc-review-nda-use-possible-anticompetitive-practices/?utm_source=openai))
- **Aetna is using distribution controls to constrain selected 2027 Medicare Advantage enrollment.** The carrier confirmed that certain plans will become noncommissionable on September 15, 2026, and others on January 1, 2027—an enrollment throttle that protects local economics without requiring a full market exit. ([beckerspayer.com](https://www.beckerspayer.com/payer/medicare-advantage/aetna-to-cut-medicare-advantage-broker-commissions-again/?utm_source=openai))
- **Commercial affordability pressure worsened.** Aon projects employer health costs will rise 9.5% in 2027 to more than $19,000 per employee. Although this is a consultant forecast rather than realized claims experience, it strengthens the case for more aggressive network, pharmacy, payment-integrity and utilization interventions. ([prnewswire.com](https://www.prnewswire.com/news-releases/aon-us-employer-health-care-costs-continue-multi-year-climb-projected-to-rise-9-5-in-2027--302855864.html?utm_source=openai))
- **Capital is returning to scaled government-program care models, not undifferentiated value-based-care platforms.** Cityblock’s proposed acquisition of Homeward Health, alongside a $116 million financing, combines Medicaid, dual-eligible and rural MA capabilities. ([cityblock.com](https://www.cityblock.com/homeward?utm_source=openai))
- **Overall environment: modestly deteriorated for payer affordability and MA growth, mixed for providers, and improved for selected health-technology demand—especially authorization, interoperability, cybersecurity and government-program care orchestration.**

The week’s thesis is that healthcare infrastructure is becoming a tool for **controlling growth and allocating scarce capacity**, not merely reducing administrative expense. I am not repeating last week’s prior-authorization denial benchmarks, No Surprises Act ruling, Epic imaging exchange or Medicaid coding-enforcement story; none received a more consequential update than the developments below.

<h3 id="strategy-executive-view-1-epic-s-prior-authorization-advance-confirms-its-moat-and-raises-the-stakes-of-the-ftc-inquiry">1. Epic’s prior-authorization advance confirms its moat—and raises the stakes of the FTC inquiry</h3>

**Status:** UPDATE

**What happened**

On August 17, Epic announced live, real-time prior-authorization requirement checks at Ochsner Health, Froedtert ThedaCare Health, Denver Health and Summit Health. The initial workflow uses Coverage Requirements Discovery to tell clinicians inside the EHR whether authorization is required; Epic’s broader architecture also supports documentation and electronic submission through the DTR and PAS standards. [Epic, “Payers, Providers, and Epic Launch Real-Time Prior Authorization Checks,” August 17, 2026](https://www.epic.com/epic/newsroom/) and [Epic on FHIR, “CMS-0057 Prior Authorization APIs”](https://fhir.epic.com/documentation?docid=fhir). ([epic.com](https://www.epic.com/epic/newsroom/?_rsc=1g62m&utm_source=openai))

Separately, Epic responded during the week to reports that the FTC is examining whether its data-access and employment practices inhibit competition. The inquiry is preliminary, the FTC has not announced an enforcement action, and Epic denies anticompetitive conduct. [STAT, “Epic’s alleged anti-competitive practices under scrutiny,” August 14, 2026](https://www.statnews.com/2026/08/14/epic-systems-ftc-review-nda-use-possible-anticompetitive-practices/) and [Healthcare IT News, “Epic responds to potential FTC antitrust probe,” August 18, 2026](https://www.healthcareitnews.com/news/epic-responds-potential-ftc-antitrust-probe). ([statnews.com](https://www.statnews.com/2026/08/14/epic-systems-ftc-review-nda-use-possible-anticompetitive-practices/?utm_source=openai))

**Why it matters**

Last week’s view—that Epic is turning interoperability into workflow infrastructure—was strengthened operationally but qualified competitively. Embedding payer rules at order entry can reduce authorization-related cancellations, manual portal work and avoidable denials. Yet the more workflows depend on Epic-mediated data access, the more consequential its commercial and technical access policies become.

**Strategist implication**

Near term, Epic gains leverage over authorization vendors because it controls clinician workflow and can offer health systems a lower-friction implementation path. Longer term, an access remedy or stronger interoperability enforcement could improve the position of neutral third-party applications. Payers should therefore avoid Epic-only designs and measure whether CRD deployment progresses to complete documentation, submission and appeal workflows.

**Watch next**

Formal FTC action, if any; payer adoption beyond initial connections; and evidence that DTR and PAS reduce missing-document denials rather than simply accelerating requirement checks.

---

<h3 id="strategy-executive-view-2-r1-s-humata-acquisition-pulls-prior-authorization-into-the-revenue-cycle-operating-system">2. R1’s Humata acquisition pulls prior authorization into the revenue-cycle operating system</h3>

**Status:** NEW

**What happened**

On August 18, R1 agreed to acquire Humata Health, an AI-enabled prior-authorization company, and integrate it into R1’s Phare operating system across authorization, utilization review, documentation and coding. Transaction value was not disclosed. [R1, “R1 to Acquire Humata Health,” August 18, 2026](https://www.r1rcm.com/newsroom/r1-to-acquire-humata-health-enhancing-phare-os-with-ai-powered-prior-authorization-automation-and-payer-provider-collaboration). ([r1rcm.com](https://www.r1rcm.com/newsroom/r1-to-acquire-humata-health-enhancing-phare-os-with-ai-powered-prior-authorization-automation-and-payer-provider-collaboration?utm_source=openai))

**Why it matters**

Authorization is moving upstream from denial management into claim construction. R1 can now connect whether approval was required, what evidence the payer requested, what was submitted, how the service was documented and whether the eventual claim was paid correctly.

**Strategist implication**

This confirms that pre-bill authorization is becoming a core RCM platform module, not a standalone administrative tool. Providers should expect bundled contracting around authorization-related denials, cash acceleration and staff touches. Independent authorization vendors will increasingly need payer connectivity, differentiated clinical-policy intelligence or distribution through EHR and RCM partners.

The strongest product KPI is no longer “touchless authorization rate.” It is the downstream combination of first-pass approval, avoided cancellations, clean claims, lower appeal volume and net collection yield.

**Watch next**

Customer migration from existing R1 workflows, payer participation and disclosed outcome metrics after integration.

---

<h3 id="strategy-executive-view-3-aetna-is-selectively-suppressing-ma-growth-through-broker-economics">3. Aetna is selectively suppressing MA growth through broker economics</h3>

**Status:** UPDATE

**What happened**

Aetna confirmed on August 21 that certain Medicare Advantage plans will become noncommissionable for new broker-driven enrollment beginning September 15, 2026, with additional changes effective January 1, 2027. Trade reporting indicates the 2027 action covers 123 plans across 33 states, although a complete independently verifiable public plan list was unavailable. [Becker’s Payer Issues, “Aetna to cut Medicare Advantage broker commissions again,” August 21, 2026](https://www.beckerspayer.com/payer/medicare-advantage/aetna-to-cut-medicare-advantage-broker-commissions-again/) and [Live Insurance News, “Aetna Just Froze Broker Commissions on 123 Medicare Advantage Plans,” August 21, 2026](https://www.liveinsurancenews.com/aetna-froze-broker-commissions/8575361/). ([beckerspayer.com](https://www.beckerspayer.com/payer/medicare-advantage/aetna-to-cut-medicare-advantage-broker-commissions-again/?utm_source=openai))

**Why it matters**

Removing commissions functions as a soft enrollment brake. Aetna can retain a plan and its existing members while reducing the incentive for brokers to add new, potentially higher-utilization enrollment. It is therefore a more granular margin-management tool than a county exit.

**Strategist implication**

This is the first meaningful Aetna-specific delta since its recent earnings. It supports a margin-over-membership interpretation of 2027 strategy and may shift enrollment toward direct channels or competing commissionable plans. County-level bid, product and distribution analytics become more important because reported membership changes may reflect broker economics as much as benefit competitiveness.

**Watch next**

The affected plan mix—particularly PPO versus HMO and general enrollment versus D-SNP—and whether other carriers make additional plans noncommissionable before annual enrollment.

---

<h3 id="strategy-executive-view-4-the-2027-employer-cost-outlook-increases-demand-for-intervention-but-raises-the-roi-bar">4. The 2027 employer-cost outlook increases demand for intervention—but raises the ROI bar</h3>

**Status:** NEW

**What happened**

Aon projected on August 20 that U.S. employer healthcare costs will increase 9.5% in 2027, pushing average cost above $19,000 per employee. Aon characterized this as the fourth consecutive year of near-double-digit increases and said employers currently absorb more than 80% of plan costs. [Aon, “U.S. Employer Health Care Costs Continue Multi-Year Climb,” August 20, 2026](https://www.prnewswire.com/news-releases/aon-us-employer-health-care-costs-continue-multi-year-climb-projected-to-rise-9-5-in-2027--302855864.html). ([prnewswire.com](https://www.prnewswire.com/news-releases/aon-us-employer-health-care-costs-continue-multi-year-climb-projected-to-rise-9-5-in-2027--302855864.html?utm_source=openai))

**Why it matters**

If renewals approach that level, employers will intensify pressure on commercial carriers and administrators to demonstrate savings from high-performance networks, site-of-care steering, pharmacy controls, payment integrity and complex-case management. Fully insured plans face margin risk where pricing lags trend; self-funded employers bear the cost directly.

**Strategist implication**

Demand for cost-management technology should rise, but buyers will be less tolerant of overlapping vendor fees and attribution-based savings claims. Solutions that connect intervention to allowed-cost reduction, provider behavior or contract performance should gain share. Providers should expect more steerage, utilization controls and purchaser scrutiny of facility-based pricing.

**Watch next**

Actual renewal pricing and whether employers respond primarily through contribution increases, benefit reductions or more selective provider and pharmacy networks.

---

<h3 id="strategy-executive-view-5-cityblock-homeward-shows-where-value-based-care-capital-remains-available">5. Cityblock-Homeward shows where value-based-care capital remains available</h3>

**Status:** CONFIRM

**What happened**

Cityblock announced on August 20 that it had signed an all-stock agreement to acquire rural MA provider Homeward Health while raising a $116 million Series E led by General Catalyst. Management reports that Cityblock serves nearly 200,000 members and generates $2.2 billion in annualized revenue; Homeward contributes nearly 50,000 members. These figures are company-reported and unaudited. [Cityblock, “Scaling the Platform Custom-Built for the Biggest Challenges in Healthcare,” August 20, 2026](https://www.cityblock.com/homeward). ([cityblock.com](https://www.cityblock.com/homeward?utm_source=openai))

**Why it matters**

The deal combines urban Medicaid and dual-eligible operations with rural Medicare Advantage capabilities. It suggests capital remains available where platforms can offer payers geographic expansion, multiple government-program populations and a credible operating layer—not merely analytics or contracting support.

**Strategist implication**

Payers may increasingly prefer scaled partners that can manage outreach, care delivery and utilization across Medicaid, MA and duals. The opportunity is meaningful, but reliable public absolute profitability and medical-cost performance remain unavailable. The transaction confirms strategic demand, not yet proven unit economics.

**Watch next**

Payer retention, closing terms, integration of rural and urban operating models, and independently measurable medical-cost and quality outcomes.

---

<h3 id="strategy-executive-view-6-rural-health-transformation-funding-is-becoming-an-addressable-technology-market">6. Rural Health Transformation funding is becoming an addressable technology market</h3>

**Status:** NEW

**What happened**

CMS announced $90 million for South Dakota on August 19 focused on EHR modernization, cybersecurity, interoperability and virtual care. It also announced $35 million for Pennsylvania capacity and equipment, followed on August 20 by $4.2 million for West Virginia transportation and $1 million for North Dakota care coordination. [CMS, South Dakota announcement, August 19, 2026](https://www.cms.gov/newsroom/press-releases/trump-administration-announces-90-million-modernize-improve-it-interoperability-south-dakota), [Pennsylvania announcement, August 19](https://www.cms.gov/newsroom/press-releases/trump-administration-announces-35-million-investment-advance-screening-technology-secure-additional), and [West Virginia announcement, August 20](https://www.cms.gov/newsroom/press-releases/trump-administration-announces-4-2-million-expand-medical-transportation-improve-patient-access-care). ([cms.gov](https://www.cms.gov/newsroom/press-releases/trump-administration-announces-90-million-modernize-improve-it-interoperability-south-dakota))

**Strategist implication**

The $50 billion, five-year Rural Health Transformation Program is moving from policy authorization into state-level procurement. Near-term demand should favor implementation-ready EHR, cybersecurity, interoperability, remote-monitoring, referral and capacity-management vendors. However, grants improve infrastructure; they do not replace recurring reimbursement. Vendors must distinguish funded modernization from sustainable provider operating economics.

<h3 id="strategic-synthesis">Strategic synthesis</h3>

This week strengthens a narrower thesis than “healthcare automation is growing.” Capital and buyer attention are concentrating around systems that control an economically consequential junction:

- authorization before the claim;
- broker distribution before enrollment;
- care orchestration before avoidable utilization;
- state funding before rural technology procurement.

The winners are more likely to be platforms that can prove downstream financial outcomes across these junctions. Access, distribution and workflow ownership are becoming as important as model accuracy.

<h3 id="what-i-m-watching-next">What I&#x27;m Watching Next</h3>

- **September 15, 2026:** Initial Aetna Medicare Advantage commission changes take effect; NCQA also releases its 2026 Health Plan Ratings.
- **October 15–December 7, 2026:** Medicare annual enrollment tests whether noncommissionable plans experience meaningful share shifts.
- **January 1, 2027:** Additional Aetna commission changes take effect, alongside the principal CMS-0057 payer API implementation deadline.

<h3 id="bottom-line">Bottom Line</h3>

The most important weekly change is that prior authorization is becoming embedded infrastructure across both EHR and RCM platforms. The exposure requiring closest attention is MA distribution economics, where Aetna is constraining selected growth without fully exiting markets. The next evidence most likely to change the view will be whether production authorization deployments reduce denials and rework—not merely response time.

## Notable Changes

Comparison with the final report dated August 17, 2026 (market data through August 14, 2026).

### Sectors

#### Top-three comparison

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Entity</th><th class="sortable-heading" data-column="1" data-type="number">Previous</th><th class="sortable-heading" data-column="2" data-type="number">Current</th><th class="sortable-heading" data-column="3" data-type="number">Change</th><th class="sortable-heading" data-column="4" data-type="number">Current return</th></tr></thead><tbody><tr><td class="text" data-sort="precision diagnostics" style=""><a href="#category-precision-diagnostics">Precision Diagnostics</a></td><td class="" data-sort="1" style="">#1</td><td class="" data-sort="1" style="">#1</td><td class="" data-sort="0" style="">— 0</td><td class="" data-sort="0.9305996293794843" style="background:#1a7a3c;color:#ffffff;">+93.1%</td></tr><tr><td class="text" data-sort="inpatient non-acute providers" style=""><a href="#category-inpatient-non-acute-providers">Inpatient Non-Acute Providers</a></td><td class="" data-sort="3" style="">#3</td><td class="" data-sort="2" style="">#2</td><td class="rank-change-up" data-sort="-1" style="">↑ 1</td><td class="" data-sort="0.6462269126862907" style="background:#2f9e44;color:#111820;">+64.6%</td></tr><tr><td class="text" data-sort="value-based care" style=""><a href="#category-value-based-care">Value-Based Care</a></td><td class="" data-sort="2" style="">#2</td><td class="" data-sort="3" style="">#3</td><td class="rank-change-down" data-sort="1" style="">↓ 1</td><td class="" data-sort="0.5789131205662648" style="background:#2f9e44;color:#111820;">+57.9%</td></tr></tbody></table></div>


### Stocks

#### Top-three comparison

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Entity</th><th class="sortable-heading" data-column="1" data-type="number">Previous</th><th class="sortable-heading" data-column="2" data-type="number">Current</th><th class="sortable-heading" data-column="3" data-type="number">Change</th><th class="sortable-heading" data-column="4" data-type="number">Current return</th></tr></thead><tbody><tr><td class="text" data-sort="10x genomics" style="">10x Genomics (<a href="#company-txg">TXG</a>)</td><td class="" data-sort="1" style="">#1</td><td class="" data-sort="1" style="">#1</td><td class="" data-sort="0" style="">— 0</td><td class="" data-sort="3.5538461538461537" style="background:#1a7a3c;color:#ffffff;">+355.4%</td></tr><tr><td class="text" data-sort="pacs group" style="">PACS Group (<a href="#company-pacs">PACS</a>)</td><td class="" data-sort="2" style="">#2</td><td class="" data-sort="2" style="">#2</td><td class="" data-sort="0" style="">— 0</td><td class="" data-sort="2.672199170124481" style="background:#2f9e44;color:#111820;">+267.2%</td></tr><tr><td class="text" data-sort="agilon health" style="">Agilon Health (<a href="#company-agl">AGL</a>)</td><td class="" data-sort="3" style="">#3</td><td class="" data-sort="3" style="">#3</td><td class="" data-sort="0" style="">— 0</td><td class="" data-sort="1.9046616541353383" style="background:#7cc077;color:#111820;">+190.5%</td></tr></tbody></table></div>


#### Largest rank changes

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Entity</th><th class="sortable-heading" data-column="1" data-type="number">Previous</th><th class="sortable-heading" data-column="2" data-type="number">Current</th><th class="sortable-heading" data-column="3" data-type="number">Change</th><th class="sortable-heading" data-column="4" data-type="number">Current return</th></tr></thead><tbody><tr><td class="text" data-sort="iqvia" style="">Iqvia (<a href="#company-iqv">IQV</a>)</td><td class="" data-sort="36" style="">#36</td><td class="" data-sort="24" style="">#24</td><td class="rank-change-up" data-sort="-12" style="">↑ 12</td><td class="" data-sort="0.3592466649228354" style="background:#1a7a3c;color:#ffffff;">+35.9%</td></tr><tr><td class="text" data-sort="acadia healthcare" style="">Acadia Healthcare (<a href="#company-achc">ACHC</a>)</td><td class="" data-sort="22" style="">#22</td><td class="" data-sort="33" style="">#33</td><td class="rank-change-down" data-sort="11" style="">↓ 11</td><td class="" data-sort="0.23975044563279857" style="background:#2f9e44;color:#111820;">+24.0%</td></tr><tr><td class="text" data-sort="goodrx" style="">GoodRx (<a href="#company-gdrx">GDRX</a>)</td><td class="" data-sort="55" style="">#55</td><td class="" data-sort="68" style="">#68</td><td class="rank-change-down" data-sort="13" style="">↓ 13</td><td class="" data-sort="-0.24342105263157887" style="background:#e34948;color:#111820;">-24.3%</td></tr></tbody></table></div>


### Subcategory movement since the previous report

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Subcategory</th><th class="sortable-heading" data-column="1" data-type="number">Move</th><th class="sortable-heading" data-column="2" data-type="number">Last Report, 12m Ret</th><th class="sortable-heading" data-column="3" data-type="number">Current Report, 12m Ret</th></tr></thead><tbody><tr><td class="text" data-sort="precision diagnostics" style=""><a href="#category-precision-diagnostics">Precision Diagnostics</a></td><td class="" data-sort="0.09809965724267156" style="background:#1a7a3c;color:#ffffff;">+9.8%</td><td class="" data-sort="0.806611434939" style="background:#1a7a3c;color:#ffffff;">+80.7%</td><td class="" data-sort="0.9305996293794843" style="background:#1a7a3c;color:#ffffff;">+93.1%</td></tr><tr><td class="text" data-sort="health system providers" style=""><a href="#category-health-system-providers">Health System Providers</a></td><td class="" data-sort="0.05600779825812341" style="background:#7cc077;color:#111820;">+5.6%</td><td class="" data-sort="0.106456369394" style="background:#d6ecd4;color:#111820;">+10.6%</td><td class="" data-sort="0.13461582069852387" style="background:#d6ecd4;color:#111820;">+13.5%</td></tr><tr><td class="text" data-sort="digital health, specialty, benefits" style=""><a href="#category-digital-health-specialty-benefits">Digital Health, Specialty, Benefits</a></td><td class="" data-sort="0.04027110255083125" style="background:#7cc077;color:#111820;">+4.0%</td><td class="" data-sort="0.091407915079" style="background:#d6ecd4;color:#111820;">+9.1%</td><td class="" data-sort="0.09838186698948848" style="background:#d6ecd4;color:#111820;">+9.8%</td></tr><tr><td class="text" data-sort="health care real estate" style=""><a href="#category-health-care-real-estate">Health Care Real Estate</a></td><td class="" data-sort="0.015377308444059386" style="background:#d6ecd4;color:#111820;">+1.5%</td><td class="" data-sort="0.372038086192" style="background:#7cc077;color:#111820;">+37.2%</td><td class="" data-sort="0.37882271724122857" style="background:#7cc077;color:#111820;">+37.9%</td></tr><tr><td class="text" data-sort="pharma distribution" style=""><a href="#category-pharma-distribution">Pharma Distribution</a></td><td class="" data-sort="-0.008163651789695687" style="background:#fbd5d4;color:#111820;">-0.8%</td><td class="" data-sort="0.300068673074" style="background:#a9d9a4;color:#111820;">+30.0%</td><td class="" data-sort="0.2764098909531431" style="background:#a9d9a4;color:#111820;">+27.6%</td></tr><tr><td class="text" data-sort="health it and data" style=""><a href="#category-health-it-and-data">Health IT and Data</a></td><td class="" data-sort="-0.011805582542501762" style="background:#fbd5d4;color:#111820;">-1.2%</td><td class="" data-sort="-0.303148912292" style="background:#f5aead;color:#111820;">-30.3%</td><td class="" data-sort="-0.2849867125153504" style="background:#f5aead;color:#111820;">-28.5%</td></tr><tr><td class="text" data-sort="outpatient and home providers" style=""><a href="#category-outpatient-and-home-providers">Outpatient and Home Providers</a></td><td class="" data-sort="-0.0172991865202102" style="background:#fbd5d4;color:#111820;">-1.7%</td><td class="" data-sort="0.518902426763" style="background:#2f9e44;color:#111820;">+51.9%</td><td class="" data-sort="0.40979001521205816" style="background:#7cc077;color:#111820;">+41.0%</td></tr><tr><td class="text" data-sort="inpatient non-acute providers" style=""><a href="#category-inpatient-non-acute-providers">Inpatient Non-Acute Providers</a></td><td class="" data-sort="-0.022798691717376075" style="background:#f5aead;color:#111820;">-2.3%</td><td class="" data-sort="0.744697156406" style="background:#1a7a3c;color:#ffffff;">+74.5%</td><td class="" data-sort="0.6462269126862907" style="background:#2f9e44;color:#111820;">+64.6%</td></tr><tr><td class="text" data-sort="value-based care" style=""><a href="#category-value-based-care">Value-Based Care</a></td><td class="" data-sort="-0.025823928729135984" style="background:#f5aead;color:#111820;">-2.6%</td><td class="" data-sort="0.806406698893" style="background:#1a7a3c;color:#ffffff;">+80.6%</td><td class="" data-sort="0.5789131205662648" style="background:#2f9e44;color:#111820;">+57.9%</td></tr><tr><td class="text" data-sort="payers" style=""><a href="#category-payers">Payers</a></td><td class="" data-sort="-0.027884248161636486" style="background:#f5aead;color:#111820;">-2.8%</td><td class="" data-sort="0.351948184652" style="background:#7cc077;color:#111820;">+35.2%</td><td class="" data-sort="0.2831833321171043" style="background:#a9d9a4;color:#111820;">+28.3%</td></tr></tbody></table></div>


### Largest company moves

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Direction</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Move</th></tr></thead><tbody><tr><td class="text" data-sort="0" style="">Gain</td><td class="text" data-sort="tempus ai" style="">Tempus AI</td><td class="text text" data-sort="tem" style=""><a href="#company-tem">TEM</a></td><td class="" data-sort="0.3952015355086371" style="background:#1a7a3c;color:#ffffff;">+39.5%</td></tr><tr><td class="text" data-sort="0" style="">Gain</td><td class="text" data-sort="hims &amp; hers" style="">Hims &amp; Hers</td><td class="text text" data-sort="hims" style=""><a href="#company-hims">HIMS</a></td><td class="" data-sort="0.20000000000000018" style="background:#7cc077;color:#111820;">+20.0%</td></tr><tr><td class="text" data-sort="0" style="">Gain</td><td class="text" data-sort="pacbio" style="">PacBio</td><td class="text text" data-sort="pacb" style=""><a href="#company-pacb">PACB</a></td><td class="" data-sort="0.17391304347826098" style="background:#7cc077;color:#111820;">+17.4%</td></tr><tr><td class="text" data-sort="1" style="">Decline</td><td class="text" data-sort="health catalyst" style="">Health Catalyst</td><td class="text text" data-sort="hcat" style=""><a href="#company-hcat">HCAT</a></td><td class="" data-sort="-0.17297297297297298" style="background:#ee8483;color:#111820;">-17.3%</td></tr><tr><td class="text" data-sort="1" style="">Decline</td><td class="text" data-sort="clover health" style="">Clover Health</td><td class="text text" data-sort="clov" style=""><a href="#company-clov">CLOV</a></td><td class="" data-sort="-0.09782608695652162" style="background:#f5aead;color:#111820;">-9.8%</td></tr><tr><td class="text" data-sort="1" style="">Decline</td><td class="text" data-sort="acadia healthcare" style="">Acadia Healthcare</td><td class="text text" data-sort="achc" style=""><a href="#company-achc">ACHC</a></td><td class="" data-sort="-0.09763217645150823" style="background:#f5aead;color:#111820;">-9.8%</td></tr></tbody></table></div>


## Subcategory Performance

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Subcategory</th><th class="sortable-heading" data-column="1" data-type="number">Companies</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="payers" style=""><a href="#category-payers">Payers</a></td><td class="" data-sort="10" style="">10</td><td class="" data-sort="769783972394.51" style="">$769.8B</td><td class="" data-sort="0.023265607422294582" style="background:#d6ecd4;color:#111820;">+2.3%</td><td class="" data-sort="0.2831833321171043" style="background:#a9d9a4;color:#111820;">+28.3%</td><td class="" data-sort="-0.10673955923524782" style="background:#fbd5d4;color:#111820;">-10.7%</td></tr><tr><td class="text" data-sort="health system providers" style=""><a href="#category-health-system-providers">Health System Providers</a></td><td class="" data-sort="5" style="">5</td><td class="" data-sort="119831113197.41" style="">$119.8B</td><td class="" data-sort="0.1834302537748217" style="background:#a9d9a4;color:#111820;">+18.3%</td><td class="" data-sort="0.13461582069852387" style="background:#d6ecd4;color:#111820;">+13.5%</td><td class="" data-sort="0.17006985256555376" style="background:#d6ecd4;color:#111820;">+17.0%</td></tr><tr><td class="text" data-sort="inpatient non-acute providers" style=""><a href="#category-inpatient-non-acute-providers">Inpatient Non-Acute Providers</a></td><td class="" data-sort="4" style="">4</td><td class="" data-sort="31441382422.3" style="">$31.4B</td><td class="" data-sort="0.12316789636469591" style="background:#a9d9a4;color:#111820;">+12.3%</td><td class="" data-sort="0.6462269126862907" style="background:#2f9e44;color:#111820;">+64.6%</td><td class="" data-sort="0.13974582427376378" style="background:#d6ecd4;color:#111820;">+14.0%</td></tr><tr><td class="text" data-sort="health care real estate" style=""><a href="#category-health-care-real-estate">Health Care Real Estate</a></td><td class="" data-sort="8" style="">8</td><td class="" data-sort="266432919583.72998" style="">$266.4B</td><td class="" data-sort="0.0757824952374116" style="background:#d6ecd4;color:#111820;">+7.6%</td><td class="" data-sort="0.37882271724122857" style="background:#7cc077;color:#111820;">+37.9%</td><td class="" data-sort="0.7630204228159297" style="background:#7cc077;color:#111820;">+76.3%</td></tr><tr><td class="text" data-sort="value-based care" style=""><a href="#category-value-based-care">Value-Based Care</a></td><td class="" data-sort="5" style="">5</td><td class="" data-sort="7199786717.830001" style="">$7.2B</td><td class="" data-sort="0.021980629740791815" style="background:#d6ecd4;color:#111820;">+2.2%</td><td class="" data-sort="0.5789131205662648" style="background:#2f9e44;color:#111820;">+57.9%</td><td class="" data-sort="-0.12311298042013119" style="background:#fbd5d4;color:#111820;">-12.3%</td></tr><tr><td class="text" data-sort="outpatient and home providers" style=""><a href="#category-outpatient-and-home-providers">Outpatient and Home Providers</a></td><td class="" data-sort="11" style="">11</td><td class="" data-sort="64788787758.09" style="">$64.8B</td><td class="" data-sort="0.10907550672842822" style="background:#a9d9a4;color:#111820;">+10.9%</td><td class="" data-sort="0.40979001521205816" style="background:#7cc077;color:#111820;">+41.0%</td><td class="" data-sort="0.8460605497526712" style="background:#7cc077;color:#111820;">+84.6%</td></tr><tr><td class="text" data-sort="digital health, specialty, benefits" style=""><a href="#category-digital-health-specialty-benefits">Digital Health, Specialty, Benefits</a></td><td class="" data-sort="10" style="">10</td><td class="" data-sort="26312964338.309998" style="">$26.3B</td><td class="" data-sort="0.26244597757424865" style="background:#7cc077;color:#111820;">+26.2%</td><td class="" data-sort="0.09838186698948848" style="background:#d6ecd4;color:#111820;">+9.8%</td><td class="" data-sort="0.5249776742589063" style="background:#a9d9a4;color:#111820;">+52.5%</td></tr><tr><td class="text" data-sort="health it and data" style=""><a href="#category-health-it-and-data">Health IT and Data</a></td><td class="" data-sort="12" style="">12</td><td class="" data-sort="470568402022.48" style="">$470.6B</td><td class="" data-sort="-0.09550854978992336" style="background:#fbd5d4;color:#111820;">-9.6%</td><td class="" data-sort="-0.2849867125153504" style="background:#f5aead;color:#111820;">-28.5%</td><td class="" data-sort="0.07186861890879315" style="background:#d6ecd4;color:#111820;">+7.2%</td></tr><tr><td class="text" data-sort="pharma distribution" style=""><a href="#category-pharma-distribution">Pharma Distribution</a></td><td class="" data-sort="5" style="">5</td><td class="" data-sort="222577856248.59" style="">$222.6B</td><td class="" data-sort="0.13712369774359925" style="background:#a9d9a4;color:#111820;">+13.7%</td><td class="" data-sort="0.2764098909531431" style="background:#a9d9a4;color:#111820;">+27.6%</td><td class="" data-sort="0.6122174984446888" style="background:#7cc077;color:#111820;">+61.2%</td></tr><tr><td class="text" data-sort="precision diagnostics" style=""><a href="#category-precision-diagnostics">Precision Diagnostics</a></td><td class="" data-sort="12" style="">12</td><td class="" data-sort="168611092169.36" style="">$168.6B</td><td class="" data-sort="0.4933461431710856" style="background:#1a7a3c;color:#ffffff;">+49.3%</td><td class="" data-sort="0.9305996293794843" style="background:#1a7a3c;color:#ffffff;">+93.1%</td><td class="" data-sort="1.4176811883844291" style="background:#1a7a3c;color:#ffffff;">+141.8%</td></tr></tbody></table></div>

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

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="number">Rank</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">Return</th></tr></thead><tbody><tr><td class="" data-sort="1" style="">1</td><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="1.7500000000000004" style="background:#1a7a3c;color:#ffffff;">+175.0%</td></tr><tr><td class="" data-sort="2" style="">2</td><td class="text" data-sort="neogenomics" style="">NeoGenomics</td><td class="text text" data-sort="neo" style=""><a href="#company-neo">NEO</a></td><td class="" data-sort="2092864917.6" style="">$2.1B</td><td class="" data-sort="0.8396533044420369" style="background:#7cc077;color:#111820;">+84.0%</td></tr><tr><td class="" data-sort="3" style="">3</td><td class="text" data-sort="aveanna healthcare" style="">Aveanna Healthcare</td><td class="text text" data-sort="avah" style=""><a href="#company-avah">AVAH</a></td><td class="" data-sort="2038188700.08" style="">$2.0B</td><td class="" data-sort="0.7953615279672579" style="background:#7cc077;color:#111820;">+79.5%</td></tr><tr><td class="" data-sort="4" style="">4</td><td class="text" data-sort="lifestance health" style="">Lifestance Health</td><td class="text text" data-sort="lfst" style=""><a href="#company-lfst">LFST</a></td><td class="" data-sort="4001624847.36" style="">$4.0B</td><td class="" data-sort="0.6874154262516916" style="background:#a9d9a4;color:#111820;">+68.7%</td></tr><tr><td class="" data-sort="5" style="">5</td><td class="text" data-sort="natera" style="">Natera</td><td class="text text" data-sort="ntra" style=""><a href="#company-ntra">NTRA</a></td><td class="" data-sort="39411440972.58" style="">$39.4B</td><td class="" data-sort="0.634086323145824" style="background:#a9d9a4;color:#111820;">+63.4%</td></tr></tbody></table></div>

### Last 12 months

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="number">Rank</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">Return</th></tr></thead><tbody><tr><td class="" data-sort="1" style="">1</td><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="3.5538461538461537" style="background:#1a7a3c;color:#ffffff;">+355.4%</td></tr><tr><td class="" data-sort="2" style="">2</td><td class="text" data-sort="pacs group" style="">PACS Group</td><td class="text text" data-sort="pacs" style=""><a href="#company-pacs">PACS</a></td><td class="" data-sort="7282112019.759999" style="">$7.3B</td><td class="" data-sort="2.672199170124481" style="background:#2f9e44;color:#111820;">+267.2%</td></tr><tr><td class="" data-sort="3" style="">3</td><td class="text" data-sort="agilon health" style="">Agilon Health</td><td class="text text" data-sort="agl" style=""><a href="#company-agl">AGL</a></td><td class="" data-sort="2073627800.0" style="">$2.1B</td><td class="" data-sort="1.9046616541353383" style="background:#7cc077;color:#111820;">+190.5%</td></tr><tr><td class="" data-sort="4" style="">4</td><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="1.7799674267100976" style="background:#7cc077;color:#111820;">+178.0%</td></tr><tr><td class="" data-sort="5" style="">5</td><td class="text" data-sort="neogenomics" style="">NeoGenomics</td><td class="text text" data-sort="neo" style=""><a href="#company-neo">NEO</a></td><td class="" data-sort="2092864917.6" style="">$2.1B</td><td class="" data-sort="1.570779712339137" style="background:#7cc077;color:#111820;">+157.1%</td></tr></tbody></table></div>

### Last 24 months

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="number">Rank</th><th class="sortable-heading" data-column="1" data-type="text">Company</th><th class="sortable-heading" data-column="2" data-type="text">Ticker</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">Return</th></tr></thead><tbody><tr><td class="" data-sort="1" style="">1</td><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="4.881805651274982" style="background:#1a7a3c;color:#ffffff;">+488.2%</td></tr><tr><td class="" data-sort="2" style="">2</td><td class="text" data-sort="brightspring health services" style="">BrightSpring Health Services</td><td class="text text" data-sort="btsg" style=""><a href="#company-btsg">BTSG</a></td><td class="" data-sort="12419938407.57" style="">$12.4B</td><td class="" data-sort="3.6833731105807477" style="background:#2f9e44;color:#111820;">+368.3%</td></tr><tr><td class="" data-sort="3" style="">3</td><td class="text" data-sort="talkspace" style="">Talkspace</td><td class="text text" data-sort="talk" style=""><a href="#company-talk">TALK</a></td><td class="" data-sort="874415594.52" style="">$874.4M</td><td class="" data-sort="1.9661016949152543" style="background:#7cc077;color:#111820;">+196.6%</td></tr><tr><td class="" data-sort="4" style="">4</td><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="1.7722435078756922" style="background:#a9d9a4;color:#111820;">+177.2%</td></tr><tr><td class="" data-sort="5" style="">5</td><td class="text" data-sort="natera" style="">Natera</td><td class="text text" data-sort="ntra" style=""><a href="#company-ntra">NTRA</a></td><td class="" data-sort="39411440972.58" style="">$39.4B</td><td class="" data-sort="1.7058104473963" style="background:#a9d9a4;color:#111820;">+170.6%</td></tr></tbody></table></div>


## Companies by Subcategory

<h3 id="category-payers"><a href="#subcategory-performance">Payers</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +2.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="unitedhealth" style="">UnitedHealth</td><td class="text text" data-sort="unh" style=""><a href="#company-unh">UNH</a></td><td class="" data-sort="380076600000.0" style="">$380.1B</td><td class="" data-sort="0.00422169022060892" style="background:#d6ecd4;color:#111820;">+0.4%</td><td class="" data-sort="0.2689805477847895" style="background:#a9d9a4;color:#111820;">+26.9%</td><td class="" data-sort="-0.3325862688405673" style="background:#ee8483;color:#111820;">-33.3%</td></tr><tr><td class="text" data-sort="cvs health" style="">CVS Health</td><td class="text text" data-sort="cvs" style=""><a href="#company-cvs">CVS</a></td><td class="" data-sort="135133460000.0" style="">$135.1B</td><td class="" data-sort="-0.0025734505683037145" style="background:#fbd5d4;color:#111820;">-0.3%</td><td class="" data-sort="0.30462833099579245" style="background:#a9d9a4;color:#111820;">+30.5%</td><td class="" data-sort="0.5833191489361702" style="background:#2f9e44;color:#111820;">+58.3%</td></tr><tr><td class="text" data-sort="humana" style="">Humana</td><td class="text text" data-sort="hum" style=""><a href="#company-hum">HUM</a></td><td class="" data-sort="43692420868.880005" style="">$43.7B</td><td class="" data-sort="0.23032959896087024" style="background:#7cc077;color:#111820;">+23.0%</td><td class="" data-sort="0.2649994991819973" style="background:#a9d9a4;color:#111820;">+26.5%</td><td class="" data-sort="0.07361858883536421" style="background:#d6ecd4;color:#111820;">+7.4%</td></tr><tr><td class="text" data-sort="oscar health" style="">Oscar Health</td><td class="text text" data-sort="oscr" style=""><a href="#company-oscr">OSCR</a></td><td class="" data-sort="9412611460.0" style="">$9.4B</td><td class="" data-sort="0.4151943462897525" style="background:#1a7a3c;color:#ffffff;">+41.5%</td><td class="" data-sort="0.907142857142857" style="background:#2f9e44;color:#111820;">+90.7%</td><td class="" data-sort="0.8081264108352144" style="background:#1a7a3c;color:#ffffff;">+80.8%</td></tr><tr><td class="text" data-sort="molina healthcare" style="">Molina Healthcare</td><td class="text text" data-sort="moh" style=""><a href="#company-moh">MOH</a></td><td class="" data-sort="10211364000.0" style="">$10.2B</td><td class="" data-sort="0.08770500705984574" style="background:#a9d9a4;color:#111820;">+8.8%</td><td class="" data-sort="0.1481884888786975" style="background:#d6ecd4;color:#111820;">+14.8%</td><td class="" data-sort="-0.42082586316580883" style="background:#ee8483;color:#111820;">-42.1%</td></tr><tr><td class="text" data-sort="cigna" style="">Cigna</td><td class="text text" data-sort="ci" style=""><a href="#company-ci">CI</a></td><td class="" data-sort="73736307618.3" style="">$73.7B</td><td class="" data-sort="-0.03049888205701512" style="background:#fbd5d4;color:#111820;">-3.0%</td><td class="" data-sort="-0.08818794151470355" style="background:#fbd5d4;color:#111820;">-8.8%</td><td class="" data-sort="-0.21605130088420577" style="background:#f5aead;color:#111820;">-21.6%</td></tr><tr><td class="text" data-sort="elevance" style="">Elevance</td><td class="text text" data-sort="elv" style=""><a href="#company-elv">ELV</a></td><td class="" data-sort="81508153953.59999" style="">$81.5B</td><td class="" data-sort="0.014821758848716726" style="background:#d6ecd4;color:#111820;">+1.5%</td><td class="" data-sort="0.2653293318591059" style="background:#a9d9a4;color:#111820;">+26.5%</td><td class="" data-sort="-0.2663565096344055" style="background:#f5aead;color:#111820;">-26.6%</td></tr><tr><td class="text" data-sort="clover health" style="">Clover Health</td><td class="text text" data-sort="clov" style=""><a href="#company-clov">CLOV</a></td><td class="" data-sort="2196273631.08" style="">$2.2B</td><td class="" data-sort="0.16901408450704247" style="background:#7cc077;color:#111820;">+16.9%</td><td class="" data-sort="0.5201465201465203" style="background:#7cc077;color:#111820;">+52.0%</td><td class="" data-sort="0.24251497005988032" style="background:#a9d9a4;color:#111820;">+24.3%</td></tr><tr><td class="text" data-sort="centene" style="">Centene</td><td class="text text" data-sort="cnc" style=""><a href="#company-cnc">CNC</a></td><td class="" data-sort="30736368900.0" style="">$30.7B</td><td class="" data-sort="0.09942509299966185" style="background:#a9d9a4;color:#111820;">+9.9%</td><td class="" data-sort="1.2108126487589255" style="background:#1a7a3c;color:#ffffff;">+121.1%</td><td class="" data-sort="-0.17224697644812226" style="background:#f5aead;color:#111820;">-17.2%</td></tr><tr><td class="text" data-sort="alignment health" style="">Alignment Health</td><td class="text text" data-sort="alhc" style=""><a href="#company-alhc">ALHC</a></td><td class="" data-sort="3080411962.65" style="">$3.1B</td><td class="" data-sort="-0.19510703363914383" style="background:#ee8483;color:#111820;">-19.5%</td><td class="" data-sort="-0.16919191919191923" style="background:#fbd5d4;color:#111820;">-16.9%</td><td class="" data-sort="0.41963322545846826" style="background:#7cc077;color:#111820;">+42.0%</td></tr></tbody></table></div>

<h3 id="category-health-system-providers"><a href="#subcategory-performance">Health System Providers</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +18.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="hca healthcare" style="">HCA Healthcare</td><td class="text text" data-sort="hca" style=""><a href="#company-hca">HCA</a></td><td class="" data-sort="87161338885.0" style="">$87.2B</td><td class="" data-sort="0.08912122211789786" style="background:#d6ecd4;color:#111820;">+8.9%</td><td class="" data-sort="0.05980689927648952" style="background:#d6ecd4;color:#111820;">+6.0%</td><td class="" data-sort="0.10394053192036634" style="background:#d6ecd4;color:#111820;">+10.4%</td></tr><tr><td class="text" data-sort="tenet health" style="">Tenet Health</td><td class="text text" data-sort="thc" style=""><a href="#company-thc">THC</a></td><td class="" data-sort="20514630820.0" style="">$20.5B</td><td class="" data-sort="0.6156634825641614" style="background:#1a7a3c;color:#ffffff;">+61.6%</td><td class="" data-sort="0.5641782729805014" style="background:#1a7a3c;color:#ffffff;">+56.4%</td><td class="" data-sort="0.7064972953260802" style="background:#1a7a3c;color:#ffffff;">+70.6%</td></tr><tr><td class="text" data-sort="universal health services" style="">Universal Health Services</td><td class="text text" data-sort="uhs" style=""><a href="#company-uhs">UHS</a></td><td class="" data-sort="10196742962.44" style="">$10.2B</td><td class="" data-sort="0.12332065906210388" style="background:#a9d9a4;color:#111820;">+12.3%</td><td class="" data-sort="-0.04483241728634557" style="background:#fbd5d4;color:#111820;">-4.5%</td><td class="" data-sort="-0.2396843098567384" style="background:#f5aead;color:#111820;">-24.0%</td></tr><tr><td class="text" data-sort="community health systems" style="">Community Health Systems</td><td class="text text" data-sort="cyh" style=""><a href="#company-cyh">CYH</a></td><td class="" data-sort="417387696.71999997" style="">$417.4M</td><td class="" data-sort="0.07499999999999996" style="background:#d6ecd4;color:#111820;">+7.5%</td><td class="" data-sort="0.0905797101449275" style="background:#d6ecd4;color:#111820;">+9.1%</td><td class="" data-sort="-0.4051383399209486" style="background:#ee8483;color:#111820;">-40.5%</td></tr><tr><td class="text" data-sort="ardent health partners" style="">Ardent Health Partners</td><td class="text text" data-sort="ardt" style=""><a href="#company-ardt">ARDT</a></td><td class="" data-sort="1541012833.25" style="">$1.5B</td><td class="" data-sort="0.1906825568797399" style="background:#a9d9a4;color:#111820;">+19.1%</td><td class="" data-sort="-0.1533127889060093" style="background:#f5aead;color:#111820;">-15.3%</td><td class="" data-sort="-0.36363636363636365" style="background:#ee8483;color:#111820;">-36.4%</td></tr></tbody></table></div>

<h3 id="category-inpatient-non-acute-providers"><a href="#subcategory-performance">Inpatient Non-Acute Providers</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +12.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="the ensign group" style="">The Ensign Group</td><td class="text text" data-sort="ensg" style=""><a href="#company-ensg">ENSG</a></td><td class="" data-sort="10383598441.44" style="">$10.4B</td><td class="" data-sort="0.0438525066883797" style="background:#a9d9a4;color:#111820;">+4.4%</td><td class="" data-sort="0.040825794479239175" style="background:#d6ecd4;color:#111820;">+4.1%</td><td class="" data-sort="0.21212939825758093" style="background:#a9d9a4;color:#111820;">+21.2%</td></tr><tr><td class="text" data-sort="acadia healthcare" style="">Acadia Healthcare</td><td class="text text" data-sort="achc" style=""><a href="#company-achc">ACHC</a></td><td class="" data-sort="2757630145.5" style="">$2.8B</td><td class="" data-sort="0.2001725625539259" style="background:#1a7a3c;color:#ffffff;">+20.0%</td><td class="" data-sort="0.23975044563279857" style="background:#d6ecd4;color:#111820;">+24.0%</td><td class="" data-sort="-0.6518583406332124" style="background:#c0302f;color:#ffffff;">-65.2%</td></tr><tr><td class="text" data-sort="encompass health" style="">Encompass Health</td><td class="text text" data-sort="ehc" style=""><a href="#company-ehc">EHC</a></td><td class="" data-sort="11018041815.599998" style="">$11.0B</td><td class="" data-sort="0.14624618902439024" style="background:#2f9e44;color:#111820;">+14.6%</td><td class="" data-sort="-0.020516160547097595" style="background:#fbd5d4;color:#111820;">-2.1%</td><td class="" data-sort="0.315150852645387" style="background:#7cc077;color:#111820;">+31.5%</td></tr><tr><td class="text" data-sort="pacs group" style="">PACS Group</td><td class="text text" data-sort="pacs" style=""><a href="#company-pacs">PACS</a></td><td class="" data-sort="7282112019.759999" style="">$7.3B</td><td class="" data-sort="0.17218543046357615" style="background:#1a7a3c;color:#ffffff;">+17.2%</td><td class="" data-sort="2.672199170124481" style="background:#1a7a3c;color:#ffffff;">+267.2%</td><td class="" data-sort="0.07090997095837359" style="background:#d6ecd4;color:#111820;">+7.1%</td></tr></tbody></table></div>

<h3 id="category-health-care-real-estate"><a href="#subcategory-performance">Health Care Real Estate</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +7.6%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="healthpeak properties" style="">Healthpeak properties</td><td class="text text" data-sort="doc" style=""><a href="#company-doc">DOC</a></td><td class="" data-sort="15050032094.659998" style="">$15.1B</td><td class="" data-sort="0.08464267612772414" style="background:#7cc077;color:#111820;">+8.5%</td><td class="" data-sort="0.20563380281690136" style="background:#7cc077;color:#111820;">+20.6%</td><td class="" data-sort="-0.04719501335707932" style="background:#fbd5d4;color:#111820;">-4.7%</td></tr><tr><td class="text" data-sort="ventas, inc" style="">Ventas, Inc</td><td class="text text" data-sort="vtr" style=""><a href="#company-vtr">VTR</a></td><td class="" data-sort="47965614030.090004" style="">$48.0B</td><td class="" data-sort="0.055341347244272976" style="background:#a9d9a4;color:#111820;">+5.5%</td><td class="" data-sort="0.3727688449623838" style="background:#1a7a3c;color:#ffffff;">+37.3%</td><td class="" data-sort="0.5619335347432024" style="background:#7cc077;color:#111820;">+56.2%</td></tr><tr><td class="text" data-sort="medical properties trust" style="">Medical Properties Trust</td><td class="text text" data-sort="mpt" style=""><a href="#company-mpt">MPT</a></td><td class="" data-sort="2769203000.0" style="">$2.8B</td><td class="" data-sort="-0.1889763779527559" style="background:#c0302f;color:#ffffff;">-18.9%</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td></tr><tr><td class="text" data-sort="national health investors" style="">National Health Investors</td><td class="text text" data-sort="nhi" style=""><a href="#company-nhi">NHI</a></td><td class="" data-sort="3715308205.3500004" style="">$3.7B</td><td class="" data-sort="-0.04004187385501179" style="background:#f5aead;color:#111820;">-4.0%</td><td class="" data-sort="-0.05791704122255048" style="background:#fbd5d4;color:#111820;">-5.8%</td><td class="" data-sort="-0.06702276484802239" style="background:#fbd5d4;color:#111820;">-6.7%</td></tr><tr><td class="text" data-sort="omega healthcare investors" style="">Omega Healthcare Investors</td><td class="text text" data-sort="ohi" style=""><a href="#company-ohi">OHI</a></td><td class="" data-sort="15143989930.0" style="">$15.1B</td><td class="" data-sort="-0.02693110647181629" style="background:#fbd5d4;color:#111820;">-2.7%</td><td class="" data-sort="0.10293421675343128" style="background:#a9d9a4;color:#111820;">+10.3%</td><td class="" data-sort="0.20036054596961117" style="background:#d6ecd4;color:#111820;">+20.0%</td></tr><tr><td class="text" data-sort="welltower" style="">Welltower</td><td class="text text" data-sort="well" style=""><a href="#company-well">WELL</a></td><td class="" data-sort="166862860587.27" style="">$166.9B</td><td class="" data-sort="0.1066290419577185" style="background:#7cc077;color:#111820;">+10.7%</td><td class="" data-sort="0.4548440065681445" style="background:#1a7a3c;color:#ffffff;">+45.5%</td><td class="" data-sort="1.004021110831867" style="background:#1a7a3c;color:#ffffff;">+100.4%</td></tr><tr><td class="text" data-sort="caretrust reit" style="">CareTrust REIT</td><td class="text text" data-sort="ctre" style=""><a href="#company-ctre">CTRE</a></td><td class="" data-sort="9648051197.400002" style="">$9.6B</td><td class="" data-sort="-0.03791929995138554" style="background:#f5aead;color:#111820;">-3.8%</td><td class="" data-sort="0.14924506387921022" style="background:#a9d9a4;color:#111820;">+14.9%</td><td class="" data-sort="0.3550154056829853" style="background:#a9d9a4;color:#111820;">+35.5%</td></tr><tr><td class="text" data-sort="sabra health care reit" style="">Sabra Health Care REIT</td><td class="text text" data-sort="sbra" style=""><a href="#company-sbra">SBRA</a></td><td class="" data-sort="5277860538.96" style="">$5.3B</td><td class="" data-sort="-0.015926640926640867" style="background:#fbd5d4;color:#111820;">-1.6%</td><td class="" data-sort="0.04296675191815846" style="background:#d6ecd4;color:#111820;">+4.3%</td><td class="" data-sort="0.22609741431148533" style="background:#a9d9a4;color:#111820;">+22.6%</td></tr></tbody></table></div>

<h3 id="category-value-based-care"><a href="#subcategory-performance">Value-Based Care</a><span class="return-badge category-return" style="background:#d6ecd4;color:#111820;">Last 3m: +2.2%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="privia health group" style="">Privia Health Group</td><td class="text text" data-sort="prva" style=""><a href="#company-prva">PRVA</a></td><td class="" data-sort="2982712892.5800004" style="">$3.0B</td><td class="" data-sort="-0.07327775340061427" style="background:#f5aead;color:#111820;">-7.3%</td><td class="" data-sort="-0.03956343792632999" style="background:#fbd5d4;color:#111820;">-4.0%</td><td class="" data-sort="0.012464046021092967" style="background:#d6ecd4;color:#111820;">+1.2%</td></tr><tr><td class="text" data-sort="astrana health" style="">Astrana Health</td><td class="text text" data-sort="asth" style=""><a href="#company-asth">ASTH</a></td><td class="" data-sort="1763186344.0800002" style="">$1.8B</td><td class="" data-sort="0.039630118890356725" style="background:#d6ecd4;color:#111820;">+4.0%</td><td class="" data-sort="0.2825945241199479" style="background:#d6ecd4;color:#111820;">+28.3%</td><td class="" data-sort="-0.18225270157938478" style="background:#f5aead;color:#111820;">-18.2%</td></tr><tr><td class="text" data-sort="agilon health" style="">Agilon Health</td><td class="text text" data-sort="agl" style=""><a href="#company-agl">AGL</a></td><td class="" data-sort="2073627800.0" style="">$2.1B</td><td class="" data-sort="0.11795346683643948" style="background:#7cc077;color:#111820;">+11.8%</td><td class="" data-sort="1.9046616541353383" style="background:#1a7a3c;color:#ffffff;">+190.5%</td><td class="" data-sort="-0.13767857142857143" style="background:#fbd5d4;color:#111820;">-13.8%</td></tr><tr><td class="text" data-sort="evolent health" style="">Evolent Health</td><td class="text text" data-sort="evh" style=""><a href="#company-evh">EVH</a></td><td class="" data-sort="347566497.03" style="">$347.6M</td><td class="" data-sort="0.19999999999999996" style="background:#1a7a3c;color:#ffffff;">+20.0%</td><td class="" data-sort="-0.50625" style="background:#f5aead;color:#111820;">-50.6%</td><td class="" data-sort="-0.8562329390354868" style="background:#c0302f;color:#ffffff;">-85.6%</td></tr><tr><td class="text" data-sort="p3 health" style="">P3 Health</td><td class="text text" data-sort="piii" style=""><a href="#company-piii">PIII</a></td><td class="" data-sort="32693184.14" style="">$32.7M</td><td class="" data-sort="-0.21893939393939388" style="background:#c0302f;color:#ffffff;">-21.9%</td><td class="" data-sort="0.43393602225312944" style="background:#a9d9a4;color:#111820;">+43.4%</td><td class="" data-sort="-0.585027168444355" style="background:#e34948;color:#111820;">-58.5%</td></tr></tbody></table></div>

<h3 id="category-outpatient-and-home-providers"><a href="#subcategory-performance">Outpatient and Home Providers</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +10.9%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="davita" style="">Davita</td><td class="text text" data-sort="dva" style=""><a href="#company-dva">DVA</a></td><td class="" data-sort="15410176650.0" style="">$15.4B</td><td class="" data-sort="-0.12442071327825921" style="background:#fbd5d4;color:#111820;">-12.4%</td><td class="" data-sort="0.238387004844685" style="background:#d6ecd4;color:#111820;">+23.8%</td><td class="" data-sort="0.1287745957529709" style="background:#d6ecd4;color:#111820;">+12.9%</td></tr><tr><td class="text" data-sort="fresenius" style="">Fresenius</td><td class="text text" data-sort="fms" style=""><a href="#company-fms">FMS</a></td><td class="" data-sort="13782736811.6" style="">$13.8B</td><td class="" data-sort="0.08271719038817005" style="background:#d6ecd4;color:#111820;">+8.3%</td><td class="" data-sort="-0.08476562500000007" style="background:#fbd5d4;color:#111820;">-8.5%</td><td class="" data-sort="0.20462724935732646" style="background:#d6ecd4;color:#111820;">+20.5%</td></tr><tr><td class="text" data-sort="surgery partners" style="">Surgery Partners</td><td class="text text" data-sort="sgry" style=""><a href="#company-sgry">SGRY</a></td><td class="" data-sort="2014137694.8" style="">$2.0B</td><td class="" data-sort="0.08358208955223878" style="background:#d6ecd4;color:#111820;">+8.4%</td><td class="" data-sort="-0.3857868020304569" style="background:#f5aead;color:#111820;">-38.6%</td><td class="" data-sort="-0.5690115761353517" style="background:#fbd5d4;color:#111820;">-56.9%</td></tr><tr><td class="text" data-sort="option care health" style="">Option Care Health</td><td class="text text" data-sort="opch" style=""><a href="#company-opch">OPCH</a></td><td class="" data-sort="3449554146.29" style="">$3.4B</td><td class="" data-sort="0.13234591495461068" style="background:#d6ecd4;color:#111820;">+13.2%</td><td class="" data-sort="-0.17536534446764085" style="background:#fbd5d4;color:#111820;">-17.5%</td><td class="" data-sort="-0.2554194156456173" style="background:#fbd5d4;color:#111820;">-25.5%</td></tr><tr><td class="text" data-sort="lifestance health" style="">Lifestance Health</td><td class="text text" data-sort="lfst" style=""><a href="#company-lfst">LFST</a></td><td class="" data-sort="4001624847.36" style="">$4.0B</td><td class="" data-sort="0.6874154262516916" style="background:#1a7a3c;color:#ffffff;">+68.7%</td><td class="" data-sort="1.246846846846847" style="background:#1a7a3c;color:#ffffff;">+124.7%</td><td class="" data-sort="1.0177993527508091" style="background:#a9d9a4;color:#111820;">+101.8%</td></tr><tr><td class="text" data-sort="chemed (vitas)" style="">Chemed (Vitas)</td><td class="text text" data-sort="che" style=""><a href="#company-che">CHE</a></td><td class="" data-sort="7054119350.92" style="">$7.1B</td><td class="" data-sort="0.23035779315367821" style="background:#a9d9a4;color:#111820;">+23.0%</td><td class="" data-sort="0.17758414116109367" style="background:#d6ecd4;color:#111820;">+17.8%</td><td class="" data-sort="-0.055558467424917324" style="background:#fbd5d4;color:#111820;">-5.6%</td></tr><tr><td class="text" data-sort="addus homecare" style="">Addus HomeCare</td><td class="text text" data-sort="adus" style=""><a href="#company-adus">ADUS</a></td><td class="" data-sort="2121438440.1599998" style="">$2.1B</td><td class="" data-sort="0.30393955747436574" style="background:#a9d9a4;color:#111820;">+30.4%</td><td class="" data-sort="0.02026855839878383" style="background:#d6ecd4;color:#111820;">+2.0%</td><td class="" data-sort="-0.09559814343464601" style="background:#fbd5d4;color:#111820;">-9.6%</td></tr><tr><td class="text" data-sort="pennant group" style="">Pennant Group</td><td class="text text" data-sort="pntg" style=""><a href="#company-pntg">PNTG</a></td><td class="" data-sort="1342375375.77" style="">$1.3B</td><td class="" data-sort="0.14622641509433953" style="background:#d6ecd4;color:#111820;">+14.6%</td><td class="" data-sort="0.5446960667461263" style="background:#a9d9a4;color:#111820;">+54.5%</td><td class="" data-sort="0.11212814645308922" style="background:#d6ecd4;color:#111820;">+11.2%</td></tr><tr><td class="text" data-sort="us physical therapy" style="">US Physical Therapy</td><td class="text text" data-sort="usph" style=""><a href="#company-usph">USPH</a></td><td class="" data-sort="1154497333.54" style="">$1.2B</td><td class="" data-sort="0.2622659780503549" style="background:#a9d9a4;color:#111820;">+26.2%</td><td class="" data-sort="-0.10545579320599352" style="background:#fbd5d4;color:#111820;">-10.5%</td><td class="" data-sort="-0.07782101167315181" style="background:#fbd5d4;color:#111820;">-7.8%</td></tr><tr><td class="text" data-sort="brightspring health services" style="">BrightSpring Health Services</td><td class="text text" data-sort="btsg" style=""><a href="#company-btsg">BTSG</a></td><td class="" data-sort="12419938407.57" style="">$12.4B</td><td class="" data-sort="0.006324786324786391" style="background:#d6ecd4;color:#111820;">+0.6%</td><td class="" data-sort="1.3671089666264575" style="background:#1a7a3c;color:#ffffff;">+136.7%</td><td class="" data-sort="3.6833731105807477" style="background:#1a7a3c;color:#ffffff;">+368.3%</td></tr><tr><td class="text" data-sort="aveanna healthcare" style="">Aveanna Healthcare</td><td class="text text" data-sort="avah" style=""><a href="#company-avah">AVAH</a></td><td class="" data-sort="2038188700.08" style="">$2.0B</td><td class="" data-sort="0.7953615279672579" style="background:#1a7a3c;color:#ffffff;">+79.5%</td><td class="" data-sort="0.7617135207496655" style="background:#7cc077;color:#111820;">+76.2%</td><td class="" data-sort="1.35" style="background:#a9d9a4;color:#111820;">+135.0%</td></tr></tbody></table></div>

<h3 id="category-digital-health-specialty-benefits"><a href="#subcategory-performance">Digital Health, Specialty, Benefits</a><span class="return-badge category-return" style="background:#7cc077;color:#111820;">Last 3m: +26.2%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="teladoc" style="">Teladoc</td><td class="text text" data-sort="tdoc" style=""><a href="#company-tdoc">TDOC</a></td><td class="" data-sort="1219099780.91" style="">$1.2B</td><td class="" data-sort="-0.027397260273972712" style="background:#fbd5d4;color:#111820;">-2.7%</td><td class="" data-sort="-0.16796875" style="background:#fbd5d4;color:#111820;">-16.8%</td><td class="" data-sort="-0.13881401617250677" style="background:#fbd5d4;color:#111820;">-13.9%</td></tr><tr><td class="text" data-sort="amwell" style="">Amwell</td><td class="text text" data-sort="amwl" style=""><a href="#company-amwl">AMWL</a></td><td class="" data-sort="179616192.25" style="">$179.6M</td><td class="" data-sort="0.4949748743718594" style="background:#1a7a3c;color:#ffffff;">+49.5%</td><td class="" data-sort="0.6643356643356644" style="background:#2f9e44;color:#111820;">+66.4%</td><td class="" data-sort="0.3192904656319291" style="background:#d6ecd4;color:#111820;">+31.9%</td></tr><tr><td class="text" data-sort="talkspace" style="">Talkspace</td><td class="text text" data-sort="talk" style=""><a href="#company-talk">TALK</a></td><td class="" data-sort="874415594.52" style="">$874.4M</td><td class="" data-sort="0.009615384615384581" style="background:#d6ecd4;color:#111820;">+1.0%</td><td class="" data-sort="0.8750000000000002" style="background:#1a7a3c;color:#ffffff;">+87.5%</td><td class="" data-sort="1.9661016949152543" style="background:#1a7a3c;color:#ffffff;">+196.6%</td></tr><tr><td class="text" data-sort="hims &amp; hers" style="">Hims &amp; Hers</td><td class="text text" data-sort="hims" style=""><a href="#company-hims">HIMS</a></td><td class="" data-sort="6427580190.15" style="">$6.4B</td><td class="" data-sort="0.4223157894736842" style="background:#1a7a3c;color:#ffffff;">+42.2%</td><td class="" data-sort="-0.24209109266322637" style="background:#f5aead;color:#111820;">-24.2%</td><td class="" data-sort="1.0191273161984458" style="background:#7cc077;color:#111820;">+101.9%</td></tr><tr><td class="text" data-sort="lifemd" style="">LifeMD</td><td class="text text" data-sort="lfmd" style=""><a href="#company-lfmd">LFMD</a></td><td class="" data-sort="169268785.0" style="">$169.3M</td><td class="" data-sort="-0.21002386634844872" style="background:#ee8483;color:#111820;">-21.0%</td><td class="" data-sort="-0.47709320695102686" style="background:#ee8483;color:#111820;">-47.7%</td><td class="" data-sort="-0.3926605504587156" style="background:#fbd5d4;color:#111820;">-39.3%</td></tr><tr><td class="text" data-sort="omada health" style="">Omada Health</td><td class="text text" data-sort="omda" style=""><a href="#company-omda">OMDA</a></td><td class="" data-sort="1179458378.8799999" style="">$1.2B</td><td class="" data-sort="0.4470018170805572" style="background:#1a7a3c;color:#ffffff;">+44.7%</td><td class="" data-sort="0.12080694346704202" style="background:#d6ecd4;color:#111820;">+12.1%</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td></tr><tr><td class="text" data-sort="goodrx" style="">GoodRx</td><td class="text text" data-sort="gdrx" style=""><a href="#company-gdrx">GDRX</a></td><td class="" data-sort="1039733395.1099999" style="">$1.0B</td><td class="" data-sort="0.30188679245283034" style="background:#2f9e44;color:#111820;">+30.2%</td><td class="" data-sort="-0.24342105263157887" style="background:#f5aead;color:#111820;">-24.3%</td><td class="" data-sort="-0.5808019441069259" style="background:#f5aead;color:#111820;">-58.1%</td></tr><tr><td class="text" data-sort="progyny" style="">Progyny</td><td class="text text" data-sort="pgny" style=""><a href="#company-pgny">PGNY</a></td><td class="" data-sort="2465903007.6" style="">$2.5B</td><td class="" data-sort="0.030948553054662264" style="background:#d6ecd4;color:#111820;">+3.1%</td><td class="" data-sort="0.09009774755631095" style="background:#d6ecd4;color:#111820;">+9.0%</td><td class="" data-sort="0.17660550458715596" style="background:#d6ecd4;color:#111820;">+17.7%</td></tr><tr><td class="text" data-sort="concentra group" style="">Concentra Group</td><td class="text text" data-sort="con" style=""><a href="#company-con">CON</a></td><td class="" data-sort="3982170593.6" style="">$4.0B</td><td class="" data-sort="0.382306477093207" style="background:#2f9e44;color:#111820;">+38.2%</td><td class="" data-sort="0.4799154334038056" style="background:#7cc077;color:#111820;">+48.0%</td><td class="" data-sort="0.49572649572649574" style="background:#a9d9a4;color:#111820;">+49.6%</td></tr><tr><td class="text" data-sort="healthequity" style="">HealthEquity</td><td class="text text" data-sort="hqy" style=""><a href="#company-hqy">HQY</a></td><td class="" data-sort="8775718420.289999" style="">$8.8B</td><td class="" data-sort="0.19634547724435358" style="background:#a9d9a4;color:#111820;">+19.6%</td><td class="" data-sort="0.17356936094411046" style="background:#d6ecd4;color:#111820;">+17.4%</td><td class="" data-sort="0.37575045679979113" style="background:#d6ecd4;color:#111820;">+37.6%</td></tr></tbody></table></div>

<h3 id="category-health-it-and-data"><a href="#subcategory-performance">Health IT and Data</a><span class="return-badge category-return" style="background:#fbd5d4;color:#111820;">Last 3m: -9.6%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="oracle-cerner" style="">Oracle-Cerner</td><td class="text text" data-sort="orcl" style=""><a href="#company-orcl">ORCL</a></td><td class="" data-sort="374086768770.0" style="">$374.1B</td><td class="" data-sort="-0.2374531445231154" style="background:#ee8483;color:#111820;">-23.7%</td><td class="" data-sort="-0.38033591403308376" style="background:#ee8483;color:#111820;">-38.0%</td><td class="" data-sort="0.05230260794597319" style="background:#d6ecd4;color:#111820;">+5.2%</td></tr><tr><td class="text" data-sort="veradigm" style="">Veradigm</td><td class="text text" data-sort="mdrx" style=""><a href="#company-mdrx">MDRX</a></td><td class="" data-sort="n/a" style="">n/a</td><td class="" data-sort="0.010526315789473717" style="background:#d6ecd4;color:#111820;">+1.1%</td><td class="" data-sort="-0.010309278350515427" style="background:#fbd5d4;color:#111820;">-1.0%</td><td class="" data-sort="-0.5051546391752577" style="background:#ee8483;color:#111820;">-50.5%</td></tr><tr><td class="text" data-sort="waystar" style="">Waystar</td><td class="text text" data-sort="way" style=""><a href="#company-way">WAY</a></td><td class="" data-sort="4047809061.7599998" style="">$4.0B</td><td class="" data-sort="0.277976494634645" style="background:#7cc077;color:#111820;">+27.8%</td><td class="" data-sort="-0.309878587196468" style="background:#f5aead;color:#111820;">-31.0%</td><td class="" data-sort="-0.05229253505115572" style="background:#fbd5d4;color:#111820;">-5.2%</td></tr><tr><td class="text" data-sort="solventum" style="">Solventum</td><td class="text text" data-sort="solv" style=""><a href="#company-solv">SOLV</a></td><td class="" data-sort="13571702000.0" style="">$13.6B</td><td class="" data-sort="0.16582064297800336" style="background:#a9d9a4;color:#111820;">+16.6%</td><td class="" data-sort="0.21781101291638327" style="background:#a9d9a4;color:#111820;">+21.8%</td><td class="" data-sort="0.45879478827361564" style="background:#7cc077;color:#111820;">+45.9%</td></tr><tr><td class="text" data-sort="phreesia" style="">Phreesia</td><td class="text text" data-sort="phr" style=""><a href="#company-phr">PHR</a></td><td class="" data-sort="663241568.97" style="">$663.2M</td><td class="" data-sort="0.358744394618834" style="background:#2f9e44;color:#111820;">+35.9%</td><td class="" data-sort="-0.5926050420168067" style="background:#e34948;color:#111820;">-59.3%</td><td class="" data-sort="-0.5230224321133412" style="background:#e34948;color:#111820;">-52.3%</td></tr><tr><td class="text" data-sort="consensus cloud solutions" style="">Consensus Cloud Solutions</td><td class="text text" data-sort="ccsi" style=""><a href="#company-ccsi">CCSI</a></td><td class="" data-sort="669685380.0" style="">$669.7M</td><td class="" data-sort="0.3760425909494234" style="background:#2f9e44;color:#111820;">+37.6%</td><td class="" data-sort="0.44448584202682584" style="background:#7cc077;color:#111820;">+44.4%</td><td class="" data-sort="0.7759963353183694" style="background:#1a7a3c;color:#ffffff;">+77.6%</td></tr><tr><td class="text" data-sort="definitive healthcare" style="">Definitive Healthcare</td><td class="text text" data-sort="dh" style=""><a href="#company-dh">DH</a></td><td class="" data-sort="85548500.0" style="">$85.5M</td><td class="" data-sort="-0.1620511616991317" style="background:#f5aead;color:#111820;">-16.2%</td><td class="" data-sort="-0.8241133004926109" style="background:#c0302f;color:#ffffff;">-82.4%</td><td class="" data-sort="-0.8423620309050772" style="background:#c0302f;color:#ffffff;">-84.2%</td></tr><tr><td class="text" data-sort="iqvia" style="">Iqvia</td><td class="text text" data-sort="iqv" style=""><a href="#company-iqv">IQV</a></td><td class="" data-sort="38684292000.0" style="">$38.7B</td><td class="" data-sort="0.5474687313877307" style="background:#1a7a3c;color:#ffffff;">+54.7%</td><td class="" data-sort="0.3592466649228354" style="background:#7cc077;color:#111820;">+35.9%</td><td class="" data-sort="0.04374723817940773" style="background:#d6ecd4;color:#111820;">+4.4%</td></tr><tr><td class="text" data-sort="health catalyst" style="">Health Catalyst</td><td class="text text" data-sort="hcat" style=""><a href="#company-hcat">HCAT</a></td><td class="" data-sort="154438501.79999998" style="">$154.4M</td><td class="" data-sort="0.18604651162790686" style="background:#a9d9a4;color:#111820;">+18.6%</td><td class="" data-sort="-0.5335365853658536" style="background:#e34948;color:#111820;">-53.4%</td><td class="" data-sort="-0.7895460797799174" style="background:#c0302f;color:#ffffff;">-79.0%</td></tr><tr><td class="text" data-sort="doximity" style="">Doximity</td><td class="text text" data-sort="docs" style=""><a href="#company-docs">DOCS</a></td><td class="" data-sort="3812680930.62" style="">$3.8B</td><td class="" data-sort="0.270310932798395" style="background:#7cc077;color:#111820;">+27.0%</td><td class="" data-sort="-0.6260702686743431" style="background:#e34948;color:#111820;">-62.6%</td><td class="" data-sort="-0.30621747466447546" style="background:#f5aead;color:#111820;">-30.6%</td></tr><tr><td class="text" data-sort="veeva systems" style="">Veeva Systems</td><td class="text text" data-sort="veev" style=""><a href="#company-veev">VEEV</a></td><td class="" data-sort="33102693839.98" style="">$33.1B</td><td class="" data-sort="0.5477305363051759" style="background:#1a7a3c;color:#ffffff;">+54.8%</td><td class="" data-sort="-0.1476999243622361" style="background:#fbd5d4;color:#111820;">-14.8%</td><td class="" data-sort="0.24416562107904638" style="background:#a9d9a4;color:#111820;">+24.4%</td></tr><tr><td class="text" data-sort="omnicell" style="">Omnicell</td><td class="text text" data-sort="omcl" style=""><a href="#company-omcl">OMCL</a></td><td class="" data-sort="1689541469.35" style="">$1.7B</td><td class="" data-sort="-0.19882909254672365" style="background:#f5aead;color:#111820;">-19.9%</td><td class="" data-sort="0.0582986317668055" style="background:#d6ecd4;color:#111820;">+5.8%</td><td class="" data-sort="-0.20580357142857142" style="background:#f5aead;color:#111820;">-20.6%</td></tr></tbody></table></div>

<h3 id="category-pharma-distribution"><a href="#subcategory-performance">Pharma Distribution</a><span class="return-badge category-return" style="background:#a9d9a4;color:#111820;">Last 3m: +13.7%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="mckesson" style="">McKesson</td><td class="text text" data-sort="mck" style=""><a href="#company-mck">MCK</a></td><td class="" data-sort="97224871780.34999" style="">$97.2B</td><td class="" data-sort="0.12116228070175428" style="background:#a9d9a4;color:#111820;">+12.1%</td><td class="" data-sort="0.24577561824642813" style="background:#7cc077;color:#111820;">+24.6%</td><td class="" data-sort="0.5555555555555556" style="background:#7cc077;color:#111820;">+55.6%</td></tr><tr><td class="text" data-sort="cardinal health" style="">Cardinal Health</td><td class="text text" data-sort="cah" style=""><a href="#company-cah">CAH</a></td><td class="" data-sort="54698777435.25" style="">$54.7B</td><td class="" data-sort="0.1436615507275263" style="background:#a9d9a4;color:#111820;">+14.4%</td><td class="" data-sort="0.549696151249156" style="background:#1a7a3c;color:#ffffff;">+55.0%</td><td class="" data-sort="1.0971308479532165" style="background:#1a7a3c;color:#ffffff;">+109.7%</td></tr><tr><td class="text" data-sort="cencora" style="">Cencora</td><td class="text text" data-sort="cor" style=""><a href="#company-cor">COR</a></td><td class="" data-sort="59590161456.799995" style="">$59.6B</td><td class="" data-sort="0.15688770870466695" style="background:#a9d9a4;color:#111820;">+15.7%</td><td class="" data-sort="0.08694463431305532" style="background:#d6ecd4;color:#111820;">+8.7%</td><td class="" data-sort="0.33776394380415575" style="background:#a9d9a4;color:#111820;">+33.8%</td></tr><tr><td class="text" data-sort="accendra health" style="">Accendra Health</td><td class="text text" data-sort="ahco" style=""><a href="#company-ahco">AHCO</a></td><td class="" data-sort="912923359.92" style="">$912.9M</td><td class="" data-sort="-0.4612440191387559" style="background:#c0302f;color:#ffffff;">-46.1%</td><td class="" data-sort="-0.41415192507804366" style="background:#e34948;color:#111820;">-41.4%</td><td class="" data-sort="-0.4612440191387559" style="background:#ee8483;color:#111820;">-46.1%</td></tr><tr><td class="text" data-sort="henry schein" style="">Henry Schein</td><td class="text text" data-sort="hsic" style=""><a href="#company-hsic">HSIC</a></td><td class="" data-sort="10151122216.27" style="">$10.2B</td><td class="" data-sort="0.19256164937339992" style="background:#7cc077;color:#111820;">+19.3%</td><td class="" data-sort="0.27155172413793105" style="background:#7cc077;color:#111820;">+27.2%</td><td class="" data-sort="0.24964699237503551" style="background:#a9d9a4;color:#111820;">+25.0%</td></tr></tbody></table></div>

<h3 id="category-precision-diagnostics"><a href="#subcategory-performance">Precision Diagnostics</a><span class="return-badge category-return" style="background:#1a7a3c;color:#ffffff;">Last 3m: +49.3%</span></h3>

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="number">Market cap</th><th class="sortable-heading" data-column="3" data-type="number">3m Return</th><th class="sortable-heading" data-column="4" data-type="number">12m Return</th><th class="sortable-heading" data-column="5" data-type="number">24m Return</th></tr></thead><tbody><tr><td class="text" data-sort="natera" style="">Natera</td><td class="text text" data-sort="ntra" style=""><a href="#company-ntra">NTRA</a></td><td class="" data-sort="39411440972.58" style="">$39.4B</td><td class="" data-sort="0.634086323145824" style="background:#a9d9a4;color:#111820;">+63.4%</td><td class="" data-sort="1.005012077294686" style="background:#a9d9a4;color:#111820;">+100.5%</td><td class="" data-sort="1.7058104473963" style="background:#a9d9a4;color:#111820;">+170.6%</td></tr><tr><td class="text" data-sort="neogenomics" style="">NeoGenomics</td><td class="text text" data-sort="neo" style=""><a href="#company-neo">NEO</a></td><td class="" data-sort="2092864917.6" style="">$2.1B</td><td class="" data-sort="0.8396533044420369" style="background:#7cc077;color:#111820;">+84.0%</td><td class="" data-sort="1.570779712339137" style="background:#7cc077;color:#111820;">+157.1%</td><td class="" data-sort="0.019207683073229287" style="background:#d6ecd4;color:#111820;">+1.9%</td></tr><tr><td class="text" data-sort="billiontoone" style="">BillionToOne</td><td class="text text" data-sort="blln" style=""><a href="#company-blln">BLLN</a></td><td class="" data-sort="6542857599.0" style="">$6.5B</td><td class="" data-sort="0.10602886405959033" style="background:#d6ecd4;color:#111820;">+10.6%</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td><td class="missing" data-sort="—" style="background:#f0efec;color:#111820;">—</td></tr><tr><td class="text" data-sort="guardant health" style="">Guardant Health</td><td class="text text" data-sort="gh" style=""><a href="#company-gh">GH</a></td><td class="" data-sort="21443206004.3" style="">$21.4B</td><td class="" data-sort="0.4349726775956284" style="background:#a9d9a4;color:#111820;">+43.5%</td><td class="" data-sort="1.7799674267100976" style="background:#7cc077;color:#111820;">+178.0%</td><td class="" data-sort="4.881805651274982" style="background:#1a7a3c;color:#ffffff;">+488.2%</td></tr><tr><td class="text" data-sort="tempus ai" style="">Tempus AI</td><td class="text text" data-sort="tem" style=""><a href="#company-tem">TEM</a></td><td class="" data-sort="8489455269.799999" style="">$8.5B</td><td class="" data-sort="0.5740580337808574" style="background:#a9d9a4;color:#111820;">+57.4%</td><td class="" data-sort="-0.09724292101341281" style="background:#fbd5d4;color:#111820;">-9.7%</td><td class="" data-sort="0.11916859122401835" style="background:#d6ecd4;color:#111820;">+11.9%</td></tr><tr><td class="text" data-sort="illumina" style="">Illumina</td><td class="text text" data-sort="ilmn" style=""><a href="#company-ilmn">ILMN</a></td><td class="" data-sort="30654510000.0" style="">$30.7B</td><td class="" data-sort="0.5192853680493041" style="background:#a9d9a4;color:#111820;">+51.9%</td><td class="" data-sort="1.1552062868369353" style="background:#a9d9a4;color:#111820;">+115.5%</td><td class="" data-sort="0.669837887206028" style="background:#d6ecd4;color:#111820;">+67.0%</td></tr><tr><td class="text" data-sort="10x genomics" style="">10x Genomics</td><td class="text text" data-sort="txg" style=""><a href="#company-txg">TXG</a></td><td class="" data-sort="6076123205.54" style="">$6.1B</td><td class="" data-sort="1.7500000000000004" style="background:#1a7a3c;color:#ffffff;">+175.0%</td><td class="" data-sort="3.5538461538461537" style="background:#1a7a3c;color:#ffffff;">+355.4%</td><td class="" data-sort="1.7722435078756922" style="background:#a9d9a4;color:#111820;">+177.2%</td></tr><tr><td class="text" data-sort="pacbio" style="">PacBio</td><td class="text text" data-sort="pacb" style=""><a href="#company-pacb">PACB</a></td><td class="" data-sort="447266430.71999997" style="">$447.3M</td><td class="" data-sort="0.10655737704918034" style="background:#d6ecd4;color:#111820;">+10.7%</td><td class="" data-sort="-0.021739130434782483" style="background:#fbd5d4;color:#111820;">-2.2%</td><td class="" data-sort="-0.13461538461538458" style="background:#fbd5d4;color:#111820;">-13.5%</td></tr><tr><td class="text" data-sort="quidelortho" style="">QuidelOrtho</td><td class="text text" data-sort="qdel" style=""><a href="#company-qdel">QDEL</a></td><td class="" data-sort="1198797586.62" style="">$1.2B</td><td class="" data-sort="0.24283305227656005" style="background:#d6ecd4;color:#111820;">+24.3%</td><td class="" data-sort="-0.47168458781362" style="background:#fbd5d4;color:#111820;">-47.2%</td><td class="" data-sort="-0.672517218395912" style="background:#fbd5d4;color:#111820;">-67.3%</td></tr><tr><td class="text" data-sort="quest diagnostics" style="">Quest Diagnostics</td><td class="text text" data-sort="dgx" style=""><a href="#company-dgx">DGX</a></td><td class="" data-sort="25796461699.2" style="">$25.8B</td><td class="" data-sort="0.2519338148660415" style="background:#d6ecd4;color:#111820;">+25.2%</td><td class="" data-sort="0.3559895688842034" style="background:#d6ecd4;color:#111820;">+35.6%</td><td class="" data-sort="0.5914951810367282" style="background:#d6ecd4;color:#111820;">+59.1%</td></tr><tr><td class="text" data-sort="labcorp holdings" style="">Labcorp Holdings</td><td class="text text" data-sort="lh" style=""><a href="#company-lh">LH</a></td><td class="" data-sort="25268305999.999996" style="">$25.3B</td><td class="" data-sort="0.29396375947370434" style="background:#d6ecd4;color:#111820;">+29.4%</td><td class="" data-sort="0.20907326191674436" style="background:#d6ecd4;color:#111820;">+20.9%</td><td class="" data-sort="0.4567109879163238" style="background:#d6ecd4;color:#111820;">+45.7%</td></tr><tr><td class="text" data-sort="certara" style="">Certara</td><td class="text text" data-sort="cert" style=""><a href="#company-cert">CERT</a></td><td class="" data-sort="1189802484.0" style="">$1.2B</td><td class="" data-sort="0.6087786259541983" style="background:#a9d9a4;color:#111820;">+60.9%</td><td class="" data-sort="-0.26503923278116837" style="background:#fbd5d4;color:#111820;">-26.5%</td><td class="" data-sort="-0.3656884875846501" style="background:#fbd5d4;color:#111820;">-36.6%</td></tr></tbody></table></div>


## Upcoming Earnings

### Digital Health, Specialty, Benefits

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="text">Date</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">3m Return</th><th class="sortable-heading" data-column="5" data-type="number">12m Return</th></tr></thead><tbody><tr><td class="text" data-sort="healthequity" style="">HealthEquity</td><td class="text text" data-sort="hqy" style=""><a href="#company-hqy">HQY</a></td><td class="text" data-sort="2026-08-27" style="">August 27, 2026</td><td class="" data-sort="8775718420.289999" style="">$8.8B</td><td class="" data-sort="0.19634547724435358" style="background:#1a7a3c;color:#ffffff;">+19.6%</td><td class="" data-sort="0.17356936094411046" style="background:#1a7a3c;color:#ffffff;">+17.4%</td></tr></tbody></table></div>

### Health IT and Data

<div class="table-wrap"><table class="sortable"><thead><tr><th class="sortable-heading" data-column="0" data-type="text">Company</th><th class="sortable-heading" data-column="1" data-type="text">Ticker</th><th class="sortable-heading" data-column="2" data-type="text">Date</th><th class="sortable-heading" data-column="3" data-type="number">Market cap</th><th class="sortable-heading" data-column="4" data-type="number">3m Return</th><th class="sortable-heading" data-column="5" data-type="number">12m Return</th></tr></thead><tbody><tr><td class="text" data-sort="veeva systems" style="">Veeva Systems</td><td class="text text" data-sort="veev" style=""><a href="#company-veev">VEEV</a></td><td class="text" data-sort="2026-08-26" style="">August 26, 2026</td><td class="" data-sort="33102693839.98" style="">$33.1B</td><td class="" data-sort="0.5477305363051759" style="background:#1a7a3c;color:#ffffff;">+54.8%</td><td class="" data-sort="-0.1476999243622361" style="background:#c0302f;color:#ffffff;">-14.8%</td></tr></tbody></table></div>


## Recent Earnings Highlights — 3m Ret

No earnings highlights fall within this report's window.

## Company Overviews

<h3 id="company-unh">UnitedHealth (UNH)</h3>

*Payers · $380.1B · 3m +0.4% · 12m +26.9% · 24m -33.3%*

[Google Finance](https://www.google.com/finance/quote/UNH:NYSE?tab=earnings&hl=en)

Diversified healthcare company operating UHC insurance businesses and the Optum health services platform.

![UnitedHealth versus category peers and the S&P 500](assets/earnings-unh-3m.webp)

UnitedHealth Group is one of the largest private health insurers and provides medical benefits to about 51 million members globally, including 1 million outside the US as of December 2025. As a leader in employer-sponsored, self-directed, and government-backed insurance plans, UnitedHealth has obtained massive scale in medical insurance. Along with its insurance assets, UnitedHealth's Optum franchises help create a healthcare services colossus that spans everything from pharmaceutical benefits to providing outpatient care and analytics to affiliates and third parties.

<h3 id="company-cvs">CVS Health (CVS)</h3>

*Payers · $135.1B · 3m -0.3% · 12m +30.5% · 24m +58.3%*

[Google Finance](https://www.google.com/finance/quote/CVS:NYSE?tab=earnings&hl=en)

Healthcare retail ecosystem.

![CVS Health versus category peers and the S&P 500](assets/earnings-cvs-3m.webp)

CVS Health offers a diverse set of healthcare services. Its roots are in its retail pharmacy operations, where it operates around 9,000 stores primarily in the US. CVS is also a large pharmacy benefit manager (acquired through Caremark), processing about 2 billion adjusted claims annually. It operates a top-tier health insurer (acquired through Aetna) through which it serves about 27 million medical members. The acquisition of Oak Street Health added primary care services to the mix, which could have significant synergies with all existing business lines.

<h3 id="company-hum">Humana (HUM)</h3>

*Payers · $43.7B · 3m +23.0% · 12m +26.5% · 24m +7.4%*

[Google Finance](https://www.google.com/finance/quote/HUM:NYSE?tab=earnings&hl=en)

Large payer, Medicare and Medicare Advantage focused.

![Humana versus category peers and the S&P 500](assets/earnings-hum-3m.webp)

Humana is one of the largest private health insurers in the US, and the firm has built a niche specializing in government-sponsored programs, with nearly all its medical membership stemming from Medicare, Medicaid, and the military's Tricare program. Beyond medical insurance, the company provides other healthcare services, including primary-care services, at-home services, and pharmacy benefit management.

<h3 id="company-oscr">Oscar Health (OSCR)</h3>

*Payers · $9.4B · 3m +41.5% · 12m +90.7% · 24m +80.8%*

[Google Finance](https://www.google.com/finance/quote/OSCR:NYSE?tab=earnings&hl=en)

Tech-focused payer with large exposure to exchange products and ICHRAs.

![Oscar Health versus category peers and the S&P 500](assets/earnings-oscr-3m.webp)

Oscar Health Inc is a healthcare technology company built around a full stack technology platform and a relentless focus on serving its members. It offers Individual & Family plans and health technology solutions that power the healthcare industry. Oscar operates as one segment to sell insurance to individuals, families and employees through the federal and state-run healthcare exchanges formed in conjunction with the Patient Protection and Affordable Care Act (ACA) and leverages its technology platform to provide services via its Oscar offering.

<h3 id="company-moh">Molina Healthcare (MOH)</h3>

*Payers · $10.2B · 3m +8.8% · 12m +14.8% · 24m -42.1%*

[Google Finance](https://www.google.com/finance/quote/MOH:NYSE?tab=earnings&hl=en)

Managed-care company providing health insurance through government programs.

![Molina Healthcare versus category peers and the S&P 500](assets/earnings-moh-3m.webp)

Molina Healthcare Inc provides medical insurance plans through Medicaid, the individual exchanges, and Medicare. The company operates in four reportable segments consisting of: 1) Medicaid; 2) Medicare; 3) Marketplace; and 4) Other. It manages health benefit risks for more than 5 million people, with more than 85% of those members coming through contracts with state governments for their Medicaid programs. Medicaid contracts in four states-California, New York, Texas, and Washington-account for over half of its enrollees.

<h3 id="company-ci">Cigna (CI)</h3>

*Payers · $73.7B · 3m -3.0% · 12m -8.8% · 24m -21.6%*

[Google Finance](https://www.google.com/finance/quote/CI:NYSE?tab=earnings&hl=en)

Employer-focused health insurance company.

![Cigna versus category peers and the S&P 500](assets/earnings-ci-3m.webp)

Cigna primarily provides pharmacy benefit management and health insurance services. Its PBM and specialty pharmacy services, which were greatly expanded by its 2018 merger with Express Scripts, are mostly sold to health insurance plans and employers. Its largest PBM contract is with the Department of Defense, and it recently won a multiyear deal with top-tier insurer Centene. In health insurance and other benefits, Cigna primarily serves employers through self-funding arrangements, and the company operates mostly in the US with 16 million US and 2 million international medical members covered as of December 2025.

<h3 id="company-elv">Elevance (ELV)</h3>

*Payers · $81.5B · 3m +1.5% · 12m +26.5% · 24m -26.6%*

[Google Finance](https://www.google.com/finance/quote/ELV:NYSE?tab=earnings&hl=en)

Health insurance company, previously named Anthem.

![Elevance versus category peers and the S&P 500](assets/earnings-elv-3m.webp)

Elevance Health remains one of the leading health insurers in the US, providing medical benefits to 45 million medical members at the end of 2025. The company offers employer, individual, and government-sponsored coverage plans. Elevance differs from its peers in its unique position as the largest single provider of Blue Cross Blue Shield branded coverage, operating as the licensee for the Blue Cross Blue Shield Association in 14 states. Through acquisitions, such as the Amerigroup deal in 2012 and MMM in 2021, Elevance's reach expands beyond those states in government-sponsored programs, such as Medicaid and Medicare Advantage plans, too. It is also an emerging player in pharmacy benefit management and other healthcare services.

<h3 id="company-clov">Clover Health (CLOV)</h3>

*Payers · $2.2B · 3m +16.9% · 12m +52.0% · 24m +24.3%*

[Google Finance](https://www.google.com/finance/quote/CLOV:NASDAQ?tab=earnings&hl=en)

American healthcare company company providing Medicare Advantage insurance plans.

![Clover Health versus category peers and the S&P 500](assets/earnings-clov-3m.webp)

Clover Health Investments Corp is a healthcare technology company. It focuses on empowering Medicare physicians to proactively manage chronic diseases through its proprietary software platform, Clover Assistant. This cloud-based solution provides personalized insights to physicians, enabling early detection and management of chronic conditions. It operates in one segment: Insurance, through which it offers PPO and HMO plans to Medicare Advantage members in several states.

<h3 id="company-cnc">Centene (CNC)</h3>

*Payers · $30.7B · 3m +9.9% · 12m +121.1% · 24m -17.2%*

[Google Finance](https://www.google.com/finance/quote/CNC:NYSE?tab=earnings&hl=en)

Health insurance for government and privately insured healthcare programs.

![Centene versus category peers and the S&P 500](assets/earnings-cnc-3m.webp)

Centene is a managed care organization that focuses on government-sponsored healthcare plans, including Medicaid, Medicare, and the individual exchanges. Centene served 20 million medical members as of December 2025, mostly in Medicaid (about 64% of membership), the individual exchanges (about 28%), and Medicare (about 5%). The company also provides Medicare Part D pharmaceutical plans.

<h3 id="company-alhc">Alignment Health (ALHC)</h3>

*Payers · $3.1B · 3m -19.5% · 12m -16.9% · 24m +42.0%*

[Google Finance](https://www.google.com/finance/quote/ALHC:NASDAQ?tab=earnings&hl=en)

Tech-enabled Medicare Advantage Company.

![Alignment Health versus category peers and the S&P 500](assets/earnings-alhc-3m.webp)

Alignment Healthcare Inc is a next-generation, consumer-centric platform that is revolutionizing the healthcare experience for seniors through Medicare Advantage plans. These plans are marketed and sold direct-to-consumer, allowing seniors to select the manner in which customers receive healthcare coverage and services on an annual basis. The company combines a technology platform and clinical model for more effective health outcomes.

<h3 id="company-hca">HCA Healthcare (HCA)</h3>

*Health System Providers · $87.2B · 3m +8.9% · 12m +6.0% · 24m +10.4%*

[Google Finance](https://www.google.com/finance/quote/HCA:NYSE?tab=earnings&hl=en)

Largest for-profit hospital and outpatient care operator in the United States.

![HCA Healthcare versus category peers and the S&P 500](assets/earnings-hca-3m.webp)

HCA Healthcare is a Nashville-based healthcare provider organization operating the largest collection of acute-care hospitals in the United States. As of December 2025, the firm owned and operated 190 hospitals and over 2,500 outpatient facillities across 19 states and a small foothold in the United Kingdom.

<h3 id="company-thc">Tenet Health (THC)</h3>

*Health System Providers · $20.5B · 3m +61.6% · 12m +56.4% · 24m +70.6%*

[Google Finance](https://www.google.com/finance/quote/THC:NYSE?tab=earnings&hl=en)

Diversified healthcare provider with hospitals and a leading ambulatory surgery center platform through USPI.

![Tenet Health versus category peers and the S&P 500](assets/earnings-thc-3m.webp)

Tenet Healthcare is a Dallas-based healthcare services organization. It operates acute and specialty hospitals (50 as of December 2025) and hundreds of ambulatory surgery centers and other outpatient facilities across the US, primarily in the South. Through its Conifer segment, Tenet also provides revenue cycle management solutions.

<h3 id="company-uhs">Universal Health Services (UHS)</h3>

*Health System Providers · $10.2B · 3m +12.3% · 12m -4.5% · 24m -24.0%*

[Google Finance](https://www.google.com/finance/quote/UHS:NYSE?tab=earnings&hl=en)

Hospital operator with significant acute care and behavioral health business.

![Universal Health Services versus category peers and the S&P 500](assets/earnings-uhs-3m.webp)

Universal Health Services Inc offers healthcare services through its behavioral health centers, acute care hospitals, and related outpatient facilities. As of late 2025, the company operated 346 inpatient behavioral health centers, 29 acute care hospitals, and many supportive outpatient facilities. Its operations are concentrated in the U.S, particularly in Nevada (21% of 2025 operating profits), Texas (19%), and California (13%), although it does have some exposure to the UK behavioral health market (6% of 2025 sales) too. While its acute care services account for over 55% of revenue, the behavioral health centers sport higher margins and account for over 55% of pretax profits.

<h3 id="company-cyh">Community Health Systems (CYH)</h3>

*Health System Providers · $417.4M · 3m +7.5% · 12m +9.1% · 24m -40.5%*

[Google Finance](https://www.google.com/finance/quote/CYH:NYSE?tab=earnings&hl=en)

Operator of community hospitals primarily serving non-urban and regional markets.

![Community Health Systems versus category peers and the S&P 500](assets/earnings-cyh-3m.webp)

Community Health Systems Inc is a publicly owned hospital operator in the United States. The company also owns four home health agencies and provides management and consulting services to independent hospitals. The firm derives revenue through a broad range of general and specialized hospital healthcare services and outpatient services.

<h3 id="company-ardt">Ardent Health Partners (ARDT)</h3>

*Health System Providers · $1.5B · 3m +19.1% · 12m -15.3% · 24m -36.4%*

[Google Finance](https://www.google.com/finance/quote/ARDT:NYSE?tab=earnings&hl=en)

Regional hospital operator focused on integrated health systems across mid-sized US markets.

![Ardent Health Partners versus category peers and the S&P 500](assets/earnings-ardt-3m.webp)

Ardent Health Inc is a provider of healthcare in growing mid-sized urban communities across the U.S and operating in eight growing mid-sized urban markets across six states Texas, Oklahoma, New Mexico, New Jersey, Idaho, and Kansas. The main focus on people and investments in services and technologies.

<h3 id="company-ensg">The Ensign Group (ENSG)</h3>

*Inpatient Non-Acute Providers · $10.4B · 3m +4.4% · 12m +4.1% · 24m +21.2%*

[Google Finance](https://www.google.com/finance/quote/ENSG:NASDAQ?tab=earnings&hl=en)

Leading operator of skilled nursing facilities, rehabilitation centers, and senior-care services.

![The Ensign Group versus category peers and the S&P 500](assets/earnings-ensg-3m.webp)

Ensign Group Inc provides post-acute healthcare services in the United States. Its regional subsidiaries oversee skilled nursing, assisted living, home health and hospice, mobile ancillary, and urgent care operations. Medicare and Medicaid programs contribute majority of revenue received for Ensign's services. The firm operates through two segments, Skilled services, and Standard Bearer. The skilled services segment includes the operation of skilled nursing facilities and rehabilitation therapy services. The Standard Bearer segment comprises of properties owned by the company through its captive REIT and leased to skilled nursing and assisted living operations. The majority of the revenue is generated from the skilled services segment.

<h3 id="company-achc">Acadia Healthcare (ACHC)</h3>

*Inpatient Non-Acute Providers · $2.8B · 3m +20.0% · 12m +24.0% · 24m -65.2%*

[Google Finance](https://www.google.com/finance/quote/ACHC:NASDAQ?tab=earnings&hl=en)

Largest provider of behavioral health and addiction treatment services.

![Acadia Healthcare versus category peers and the S&P 500](assets/earnings-achc-3m.webp)

Acadia Healthcare Co Inc acquires and develops behavioral healthcare facilities. Its facilities and services are classified into the following categories: acute inpatient psychiatric facilities; specialty treatment facilities; CTCs; and residential treatment centers. In which Acute inpatient psychiatric facilities contribute the majority of revenue in the United States. The Company has one reportable segment, behavioral healthcare services. The behavioral healthcare services segment provides inpatient and outpatient behavioral healthcare services.

<h3 id="company-ehc">Encompass Health (EHC)</h3>

*Inpatient Non-Acute Providers · $11.0B · 3m +14.6% · 12m -2.1% · 24m +31.5%*

[Google Finance](https://www.google.com/finance/quote/EHC:NYSE?tab=earnings&hl=en)

In-patient post-acute rehabilitation services.

![Encompass Health versus category peers and the S&P 500](assets/earnings-ehc-3m.webp)

Encompass Health Corp provides post-acute healthcare services in the United States through a network of inpatient rehabilitation hospitals, which is the company's sole segment. Inpatient rehabilitation contributes the majority of the firm's revenue and provides specialized rehabilitative treatment through a network of inpatient hospitals. The company's inpatient rehabilitation hospitals provide a higher level of rehabilitative care to patients who are recovering from conditions such as stroke and other neurological disorders, cardiac and pulmonary conditions, brain and spinal cord injuries, complex orthopedic conditions, and amputations.

<h3 id="company-pacs">PACS Group (PACS)</h3>

*Inpatient Non-Acute Providers · $7.3B · 3m +17.2% · 12m +267.2% · 24m +7.1%*

[Google Finance](https://www.google.com/finance/quote/PACS:NYSE?tab=earnings&hl=en)

Post-acute care and skilled nursing company.

![PACS Group versus category peers and the S&P 500](assets/earnings-pacs-3m.webp)

PACS Group Inc is a post-acute healthcare company mainly focused on delivering skilled nursing care through a portfolio of independently operated facilities. The post-acute care ecosystem serves individuals who need additional help recuperating from acute conditions, illnesses, or serious medical procedures after getting discharged from the hospital. It also provides senior care, assisted living, and independent living options in some of the communities. The company has one reportable segment.

<h3 id="company-doc">Healthpeak properties (DOC)</h3>

*Health Care Real Estate · $15.1B · 3m +8.5% · 12m +20.6% · 24m -4.7%*

[Google Finance](https://www.google.com/finance/quote/DOC:NYSE?tab=earnings&hl=en)

Healthcare industry real estate investment trust focused on outpatient medical offices, life science properties, an senior housing.

![Healthpeak properties versus category peers and the S&P 500](assets/earnings-doc-3m.webp)

Healthpeak owns a diversified healthcare portfolio of approximately 700 in-place properties spread across mainly medical office and life science assets, plus a handful of senior housing, hospital, and skilled nursing/post-acute care assets, as well.

<h3 id="company-vtr">Ventas, Inc (VTR)</h3>

*Health Care Real Estate · $48.0B · 3m +5.5% · 12m +37.3% · 24m +56.2%*

[Google Finance](https://www.google.com/finance/quote/VTR:NYSE?tab=earnings&hl=en)

Real estate investment trust focused  on ownership and management of senior housing, research, medicine office buildings, and healthcare facilities.

![Ventas, Inc versus category peers and the S&P 500](assets/earnings-vtr-3m.webp)

Ventas owns a diversified healthcare portfolio of almost 1,400 in-place properties spread across the senior housing, medical office, hospital, life science, and skilled nursing/post-acute care. The portfolio includes almost 100 properties in Canada and the United Kingdom as the company looks for additional investment opportunities in countries with mature healthcare systems that operate similarly to the United States. The firm also owns mortgages and other loans, contributing about 1% of net operating income.

<h3 id="company-mpt">Medical Properties Trust (MPT)</h3>

*Health Care Real Estate · $2.8B · 3m -18.9% · 12m n/a · 24m n/a*

[Google Finance](https://www.google.com/finance/quote/MPT:NYSE?tab=earnings&hl=en)

Real estate investment trust for healthcare facilities in the US and Europe.

![Medical Properties Trust versus category peers and the S&P 500](assets/earnings-mpt-3m.webp)

Medical Properties Trust Inc acquires and develops net-leased healthcare facilities. Its investments in healthcare real estate, other loans, and any investments in tenants are considered a single reportable segment. Its business strategy is to acquire and develop healthcare facilities and lease the facilities to healthcare operating companies under long-term net leases, which require the tenant to bear of the costs associated with the property. The group's geographic areas are the United States, the United Kingdom, and All other countries.

<h3 id="company-nhi">National Health Investors (NHI)</h3>

*Health Care Real Estate · $3.7B · 3m -4.0% · 12m -5.8% · 24m -6.7%*

[Google Finance](https://www.google.com/finance/quote/NHI:NYSE?tab=earnings&hl=en)

Healthcare REIT focused on senior housing, skilled nursing, and long-term care properties.

![National Health Investors versus category peers and the S&P 500](assets/earnings-nhi-3m.webp)

National Health Investors Inc is a self-managed REIT that owns, leases, operates, and finances the development of senior housing communities and medical facilities. It operates through two segments: Real Estate Investments and Senior Housing Operating Portfolio (SHOP). The Real Estate Investments segment, which generates the majority of revenue, includes real estate leases, mortgages, and other notes receivable related to independent living facilities, assisted living facilities, entrance fee communities, senior living campuses, skilled nursing facilities, and a hospital. The SHOP segment consists of ventures that own and operate independent living facilities. The company's revenues are derived from rental income, interest and other income, and resident fees and services.

<h3 id="company-ohi">Omega Healthcare Investors (OHI)</h3>

*Health Care Real Estate · $15.1B · 3m -2.7% · 12m +10.3% · 24m +20.0%*

[Google Finance](https://www.google.com/finance/quote/OHI:NYSE?tab=earnings&hl=en)

Healthcare REIT healthcare REIT focused on skilled nursing and assisted living facilities.

![Omega Healthcare Investors versus category peers and the S&P 500](assets/earnings-ohi-3m.webp)

Omega Healthcare Investors Inc is a real estate investment trust that invests in healthcare-related real estate properties located in the United States (U.S.), the United Kingdom (U.K.), and Canada. The company's objective is to provide attractive returns to investors while serving as the preferred capital partner to its third-party healthcare operating companies and affiliates, as well as other third-party healthcare operators, allowing them to focus on delivering a high level of care to their resident patients. Omega's investment portfolio mainly consists of skilled nursing facilities, assisted living facilities (ALFs), including care homes in the U.K., independent living facilities, rehabilitation and acute care facilities, and continuing care retirement communities.

<h3 id="company-well">Welltower (WELL)</h3>

*Health Care Real Estate · $166.9B · 3m +10.7% · 12m +45.5% · 24m +100.4%*

[Google Finance](https://www.google.com/finance/quote/WELL:NYSE?tab=earnings&hl=en)

Largest healthcare REIT, focused on senior housing, outpatient medical, and wellness-oriented healthcare properties.

![Welltower versus category peers and the S&P 500](assets/earnings-well-3m.webp)

Welltower owns a diversified healthcare portfolio of 2,800 in-place properties spread across the senior housing, medical office, and skilled nursing/postacute care sectors. The portfolio includes over 900 properties in Canada and the United Kingdom as the company looks for additional investment opportunities in countries with mature healthcare systems that operate similarly to that of the United States.

<h3 id="company-ctre">CareTrust REIT (CTRE)</h3>

*Health Care Real Estate · $9.6B · 3m -3.8% · 12m +14.9% · 24m +35.5%*

[Google Finance](https://www.google.com/finance/quote/CTRE:NYSE?tab=earnings&hl=en)

Healthcare REIT focused on skilled nursing, senior housing, and other post-acute care facilities.

![CareTrust REIT versus category peers and the S&P 500](assets/earnings-ctre-3m.webp)

CareTrust REIT Inc is a self-administered, publicly traded REIT engaged in the ownership, acquisition, financing, development, and leasing of skilled nursing, seniors housing, and other healthcare-related properties. The company has one reportable segment consisting of investments in healthcare-related real estate assets. It generates revenues by leasing healthcare-related properties to healthcare operators under triple-net lease arrangements, in which the tenant is solely responsible for property-related costs. The company operates in Domestic and Foreign markets, with the majority of revenue coming from Domestic operations.

<h3 id="company-sbra">Sabra Health Care REIT (SBRA)</h3>

*Health Care Real Estate · $5.3B · 3m -1.6% · 12m +4.3% · 24m +22.6%*

[Google Finance](https://www.google.com/finance/quote/SBRA:NASDAQ?tab=earnings&hl=en)

healthcare REIT focused on skilled nursing, senior housing, and behavioral health properties.

![Sabra Health Care REIT versus category peers and the S&P 500](assets/earnings-sbra-3m.webp)

Sabra Health Care REIT Inc is a healthcare facility real estate investment trust. The company operates one segment that owns and invests in healthcare real estate. All of the company's revenue is generated in the United States. Sabra's operations consist of nursing facilities, assisted living centers, and mental health facilities.

<h3 id="company-prva">Privia Health Group (PRVA)</h3>

*Value-Based Care · $3.0B · 3m -7.3% · 12m -4.0% · 24m +1.2%*

[Google Finance](https://www.google.com/finance/quote/PRVA:NASDAQ?tab=earnings&hl=en)

Value-based care company focusing on physician enablement for independent practices.

![Privia Health Group versus category peers and the S&P 500](assets/earnings-prva-3m.webp)

Privia Health Group Inc is one of the physician enablement companies in the United States with a presence in around 24 states and the District of Columbia. The group builds scaled provider networks with primary-care centric medical groups, risk-bearing entities, a physician-led governance structure, and the Privia Platform comprising an extensive suite of technology and service solutions. It collaborates with medical groups, health plans, and health systems to optimize approximately 1,300+ physician practices, improve the patient experience for over 5.8+ million patients, and reward around 5,300+ physicians and practitioners for delivering high-value care.

<h3 id="company-asth">Astrana Health (ASTH)</h3>

*Value-Based Care · $1.8B · 3m +4.0% · 12m +28.3% · 24m -18.2%*

[Google Finance](https://www.google.com/finance/quote/ASTH:NASDAQ?tab=earnings&hl=en)

Physician centric management company that operates and coordinates provider networks to take on risk contracts.

![Astrana Health versus category peers and the S&P 500](assets/earnings-asth-3m.webp)

Astrana Health Inc is a patient-centered, physician-centric integrated population health management company. The company is working to provide coordinated, outcomes-based medical care cost-effectively. It is focused on physicians providing high-quality medical care, population health management, and care coordination for patients, particularly senior patients and patients with multiple chronic conditions. The company's three reportable segments are Care Partners, Care Delivery, and Care Enablement. It generates the majority of its revenue from the Care Partners segment.

<h3 id="company-agl">Agilon Health (AGL)</h3>

*Value-Based Care · $2.1B · 3m +11.8% · 12m +190.5% · 24m -13.8%*

[Google Finance](https://www.google.com/finance/quote/AGL:NYSE?tab=earnings&hl=en)

Value-based care company focused on partnerships with primary care physicians for Medicare Advantage seniors.

![Agilon Health versus category peers and the S&P 500](assets/earnings-agl-3m.webp)

Agilon Health Inc is a healthcare services company that partners with primary care physicians to support value-based care for senior patients. The company provides a platform that enables physician groups to manage healthcare outcomes and costs through a Medicare-centric, capitated care model and long-term partnerships with community-based physicians.

<h3 id="company-evh">Evolent Health (EVH)</h3>

*Value-Based Care · $347.6M · 3m +20.0% · 12m -50.6% · 24m -85.6%*

[Google Finance](https://www.google.com/finance/quote/EVH:NYSE?tab=earnings&hl=en)

Specialty-care management and healthcare-services company focused on oncology, cardiology, and musculoskeletal care.

![Evolent Health versus category peers and the S&P 500](assets/earnings-evh-3m.webp)

Evolent Health Inc is engaged in healthcare delivery and payment. The company supports health systems and physician organizations in their migration toward value-based care and population health management. It provides specialty care management services in oncology, cardiology, musculoskeletal markets and holistic total cost of care management along with an integrated platform for health plan administration and value-based business infrastructure under one go to market package. The solutions provided by the company includes: Oncology, Cardiology, Musculoskeletal, Administrative Services, Advanced Illness, Genetic Testing, Physical Medicine, Radiology, and Surgical Management.

<h3 id="company-piii">P3 Health (PIII)</h3>

*Value-Based Care · $32.7M · 3m -21.9% · 12m +43.4% · 24m -58.5%*

[Google Finance](https://www.google.com/finance/quote/PIII:NASDAQ?tab=earnings&hl=en)

Physician-led population ehalth company focused on coordinating care for Medicare Advantage Patients.

![P3 Health versus category peers and the S&P 500](assets/earnings-piii-3m.webp)

P3 Health Partners Inc is a patient-centered and physician-led population health management company. P3's model aggregates and supports the community's existing healthcare resources to build a network of community providers working together to deliver coordinated and integrated care to patients with a shared commitment to improving patient outcomes, lowering cost, and delivering experience for all. It includes utilization management, care management, disease education, and maintenance of a quality improvement and quality management program for members assigned to the Company. The Company is also responsible for the credentialing of its providers, processing and payment of claims, and the establishment of a provider network for certain health plans.

<h3 id="company-dva">Davita (DVA)</h3>

*Outpatient and Home Providers · $15.4B · 3m -12.4% · 12m +23.8% · 24m +12.9%*

[Google Finance](https://www.google.com/finance/quote/DVA:NYSE?tab=earnings&hl=en)

One of two dominant US dialysis providers.

![Davita versus category peers and the S&P 500](assets/earnings-dva-3m.webp)

DaVita is one of the largest providers of dialysis services in the United States, boasting a market share of about 35%. The firm operates over 3,200 facilities worldwide, mostly in the US, and treats about 300,000 patients annually. Government payers dominate US dialysis reimbursement. DaVita receives about two-thirds of US sales at government (primarily Medicare) reimbursement rates, with the remainder coming from commercial insurers. While commercial insurers represent only about 10% of US patients treated, they represent nearly all of the profits generated by DaVita in the US dialysis business.

<h3 id="company-fms">Fresenius (FMS)</h3>

*Outpatient and Home Providers · $13.8B · 3m +8.3% · 12m -8.5% · 24m +20.5%*

[Google Finance](https://www.google.com/finance/quote/FMS:NYSE?tab=earnings&hl=en)

Global leaders in dialysis clinics, equipment, and renal services.

![Fresenius versus category peers and the S&P 500](assets/earnings-fms-3m.webp)

Fresenius Medical Care is the largest dialysis company in the world, treating nearly 300,000 patients from about 3,600 clinics worldwide as of December 2025. In addition to providing dialysis services, the firm is a leading supplier of dialysis products, including machines, dialyzers, and concentrates. Fresenius accounts for about 35% of the global dialysis products market, creating the world's only fully integrated dialysis business. Services account for about three-fourths of sales, while the balance is generated from medical technology products that enable dialysis treatments.

<h3 id="company-sgry">Surgery Partners (SGRY)</h3>

*Outpatient and Home Providers · $2.0B · 3m +8.4% · 12m -38.6% · 24m -56.9%*

[Google Finance](https://www.google.com/finance/quote/SGRY:NASDAQ?tab=earnings&hl=en)

Operator of Ambulatory Surgery Centers.

![Surgery Partners versus category peers and the S&P 500](assets/earnings-sgry-3m.webp)

Surgery Partners Inc is a healthcare services company with an integrated outpatient delivery model focused on providing quality, cost-effective solutions for surgical and related ancillary care in support of both patients and physicians. It has one reportable segment: Surgical Facilities, which includes the operation of ASCs, surgical hospitals, anesthesia services, and multi-specialty physician practices, which earn revenues from contracts with patients in which the performance obligations are to provide health care services.

<h3 id="company-opch">Option Care Health (OPCH)</h3>

*Outpatient and Home Providers · $3.4B · 3m +13.2% · 12m -17.5% · 24m -25.5%*

[Google Finance](https://www.google.com/finance/quote/OPCH:NASDAQ?tab=earnings&hl=en)

Largest independent provider of home and alternate-site infusion therapy services in the United States.

![Option Care Health versus category peers and the S&P 500](assets/earnings-opch-3m.webp)

Option Care Health Inc is the provider of home and alternate-site infusion services. It provides treatment for bleeding disorders, neurological disorders, heart failure, anti-infectives, and chronic inflammatory disorders, among others. The Company operates in one segment, infusion services.

<h3 id="company-lfst">Lifestance Health (LFST)</h3>

*Outpatient and Home Providers · $4.0B · 3m +68.7% · 12m +124.7% · 24m +101.8%*

[Google Finance](https://www.google.com/finance/quote/LFST:NASDAQ?tab=earnings&hl=en)

Outpatient behavioral-health providers of psychiatry and therapy services.

![Lifestance Health versus category peers and the S&P 500](assets/earnings-lfst-3m.webp)

LifeStance Health Group Inc is a mental healthcare company that operates as a provider of outpatient mental health services, spanning psychiatric evaluations and treatment, psychological and neuropsychological testing, and individual, family, and group therapy. It treats a broad range of mental health conditions, including anxiety, depression, bipolar disorder, eating disorders, psychotic disorders, and post-traumatic stress disorder, using evidence-based approaches to ensure effective treatment. The group has a single operating and reportable segment of mental health services.

<h3 id="company-che">Chemed (Vitas) (CHE)</h3>

*Outpatient and Home Providers · $7.1B · 3m +23.0% · 12m +17.8% · 24m -5.6%*

[Google Finance](https://www.google.com/finance/quote/CHE:NYSE?tab=earnings&hl=en)

Hospice and end of life provider through VITAS healthcare.

![Chemed (Vitas) versus category peers and the S&P 500](assets/earnings-che-3m.webp)

Chemed Corp purchases, operates, and divests subsidiaries engaged in diverse business activities to maximize shareholder value. The company operates in the following segments: VITAS and Roto-Rooter. The VITAS segment generates the majority of the firm's revenue and provides hospice and palliative care services to patients with terminal illnesses through a network of physicians, registered nurses, home health aides, social workers, and volunteers. The Roto-Rooter segment provides plumbing, drain cleaning, water restoration, and related services to residential and commercial customers.

<h3 id="company-adus">Addus HomeCare (ADUS)</h3>

*Outpatient and Home Providers · $2.1B · 3m +30.4% · 12m +2.0% · 24m -9.6%*

[Google Finance](https://www.google.com/finance/quote/ADUS:NASDAQ?tab=earnings&hl=en)

Provider of personal care, hospice, and home health services.

![Addus HomeCare versus category peers and the S&P 500](assets/earnings-adus-3m.webp)

Addus HomeCare Corp is engaged in the provision of in-home care services. The Company has three reportable segments: Personal Care, Hospice, and Home Health. The Personal Care segment provides non-medical assistance with activities of daily living, mainly to the elderly, chronically ill, and disabled individuals. The Hospice segment provides physical, emotional, and spiritual care for terminally ill patients and their families. The Home Health segment provides medical services to individuals requiring care during illness or recovery. It generates the majority of its revenue from the Personal Care segment.

<h3 id="company-pntg">Pennant Group (PNTG)</h3>

*Outpatient and Home Providers · $1.3B · 3m +14.6% · 12m +54.5% · 24m +11.2%*

[Google Finance](https://www.google.com/finance/quote/PNTG:NASDAQ?tab=earnings&hl=en)

provider of home health, hospice, and senior living services.

![Pennant Group versus category peers and the S&P 500](assets/earnings-pntg-3m.webp)

Pennant Group Inc is engaged in providing healthcare services to patients of all ages, including the growing senior population, in the United States. It operates in multiple lines of business including home health, hospice, and senior living which includes the company's assisted living, independent living, and memory care communities across Arizona, California, Colorado, Idaho, Montana, Nevada, Oklahoma, Oregon, Texas, Utah, Washington, Wisconsin, and Wyoming. It operates in two segments; home health and hospice services and senior living services. The company generates majority of its revenue from home health and hospice services segment, which includes its home health, hospice and home care businesses.

<h3 id="company-usph">US Physical Therapy (USPH)</h3>

*Outpatient and Home Providers · $1.2B · 3m +26.2% · 12m -10.5% · 24m -7.8%*

[Google Finance](https://www.google.com/finance/quote/USPH:NYSE?tab=earnings&hl=en)

operator of outpatient physical therapy clinics and industrial injury prevention services.

![US Physical Therapy versus category peers and the S&P 500](assets/earnings-usph-3m.webp)

US Physical Therapy Inc through its subsidiaries operate outpatient physical therapy clinics that provide pre-and post-operative care and treatment for orthopedic-related disorders, sports-related injuries, preventative care, rehabilitation of injured workers, and neurological-related injuries. The principal payment sources for the clinics' services are managed care programs, commercial health insurance, Medicare/Medicaid, workers' compensation insurance, and proceeds from personal injury cases. Its operating segment includes Physical therapy operations and Industrial injury prevention services. The company generates maximum revenue from the Physical therapy operations segment.

<h3 id="company-btsg">BrightSpring Health Services (BTSG)</h3>

*Outpatient and Home Providers · $12.4B · 3m +0.6% · 12m +136.7% · 24m +368.3%*

[Google Finance](https://www.google.com/finance/quote/BTSG:NASDAQ?tab=earnings&hl=en)

provider of home and community-based healthcare services, including pharmacy, rehabilitation, primary care, and hospice.

![BrightSpring Health Services versus category peers and the S&P 500](assets/earnings-btsg-3m.webp)

BrightSpring Health Services Inc is a home and community-based healthcare services platform, focused on delivering complementary pharmacy and provider services to complex patients. Its platform delivers clinical services and pharmacy solutions across Medicare, Medicaid, and commercially insured populations. Its segments include Pharmacy Solutions, Provider Services, and others. It generates the majority of its revenue from the Pharmacy Solutions segment.

<h3 id="company-avah">Aveanna Healthcare (AVAH)</h3>

*Outpatient and Home Providers · $2.0B · 3m +79.5% · 12m +76.2% · 24m +135.0%*

[Google Finance](https://www.google.com/finance/quote/AVAH:NASDAQ?tab=earnings&hl=en)

provider of pediatric and adult home healthcare, private-duty nursing, and hospice services.

![Aveanna Healthcare versus category peers and the S&P 500](assets/earnings-avah-3m.webp)

Aveanna Healthcare Holdings Inc is a diversified home care platform that provides care to medically complex, high-cost patient populations. It directly addresses the pressing challenges facing the U.S. healthcare system by providing safe, high-quality care in the home. The firm provides its services through three segments: Private Duty Services (PDS); Home Health & Hospice (HHH); and Medical Solutions (MS). The Private Duty Services segment generates the majority of revenue, which includes private duty skilled nursing services, non-clinical and personal care services, and pediatric therapy services, and is principally reimbursed by Medicaid and Medicaid MCO.

<h3 id="company-tdoc">Teladoc (TDOC)</h3>

*Digital Health, Specialty, Benefits · $1.2B · 3m -2.7% · 12m -16.8% · 24m -13.9%*

[Google Finance](https://www.google.com/finance/quote/TDOC:NYSE?tab=earnings&hl=en)

Largest pure-play virtual care platform, offering telemedicine, chronic-care management, and specialty virtual health services.

![Teladoc versus category peers and the S&P 500](assets/earnings-tdoc-3m.webp)

Teladoc Health Inc is engaged in the provision of virtual healthcare services, connecting patients, providers, and healthcare systems through technology-enabled platforms. The company has two reportable segments: Integrated Care and BetterHelp. The Integrated Care segment provides virtual healthcare solutions, including primary care, mental health, chronic care management, and telehealth enablement services for employers, insurers, and healthcare systems, mainly on a business-to-business basis, while the BetterHelp segment offers direct-to-consumer online mental health services, including counseling and therapy delivered through digital platforms. It generates the majority of its revenue from the Integrated Care segment.

<h3 id="company-amwl">Amwell (AMWL)</h3>

*Digital Health, Specialty, Benefits · $179.6M · 3m +49.5% · 12m +66.4% · 24m +31.9%*

[Google Finance](https://www.google.com/finance/quote/AMWL:NYSE?tab=earnings&hl=en)

Telehealth infrastructure company providing virtual-care technology.

![Amwell versus category peers and the S&P 500](assets/earnings-amwl-3m.webp)

American Well Corp is an enterprise platform and software company digitally enabling hybrid care by offering payers and health systems a technology-enabled care platform. The Amwell Platform, its cloud-based enablement platform, digitally enables a scalable healthcare experience across all care settings by enabling critical services like virtual primary care, urgent care, clinical partner programs, scheduling visits, etc. Additionally, the healthcare providers can use the platform to access familiar workflows for taking notes, prescribing, referencing clinical treatment guidelines, and other related activities. The firm also offers various paid services, including licensed clinical staffing, implementation support, workflow design, etc, to help clients execute their hybrid care strategies.

<h3 id="company-talk">Talkspace (TALK)</h3>

*Digital Health, Specialty, Benefits · $874.4M · 3m +1.0% · 12m +87.5% · 24m +196.6%*

[Google Finance](https://www.google.com/finance/quote/TALK:NASDAQ?tab=earnings&hl=en)

Digital behavioral-health company providing online therapy and mental-health services through employers and health-plans.

![Talkspace versus category peers and the S&P 500](assets/earnings-talk-3m.webp)

Talkspace Inc is a virtual behavioral healthcare company offering its members convenient and affordable access to a fully-credentialed network of qualified providers across a wide and growing spectrum of care through virtual psychotherapy and psychiatry. It is a single destination for comprehensive mental health care, including therapy for individuals, couples, and teens, as well as psychiatric treatment and medication management (18+), and self-guided tools and resources. The company's customers include Health insurance plans from commercial and government institutions, and employee assistance programs, Direct-to-Enterprise, and Individual subscribers. The company operates as a single segment.

<h3 id="company-hims">Hims &amp; Hers (HIMS)</h3>

*Digital Health, Specialty, Benefits · $6.4B · 3m +42.2% · 12m -24.2% · 24m +101.9%*

[Google Finance](https://www.google.com/finance/quote/HIMS:NYSE?tab=earnings&hl=en)

Direct-to-Consumer telehealth platform for primary care, weight management, mental health, sexual health, and wellness.

![Hims &amp; Hers versus category peers and the S&P 500](assets/earnings-hims-3m.webp)

Hims & Hers, launched in 2017, is a telehealth platform that connects patients and healthcare providers to offer treatment options for specialties like erectile dysfunction, hair loss, skin care, mental health, and weight loss. Its offerings include generic, branded, and compounded prescription drugs as well as over-the-counter medicines, cosmetics, and supplements. The platform, which has more than 2 million subscribers, is available in all 50 states and certain European markets like the UK. It includes provider networks, electronic medical records, cloud pharmacy fulfillment, and personalization capabilities. Hims does not take insurance and only accepts payments directly from customers.

<h3 id="company-lfmd">LifeMD (LFMD)</h3>

*Digital Health, Specialty, Benefits · $169.3M · 3m -21.0% · 12m -47.7% · 24m -39.3%*

[Google Finance](https://www.google.com/finance/quote/LFMD:NASDAQ?tab=earnings&hl=en)

Virtual primary-care and telehealth company known for chronic condition management.

![LifeMD versus category peers and the S&P 500](assets/earnings-lfmd-3m.webp)

LifeMD Inc is a patient-centric, direct-to-patient healthcare company providing a high-quality, cost-effective, and convenient way for patients to access virtual medical care and pharmacy services. The Company's portfolio of brands within continuing operations is now managed as a single operating segment, Telehealth. Telehealth platform integrates core capabilities, includes: A nationwide pharmacy network, A wholly-owned commercial pharmacy, A fully integrated patient care center, A direct-to-patient marketing infrastructure for acquisition and retention, and AI-enabled clinical and operational technologies.

<h3 id="company-omda">Omada Health (OMDA)</h3>

*Digital Health, Specialty, Benefits · $1.2B · 3m +44.7% · 12m +12.1% · 24m n/a*

[Google Finance](https://www.google.com/finance/quote/OMDA:NASDAQ?tab=earnings&hl=en)

Virtual chronic-care platform focused on diabetes, hypertension, obesity, and musculoskeletal conditions through employers and health plans.

![Omada Health versus category peers and the S&P 500](assets/earnings-omda-3m.webp)

Omada Health Inc empowers individuals to make lasting health changes through personalized, virtual care between doctor's visits. The integrated platform of the company supports members with cardiometabolic conditions like prediabetes, diabetes, hypertension, musculoskeletal issues, and behavioral health needs. The company's specialized care tracks also assist members using GLP-1 medications. The company delivers measurable health outcomes and value for employers, health plans, health systems, and pharmacy benefit managers.

<h3 id="company-gdrx">GoodRx (GDRX)</h3>

*Digital Health, Specialty, Benefits · $1.0B · 3m +30.2% · 12m -24.3% · 24m -58.1%*

[Google Finance](https://www.google.com/finance/quote/GDRX:NASDAQ?tab=earnings&hl=en)

Prescription-pricing and healthcare-shopping platform that helps consumers find discounts on medications and healthcare services.

![GoodRx versus category peers and the S&P 500](assets/earnings-gdrx-3m.webp)

GoodRx Holdings Inc is a consumer-focused digital healthcare platform that aims to lower the cost of healthcare in the United States. It operates a price comparison platform that provides consumers with curated, geographically relevant prescription pricing, and provides access to negotiated prices through codes that can be used to save money on prescriptions across the United States. GoodRx generates revenue from core business from pharmacy benefit managers (PBMs) that manage formularies and prescription transactions including establishing pricing between consumers and pharmacies. It also offers various healthcare products and services, including pharma manufacturer solutions, subscriptions, and telehealth services.

<h3 id="company-pgny">Progyny (PGNY)</h3>

*Digital Health, Specialty, Benefits · $2.5B · 3m +3.1% · 12m +9.0% · 24m +17.7%*

[Google Finance](https://www.google.com/finance/quote/PGNY:NASDAQ?tab=earnings&hl=en)

fertility and family-building benefits manager that provides employer-sponsored fertility, maternity, and women's health programs.

![Progyny versus category peers and the S&P 500](assets/earnings-pgny-3m.webp)

Progyny Inc is a benefits management company specializing in fertility, family building, and women's health benefits solutions. Its clients include employers across various industries. The fertility benefits solution consists of treatment services (Smart Cycles), access to the Progyny network of high-quality fertility specialists that perform the Smart Cycle treatments, and active management of the selective network of high-quality provider clinics.

<h3 id="company-con">Concentra Group (CON)</h3>

*Digital Health, Specialty, Benefits · $4.0B · 3m +38.2% · 12m +48.0% · 24m +49.6%*

[Google Finance](https://www.google.com/finance/quote/CON:NYSE?tab=earnings&hl=en)

leading provider of occupational health, workers’ compensation, and employer health services.

![Concentra Group versus category peers and the S&P 500](assets/earnings-con-3m.webp)

Concentra Group Holdings Parent Inc is a provider of occupational health services in the USA. The business is organized into three operating segments: occupational health centers, onsite health clinics, and other businesses.

<h3 id="company-hqy">HealthEquity (HQY)</h3>

*Digital Health, Specialty, Benefits · $8.8B · 3m +19.6% · 12m +17.4% · 24m +37.6%*

[Google Finance](https://www.google.com/finance/quote/HQY:NASDAQ?tab=earnings&hl=en)

administrator of health savings accounts (HSAs) and consumer-directed healthcare benefits.

![HealthEquity versus category peers and the S&P 500](assets/earnings-hqy-3m.webp)

HealthEquity Inc provides solutions that allow consumers to make healthcare saving and spending decisions. It provides payment processing services, personalized benefit information, the ability to earn wellness incentives, and investment advice to grow their tax-advantaged healthcare savings. It manages consumers' tax-advantaged health savings accounts (HSAs) and other consumer-directed benefits (CDBs) offered by employers, including flexible spending accounts and health reimbursement arrangements (FSAs and HRAs), and administers Consolidated Omnibus Budget Reconciliation Act (COBRA), commuter and other benefits. It also provides investment advisory services to customers whose account balances exceed a certain threshold. HealthEquity generates its revenue in the United States.

<h3 id="company-orcl">Oracle-Cerner (ORCL)</h3>

*Health IT and Data · $374.1B · 3m -23.7% · 12m -38.0% · 24m +5.2%*

[Google Finance](https://www.google.com/finance/quote/ORCL:NYSE?tab=earnings&hl=en)

Largest healthcare IT platform vendor, providing EHRs, clinical workflow software, and healthcare data infrastructure.

![Oracle-Cerner versus category peers and the S&P 500](assets/earnings-orcl-3m.webp)

Oracle provides enterprise applications and infrastructure offerings through a variety of flexible IT deployment models, including on-premises, cloud-based, and hybrid. Founded in 1977, Oracle pioneered the first commercial SQL-based relational database management system, which is commonly used by the world's largest companies for high-volume online transaction processing workloads. Besides databases, Oracle also sells enterprise resource planning platforms and cloud infrastructure that play an increasingly important role in large language model training and inferencing.

<h3 id="company-mdrx">Veradigm (MDRX)</h3>

*Health IT and Data · n/a · 3m +1.1% · 12m -1.0% · 24m -50.5%*

[Google Finance](https://www.google.com/finance/quote/MDRX:NYSE?tab=earnings&hl=en)

Healthcare data, EHR (AllScripts) and interoperability.

![Veradigm versus category peers and the S&P 500](assets/earnings-mdrx-3m.webp)

VERADIGM INC

<h3 id="company-way">Waystar (WAY)</h3>

*Health IT and Data · $4.0B · 3m +27.8% · 12m -31.0% · 24m -5.2%*

[Google Finance](https://www.google.com/finance/quote/WAY:NASDAQ?tab=earnings&hl=en)

Healthcare payments and revenue cycle platform.

![Waystar versus category peers and the S&P 500](assets/earnings-way-3m.webp)

Waystar Holding Corp is a provider of mission-critical cloud technology to healthcare organizations. Its enterprise-grade platform transforms the complex and disparate processes comprising healthcare payments received by healthcare providers from payers and patients, from pre-service engagement through post-service remittance and reconciliation. its platform enhances data integrity, eliminates manual tasks, and improves claim and billing accuracy, which results in transparency, reduced labor costs, and faster, more accurate reimbursement and cash flow. The market for solutions extends throughout the United States and includes Puerto Rico and other USA Territories.

<h3 id="company-solv">Solventum (SOLV)</h3>

*Health IT and Data · $13.6B · 3m +16.6% · 12m +21.8% · 24m +45.9%*

[Google Finance](https://www.google.com/finance/quote/SOLV:NYSE?tab=earnings&hl=en)

Revenue-cycle, clinical documentation, coding, and healthcare workflow solutions.

![Solventum versus category peers and the S&P 500](assets/earnings-solv-3m.webp)

Solventum Corp is a healthcare company developing, manufacturing, and commercializing solutions leveraging material science, data science, and digital capabilities to address customer and patient needs. Its segments include MedSurg, which earns maximum revenue and provides wound therapy, I.V. site management, surgical supplies, medical tapes and wraps, stethoscopes, medical electrodes, and OEM medical technologies; Dental Solutions, offering dental and orthodontic products such as brackets, restorative cements, and bonding agents; and Health Information Systems, providing software solutions including physician documentation, coding automation, speech recognition, and data visualization platforms. It operates in the United States, which earns the majority of revenue, and internationally.

<h3 id="company-phr">Phreesia (PHR)</h3>

*Health IT and Data · $663.2M · 3m +35.9% · 12m -59.3% · 24m -52.3%*

[Google Finance](https://www.google.com/finance/quote/PHR:NYSE?tab=earnings&hl=en)

Patient-intake and engagement platform that digitizes registration, scheduling, intake forms, payments, and communications.

![Phreesia versus category peers and the S&P 500](assets/earnings-phr-3m.webp)

Phreesia Inc is a provides an integrated software, payments, and engagement platform designed to address three foundational challenges in healthcare delivery: access to care, affordability of care, and patient health outcomes. Its platform is embedded directly into provider workflows and patient interactions, enabling healthcare organizations to activate patients, streamline administrative processes, and improve financial performance across the care continuum. The group serves a diverse group of healthcare organizations, including ambulatory practices, health systems, and hospitals, as well as life sciences companies, government entities, patient advocacy, public interest, and not-for-profit and other organizations.

<h3 id="company-ccsi">Consensus Cloud Solutions (CCSI)</h3>

*Health IT and Data · $669.7M · 3m +37.6% · 12m +44.4% · 24m +77.6%*

[Google Finance](https://www.google.com/finance/quote/CCSI:NASDAQ?tab=earnings&hl=en)

Healthcare-focused cloud communications company known for secure-faxing, interoperability, and clinical document exchange.

![Consensus Cloud Solutions versus category peers and the S&P 500](assets/earnings-ccsi-3m.webp)

Consensus Cloud Solutions Inc is a provider of secure information delivery services with a scalable Software-as-a-Service SaaS platform. It is engaged in the fax cloud business. The company's offerings include communication, data extraction, and digital signature solutions that enable users to securely access, exchange, and manage information across organizational and geographic boundaries. It serves multiple industry verticals, including healthcare, government, financial services, legal, and education. Geographically, the company operates in the United States, Canada, Ireland, and other countries. It derives the maximum revenue from the United States.

<h3 id="company-dh">Definitive Healthcare (DH)</h3>

*Health IT and Data · $85.5M · 3m -16.2% · 12m -82.4% · 24m -84.2%*

[Google Finance](https://www.google.com/finance/quote/DH:NASDAQ?tab=earnings&hl=en)

Healthcare data providers for provider, hospital, physician, and payer intelligence databases.

![Definitive Healthcare versus category peers and the S&P 500](assets/earnings-dh-3m.webp)

Definitive Healthcare Corp is a provider of healthcare commercial intelligence. Its SaaS-based healthcare commercial intelligence platform is designed to provide comprehensive and accurate information on the healthcare ecosystem in the U.S. The platform uses deep analytics and data science to help customers develop data-driven strategic decisions, such as finding new markets to enter, building comprehensive go-to-market strategies, accessing tactical information to help target the right decision makers, and improving win rates with detailed contextual information. The company derives substantially all of its revenue from the sale of subscription fees for access to its platform and stand-ready support. Geographically, it derives a majority of its revenue from the United States.

<h3 id="company-iqv">Iqvia (IQV)</h3>

*Health IT and Data · $38.7B · 3m +54.7% · 12m +35.9% · 24m +4.4%*

[Google Finance](https://www.google.com/finance/quote/IQV:NYSE?tab=earnings&hl=en)

Dominant healthcare data, analytics, and contract research organization, supplying pharmaceutical companies with clinical reearch and commercial intelligence.

![Iqvia versus category peers and the S&P 500](assets/earnings-iqv-3m.webp)

Iqvia is a global leader in clinical research and technology solutions for the life science industry. Formed in 2016 from the merger of Quintiles and IMS Health, it combined clinical trial services with extensive healthcare data and analytics. Its research and development solutions segment provides outsourced clinical development services spanning drug discovery, trial design, patient recruitment, site management, clinical testing, real-world studies, and the regulatory approval process. Its commercial solutions segment helps companies optimize product commercialization through analytics, technology, and outsourced sales and medical services. Together, Iqvia supports customers across the life science industry, and it serves biopharmaceutical firms, providers, payers, and policymakers.

<h3 id="company-hcat">Health Catalyst (HCAT)</h3>

*Health IT and Data · $154.4M · 3m +18.6% · 12m -53.4% · 24m -79.0%*

[Google Finance](https://www.google.com/finance/quote/HCAT:NASDAQ?tab=earnings&hl=en)

Healthcare analytics and data-platform company that helps providers improve clinical, operational, and financial performance.

![Health Catalyst versus category peers and the S&P 500](assets/earnings-hcat-3m.webp)

Health Catalyst Inc provides data and analytics technology and services to healthcare organizations. It has two operating segments. The Technology segment, the key revenue driver, includes data platform, analytics applications and support services and generates revenues mainly from contracts that are cloud-based subscription arrangements, time-based license arrangements, and maintenance and support fees; the Professional Services segment is generally the combination of analytics, implementation, strategic advisory, outsourcing, and improvement services to deliver expertise to its customers to more fully configure and utilize the benefits of the technology offerings.

<h3 id="company-docs">Doximity (DOCS)</h3>

*Health IT and Data · $3.8B · 3m +27.0% · 12m -62.6% · 24m -30.6%*

[Google Finance](https://www.google.com/finance/quote/DOCS:NYSE?tab=earnings&hl=en)

Professional network for physicians, combining recruiting, communications, telehealth, and workflow tools.

![Doximity versus category peers and the S&P 500](assets/earnings-docs-3m.webp)

Doximity Inc provides an online platform, which enables physicians and other healthcare professionals to collaborate with colleagues, stay up to date with the latest medical news and research, manage their careers and on-call schedules, streamline documentation and administrative paperwork, and conduct virtual patient visits. The Company's customers include pharmaceutical companies and health systems that connect with healthcare professionals through the Company's digital Marketing, Hiring, and Workflow Solutions. Marketing Solutions provide customers with the ability to share tailored content on the network. Hiring Solutions enable customers to identify, connect with, and hire from the network of both active and passive potential medical professional candidates.

<h3 id="company-veev">Veeva Systems (VEEV)</h3>

*Health IT and Data · $33.1B · 3m +54.8% · 12m -14.8% · 24m +24.4%*

[Google Finance](https://www.google.com/finance/quote/VEEV:NYSE?tab=earnings&hl=en)

Leading cloud-software provider for life sciences companies, supporting CRM, clinical trails, regulatory processes, and commercialization.

![Veeva Systems versus category peers and the S&P 500](assets/earnings-veev-3m.webp)

Veeva is the global leading supplier of cloud-based software solutions for the life sciences industry. The company's best-of-breed offerings address operating and regulatory requirements for customers ranging from small, emerging biotechnology companies to departments of global pharmaceutical manufacturers. The company leverages its domain expertise to improve the efficiency and compliance of the underserved life sciences industry, displacing large, highly customized and dated enterprise resource planning systems that have limited flexibility. Its two main products are Veeva CRM, a customer relationship management platform for companies with a salesforce, and Veeva Vault, a content management platform that tackles various functions within any life sciences company.

<h3 id="company-omcl">Omnicell (OMCL)</h3>

*Health IT and Data · $1.7B · 3m -19.9% · 12m +5.8% · 24m -20.6%*

[Google Finance](https://www.google.com/finance/quote/OMCL:NASDAQ?tab=earnings&hl=en)

Pharmacy automation, medication management, and healthcare workflow software.

![Omnicell versus category peers and the S&P 500](assets/earnings-omcl-3m.webp)

Omnicell Inc provides automation and business analytics software for healthcare providers. The company is engaged in transforming the pharmacy and nursing care delivery model. The company helps its customers define and deliver cost-effective medication management designed to equip and empower pharmacists and nurses to focus on patient care rather than administrative tasks and drive improved clinical, operational, and financial outcomes across all care settings. The company derives the majority of its revenue from the United States.

<h3 id="company-mck">McKesson (MCK)</h3>

*Pharma Distribution · $97.2B · 3m +12.1% · 12m +24.6% · 24m +55.6%*

[Google Finance](https://www.google.com/finance/quote/MCK:NYSE?tab=earnings&hl=en)

Largest pharmaceutical distributor in North America.

![McKesson versus category peers and the S&P 500](assets/earnings-mck-3m.webp)

McKesson is one of three leading pharmaceutical wholesalers in the US engaged in sourcing and distributing branded, generic, and specialty pharmaceutical products to pharmacies (retail chains, independent, and mail order), hospitals networks, and healthcare providers. Along with Cencora and Cardinal Health, the three account for over 90% of the US pharmaceutical wholesale industry. Outside the US market, McKesson engages in pharmaceutical wholesale and distribution in Canada. Additionally, the company supplies medical-surgical products and equipment to healthcare facilities and provides a variety of technology solutions for pharmacies.

<h3 id="company-cah">Cardinal Health (CAH)</h3>

*Pharma Distribution · $54.7B · 3m +14.4% · 12m +55.0% · 24m +109.7%*

[Google Finance](https://www.google.com/finance/quote/CAH:NYSE?tab=earnings&hl=en)

One of the big three drug wholesalesrs, providing pharma distribution, medical products, and supply chain services.

![Cardinal Health versus category peers and the S&P 500](assets/earnings-cah-3m.webp)

Cardinal Health is one of three leading pharmaceutical wholesalers in the US, engaged in sourcing and distributing of branded, generic, and specialty pharmaceutical products to pharmacies (retail chains, independent, and mail order), hospital networks, and healthcare providers. Cardinal, Cencora, and McKesson hold well over 90% of the US pharmaceutical wholesale industry. Cardinal Health also supplies medical-surgical products and equipment to healthcare facilities in North America, Europe, and Asia.

<h3 id="company-cor">Cencora (COR)</h3>

*Pharma Distribution · $59.6B · 3m +15.7% · 12m +8.7% · 24m +33.8%*

[Google Finance](https://www.google.com/finance/quote/COR:NYSE?tab=earnings&hl=en)

Formerly AmerisourceBergen, Global pharmaceutical distribution and specialty-services leader.

![Cencora versus category peers and the S&P 500](assets/earnings-cor-3m.webp)

Cencora is one of three leading domestic pharmaceutical wholesalers. It sources and distributes branded, generic, and specialty pharmaceutical products to pharmacies (retail chains, independent, and mail order), hospital networks, and healthcare providers. It and McKesson and Cardinal Health hold over 90% share of the US pharmaceutical wholesale industry. Cencora also provides commercialization services for manufacturers of pharmaceuticals and medical devices, global specialty drug logistics (World Courier), and animal health product distribution (MWI Animal Health). Cencora expanded its international presence in 2021 by purchasing Alliance Healthcare, one of the leading drug wholesalers in Europe.

<h3 id="company-ahco">Accendra Health (AHCO)</h3>

*Pharma Distribution · $912.9M · 3m -46.1% · 12m -41.4% · 24m -46.1%*

[Google Finance](https://www.google.com/finance/quote/AHCO:NASDAQ?tab=earnings&hl=en)

Medical and Surgical supply distributor with a significant healthcare logistics business.

![Accendra Health versus category peers and the S&P 500](assets/earnings-ahco-3m.webp)

AdaptHealth Corp is engaged in providing patient-centered, healthcare-at-home solutions including home medical equipment (HME), medical supplies, and related services. The Company operates under four reportable segments that align with its product categories: (i) Sleep Health, (ii) Respiratory Health, (iii) Diabetes Health, and (iv) Wellness at Home. The company generates majority of its revenue from the Sleep Health segment. The Sleep Health segment provides sleep therapy equipment, supplies and related services (including continuous positive airway pressure and BiLevel services) to individuals for the treatment of obstructive sleep apnea.

<h3 id="company-hsic">Henry Schein (HSIC)</h3>

*Pharma Distribution · $10.2B · 3m +19.3% · 12m +27.2% · 24m +25.0%*

[Google Finance](https://www.google.com/finance/quote/HSIC:NASDAQ?tab=earnings&hl=en)

Leading dental product, tech, and physician office supply distributor.

![Henry Schein versus category peers and the S&P 500](assets/earnings-hsic-3m.webp)

Henry Schein Inc is a solutions company for healthcare professionals. It offers healthcare equipment, products, and services to office-based dental and medical practitioners, as well as alternative sites of care. The company's reportable segments are: Global Distribution and Value-Added Services, Global Specialty Products, and Global Technology. It generates maximum revenue from the Global Distribution and Value-Added Services segment, which includes distribution to the dental and medical markets of national brand and corporate brand merchandise, as well as equipment and related technical services. This segment also includes value-added services such as financial services, continuing education services, consulting, and other practice services.

<h3 id="company-ntra">Natera (NTRA)</h3>

*Precision Diagnostics · $39.4B · 3m +63.4% · 12m +100.5% · 24m +170.6%*

[Google Finance](https://www.google.com/finance/quote/NTRA:NASDAQ?tab=earnings&hl=en)

molecular diagnostics leader using cell-free DNA testing for prenatal screening, oncology monitoring, and transplant surveillance.

![Natera versus category peers and the S&P 500](assets/earnings-ntra-3m.webp)

Natera Inc is a diagnostic and research company with proprietary molecular and bioinformatics technology. The company's key product offerings include its Panorama Non-Invasive Prenatal Test (NIPT) which screens for chromosomal abnormalities of a fetus as well as in twin pregnancies, typically with a blood draw from the mother, Horizon Carrier Screening (HCS) to determine carrier status for a large number of severe genetic diseases that could be passed on to the carrier's children, Signatera molecular residual disease (MRD) test, which detects circulating tumor DNA in patients previously diagnosed with cancer to assess molecular residual disease and monitor for recurrence; and Prospera, to assess organ transplant rejection.

<h3 id="company-neo">NeoGenomics (NEO)</h3>

*Precision Diagnostics · $2.1B · 3m +84.0% · 12m +157.1% · 24m +1.9%*

[Google Finance](https://www.google.com/finance/quote/NEO:NASDAQ?tab=earnings&hl=en)

precision oncology diagnostics company providing cancer testing, genomic profiling, and biomarker services.

![NeoGenomics versus category peers and the S&P 500](assets/earnings-neo-3m.webp)

NeoGenomics Inc provides oncology diagnostic testing and consultative services which include technical laboratory services and professional interpretation of laboratory test results by licensed physicians or molecular experts in pathology and oncology. The company operates a network of cancer-focused testing laboratories in the United States and the United Kingdom. The company operates in a single segment and derives revenue from clients by providing clinical cancer testing, interpretation, and consultative services, molecular and NGS testing, comprehensive technical and professional services offerings, clinical trials and research, validation laboratory services, and oncology data solutions.

<h3 id="company-blln">BillionToOne (BLLN)</h3>

*Precision Diagnostics · $6.5B · 3m +10.6% · 12m n/a · 24m n/a*

[Google Finance](https://www.google.com/finance/quote/BLLN:NASDAQ?tab=earnings&hl=en)

molecular diagnostics company focused on prenatal screening and precision oncology testing.

![BillionToOne versus category peers and the S&P 500](assets/earnings-blln-3m.webp)

BillionToOne Inc is a molecular diagnostics company. It offers a portfolio of ultrasensitive tests covering prenatal genetic testing, cancer therapy selection, and response monitoring, which are based on its Quantitative Counting Templates (QCT) molecular counting platform. The company's product portfolio comprises UNITY, a portfolio of prenatal testing products that can conduct fetal risk analysis without requiring a paternal sample; Northstar Select, a ultrasensitive liquid biopsy test that provides insights into appropriate therapies for stage III or IV cancer patients; and Northstar Response, a tissue-free, pan-cancer, liquid biopsy test that measures several genomic loci uniquely methylated in cancer to provide insight into dynamic changes in therapy response.

<h3 id="company-gh">Guardant Health (GH)</h3>

*Precision Diagnostics · $21.4B · 3m +43.5% · 12m +178.0% · 24m +488.2%*

[Google Finance](https://www.google.com/finance/quote/GH:NASDAQ?tab=earnings&hl=en)

liquid-biopsy leader using blood-based genomic testing for cancer detection, treatment selection, and disease monitoring.

![Guardant Health versus category peers and the S&P 500](assets/earnings-gh-3m.webp)

Guardant Health, based in Redwood City, California, is a leader in liquid-based cancer tests for clinical and research use. The company's main franchises are Guardant360 for genomic profiling of tumors, Reveal for molecular residual disease testing, and Shield for colorectal cancer screening. Additionally, Guardant offers research development services such as regulatory approval consultancy and clinical trial referrals.

<h3 id="company-tem">Tempus AI (TEM)</h3>

*Precision Diagnostics · $8.5B · 3m +57.4% · 12m -9.7% · 24m +11.9%*

[Google Finance](https://www.google.com/finance/quote/TEM:NASDAQ?tab=earnings&hl=en)

precision medicine company combining genomic testing, clinical data, and artificial intelligence to support treatment decisions and drug development.

![Tempus AI versus category peers and the S&P 500](assets/earnings-tem-3m.webp)

Tempus AI Inc is a technology company. It has built the Tempus Platform, which comprises both a technology platform to free healthcare data from silos and an operating system to make the resulting data useful. Its Intelligent Diagnostics use AI, including generative AI, to make laboratory tests more accurate, tailored, and personal.

<h3 id="company-ilmn">Illumina (ILMN)</h3>

*Precision Diagnostics · $30.7B · 3m +51.9% · 12m +115.5% · 24m +67.0%*

[Google Finance](https://www.google.com/finance/quote/ILMN:NASDAQ?tab=earnings&hl=en)

leading DNA sequencing platform company providing foundational technology for genomics research and clinical testing.

![Illumina versus category peers and the S&P 500](assets/earnings-ilmn-3m.webp)

Illumina provides tools and services to analyze genetic material with life science and clinical lab applications. The company generates over 90% of its revenue from sequencing instruments, consumables, and services. Illumina's high-throughput technology enables whole genome sequencing in humans and other large organisms. Its lower throughput tools enable applications that require smaller data outputs, such as viral and cancer tumor screening. Illumina also sells microarrays that enable lower-cost, focused genetic screening with primarily consumer and agricultural applications.

<h3 id="company-txg">10x Genomics (TXG)</h3>

*Precision Diagnostics · $6.1B · 3m +175.0% · 12m +355.4% · 24m +177.2%*

[Google Finance](https://www.google.com/finance/quote/TXG:NASDAQ?tab=earnings&hl=en)

leader in single-cell and spatial biology technologies used in genomics research and drug discovery.

![10x Genomics versus category peers and the S&P 500](assets/earnings-txg-3m.webp)

10x Genomics Inc is a life science technology company based in the United States. Its solutions include instruments, consumables, and software for analyzing biological systems. The company's integrated solutions include instruments, consumables, and software for analyzing biological systems at a resolution and scale that matches the complexity of biology. Its product offerings include a Chromium platform comprising microfluidic chips and related consumables, Chromium X series, Visium and Xenium platforms, and others, which are predominantly used for the study of biological components. Geographically, the company derives operates from the United States and the rest from Americas (excluding the United States), Europe, Middle East and Africa, China, and Asia-Pacific (excluding China).

<h3 id="company-pacb">PacBio (PACB)</h3>

*Precision Diagnostics · $447.3M · 3m +10.7% · 12m -2.2% · 24m -13.5%*

[Google Finance](https://www.google.com/finance/quote/PACB:NASDAQ?tab=earnings&hl=en)

developer of long-read DNA sequencing technologies used to analyze complex genomes.

![PacBio versus category peers and the S&P 500](assets/earnings-pacb-3m.webp)

Pacific Biosciences of California Inc is a biotechnology company focused on designing, developing, and manufacturing sequencing solutions that enable scientists and clinical researchers to improve their understanding of the genome and ultimately, resolve genetically complex problems. It operates in, one reportable segment: the development, manufacturing, and marketing of an integrated platform for genetic analysis. The majority of the company's revenue is derived from Americas, followed by Europe Middle East, and Africa and Asia-Pacific.

<h3 id="company-qdel">QuidelOrtho (QDEL)</h3>

*Precision Diagnostics · $1.2B · 3m +24.3% · 12m -47.2% · 24m -67.3%*

[Google Finance](https://www.google.com/finance/quote/QDEL:NASDAQ?tab=earnings&hl=en)

diagnostics company providing clinical laboratory, immunoassay, and point-of-care testing solutions.

![QuidelOrtho versus category peers and the S&P 500](assets/earnings-qdel-3m.webp)

QuidelOrtho Corp is engaged in the development, manufacturing, and marketing of rapid diagnostic testing solutions. The company is engaged in immunoassay and molecular testing, clinical chemistry, and transfusion medicine, which helps clinicians and patients to make decisions across the globe. Geographically, the company has its presence in North America, EMEA, China, and Other countries. It generates the majority of its revenue from North America.

<h3 id="company-dgx">Quest Diagnostics (DGX)</h3>

*Precision Diagnostics · $25.8B · 3m +25.2% · 12m +35.6% · 24m +59.1%*

[Google Finance](https://www.google.com/finance/quote/DGX:NYSE?tab=earnings&hl=en)

largest U.S. independent clinical laboratory and diagnostic testing company.

![Quest Diagnostics versus category peers and the S&P 500](assets/earnings-dgx-3m.webp)

Quest Diagnostics is a leading independent provider of diagnostic testing, information, and services in the US. The company generates over 97% of its revenue through clinical testing, anatomic pathology, esoteric testing, and substance abuse testing with specimens collected at its national network of roughly 2,400 patient service centers, as well as multiple doctors offices and hospitals. The firm also runs a much smaller diagnostic solutions segment that provides clinical trials testing, risk-assessment services, and information technology solutions.

<h3 id="company-lh">Labcorp Holdings (LH)</h3>

*Precision Diagnostics · $25.3B · 3m +29.4% · 12m +20.9% · 24m +45.7%*

[Google Finance](https://www.google.com/finance/quote/LH:NYSE?tab=earnings&hl=en)

leading diagnostics and laboratory services company with substantial genomic and specialty testing capabilities.

![Labcorp Holdings versus category peers and the S&P 500](assets/earnings-lh-3m.webp)

Labcorp is one of the nation's two largest independent clinical laboratories, with roughly 20% of the independent lab market. The company operates approximately 2,000 patient-service centers, offering a broad range of 5,000 clinical lab tests, ranging from uncomplicated routine blood and urine screens to complex oncology and genomic testing.

<h3 id="company-cert">Certara (CERT)</h3>

*Precision Diagnostics · $1.2B · 3m +60.9% · 12m -26.5% · 24m -36.6%*

[Google Finance](https://www.google.com/finance/quote/CERT:NASDAQ?tab=earnings&hl=en)

biosimulation and data-driven drug development company supporting precision medicine and clinical development.

![Certara versus category peers and the S&P 500](assets/earnings-cert-3m.webp)

Certara Inc accelerates medicines to patients using biosimulation software and technology to transform traditional drug discovery and development. It provides modeling and simulation, regulatory science, and assessment software and services to help clients reduce clinical trials, accelerate regulatory approval, and increase patient access to medicines. The company has its business presence in the Americas, which is also its key revenue-generating market, EMEA, and the Asia Pacific region.

