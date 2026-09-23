-- Setup
create database coffeeShop;
use coffeeShop;

CREATE TABLE baristas (
    baristaID INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    experience_level VARCHAR(20)
);

CREATE TABLE shops (
    shopID INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    city VARCHAR(50)
);

CREATE TABLE pastries (
    pastryID INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category VARCHAR(30),
    price DECIMAL(5,2)
);

CREATE TABLE employs (
    baristaID INT,
    shopID INT,
    PRIMARY KEY (baristaID, shopID),
    FOREIGN KEY (baristaID) REFERENCES baristas(baristaID),
    FOREIGN KEY (shopID) REFERENCES shops(shopID)
);

CREATE TABLE offers (
    shopID INT,
    pastryID INT,
    date_added DATE,
    PRIMARY KEY (shopID, pastryID),
    FOREIGN KEY (shopID) REFERENCES shops(shopID),
    FOREIGN KEY (pastryID) REFERENCES pastries(pastryID)
);

select * from employs;


-- 1) Find the average price of pastries for each category from the pastries table.

select category, avg(price)
from pastries
group by category;

-- 2) Find the total number of baristas at each experience level from the baristas table.

select experience_level, count(*)
from baristas
group by experience_level;

-- 3) Count the total number of shops located in each city from the shops table.

select city, count(*)
from shops
group by city;

-- 4) Find the maximum price among pastries for each category from the pastries table.

select category, max(price)
from pastries
group by category;

-- 5) Count how many pastries have been added by each shop using the shopID column from the offers table.

select shopID, count(pastryID)
from offers
group by shopID;

-- 6) Find the name, category, and price of any pastry whose price matches the maximum price within its category.

select name, category, price
from pastries p
where p.price =
(
select max(p2.price)
from pastries p2
where p.category = p2.category
);

-- 7) Find the unique shop IDs from the offers table that have offered at least one
-- pastry whose price is strictly greater than the overall average price of all pastries.

select shopID
from offers o
where o.pastryID in
(
select pastryID
from pastries
where price > 
(select avg(price) from pastries)
);

-- 8) Find the shop ID and pastry ID for the records in the offers table that have the earliest date_added (minimum date).

select shopID, pastryID, date_added
from offers
where date_added = (select min(date_added) from offers);

-- 9) Find the shop ID(s) that offer the highest number of pastries, utilizing a subquery to evaluate the maximum count per shop.

select shopID, count(*)
from offers
group by shopID
having count(*) = (select max(cnt)
from (
select count(*) as cnt
from offers
group by shopID
) as shop_counts
);


-- 10) Find the names of baristas who work at shops located in 'Seattle' using nested subqueries.

select name
from baristas
where baristaID in
(
select baristaID
from employs
where shopID in
(
select shopID
from shops
where city = 'Seattle'
)
);





