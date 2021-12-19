
CREATE SCHEMA IF NOT EXISTS olist

CREATE TABLE IF NOT EXISTS olist.geolocation (
	geolocation_zip_code_prefix VARCHAR(20),
	geolocation_lat REAL,
	geolocation_lng REAL,
	geolocation_city VARCHAR(50),
	geolocation_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS olist.customer (
	customer_id VARCHAR(50),
	customer_unique_id VARCHAR(50) ,
	customer_zip_code_prefix VARCHAR(20),
	customer_city VARCHAR(50),
	customer_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS olist.seller (
	seller_unique_id VARCHAR(50) PRIMARY KEY,
	seller_zip_code_prefix VARCHAR(20),
	seller_city VARCHAR(100),
	seller_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS olist.products (
	product_id VARCHAR(50) PRIMARY KEY,
	product_category_name VARCHAR(200),
	product_name_lenght integer,
	product_description_lenght integer,
	product_photos_qty integer,
	product_weight_g integer,
	product_length_cm integer,
	product_height_cm integer,
	product_width_cm integer);

CREATE TABLE IF NOT EXISTS olist.orders (
	order_id VARCHAR(50) PRIMARY KEY,
	customer_id VARCHAR(50),
	order_status VARCHAR(30),
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date date);

CREATE TABLE IF NOT EXISTS olist.order_payment (
	order_id VARCHAR(50) REFERENCES olist.orders(order_id),
	payment_sequential integer,
	payment_type VARCHAR(20),
	payment_installments integer,
	payment_value real
);

CREATE TABLE IF NOT EXISTS olist.order_items (
	order_id VARCHAR(50),
	order_item_id integer,
	product_id VARCHAR(50) REFERENCES olist.products(product_id),
	seller_unique_id VARCHAR(50) REFERENCES olist.seller(seller_unique_id),
	shipping_limit_date timestamp,
	price real,
	freight_value real);

CREATE TABLE IF NOT EXISTS olist.review (
	review_id VARCHAR(50),
	order_id VARCHAR(50) REFERENCES olist.orders(order_id),
	review_score integer,
	review_comment_title VARCHAR(120),
	review_comment_message TEXT,
	review_creation_date date,
	review_answer_timestamp timestamp
);


