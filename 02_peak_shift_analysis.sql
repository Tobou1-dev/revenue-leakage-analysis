-- ============================================================
-- FILE: 02_peak_shift_analysis.sql
-- PROJECT: Restaurant Revenue Protection Model
-- AUTHOR: Tobou Egbekun — Analytics Engineer
-- DESCRIPTION: Identifies the Saturday peak shift as the primary
--              source of revenue leakage. Compares actual vs
--              potential revenue by day type and shift type.
--              This query surfaces the ₦13.3M monthly finding.
-- ============================================================

SELECT
    c.Day_Type,
    c.Date,
    f.Is_Peak_Hour,

    -- Order volume
    COUNT(f.Order_ID)                               AS Total_Orders,

    -- Revenue metrics
    ROUND(SUM(f.Scenario_A_Revenue), 2)             AS Total_Actual_Revenue,
    ROUND(SUM(f.Scenario_B_Revenue), 2)             AS Total_Potential_Revenue,
    ROUND(SUM(f.Scenario_B_Revenue
            - f.Scenario_A_Revenue), 2)             AS Total_Revenue_Leaked,

    -- Average wait time
    ROUND(AVG(f.Total_Wait_Mins), 1)                AS Avg_Wait_Mins,

    -- Orders by risk category
    COUNTIF(
        CASE
            WHEN f.Total_Wait_Mins > 35 THEN 'Critical Risk'
            WHEN f.Total_Wait_Mins > 20 THEN 'High Risk'
            ELSE 'Safe'
        END = 'Critical Risk'
    )                                               AS Critical_Risk_Orders,

    COUNTIF(
        CASE
            WHEN f.Total_Wait_Mins > 35 THEN 'Critical Risk'
            WHEN f.Total_Wait_Mins > 20 THEN 'High Risk'
            ELSE 'Safe'
        END = 'High Risk'
    )                                               AS High_Risk_Orders,

    -- Revenue recovery rate
    ROUND(
        SAFE_DIVIDE(
            SUM(f.Scenario_A_Revenue),
            SUM(f.Scenario_B_Revenue)
        ) * 100, 2
    )                                               AS Revenue_Recovery_Pct

FROM `restaurant-blueprint.data.fact_simulation_orders` AS f
JOIN `restaurant-blueprint.data.calendar` AS c
    ON f.Date = c.Date

GROUP BY
    c.Day_Type,
    c.Date,
    f.Is_Peak_Hour

ORDER BY
    Total_Revenue_Leaked DESC;
