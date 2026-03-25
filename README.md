# Restaurant Revenue Protection Model
## SQL Analysis Layer — Google BigQuery

A revenue protection analytics system that quantifies the financial cost of operational friction in a high-volume restaurant environment.

## The Finding

**Saturday peak shifts were losing ₦13.3M monthly** due to payment-stage bottlenecks — customers abandoning orders after waiting beyond the 35-minute threshold in a Post-Pay workflow.

A transition to a Pre-Pay model was projected to recover **28% of realized monthly revenue** without increasing customer acquisition costs.

## The Core Insight

The analysis proved this was a **process problem, not a people problem**. Revenue leakage was consistent across all staff members — meaning no amount of individual effort could fix a fundamentally broken workflow.

## SQL Files

| File | Purpose |
|---|---|
| `01_revenue_impact_analysis.sql` | Core revenue impact table joining fact orders with calendar metadata |
| `02_peak_shift_analysis.sql` | Identifies Saturday peak shifts as primary leakage source |
| `03_staff_and_wait_time_analysis.sql` | Staff consistency analysis + 35-minute cliff + menu item contribution |

## Data Architecture

**Star Schema:**

```
fact_simulation_orders (central fact table)
├── calendar (date dimension — Day_Type, Daily_Order_Target)
└── menu (item dimension — name, price, prep_time_base)
```

**Key Columns:**

| Column | Description |
|---|---|
| `Scenario_A_Revenue` | Actual revenue captured (Post-Pay model) |
| `Scenario_B_Revenue` | Potential revenue (Pre-Pay model) |
| `Total_Wait_Mins` | End-to-end customer wait time |
| `Is_Peak_Hour` | Boolean flag for peak shift identification |
| `Day_Type` | Calendar dimension — Weekend/Weekday |

## Key Analytical Findings

**The 35-Minute Cliff:** Orders exceeding 35 minutes had an 80% higher probability of becoming unrealized revenue — identified as the critical abandonment threshold.

**Staff Consistency:** Revenue recovery rate was consistent across all staff members, confirming the workflow itself was the failure point — not individual performance.

**Peak Shift Concentration:** The majority of leakage was concentrated in Saturday dinner rush (7PM–9PM), enabling targeted intervention rather than wholesale operational redesign.

## Tech Stack

| Layer | Tool |
|---|---|
| Data Simulation | Python (behavioral simulation with reneging logic) |
| Data Warehouse | Google BigQuery |
| SQL Analytics | BigQuery SQL |
| Visualization | Power BI |

## Methodology Note

This project uses synthetic data generated to simulate operational patterns in a high-volume dining environment. The simulation models customer reneging behavior — the probability of abandonment increasing exponentially beyond the 35-minute wait threshold.

## Strategic Recommendations

1. **Workflow Pivot:** Transition to Pre-Pay model to decouple food preparation from financial risk
2. **Peak-Mode Staffing:** Reallocate labor to order fulfillment during Saturday 7PM–9PM window
3. **Kiosk Deployment:** Self-service terminals to handle Pre-Pay volume during peak periods

## About

Built by **Tobou Egbekun** — Analytics Engineer & Financial Modeler
Lagos, Nigeria | [LinkedIn](https://linkedin.com/in/tobouegbekun)
