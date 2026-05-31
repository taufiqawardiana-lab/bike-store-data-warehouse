# 📖 Data Dictionary
## Bike Store Data Warehouse
**Author:** Taufiq Akbar Wardiana

---

## 🔴 Bronze Layer (Raw Data)

### bronze_brands
| Column | Type | Description |
|--------|------|-------------|
| brand_id | VARCHAR | Primary key. Format: BRAND000X |
| brand_name | VARCHAR | Nama brand sepeda |

### bronze_categories
| Column | Type | Description |
|--------|------|-------------|
| category_id | VARCHAR | Primary key. Format: CATEGORY000X |
| category_name | VARCHAR | Nama kategori sepeda |

### bronze_customers
| Column | Type | Description |
|--------|------|-------------|
| customer_id | VARCHAR | Primary key. Format: CUSTOMER000X |
| first_name | VARCHAR | Nama depan customer |
| last_name | VARCHAR | Nama belakang customer |
| phone | VARCHAR | Nomor telepon (bisa kosong) |
| email | VARCHAR | Alamat email |
| street | VARCHAR | Alamat jalan |
| city | VARCHAR | Kota |
| state | VARCHAR | Negara bagian (US) |
| zip_code | INTEGER | Kode pos |

### bronze_products
| Column | Type | Description |
|--------|------|-------------|
| product_id | VARCHAR | Primary key. Format: PRODUCT000X |
| product_name | VARCHAR | Nama lengkap produk |
| brand_id | VARCHAR | Foreign key ke bronze_brands |
| category_id | VARCHAR | Foreign key ke bronze_categories |
| model_year | INTEGER | Tahun model produk |
| list_price | NUMERIC | Harga satuan produk |

### bronze_orders
| Column | Type | Description |
|--------|------|-------------|
| order_id | VARCHAR | Primary key. Format: ORDER000X |
| customer_id | VARCHAR | Foreign key ke bronze_customers |
| order_status | INTEGER | Status order (1-4) |
| order_date | VARCHAR | Tanggal order (raw: MM/DD/YYYY) |
| required_date | VARCHAR | Tanggal dibutuhkan (raw: MM/DD/YYYY) |
| shipped_date | VARCHAR | Tanggal dikirim (raw: MM/DD/YYYY) |
| store_id | VARCHAR | Foreign key ke bronze_stores |
| staff_id | VARCHAR | Foreign key ke bronze_staffs |

### bronze_order_items
| Column | Type | Description |
|--------|------|-------------|
| order_item_id | VARCHAR | Primary key. Format: ORDERITEM000X |
| order_id | VARCHAR | Foreign key ke bronze_orders |
| item_id | VARCHAR | ID item dalam order |
| product_id | VARCHAR | Foreign key ke bronze_products |
| quantity | INTEGER | Jumlah unit yang dipesan |
| list_price | NUMERIC | Harga satuan saat transaksi |
| discount | NUMERIC | Diskon dalam desimal (0.0 - 1.0) |

### bronze_staffs
| Column | Type | Description |
|--------|------|-------------|
| staff_id | VARCHAR | Primary key. Format: STAFF000X |
| first_name | VARCHAR | Nama depan staff |
| last_name | VARCHAR | Nama belakang staff |
| email | VARCHAR | Email staff |
| phone | VARCHAR | Nomor telepon staff |
| active | INTEGER | Status aktif (1=aktif, 0=nonaktif) |
| store
