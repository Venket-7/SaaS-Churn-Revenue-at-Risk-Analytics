# 📊 SaaS Churn & Revenue-at-Risk Analytics

An end-to-end SaaS analytics project using **MySQL, SQL, Power BI, DAX, Python, and Machine Learning** to analyze customer churn, recurring revenue exposure, churn drivers, product usage, customer support, and predictive churn risk.

---

## 📌 Project Overview

This project analyzes RavenStack's SaaS customer data to answer business questions around:

- Customer churn
- Churn by customer segment
- MRR and ARR
- Churned MRR and revenue exposure
- Churn reasons
- Product usage and engagement
- Customer support experience
- Customer satisfaction
- Predictive churn modeling
- Customer risk segmentation
- Model explainability using SHAP

The project contains both **descriptive/diagnostic analytics** and **predictive analysis**.

---

## 🎯 Business Objectives

- Measure overall and segment-level customer churn.
- Analyze churn by plan, industry, country, company size, and billing frequency.
- Analyze when churn occurs.
- Measure MRR, ARR, Active MRR, and Churned MRR.
- Identify final churn reasons and their associated lost MRR.
- Compare product usage and product errors between retained and churned customers.
- Analyze customer engagement and its relationship with churn.
- Compare support tickets, response time, resolution time, and satisfaction between retained and churned customers.
- Build and evaluate churn prediction models.
- Generate customer churn probabilities and risk segments.
- Explain model predictions using SHAP.

---

# 🛠️ Tech Stack

- **Database:** MySQL
- **Query Language:** SQL
- **Business Intelligence:** Power BI
- **Power BI Calculations:** DAX
- **Data Preparation / Analysis:** Python, pandas
- **Machine Learning:** scikit-learn, XGBoost
- **Model Explainability:** SHAP
- **Visualization:** Power BI, Matplotlib
- **Version Control:** Git & GitHub

---

# 📁 Project Structure

```text
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
│   ├── 01_customer_churn.sql
│   ├── 02_revenue_analysis.sql
│   ├── 03_churn_drivers.sql
│   ├── 04_product_usage.sql
│   └── 05_support_analysis.sql
│
├── Power BI Dashboard
│   └── Saas_Churn_Analysis.pbix
│       └──Images
│           ├── Executive_Overview.png
│           ├── Revenue_Exposure.png
│           ├── Customer_Churn_Segmentation.png
│           └── Churn_Drivers.png
│
├── Predicitve_analysis
│   ├── churn_model.ipynb
│   ├── model_comparison_test.csv
│   ├── confusion_matrix.png
│   ├── risk_segments.png
│   ├── roc_curves.png
│   └── shap_summary.png
│
├── Documentation
|   └──Business_Questions.txt
|
├── requirements
├── README.md
├── LICENSE
└── .gitignore
```

---

# 📂 Dataset

The project uses five related RavenStack tables covering approximately **500 customer accounts**.

### Accounts
- Plan tier
- Industry
- Country
- Seats
- Trial status
- Churn flag
- Signup date

### Subscriptions
- Subscription history
- MRR
- ARR
- Billing frequency
- Plan changes
- Start and end dates

### Churn Events
- Churn date
- Churn reason
- Reactivation flag
- Refund amount
- Feedback

### Feature Usage
- Feature name
- Usage count
- Error count
- Session duration
- Beta-feature usage

### Support Tickets
- Ticket information
- First-response time
- Resolution time
- Satisfaction score
- Priority
- Escalation flag

---

# 🧹 Data Preparation

The data was prepared for analysis before building the dashboard and predictive model.

Key preparation work included:

- Standardizing data types.
- Checking relationships between the five tables.
- Handling the historical subscription records when calculating MRR measures.
- Keeping missing satisfaction values as missing instead of treating them as zero.
- Creating customer-level aggregated features for predictive modeling.

---

# 🗄️ Database

### Database Name

```sql
Saas_Churn_Analysis
```

### Tables

```text
ravenstack_accounts
ravenstack_subscriptions
ravenstack_churn_events
ravenstack_feature_usage
ravenstack_support_tickets
```

---

# 📊 SQL Business Analysis

## 01 — Customer Churn Analysis

- What is the customer churn rate?
- Churn by plan
- Churn by industry
- Churn by country
- Churn by company size
- Does billing frequency affect churn?
- When does churn occur?

fileciteturn5file2L9-L39

---

## 02 — Revenue Analysis

