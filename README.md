# Restaurant Revenue Protection Model

## Quantifying Revenue Loss from Payment Friction

A revenue protection system designed to identify and eliminate hidden revenue leakage in high-volume operations.

---

## Executive Summary

This analysis uncovered a structural revenue leak caused by payment-stage friction in a high-volume restaurant environment.

* **Actual Monthly Revenue (Post-Pay):** ₦46M
* **Potential Monthly Revenue (Pre-Pay):** ₦59M
* **Revenue Leakage:** **₦13M/month**
* **Recovery Opportunity:** **+28% revenue without increasing demand**

> The business is not demand-constrained.
> It is **conversion-constrained at the point of payment**.

---

## The Core Insight

> **Revenue is only realized when payment is completed.**

Customers were completing the service experience but abandoning transactions due to excessive wait times at checkout.

This is not a demand problem.
This is not a staffing problem.

> **This is a system design failure.**

---

## The Problem

Most operations optimize for:

* Order speed
* Table turnover
* Kitchen efficiency

But ignore a critical constraint:

> **A delayed payment system converts demand into lost revenue.**

---

## Business Impact Breakdown

| Metric                              | Value |
| ----------------------------------- | ----- |
| Ideal Daily Revenue (Pre-Pay)       | ₦8M   |
| Actual Monthly Revenue (Post-Pay)   | ₦46M  |
| Potential Monthly Revenue (Pre-Pay) | ₦59M  |
| Monthly Revenue Lost                | ₦13M  |
| Revenue Recovery Potential          | +28%  |

---

## SQL Analysis Layer (Google BigQuery)

This repository contains the analytical layer used to quantify revenue loss and simulate recovery scenarios.

### SQL Files

| File                                  | Purpose                                                    |
| ------------------------------------- | ---------------------------------------------------------- |
| `01_revenue_impact_analysis.sql`      | Computes actual vs potential revenue (Post-Pay vs Pre-Pay) |
| `02_peak_shift_analysis.sql`          | Identifies peak-hour revenue leakage concentration         |
| `03_staff_and_wait_time_analysis.sql` | Validates system-level failure and abandonment thresholds  |

---

## Analytical Approach

1. Defined **revenue realization point** (payment completion)
2. Segmented orders by **total wait time**
3. Modeled **abandonment risk beyond 35 minutes**
4. Calculated:

   * Actual revenue (Post-Pay)
   * Potential revenue (Pre-Pay)
5. Isolated **peak-hour concentration of losses**

---

## Key Findings

### 1. The ₦13M Monthly Revenue Leak

Revenue loss is driven by **uncompleted transactions**, not lack of demand.

---

### 2. The 35-Minute Cliff

> Orders exceeding 35 minutes show an 80% higher abandonment probability.

This is the operational tipping point where demand fails to convert into revenue.

---

### 3. Peak-Hour Concentration

> The majority of losses occur during Saturday dinner rush (7PM–9PM).

This enables targeted intervention rather than full operational overhaul.

---

### 4. System Failure, Not Staff Failure

Revenue loss patterns were consistent across staff.

> The constraint is embedded in the workflow — not execution quality.

---

## Decision Framework

If:

* Wait times exceed 30–35 minutes
* Peak-hour order volume exceeds processing capacity

Then:
→ The Post-Pay model becomes **revenue-negative**

**Recommended Action:**
→ Transition to **Pre-Pay during peak hours** as a phased rollout

---

## Strategic Recommendations

### 1. Transition to Pre-Pay

Capture revenue at order initiation to eliminate payment-stage risk.

---

### 2. Peak-Hour Optimization

Reallocate staff during high-volume windows to reduce queue buildup.

---

### 3. Payment Infrastructure Upgrade

Introduce kiosks or digital ordering to remove checkout bottlenecks.

---

## Tech Stack

| Layer          | Tool                                              |
| -------------- | ------------------------------------------------- |
| Simulation     | Python (customer behavior & abandonment modeling) |
| Data Warehouse | Google BigQuery                                   |
| Analytics      | SQL                                               |
| Visualization  | Power BI                                          |

---

## Methodology Note

This project uses synthetic data to simulate real-world operational dynamics.

Customer behavior was modeled using reneging logic, where abandonment probability increases sharply beyond a 35-minute wait threshold.

---

## Final Insight

> **Most businesses focus on generating demand.**
> **Few focus on capturing the demand they already have.**

Fixing demand does not solve this problem.
Fixing flow does.

---

## About

Built by **Tobou Egbekun**
Analytics Engineer & Financial Modeler
Lagos, Nigeria
[LinkedIn](https://linkedin.com/in/tobouegbekun)
