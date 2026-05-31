# 🚲 Bike Store Data Warehouse

## Project Overview
End-to-end Data Engineering project that builds a data warehouse solution 
for Bike Store sales, inventory, and profitability analytics. 
The pipeline ingests data from Google Sheets, processes it through 
Bronze → Silver → Gold layers, and visualizes insights via Looker Studio.

---

## 🏗️ Architecture
```
Google Sheets (Source)
        ↓
  Bronze Layer (Raw)
        ↓
  Silver Layer (Cleaned)
        ↓
   Gold Layer (Aggregated)
        ↓
  Looker Studio (Dashboard)
```

---

## ❓ Business Problems
- Difficulty monitoring inventory across multiple store branches
- Inconsistent sales reporting between branches
- Overstock and stockout risks
- Limited visibility into product profitability trends

---

## 🎯 Project Objectives
- Build a centralized analytical data warehouse
- Analyze product sales trends by brand and category
- Monitor inventory movement across stores
- Evaluate store and staff performance
- Support profitability analysis

---

## 🛠️ Tech Stack
| Component | Tools |
|-----------|-------|
| Data Source | Google Sheets API |
| Data Warehouse | PostgreSQL 15 (Docker) |
| Data Processing | Python, Pandas, SQLAlchemy |
| Pipeline Orchestration | Apache Airflow 2.8.1 |
| Containerization | Docker |
| Version Control | Git & GitHub |
| Visualization | Looker Studio |
| Development | JupyterLab |

---

## 📁 Dataset
9 tables sourced from Google Sheets:

| Table | Type | Rows |
|-------|------|------|
| brands | Master | 9 |
| categories | Master | 7 |
| customers | Master | 1,445 |
| products | Master | 321 |
| staffs | Master | 10 |
| stores | Master | 3 |
| orders | Transaction | 1,615 |
| order_items | Transaction | 4,722 |
| stocks | Transaction | 939 |

---

## 🔄 Data Pipeline (Bronze → Silver → Gold)

### Bronze Layer
Raw data ingested directly from Google Sheets without transformation.

### Silver Layer
Cleaned and transformed data:
- Converted `order_date`, `required_date`, `shipped_date` to datetime format
- Added `order_status_label` (1=Pending, 2=Processing, 3=Rejected, 4=Completed)
- Handled empty strings in `phone` and `manager_id` columns
- Converted `active` column to boolean

### Gold Layer
Aggregated tables ready for analytics:
- `gold_sales_summary` — 4,722 rows with revenue calculation
- `gold_stock_summary` — 939 rows with store-product stock mapping

---

## 📊 Dashboard
Built with Looker Studio — [View Dashboard](https://datastudio.google.com/s/pTNGns_fs-s) 

Key insights:
- **Total Revenue:** $7,689,116.56
- **Top Store:** Baldwin Bikes ($5.2M — 68% of total revenue)
- **Top Category:** Mountain Bikes (35.3% of revenue)
- **Top Product:** Trek Slash 8 27.5 - 2016 ($555,558.61)
- **Best Year:** 2017 ($1,265,776.22)

---

## ⚙️ Airflow DAG
Pipeline scheduled `@daily` with 3 tasks:
```
load_bronze → load_silver → load_gold
```

---

## 🗂️ Project Structure
```
bike_store_dw/
├── credentials/          # Service account (not uploaded)
├── notebooks/
│   ├── 01_data_profiling.ipynb
│   ├── 02_silver_layer.ipynb
│   ├── 03_gold_layer.ipynb
│   └── 04_export_to_gsheets.ipynb
|__ screenshoots/
|   |__ README
├── airflow/
│   ├── dags/
│   │   └── bike_store_pipeline.py
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── requirements.txt
└── README.md
```

---

## 🚀 How to Run
1. Clone this repository
2. Setup Google Sheets API credentials
3. Start PostgreSQL container:
```bash
docker run --name postgres_bikestore \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres123 \
  -e POSTGRES_DB=bike_store_dw \
  -p 5435:5432 -d postgres:15
```
4. Start Airflow:
```bash
cd airflow
docker-compose up -d
```
5. Access Airflow UI at `http://localhost:8084`
6. Trigger DAG `bike_store_pipeline`

---

## 👤 Author
**Taufiq Akbar Wardiana**  
Aspiring Data Engineer | Bandung, Indonesia  
[LinkedIn](https://linkedin.com/in/taufiq-akbar-wardiana-7b4849311) | 
[GitHub](https://github.com/taufiqawardiana-lab)

---

## 📌 Project Status
✅ Completed

