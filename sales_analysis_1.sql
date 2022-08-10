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



with rfm as 
(
select 
CUSTOMERNAME, 
sum(sales) MonetaryValue,
avg(sales) AvgMonetaryValue,
count(ORDERNUMBER) Frequency,
max(ORDERDATE) last_order_date,
(select max(orderdate) from sales_data_1) maxorderdate,
datediff((select max(orderdate) from sales_data_1),max(orderdate)) recency

from sales_data_1
group by CUSTOMERNAME
),
rfm_calc as
(

select r.*,
NTILE(4) OVER (order by Recency desc) rfm_recency,
NTILE(4) OVER (order by Frequency) rfm_frequency,
NTILE(4) OVER (order by MonetaryValue) rfm_monetary
from rfm r
)

select 
c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
concat(rfm_recency,rfm_frequency,rfm_monetary) as rfm_cell_string
 from rfm_calc c



