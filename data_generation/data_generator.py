import random
from faker import Faker
import mysql.connector
from datetime import datetime

fake = Faker()
fake.unique.clear()

# MySQL CONNECTION
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Athish@1969",
    database="fintech_analytics"
)

cursor = conn.cursor()


# GENERATE USERS
def generate_users(n=5000):
    users = []

    for user_id in range(1, n + 1):
        users.append((
            user_id,
            fake.name(),
            fake.unique.email(),
            fake.msisdn()[0:10],
            fake.date_time_between(start_date='-1y', end_date='now')
        ))

    query = """
    INSERT INTO users (user_id, full_name, email, phone, created_at)
    VALUES (%s, %s, %s, %s, %s)
    """

    cursor.executemany(query, users)
    conn.commit()
    print(f"{n} users inserted.")


# GENERATE MERCHANTS
def generate_merchants(n=500):
    categories = ['Food', 'E-commerce', 'Travel', 'Bills', 'Entertainment']
    merchants = []

    for merchant_id in range(1, n + 1):
        merchants.append((
            merchant_id,
            fake.company(),
            random.choice(categories),
            fake.date_time_between(start_date='-1y', end_date='now')
        ))

    query = """
    INSERT INTO merchants (merchant_id, merchant_name, category, created_at)
    VALUES (%s, %s, %s, %s)
    """

    cursor.executemany(query, merchants)
    conn.commit()
    print(f"{n} merchants inserted.")


# GENERATE WALLETS
def generate_wallets(n=5000):
    wallets = []

    for wallet_id in range(1, n + 1):
        wallets.append((
            wallet_id,
            wallet_id,
            round(random.uniform(0, 20000), 2),
            fake.date_time_between(start_date='-1y', end_date='now')
        ))

    query = """
    INSERT INTO wallets (wallet_id, user_id, balance, created_at)
    VALUES (%s, %s, %s, %s)
    """

    cursor.executemany(query, wallets)
    conn.commit()
    print(f"{n} wallets inserted.")


# FETCH USER SIGNUP DATES
def fetch_user_signup_dates():
    cursor.execute("SELECT user_id, created_at FROM users")
    return dict(cursor.fetchall())


# FETCH LOAN -> USER MAP
def fetch_loan_user_map():
    cursor.execute("SELECT loan_id, user_id FROM loans")
    return dict(cursor.fetchall())


# GENERATE TRANSACTIONS
def generate_transactions(user_signup_dates, n=70000):
    transaction_types = [
        'wallet_topup',
        'merchant_payment',
        'loan_disbursement',
        'loan_repayment'
    ]

    statuses = ['SUCCESS', 'FAILED']
    transactions = []

    for txn_id in range(1, n + 1):
        txn_type = random.choice(transaction_types)
        user_id = random.randint(1, 5000)

        merchant_id = None
        if txn_type == 'merchant_payment':
            merchant_id = random.randint(1, 500)

        amount = round(random.uniform(50, 5000), 2)
        signup_date = user_signup_dates[user_id]

        txn_date = fake.date_time_between(
            start_date=signup_date,
            end_date='now'
        )

        transactions.append((
            txn_id,
            user_id,
            merchant_id,
            txn_type,
            amount,
            random.choice(statuses),
            txn_date
        ))

    query = """
    INSERT INTO transactions 
    (transaction_id, user_id, merchant_id, transaction_type, amount, status, created_at)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """

    cursor.executemany(query, transactions)
    conn.commit()
    print(f"{n} transactions inserted.")


# GENERATE LOANS
def generate_loans(user_signup_dates, n=5000):
    loans = []

    for loan_id in range(1, n + 1):
        user_id = random.randint(1, 5000)
        signup_date = user_signup_dates[user_id]

        disbursed_at = fake.date_time_between(
            start_date=signup_date,
            end_date='now'
        )

        loans.append((
            loan_id,
            user_id,
            round(random.uniform(5000, 200000), 2),
            round(random.uniform(10, 24), 2),
            random.randint(6, 36),
            disbursed_at,
            random.choice(['ACTIVE', 'CLOSED'])
        ))

    query = """
    INSERT INTO loans
    (loan_id, user_id, principal_amount, interest_rate, tenure_months, disbursed_at, loan_status)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """

    cursor.executemany(query, loans)
    conn.commit()
    print(f"{n} loans inserted.")


# GENERATE REPAYMENTS
def generate_repayments(loan_user_map, n=15000):
    repayments = []

    for repayment_id in range(1, n + 1):
        loan_id = random.randint(1, 5000)
        user_id = loan_user_map[loan_id]

        due_date = fake.date_between(start_date='-6M', end_date='+3M')
        status = random.choice(['PAID', 'OVERDUE', 'MISSED'])
        paid_at = None

        if status == 'PAID':
            paid_at = fake.date_time_between(start_date='-6M', end_date='now')

        repayments.append((
            repayment_id,
            loan_id,
            user_id,
            round(random.uniform(1000, 10000), 2),
            due_date,
            paid_at,
            status
        ))

    query = """
    INSERT INTO loan_repayments
    (repayment_id, loan_id, user_id, amount, due_date, paid_at, repayment_status)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """

    cursor.executemany(query, repayments)
    conn.commit()
    print(f"{n} repayments inserted.")


# MAIN EXECUTION
generate_users()
generate_merchants()
generate_wallets()

user_signup_dates = fetch_user_signup_dates()

generate_transactions(user_signup_dates)
generate_loans(user_signup_dates)

loan_user_map = fetch_loan_user_map()
generate_repayments(loan_user_map)

cursor.close()
conn.close()

print("Data generation complete ")