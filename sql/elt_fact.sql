-- Building Fact
insert into dw.fact_sales (date, sk_customer, sk_seller, sk_product, sk_geolocation,
	order_id, order_status, customer_unique_id, seller_unique_id, price, freight_value,
	quantity_products, credit_card, voucher, debit_card, boleto, not_defined,
	payment_credit_card, payment_voucher, payment_debit_card, payment_boleto, 
	payment_not_defined, review_score, delivery_delay)

select
	date(o.order_purchase_timestamp) as date,
	sc.sk_customer,
	sl.sk_seller,
	sp.sk_product,
	sg.sk_geolocation,
	o.order_id,
	o.order_status,
	sc.customer_unique_id,
	oi.seller_unique_id,
	oi.price,
	oi.freight_value,
	oi.quantity_products,
	op.credit_card,
	op.voucher,
	op.debit_card,
	op.boleto,
	op.not_defined,
	op.payment_credit_card,
	op.payment_voucher,
	op.payment_debit_card,
	op.payment_boleto,
	op.payment_not_defined,
	sr.review_score,
	o.order_delivered_customer_date::DATE - o.order_estimated_delivery_date::DATE as delivery_delay
from olist.orders as o
left join (select
		  customer_id,
		  customer_unique_id,
		  sk_customer
		  from dw.dim_customer
		  ) as sc on sc.customer_id = o.customer_id
inner join (
	select
		oi.order_id,
		oi.product_id,
		oi.seller_unique_id,
		count(oi.product_id) as quantity_products,
		max(oi.price) as price,
		max(oi.freight_value) as freight_value
	from olist.order_items as oi
	group by oi.order_id, oi.product_id, oi.seller_unique_id) as oi on oi.order_id = o.order_id
left join (
	select
		  sk_seller,
		  seller_unique_id
		  from dw.dim_seller) as sl on sl.seller_unique_id = oi.seller_unique_id
left join (select
		  sk_product,
		  product_id
		  from dw.dim_products) as sp on sp.product_id = oi.product_id
left join (
	select
		order_id,
		max(payment_credit_card) as payment_credit_card,
		max(payment_voucher) as payment_voucher,
		max(payment_debit_card) as payment_debit_card,
		max(payment_boleto) as payment_boleto,
		max(payment_not_defined) as payment_not_defined,
		max(credit_card) as credit_card,
		max(voucher) as voucher,
		max(debit_card) as debit_card,
		max(boleto) as boleto,
		max(not_defined) as not_defined
		from (select
			order_id,
			case when payment_type = 'credit_card' then 1 else 0 end as credit_card,
			case when payment_type = 'credit_card' then payment_installments else 0 end as payment_credit_card, 
			case when payment_type = 'voucher' then 1 else 0 end as voucher,
			case when payment_type = 'voucher' then payment_installments else 0 end as payment_voucher,
			case when payment_type = 'debit_card' then 1 else 0 end as debit_card,
			case when payment_type = 'debit_card' then payment_installments else 0 end as payment_debit_card,
			case when payment_type = 'boleto' then 1 else 0 end as boleto,
			case when payment_type = 'boleto' then payment_installments else 0 end as payment_boleto,
			case when payment_type = 'not_defined' then 1 else 0 end as not_defined,
			case when payment_type = 'not_defined' then payment_installments else 0 end as payment_not_defined
			from olist.order_payment) as pt
		group by order_id) as op on op.order_id = o.order_id
left join (
	select
	order_id,
	max(review_score) as review_score
	from olist.review
	group by order_id) as sr on sr.order_id = o.order_id
inner join(
	select
		sg.sk_geolocation,
		c.customer_unique_id
	from (
		select distinct
		customer_unique_id,
		first_value(customer_zip_code_prefix) over(partition by customer_unique_id order by customer_id desc) as customer_zip_code_prefix
		from olist.customer) as c
	inner join dw.dim_geolocation as sg on sg.geolocation_zip_code_prefix = c.customer_zip_code_prefix
) as sg on sg.customer_unique_id = sc.customer_unique_id
where not exists (select
				  sk_seller,
				  sk_product,
				  sk_geolocation,
				  date
				  from dw.fact_sales where sk_customer = sk_customer
				  and sk_seller = sk_seller
				  and sk_product = sk_product
				  and sk_geolocation = sk_geolocation
				 and date = date)