-- SELECTS

-- single tables
SELECT * FROM mydb.cats;
SELECT * FROM mydb.servants;

-- Cartesian product
SELECT * FROM mydb.cats JOIN mydb.servants;

-- Inner join 1 / whole table
SELECT
	*
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
;

-- Inner join 2 / selected columns (who serves whom?)
SELECT
	cat_name AS Cat,
    servant_name AS Servant
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
#WHERE cat_name = "Grizabella"
WHERE servant_name = "Juniad"
;

-- Inner join 2a / (who serves whom?)
-- "X is servant to Y"
SELECT
	concat(servant_name, " is servant to ", cat_name, ".") AS servicerelationship
    #cat_name AS Cat,
    #servant_name AS Servant
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
#WHERE cat_name = "Alonzo"
#WHERE cat_name = "Grizabella"
WHERE servant_name = "Holger"
;

-- Inner join 3 / servicetime
-- sorted descending
SELECT
	servant_name AS servant,
    yrs_served AS servicetime
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
ORDER BY yrs_served DESC
;

-- Inner Join 4 / 
-- "X - der Diener von Y -  ist der Diener mit der längsten Dienstzeit" // MAX()