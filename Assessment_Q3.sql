use adashi_staging;

SELECT 
     p.id as plan_id, 
     p.owner_id, 
     case when is_regular_savings = 1 then 'Savings'
		  when is_a_fund = 1 then 'Investment'
          end as type,
     cast(max(transaction_date) as date) as last_transaction_date,
     datediff(curdate(), max(transaction_date)) as inactivity_days

FROM plans_plan as p
LEFT JOIN savings_savingsaccount as s on p.id = s.plan_id

WHERE (is_regular_savings = 1 or is_a_fund = 1)
AND (confirmed_amount < 1 or confirmed_amount is null)

GROUP BY  1,2
HAVING DATEDIFF(CURRENT_DATE, last_transaction_date) <= 365
ORDER BY 1,2;

