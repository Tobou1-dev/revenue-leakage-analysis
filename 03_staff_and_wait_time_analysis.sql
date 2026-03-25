-- ============================================================
-- FILE: 03_staff_and_wait_time_analysis.sql
-- PROJECT: Restaurant Revenue Protection Model
-- AUTHOR: Tobou Egbekun — Analytics Engineer
-- DESCRIPTION: Analyzes revenue leakage by staff member and
--              wait time threshold to prove the problem is
--              process-driven, not people-driven. Also joins
--              menu data to identify which items contribute
--              most to wait time friction.
-- ============================================================

-- ── PART 1: Staff-Level Revenue Analysis ───────────────────────
-- Tests whether revenue leakage is consistent across all staff
-- A consistent pattern proves a process problem, not a people problem

SELECT
    f.Staff_Name,

    -- Order volume per staff member
    COUNT(f.Order_ID)                               AS Total_Orders_Handled,

    -- Revenue metrics
    ROUND(SUM(f.Scenario_A_Revenue), 2)             AS Actual_Revenue_Generated,
    ROUND(SUM(f.Scenario_B_Revenue), 2)             AS Potential_Revenue,
    ROUND(SUM(f.Scenario_B_Revenue
            - f.Scenario_A_Revenue), 2)             AS Revenue_Lost,

    -- Average wait time per staff member
    ROUND(AVG(f.Total_Wait_Mins), 1)                AS Avg_Wait_Mins,

    -- Percentage of orders exceeding the 35-minute cliff
    ROUND(
        SAFE_DIVIDE(
            COUNT(CASE WHEN f.Total_Wait_Mins > 35
                  THEN f.Order_ID END),
            COUNT(f.Order_ID)
        ) * 100, 2
    )                                               AS Pct_Orders_Over_35_Mins,

    -- Revenue recovery rate per staff member
    ROUND(
        SAFE_DIVIDE(
            SUM(f.Scenario_A_Revenue),
            SUM(f.Scenario_B_Revenue)
        ) * 100, 2
    )                                               AS Revenue_Recovery_Pct

FROM `restaurant-blueprint.data.fact_simulation_orders` AS f

GROUP BY f.Staff_Name
ORDER BY Revenue_Lost DESC;


-- ── PART 2: Wait Time Threshold Analysis ──────────────────────
-- Identifies the 35-minute cliff — the point of no return
-- where customer abandonment probability rises 80%

SELECT
    -- Group orders into wait time buckets
    CASE
        WHEN f.Total_Wait_Mins <= 15 THEN '0-15 mins'
        WHEN f.Total_Wait_Mins <= 20 THEN '16-20 mins'
        WHEN f.Total_Wait_Mins <= 25 THEN '21-25 mins'
        WHEN f.Total_Wait_Mins <= 30 THEN '26-30 mins'
        WHEN f.Total_Wait_Mins <= 35 THEN '31-35 mins'
        ELSE 'Over 35 mins'
    END                                             AS Wait_Time_Bucket,

    COUNT(f.Order_ID)                               AS Total_Orders,
    ROUND(AVG(f.Scenario_A_Revenue), 2)             AS Avg_Actual_Revenue,
    ROUND(AVG(f.Scenario_B_Revenue), 2)             AS Avg_Potential_Revenue,
    ROUND(SUM(f.Scenario_B_Revenue
            - f.Scenario_A_Revenue), 2)             AS Total_Revenue_Lost,
    ROUND(
        SAFE_DIVIDE(
            SUM(f.Scenario_A_Revenue),
            SUM(f.Scenario_B_Revenue)
        ) * 100, 2
    )                                               AS Revenue_Recovery_Pct

FROM `restaurant-blueprint.data.fact_simulation_orders` AS f

GROUP BY Wait_Time_Bucket
ORDER BY
    CASE Wait_Time_Bucket
        WHEN '0-15 mins'    THEN 1
        WHEN '16-20 mins'   THEN 2
        WHEN '21-25 mins'   THEN 3
        WHEN '26-30 mins'   THEN 4
        WHEN '31-35 mins'   THEN 5
        ELSE 6
    END;


-- ── PART 3: Menu Item Contribution to Wait Time ───────────────
-- Joins menu dimension to identify which items have highest
-- prep times and contribute most to the friction problem

SELECT
    m.name                                          AS Menu_Item,
    m.price                                         AS Item_Price,
    m.prep_time_base                                AS Base_Prep_Time_Mins,

    COUNT(f.Order_ID)                               AS Times_Ordered,
    ROUND(AVG(f.Total_Wait_Mins), 1)                AS Avg_Total_Wait_Mins,
    ROUND(AVG(f.Total_Wait_Mins)
        - m.prep_time_base, 1)                      AS Avg_Excess_Wait_Mins,
    ROUND(SUM(f.Scenario_B_Revenue
            - f.Scenario_A_Revenue), 2)             AS Total_Revenue_Lost

FROM `restaurant-blueprint.data.fact_simulation_orders` AS f
JOIN `restaurant-blueprint.data.menu` AS m
    ON f.Item_Name = m.name

GROUP BY
    m.name,
    m.price,
    m.prep_time_base

ORDER BY Total_Revenue_Lost DESC;
