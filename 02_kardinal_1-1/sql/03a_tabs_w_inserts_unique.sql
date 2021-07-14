-- 3. verbundene Tabellen + Inserts

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
-- Das sollte eigentlich nicht gehen !! --> UNIQUE
INSERT INTO `mydb`.`servants` (`id`, `servant_name`, `yrs_served`, `cats_id`) VALUES (DEFAULT, "Holger", 3, 3);

-- Struktur: DT
SELECT * FROM servants;