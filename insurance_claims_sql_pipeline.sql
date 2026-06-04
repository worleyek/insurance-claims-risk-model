/* =========================================================
   PROJECT: Auto Insurance Claims Analytics Pipeline
   AUTHOR: Emily Worley
   TOOLING: PostgreSQL, SQL
   DATE: May 2026

   DESCRIPTION:
   End-to-end analytics pipeline for auto insurance claims data.
   Includes data cleaning, validation, feature engineering,
   and analytical modeling preparation for Python + Power BI.

   OBJECTIVE:
   - Analyze drivers of insurance claim severity
   - Segment customers by risk and income level
   - Prepare dataset for predictive modeling and BI dashboards
   ========================================================= */

/* =========================================================
   CLEAN START
   ========================================================= */

DROP VIEW IF EXISTS claims_dashboard_view;
DROP VIEW IF EXISTS income_bands;
DROP VIEW IF EXISTS income_quartiles;

DROP TABLE IF EXISTS claims_final;
DROP TABLE IF EXISTS claims_clean;

/* =========================================================
   DATA EXPLORATION
   ========================================================= */

-- preview first 10 rows of dataset
SELECT *
FROM raw_claims
LIMIT 10;

-- view total number of rows
SELECT COUNT(*)
FROM raw_claims; 

-- check for weird values for claim amount
SELECT MIN("Total Claim Amount"), MAX("Total Claim Amount")
FROM raw_claims;

-- check for weird values for income amount
SELECT MIN("Income"), MAX("Income")
FROM raw_claims;

-- check income distribution after noticing minimum of 0
SELECT
    MIN("Income"),
    MAX("Income"),
    AVG("Income")
FROM raw_claims;

-- view how many entries have income of 0
SELECT COUNT(*)
FROM raw_claims
WHERE "Income" = 0;

/* =========================================================
   DATA CLEANING & VALIDATION
   ========================================================= */

-- check for missing values
SELECT
    COUNT(*) AS total_rows,
    COUNT("State") AS state_count,
    COUNT("Total Claim Amount") AS claim_count,
    COUNT("Income") AS income_count
FROM raw_claims;

-- create a clean working table
CREATE TABLE claims_clean AS
SELECT *
FROM raw_claims;

-- change income = 0 values to null since it likely indicates missingness
UPDATE claims_clean
SET "Income" = NULL
WHERE "Income" = 0;

-- re-check distribution
SELECT
    MIN("Income"),
    MAX("Income"),
    AVG("Income")
FROM claims_clean;

-- check for duplicates
SELECT "Customer", COUNT(*)
FROM claims_clean
GROUP BY "Customer"
HAVING COUNT(*) > 1;

-- validated outliers

-- check for impossible values
SELECT *
FROM claims_clean
WHERE "Months Since Policy Inception" < 0; -- returned 0 rows

SELECT *
FROM claims_clean
WHERE "Number of Policies" < 0; -- returned 0 rows

-- check complaint range (should be 0,1,2,...)
SELECT DISTINCT "Number of Open Complaints"
FROM claims_clean
ORDER BY 1;

/* =========================================================
   FEATURE ENGINEERING
   ========================================================= */

-- create quartile view
CREATE VIEW income_quartiles AS
SELECT
    "Customer",
    "Income",
    NTILE(4) OVER (ORDER BY "Income") AS income_quartile
FROM claims_clean
WHERE "Income" IS NOT NULL;

-- verify quartile functionality works
SELECT income_quartile, COUNT(*) 
FROM income_quartiles
GROUP BY income_quartile
ORDER BY income_quartile;

-- apply income labels
CREATE VIEW income_bands AS
WITH ranked AS (
    SELECT
        "Customer",
        "Income",
        NTILE(4) OVER (ORDER BY "Income") AS income_quartile
    FROM claims_clean
    WHERE "Income" IS NOT NULL
)
SELECT
    *,
    CASE
        WHEN income_quartile = 1 THEN 'Low'
        WHEN income_quartile = 2 THEN 'Lower-Middle'
        WHEN income_quartile = 3 THEN 'Upper-Middle'
        WHEN income_quartile = 4 THEN 'High'
    END AS income_band
FROM ranked;

/* =========================================================
   DATA ANALYSIS
   ========================================================= */

-- claim severity by income band
SELECT
    income_band,
    COUNT(*) AS customers,
    AVG("Total Claim Amount") AS avg_claim
FROM income_bands b
JOIN claims_clean c
    ON b."Customer" = c."Customer"
GROUP BY income_band
ORDER BY avg_claim DESC;

-- risk distribution by income band
SELECT
    income_band,
    AVG("Total Claim Amount") AS avg_claim,
    AVG("Number of Open Complaints") AS avg_complaints
FROM income_bands b
JOIN claims_clean c
    ON b."Customer" = c."Customer"
GROUP BY income_band;

