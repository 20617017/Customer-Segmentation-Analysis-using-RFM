use sales_analysis;

SELECT * FROM sales_analysis.sales_data_1;

# INSPECTING DATA
select * from sales_data_1;
desc sales_data_1;

#CHECKING UNIQUE VALUES
select distinct status from sales_data_1;
select distinct year_id from sales_data_1;
select distinct productline from sales_data_1; 
select distinct country from sales_data_1; 
select distinct dealsize from sales_data_1; 
select distinct territory from sales_data_1; 

select distinct month_id from sales_data_1
where year_id=2005;


#ANALYSIS
# GROUPING SALES BY PRODUCTLINE, YEAR, DEALSIZE
select productline, sum(sales) revenue
from sales_data_1
group by productline
order by 2 desc;

select year_id, sum(sales) revenue
from sales_data_1
group by year_id
order by 2 desc;

select dealsize, sum(sales) revenue
from sales_data_1
group by dealsize
order by 2 desc;

#TO SEE THE BEST MONTH OF SALE AND HOW MUCH WAS EARNED IN THAT MONTH 
select month_id, sum(sales) revenue, count(ordernumber) frequency
from sales_data_1
where year_id=2004
group by month_id
order by 2 desc;

#NOVEMBER IS THE BEST MONTH OF SALE AND SEE WHICH PRODUCT'S SALE WAS LARGE IN THAT MONTH
select month_id, productline, sum(sales) revenue, count(ordernumber) frequency
from sales_data_1
where year_id=2004 and month_id=11
group by month_id, productline
order by 3 desc;

#RFM (Recency, frequency, monetary) ANALYSIS TO SEE WHO ARE THE BEST CUSTOMERS

select 
customername , sum(sales) monetaryvalue,
avg(sales) avgmonetaryvalue,
count(ordernumber) frequency,
max(orderdate) lastorderdate,
(select max(orderdate) from sales_data_1) maxorderdate,
datediff((select max(orderdate) from sales_data_1),max(orderdate)) recency
from sales_data_1
group by customername;

create table rfm as 
(
 with rfm as 
( select 
customername , sum(sales) monetaryvalue,
avg(sales) avgmonetaryvalue,
count(ordernumber) frequency,
max(orderdate) lastorderdate,
(select max(orderdate) from sales_data_1) maxorderdate,
datediff((select max(orderdate) from sales_data_1),max(orderdate)) recency
from sales_data_1
group by customername),
rfm_calc as 
(
select r.* ,
        NTILE(4) OVER (order by recency desc) rfm_recency,
		NTILE(4) OVER (order by frequency) rfm_frequency,
		NTILE(4) OVER (order by monetaryValue) rfm_monetary
from rfm r
)
select r.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	concat(rfm_recency,rfm_frequency,rfm_monetary) as rfm_cell_string
from rfm_calc r
);

select * from rfm;

#RFM (Recency, frequency, monetary) ANALYSIS TO SEE WHO ARE THE BEST CUSTOMERS
select customername, rfm_frequency, rfm_recency, rfm_monetary,
case
	   when rfm_cell_string in  (111,112,121,122,123,132,211,212,114,141) then 'lost_customers' #lost customers
       when rfm_cell_string in (133,134,143,244,344,343,344,144) then 'slipping away, cannot lose' #Big spenders who haven’t purchased lately) slipping away
       when rfm_cell_string in (222,223,233,322) then 'potential churners'
       when rfm_cell_string in (311,411,331) then 'new customers' 
       when rfm_cell_string in (323,333,321,422,332,432) then 'active' #Customers who buy often & recently, but at low price points
       when rfm_cell_string in (433,434,443,444) then 'loyal'
   end as rfm_segment
from rfm;


SELECT * FROM sales_analysis.sales_data_1;

#WHAT PRODUCTS ARE MORE OFTEN SOLD TOGETHER
select concat (',',productcode) from sales_data_1
where ordernumber in
(
select ordernumber from (
select ordernumber,count(*) rn
from sales_data_1
where status='shipped'
group by ordernumber) m
where rn=2
);


select distinct OrderNumber, stuff(

(select concat(',', ptoductcode)
from sales_data_1 p
where ordernumber in 
(

select ordernumber
from (
select ordernumber, count(*) rn
FROM sales_data_1
where STATUS = 'Shipped'
group by ORDERNUMBER
)m
where rn = 2
)
and p.ordernumber = s.ordernumber
for xml path (''))

, 1, 1, '') ProductCodes

from sales_data_1 s
order by 2 desc;