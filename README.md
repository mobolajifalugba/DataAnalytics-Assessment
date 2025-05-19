# DataAnalytics-Assessment
## Approach and Challenges to each business questions

1: High-Value Customers with Multiple Products
### Approach :
- JOINED the three tables on the owner_id (i.e. u.id = s.owner_id and u.id = p.owner_id) to relate savings and investment data to each user.
- Filtered only users with funded savings (s.amount > 0) and funded investments (p.goal > 0).
- Grouped the results by each user to: Savings_count, Investment_count, Total_deposits as the sum of all savings amount and plan goal.
- Sorted results by total deposit in descending order to surface high-value customers.

### Challenges and Resolution: 
- Ambiguous Plan Types: It wasn't immediately clear which plans in plans_plan were savings vs investment. Assumed savings_savingsaccount represents actual savings, and plans_plan represents investment plans.


2. Transaction Frequency Analysis
### Approach :
- Joined users_customuser with savings_savingsaccount using owner_id.
- Counted all savings transactions per customer.
- Calculated the number of active months per user using DATE_FORMAT(transaction_date, '%Y-%m').
- Computed the average monthly transactions: avg_tx_per_month = total_transactions / active_months
- Categorized users into: High Frequency (≥10/month), Medium Frequency (3–9/month), Low Frequency (≤2/month)
- Grouped and aggregated to produce segment counts and average metrics.

### Challenges and Resolution:  
- Ensuring accurate month grouping across time zones or inconsistent timestamps.
- Deciding on inflow vs. all transaction logic; Used all transactions for simplicity.
- Handling users with no transactions (division by 0 risk).

3. Account Inactivity Alert
### Approach :
- Used plans_plan to get account metadata.
- Used savings_savingsaccount to check for recent transactions (via transaction_date).
- Calculated the most recent transaction per plan.
- Used DATEDIFF(CURDATE(), last_transaction_date) to calculate inactivity days.
- Filtered for accounts with inactivity > 365 days or no transaction at all.
- Classified plan type using plan_type_id: 1 = Savings  2 = Investment

### Challenges and Resolution: 
- Accounts with no transactions ever returned NULL for last_transaction_date — handled via HAVING clause.
- No separate inflow/outflow field — assumed any transaction implies activity.
- Ensuring accurate status filtering (status_id = 1) for active accounts only.

4. Customer Lifetime Value (CLV) Estimation
### Approach :
- Used users_customuser.date_joined to calculate account tenure in months.
- Counted all transactions from savings_savingsaccount per user.
- Calculated average transaction value and applied a fixed profit rate of 0.1% (0.001). CLV formula used: CLV = (total_transactions / tenure_months) * 12 * (avg_transaction_value * 0.001)
- Rounded CLV to 2 decimal places

### Challenges and Resolution: 
- Users with zero tenure months (new signups) required handling via NULLIF to prevent division by zero.
- Some users had very low transaction history, skewing averages.
- CLV values are approximate due to simplified assumptions (e.g., fixed profit margin, only savings considered).
