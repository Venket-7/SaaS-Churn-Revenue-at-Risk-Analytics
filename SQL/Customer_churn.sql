-- Create Database
CREATE DATABASE IF NOT EXISTS Saas_Churn_Analysis;

-- Use Database
USE Saas_Churn_Analysis;

-- ==================================================================================================================================

-- Q1.What is the customer churn rate?
SELECT ROUND(COUNT(DISTINCT CASE 
								WHEN churn_flag = 'TRUE' THEN account_id END) * 100.0 / COUNT(DISTINCT account_id),2) AS Churn_rate
FROM ravenstack_accounts;

-- Q2. What is churn by plan?
SELECT plan_tier,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END) * 100.0/ COUNT(DISTINCT account_id), 2) AS churn_rate
FROM ravenstack_accounts
GROUP BY plan_tier
ORDER BY churn_rate DESC;

-- Q3.What is churn by industry?
SELECT industry,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END)* 100.0 / COUNT(DISTINCT account_id), 2) AS churn_rate
FROM ravenstack_accounts
GROUP BY industry
ORDER BY churn_rate DESC;

-- Q4.What is churn by country?
SELECT country,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END)* 100.0 / COUNT(DISTINCT account_id), 2) AS churn_rate
FROM ravenstack_accounts
GROUP BY country
ORDER BY churn_rate DESC;

-- Q5.What is churn by company size?
SELECT
    CASE
        WHEN seats <= 10 THEN '1-10'
        WHEN seats <= 50 THEN '11-50'
        WHEN seats <= 100 THEN '51-100'
        ELSE '101+'
    END AS company_size,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END) AS churned_customers,
    ROUND( COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END) * 100.0 / COUNT(DISTINCT account_id),2) AS churn_rate
FROM ravenstack_accounts
GROUP BY
    CASE
        WHEN seats <= 10 THEN '1-10'
        WHEN seats <= 50 THEN '11-50'
        WHEN seats <= 100 THEN '51-100'
        ELSE '101+'
    END
ORDER BY churn_rate DESC;

-- Q6.Does billing frequency affect churn?
SELECT billing_frequency,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END)* 100.0 / COUNT(DISTINCT account_id), 2) AS churn_rate
FROM ravenstack_subscriptions
GROUP BY billing_frequency
ORDER BY churn_rate DESC;

-- Q7.When does churn occur?
-- Monthly churn
SELECT
    DATE_FORMAT(churn_date, '%Y-%m') AS churn_month,
    COUNT(DISTINCT account_id) AS churned_customers
FROM ravenstack_churn_events
GROUP BY churn_month
ORDER BY churn_month;

-- Quarterly churn
SELECT
    YEAR(churn_date) AS churn_year,
    QUARTER(churn_date) AS churn_quarter,
    COUNT(DISTINCT account_id) AS churned_customers
FROM ravenstack_churn_events
GROUP BY churn_year, churn_quarter
ORDER BY churn_year, churn_quarter;