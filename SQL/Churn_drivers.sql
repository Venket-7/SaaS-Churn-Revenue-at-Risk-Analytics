-- Create Database
CREATE DATABASE IF NOT EXISTS Saas_Churn_Analysis;

-- Use Database
USE Saas_Churn_Analysis;

-- ==================================================================================================================================

-- Q1. What are the top final churn reasons?
SELECT reason_code,
    COUNT(*) AS churned_customers
FROM final_churn_reason
GROUP BY reason_code
ORDER BY churned_customers DESC;

-- Q2. Which final churn reason is associated with the highest lost MRR?
SELECT f.reason_code,
    ROUND(SUM(s.mrr_amount), 2) AS churned_mrr
FROM final_churn_reason f
JOIN latest_subscription s
    ON f.account_id = s.account_id
GROUP BY f.reason_code
ORDER BY churned_mrr DESC;