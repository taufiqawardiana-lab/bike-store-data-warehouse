# 🔄 Pipeline Flow
## Bike Store Data Warehouse — ETL Pipeline Documentation
**Author:** Taufiq Akbar Wardiana

---

## Overview

Pipeline ini menggunakan arsitektur **Medallion (Bronze → Silver → Gold)** 
yang diorkestrasikan oleh Apache Airflow dan berjalan secara otomatis setiap hari.

  Google Sheets (9 files)
  ↓
  [load_bronze] — Extract & Load Raw Data
  ↓
  [load_silver] — Clean & Transform
  ↓
  [load_gold]   — Aggregate & Enrich
  ↓
  PostgreSQL 15 (Docker)
  ↓
  Google Sheets (Export)
  ↓
  Looker Studio Dashboard

---

## Source Data

| Sumber | Platform | Jumlah File | Akses |
|--------|----------|-------------|-------|
| Bike Store Dataset | Google Sheets | 9 file | Google Sheets API v4 |

**Autentikasi:** Google Service Account (`credentials.json`)

---

## Phase 1 — Bronze Layer

**Task Airflow:** `load_bronze`  
**Tujuan:** Menyimpan data mentah apa adanya dari sumber tanpa transformasi apapun.

### Proses:
  1. Autentikasi ke Google Sheets API menggunakan Service Account
  2. Baca semua 9 file Google Sheets
  3. Convert ke Pandas DataFrame
  4. Load ke PostgreSQL dengan prefix `bronze_`

### Output Tables:
  bronze_brands        (9 rows)
  bronze_categories    (7 rows)
  bronze_customers     (1,445 rows)
  bronze_products      (321 rows)
  bronze_orders        (1,615 rows)
  bronze_order_items   (4,722 rows)
  bronze_staffs        (10 rows)
  bronze_stocks        (939 rows)
  bronze_stores        (3 rows)

### Catatan:
- Semua kolom disimpan sebagai tipe data aslinya
- Tidak ada filtering atau transformasi
- `if_exists="replace"` — data selalu di-refresh penuh setiap run

---

## Phase 2 — Silver Layer

**Task Airflow:** `load_silver`  
**Tujuan:** Membersihkan dan mentransformasi data dari Bronze Layer.

### Transformasi yang dilakukan:

#### silver_orders
| Kolom | Transformasi |
|-------|-------------|
| order_date | VARCHAR → TIMESTAMP (format: MM/DD/YYYY) |
| required_date | VARCHAR → TIMESTAMP (format: MM/DD/YYYY) |
| shipped_date | VARCHAR → TIMESTAMP (format: MM/DD/YYYY) |
| order_status_label | Kolom baru — mapping integer ke label teks |

#### silver_staffs
| Kolom | Transformasi |
|-------|-------------|
| active | INTEGER → BOOLEAN |
| manager_id | String kosong → NULL |

#### silver_customers
| Kolom | Transformasi |
|-------|-------------|
| phone | String kosong → NULL |

#### Tabel lainnya
Tidak ada transformasi — langsung copy dari Bronze Layer.

### Output Tables:
  silver_brands
  silver_categories
  silver_customers
  silver_products
  silver_orders        ← ada 3 kolom datetime + 1 kolom baru
  silver_order_items
  silver_staffs        ← active → boolean, manager_id → nullable
  silver_stocks
  silver_stores

---

## Phase 3 — Gold Layer

**Task Airflow:** `load_gold`  
**Tujuan:** Membuat tabel agregasi siap analisis dengan menggabungkan multiple tabel.

### gold_sales_summary

**Join yang dilakukan:**
  silver_order_items
  ↓ JOIN silver_orders      ON order_id
  ↓ JOIN silver_products    ON product_id
  ↓ JOIN silver_brands      ON brand_id
  ↓ JOIN silver_categories  ON category_id
  ↓ JOIN silver_stores      ON store_id
  ↓ JOIN silver_staffs      ON staff_id

**Kalkulasi tambahan:**
```python
revenue = quantity × list_price × (1 - discount)
```

**Output:** 4,722 rows

### gold_stock_summary

**Join yang dilakukan:**
  silver_stocks
  ↓ JOIN silver_products  ON product_id
  ↓ JOIN silver_brands    ON brand_id
  ↓ JOIN silver_stores    ON store_id

**Output:** 939 rows

---

## Airflow DAG Configuration

**File:** `airflow/dags/bike_store_pipeline.py`

| Parameter | Value |
|-----------|-------|
| DAG ID | bike_store_pipeline |
| Schedule | @daily |
| Start Date | 2024-01-01 |
| Catchup | False |
| Retries | 1 |
| Retry Delay | 5 minutes |
| Tags | bike_store, etl |

### Task Dependencies:
  load_bronze >> load_silver >> load_gold

### Run Duration (average):
| Task | Duration |
|------|----------|
| load_bronze | ~1-2 menit |
| load_silver | ~30 detik |
| load_gold | ~30 detik |
| **Total** | **~2-3 menit** |

---

## Infrastructure

| Komponen | Detail |
|----------|--------|
| PostgreSQL | v15, Docker container `postgres_bikestore` |
| Port | 5435 |
| Airflow | v2.8.1, Docker Compose |
| Airflow Port | 8084 |
| Python | 3.8 (dalam container Airflow) |

---

## Error Handling

| Kondisi | Penanganan |
|---------|------------|
| Google Sheets tidak bisa diakses | Retry otomatis setelah 5 menit |
| PostgreSQL tidak bisa diakses | Retry otomatis setelah 5 menit |
| Konversi datetime gagal | `errors="coerce"` → nilai jadi NULL |
| Data duplikat | `if_exists="replace"` — tabel di-drop dan dibuat ulang |
