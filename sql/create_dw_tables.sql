-- Criando Data Warehouse
CREATE SCHEMA IF NOT EXISTS dw;

-- Seller Dimension
CREATE TABLE IF NOT EXISTS dw.dim_seller (
    sk_seller SERIAL NOT NULL,
    seller_unique_id VARCHAR(40),
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(70),
    seller_state CHAR(2),
    CONSTRAINT pkSeller PRIMARY KEY (sk_seller)
);

-- Products Dimension
CREATE TABLE IF NOT EXISTS dw.dim_products (
	sk_product SERIAL NOT NULL,
	product_id VARCHAR(40),
	product_category_name VARCHAR(70),
	product_description_lenght INT,
	product_photos_qty INT,
	CONSTRAINT pkProduct PRIMARY KEY (sk_product)
);
-- Customer Dimension
CREATE TABLE IF NOT EXISTS dw.dim_customer (
	sk_customer SERIAL NOT NULL,
    customer_id VARCHAR(50),
	customer_unique_id VARCHAR(40),
    customer_zip_code_prefix VARCHAR(5),
	customer_city VARCHAR(70),
	customer_state CHAR(2),
	CONSTRAINT pkCustomer PRIMARY KEY (sk_customer)
);

-- Dimension Geolocation
CREATE TABLE IF NOT EXISTS dw.dim_geolocation (
    sk_geolocation SERIAL NOT NULL,
    geolocation_zip_code_prefix VARCHAR(20),
    geolocation_lat REAL,
    geolocation_lng REAL,
    CONSTRAINT pkGeolocation PRIMARY KEY (sk_geolocation)
);

-- Creating data dimension table
CREATE TABLE IF NOT EXISTS dw.dim_date (
	date DATE NOT NULL,
	day INT ,
	week_day VARCHAR(7),
	month INT,
	quarter INT,
	year INT,
	CONSTRAINT date PRIMARY KEY (date)
);

-- Inserting data
INSERT INTO dw.dim_date(date, day, week_day, month, quarter, year)
SELECT date,
       EXTRACT(DAY FROM date) AS day,
	   EXTRACT(dow FROM date) AS week_day,
       EXTRACT(MONTH FROM date) AS month,
       EXTRACT(quarter FROM date) AS year,
	   EXTRACT(year FROM date) AS quarter
FROM (SELECT '2016-09-04'::DATE+ SEQUENCE.DAY AS date
      FROM GENERATE_SERIES (0,2000) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) AS tb
ORDER BY date;

-- Create fact_sales
CREATE TABLE IF NOT EXISTS dw.fact_sales (
	sk_product INT REFERENCES dw.dim_products(sk_product),
    sk_customer INT REFERENCES dw.dim_customer(sk_customer),
    sk_seller INT REFERENCES dw.dim_seller(sk_seller),
    sk_geolocation INT REFERENCES dw.dim_geolocation(sk_geolocation),
    date DATE REFERENCES dw.dim_date(date),   
    order_id VARCHAR(40),
	order_status VARCHAR(30),
    customer_unique_id VARCHAR(40),
    seller_unique_id VARCHAR(40),
    price REAL,
    freight_value REAL,
	quantity_products INTEGER,
    credit_card INTEGER,
    voucher INTEGER,
    debit_card INTEGER,
    boleto INTEGER,
    not_defined INTEGER,
	payment_credit_card INTEGER,
	payment_voucher INTEGER,
	payment_debit_card INTEGER,
	payment_boleto INTEGER,
	payment_not_defined INTEGER,
    review_score INTEGER, 
    delivery_delay INTEGER,
	PRIMARY KEY (date, sk_product, sk_customer, sk_seller, sk_geolocation)
);
