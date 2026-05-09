create database customer_churn_analysis;
use customer_churn_analysis;

CREATE TABLE customer_churn (

    customer_id VARCHAR(50),
    gender VARCHAR(20),
    age INT,
    under_30 VARCHAR(10),
    senior_citizen VARCHAR(10),
    married VARCHAR(10),
    dependents VARCHAR(10),
    number_of_dependents INT,

    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(100),
    zip_code INT,

    latitude FLOAT,
    longitude FLOAT,

    population INT,

    quarter VARCHAR(20),

    referred_a_friend VARCHAR(10),

    number_of_referrals INT,

    tenure_in_months INT,

    offer VARCHAR(50),

    phone_service VARCHAR(20),

    avg_monthly_long_distance_charges FLOAT,

    multiple_lines VARCHAR(20),

    internet_service VARCHAR(20),

    internet_type VARCHAR(50),

    avg_monthly_gb_download INT,

    online_security VARCHAR(20),

    online_backup VARCHAR(20),

    device_protection_plan VARCHAR(20),

    premium_tech_support VARCHAR(20),

    streaming_tv VARCHAR(20),

    streaming_movies VARCHAR(20),

    streaming_music VARCHAR(20),

    unlimited_data VARCHAR(20),

    contract VARCHAR(50),

    paperless_billing VARCHAR(20),

    payment_method VARCHAR(100),

    monthly_charge FLOAT,

    total_charges FLOAT,

    total_refunds FLOAT,

    total_extra_data_charges FLOAT,

    total_long_distance_charges FLOAT,

    total_revenue FLOAT,

    satisfaction_score INT,

    customer_status VARCHAR(50),

    churn_label VARCHAR(10),

    churn_score INT,

    cltv INT,

    churn_category VARCHAR(100),

    churn_reason VARCHAR(255)

);

show tables;
select * from customer_churn;

desc customer_churn;   # describes the table's column, data types and null info

# total numbers of customers-
select count(*) as total_customer from customer_churn;

# count churned customers-
select count(*) as total_customers
from customer_churn where churn_label='Yes';

# calculate churn rate-
select round(sum(case
when churn_label='Yes' then 1
else 0
end)*100.0/count(*),
2) as churn_rate
from customer_churn;

# churn by contract type-
select contract,
count(*) as total_Curtomers,
sum(case 
when churn_label='Yes' then 1
else 0
end)
 as churn_customers
 from customer_churn group by contract;
 
 # average monthly charges--
 select churn_label,
 avg(monthly_charge) as avg_monthly_charge
 from customer_churn
 group by churn_label;

# churn by internet type
select internet_type,
count(*) as customers,
sum(case
when churn_label='Yes' then 1
else 0
end) as churn_customers
from customer_churn 
group by internet_type;

# churn by gender
select gender, count(*) as total_customer,
sum(case when churn_label='Yes' then 1
else 0
end) as churn_customer
from customer_churn 
group by gender;

# highest revenue customers
select customer_id,
total_revenue
from customer_churn 
order by total_revenue desc
limit 10;

# top churn reasons--
select churn_reason,
count(*) as total_customers
from customer_churn 
where churn_label='Yes'
group by churn_reason
order by total_customers desc;

# customer satisfaction analysis--
select satisfaction_score,
count(*) as total_customer
from customer_churn 
group by satisfaction_score
order by satisfaction_score;

# churn percentage by contract type
select contract, count(*) as total_customer,
sum(case when churn_label='Yes' then 1
else 0 end) as churn_customers,

round(sum(case when churn_label='Yes' then 1
else 0 end) *100.0/count(*),2)
as churn_percentage
from customer_churn 
group by contract;

# find contract types where churned customers are greater than 300---

select contract, count(*) as total_customer,
sum(case when churn_label='Yes' then 1
else 0 end)as churn_customers
from customer_churn 
group by contract
having churn_customers > 300;

# customer segmentation using case when--

select customer_id,monthly_charge,
case
when monthly_charge <50 then'Low Spending'
when monthly_charge between 50 and 100 then 'Medium Spending'
else 'High Spending'
end as customer_segment
from customer_churn;

# window functions---
# rank customers by revenue--
select customer_id,total_revenue,
rank() over(order by total_revenue desc) as revenue_rank
from customer_churn;

# row_number()--
select customer_id, total_revenue,
row_number() over(order by total_revenue desc)as row_num
from customer_churn;

# average revenue by contract type----
select contract, avg(total_revenue) as avg_revenue
from customer_churn 
group by contract 
order by avg_Revenue desc;

# CTEs---
with churn_summary as(
select contract,count(*) as total_customers,
sum(case when churn_label='Yes' then 1 
else 0 
end) as churn_customers
from customer_churn
group by contract
)
select contract, total_customers,churn_customers,
round(churn_customers*100.0/total_customers,2)
as churn_percentage
from churn_summary;

# subquery-
# find the customers above average revenue---

select customer_id,
total_revenue
from customer_churn
where total_revenue >
(select avg(total_revenue) from customer_churn);

# churn rate by internet type--
select internet_type,
count(*) as total_customer,
sum(case when churn_label='Yes' then 1
else 0 end) as churn_customers,
round(sum(case when churn_label ='Yes' then 1
else 0 end) *100.0/count(*),2)
as churn_rate
from customer_churn 
group by internet_type
order by churn_rate desc;

# most common churn reasons--
select churn_reason, count(*) as total_customers
from customer_churn
where churn_label = 'Yes'
group by churn_reason
order by total_customers desc
limit 5;

# retention analysis---
select customer_status,
count(*) as total_customers
from customer_churn 
group by customer_status;

# advanved KPI query---
select count(*) as total_customers,
sum(case when churn_label ='Yes' then 1
else 0
end) as churn_customers,

sum(case when churn_label-'No' then 1
else 0 end)
as retained_customers,

round(sum(case when churn_label='Yes' then 1
else 0 end) *100.0/count(*),
2)
as churn_rate,
avg(monthly_charge) as avg_monthly_charge,
avg(total_revenue) as avg_total_revenue
from customer_churn;