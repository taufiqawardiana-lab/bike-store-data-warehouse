## 📸 Screenshots

### 1. Pipeline Run Status
![Pipeline Run Status](screenshots/TangkapanLayar2026-05-31pukul15.49.04.png)
> Monitoring pipeline duration untuk tiga layer data: **load_bronze**, **load_silver**, dan **load_gold**.
> Grafik batang menampilkan durasi eksekusi tiap run — warna merah menandakan run yang gagal/lama,
> sementara warna hijau menandakan run yang berhasil dan cepat. Terlihat adanya perbaikan performa
> setelah beberapa run awal yang bermasalah (sekitar tanggal May 30).

---

### 2. Bike Store Sales Dashboard
![Bike Store Sales Dashboard](screenshots/TangkapanLayar2026-05-31pukul16.07.45.png)
> Dashboard analitik penjualan toko sepeda menggunakan tools BI (tampak seperti **Metabase** atau sejenisnya).
> Menampilkan:
> - **Bar chart** revenue per toko (Baldwin Bikes tertinggi ~5M)
> - **Pie chart** komposisi kategori produk (Mountain Bikes 35.3%, Road Bikes 21.7%)
> - **Line chart** tren revenue harian dari Jan 2016 – Agt 2018
> - **Tabel top 10 produk** berdasarkan quantity dan revenue

---

### 3. Gold Layer Tables
![Gold Layer](screenshots/gold_tables.png)
> Tabel hasil transformasi pada **Gold Layer** di data warehouse:
> - `gold_sales_summary` — ringkasan data penjualan (~1.1M rows)
> - `gold_stock_summary` — ringkasan data stok (~136K rows)

---

### 4. Silver Layer Tables
![Silver Layer](screenshots/silver_tables.png)
> Tabel pada **Silver Layer** hasil cleaning/transformasi dari Bronze Layer:
> `silver_brands`, `silver_categories`, `silver_customers`, `silver_order_items`,
> `silver_orders`, `silver_products`, `silver_staffs`, `silver_stocks`, `silver_stores`

---

### 5. Bronze Layer Tables
![Bronze Layer](screenshots/bronze_tables.png)
> Tabel raw data pada **Bronze Layer** (ingestion langsung dari sumber):
> `bronze_brands`, `bronze_categories`, `bronze_customers`, `bronze_order_items`,
> `bronze_orders`, `bronze_products`, `bronze_staffs`, `bronze_stocks`, `bronze_stores`
