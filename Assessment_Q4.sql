-- cte to get the tenure month needed for the CLV calculation
with customer_info as (SELECT 
			    id as customer_id,
			   concat(first_name, ' ', last_name) as name,
                           date_joined,
			    timestampdiff(month, date_joined, current_date) as tenure_months -- months since signup: To get this, I used the date_joined column of the users table
			FROM adashi_staging.users_customuser),

-- cte for total and average transactions per customer	
trx as (SELECT  
             owner_id as customer_id, 
             count(*) as total_transactions, -- transaction volume
             avg(confirmed_amount) as avg_transactions
        FROM adashi_staging.savings_savingsaccount
        WHERE confirmed_amount is not null and confirmed_amount > 0 -- since this field is recognised as the inflows, this condition excludes the non-values
        GROUP BY 1)

SELECT 
    c.customer_id,
    c.name,
    c.tenure_months,
    t.total_transactions,
    (t.total_transactions / NULLIF(c.tenure_months, 0)) * 12 * (0.001 * t.avg_transactions)  AS estimated_clv

FROM customer_info c
INNER JOIN trx t ON c.customer_id = t.customer_id -- Inner join was used to focus on only customers that have done transactions

ORDER BY estimated_clv DESC;