-- loss risk by policy type
SELECT
    "Policy Type",
    COUNT(*) AS policies,
    AVG("Total Claim Amount") AS avg_claim
FROM claims_clean
GROUP BY "Policy Type"
ORDER BY avg_claim DESC;

-- vehicle risk analysis
SELECT
    "Vehicle Class",
    COUNT(*) AS policies,
    AVG("Total Claim Amount") AS avg_claim
FROM claims_clean
GROUP BY "Vehicle Class"
ORDER BY avg_claim DESC;

-- customer lifetime value vs claim loss
WITH clv_ranked AS (
    SELECT
        "Customer",
        "Customer Lifetime Value",
        "Total Claim Amount",
        NTILE(4) OVER (
            ORDER BY "Customer Lifetime Value"
        ) AS clv_quartile
    FROM claims_clean
)

SELECT
    clv_quartile,
    COUNT(*) AS customers,
    AVG("Total Claim Amount") AS avg_claim
FROM clv_ranked
GROUP BY clv_quartile
ORDER BY clv_quartile;

-- renewal channel performance
SELECT
    "Sales Channel",
    COUNT(*) AS policies,
    AVG("Total Claim Amount") AS avg_claim
FROM claims_clean
GROUP BY "Sales Channel"
ORDER BY avg_claim DESC;

-- marital status risk segmentation
SELECT
    "Marital Status",
    AVG("Total Claim Amount") AS avg_claim,
    AVG("Number of Open Complaints") AS avg_complaints
FROM claims_clean
GROUP BY "Marital Status";

/* =========================================================
   FINAL CLAIMS TABLE
   ========================================================= */

-- create final claims table with standardized column names
DROP TABLE IF EXISTS claims_final;

CREATE TABLE claims_final AS
SELECT
    "Customer" AS customer_id,
    "State" AS state,
    "Customer Lifetime Value" AS customer_lifetime_value,
    "Response" AS response,
    "Coverage" AS coverage,
    "Education" AS education,
    "Effective To Date" AS effective_to_date,
    "Employment Status" AS employment_status,
    "Gender" AS gender,
    "Income" AS income,
    "Location" AS location,
    "Marital Status" AS marital_status,
    "Monthly Premium Auto" AS monthly_premium_auto,
    "Months Since Last Claim" AS months_since_last_claim,
    "Months Since Policy Inception" AS months_since_policy_inception,
    "Number of Open Complaints" AS number_of_open_complaints,
    "Number of Policies" AS number_of_policies,
    "Policy Type" AS policy_type,
    "Policy" AS policy_name,
    "Renew Offer Type" AS renew_offer_type,
    "Sales Channel" AS sales_channel,
    "Total Claim Amount" AS total_claim_amount,
    "Vehicle Class" AS vehicle_class,
    "Vehicle Size" AS vehicle_size
FROM claims_clean;

-- remove leading/trailing spaces
UPDATE claims_final
SET
    state = TRIM(state),
    coverage = TRIM(coverage),
    education = TRIM(education),
    employment_status = TRIM(employment_status),
    location = TRIM(location),
    marital_status = TRIM(marital_status),
    policy_type = TRIM(policy_type),
    policy_name = TRIM(policy_name),
    sales_channel = TRIM(sales_channel),
    vehicle_class = TRIM(vehicle_class),
    vehicle_size = TRIM(vehicle_size);

-- date standardization
SELECT effective_to_date
FROM claims_final
LIMIT 5;

ALTER TABLE claims_final
ALTER COLUMN effective_to_date
TYPE DATE
USING TO_DATE(effective_to_date, 'MM/DD/YYYY');

-- add primary key
ALTER TABLE claims_final
ADD PRIMARY KEY (customer_id);

-- add income bands
ALTER TABLE claims_final
ADD COLUMN income_band TEXT;

UPDATE claims_final cf
SET income_band = ib.income_band
FROM income_bands ib
WHERE cf.customer_id = ib."Customer";

-- add claim severity
ALTER TABLE claims_final
ADD COLUMN claim_severity TEXT;

UPDATE claims_final
SET claim_severity =
CASE
    WHEN total_claim_amount < 500 THEN 'Low'
    WHEN total_claim_amount BETWEEN 500 AND 2000 THEN 'Medium'
    ELSE 'High'
END;

-- claim severity distribution
SELECT
    claim_severity,
    COUNT(*) AS customers,
    AVG(total_claim_amount) AS avg_claim
FROM claims_final
GROUP BY claim_severity;

-- add complaint risk
ALTER TABLE claims_final
ADD COLUMN complaint_risk TEXT;

UPDATE claims_final
SET complaint_risk =
CASE
    WHEN number_of_open_complaints = 0 THEN 'None'
    WHEN number_of_open_complaints BETWEEN 1 AND 2 THEN 'Low'
    ELSE 'High'
END;

