CREATE DATABASE IF NOT EXISTS fintech_analytics;
USE fintech_analytics;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at DATETIME
);

CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(150),
    category VARCHAR(50),
    created_at DATETIME
);

CREATE TABLE wallets (
    wallet_id INT PRIMARY KEY,
    user_id INT,
    balance DECIMAL(15,2),
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    merchant_id INT NULL,
    transaction_type VARCHAR(50),
    amount DECIMAL(15,2),
    status VARCHAR(20),
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    user_id INT,
    principal_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    disbursed_at DATETIME,
    loan_status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE loan_repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    user_id INT,
    amount DECIMAL(15,2),
    due_date DATE,
    paid_at DATETIME NULL,
    repayment_status VARCHAR(20),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);