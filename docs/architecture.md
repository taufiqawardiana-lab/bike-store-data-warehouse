# 🏗️ System Architecture
## Bike Store Data Warehouse
**Author:** Taufiq Akbar Wardiana

---

## Architecture Overview
┌─────────────────────────────────────────────────────────┐
│                     DATA SOURCES                        │
│                                                         │
│   Google Sheets (9 files)                               │
│   brands │ categories │ customers │ products │ orders   │
│   order_items │ staffs │ stocks │ stores                │
└─────────────────────────┬───────────────────────────────┘
│ Google Sheets API v4
│ Service Account Auth
▼
┌─────────────────────────────────────────────────────────┐
│                  ORCHESTRATION LAYER                    │
│                                                         │
│              Apache Airflow 2.8.1                       │
│         DAG: bike_store_pipeline (@daily)               │
│                                                         │
│    [load_bronze] → [load_silver] → [load_gold]          │
└─────────────────────────┬───────────────────────────────┘
│ SQLAlchemy + psycopg2
▼
┌─────────────────────────────────────────────────────────┐
│                   STORAGE LAYER                         │
│                                                         │
│            PostgreSQL 15 (Docker)                       │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   BRONZE    │  │   SILVER    │  │    GOLD     │     │
│  │  Raw Data   │→ │ Clean Data  │→ │  Analytics  │     │
│  │  9 tables   │  │  9 tables   │  │  2 tables   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────┬───────────────────────────────┘
│ Python + gspread
▼
┌─────────────────────────────────────────────────────────┐
│                VISUALIZATION LAYER                      │
│                                                         │
│   Google Sheets          Looker Studio                  │
│   (gold export)    →     (Dashboard)                    │
│                                                         │
│   • Revenue per Store                                   │
│   • Revenue per Kategori                                │
│   • Tren Revenue per Waktu                              │
│   • Top 10 Produk                                       │
└─────────────────────────────────────────────────────────┘

---

## Infrastructure Detail

### Docker Containers

| Container | Image | Port | Fungsi |
|-----------|-------|------|--------|
| postgres_bikestore | postgres:15 | 5435 | Database PostgreSQL |
| airflow-webserver | apache/airflow:2.8.1 | 8084 | Airflow UI |
| airflow-scheduler | apache/airflow:2.8.1 | - | Pipeline scheduler |

### Docker Networks
- `postgres_bikestore` — standalone container
- `airflow_default` — network untuk Airflow services

### Volume Mounts (Airflow)
  ./dags      → /opt/airflow/dags
  ./logs      → /opt/airflow/logs
  ./plugins   → /opt/airflow/plugins
  ./config    → /opt/airflow/config

---

## Technology Stack

### Core
| Technology | Version | Fungsi |
|------------|---------|--------|
| Python | 3.8 | Bahasa pemrograman utama |
| PostgreSQL | 15 | Data warehouse storage |
| Apache Airflow | 2.8.1 | Pipeline orchestration |
| Docker | latest | Containerization |

### Python Libraries
| Library | Fungsi |
|---------|--------|
| pandas | Data manipulation & transformation |
| sqlalchemy | Database connection & ORM |
| psycopg2-binary | PostgreSQL adapter |
| gspread | Google Sheets API client |
| oauth2client | Google authentication |

### External Services
| Service | Fungsi |
|---------|--------|
| Google Sheets API | Data source access |
| Google Drive API | File management |
| Looker Studio | Data visualization |

---

## Data Flow Detail

### Extract (Bronze)
```python
# Google Sheets → DataFrame → PostgreSQL
client = gspread.authorize(creds)
spreadsheet = client.open_by_key(sheet_id)
data = spreadsheet.sheet1.get_all_records()
df = pd.DataFrame(data)
df.to_sql(f"bronze_{name}", engine, if_exists="replace")
```

### Transform (Silver)
```python
# Fix datetime
df["order_date"] = pd.to_datetime(
    df["order_date"], format="%m/%d/%Y", errors="coerce"
)

# Add status label
df["order_status_label"] = df["order_status"].map({
    1: "Pending", 2: "Processing",
    3: "Rejected", 4: "Completed"
})
```

### Load (Gold)
```python
# Multi-table join + revenue calculation
df_sales = order_items.merge(orders, on="order_id") \
                      .merge(products, on="product_id") \
                      ...
df_sales["revenue"] = (
    df_sales["quantity"] *
    df_sales["list_price"] *
    (1 - df_sales["discount"])
)
```

---

## Security

| Aspek | Implementasi |
|-------|-------------|
| Google API Auth | Service Account JSON (tidak di-upload ke GitHub) |
| Database | Credentials di environment variables |
| GitHub | File credentials di `.gitignore` |

---

## Scalability Considerations

| Aspek | Current | Future |
|-------|---------|--------|
| Storage | PostgreSQL lokal (Docker) | Cloud DB (BigQuery/RDS) |
| Orchestration | Airflow lokal | Airflow di Cloud (MWAA/Cloud Composer) |
| Data Source | Google Sheets | REST API / Database langsung |
| Visualization | Looker Studio | Metabase / Superset |
