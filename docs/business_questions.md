# ❓ Business Questions & Answers
## Bike Store Data Warehouse
**Author:** Taufiq Akbar Wardiana

---

## 1. Berapa total revenue keseluruhan?

```sql
SELECT ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary;
```

**Result:**
| total_revenue |
|---------------|
| $7,689,116.56 |

---

## 2. Store mana yang menghasilkan revenue terbesar?

```sql
SELECT 
    store_name,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY store_name
ORDER BY total_revenue DESC;
```

**Result:**
| store_name | total_orders | total_revenue |
|------------|-------------|---------------|
| Baldwin Bikes | 979 | $5,215,751.28 |
| Santa Cruz Bikes | 271 | $1,605,823.04 |
| Rowlett Bikes | 120 | $867,542.24 |

**Insight:** Baldwin Bikes mendominasi dengan 68% dari total revenue.

---

## 3. Bagaimana tren revenue per tahun?

```sql
SELECT
    EXTRACT(YEAR FROM order_date)   AS tahun,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
WHERE order_status = 4
GROUP BY tahun
ORDER BY tahun;
```

**Result:**
| tahun | total_orders | total_revenue |
|-------|-------------|---------------|
| 2016 | 255 | $936,506.83 |
| 2017 | 245 | $1,265,776.22 |
| 2018 | 57 | $702,500.79 |

**Insight:** 2017 adalah tahun terbaik. Data 2018 tidak penuh setahun.

---

## 4. Kategori produk apa yang paling menguntungkan?

```sql
SELECT
    category_name,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY category_name
ORDER BY total_revenue DESC;
```

**Result:**
| category_name | total_qty | total_revenue |
|---------------|-----------|---------------|
| Mountain Bikes | 1,755 | $2,715,079.53 |
| Road Bikes | 559 | $1,665,098.49 |
| Cruisers Bicycles | 2,063 | $995,032.62 |
| Electric Bikes | 315 | $916,684.78 |
| Cyclocross Bicycles | 394 | $711,011.84 |
| Comfort Bicycles | 813 | $394,020.10 |
| Children Bicycles | 1,179 | $292,189.20 |

**Insight:** Mountain Bikes adalah kategori terlaris dengan 35.3% dari total revenue.

---

## 5. Apa 10 produk dengan revenue tertinggi?

```sql
SELECT 
    product_name,
    brand_name,
    category_name,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY product_name, brand_name, category_name
ORDER BY total_revenue DESC
LIMIT 10;
```

**Result:**
| product_name | brand_name | category_name | total_qty | total_revenue |
|--------------|------------|---------------|-----------|---------------|
| Trek Slash 8 27.5 - 2016 | Trek | Mountain Bikes | 154 | $555,558.61 |
| Trek Conduit+ - 2016 | Trek | Electric Bikes | 145 | $389,248.70 |
| Trek Fuel EX 8 29 - 2016 | Trek | Mountain Bikes | 143 | $368,472.73 |
| Surly Straggler 650b - 2016 | Surly | Cyclocross Bicycles | 151 | $226,765.55 |
| Trek Domane SLR 6 Disc - 2017 | Trek | Road Bikes | 43 | $211,584.62 |
| Surly Straggler - 2016 | Surly | Cyclocross Bicycles | 147 | $203,507.62 |
| Trek Remedy 29 Carbon Frameset - 2016 | Trek | Mountain Bikes | 125 | $203,380.87 |
| Trek Powerfly 8 FS Plus - 2017 | Trek | Electric Bikes | 41 | $188,249.62 |
| Trek Madone 9.2 - 2017 | Trek | Road Bikes | 39 | $175,899.65 |
| Trek Silque SLR 8 Women's - 2017 | Trek | Road Bikes | 29 | $174,524.73 |

**Insight:** Trek mendominasi top 10 produk dengan 8 dari 10 produk teratas.

---

## 6. Brand mana yang paling menguntungkan?

```sql
SELECT
    brand_name,
    SUM(quantity)                   AS total_qty,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY brand_name
ORDER BY total_revenue DESC;
```

**Result:**
| brand_name | total_qty | total_revenue |
|------------|-----------|---------------|
| Trek | 2,184 | $4,728,312.45 |
| Surly | 598 | $914,519.18 |
| Electra | 2,152 | $614,238.42 |
| Sun Bicycles | 1,042 | $398,271.34 |
| Haro | 454 | $312,489.21 |

**Insight:** Trek mendominasi dengan 61.5% dari total revenue.

---

## 7. Bagaimana status order secara keseluruhan?

```sql
SELECT
    order_status_label,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
GROUP BY order_status_label
ORDER BY total_orders DESC;
```

**Result:**
| order_status_label | total_orders | total_revenue |
|-------------------|-------------|---------------|
| Completed | 1,445 | $7,689,116.56 |
| Processing | 63 | - |
| Pending | 62 | - |
| Rejected | 45 | - |

**Insight:** 89.5% order sudah completed.

---

## 8. Produk mana yang stoknya menipis (< 10 unit)?

```sql
SELECT
    store_name,
    product_name,
    brand_name,
    quantity AS current_stock
FROM gold_stock_summary
WHERE quantity < 10
ORDER BY quantity ASC;
```

**Insight:** Query ini membantu manajemen mengidentifikasi produk yang perlu segera direstok.

---

## 9. Bagaimana performa staff berdasarkan revenue?

```sql
SELECT
    staff_first_name || ' ' || staff_last_name AS staff_name,
    store_name,
    COUNT(DISTINCT order_id)        AS total_orders,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM gold_sales_summary
WHERE order_status = 4
GROUP BY staff_name, store_name
ORDER BY total_revenue DESC;
```

**Insight:** Query ini membantu evaluasi performa staff per toko.

---

## 10. Bagaimana distribusi stok per store per brand?

```sql
SELECT
    store_name,
    brand_name,
    SUM(quantity) AS total_stock
FROM gold_stock_summary
GROUP BY store_name, brand_name
ORDER BY store_name, total_stock DESC;
```

**Insight:** Trek dan Electra adalah brand dengan stok terbanyak di semua toko.
