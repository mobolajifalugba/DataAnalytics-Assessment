SELECT 
    p.id AS plan_id,
    p.owner_id,       
    CASE 
        WHEN p.plan_type_id = 1 THEN 'Savings'         -- Categorize plan
        WHEN p.plan_type_id = 2 THEN 'Investment'
        ELSE 'Other'
    END AS type,
     DATE(MAX(s.transaction_date)) AS last_transaction_date,  -- Most recent transaction date for this plan
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days  -- Days since last transaction
FROM plans_plan p
LEFT JOIN savings_savingsaccount s ON s.plan_id = p.id
WHERE p.status_id = 1  -- Only consider active plans
GROUP BY p.id, p.owner_id, p.plan_type_id  
-- Filter for inactive plans
HAVING 
    last_transaction_date IS NULL
    OR DATEDIFF(CURDATE(), last_transaction_date) > 365
ORDER BY inactivity_days DESC;
