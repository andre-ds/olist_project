-- Dimension Customer
insert into dw.dim_customer (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
select distinct
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
from olist.customer as oltp
where not exists (select
				  customer_unique_id
				  from dw.dim_customer
				  where customer_id = oltp.customer_id and customer_unique_id = oltp.customer_unique_id);