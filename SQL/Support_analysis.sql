-- Create Database
CREATE DATABASE IF NOT EXISTS Saas_Churn_Analysis;

-- Use Database
USE Saas_Churn_Analysis;

-- ==================================================================================================================================
-- Q1. Do churned customers have more tickets?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    COUNT(t.ticket_id) AS total_tickets,
    COUNT(DISTINCT a.account_id) AS customers,
    ROUND(COUNT(t.ticket_id)/ COUNT(DISTINCT a.account_id),2) AS avg_tickets_per_customer
FROM ravenstack_accounts a
LEFT JOIN ravenstack_support_tickets t ON a.account_id = t.account_id
GROUP BY a.churn_flag;

-- Q2.Do churned customers have slower first responses?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(t.first_response_time_minutes),2) AS avg_first_response_minutes
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
GROUP BY a.churn_flag;

-- Q3.Do churned customers have longer resolution times?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(t.resolution_time_hours),2) AS avg_resolution_hours
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
GROUP BY a.churn_flag;

-- Q4.Does satisfaction differ between churned and retained customers?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(t.satisfaction_score),2) AS avg_satisfaction
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
WHERE t.satisfaction_score IS NOT NULL
GROUP BY a.churn_flag;

-- Q5.What is churn by satisfaction level?
SELECT
    CASE
        WHEN t.satisfaction_score <= 2 THEN 'Low'
        WHEN t.satisfaction_score = 3 THEN 'Medium'
        WHEN t.satisfaction_score >= 4 THEN 'High'
    END AS satisfaction_level,
    COUNT(DISTINCT t.account_id) AS customers,
    COUNT(DISTINCT CASE
					WHEN a.churn_flag = 'TRUE' THEN t.account_id
    END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE
						 WHEN a.churn_flag = 'TRUE' THEN t.account_idEND) * 100.0/ COUNT(DISTINCT t.account_id),2) AS churn_rate
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
WHERE t.satisfaction_score IS NOT NULL
GROUP BY satisfaction_level
ORDER BY churn_rate DESC;
