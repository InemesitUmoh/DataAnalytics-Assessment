USE cowrywise_assessment;

-- Get the last inflow transaction date for each plan
WITH last_inflow AS (
    SELECT 
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.transaction_type_id = 1  -- Only inflows
    GROUP BY s.plan_id
),

-- Join plans with their last inflow date and calculate inactivity period
inactivity_check AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        li.last_transaction_date,
        DATEDIFF(CURDATE(), li.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_inflow li ON p.id = li.plan_id
    WHERE p.status_id = 1
)

-- Return only those accounts with no inflow in the last 365 days
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM inactivity_check
WHERE (last_transaction_date IS NULL OR inactivity_days > 365)
ORDER BY inactivity_days DESC;