--SALES DATA OVERVIEW

--Total number of receipts, total quantity of products sold, and total sales revenue.
select 
count("FIS_ID") as toplam_fis_sayisi,
sum("URUN_ADEDI") as toplam_urun_adedi,
sum("URUN_TUTARI") as toplam_sati_tutari 
from satis_retail;

--Daily analysis of total receipt count, total sales revenue, and average basket size.
select 
"ALISVERIS_TARIHI",
count("FIS_ID") as toplam_fis_sayisi,
sum("URUN_TUTARI") as toplam_satis_tutari,
avg("URUN_TUTARI") as ortalama_urun_tutari
from satis_retail  
group by "ALISVERIS_TARIHI" ;

---Distribution of receipt amounts by store format (Min / Mean / Median / Max).
select 
"MAGAZA_FORMAT_KODU",
min("URUN_TUTARI") minimum,
avg("URUN_TUTARI") as mean,
max("URUN_TUTARI") as maksimum,
percentile_cont(0.5) within group (order by "URUN_TUTARI") as median 
from satis_retail sr 
group by "MAGAZA_FORMAT_KODU";


--PRODUCT BASED ANALYSIS

--Department-level analysis – total receipt count and total expenditure.
select 
ukr."REYON_ADI",
count(sr."FIS_ID"),
sum(sr."URUN_TUTARI")
from satis_retail as sr 
join urun_kategori_retail as ukr
on sr."URUN_KODU" = ukr."URUN_KODU" 
group by "REYON_ADI" ;

--b. Analysis by product family group (for the department with the highest revenue share) – total receipt count and total expenditure.
select 
ukr."REYON_ADI",
sum(sr."URUN_TUTARI") as urun_tutari
from satis_retail as sr 
join urun_kategori_retail as ukr
on sr."URUN_KODU" = ukr."URUN_KODU" 
group by "REYON_ADI" 
order by urun_tutari desc 
limit 1;

select 
ukr."AILE_ADI",
count(sr."FIS_ID"),
sum(sr."URUN_TUTARI") as urun_tutari
from satis_retail sr 
join urun_kategori_retail ukr 
on sr."URUN_KODU" = ukr."URUN_KODU" 
where ukr."REYON_ADI" =
	(select subquery."REYON_ADI" from (select 
	ukr."REYON_ADI",
	sum(sr."URUN_TUTARI") as urun_tutari
	from satis_retail as sr 
	join urun_kategori_retail as ukr
	on sr."URUN_KODU" = ukr."URUN_KODU" 
	group by "REYON_ADI" 
	order by urun_tutari desc 
	limit 1) as subquery)
group by "AILE_ADI"
order by urun_tutari desc;

--Product-level analysis (for the product family with the highest revenue share) 
--– Calculation of basket penetration and revenue penetration within the family.
select 
ukr."AILE_ADI",
sum(sr."URUN_TUTARI") as urun_tutari
from satis_retail sr 
join urun_kategori_retail ukr 
on sr."URUN_KODU" = ukr."URUN_KODU" 
group by ukr."AILE_ADI" 
order by urun_tutari desc;


select
sum(sr2."URUN_TUTARI") as toplam_ciro_aile
from urun_kategori_retail ukr 
join satis_retail sr2 
on sr2."URUN_KODU" = ukr."URUN_KODU" 
where "AILE_ADI" = (select "AILE_ADI" from ( select 
ukr2."AILE_ADI",
sum(sr."URUN_TUTARI") as urun_tutari
from satis_retail sr 
join urun_kategori_retail ukr2 
on sr."URUN_KODU" = ukr2."URUN_KODU" 
group by ukr2."AILE_ADI" 
order by urun_tutari desc
limit 1));



select
"URUN_TUTARI"/ 72908.06
from urun_kategori_retail ukr 
join satis_retail sr2 
on sr2."URUN_KODU" = ukr."URUN_KODU" 
where "AILE_ADI" = (select "AILE_ADI" from ( select 
ukr2."AILE_ADI",
sum(sr."URUN_TUTARI") as urun_tutari
from satis_retail sr 
join urun_kategori_retail ukr2 
on sr."URUN_KODU" = ukr2."URUN_KODU" 
group by ukr2."AILE_ADI" ));