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

## Dashboard - Built With Looker Studio
### Page 1 - Executive Summary
[View Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Dashboard%20Sales%20Report.png)
- **Scorecard Actual Revenue** — Total revenue dari completed orders
- **Scorecard Lost Revenue** — Revenue dari rejected orders
- **Scorecard Potential Revenue** — Revenue dari pending orders
- **Scorecard Revenue In Process** — Revenue dari processing orders
- **Bar Chart Revenue per Store** — Perbandingan revenue antar cabang toko
- **Pie Chart Revenue per Kategori** — Distribusi revenue berdasarkan kategori produk
- **Time Series Tren Revenue** — Tren revenue harian dari 2016 hingga 2018

### Page 2 - Sales Analysis
[View Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Sales%20Analysis.png)
- **Table Top 10 Products** — 10 produk dengan revenue tertinggi
- **Bar Chart Revenue per Brand** — Perbandingan revenue antar brand
- **Table Staff Performance** — Performa staff berdasarkan total orders dan revenue

### Page 3 - Inventory Management
[View Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Inventory%20Management.png)
- **Stacked Bar Chart Stock per Store per Brand** — Distribusi stok per toko per brand
- **Table Low Stock Alert** — Produk dengan stok menipis (1-9 unit) per toko

### Key Insight
- **Actual Revenue:** $6,662,615.24 (Completed orders only)
- **Lost Revenue (Rejected):** $208,579.45
- **Top Store:** Baldwin Bikes ($5,215,751.28 — 68% of total revenue)
- **Top Category:** Mountain Bikes (35.3% of revenue)
- **Top Product:** Trek Slash 8 27.5 - 2016 ($555,558.61)
- **Top Brand:** Trek ($4,728,312.45)
- **Top Staff:** Marcelene Boyer — Baldwin Bikes ($2,405,217.85)
- **Best Year:** 2017 ($1,265,776.22)
- **Low Stock Products:** 292 produk dengan stok 1-9 unit

---

## ⚙️ Airflow DAG
Pipeline scheduled `@daily` with 3 tasks:
```
load_bronze → load_silver → load_gold
```

---

## 🗂️ Project Structure
```
├── airflow
│   ├── config
│   │   └── credentials.json
│   ├── dags
│   │   └── bike_store_pipeline.py
│   ├── plugins
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── requirements.txt
├── docs
│   └── README.md
├── notebooks
│   ├── 01_data_profiling.ipynb
│   ├── 02_silver_layer.ipynb
│   ├── 03_gold_layer.ipynb
│   └── 04_export_to_gsheets.ipynb
├── pipeline
│   ├── bronze
│   ├── gold
│   └── silver
├── screenshots
│   └── README.md
├── sql
│   ├── queries.sql
│   └── schema.sql
├── LICENSE
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

## 📂 Repository Guide

Berikut panduan akses ke seluruh file dan dokumentasi project ini:

### 📓 Notebooks
| File | Deskripsi |
|------|-----------|
| [01_data_profiling.ipynb](notebooks/01_data_profiling.ipynb) | Data understanding, profiling, dan referential integrity check |
| [02_silver_layer.ipynb](notebooks/02_silver_layer.ipynb) | Data cleaning dan transformasi ke Silver Layer |
| [03_gold_layer.ipynb](notebooks/03_gold_layer.ipynb) | Agregasi data ke Gold Layer |
| [04_export_to_gsheets.ipynb](notebooks/04_export_to_gsheets.ipynb) | Export Gold Layer ke Google Sheets untuk dashboard |

### ⚙️ Airflow Pipeline
| File | Deskripsi |
|------|-----------|
| [bike_store_pipeline.py](airflow/dags/bike_store_pipeline.py) | DAG utama — Bronze → Silver → Gold pipeline |
| [docker-compose.yml](airflow/docker-compose.yml) | Konfigurasi Docker Compose untuk Airflow |
| [Dockerfile](airflow/Dockerfile) | Custom image Airflow dengan dependencies tambahan |
| [requirements.txt](airflow/requirements.txt) | Python libraries yang diinstall di container Airflow |

### 🗄️ SQL
| File | Deskripsi |
|------|-----------|
| [queries.sql](sql/queries.sql) | 10 analytical queries untuk business questions |
| [schema.sql](sql/schema.sql) | DDL schema untuk semua tabel Bronze, Silver, dan Gold |

### 📖 Documentation
| File | Deskripsi |
|------|-----------|
| [data_dictionary.md](docs/data_dictionary.md) | Penjelasan lengkap setiap kolom di semua tabel |
| [pipeline_flow.md](docs/pipeline_flow.md) | Alur kerja ETL pipeline Bronze → Silver → Gold |
| [business_questions.md](docs/business_questions.md) | 10 business questions beserta SQL queries dan hasilnya |
| [architecture.md](docs/architecture.md) | Arsitektur sistem dan technology stack |

---

## 👤 Author
**Taufiq Akbar Wardiana**  
Aspiring Data Engineer | Bandung, Indonesia  
[LinkedIn](https://linkedin.com/in/taufiq-akbar-wardiana-7b4849311) | 
[GitHub](https://github.com/taufiqawardiana-lab)

---

## 📌 Project Status
✅ Completed

