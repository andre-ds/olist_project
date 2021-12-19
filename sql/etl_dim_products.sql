-- Dimension Products
insert into dw.dim_products (product_id, product_category_name, product_description_lenght, product_photos_qty)
select
	product_id,
	product_category_name,
	product_description_lenght,
	product_photos_qty
from olist.products as oltp
where not exists (select
				 product_id
				 from dw.dim_products where product_id = oltp.product_id);