-- ==========================================
-- STEP 1: DATA CLEANING
-- Goal: Remove null customer IDs, returns, and pricing errors to create a clean base table.
-- ==========================================

CREATE TABLE CleanRetail AS
SELECT * 
FROM online_retail_II
WHERE "Customer ID" IS NOT NULL 
  AND Quantity > 0 
  AND Price > 0;


-- ==========================================
-- STEP 2: BASE RFM SCORING
-- Goal: Calculate raw Recency, Frequency, and Monetary values, then use window functions to assign 1-4 quartile scores.
-- ==========================================

WITH RFM_Base AS (
    SELECT 
        "Customer ID",
        MAX(InvoiceDate) AS Last_Purchase_Date,
        COUNT(DISTINCT Invoice) AS Frequency,
        SUM(Quantity * Price) AS Monetary_Value
    FROM CleanRetail
    GROUP BY "Customer ID"
)
SELECT 
    "Customer ID",
    Last_Purchase_Date,
    Frequency,
    Monetary_Value,
    NTILE(4) OVER (ORDER BY Last_Purchase_Date ASC) AS R_Score,
    NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
    NTILE(4) OVER (ORDER BY Monetary_Value ASC) AS M_Score
FROM RFM_Base;


-- ==========================================
-- STEP 3: FINAL CUSTOMER SEGMENTATION
-- Goal: Stack CTEs to apply business logic, converting numerical RFM scores into plain-English marketing categories for Power BI.
-- ==========================================

WITH RFM_Base AS (
    SELECT 
        "Customer ID",
        MAX(InvoiceDate) AS Last_Purchase_Date,
        COUNT(DISTINCT Invoice) AS Frequency,
        SUM(Quantity * Price) AS Monetary_Value
    FROM CleanRetail
    GROUP BY "Customer ID"
),
RFM_Scores AS (
    SELECT 
        "Customer ID",
        NTILE(4) OVER (ORDER BY Last_Purchase_Date ASC) AS R_Score,
        NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY Monetary_Value ASC) AS M_Score
    FROM RFM_Base
)
SELECT 
    "Customer ID",
    R_Score || F_Score || M_Score AS RFM_Cell,
    CASE 
        WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score = 1 AND F_Score >= 3 AND M_Score >= 3 THEN 'At Risk / Can''t Lose Them'
        WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Hibernating / Lost'
        ELSE 'Potential / Regulars'
    END AS Customer_Segment
FROM RFM_Scores
ORDER BY RFM_Cell DESC;