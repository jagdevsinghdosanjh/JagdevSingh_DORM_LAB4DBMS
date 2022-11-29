CREATE DATABASE `ecommerce`; 
-- /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ 
-- /*!80016 DEFAULT ENCRYPTION='N' */;

-- Lab 4 - DBMS ( Nov 29, 11:59 PM Total Marks: 20)

-- Question No 3.	Display the total number of customers based on gender 	who have placed orders of worth at least Rs.3000.
-- Solved Query
select cus_gender, count(cus_gender) from customer
where cus_id in(select cus_id from ecommerce.order
group by cus_id having sum(ORD_AMOUNT)>=3000)group by cus_gender;

-- Question No 4. 	Display all the orders along with product name ordered by a customer having Customer_Id=2
-- Solved Query
select o.*, p.PRO_NAME 
from ecommerce.order o
left join supplier_pricing sp on sp.PRICING_ID=o.PRICING_ID
left join product p on p.PRO_ID=sp.PRO_ID
where o.CUS_ID=2;



-- Question No 5.	Display the Supplier details who can supply more than one product.
-- Solved Query
select * from supplier where supp_id 
in (select supp_id from supplier_pricing group by supp_id having count(supp_id)>1);

-- Question No 6.	Find the least expensive product from each category and print the table with category id, name, product name and price of the product
-- Solved Query
select pp.CAT_ID,c.CAT_NAME,pp.PRO_NAME, min(supp_price) MIN_PRICE
from supplier_pricing sp
inner join product pp on pp.pro_id=sp.pro_id 
inner join category c on c.cat_id=pp.cat_id 
group by c.CAT_ID;-- pp.CAT_ID; 


-- Question No 7.	Display the Id and Name of the Product ordered after “2021-10-05”.
-- Solved Query
select pro_id , pro_name from product where pro_id 
in(select pro_id from supplier_pricing as sp where PRICING_ID 
in (select pricing_id from ecommerce.order as o where ORD_DATE >'2021-10-05'));

-- or

select sp.pro_id, p.pro_name
from ecommerce.order o
inner join supplier_pricing sp on sp.PRICING_ID=o.PRICING_ID
inner join product p on p.PRO_ID=sp.PRO_ID
where ORD_DATE > '2021-10-05';

-- Question No 8.	Display customer name and gender whose names start or end with character 'A'.
-- Solved Query
select CUS_NAME, CUS_GENDER from ecommerce.customer 
where CUS_NAME like 'A%' or cus_name like '%A';

-- Question No 9.	Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
-- Solved Query
 delimiter $$
create procedure Rating_Procedure()
begin
select supp_id, supp_name,Avg_Rating, 
case when Avg_rating=5 then'Excellent Service'
when Avg_rating>4 then 'Good Service'
when Avg_rating>2 then'Average Service'
else 'Poor Service'
End as Type_Of_Service from (select sp.supp_id, s.supp_name, avg(r.rat_ratstars) as Avg_rating
from rating as r, ecommerce.order as o,
supplier_pricing as sp, supplier as s where r.ORD_ID=o.ORD_ID and sp.PRICING_ID=o.PRICING_ID 
and s.supp_id=sp.SUPP_ID group by sp.supp_id) as T1;
end $$
delimiter ;

call Rating_Procedure();