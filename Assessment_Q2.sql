-- Aggregate each user's transaction behavior
WITH user_tx_summary AS (
  SELECT 
      u.id AS user_id, 
      COUNT(s.id) AS total_transactions,
      COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) AS active_months,  -- Number of distinct active months (YYYY-MM)
      ROUND(
        COUNT(s.id) / NULLIF(COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')), 0), 
        2
      ) AS avg_tx_per_month  
  FROM users_customuser u
  LEFT JOIN savings_savingsaccount s 
      ON s.owner_id = u.id 
  GROUP BY u.id
),

-- Segment users based on their average monthly transaction frequency
frequency_segmented AS (
  SELECT 
    user_id,
    avg_tx_per_month,
    CASE 
        WHEN avg_tx_per_month >= 10 THEN 'High Frequency' 
        WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency' 
    END AS frequency_category
  FROM user_tx_summary
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count, 
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month  
FROM frequency_segmented
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
