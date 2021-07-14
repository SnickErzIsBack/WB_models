-- Vorbereitung
DROP DATABASE IF EXISTS mydb;
CREATE DATABASE mydb;
USE mydb;

-- Mastertabelle (MT): unverändert
CREATE TABLE IF NOT EXISTS `mydb`.`cats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cat_name` VARCHAR(45) NOT NULL,
  `fur_color` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- Struktur: MT
DESCRIBE cats;

-- Inserts: MT (Mastertable)
INSERT INTO `mydb`.`cats` (`id`, `cat_name`, `fur_color`) VALUES (DEFAULT, "Grizabella", "white");
INSERT INTO `mydb`.`cats` (`id`, `cat_name`, `fur_color`) VALUES (DEFAULT, "Alonzo", "grey");
INSERT INTO `mydb`.`cats` (`id`, `cat_name`, `fur_color`) VALUES (DEFAULT, "Mausi", "striped");

-- Inhalte: MT
SELECT * FROM cats;

-- Detailtabelle (DT): Verbindung zur MT über Fremdschlüssel
CREATE TABLE IF NOT EXISTS `mydb`.`servants` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `servant_name` VARCHAR(45) NOT NULL,
  `yrs_served` INT NOT NULL,
  `cats_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_servants_cats_idx` (`cats_id` ASC) ,
  UNIQUE INDEX `cats_id_UNIQUE` (`cats_id` ASC) ,
  CONSTRAINT `fk_servants_cats`
    FOREIGN KEY (`cats_id`)
    REFERENCES `mydb`.`cats` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Struktur: DT
DESCRIBE servants;

-- Inserts: DT (Detailtable)
INSERT INTO `mydb`.`servants` (`id`, `servant_name`, `yrs_served`, `cats_id`) VALUES (DEFAULT, "Peter", 5, 1);
INSERT INTO `mydb`.`servants` (`id`, `servant_name`, `yrs_served`, `cats_id`) VALUES (DEFAULT, "Juniad", 2, 2);
INSERT INTO `mydb`.`servants` (`id`, `servant_name`, `yrs_served`, `cats_id`) VALUES (DEFAULT, "Holger", 3, 3);

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

/* -- INNER JOIN 4 | Dienstzeit -- "X - der ... x Jan-Daniel Martin & Sven-Marc Tigges
-- "X - der Diener von Y - ist der Diener mit der längsten Dienstzeit" // MAX()
SELECT
servant_name AS "DIENER",
MAX(yrs_served) AS "DIENSTZEIT",
cat_name AS "HERRSCHER",
CONCAT(servant_name, " der Diener von ", cat_name, ", ist der Diener mit der längsten Dienstzeit.") AS "Ausgabe String"
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id;

-- INNER JOIN 4 | Dienstzeit -- "X - der ... x Sven-Marc Tigges
-- "X - der Diener von Y - ist der Diener mit der längsten Dienstzeit" // MAX()
SELECT
MAX(yrs_served) AS "Dienstzeit in Jahren",
CONCAT(servant_name, " der diener von ", cat_name," ist der Diener mit der Längsten Dienstzeit.") AS "Dienstzeit Veteran"
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
;

-- INNER JOIN 4 | Dienstzeit -- "X - der ... x Jan-Daniel Martin
-- "X - der Diener von Y - ist der Diener mit der längsten Dienstzeit" // MAX()
SELECT
CONCAT(servant_name, " der Diener von ", cat_name, ", ist der Diener mit der längsten Dienstzeit.") AS "Ausgabe String"
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
WHERE yrs_served = (SELECT MAX(yrs_served) FROM mydb.servants)
;
*/

-- INNER JOIN 4 | Dienstzeit -- Variant with SUBQUERY
-- "X - der Diener von Y - ist der Diener mit der längsten Dienstzeit" // MAX()
-- SUBQUERY
SELECT
	MAX(yrs_served) AS Dienstzeit
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
;

SELECT
CONCAT(servant_name, ", der Diener von ", cat_name, ", ist der Diener mit der längsten Dienstzeit.") AS Dienstzeit
FROM mydb.cats INNER JOIN mydb.servants
ON cats.id = servants.cats_id
WHERE yrs_served = (
					SELECT
						MAX(yrs_served) AS Dienstzeit
					FROM mydb.cats INNER JOIN mydb.servants
					ON cats.id = servants.cats_id
					)
;