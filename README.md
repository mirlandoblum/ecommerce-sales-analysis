# E-Commerce Sales Analysis | PostgreSQL

**SQL portfolio project based on real, anonymized orders from my independent digital-goods online sales activity.**

## Project overview

I analyzed order performance, completed sales amounts, cancellations and monthly trends using PostgreSQL. The project demonstrates data cleaning/validation, SQL aggregations, conditional metrics, common table expressions (CTEs) and window functions.

**Period:** July 1 – October 24, 2026 (October is **incomplete**).

## Key findings

| KPI | Value |
|---|---:|
| Distinct orders | 463 |
| Completed orders | 413 |
| Canceled orders | 29 |
| Other non-final statuses (`Received`, `Delivered`) | 21 |
| Completed sales amount | **$7,634.07** |
| Average completed order | **$18.48** |

Completed sales amount is the sum of recorded order amounts for `Completed` orders. It is **not net profit**, and does not subtract fees, inventory costs, taxes, or chargebacks. The 21 orders in non-final statuses are excluded from completed sales.

### Monthly performance

| Month | All orders | Completed | Canceled | Other non-final | Completed sales (USD) | Canceled / all orders |
|---|---:|---:|---:|---:|---:|---:|
| 2026-07 | 169 | 161 | 8 | 0 | $2,820.59 | 4.73% |
| 2026-08 | 91 | 86 | 5 | 0 | $1,656.14 | 5.49% |
| 2026-09 | 115 | 109 | 6 | 0 | $1,980.91 | 5.22% |
| 2026-10* | 88 | 57 | 10 | 21 | $1,176.43 | 11.36% |

*October is incomplete and includes orders still in progress; comparisons against full calendar months are not like-for-like.*

**Business observation:** The share of orders marked canceled increased from 5.22% in September to 11.36% in the partial October export. These are descriptive ratios, not proof of an underlying cause. Follow-up analysis would require order categories, fulfillment data, and final outcomes for still-open orders.

## Skills demonstrated

- PostgreSQL, data import and validation
- `SELECT`, `WHERE`, `GROUP BY`, `SUM`, `COUNT`, conditional aggregation
- `CASE WHEN`, `FILTER`, `NULLIF`
- CTEs and `LAG()` for month-over-month analysis
- `ROW_NUMBER()` for ranking completed orders

## Files

```text
ecommerce-sales-analysis/
├── README.md
├── data/
│   └── orders_anonymized.csv
├── sql/
│   ├── 01_create_table.sql
│   └── 02_analysis.sql
├── results/
│   └── monthly_kpis.csv
└── .gitignore
```

## Run locally (PostgreSQL + pgAdmin)

1. Create a local PostgreSQL database named `ecommerce_analysis`.
2. In pgAdmin Query Tool connected to that database, execute `sql/01_create_table.sql`. If the table already exists and contains records, **do not re-import duplicate data**.
3. For a new empty table, right-click `public.sales` → **Import/Export Data**. Choose `data/orders_anonymized.csv`, **Import**, **CSV**, **Header = Yes**, delimiter `,`, encoding **UTF8**.
4. Validate with `SELECT COUNT(*) FROM sales;` — expected result: **463**.
5. Execute the statements in `sql/02_analysis.sql` one at a time. Compare the monthly query with `results/monthly_kpis.csv`.

## Dataset notes and privacy

The dataset combines unique rows from four monthly invoice exports. Original order IDs, customer identifiers, product listings, buyer messages, and dispute text have been excluded. `order_no` is a synthetic row identifier and **cannot** be used to link a buyer across orders. Ratings are categorical (`Positive`, `Negative`, or missing). All monetary values are nominal USD amounts recorded in the exports.

Do not infer gross margin, unique customers, retention, product-level profitability or cancellation causes from these seven columns.

## Next steps

- Create a sales and cancellations dashboard (Excel or Power BI)
- Extend the dataset with additional months when available
- Investigate cancellation drivers only if suitably anonymized product/fulfillment data becomes available
