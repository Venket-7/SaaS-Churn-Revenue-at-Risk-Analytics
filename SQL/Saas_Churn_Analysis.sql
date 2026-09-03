-- ======================================================================
-- 				SAAS Churn & Revenue-at-Risk Analytics
-- ======================================================================

-- Create Database
CREATE DATABASE Saas_Churn_Analysis;

-- Use Database
USE Saas_Churn_Analysis;

-- View data from tables
SELECT * FROM ravenstack_accounts;
SELECT * FROM ravenstack_churn_events;
SELECT * FROM ravenstack_feature_usage;
SELECT * FROM ravenstack_subscriptions;
SELECT * FROM ravenstack_support_tickets;

-- ===============================================
-- 			Customer Churn Analysis 
-- ===============================================

-- Q1. What is the total customer count?
SELECT COUNT(DISTINCT account_id) as No_of_Customers FROM ravenstack_accounts;

-- Q2.How many customers have churned?
SELECT COUNT(DISTINCT account_id) as No_of_Customers FROM ravenstack_accounts WHERE churn_flag="TRUE";

-- Q3.What is the customer churn rate?
SELECT ROUND(COUNT(DISTINCT 
		CASE WHEN churn_flag = 'TRUE' THEN account_id END) * 100.0 / COUNT(DISTINCT account_id),2) AS Churn_rate
FROM ravenstack_accounts;

-- Q4. What is churn by plan?
SELECT
    plan_tier,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END) AS churned_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END) * 100.0
        / COUNT(DISTINCT account_id), 2
    ) AS churn_rate
FROM ravenstack_accounts
GROUP BY plan_tier
ORDER BY churn_rate DESC;

-- Q5.What is churn by industry?
SELECT
    industry,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END) AS churned_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN churn_flag='TRUE' THEN account_id END)
        * 100.0 / COUNT(DISTINCT account_id), 2
    ) AS churn_rate
FROM ravenstack_accounts
GROUP BY industry
ORDER BY churn_rate DESC;

-- Q6.What is churn by country?
SELECT
    country,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END) AS churned_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END)
        * 100.0 / COUNT(DISTINCT account_id), 2
    ) AS churn_rate
FROM ravenstack_accounts
GROUP BY country
ORDER BY churn_rate DESC;

-- Q7.What is churn by company size?
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

-- Q8.Does billing frequency affect churn?
SELECT
    billing_frequency,
    COUNT(DISTINCT account_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE WHEN churn_flag = 'TRUE' THEN account_id END)* 100.0 / COUNT(DISTINCT account_id), 2) AS churn_rate
FROM ravenstack_subscriptions
GROUP BY billing_frequency
ORDER BY churn_rate DESC;

-- Q9.How long do customers stay before churn?
WITH customer_lifetime AS (
    SELECT
        a.account_id,
        DATEDIFF(MIN(c.churn_date), a.signup_date) AS lifetime_days
    FROM ravenstack_accounts a
    JOIN ravenstack_churn_events c
        ON a.account_id = c.account_id
    WHERE a.churn_flag = 'TRUE'
    GROUP BY a.account_id, a.signup_date
)

SELECT
    COUNT(*) AS churned_customers,
    ROUND(AVG(lifetime_days), 2) AS avg_lifetime_days,
    ROUND(AVG(lifetime_days) / 30.44, 2) AS avg_lifetime_months
FROM customer_lifetime;

-- Q10.When does churn occur?
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

-- ===============================================
-- 		    Revenue & Revenue-at-Risk
-- ===============================================

-- Q11.What is Total MRR?
SELECT ROUND(SUM(mrr_amount), 2) AS total_mrr
FROM ravenstack_subscriptions;

-- Q12.What is Total ARR?
SELECT ROUND(SUM(arr_amount), 2) AS total_arr
FROM ravenstack_subscriptions;

-- Q13.What is Active MRR?
SELECT ROUND(SUM(mrr_amount), 2) AS active_mrr
FROM ravenstack_subscriptions
WHERE churn_flag = 'FALSE';

-- Q14.What is Churned MRR?
SELECT ROUND(SUM(mrr_amount), 2) AS churned_mrr
FROM ravenstack_subscriptions
WHERE churn_flag = 'TRUE';

-- Q15.What is Revenue at Risk?
SELECT ROUND(SUM(mrr_amount), 2) AS revenue_at_risk
FROM ravenstack_subscriptions
WHERE churn_flag ='TRUE';

-- Q16.What percentage of MRR at Risk?
SELECT ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN mrr_amount ELSE 0 END)* 100.0 / SUM(mrr_amount),2) 
AS revenue_at_risk_percentage
FROM ravenstack_subscriptions;

