CREATE TABLE mortgage_transactions (
       id INTEGER PRIMARY KEY,
       property_address text,
       buyer VARCHAR(200),
       seller VARCHAR(200),
       transaction_date DATE DISTKEY,
       property_id INTEGER SORTKEY,
       property_type VARCHAR(10),
       transaction_amount INTEGER,
       loan_amount INTEGER,
       lender VARCHAR(200),
       sqft INTEGER,
       year_built SMALLINT
);


UPDATE mortgage_transactions SET property_address = NULL WHERE property_address = '';

-- Store
CREATE VIEW mortgage_lender AS
SELECT
 lender, EXTRACT('year' FROM transaction_date) AS year,
 COUNT(1) AS total_loan_count,
 SUM(loan_amount) AS total_loan_amount,
 MEDIAN(loan_amount) AS median_loan_amount
FROM mortgage_transactions
WHERE
 lender IS NOT NULL
 AND loan_amount > 0
 AND lender != ''
GROUP BY 1, 2


-- 2014 Competitors (120)

CREATE VIEW lendinghome_competitor_2014 AS
SELECT DISTINCT lender
FROM mortgage_lender
WHERE
 year = 2014
 AND total_loan_count > 100
 AND total_loan_count < 200
 AND total_loan_amount > 3e7
 AND total_loan_amount < 5e7
 AND lender NOT ILIKE '%lendinghome%'
