# Healthcare Strategy Brief
## Week of October 26, 2026

## Executive View

- **ACA integrity policy moved from retrospective enrollment cleanup to a redesigned 2028 enrollment process.** CMS estimates mandatory annual verification would reduce Exchange enrollment by 332,500, lower advance premium-tax-credit payments by $7.6 billion annually and modestly worsen risk pools.
- **Molina put numbers behind the Medicaid margin-turn thesis.** Its early 2027 view places rates near 6% against 5.5%-6% medical-cost trend—better than the recent rate shortfall, but not yet a wide margin-recovery spread.
- **Electronic prior authorization gained a commercial-market demand signal.** Five major employers want the capabilities being built for regulated plans made available to their self-funded plans, increasing pressure on TPAs to deploy common FHIR workflows across lines of business.
- **Two transactions advanced distinct provider-integration models.** Horizon plans to own a major New Jersey ambulatory network, while Kaiser-backed Risant is adding a third health system to its reusable value-based-care platform.
- **DOJ created an explicit resolution path for legacy healthcare False Claims Act exposure.** The six-month pilot may accelerate internal audits, repayment decisions and transaction diligence.
- **Overall environment:** improved for Medicaid margin visibility and administrative-technology demand; deteriorated for ACA enrollment continuity; broadly unchanged in aggregate.

## 1. CMS makes active verification a condition of subsidized Exchange enrollment

**Status:** NEW

**What happened**

