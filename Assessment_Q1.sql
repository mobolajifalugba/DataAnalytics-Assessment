SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count, 
    COUNT(DISTINCT p.id) AS investment_count, 
    ROUND(SUM(COALESCE(s.amount, 0)) + SUM(COALESCE(p.goal, 0)), 2) AS total_deposits -- Total of all savings and investment goals combined, rounded to 2 decimals
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id AND s.amount > 0
JOIN plans_plan p ON u.id = p.owner_id AND p.goal > 0
GROUP BY u.id, u.name
HAVING savings_count > 0 AND investment_count > 0  -- Ensure the customer has both at least one funded savings and one funded investment
ORDER BY total_deposits DESC;