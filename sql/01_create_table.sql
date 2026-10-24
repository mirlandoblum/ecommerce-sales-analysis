-- Run once in the ecommerce_analysis database before importing the CSV.
-- In pgAdmin: right-click public.sales > Import/Export Data > Import;
-- select data/orders_anonymized.csv; Format CSV; Header = Yes; Encoding UTF8.
CREATE TABLE IF NOT EXISTS public.sales (
    order_no INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    order_month CHAR(7) NOT NULL,
    order_state VARCHAR(30) NOT NULL,
    quantity INTEGER,
    total_amount_usd NUMERIC(12, 2),
    feedback_rating VARCHAR(30)
);
