WITH funded_plans AS (
    SELECT 
        u.id AS user_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        p.id AS plan_id,
        p.is_regular_savings,
        p.is_a_fund,
        s.confirmed_amount
    FROM adashi_staging.users_customuser u
    INNER JOIN adashi_staging.plans_plan p ON u.id = p.owner_id
    INNER JOIN adashi_staging.savings_savingsaccount s ON p.id = s.plan_id
    WHERE (s.confirmed_amount IS NOT NULL and s.confirmed_amount > 0) -- a condition that takes out 0 or null amounts
)

SELECT 
    f.user_id AS owner_id,
    f.name,
    COUNT(DISTINCT CASE WHEN f.is_regular_savings = 1 THEN f.plan_id END) AS savings_count, -- This is to count the distinct funded savings plans
    COUNT(DISTINCT CASE WHEN f.is_a_fund = 1 THEN f.plan_id END) AS investment_count,    -- This counts the distinct funded investment plans
    ROUND(SUM(f.confirmed_amount), 2) AS total_deposits     -- It rounds ups the total deposits from only the funded plans

FROM funded_plans f
GROUP BY f.user_id, f.name

HAVING savings_count >= 1 AND investment_count >= 1 -- Meets the condition of at least 1 savings plan and 1 investment plan

ORDER BY total_deposits DESC;
