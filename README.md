# E-Commerce Customer Segmentation (RFM Analysis)

## Business Problem
The marketing team needed a way to identify top-tier customers for loyalty rewards and "at-risk" customers for targeted re-engagement campaigns. 

## Solution
I analyzed over 500,000 real retail transactions using SQL to build an RFM (Recency, Frequency, Monetary) model. I scored customers from 1-4 across all three metrics and applied business logic to categorize them into actionable segments. Finally, I exported this data to Power BI to build an interactive dashboard for stakeholders.

## Key Insights
* Analyzed 541,909 rows of raw data, cleaning out returns and missing records.
* Segmented 4,338 unique customers.
* Discovered that the largest segment falls into the "Hibernating / Lost" category, highlighting a massive opportunity for a win-back marketing campaign.
* Isolated top "Champions" (score 444) who drive the most revenue.

## Tools Used
* **SQL:** Data cleaning, Common Table Expressions (CTEs), Window Functions (`NTILE`), and `CASE WHEN` statements.
* **Power BI:** Data visualization and interactive filtering.