-- Q17.Which plans have the highest revenue at risk?
SELECT plan_tier,
    ROUND(SUM(mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN mrr_amount ELSE 0 END), 2) AS revenue_at_risk,
    ROUND(SUM(CASE WHEN churn_flag = 'TRUE' THEN mrr_amount ELSE 0 END)* 100.0/ SUM(mrr_amount),2) AS revenue_at_risk_percentage
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY revenue_at_risk DESC;

-- Q18.Which industries have the highest revenue at risk?
SELECT a.industry,
    ROUND(SUM(s.mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END), 2) AS revenue_at_risk,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END)* 100.0/ SUM(s.mrr_amount),2) AS revenue_at_risk_percentage
FROM ravenstack_accounts a 
JOIN ravenstack_subscriptions s ON a.account_id = s.account_id
GROUP BY a.industry
ORDER BY revenue_at_risk DESC;

-- Q19.Which countries have the highest revenue at risk?
SELECT a.country,
    ROUND(SUM(s.mrr_amount), 2) AS total_mrr,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END), 2) AS revenue_at_risk,
    ROUND(SUM(CASE WHEN s.churn_flag = 'TRUE' THEN s.mrr_amount ELSE 0 END)* 100.0/ SUM(s.mrr_amount),2) AS revenue_at_risk_percentage
FROM ravenstack_accounts a 
JOIN ravenstack_subscriptions s ON a.account_id = s.account_id
GROUP BY a.country
ORDER BY revenue_at_risk DESC;

-- Q20.Are high-value customers disproportionately churning?
WITH customer_revenue AS (		
		SELECT account_id,
        SUM(mrr_amount) AS total_mrr,
        MAX(CASE WHEN churn_flag = 'TRUE' THEN 1 ELSE 0 END) AS churned
    FROM ravenstack_subscriptions
    GROUP BY account_id),
customer_segments AS (
    SELECT account_id,total_mrr,churned,
        CASE
            WHEN total_mrr < 500 THEN 'Low Value'
            WHEN total_mrr < 1500 THEN 'Medium Value'
            WHEN total_mrr < 3000 THEN 'High Value'
            ELSE 'Very High Value'
        END AS value_segment
    FROM customer_revenue)
    
SELECT value_segment,
    COUNT(*) AS total_customers,
    SUM(churned) AS churned_customers,
    ROUND(SUM(churned) * 100.0 / COUNT(*),2) AS churn_rate_percentage,
    ROUND(SUM(total_mrr), 2) AS total_mrr
FROM customer_segments
GROUP BY value_segment
ORDER BY total_mrr DESC;

-- ===============================================
-- 			Churn Reason Analysis 
-- ===============================================
-- Q21.What are the top churn reasons?
SELECT reason_code,
    COUNT(*) AS churn_events
FROM ravenstack_churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;

-- Q22. What % of churn does each reason represent?
SELECT reason_code,
    COUNT(*) AS churn_events,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ravenstack_churn_events),2) AS churn_percentage
FROM ravenstack_churn_events
GROUP BY reason_code
ORDER BY churn_percentage DESC;

-- Q23.Which churn reason causes the highest lost MRR?
SELECT ce.reason_code,
    ROUND(SUM(s.mrr_amount),2) AS lost_mrr
FROM ravenstack_churn_events ce
JOIN ravenstack_subscriptions s ON ce.account_id = s.account_id
WHERE s.churn_flag = 'TRUE'
GROUP BY ce.reason_code
ORDER BY lost_mrr DESC;

-- Q24.Which plan has the highest pricing-related churn?
SELECT s.plan_tier,
    COUNT(*) AS pricing_churn_events
FROM ravenstack_churn_events ce
JOIN ravenstack_subscriptions s ON ce.account_id = s.account_id
WHERE ce.reason_code = 'Pricing'
GROUP BY s.plan_tier
ORDER BY pricing_churn_events DESC;

-- Q25. Which industry has the highest support-related churn?
SELECT a.industry,
    COUNT(*) AS support_churn_events
FROM ravenstack_churn_events ce
JOIN ravenstack_accounts a ON ce.account_id = a.account_id
WHERE ce.reason_code = 'Support'
GROUP BY a.industry
ORDER BY support_churn_events DESC;

-- Q26. How many customers have multiple churn events?
SELECT
    COUNT(*) AS customers_with_multiple_churn_events
FROM (SELECT account_id
    FROM ravenstack_churn_events
    GROUP BY account_id
    HAVING COUNT(*) > 1
) AS multiple_churners;

-- ===============================================
-- 			Product Usage & Engagement
-- ===============================================

