-- Create Database
CREATE DATABASE IF NOT EXISTS Saas_Churn_Analysis;

-- Use Database
USE Saas_Churn_Analysis;

-- ==================================================================================================================================

-- Q1.What is the average usage for retained customers?
SELECT ROUND(AVG(fu.usage_count),2) AS avg_usage_retained
FROM ravenstack_feature_usage fu
JOIN ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
JOIN ravenstack_accounts a ON s.account_id = a.account_id
WHERE a.churn_flag = 'FALSE';

-- Q2.What is the average usage for churned customers?
SELECT ROUND(AVG(fu.usage_count),2) AS avg_usage_churned
FROM ravenstack_feature_usage fu
JOIN ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
JOIN ravenstack_accounts a ON s.account_id = a.account_id
WHERE a.churn_flag = 'TRUE';

-- Q3.Do churned customers have more product errors?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(fu.error_count),2) AS avg_errors
FROM ravenstack_feature_usage fu
JOIN ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
JOIN ravenstack_accounts a ON s.account_id = a.account_id
GROUP BY a.churn_flag;

-- Q4.Is low engagement associated with higher churn?
WITH customer_usage AS (
    SELECT s.account_id,
        SUM(fu.usage_count) AS total_usage
    FROM ravenstack_feature_usage fu
    JOIN ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
    GROUP BY s.account_id),
    engagement_segments AS (
    SELECT cu.account_id,cu.total_usage,
        CASE
            WHEN cu.total_usage < 100 THEN 'Low Engagement'
            WHEN cu.total_usage < 300 THEN 'Medium Engagement'
            ELSE 'High Engagement'
        END AS engagement_level
    FROM customer_usage cu)
    
SELECT es.engagement_level,COUNT(*) AS customers,
    SUM(CASE WHEN a.churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN a.churn_flag = 'TRUE' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2) AS churn_rate
FROM engagement_segments es
JOIN ravenstack_accounts a ON es.account_id = a.account_id
GROUP BY es.engagement_level
ORDER BY churn_rate DESC;