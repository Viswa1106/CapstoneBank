select customerId, year(BankDOJ) as year, quarter(BankDOJ) as quarter, max(EstimatedSalary) as maxsalary
from customerinfo
where quarter(BankDOJ) = 4
group by year(BankDOJ), quarter(BankDOJ), customerid
order by maxsalary desc
limit 5;

Select * from bank_churn;

select * from creditcard;

select customerID, avg(NumOfProducts) as avg_product
from bank_churn
where HasCrCard = 1
group by customerID;

select * from bank_churn;

select * from activecustomer;

select g.GenderCategory,
count(*) as total_customers,
sum(case when bk.exited = 1 then 1 else 0 end) as churned_customers,
sum(case when bk.exited = 1 then 1 else 0 end)/count(*) as churn_rate
from Bank_churn bk
join customerinfo cf on bk.customerid = cf.customerid
join gender g on cf.genderid = g.genderid
where year(cf.BankDOJ) = (select max(year(BankDOJ)) from customerinfo)
group by g.gendercategory;

select * from exitcustomer;

select Exited, avg(creditscore) as Average_CreditScore from bank_churn
where exited = 1
union
select exited, avg(creditscore) as Average_CreditScore from bank_churn
where exited = 0;

select g.gendercategory, round(avg(cf.estimatedsalary),2) as average_esitmate_salary,
sum(bk.isactivemember) as active_accounts from gender g
join customerinfo cf on g.genderid =cf.genderid
join bank_churn bk on cf.customerid = bk.customerid
group by g.gendercategory;

with credit_score_segment as (
select case
when CreditScore <= 599 then 'Poor'
when CreditScore >599 and CreditScore <= 700 then 'Low'
when CreditScore >700 and CreditScore <= 749 then 'Fair'
when CreditScore >749 and CreditScore <=799 then 'Good'
else 'Execellent'
end as Credit_Segment, Exited
from bank_churn
)
select Credit_Segment, sum(case when Exited = 1 then 1 else 0 end) as Total_Exited_Customers,
count(*) as Total_Customers,
round(sum(case when Exited = 1 then 1 else 0 end)/count(*),3) as Exit_Rate
from credit_score_segment
group by Credit_Segment
order by Exit_Rate desc limit 1;

select g.GeographyLocation, sum(bk.isactivemember) as active_member from geography g
join customerinfo cf on
g.GeographyID = cf.GeographyID
join bank_churn bk on
cf.customerid = bk.customerid
where bk.isactivemember = 1
and bk.tenure > 5
group by g.GeographyLocation
order by 2 desc 
limit 1;

select case
when
HasCrCard = 0 then 'Non-Creditcard Holder' else 'CreditCard Holder' end as Creditcard_Status,
Churned_Customer
from
(select HasCrCard,count(exited) as Churned_Customer from bank_churn
where exited = 1
group by HasCrCard) as Data;

select NumOfProducts,count(*) as Product_Count
from bank_churn
where exited = 1
group by NumOfProducts
order by Product_Count Desc
limit 1;

select year(BankDOJ) as Yr,
month(BankDOJ) as mnth,
count(*) as count_of_joining
from customerinfo
group by Yr, mnth
order by Yr, mnth;

select NumOfProducts, avg(balance) as Average_Balance
from bank_churn
where exited = 1
group by numofproducts
order by numofproducts;

select
corr(salary,CreditScore) as correlation
from
customerinfo cf
join
bank_churn bk on cf.customerid = bk.customerid;

select * from exitcustomer;
select * from bank_churn;
select * from creditcard;
select * from customerinfo;

show tables;


select case genderid 
	when 1 then 'male'
    when 2 then 'female' end as gender, 
    avg(case when geographyid = 1 then estimatedsalary end) as france,
    avg(case when geographyid = 2 then estimatedsalary end) as spain,
    avg(case when geographyid = 3 then estimatedsalary end) as germany,
    rank() over (order by avg(estimatedsalary) desc) as gender_rank
from 
customerinfo
group by genderID;


select 
case
when age between 18 and 30 then '18-30'
when age between 31 and 50 then '31-50'
else '50+' end as Age_group,
avg(bk.tenure) as Avg_Tenure
from bank_churn bk
join customerinfo cf on bk.customerID = cf.customerID
where bk.exited = 1
group by case
when age between 18 and 30 then '18-30'
when age between 31 and 50 then '31-50'
else '50+' end
order by Age_group;

select CORR(estimatedsalary,balance) as correlation
from customerinfo cf
join bank_churn bk on cf.customerId = bk.customerID;

SELECT 
    (COUNT(*) * SUM(EstimatedSalary * CreditScore) - SUM(EstimatedSalary) * SUM(CreditScore)) /
    (SQRT((COUNT(*) * SUM(EstimatedSalary * EstimatedSalary) - POW(SUM(EstimatedSalary), 2)) * 
    (COUNT(*) * SUM(CreditScore * CreditScore) - POW(SUM(CreditScore), 2))))
    AS correlation_all
FROM 
    Bank_Churn
