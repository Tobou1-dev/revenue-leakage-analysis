-- ============================================================
-- FILE: 01_revenue_impact_analysis.sql
-- PROJECT: Restaurant Revenue Protection Model
-- AUTHOR: Tobou Egbekun — Analytics Engineer
-- DESCRIPTION: Creates the core revenue impact table by joining
--              fact orders with calendar metadata and calculating
--              revenue lost to operational friction
-- ============================================================

CREATE OR REPLACE TABLE `restaurant-blueprint.analysis.revenue_impact` AS

SELECT
    f.Order_ID,
    f.Date,
    c.Day_Type,
    f.Staff_Name,
    f.Item_Name,
    f.Item_Price,
    f.Arrival_Time,
    f.Order_Taken_Time,
    f.Food_Ready_Time,
    f.Departure_Time,
    f.Total_Wait_Mins,
    f.Is_Peak_Hour,

    -- Scenario A: Post-Pay model (current reality)
    f.Scenario_A_Status,
    f.Scenario_A_Revenue AS Actual_Revenue,

    -- Scenario B: Pre-Pay model (optimized state)
    f.Scenario_B_Status,
    f.Scenario_B_Revenue AS Potential_Revenue,

    -- Revenue lost to friction
    (f.Scenario_B_Revenue - f.Scenario_A_Revenue) AS Revenue_Lost_To_Friction,

    -- Risk classification based on wait time
    CASE
        WHEN f.Total_Wait_Mins > 35 THEN 'Critical Risk'
        WHEN f.Total_Wait_Mins > 20 THEN 'High Risk'
        ELSE 'Safe'
    END AS Risk_Category,

    -- Peak vs Regular flag
    CASE
        WHEN f.Is_Peak_Hour = TRUE THEN 'Peak'
        ELSE 'Regular'
    END AS Shift_Type

FROM `restaurant-blueprint.data.fact_simulation_orders` AS f
JOIN `restaurant-blueprint.data.calendar` AS c
    ON f.Date = c.Date;
