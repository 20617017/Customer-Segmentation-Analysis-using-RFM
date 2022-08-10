use sales_analysis;

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



















