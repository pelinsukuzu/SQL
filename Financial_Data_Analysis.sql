
--SALES PORTFOLIO ANALYSIS

--The number of unique customers, total number of credits, and total credit amount within the sales portfolio.
select 
count(distinct "BSN") as tekil_musteri_adedi,
count(*) as toplam_kredi_sayisi,
sum("ANAPARA_BAKIYE") as kredi_tutarı
from satis;

--Total credit counts, total and average credit amounts by credit type.
select 
"KREDI_TURU",
count("ANAPARA_BAKIYE") as kredi_adeti,
sum("ANAPARA_BAKIYE") as toplam_kredi_tutari,
avg("ANAPARA_BAKIYE") as ortalama_kredi_tutari 
from satis
group by "KREDI_TURU";

--CUSTOMER-BASED ANALYSIS



--The collection rate by customer (total collections / total principal amount).
CREATE TABLE satis_tahsilat AS 
SELECT
    s."BSN",
    s."ANAPARA_BAKIYE",
    t.toplam_tahsilat
FROM satis s 
RIGHT JOIN (
    SELECT 
        "BSN", 
        SUM("Tahsilat") AS toplam_tahsilat  
    FROM tahsilat 
    GROUP BY "BSN"
) t ON s."BSN" = t."BSN";

alter table satis_tahsilat
add column borc_tahsil_etme_orani numeric;

UPDATE satis_tahsilat
SET borc_tahsil_etme_orani = toplam_tahsilat / NULLIF("ANAPARA_BAKIYE" , 0);

--Distribution of the collection rate (Mean - Min – Median – Max).

select 
min(borc_tahsil_etme_orani) as min, 
max(borc_tahsil_etme_orani) as max,
avg(borc_tahsil_etme_orani) as mean,
percentile_cont(0.5) within group (order by borc_tahsil_etme_orani) as median 
from satis_tahsilat