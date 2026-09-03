# 📊 SaaS Churn & Revenue-at-Risk Analytics

An end-to-end analytics project analyzing a B2B SaaS company's customer base to uncover business insights on churn, revenue at risk, product usage, and customer support — using **MySQL** for analysis and **Power BI** for reporting.

---

## 📌 Project Overview

Understanding why customers leave — and what it costs — is essential to running a healthy subscription business.
In this project, RavenStack's customer data is analyzed to answer key business questions such as:
- Which customers are churning, and why?
- How much monthly recurring revenue is at risk because of it?
- Does product usage differ between customers who churn and those who stay?
- Does support experience (response time, resolution time, satisfaction) relate to churn?
- Which active customers today look most likely to churn next?

The project converts raw account, subscription, usage, and support data into an interactive Power BI report built for four different questions a SaaS business asks.

---

## 🎯 Business Objectives

- Quantify overall and segment-level churn (by plan, industry, country, company size).
- Translate churn into dollar terms via Monthly Recurring Revenue (MRR) at risk.
- Identify the leading reasons customers churn and where lost revenue concentrates.
- Test whether product usage and support experience actually predict churn.
- Build a composite risk score to flag active accounts before they churn.
- Provide business recommendations based on data-driven insights, not assumptions.

---

# 🛠️ Tech Stack

- **Database:** MySQL
- **Language:** SQL
- **Data Preparation:** Power Query (Power BI)
- **Visualization:** Power BI
- **Version Control:** Git & GitHub

---

# 📁 Project Structure

```
SaaS-Churn-Revenue-at-Risk-Analytics
│
├── Dataset
│   ├── ravenstack_accounts.csv
│   ├── ravenstack_subscriptions.csv
│   ├── ravenstack_churn_events.csv
│   ├── ravenstack_feature_usage.csv
│   └── ravenstack_support_tickets.csv
│
├── SQL
│   └── Saas_Churn_Analysis.sql
│
├── Power BI Dashboard
│   └── Saas_Churn_Analysis.pbix
│
├── Images
│   ├── Executive Summary Saas.png
│   ├── Customer Churn Analysis.png
│   ├── Revenue and Revenue at Risk.png
│   └── Churn Drivers and Customer Experience.png
│
├── README.md
│
├── LICENSE
│
└── .gitignore
```

---

# 📂 Dataset Information

Five related tables covering ~500 customer accounts:

- **Accounts** — plan tier (Basic/Pro/Enterprise), industry, country, seats, trial status, churn flag
- **Subscriptions** — full subscription history per account: MRR/ARR, billing frequency, plan changes, start/end dates
- **Churn Events** — churn date, reason code, reactivation flag, refund amount, feedback text
- **Feature Usage** — usage count, error count, session duration, and beta-feature flag per subscription
- **Support Tickets** — first-response time, resolution time, satisfaction score, priority, escalation flag

---

# 🧹 Data Preparation

Cleaning and modeling were done in Power Query before analysis:

- Verified referential integrity across all 5 tables — no orphaned foreign keys
- Standardized data types on load (dates, booleans, currency) — CSV imports often mis-tag these as text
- Found that `ravenstack_subscriptions` stores full historical records (~10 rows per account, not one) — summing MRR directly overstates revenue by ~9x. Built a deduplicated **Current Subscriptions** table (latest `start_date` per account) so all revenue measures reflect current, not lifetime-summed, MRR
- Left missing `satisfaction_score` values (~41% of tickets) as blank rather than imputing zero, to avoid skewing averages
- Confirmed categorical fields (industry, country, plan tier, reason code, priority) were already consistent — no further cleanup needed

---

# 🗄️ Database Design

**Database Name**
```sql
Saas_Churn_Analysis
```

**Main Tables**
```text
ravenstack_accounts
ravenstack_subscriptions
ravenstack_churn_events
ravenstack_feature_usage
ravenstack_support_tickets
```

---

# 📊 SQL Business Analysis

## Section 1 – Customer Churn Analysis
- Total customers and overall churn rate
- Churn rate by plan, industry, country, and company size
- Does billing frequency affect churn?
- How long do customers stay before churning?
- Monthly and quarterly churn trends

## Section 2 – Revenue & Revenue-at-Risk
- Total MRR, ARR, Active MRR, Churned MRR
- What percentage of MRR is at risk?
- Revenue at risk by plan, industry, and country
- Are high-value customers disproportionately churning?

## Section 3 – Churn Reason Analysis
- Top churn reasons and their share of total churn
- Which reason causes the highest lost MRR?
- Which plan has the highest pricing-related churn?
- Which industry has the highest support-related churn?
- Customers with multiple churn events

## Section 4 – Product Usage & Engagement
- Average usage: retained vs. churned customers
- Most-used features overall, and separately for retained vs. churned
- Which features show the largest usage gap?
- Do churned customers generate more product errors?
- Is low engagement associated with higher churn?

## Section 5 – Customer Support Analysis
- Average ticket count per customer
- Ticket volume, response time, and resolution time: churned vs. retained
- Does satisfaction differ between churned and retained customers?
- Churn rate by response-time bucket and by satisfaction level

## Section 6 – Customer Lifecycle & Reactivation
- Average customer lifetime and typical churn stage
- Which signup cohorts have the highest churn?
- Overall reactivation rate, by plan, and by churn reason

---

# 📈 Dashboard

A 4-page Power BI report, each page built around a specific question:

**1. Executive Summary** — Top-level KPIs (500 customers, 22.00% churn rate, 110 churned accounts), monthly churn trend, plan-wise churn breakdown table, top churn reasons, and revenue at risk by plan.

**2. Customer Churn Analysis** — Churn rate by plan, industry, and country; trial vs. non-trial split; average customer lifetime — isolates which segments churn most.

**3. Revenue & Revenue-at-Risk** — Total MRR by plan, a revenue-at-risk gauge, a plan-level revenue exposure table, and revenue at risk by industry and plan.

**4. Churn Drivers & Customer Experience** — Average usage, error rate, first-response time, and resolution time compared side-by-side for churned vs. retained customers, plus a full support-experience breakdown table.

---

# 📈 Key Business Insights

- **22.00% overall churn rate** (110 of 500 customers), fairly even across plan tiers (~22% each) — plan tier alone does not predict churn.
- **DevTools has the highest industry churn rate (30.97%)**, nearly double Cybersecurity's (16.00%) — industry is a far stronger churn signal than plan.
- **Germany has the highest country-level churn (32.00%)**; Australia the lowest (12.50%).
- **Top churn reasons are feature gaps (114 events) and budget/support issues (104 each)** — ahead of pricing (91) and competitor loss (92), suggesting product fit drives more churn than price.
- **Cybersecurity has the lowest churn rate but the highest revenue at risk ($279K)** of any industry — fewer churned accounts, but higher-value ones. Revenue concentration matters as much as churn rate.
- **Product usage, error rates, and support response time show little to no difference between churned and retained customers** — in some cases the opposite of what's expected (churned customers had a *faster* average first response than retained ones). This is an honest finding: churn in this dataset correlates more with industry, geography, and revenue concentration than with usage friction or support quality.

---

# 👨‍💻 Author

**Venket Ramana R S**
