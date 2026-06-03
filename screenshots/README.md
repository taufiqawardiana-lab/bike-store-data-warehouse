## 📸 Screenshots

### 1. Pipeline Run Status
[Pipeline Run Status](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/578127fb88c64b19d008bdd39dceb69daf34ea22/screenshots/airflow_dags.png)
> Monitoring pipeline duration untuk tiga layer data: **load_bronze**, **load_silver**, dan **load_gold**.
> Grafik batang menampilkan durasi eksekusi tiap run — warna merah menandakan run yang gagal/lama,
> sementara warna hijau menandakan run yang berhasil dan cepat. Terlihat adanya perbaikan performa
> setelah beberapa run awal yang bermasalah (sekitar tanggal May 30).

---

### 2. Dashboard - Built With Looker Studio
> Page 1 - Executive Summary
[View Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Dashboard%20Sales%20Report.png)
- **Scorecard Actual Revenue** — Total revenue dari completed orders
- **Scorecard Lost Revenue** — Revenue dari rejected orders
- **Scorecard Potential Revenue** — Revenue dari pending orders
- **Scorecard Revenue In Process** — Revenue dari processing orders
- **Bar Chart Revenue per Store** — Perbandingan revenue antar cabang toko
- **Pie Chart Revenue per Kategori** — Distribusi revenue berdasarkan kategori produk
- **Time Series Tren Revenue** — Tren revenue harian dari 2016 hingga 2018

> Page 2 - Sales Analysis
[View Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Sales%20Analysis.png)
- **Table Top 10 Products** — 10 produk dengan revenue tertinggi
- **Bar Chart Revenue per Brand** — Perbandingan revenue antar brand
- **Table Staff Performance** — Performa staff berdasarkan total orders dan revenue

> Page 3 - Inventory Management
[View Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Inventory%20Management.png)
- **Stacked Bar Chart Stock per Store per Brand** — Distribusi stok per toko per brand
- **Table Low Stock Alert** — Produk dengan stok menipis (1-9 unit) per toko

> Key Insight
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

### 3. Gold Layer Tables
[Gold Layer](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/9eb44f7151f9d4bcf6baaa1d239a3c191f190f1f/screenshots/tabel_gold_layer.png)
> Tabel hasil transformasi pada **Gold Layer** di data warehouse:
> - `gold_sales_summary` — ringkasan data penjualan (~1.1M rows)
> - `gold_stock_summary` — ringkasan data stok (~136K rows)

---

### 4. Silver Layer Tables
[Silver Layer](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/9eb44f7151f9d4bcf6baaa1d239a3c191f190f1f/screenshots/tabel_silver_layer.png)
> Tabel pada **Silver Layer** hasil cleaning/transformasi dari Bronze Layer:
> `silver_brands`, `silver_categories`, `silver_customers`, `silver_order_items`,
> `silver_orders`, `silver_products`, `silver_staffs`, `silver_stocks`, `silver_stores`

---

### 5. Bronze Layer Tables
[Bronze Layer](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/9eb44f7151f9d4bcf6baaa1d239a3c191f190f1f/screenshots/tabel_bronze_layer.png)
> Tabel raw data pada **Bronze Layer** (ingestion langsung dari sumber):
> `bronze_brands`, `bronze_categories`, `bronze_customers`, `bronze_order_items`,
> `bronze_orders`, `bronze_products`, `bronze_staffs`, `bronze_stocks`, `bronze_stores`
