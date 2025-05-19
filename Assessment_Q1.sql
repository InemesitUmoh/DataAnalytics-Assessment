USE cowrywise_assessment;

-- CTE to get savings data: count of savings plans and total confirmed deposits (converted from Kobo to Naira)
WITH savings_data AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS savings_count,
        SUM(s.confirmed_amount) / 100 AS savings_total   ### Converts koko to naira
    FROM plans_plan p
    JOIN savings_savingsaccount s ON p.id = s.plan_id
    WHERE p.is_regular_savings = 1 AND s.confirmed_amount > 0
    GROUP BY p.owner_id
),

-- CTE to get investment data: count of investment plans and total confirmed deposits (in Naira)
investment_data AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS investment_count,
        SUM(s.confirmed_amount) / 100 AS investment_total  ### Converts koko to naira
    FROM plans_plan p
    JOIN savings_savingsaccount s ON p.id = s.plan_id
    WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
    GROUP BY p.owner_id
)

-- Final selection: customers with both savings and investment plans
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    sd.savings_count,
    idt.investment_count,
    ROUND(IFNULL(sd.savings_total, 0) + IFNULL(idt.investment_total, 0), 2) AS total_deposits
FROM savings_data sd
JOIN investment_data idt ON sd.owner_id = idt.owner_id
JOIN users_customuser u ON u.id = sd.owner_id
ORDER BY total_deposits DESC;