- What is Total MRR?
- What is Total ARR?
- What is Churned MRR?
- What is Churned MRR as a percentage of current MRR?
- Which plans have the highest churned MRR?
- Which industries have the highest churned MRR?
- Which countries have the highest churned MRR?

fileciteturn5file4L9-L55

---

## 03 — Churn Drivers

- What are the top final churn reasons?
- Which final churn reason is associated with the highest lost MRR?

fileciteturn5file1L9-L23

---

## 04 — Product Usage & Engagement

- What is the average usage for retained customers?
- What is the average usage for churned customers?
- Do churned customers have more product errors?
- Is low engagement associated with higher churn?

Engagement is grouped into:

- Low Engagement
- Medium Engagement
- High Engagement

fileciteturn5file3L9-L57

---

## 05 — Customer Support Analysis

- Do churned customers have more tickets?
- Do churned customers have slower first responses?
- Do churned customers have longer resolution times?
- Does satisfaction differ between churned and retained customers?
- What is churn by satisfaction level?

fileciteturn5file5L8-L72

---

# 📈 Power BI Dashboard

The Power BI report contains four pages.

### 1. Executive Summary

- Total customers
- Churned customers
- Churn rate
- MRR
- Monthly churn trend
- Plan-wise churn
- Top churn reasons
- Revenue exposure

### 2. Customer Churn Analysis

- Churn rate by plan
- Churn rate by industry
- Churn rate by country
- Trial vs. non-trial analysis
- Average customer lifetime
- Customer segmentation

### 3. Revenue & Revenue-at-Risk

- Total MRR
- Active MRR
- Churned MRR
- Churned MRR %
- MRR by plan
- Revenue exposure by plan
- Revenue exposure by industry

### 4. Churn Drivers & Customer Experience

- Churn reasons
- Average usage
- Average errors
- Engagement level
- Support tickets
- First-response time
- Resolution time
- Satisfaction
- Retained vs. churned comparisons

---

# 🤖 Predictive Churn Modeling

A predictive churn analysis was developed using customer-level features from the SaaS data.

### Models evaluated

- Logistic Regression
- Random Forest
- XGBoost

The modeling workflow includes:

- Customer-level feature engineering
- Model comparison
- Train/test evaluation
- ROC curves
- Churn probability output
- Risk segmentation
- SHAP explainability

---

# 📊 Model Evaluation

The hold-out ROC curves produced the following AUC values shown in the project outputs:

| Model | ROC-AUC |
|---|---:|
| Logistic Regression | 0.62 |
| Random Forest | 0.58 |
| XGBoost | 0.52 |

The project also includes the Random Forest confusion matrix at a **0.23 threshold**.

The resulting test-set confusion matrix was:

```text
                 Predicted
                 Retained   Churned

Actual Retained      0         78
Actual Churned       0         22
```

---

# 🎯 Risk Segmentation

The predictive workflow also creates customer risk segments based on model-estimated churn probabilities.

The project output contains:

- Low Risk
- Medium Risk
- High Risk

The observed churn rates shown in the risk-segment analysis are approximately:

- Low: 20%
- Medium: 23%
- High: 25%

---

# 🔎 SHAP Explainability

SHAP was used to analyze feature importance and understand model output.

The SHAP analysis includes features such as:

- Average MRR
- Average first-response time
- Error rate
- Average session duration
- Subscription tenure
- Distinct features used
- Account age
- Trial subscription share
- Beta usage share
- Industry
- Maximum MRR
- High-priority ticket share

---

# 📈 Key Business Insights

- **500 customers** are included in the analysis.
- **110 customers are churned**, resulting in an observed churn rate of **22.00%**.
- Churn rates are approximately 22% across Basic, Enterprise, and Pro plans.
- **DevTools** has the highest observed industry churn rate at **30.97%**.
- **Germany** has the highest observed country churn rate at **32.00%**.
- Feature-related issues are the most frequently observed churn reason in the churn-event analysis.
- The project compares product usage, product errors, support experience, and satisfaction between retained and churned customers.
- The predictive models show limited separation between churned and retained customers in the current dataset.

---

# 📌 Project Outputs

The project produces:

### SQL
Business-question-driven SQL analysis.

### Power BI
Interactive churn, revenue, product, and support dashboards.

### Machine Learning
Churn model comparison, ROC curves, confusion matrix, risk segments, and SHAP analysis.

---

# 👨‍💻 Author

**Venket Ramana R S**
