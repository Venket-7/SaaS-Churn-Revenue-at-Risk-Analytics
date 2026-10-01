-- Create Database
CREATE DATABASE IF NOT EXISTS Saas_Churn_Analysis;

-- Use Database
USE Saas_Churn_Analysis;

-- ==================================================================================================================================

-- Q1. What is Total MRR?
SELECT ROUND(SUM(mrr_amount), 2) AS total_mrr
FROM ravenstack_subscriptions;

-- Q2. What is Total ARR?
SELECT ROUND(SUM(arr_amount), 2) AS total_arr
FROM ravenstack_subscriptions;

-- Q3. What is Churned MRR?
SELECT ROUND(SUM(mrr_amount), 2) AS churned_mrr
FROM ravenstack_subscriptions
WHERE churn_flag = 'TRUE';

-- Q4. What is Churned MRR as a percentage of current MRR?
SELECT ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN mrr_amount ELSE 0 END)* 100.0 / SUM(mrr_amount),2) AS churned_mrr_percentage
FROM ravenstack_subscriptions;

-- Q5. Which plans have the highest churned MRR?
SELECT plan_tier,
    ROUND(SUM(mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN mrr_amount ELSE 0 END),2) AS churned_mrr,
    ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN mrr_amount ELSE 0 END)* 100.0 / SUM(mrr_amount),2) AS churned_mrr_percentage
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY churned_mrr DESC;

-- Q6. Which industries have the highest churned MRR?
SELECT a.industry,
    ROUND(SUM(s.mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END),2) AS churned_mrr,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END)* 100.0 / SUM(s.mrr_amount),2) AS churned_mrr_percentage
FROM ravenstack_accounts a
JOIN ravenstack_subscriptions s
    ON a.account_id = s.account_id
GROUP BY a.industry
ORDER BY churned_mrr DESC;

-- Q7. Which countries have the highest churned MRR?
SELECT
    a.country,
    ROUND(SUM(s.mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END),2) AS churned_mrr,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END)* 100.0 / SUM(s.mrr_amount),2) AS churned_mrr_percentage
FROM ravenstack_accounts a
JOIN ravenstack_subscriptions s
    ON a.account_id = s.account_id
GROUP BY a.country
ORDER BY churned_mrr DESC;