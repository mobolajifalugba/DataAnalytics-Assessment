-- Estimate Customer Lifetime Value (CLV) based on savings activity
SELECT 
    u.id AS customer_id,  
    CONCAT(u.first_name, ' ', u.last_name) AS name, 
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- How long the user has been with the platform
    COUNT(s.id) AS total_transactions, 
    -- Estimate CLV using a simplified formula: (average monthly transactions) * 12 months * average transaction value * adjustment factor
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0))* 12* (0.001 * AVG(s.amount)),2) AS estimated_clv 
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id  -- (left join ensures users without transactions are included)
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
ORDER BY estimated_clv DESC;
