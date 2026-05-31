from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import pandas as pd
from sqlalchemy import create_engine
import gspread
from oauth2client.service_account import ServiceAccountCredentials

# Config
DB_CONN = "postgresql://postgres:postgres123@host.docker.internal:5435/bike_store_dw"

SHEETS_CONFIG = {
    "brands":      "1iXpgME1wvZ6Q5RJyT1VZ5uKO1HbuRUvLfJc-B5I7yn8",
    "categories":  "1YHaCJ7opgcfc2urqX4aqn0CkxjgOnazfRGGNrF3vvA4",
    "customers":   "1YUkB-GCUBY3kLNBdAP5OWsyQaPYfRCCcSyJItO1IDIA",
    "order_items": "1H7jQa53qDm4BThBjjLjtcd3bv1X3dtXJLNLi3CEXcLg",
    "orders":      "1M5pt7n7DXEIfmvk7T-Yn4XzKfWS6DmtACIp1tU7KwHA",
    "products":    "1PIQuRCpLHVOWBNc-1SNsZZqGuyRXs2bqeMN_wjLdmUs",
    "staffs":      "1onOKcZAQo1VFCGKqYRnlUYeEHTFhnIkyA_lvf3jzlAQ",
    "stocks":      "1RkW3L6CbWaMFcVyffDOEbFHSo0KbGvDLwY1JC4HXVxA",
    "stores":      "1Vm6ief5IYUfrzPqL4-mPD4WN2ndUZu1DIX-XWw4m_IM"
}

def get_gsheet_client():
    scope = [
        "https://spreadsheets.google.com/feeds",
        "https://www.googleapis.com/auth/drive"
    ]
    creds = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/airflow/config/credentials.json", scope
    )
    return gspread.authorize(creds)

# =====================
# TASK 1 — BRONZE LAYER
# =====================
def load_bronze():
    client = get_gsheet_client()
    engine = create_engine(DB_CONN)
    for name, sheet_id in SHEETS_CONFIG.items():
        spreadsheet = client.open_by_key(sheet_id)
        data = spreadsheet.sheet1.get_all_records()
        df = pd.DataFrame(data)
        df.to_sql(f"bronze_{name}", engine, if_exists="replace", index=False)
        print(f"✅ bronze_{name} — {len(df)} rows")

# =====================
# TASK 2 — SILVER LAYER
# =====================
def load_silver():
    engine = create_engine(DB_CONN)

    # Orders — fix tanggal & status label
    df_orders = pd.read_sql("SELECT * FROM bronze_orders", engine)
    for col in ["order_date", "required_date", "shipped_date"]:
        df_orders[col] = pd.to_datetime(df_orders[col], format="%m/%d/%Y", errors="coerce")
    df_orders["order_status_label"] = df_orders["order_status"].map(
        {1: "Pending", 2: "Processing", 3: "Rejected", 4: "Completed"}
    )

    # Staffs — fix active & manager_id
    df_staffs = pd.read_sql("SELECT * FROM bronze_staffs", engine)
    df_staffs["active"] = df_staffs["active"].astype(bool)
    df_staffs["manager_id"] = df_staffs["manager_id"].replace("", None)

    # Customers — fix phone
    df_customers = pd.read_sql("SELECT * FROM bronze_customers", engine)
    df_customers["phone"] = df_customers["phone"].replace("", None)

    # Tabel lain langsung copy
    silver_tables = {
        "brands":      pd.read_sql("SELECT * FROM bronze_brands", engine),
        "categories":  pd.read_sql("SELECT * FROM bronze_categories", engine),
        "customers":   df_customers,
        "order_items": pd.read_sql("SELECT * FROM bronze_order_items", engine),
        "orders":      df_orders,
        "products":    pd.read_sql("SELECT * FROM bronze_products", engine),
        "staffs":      df_staffs,
        "stocks":      pd.read_sql("SELECT * FROM bronze_stocks", engine),
        "stores":      pd.read_sql("SELECT * FROM bronze_stores", engine),
    }

    for name, df in silver_tables.items():
        df.to_sql(f"silver_{name}", engine, if_exists="replace", index=False)
        print(f"✅ silver_{name} — {len(df)} rows")

# ====================
# TASK 3 — GOLD LAYER
# ====================
def load_gold():
    engine = create_engine(DB_CONN)

    silver = {}
    for t in ["brands","categories","customers","order_items",
              "orders","products","staffs","stocks","stores"]:
        silver[t] = pd.read_sql(f"SELECT * FROM silver_{t}", engine)

    # Gold Sales Summary
    df_sales = silver["order_items"].merge(silver["orders"],     on="order_id") \
                                    .merge(silver["products"],   on="product_id") \
                                    .merge(silver["brands"],     on="brand_id") \
                                    .merge(silver["categories"], on="category_id") \
                                    .merge(silver["stores"],     on="store_id") \
                                    .merge(silver["staffs"],     on="staff_id")

    df_sales["revenue"] = df_sales["quantity"] * df_sales["list_price_x"] * (1 - df_sales["discount"])

    df_gold_sales = df_sales[[
        "order_id", "order_item_id", "order_date", "order_status", "order_status_label",
        "customer_id", "store_name", "state",
        "product_name", "brand_name", "category_name", "model_year",
        "quantity", "list_price_x", "discount", "revenue",
        "first_name", "last_name"
    ]].rename(columns={
        "list_price_x": "list_price",
        "first_name": "staff_first_name",
        "last_name": "staff_last_name"
    })

    # Gold Stock Summary
    df_gold_stocks = silver["stocks"].merge(silver["products"], on="product_id") \
                                     .merge(silver["brands"],   on="brand_id") \
                                     .merge(silver["stores"],   on="store_id")

    df_gold_stocks = df_gold_stocks[[
        "stock_id", "store_name", "product_name", "brand_name", "quantity"
    ]]

    df_gold_sales.to_sql("gold_sales_summary",  engine, if_exists="replace", index=False)
    df_gold_stocks.to_sql("gold_stock_summary", engine, if_exists="replace", index=False)
    print(f"✅ gold_sales_summary — {len(df_gold_sales)} rows")
    print(f"✅ gold_stock_summary — {len(df_gold_stocks)} rows")

# ====================
# DAG DEFINITION
# ====================
default_args = {
    "owner": "taufiq",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="bike_store_pipeline",
    default_args=default_args,
    description="ETL Pipeline: Bronze → Silver → Gold",
    schedule_interval="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["bike_store", "etl"],
) as dag:

    t1 = PythonOperator(task_id="load_bronze", python_callable=load_bronze)
    t2 = PythonOperator(task_id="load_silver", python_callable=load_silver)
    t3 = PythonOperator(task_id="load_gold",   python_callable=load_gold)

    t1 >> t2 >> t3