-- add risk score
ALTER TABLE claims_final
ADD COLUMN risk_score INTEGER;

UPDATE claims_final
SET risk_score =
(
    CASE WHEN income < 30000 THEN 2 ELSE 0 END +
    CASE WHEN number_of_open_complaints > 0 THEN 2 ELSE 0 END +
    CASE WHEN total_claim_amount > 1500 THEN 3 ELSE 0 END
);

-- add missing income flag
ALTER TABLE claims_final
ADD COLUMN missing_income_flag INTEGER;

UPDATE claims_final
SET missing_income_flag =
CASE
    WHEN income IS NULL THEN 1
    ELSE 0
END;

/*
-- create Power BI view
CREATE VIEW claims_dashboard_view AS
SELECT
    customer_id,
    state,
    gender,
    marital_status,
    income,
    income_band,
    customer_lifetime_value,
    monthly_premium_auto,
    total_claim_amount,
    claim_severity,
    complaint_risk,
    risk_score,
    vehicle_class,
    vehicle_size,
    policy_type,
    sales_channel
FROM claims_final;
*/

/* =========================================================
   FINAL VALIDATION CHECKS
   ========================================================= */

-- verify final row count
SELECT COUNT(*)
FROM claims_final;

-- verify income band distribution
SELECT
    income_band,
    COUNT(*) AS customers
FROM claims_final
GROUP BY income_band
ORDER BY customers DESC;

-- verify claim severity distribution
SELECT
    claim_severity,
    COUNT(*) AS customers
FROM claims_final
GROUP BY claim_severity
ORDER BY customers DESC;

-- verify complaint risk distribution
SELECT
    complaint_risk,
    COUNT(*) AS customers
FROM claims_final
GROUP BY complaint_risk
ORDER BY customers DESC;

-- verify risk score distribution
SELECT
    risk_score,
    COUNT(*) AS customers
FROM claims_final
GROUP BY risk_score
ORDER BY risk_score;

-- add indices
CREATE INDEX idx_claims_state
ON claims_final(state);

CREATE INDEX idx_claims_income_band
ON claims_final(income_band);

CREATE INDEX idx_claims_policy_type
ON claims_final(policy_type);

/* =========================================================
   VALIDATION CHECKS FOR LARGE DATASET
   ========================================================= */

-- verify row count for large dataset
SELECT COUNT(*)
FROM claims_large;

-- get expansion factor
SELECT
    ROUND(
        COUNT(*)::numeric /
        (SELECT COUNT(*) FROM claims_final),
        2
    ) AS expansion_factor
FROM claims_large;

-- verify unique customer IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM claims_large;

-- compare distributions
SELECT
    AVG(income) AS avg_income,
    AVG(total_claim_amount) AS avg_claim,
    AVG(customer_lifetime_value) AS avg_clv
FROM claims_final;

SELECT
    AVG(income) AS avg_income,
    AVG(total_claim_amount) AS avg_claim,
    AVG(customer_lifetime_value) AS avg_clv
FROM claims_large;

-- check claim severity distribution
SELECT
    claim_severity,
    COUNT(*) AS records
FROM claims_large
GROUP BY claim_severity
ORDER BY records DESC;

-- check for nulls
SELECT
    COUNT(*) AS total_rows,
    COUNT(income) AS income_populated,
    COUNT(total_claim_amount) AS claims_populated
FROM claims_large;

-- multi-dimensional risk analysis
SELECT
    policy_type,
    vehicle_class,
    COUNT(*) AS policies,
    AVG(total_claim_amount) AS avg_claim
FROM claims_large
GROUP BY
    policy_type,
    vehicle_class
ORDER BY policies DESC;

-- loss ratio analysis
SELECT
    policy_type,
    vehicle_class,
    COUNT(*) AS policies,
    AVG(total_claim_amount) AS avg_loss,
    AVG(monthly_premium_auto) AS avg_premium,
    AVG(total_claim_amount) / NULLIF(AVG(monthly_premium_auto), 0) AS loss_ratio
FROM claims_large
GROUP BY policy_type, vehicle_class
ORDER BY loss_ratio DESC;

-- high-risk customer concentration
SELECT
    state,
    COUNT(*) AS customers,
    AVG(total_claim_amount) AS avg_claim
FROM claims_large
WHERE total_claim_amount > 1500
GROUP BY state
ORDER BY avg_claim DESC;

-- income vs claim risk relationship
SELECT
    income_band,
    COUNT(*) AS customers,
    AVG(total_claim_amount) AS avg_claim
FROM claims_large
GROUP BY income_band
ORDER BY avg_claim DESC;

-- channel performance
SELECT
    sales_channel,
    COUNT(*) AS policies,
    AVG(total_claim_amount) AS avg_claim,
    AVG(risk_score) AS avg_risk_score
FROM claims_large
GROUP BY sales_channel
ORDER BY avg_claim DESC;