On October 23, CMS proposed requiring Exchanges to verify household income and size, citizenship or eligible noncitizen status, other qualifying coverage and residency before providing advance premium-tax-credit payments or cost-sharing reductions. Starting with 2028 coverage, existing members would have to return annually and confirm their information to retain financial assistance; otherwise, they could be automatically re-enrolled only without subsidies. The first proposed pre-open-enrollment verification period would begin August 1, 2027. ([CMS, *Exchange Pre-Eligibility Verification Proposed Rule*, October 23, 2026](https://www.cms.gov/newsroom/fact-sheets/exchange-pre-eligibility-verification-proposed-rule-cms-9873-p)) ([cms.gov](https://www.cms.gov/newsroom/fact-sheets/exchange-pre-eligibility-verification-proposed-rule-cms-9873-p))

CMS estimates that the proposal would reduce annual Exchange enrollment by approximately 332,500, decrease APTC spending by $7.6 billion beginning in 2028 and increase average premiums by 0.4%, or $2.89 per member per month, because administrative barriers would disproportionately deter younger and healthier consumers. ([Federal Register public-inspection document, *CMS-9873-P*, October 23, 2026](https://public-inspection.federalregister.gov/2026-21891.pdf)) ([public-inspection.federalregister.gov](https://public-inspection.federalregister.gov/2026-21891.pdf))

**Implication**

This extends the September membership-removal thesis into a permanent annual operating model. Marketplace carriers now face more churn, delayed subsidy activation, retroactive enrollment transactions and less predictable risk pools—not merely tighter broker controls. Premium revenue should decline with enrollment, although CMS acknowledges that claims may also fall and does not quantify the net margin effect.

The near-term technology demand is for eligibility orchestration, document collection, identity and residency verification, broker outreach and enrollment reconciliation. Providers face a smaller but meaningful 2028 increase in coverage gaps, bad debt and delayed care if eligible consumers fail to complete verification.

**Watch next**

Whether CMS reduces friction for passive renewals and how Exchanges operationalize retroactive subsidies and pended plan selections without generating avoidable claims and premium-reconciliation errors.

---

## 2. Molina quantifies a narrow Medicaid rate-trend crossover

**Status:** UPDATE

**What happened**

Molina reported a 93% third-quarter Medicaid medical-cost ratio and said elevated medical trend appears to be plateauing as recent state rate actions begin to close the funding gap. Management’s preliminary 2027 assumptions place Medicaid rates at approximately 6% and medical-cost trend at 5.5%-6%; it also expects enrollment pressure from work requirements and more frequent eligibility reverifications. ([Molina Healthcare, *Third Quarter 2026 Financial Results*, October 21, 2026](https://molinahealthcare.gcs-web.com/news-releases/news-release-details/molina-healthcare-reports-third-quarter-2026-financial-results); [earnings-call transcript, October 22, 2026](https://www.fool.com/earnings/call-transcripts/2026/10/22/molina-healthcare-moh-q3-2026-earnings-call-transcript/)) ([molinahealthcare.gcs-web.com](https://molinahealthcare.gcs-web.com/news-releases/news-release-details/molina-healthcare-reports-third-quarter-2026-financial-results?utm_source=openai))

Elevance provided corroborating, though less specific, evidence: premium increases offset membership attrition, while Medicaid enrollment fell 4.9% year over year. Elevance’s consolidated benefit ratio improved primarily because of Medicare Advantage and individual ACA performance, so its release does not establish a fully recovered Medicaid margin. ([Elevance Health, *Third Quarter 2026 Results*, October 21, 2026](https://www.sec.gov/Archives/edgar/data/1156039/000115603926000068/a3q2026elvearningsrelease.htm)) ([sec.gov](https://www.sec.gov/Archives/edgar/data/1156039/000115603926000068/a3q2026elvearningsrelease.htm))

**Implication**

The new evidence changes the Medicaid thesis from “rates should eventually catch up” to “rates may approximately match trend in 2027.” That is an inflection, not normalization: a zero-to-50-basis-point spread leaves little protection against pharmacy, outpatient or acuity surprises.

Plans should continue prioritizing acuity detection, eligibility forecasting, payment integrity and high-cost case management rather than assuming broad margin expansion. Providers should expect continued contracting discipline even where state rates improve, because membership attrition and mix changes can offset nominal rate gains.

**Watch next**

Whether fourth-quarter utilization remains within Molina’s 5.5%-6% trend assumption and whether state rate updates include retrospective relief or only prospective increases.

---

## 3. Self-funded employers push prior-authorization infrastructure beyond CMS-0057

**Status:** NEW

**What happened**

CMS and the Department of Labor announced on October 21 that Amazon, Axon, Google, Meta and Oracle support making the capabilities developed under the 2025 Prior Authorization Pledge available to self-funded employer plans. Those capabilities include FHIR-based electronic prior authorization, fewer services requiring authorization, greater transparency and more real-time decisions. The employer statement is voluntary and does not itself impose deadlines or performance standards. ([CMS, *Leading Employers Back Expansion of Electronic Prior Authorization to Self-Funded Health Plans*, October 21, 2026](https://www.cms.gov/newsroom/press-releases/leading-employers-back-expansion-electronic-prior-authorization-self-funded-health-plans)) ([cms.gov](https://www.cms.gov/newsroom/press-releases/leading-employers-back-expansion-electronic-prior-authorization-self-funded-health-plans?utm_source=openai))

**Implication**

The regulated-plan API build is becoming a commercial platform expectation. Large employers do not want providers switching between electronic workflows for Medicare Advantage or Medicaid patients and manual workflows for employees administered by the same carrier or TPA.

This strengthens demand for reusable payer APIs, authorization-rule engines, clinical-document exchange and workflow integration. However, the immediate revenue opportunity remains dependent on TPA contract amendments and employer purchasing decisions; a pledge without adoption metrics should not be treated as equivalent to CMS-0057 compliance.

**Watch next**

Whether national TPAs commit to common deployment dates and disclose self-funded authorization volumes, decision times and real-time approval rates.

---

## 4. Regional integration advances through both ownership and shared platforms

**Status:** NEW

**What happened**

Horizon Mutual Holdings confirmed an agreement to acquire Summit Health New Jersey, including New Jersey CityMD sites, subject to regulatory review. The transaction would place a major multispecialty and urgent-care network under the state’s dominant Blue plan. ([BINJE, *Horizon BCBS to Purchase Summit Health in Billion-Dollar Deal*, October 21, 2026](https://binje.com/sectors/health-care/horizon-bcbs-to-purchase-summit-health-in-billion-dollar-deal/)) ([binje.com](https://binje.com/sectors/health-care/horizon-bcbs-to-purchase-summit-health-in-billion-dollar-deal/?utm_source=openai))

Separately, Kaiser Permanente-backed Risant Health signed a definitive agreement to add INTEGRIS Health as its third member system after Geisinger and Cone Health. INTEGRIS operates 10 acute and 10 specialty hospitals and will retain its brand and leadership while adopting Risant’s value-based-care and technology capabilities. ([INTEGRIS Health, *INTEGRIS Health to Become Part of Risant Health*, October 21, 2026](https://integrishealth.org/resources/news/2026/october/integris-health-to-become-part-of-risant-health)) ([integrishealth.org](https://integrishealth.org/resources/news/2026/october/integris-health-to-become-part-of-risant-health?utm_source=openai))

**Implication**

Horizon is pursuing direct capture of referral, ambulatory and site-of-care economics; Risant is scaling a common operating platform across locally branded systems. Both models increase enterprise standardization and favor vendors capable of systemwide deployment, but they also concentrate purchasing authority and raise displacement risk for point solutions.

**Watch next**

Regulatory conditions on Horizon’s acquisition and evidence that Risant can reproduce its claimed operating improvements outside Geisinger and Cone’s markets.

---

## 5. DOJ puts a defined price range on voluntary FCA resolution

**Status:** NEW

**What happened**

DOJ and HHS launched a six-month healthcare False Claims Act self-disclosure pilot on October 22. Companies must provide relevant facts and documents, describe remediation and repay the government using a 1.25-to-1.6 multiplier. In exchange, participants may receive a coordinated release under the federal FCA and specified HHS administrative authorities. Submissions are accepted through April 22, 2027; potential criminal conduct follows separate disclosure procedures. ([Department of Justice, *Healthcare False Claims Act Self-Disclosure Pilot Program*, October 22, 2026](https://www.justice.gov/opa/pr/justice-departments-civil-division-and-department-health-human-services-announce-anti-fraud)) ([justice.gov](https://www.justice.gov/opa/pr/justice-departments-civil-division-and-department-health-human-services-announce-anti-fraud?utm_source=openai))

**Implication**

The program gives plans, providers and acquirers a more calculable alternative to waiting for whistleblower litigation or enforcement. It is particularly relevant to unsupported coding, risk-adjustment deletions, billing errors and successor liabilities discovered during integration.

Expect stronger demand for retrospective claims analytics, coding validation, defensible sampling and transaction diligence. The pathway reduces uncertainty—not liability—and rewards rapid remediation before an issue expands in duration, value or senior-management involvement.

**Watch next**

Whether DOJ accepts disclosures involving conduct already subject to payer audits or government data analysis, and how coordinated releases address successor liability.

## What I'm Watching Next

- **October 27, 2026:** CMS-9873-P is scheduled for publication in the *Federal Register*. ([federalregister.gov](https://www.federalregister.gov/public-inspection/2026-21891/patient-protection-and-affordable-care-act-exchange-pre-eligibility-verification))
- **April 22, 2027:** DOJ’s healthcare FCA self-disclosure pilot closes to submissions. ([justice.gov](https://www.justice.gov/opa/pr/justice-departments-civil-division-and-department-health-human-services-announce-anti-fraud?utm_source=openai))
- **August 1, 2027:** Proposed first pre-open-enrollment verification period begins for 2028 Exchange coverage, if finalized. ([cms.gov](https://www.cms.gov/newsroom/fact-sheets/exchange-pre-eligibility-verification-proposed-rule-cms-9873-p))

## Bottom Line

The most important weekly change is CMS’s proposed conversion of subsidized Exchange enrollment into an annual active-verification process with quantified enrollment and risk-pool consequences. ACA enrollment continuity requires the closest attention. The October 27 publication of CMS-9873-P begins the formal process most likely to determine whether the 2028 integrity regime becomes a manageable verification workflow or a material new source of coverage churn.
