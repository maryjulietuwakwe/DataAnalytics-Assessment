# DataAnalytics-Assessment
This document represents detailed explanations for each SQL task included in the assessment. It highlights the approach used, reasoning, and challenge(s) encountered.

---

# Task 1: Customers with Funded Savings and Investment Plans

**Problem:**
Identify customers with at least one funded savings plan and one funded investment plan, sorted by total deposits.

**Approach:**  
- I created a CTE (funded_plans) to join (users_customuser), (plans_plan), and (savings_savingsaccount).
- Filtered out plans where *confirmed_amount* is either null or zero.
- Used a conditional aggregation *COUNT(DISTINCT CASE...)* to count distinct funded savings and investment plans per user.
- Applied a final filter with *HAVING* to ensure each user has at least one of each.
- The Results were ordered by *total_deposits* in descending order.

**Challenges:**  
- Understanding plan types (is_regular_savings, is_a_fund) and counting them correctly. The HINT field provided in the assessment gave an understanding of the plan types.
- Avoiding duplicate plan counts, and this was resolved with the *COUNT(DISTINCT ...)*.


---


# Task 2. Transaction Frequency Categorization

**Problem:**
Classify customers by their **average number of transactions per month**:
- High Frequency: ≥10 transactions/month  
- Medium Frequency: 3–9 transactions/month  
- Low Frequency: ≤2 transactions/month

**Approach:**
- I created a CTE (trx) that calculated monthly transaction counts per customer.
- Another CTE (avg_trx) that computed the average monthly transactions.
- A final CTE (cat) classifying each user by using a CASE statement.
- A SELECT aggregating the number of customers and average transaction volume for each category.

**Challenges:**
- Had to think of a way to collapse the frequency category, and the average on average was used.
- Handled users with low or irregular activity by ensuring averages were calculated over actual months with activity.


---


# Task 3. Inactive Accounts (No Transactions in the Last 1 Year)

**Problem:**
Find all active savings or investment accounts with no transactions in the last 365 days, including the last transaction date and the number of inactivity in days.

**Approach:**
- Joined savings accounts to plans to identify the plan type.
- Selected only savings or investment plans based on flags (is_regular_savings, is_a_fund).
- Calculated the last transaction date per plan using MAX(transaction_date).
- Filtered results where *confirmed_amount* is NULL or less than 1, and the last transaction is older than 365 days.
- Returned key fields, including inactivity days, which were calculated with the DATEDIFF.

**Challenges:**
- Ensuring transaction inactivity logic matched the task exactly. I initially missed that date filtering should occur after aggregation, but fixed it using the HAVING keyword.


---


# Task 4. Customer Lifetime Value (CLV) Estimation

**Problem:**
Estimate Customer Lifetime Value CLV based on account tenure and transaction behavior using the formula:  
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

**Approach:**
- A CTE customer_info to calculate the account tenure in months by using TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE).
- A CTE trx that calculates aggregated total transactions and average inflow value per customer.
- Joined both CTEs and applied the CLV formula.
- Used NULLIF(..., 0) to avoid division by zero errors for new accounts.
- Ordered the final results by estimated_clv in descending order.

**Challenges:**
- Handling customers with tenure of 0 months required special care to avoid divide-by-zero errors.
- Used inner join to focus only on active transacting users as requested.


---


# Take-Aways

- using CTEs made complex queries more readable and maintainable.
- Importance of (WHERE vs HAVING) when working with grouped data.
- Clean handling of edge cases like zero tenure or NULL values ensures accurate and stable results.
- Validating assumptions is critical for correct analysis.


---


# Summary

Each query was structured to meet the specified business requirement, with attention to:
- Accuracy in data filtering and aggregation
- Efficiency through the use of CTEs and joins
- Readability and maintainability
- Handling of edge cases like nulls, zero values, and recent signups


---


# Author

**Mary-Juliet Uwakwe**



