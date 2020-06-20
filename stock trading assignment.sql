/*Creating new schema assignment*/
-- DROP DATABASE assignment;

CREATE DATABASE assignment;

/*Using the created database*/
USE assignment;

/*Importing the data using table data import wizard*/
/*Changed the format of date from Text to DateTime and used the format "%d-%B-%Y" */

/* NOTE: File names are not changed while importing the data via import wiard */
/* NOTE: datetime format used is  "%d-%B-%Y" */
/*Only Twwo columns are chosen from the CSV Files*/
-- 1.Date
-- 2.Close Price
 



/*Calculating Moving Average for 20 and 50 Days for Bajaj 
and creating the new table*/

CREATE TABLE bajaj1 AS 
SELECT  Date ,`Close Price`,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS MA20,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS MA50
FROM `bajaj auto`
ORDER BY date;


/*Calculating Moving Average for 20 and 50 Days for Eicher Motors 
and creating the new table*/

CREATE TABLE eicher1 AS 
SELECT  Date ,`Close Price`,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS MA20,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS MA50
FROM `eicher motors`
ORDER BY date;


/*Calculating Moving Average for 20 and 50 Days for Hero Motorcorps 
and creating the new table*/

CREATE TABLE hero1 AS 
SELECT  Date ,`Close Price`,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS MA20,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS MA50
FROM `hero motocorp`
ORDER BY date;


/*Calculating Moving Average for 20 and 50 Days for Infosys 
and creating the new table*/

CREATE TABLE infosys1 as 
SELECT  Date ,`Close Price`,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS MA20,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS MA50
FROM infosys
ORDER BY date;


/*Calculating Moving Average for 20 and 50 Days for TVS 
and creating the new table*/

CREATE TABLE tvs1 as 
SELECT  Date ,`Close Price`,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS MA20,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS MA50
FROM `tvs motors`
ORDER BY date;


/*Calculating Moving Average for 20 and 50 Days for TCS 
and creating the new table*/

CREATE TABLE tcs1 as 
SELECT  Date ,`Close Price`,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 19 PRECEDING) AS MA20,
AVG(`Close Price`) OVER (ORDER BY Date ASC ROWS 49 PRECEDING) AS MA50
FROM tcs
ORDER BY date;


/*Creating master table which contains the Date and Closing Price of all the stocks*/
CREATE TABLE master_stocks AS SELECT b.Date,
    b.`Close Price` AS Bajaj,
    tc.`Close Price` AS TCS,
    tv.`Close Price` AS TVS,
    i.`Close Price` AS Infosys,
    e.`Close Price` AS Eicher,
    h.`Close Price` AS Hero FROM
    bajaj1 b,
    eicher1 e,
    hero1 h,
    infosys1 i,
    tcs1 tc,
    tvs1 tv
WHERE
    b.Date = tc.Date AND tc.Date = tv.Date
        AND tv.Date = i.Date
        AND i.Date = e.Date
        AND e.Date = h.Date;

SELECT * FROM master_stocks;

/* Generate Buy/Sell Signal */
CREATE TABLE bajaj2 (
    `Date` DATE,
    `Close_Price` DECIMAL(10 , 2 ),
    `Signal` VARCHAR(10)
);

-- Copying the schema of bajaj2 for other tables

CREATE TABLE tcs2 LIKE bajaj2;
CREATE TABLE tvs2 LIKE bajaj2;
CREATE TABLE infosys2 LIKE bajaj2;
CREATE TABLE hero2 LIKE bajaj2;
CREATE TABLE eicher2 LIKE bajaj2;


/*Generating the buy/sell signal*/
-- Here we need to take into consideration that, We have calculated Moving Average of 50 rows and hence it will be valid after 50 rows onward only.
-- Hence, marking first 49 values as "NA"alter