JOIN 
    CustomerInfo ON Bank_Churn.CustomerId = CustomerInfo.CustomerId;
    
    
    with ChurnCustomers as (select case
	when CreditScore<=599 then 'Poor'
    when CreditScore>599 and CreditScore<=700 then 'Low'
    when CreditScore>700 and CreditScore<=749 then 'Fair'
    when CreditScore>749 and CreditScore<=799 then 'Low'
    else 'Excellent'end as Credit_Category, count(*) as churned_count
    from Bank_Churn where Exited= 1
    group by case
	when CreditScore<=599 then 'Poor'
    when CreditScore>599 and CreditScore<=700 then 'Low'
    when CreditScore>700 and CreditScore<=749 then 'Fair'
    when CreditScore>749 and CreditScore<=799 then 'Low'
    else 'Excellent'end),
    RankBucket as (select Credit_Category,Churned_count, rank() over (order by churned_count desc)as Rank_Bucket
    from ChurnCustomers)
    select Credit_Category, Churned_count,Rank_Bucket from RankBucket;
    
    
select age_bucket, creditcardcount
from (select case 
		when ci.age between 18 and 30 then '18-30'
		when ci.age between 31 and 50 then '31-50' 
		else '50+' end as age_bucket, 
            count(bc.hascrcard) as creditcardcount
		from bank_churn bc
        join customerinfo ci on bc.customerid = ci.customerid
        where hascrcard = 1 group by case 
		when ci.age between 18 and 30 then '18-30'
		when ci.age between 31 and 50 then '31-50' else '50+' 
		end) as creditcrad,
    (select avg(creditcardcount) as avg_creditcard
        from (select count(bc.hascrcard) as creditcardcount from bank_churn bc
                join customerinfo ci on bc.customerid = ci.customerid
                where hascrcard = 1 group by case 
				when ci.age between 18 and 30 then '18-30'
				when ci.age between 31 and 50 then '31-50' else '50+' end) as subquery) as avg_creditcards
where creditcardcount < avg_creditcard;

select case when GeographyID=1 then "France" 
			when GeographyID=2 then "Spain" 
            else "Germany" end as Locations, 
            count(bank.CustomerId) as Churned_Customers, avg(Balance) as AvgBalance from Bank_Churn as bank
join CustomerInfo as cust on bank.CustomerId = cust.CustomerId
where Exited=1
group by GeographyID;

SELECT Locations, Churned_Customer, AvgBalance,
RANK() OVER (ORDER BY Churned_Customer DESC) AS "Rank"
FROM (SELECT CASE
WHEN c.GeographyID = 1 THEN 'France'
WHEN c.GeographyID = 2 THEN 'Spain'
ELSE 'Germany'
END AS Locations,
COUNT(b.CustomerId) AS Churned_Customer,
AVG(b.Balance) AS AvgBalance
FROM Bank_Churn b
JOIN CustomerInfo c ON b.CustomerId = c.CustomerId
WHERE b.Exited = 1
GROUP BY c.GeographyID) AS Subquery;

select cf.*, concat(cf.customerId, '_', cf.Surname) as CustomerId_Surname from customerinfo cf
join bank_churn bf on cf.customerId = bf.customerID;

SELECT 
    bf.*,
    (SELECT ec.ExitCategory 
     FROM ExitCustomer ec 
     WHERE ec.exitid = bf.exited) AS ExitCategory
FROM 
    Bank_churn bf;

SELECT
    COUNT(*) AS all_rows,
    SUM(CASE WHEN customerid IS NULL THEN 1 ELSE 0 END) AS customerid_has_null,
    SUM(CASE WHEN creditscore IS NULL THEN 1 ELSE 0 END) AS creditscore_has_null,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS tenure_has_null,
    SUM(CASE WHEN balance IS NULL THEN 1 ELSE 0 END) AS balance_has_null,
    SUM(CASE WHEN numofproducts IS NULL THEN 1 ELSE 0 END) AS numofproducts_has_null,
    SUM(CASE WHEN hascrcard IS NULL THEN 1 ELSE 0 END) AS hascrcard_has_null,
    SUM(CASE WHEN isactivemember IS NULL THEN 1 ELSE 0 END) AS isactivemember_has_null,
    SUM(CASE WHEN exited IS NULL THEN 1 ELSE 0 END) AS exited_has_null
FROM 
    bank_churn;
    
    SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customerid IS NULL THEN 1 ELSE 0 END) AS nulls_in_customerid,
    SUM(CASE WHEN surname IS NULL THEN 1 ELSE 0 END) AS nulls_in_surname,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS nulls_in_age,
    SUM(CASE WHEN genderid IS NULL THEN 1 ELSE 0 END) AS nulls_in_genderid,
    SUM(CASE WHEN estimatedsalary IS NULL THEN 1 ELSE 0 END) AS nulls_in_estimatedsalary,
    SUM(CASE WHEN geographyid IS NULL THEN 1 ELSE 0 END) AS nulls_in_geographyid,
    SUM(CASE WHEN bankdoj IS NULL THEN 1 ELSE 0 END) AS nulls_in_bank_doj
FROM 
    customerinfo;
    
SELECT bc.customerid,ci.surname as Lastname, bc.isactivemember
FROM bank_churn bc
JOIN customerinfo ci ON bc.customerid = ci.customerid AND ci.surname LIKE '%on';










