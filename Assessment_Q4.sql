USE cowrywise_assessment;

-- Compute transaction statistics per user (Convert kobo to naira)
WITH txn_stats AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        AVG(s.confirmed_amount * 0.001)/100 AS avg_profit_per_transaction
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, name, tenure_months
),

-- Calculate the estimated CLV for each customer
clv_calc AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(
            (total_transactions / NULLIF(tenure_months, 0)) * 12 * avg_profit_per_transaction,
            2
        ) AS estimated_clv
    FROM txn_stats
)

-- Return the final result sorted by CLV in descending order
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;