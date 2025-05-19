-- The trx cte calculates the monthly transactions per customer
WITH trx AS (SELECT 
                  s.owner_id, 
                  date_format(s.transaction_date, '%Y-%m') as months,
				   count(*) monthly_trx_counts
             FROM adashi_staging.users_customuser AS u
	     LEFT JOIN adashi_staging.savings_savingsaccount AS s ON u.id = s.owner_id
             WHERE s.transaction_date is not null
	     GROUP BY 1,2),

-- calculating the average monthly transactions of each customer
avg_trx as (SELECT 
                owner_id, 
                avg(monthly_trx_counts) as avg_trx_monthly
            FROM trx
            GROUP BY 1),

-- creating the category based on the average monthly transaction per customer
cat as (SELECT 
	     owner_id,
             avg_trx_monthly,
             case when avg_trx_monthly >= 10 then 'High Frequency'
		  when avg_trx_monthly >= 3 then 'Medium Frequency'
                  when avg_trx_monthly < 3 then 'Low Frequency'
		  end as frequency_category
        FROM avg_trx)

SELECT frequency_category,
count(*) as customer_count,
avg(avg_trx_monthly) as avg_transactions_per_month

FROM cat
GROUP BY frequency_category
