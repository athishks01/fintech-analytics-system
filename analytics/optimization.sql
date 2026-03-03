/* 
SECTION 4: QUERY PERFORMANCE & OPTIMIZATION
 ------------------------------------------------------------
1️)  Analyze Heavy Query (Before Indexing)
How does MySQL execute a revenue-heavy aggregation query?
------------------------------------------------------------ */

EXPLAIN
SELECT 
    user_id,
    SUM(amount) AS total_gmv
FROM transactions
WHERE transaction_type = 'merchant_payment'
AND status = 'SUCCESS'
GROUP BY user_id;



/* ------------------------------------------------------------
2️)  Create Performance Index
Improve filtering + grouping performance.
------------------------------------------------------------ */

CREATE INDEX idx_transactions_perf
ON transactions (transaction_type, status, user_id);



/* ------------------------------------------------------------
3️) Analyze Same Query (After Indexing)
Did execution plan improve?
------------------------------------------------------------ */

EXPLAIN
SELECT 
    user_id,
    SUM(amount) AS total_gmv
FROM transactions
WHERE transaction_type = 'merchant_payment'
AND status = 'SUCCESS'
GROUP BY user_id;



/* ------------------------------------------------------------
4)  Check Index Usage
Confirm index is created and visible.
------------------------------------------------------------ */

SHOW INDEX FROM transactions;

