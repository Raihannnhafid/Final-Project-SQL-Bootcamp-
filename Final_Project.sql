-- Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi
-- (after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail
SELECT 
	MONTH(order_date) AS bulan, 
    SUM(after_discount) AS total_after_discount
FROM 
	order_detail 
WHERE
	YEAR (order_date) = 2021 
	AND is_valid = 1 
GROUP BY 
	MONTH(order_date) 
ORDER BY 
	total_after_discount DESC 
LIMIT 1 
;

-- Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling 
-- besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail, sku_detail
SELECT
    sd.category AS kategori_produk, 
    SUM(od.after_discount) AS banyaknya_order
FROM 
    order_detail od 
JOIN 
   sku_detail sd ON od.sku_id = sd.id 
WHERE 
    YEAR(od.order_date) = 2022 
    AND od.is_valid = 1 
GROUP BY
    sd.category
ORDER BY
    banyaknya_order DESC 
LIMIT 1;


-- Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
-- Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami
-- penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail, sku_detail

WITH transaksi_per_kategori AS ( 
	SELECT 
		sd.category AS nama_kategori,
        YEAR(od.order_date) AS tahun,
        SUM(od.after_discount) AS total_nilai_transaksi
	FROM
		order_detail od
	JOIN  
		sku_detail sd ON od.sku_id = sd.id
	WHERE 
		od.is_valid = 1
	GROUP BY 
		sd.category, YEAR(od.order_date)
)
SELECT
	t2021.nama_kategori,
    t2021.total_nilai_transaksi AS tahun_2021,
    t2022.total_nilai_transaksi AS tahun_2022,
    CASE  
		WHEN t2022.total_nilai_transaksi > t2021.total_nilai_transaksi THEN 'peningkatan'
        WHEN t2022.total_nilai_transaksi < t2021.total_nilai_transaksi THEN 'Penurunan'
        ELSE 'Tidak berubah'
	END AS status_perubahan
FROM 
    transaksi_per_kategori t2021
LEFT JOIN 
    transaksi_per_kategori t2022
    ON t2021.nama_kategori = t2022.nama_kategori AND t2022.tahun = 2022
WHERE 
    t2021.tahun = 2021;

-- Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022
-- (berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail, payment_method
SELECT 
    pd.payment_method,
	COUNT(DISTINCT od.id) AS total_barang 
FROM 
    order_detail od
JOIN 
    payment_detail pd ON od.payment_id = pd.id 
WHERE 
    od.is_valid = 1 
    AND YEAR(od.order_date) = 2022 
GROUP BY 
    pd.payment_method 
ORDER BY 
    total_barang DESC 
LIMIT 5; 

-- Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.	1.Samsung 2.Apple 3.Sony 4. Huawei 5.Lenovo
-- Gunakan is_valid = 1 untuk memfilter data transaksi. Source table: order_detail, sku_detail
SELECT 
    CASE 
        WHEN sd.sku_name LIKE '%Samsung%' THEN 'Samsung'
        WHEN sd.sku_name LIKE '%Apple%' OR LOWER(sd.sku_name) LIKE '%iphone%' 
        OR LOWER(sd.sku_name) LIKE '%macbook%' THEN 'Apple'
        WHEN sd.sku_name LIKE '%Sony%' THEN 'Sony'
        WHEN sd.sku_name LIKE '%Huawei%' THEN 'Huawei'
        WHEN sd.sku_name LIKE '%Lenovo%' THEN 'Lenovo'
    END AS nama_produk,
    SUM(od.after_discount) AS total_nilai_transaksi 
FROM 
    order_detail od 
JOIN 
    sku_detail sd ON od.sku_id = sd.id 
WHERE 
    od.is_valid = 1 
    AND (
        sd.sku_name LIKE '%Samsung%' OR 
        sd.sku_name LIKE '%Apple%' OR 
        LOWER(sd.sku_name) LIKE '%iphone%' OR 
        LOWER(sd.sku_name) LIKE '%macbook%' OR 
        sd.sku_name LIKE '%Sony%' OR 
        sd.sku_name LIKE '%Huawei%' OR 
        sd.sku_name LIKE '%Lenovo%'
    )
GROUP BY 
    nama_produk
ORDER BY 
    total_nilai_transaksi DESC; 