-- Q27.What is the average usage for retained customers?
SELECT ROUND(AVG(fu.usage_count),2) AS avg_usage_retained
FROM ravenstack_feature_usage fu
JOIN ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
JOIN ravenstack_accounts a ON s.account_id = a.account_id
WHERE a.churn_flag = 'FALSE';

-- Q28.What is the average usage for churned customers?
SELECT
    ROUND(AVG(fu.usage_count),2) AS avg_usage_churned
FROM ravenstack_feature_usage fu
JOIN ravenstack_subscriptions s ON fu.subscription_id = s.subscription_id
JOIN ravenstack_accounts a ON s.account_id = a.account_id
WHERE a.churn_flag = 'TRUE';

-- Q29.Which features are most used overall?
SELECT feature_name,SUM(usage_count) AS total_usage
FROM ravenstack_feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC;

-- Q30.Do churned customers have more product errors?
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

-- Q31.Is low engagement associated with higher churn?
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

-- ===============================================
-- 			Customer Support Analysis
-- ===============================================

-- Q32.What is the average ticket count per customer?
SELECT ROUND(COUNT(*)/ COUNT(DISTINCT account_id),2) AS avg_tickets_per_customer
FROM ravenstack_support_tickets;

-- Q33. Do churned customers have more tickets?
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

-- Q34.Do churned customers have slower first responses?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(t.first_response_time_minutes),2) AS avg_first_response_minutes
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
GROUP BY a.churn_flag;

-- Q35.Do churned customers have longer resolution times?
SELECT
    CASE
        WHEN a.churn_flag = 'TRUE' THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(t.resolution_time_hours),2) AS avg_resolution_hours
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
GROUP BY a.churn_flag;

-- Q36.Does satisfaction differ between churned and retained customers?
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

-- Q37.What is churn by satisfaction level?
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
		WHEN a.churn_flag = 'TRUE' THEN t.account_id
		END) * 100.0/ COUNT(DISTINCT t.account_id),2) AS churn_rate
FROM ravenstack_support_tickets t
JOIN ravenstack_accounts a ON t.account_id = a.account_id
WHERE t.satisfaction_score IS NOT NULL
GROUP BY satisfaction_level
ORDER BY churn_rate DESC;

-- ===============================================
-- 		  Customer Lifecycle & Reactivation
-- ===============================================
-- Q38.At what point do customers typically churn?
SELECT
    CASE
        WHEN TIMESTAMPDIFF(MONTH,a.signup_date,ce.churn_date) < 3 THEN '0-3 Months'
        WHEN TIMESTAMPDIFF(MONTH,a.signup_date,ce.churn_date) < 6 THEN '3-6 Months'
        WHEN TIMESTAMPDIFF(MONTH,a.signup_date,ce.churn_date) < 12 THEN '6-12 Months'
        ELSE '12+ Months'
    END AS lifecycle_stage,
    COUNT(*) AS churn_events
FROM ravenstack_churn_events ce
JOIN ravenstack_accounts a ON ce.account_id = a.account_id
WHERE ce.is_reactivation = 'FALSE'
GROUP BY lifecycle_stage
ORDER BY churn_events DESC;

-- Q39.Which customer cohorts have the highest churn?
SELECT
    DATE_FORMAT(a.signup_date,'%Y-%m') AS cohort,
    COUNT(DISTINCT a.account_id) AS customers,
    COUNT(DISTINCT CASE
        WHEN a.churn_flag = 'TRUE' THEN a.account_id END) AS churned_customers,
    ROUND(COUNT(DISTINCT CASE
            WHEN a.churn_flag = 'TRUE' THEN a.account_id END) * 100.0/ COUNT(DISTINCT a.account_id),2) AS churn_rate
FROM ravenstack_accounts a
GROUP BY cohort
ORDER BY churn_rate DESC;

-- Q40.What is the reactivation rate?
SELECT
    COUNT(CASE WHEN is_reactivation = 'TRUE' THEN 1 END) AS reactivation_events,
    COUNT(*) AS total_churn_events,
    ROUND(COUNT(CASE WHEN is_reactivation = 'TRUE' THEN 1 END) * 100.0/ COUNT(*),2) AS reactivation_rate
FROM ravenstack_churn_events;

-- ===============================================
-- 		  Customer Risk & Retention
-- ===============================================

-- Q41.Which active customers have high MRR?
SELECT a.account_id,a.account_name,a.plan_tier,ROUND(SUM(s.mrr_amount),2) AS mrr
FROM ravenstack_accounts a
JOIN ravenstack_subscriptions s ON a.account_id = s.account_id
WHERE a.churn_flag = 'FALSE'
GROUP BY a.account_id,a.account_name,a.plan_tier
ORDER BY mrr DESC
LIMIT 20;
