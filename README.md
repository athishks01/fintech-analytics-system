# Fintech Transaction & Credit Risk Analytics System

End-to-end fintech analytics system built using Python and MySQL.  
Simulates realistic financial data and performs revenue, risk, lifecycle, and performance analysis using advanced SQL.

---

## Dataset Scale

- 5,000 Users  
- 500 Merchants  
- 70,000 Transactions  
- 5,000 Loans  
- 15,000 Repayments  

---

## System Architecture

Schema Design → Data Generation → SQL Analytics → Query Optimization

- Relational schema built in MySQL
- Synthetic fintech data generated using Python (Faker)
- Revenue, credit risk, LTV, and cohort analytics implemented using SQL
- Query performance improved using indexing and EXPLAIN analysis

---

## Revenue Analytics

- Total GMV computation  
- Merchant revenue ranking  
- Revenue concentration (Top 20% users)

### Sample Outputs

![Total GMV](sample_outputs/revenue_total_gmv.png)  
![Top Merchants](sample_outputs/revenue_top_merchants.png)  
![Revenue Concentration](sample_outputs/revenue_pareto.png)

---

## Credit Risk Modeling

- Loan default rate calculation  
- Loan-level risk segmentation  
- Exposure distribution by risk bucket  

### Sample Output

![Risk Segmentation](sample_outputs/risk_segmentation.png)

---

## User Lifecycle & LTV

- User lifetime value calculation  
- LTV segmentation  
- Revenue contribution by user tier  

### Sample Output

![LTV Segmentation](sample_outputs/ltv_segmentation.png)

---

## Query Optimization

- Execution plan analysis using EXPLAIN  
- Composite indexing for performance improvement  

### Sample Output

![Optimization](sample_outputs/optimization_explain.png)

---

## Technical Skills Demonstrated

- Relational database modeling  
- Advanced SQL (CTEs, window functions)  
- Financial metrics computation  
- Risk modeling logic  
- Cohort retention analysis  
- Query performance tuning  

---

## How to Run

1. Execute `database/schema.sql`
2. Run `data_generation/data_generator.py`
3. Execute SQL queries inside `analytics/`