-- Dimension Geolocation
insert into dw.dim_geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng)

select
	oltp.geolocation_zip_code_prefix,
	oltp.geolocation_lat,
	oltp.geolocation_lng
from (
	select
	geolocation_zip_code_prefix,
	max(geolocation_lat) as geolocation_lat,
	max(geolocation_lng) as geolocation_lng
	from olist.geolocation
	group by geolocation_zip_code_prefix
) as oltp
where not exists (select
				  geolocation_zip_code_prefix
				  from dw.dim_geolocation where geolocation_zip_code_prefix = oltp.geolocation_zip_code_prefix);