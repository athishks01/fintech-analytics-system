/* 
SECTION 2: CREDIT & RISK ANALYTICS
------------------------------------------------------------
1)Total Loans Issued
How many loans were disbursed?
------------------------------------------------------------ */

SELECT 
    COUNT(*) AS total_loans
FROM loans;



/* ------------------------------------------------------------
2️)Total Principal Amount Disbursed
What is total credit exposure?
------------------------------------------------------------ */

SELECT 
    ROUND(SUM(principal_amount), 2) AS total_principal_disbursed
FROM loans;



/* ------------------------------------------------------------
3️) Average Loan Size
What is the average ticket size of loans?
------------------------------------------------------------ */

SELECT 
    ROUND(AVG(principal_amount), 2) AS avg_loan_amount
FROM loans;



/* ------------------------------------------------------------
4️) Loan Status Distribution
How many loans are ACTIVE vs CLOSED?
------------------------------------------------------------ */

SELECT 
    loan_status,
    COUNT(*) AS loan_count
FROM loans
GROUP BY loan_status;



/* ------------------------------------------------------------
5️)  Overall Default Rate
What % of repayments were MISSED?
------------------------------------------------------------ */

SELECT
    COUNT(*) AS total_repayments,

    COUNT(CASE 
        WHEN repayment_status = 'MISSED' 
        THEN 1 
    END) AS missed_repayments,

    ROUND(
        COUNT(CASE 
            WHEN repayment_status = 'MISSED' 
            THEN 1 
        END)
        / COUNT(*) * 100,
    2) AS default_rate_percent

FROM loan_repayments;



/* ------------------------------------------------------------
6️) Loan-Level Default %
For each loan, what % of its installments were MISSED?
------------------------------------------------------------ */

SELECT
    loan_id,

    COUNT(*) AS total_installments,

    COUNT(CASE 
        WHEN repayment_status = 'MISSED'
        THEN 1
    END) AS missed_count,

    ROUND(
        COUNT(CASE 
            WHEN repayment_status = 'MISSED'
            THEN 1
        END) 
        / COUNT(*) * 100,
    2) AS default_percent

FROM loan_repayments

GROUP BY loan_id
ORDER BY default_percent DESC;



/* ------------------------------------------------------------
7️) Loan Risk Segmentation
How many loans fall into each risk bucket?
------------------------------------------------------------ */

WITH loan_default AS (
    SELECT
        loan_id,
        ROUND(
            COUNT(CASE 
                WHEN repayment_status = 'MISSED' 
                THEN 1 
            END)
            / COUNT(*) * 100,
        2) AS default_percent
    FROM loan_repayments
    GROUP BY loan_id
)

SELECT
    CASE
        WHEN default_percent = 0 THEN 'Healthy'
        WHEN default_percent > 0 AND default_percent <= 25 THEN 'Mild Risk'
        WHEN default_percent > 25 AND default_percent <= 50 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_category,

    COUNT(*) AS loan_count

FROM loan_default
GROUP BY risk_category
ORDER BY loan_count DESC;



/* ------------------------------------------------------------
8️)  Exposure by Risk Category
How much principal amount is tied to each risk category?
------------------------------------------------------------ */

WITH loan_default AS (
    SELECT
        loan_id,
        ROUND(
            COUNT(CASE WHEN repayment_status = 'MISSED' THEN 1 END)
            / COUNT(*) * 100,
        2) AS default_percent
    FROM loan_repayments
    GROUP BY loan_id
)

SELECT
    CASE
        WHEN ld.default_percent = 0 THEN 'Healthy'
        WHEN ld.default_percent > 0 AND ld.default_percent <= 25 THEN 'Mild Risk'
        WHEN ld.default_percent > 25 AND ld.default_percent <= 50 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_category,

    COUNT(l.loan_id) AS loan_count,
    ROUND(SUM(l.principal_amount), 2) AS total_exposure

FROM loans l
JOIN loan_default ld
    ON l.loan_id = ld.loan_id

GROUP BY risk_category
ORDER BY total_exposure DESC;



/* ------------------------------------------------------------
9️) Average Loan Size by Risk Category
Are risky loans larger or smaller than healthy loans?
------------------------------------------------------------ */

WITH loan_default AS (
    SELECT
        loan_id,
        ROUND(
            COUNT(CASE WHEN repayment_status = 'MISSED' THEN 1 END)
            / COUNT(*) * 100,
        2) AS default_percent
    FROM loan_repayments
    GROUP BY loan_id
)

SELECT
    CASE
        WHEN ld.default_percent = 0 THEN 'Healthy'
        WHEN ld.default_percent > 0 AND ld.default_percent <= 25 THEN 'Mild Risk'
        WHEN ld.default_percent > 25 AND ld.default_percent <= 50 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_category,

    ROUND(AVG(l.principal_amount), 2) AS avg_loan_amount

FROM loans l
JOIN loan_default ld
    ON l.loan_id = ld.loan_id

GROUP BY risk_category
ORDER BY avg_loan_amount DESC;



/* ------------------------------------------------------------
10) User-Level Risk Behavior
Which users repeatedly take high-risk loans?
------------------------------------------------------------ */

WITH loan_default AS (
    SELECT
        loan_id,
        ROUND(
            COUNT(CASE 
                WHEN repayment_status = 'MISSED' 
                THEN 1 
            END)
            / COUNT(*) * 100,
        2) AS default_percent
    FROM loan_repayments
    GROUP BY loan_id
)

SELECT
    l.user_id,

    COUNT(l.loan_id) AS total_loans,

    COUNT(CASE 
        WHEN ld.default_percent > 50 
        THEN 1 
    END) AS high_risk_loans,

    ROUND(
        COUNT(CASE 
            WHEN ld.default_percent > 50 
            THEN 1 
        END)
        / COUNT(l.loan_id) * 100,
    2) AS risk_percent

FROM loans l
JOIN loan_default ld
    ON l.loan_id = ld.loan_id

GROUP BY l.user_id
ORDER BY risk_percent DESC;


