## 📸 Screenshots

### 1. Pipeline Run Status
[Pipeline Run Status](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/578127fb88c64b19d008bdd39dceb69daf34ea22/screenshots/airflow_dags.png)
> Monitoring pipeline duration untuk tiga layer data: **load_bronze**, **load_silver**, dan **load_gold**.
> Grafik batang menampilkan durasi eksekusi tiap run — warna merah menandakan run yang gagal/lama,
> sementara warna hijau menandakan run yang berhasil dan cepat. Terlihat adanya perbaikan performa
> setelah beberapa run awal yang bermasalah (sekitar tanggal May 30).

---

### 2. Bike Store Sales Dashboard
[Bike Store Sales Dashboard](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Dashboard%20Sales%20Report.png)
> Dashboard analitik penjualan toko sepeda menggunakan tools BI (tampak seperti **Metabase** atau sejenisnya).
> Menampilkan:
> - **Bar chart** revenue per toko (Baldwin Bikes tertinggi ~5M)
> - **Pie chart** komposisi kategori produk (Mountain Bikes 35.3%, Road Bikes 21.7%)
> - **Line chart** tren revenue harian dari Jan 2016 – Agt 2018

[Sales Analysis](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Sales%20Analysis.png)
> - **Table Top 10 Products**
> - **Bar Chart Revenue Per Brand**
> - **Table Staff Performance**

[Inventory Management](https://github.com/taufiqawardiana-lab/bike-store-data-warehouse/blob/08ee77d653a810e42e29295dd8ac2980c210a45a/screenshots/Inventory%20Management.png)
> - **Stacked Bar Chart Stock per Store per Brand**
> - **Table Low Stock Alert**

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
