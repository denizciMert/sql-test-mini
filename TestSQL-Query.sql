create table AkademetreSQL(
SÝTE varchar(250) NOT NULL,
ÜRÜN varchar(250) NOT NULL,
FÝYAT int NOT NULL
)

select * from AkademetreSQL

WITH RankedPrices AS (
    SELECT
        ÜRÜN,
        SÝTE,
        FiYAT,
        ROW_NUMBER() OVER (PARTITION BY ÜRÜN ORDER BY FiYAT) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY ÜRÜN ORDER BY FiYAT DESC) AS RowDesc
    FROM
        AkademetreSQL
),
MinPrices AS (
    SELECT
        ÜRÜN,
        SÝTE AS MinimumFiyatliSiteAdi,
        FiYAT AS MinimumFiyat
    FROM
        RankedPrices
    WHERE
        RowAsc = 1
),
MaxPrices AS (
    SELECT
        ÜRÜN,
        SÝTE AS MaksimumFiyatliSiteAdi,
        FiYAT AS MaksimumFiyat
    FROM
        RankedPrices
    WHERE
        RowDesc = 1
),
AveragePrices AS (
    SELECT
        ÜRÜN,
        AVG(FiYAT) AS OrtalamaFiyat
    FROM
        AkademetreSQL
    GROUP BY
        ÜRÜN
)
SELECT
    a.ÜRÜN,
    m.MinimumFiyat AS 'Minimum Fiyat',
    m.MinimumFiyatliSiteAdi AS 'Minimum Fiyatlý Site Adý',
    x.MaksimumFiyat AS 'Maksimum Fiyat',
    x.MaksimumFiyatliSiteAdi AS 'Maksimum Fiyatlý Site Adý',
    a.OrtalamaFiyat AS 'Ortalama Fiyat'
FROM
    AveragePrices a
JOIN
    MinPrices m ON a.ÜRÜN = m.ÜRÜN
JOIN
    MaxPrices x ON a.ÜRÜN = x.ÜRÜN
ORDER BY
    a.ÜRÜN
