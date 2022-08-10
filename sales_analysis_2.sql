USE sales_analysis;
SELECT * FROM sales_analysis.sales_data_2;


#RFM (Recency, frequency, monetary) ANALYSIS TO SEE WHO ARE THE BEST CUSTOMERS
select customername, rfm_frequency, rfm_recency, rfm_avgmonetaryvalue,
case
	   when rfm_cell_string in  (111,112,121,122,123,132,211,212,114,141) then 'lost_customers' #lost customers
       when rfm_cell_string in (133,134,143,244,344,343,344,144) then 'slipping away, cannot lose' #Big spenders who haven’t purchased lately) slipping away
       when rfm_cell_string in (222,223,233,322) then 'potential churners'
       when rfm_cell_string in (311,411,331) then 'new customers' 
       when rfm_cell_string in (323,333,321,422,332,432) then 'active' #Customers who buy often & recently, but at low price points
       when rfm_cell_string in (433,434,443,444) then 'loyal'
   end as rfm_segment
from sales_data_2;