create table AkademetreSQL(
S�TE varchar(250) NOT NULL,
�R�N varchar(250) NOT NULL,
F�YAT int NOT NULL
)

select * from AkademetreSQL

WITH RankedPrices AS (
    SELECT
        �R�N,
        S�TE,
        FiYAT,
        ROW_NUMBER() OVER (PARTITION BY �R�N ORDER BY FiYAT) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY �R�N ORDER BY FiYAT DESC) AS RowDesc
    FROM
        AkademetreSQL
),
MinPrices AS (
    SELECT
        �R�N,
        S�TE AS MinimumFiyatliSiteAdi,
        FiYAT AS MinimumFiyat
    FROM
        RankedPrices
    WHERE
        RowAsc = 1
),
MaxPrices AS (
    SELECT
        �R�N,
        S�TE AS MaksimumFiyatliSiteAdi,
        FiYAT AS MaksimumFiyat
    FROM
        RankedPrices
    WHERE
        RowDesc = 1
),
AveragePrices AS (
    SELECT
        �R�N,
        AVG(FiYAT) AS OrtalamaFiyat
    FROM
        AkademetreSQL
    GROUP BY
        �R�N
)
SELECT
    a.�R�N,
    m.MinimumFiyat AS 'Minimum Fiyat',
    m.MinimumFiyatliSiteAdi AS 'Minimum Fiyatl� Site Ad�',
    x.MaksimumFiyat AS 'Maksimum Fiyat',
    x.MaksimumFiyatliSiteAdi AS 'Maksimum Fiyatl� Site Ad�',
    a.OrtalamaFiyat AS 'Ortalama Fiyat'
FROM
    AveragePrices a
JOIN
    MinPrices m ON a.�R�N = m.�R�N
JOIN
    MaxPrices x ON a.�R�N = x.�R�N
ORDER BY
    a.�R�N
