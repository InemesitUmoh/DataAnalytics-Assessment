USE cowrywise_assessment;

-- Calculate the number of transactions per user per month
WITH monthly_txns AS (
    SELECT 
        u.id AS user_id,
        DATE_FORMAT(s.maturity_start_date, '%Y-%m') AS txn_month,
        COUNT(s.id) AS txn_count
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE s.transaction_date IS NOT NULL
    GROUP BY u.id, txn_month
),

-- Calculate the average number of transactions per user per month
avg_txn_per_customer AS (
    SELECT 
        user_id,
        AVG(txn_count) AS avg_txn_per_month
    FROM monthly_txns
    GROUP BY user_id
),

-- Categorize users based on average monthly transaction frequency
categorized AS (
    SELECT 
        u.id AS user_id,
        COALESCE(a.avg_txn_per_month, 0) AS avg_txn_per_month,
        CASE
            WHEN COALESCE(a.avg_txn_per_month, 0) >= 10 THEN 'High Frequency'
            WHEN COALESCE(a.avg_txn_per_month, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM users_customuser u
    LEFT JOIN avg_txn_per_customer a ON u.id = a.user_id
)

-- Aggregate the result to get counts and average per frequency category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,                       
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');