insert into bajaj2 (date,Close_Price,`signal`) 
	select date, `Close Price`,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when MA20 > MA50 and (lag(MA20,1) over (order by date)) < (lag(MA50,1) over (order by date)) 
				then 'Buy'
			when MA20 < MA50 and (lag(MA20,1) over (order by date)) > (lag(MA50,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	FROM  bajaj1
   	ORDER BY date; 
    
Select * from bajaj2;
insert into eicher2 (date,Close_Price,`signal`) 
	select date, `Close Price`,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when MA20 > MA50 and (lag(MA20,1) over (order by date)) < (lag(MA50,1) over (order by date)) 
				then 'Buy'
			when MA20 < MA50 and (lag(MA20,1) over (order by date)) > (lag(MA50,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	FROM  eicher1
   	ORDER BY date; 
    
insert into infosys2 (date,Close_Price,`signal`) 
	select date, `Close Price`,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when MA20 > MA50 and (lag(MA20,1) over (order by date)) < (lag(MA50,1) over (order by date)) 
				then 'Buy'
			when MA20 < MA50 and (lag(MA20,1) over (order by date)) > (lag(MA50,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	FROM  infosys1
   	ORDER BY date; 
    
insert into tvs2 (date,Close_Price,`signal`) 
	select date, `Close Price`,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when MA20 > MA50 and (lag(MA20,1) over (order by date)) < (lag(MA50,1) over (order by date)) 
				then 'Buy'
			when MA20 < MA50 and (lag(MA20,1) over (order by date)) > (lag(MA50,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	FROM  tvs1
   	ORDER BY date; 

insert into tcs2 (date,Close_Price,`signal`) 
	select date, `Close Price`,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when MA20 > MA50 and (lag(MA20,1) over (order by date)) < (lag(MA50,1) over (order by date)) 
				then 'Buy'
			when MA20 < MA50 and (lag(MA20,1) over (order by date)) > (lag(MA50,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	FROM  tcs1
   	ORDER BY date; 
    
insert into hero2 (date,Close_Price,`signal`) 
	select date, `Close Price`,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when MA20 > MA50 and (lag(MA20,1) over (order by date)) < (lag(MA50,1) over (order by date)) 
				then 'Buy'
			when MA20 < MA50 and (lag(MA20,1) over (order by date)) > (lag(MA50,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	FROM  hero1
   	ORDER BY date; 
    
    
-- view all the tables bajaj2, eicher2, hero2, infosys2, tcs2, tvs2


SELECT * FROM bajaj2;
SELECT * FROM eicher2;
SELECT * FROM hero2;
SELECT * FROM infosys2;
SELECT * FROM tcs2;
SELECT * FROM tvs2;


/*Creating User Defined function that takes the date as input and returns the signal for that particular 
day (Buy/Sell/Hold) for the Bajaj stock*/


DROP FUNCTION IF EXISTS tradeSignalBajaj;

DELIMITER $$

create function tradeSignalBajaj(input_date date) 
  returns varchar(15)
  deterministic
begin   
  declare output_trade_signal_for_bajaj varchar(15);
  
SELECT 
    bajaj2.signal
INTO output_trade_signal_for_bajaj FROM
    bajaj2
WHERE
    date = input_date;
  
  return output_trade_signal_for_bajaj ;
end
  
$$ delimiter ;


/*Running the stored function*/
SELECT TRADESIGNALBAJAJ('2016-10-14') AS trade_signal;


/* Queries for getting insights on the stock analysis */

/* Bajaj */
-- Getting Buy price for Bajaj Share

SELECT date, close_price
FROM bajaj2
WHERE `signal` = 'Buy'
ORDER BY date,close_price
LIMIT 5;

-- Getting Sell price for Bajaj Share
SELECT date, close_price
FROM bajaj2
WHERE `signal` = 'Sell'
ORDER BY date,close_price
LIMIT 5;


SELECT COUNT(*) AS 'Number of Times Bajaj shares can be sold' FROM bajaj2 WHERE `Signal`='SELL';
SELECT COUNT(*) AS 'Number of Times Bajaj shares can be bought' FROM bajaj2 WHERE `Signal`='BUY';

/* Eicher */

-- Getting Buy price for Eicher Share
SELECT date, close_price
FROM eicher2
WHERE `signal` = 'Buy'
ORDER BY date,close_price
LIMIT 5;

-- Getting Sell price for Eicher Share
SELECT date, close_price
FROM eicher2
WHERE `signal` = 'Sell'
ORDER BY date,close_price
LIMIT 5;

SELECT COUNT(*) AS 'Number of Times Eicher shares can be sold' FROM eicher2 WHERE `Signal`='SELL';
SELECT COUNT(*) AS 'Number of Times Eicher shares can be bought' FROM eicher2 WHERE `Signal`='BUY';

/* Hero */

-- Getting Buy price for Eicher Share
SELECT date, close_price
FROM hero2
WHERE `signal` = 'Buy'
ORDER BY date,close_price
LIMIT 5;

-- Getting Sell price for Eicher Share
SELECT date, close_price
FROM hero2
WHERE `signal` = 'Sell'
ORDER BY date,close_price
LIMIT 5;

SELECT COUNT(*) AS 'Number of Times TCS shares can be sold' FROM hero2 WHERE `Signal`='SELL';
SELECT COUNT(*) AS 'Number of Times TCS shares can be bought' FROM hero2 WHERE `Signal`='BUY';

/* Infosys */

-- Getting Buy price for infosys Share
SELECT date, close_price
FROM infosys2
WHERE `signal` = 'Buy'
ORDER BY date,close_price
LIMIT 5;

-- Getting Sell price for Eicher Share
SELECT date, close_price
FROM infosys2
WHERE `signal` = 'Sell'
ORDER BY date,close_price
LIMIT 5;

SELECT COUNT(*) AS 'Number of Times Infosys shares can be sold' FROM infosys2 WHERE `Signal`='SELL';
SELECT COUNT(*) AS 'Number of Times Infosys shares can be bought' FROM infosys2 WHERE `Signal`='BUY';
 
 
/* TVS */

-- Getting Buy price for infosys Share
SELECT date, close_price
FROM tvs2
WHERE `signal` = 'Buy'
ORDER BY date,close_price
LIMIT 5;

-- Getting Sell price for Eicher Share
SELECT date, close_price
FROM tvs2
WHERE `signal` = 'Sell'
ORDER BY date,close_price
LIMIT 5;

SELECT COUNT(*) AS 'Number of Times TVS shares can be sold' FROM tvs2 WHERE `Signal`='SELL';
SELECT COUNT(*) AS 'Number of Times TVS shares can be bought' FROM tvs2 WHERE `Signal`='BUY';
 

 
/* TCS */

-- Getting Buy price for infosys Share
SELECT date, close_price
FROM tcs2
WHERE `signal` = 'Buy'
ORDER BY date,close_price
LIMIT 5;

-- Getting Sell price for Eicher Share
SELECT date, close_price
FROM tcs2
WHERE `signal` = 'Sell'
ORDER BY date,close_price
LIMIT 5;

SELECT COUNT(*) AS 'Number of Times TCS shares can be sold' FROM tcs2 WHERE `Signal`='SELL';
SELECT COUNT(*) AS 'Number of Times TCS shares can be bought'FROM tcs2 WHERE `Signal`='BUY';

