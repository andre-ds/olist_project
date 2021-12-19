-- Dimension Seller
insert into dw.dim_seller (seller_unique_id, seller_zip_code_prefix, seller_city, seller_state)
select
	seller_unique_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
from olist.seller as oltp
where not exists (select
				 seller_unique_id
				 from dw.dim_seller
				 where seller_unique_id = oltp.seller_unique_id);