-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema travel
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `travel` ;

-- -----------------------------------------------------
-- Schema travel
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `travel` DEFAULT CHARACTER SET utf8 ;
USE `travel` ;

-- -----------------------------------------------------
-- Table `travel`.`airlines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`airlines` ;

CREATE TABLE IF NOT EXISTS `travel`.`airlines` (
  `airlines_id` INT NOT NULL AUTO_INCREMENT,
  `airlines_iata_code` CHAR(5) NOT NULL,
  `airlines_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`airlines_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`aircraft`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`aircraft` ;

CREATE TABLE IF NOT EXISTS `travel`.`aircraft` (
  `aircraft_id` INT NOT NULL AUTO_INCREMENT,
  `aircraft_manufacturer` VARCHAR(45) NOT NULL,
  `aircraft_model` VARCHAR(45) NOT NULL,
  `aircraft_year` INT NOT NULL,
  `aircraft_tailnum` VARCHAR(45) NOT NULL,
  `aircraft_seats` INT NOT NULL,
  `airlines_id` INT NOT NULL,
  PRIMARY KEY (`aircraft_id`),
  INDEX `fk_aircraft_airlines1_idx` (`airlines_id` ASC) VISIBLE,
  CONSTRAINT `fk_aircraft_airlines1`
    FOREIGN KEY (`airlines_id`)
    REFERENCES `travel`.`airlines` (`airlines_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`state` ;

CREATE TABLE IF NOT EXISTS `travel`.`state` (
  `state_id` INT NOT NULL AUTO_INCREMENT,
  `state_name_abbreviation` CHAR(2) NOT NULL,
  `state_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`state_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`city` ;

CREATE TABLE IF NOT EXISTS `travel`.`city` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(45) NOT NULL,
  `state_id` INT NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `fk_city_state1_idx` (`state_id` ASC) VISIBLE,
  CONSTRAINT `fk_city_state1`
    FOREIGN KEY (`state_id`)
    REFERENCES `travel`.`state` (`state_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`airport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`airport` ;

CREATE TABLE IF NOT EXISTS `travel`.`airport` (
  `airport_id` INT NOT NULL AUTO_INCREMENT,
  `airport_iata_code` CHAR(5) NOT NULL,
  `airport_name` VARCHAR(80) NOT NULL,
  `city_id` INT NOT NULL,
  PRIMARY KEY (`airport_id`),
  INDEX `fk_airport_city1_idx` (`city_id` ASC) VISIBLE,
  CONSTRAINT `fk_airport_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `travel`.`city` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`flight`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`flight` ;

CREATE TABLE IF NOT EXISTS `travel`.`flight` (
  `flight_id` INT NOT NULL AUTO_INCREMENT,
  `flight_departure_date_time` DATETIME NOT NULL,
  `flight_duration_minutes` INT NOT NULL,
  `flight_distance` DECIMAL NOT NULL,
  `flight_base_price` DECIMAL(10,2) NOT NULL,
  `aircraft_id` INT NOT NULL,
  `origin_id` INT NOT NULL,
  `destination_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  INDEX `fk_flight_airplane1_idx` (`aircraft_id` ASC) VISIBLE,
  INDEX `fk_flight_origin1_idx` (`origin_id` ASC) VISIBLE,
  INDEX `fk_flight_destination1_idx` (`destination_id` ASC) VISIBLE,
  CONSTRAINT `fk_flight_airplane1`
    FOREIGN KEY (`aircraft_id`)
    REFERENCES `travel`.`aircraft` (`aircraft_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_origin1`
    FOREIGN KEY (`origin_id`)
    REFERENCES `travel`.`airport` (`airport_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_destination1`
    FOREIGN KEY (`destination_id`)
    REFERENCES `travel`.`airport` (`airport_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`traveler`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`traveler` ;

CREATE TABLE IF NOT EXISTS `travel`.`traveler` (
  `traveler_id` INT NOT NULL AUTO_INCREMENT,
  `traveler_first_name` VARCHAR(45) NOT NULL,
  `traveler_last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`traveler_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`class` ;

CREATE TABLE IF NOT EXISTS `travel`.`class` (
  `class_id` INT NOT NULL AUTO_INCREMENT,
  `class_type` VARCHAR(45) NOT NULL,
  `class_seat_ratio` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`class_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`reservation` ;

CREATE TABLE IF NOT EXISTS `travel`.`reservation` (
  `reservation_id` INT NOT NULL AUTO_INCREMENT,
  `traveler_id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `reservation_tickets` INT NOT NULL DEFAULT 1,
  `reservation_date_time` DATETIME NOT NULL,
  PRIMARY KEY (`reservation_id`),
  INDEX `fk_reservation_customer1_idx` (`traveler_id` ASC) VISIBLE,
  INDEX `fk_reservation_class1_idx` (`class_id` ASC) VISIBLE,
  CONSTRAINT `fk_reservation_customer1`
    FOREIGN KEY (`traveler_id`)
    REFERENCES `travel`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `travel`.`class` (`class_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`payment_card_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`payment_card_type` ;

CREATE TABLE IF NOT EXISTS `travel`.`payment_card_type` (
  `payment_card_type_id` INT NOT NULL AUTO_INCREMENT,
  `payment_card_type_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`payment_card_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`payment_card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`payment_card` ;

CREATE TABLE IF NOT EXISTS `travel`.`payment_card` (
  `payment_card_id` INT NOT NULL AUTO_INCREMENT,
  `payment_card_number` VARCHAR(45) NOT NULL,
  `payment_card_expiration_date` DATETIME NOT NULL,
  `payment_card_cvc` CHAR(5) NOT NULL,
  `customer_id` INT NOT NULL,
  `payment_card_type_id` INT NOT NULL,
  PRIMARY KEY (`payment_card_id`),
  INDEX `fk_payment_card_customer1_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_payment_card_payment_card_type1_idx` (`payment_card_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_payment_card_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `travel`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_card_payment_card_type1`
    FOREIGN KEY (`payment_card_type_id`)
    REFERENCES `travel`.`payment_card_type` (`payment_card_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`price_factor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`price_factor` ;

CREATE TABLE IF NOT EXISTS `travel`.`price_factor` (
  `airlines_id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `price_factor` DECIMAL(5,2) NOT NULL,
  INDEX `fk_airlines_has_class_class1_idx` (`class_id` ASC) VISIBLE,
  INDEX `fk_airlines_has_class_airlines1_idx` (`airlines_id` ASC) VISIBLE,
  PRIMARY KEY (`airlines_id`, `class_id`),
  CONSTRAINT `fk_airlines_has_class_airlines1`
    FOREIGN KEY (`airlines_id`)
    REFERENCES `travel`.`airlines` (`airlines_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_airlines_has_class_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `travel`.`class` (`class_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`phone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`phone` ;

CREATE TABLE IF NOT EXISTS `travel`.`phone` (
  `phone_id` INT NOT NULL AUTO_INCREMENT,
  `phone_number` CHAR(12) NOT NULL,
  `traveler_id` INT NOT NULL,
  PRIMARY KEY (`phone_id`),
  INDEX `fk_phone_customer1_idx` (`traveler_id` ASC) VISIBLE,
  CONSTRAINT `fk_phone_customer1`
    FOREIGN KEY (`traveler_id`)
    REFERENCES `travel`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`email`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`email` ;

CREATE TABLE IF NOT EXISTS `travel`.`email` (
  `email_id` INT NOT NULL AUTO_INCREMENT,
  `email_address` VARCHAR(45) NOT NULL,
  `traveler_id` INT NOT NULL,
  PRIMARY KEY (`email_id`),
  INDEX `fk_email_customer1_idx` (`traveler_id` ASC) VISIBLE,
  CONSTRAINT `fk_email_customer1`
    FOREIGN KEY (`traveler_id`)
    REFERENCES `travel`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`trip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`trip` ;

CREATE TABLE IF NOT EXISTS `travel`.`trip` (
  `flight_id` INT NOT NULL,
  `reservation_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`, `reservation_id`),
  INDEX `fk_flight_has_reservation_reservation1_idx` (`reservation_id` ASC) VISIBLE,
  INDEX `fk_flight_has_reservation_flight1_idx` (`flight_id` ASC) VISIBLE,
  CONSTRAINT `fk_flight_has_reservation_flight1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `travel`.`flight` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_has_reservation_reservation1`
    FOREIGN KEY (`reservation_id`)
    REFERENCES `travel`.`reservation` (`reservation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel`.`connection`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel`.`connection` ;

CREATE TABLE IF NOT EXISTS `travel`.`connection` (
  `flight_id` INT NOT NULL,
  `trip_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`, `trip_id`),
  INDEX `fk_flight_has_trip_flight1_idx` (`flight_id` ASC) VISIBLE,
  CONSTRAINT `fk_flight_has_trip_flight1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `travel`.`flight` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE travel ; 

INSERT INTO airlines VALUES ('1','9E','Endeavor Air Inc.') ; 
INSERT INTO airlines VALUES ('2','AA','American Airlines Inc.') ; 
INSERT INTO airlines VALUES ('3','AS','Alaska Airlines Inc.') ; 
INSERT INTO airlines VALUES ('4','B6','JetBlue Airways') ; 
INSERT INTO airlines VALUES ('5','DL','Delta Air Lines Inc.') ; 
INSERT INTO airlines VALUES ('6','EV','ExpressJet Airlines Inc.') ; 
INSERT INTO airlines VALUES ('7','F9','Frontier Airlines Inc.') ; 
INSERT INTO airlines VALUES ('8','FL','AirTran Airways Corporation') ; 
INSERT INTO airlines VALUES ('9','HA','Hawaiian Airlines Inc.') ; 
INSERT INTO airlines VALUES ('10','MQ','Envoy Air') ; 
INSERT INTO airlines VALUES ('11','OO','SkyWest Airlines Inc.') ; 
INSERT INTO airlines VALUES ('12','UA','United Air Lines Inc.') ; 
INSERT INTO airlines VALUES ('13','US','US Airways Inc.') ; 
INSERT INTO airlines VALUES ('14','VX','Virgin America') ; 
INSERT INTO airlines VALUES ('15','WN','Southwest Airlines Co.') ; 
INSERT INTO airlines VALUES ('16','YV','Mesa Airlines Inc.') ; 

INSERT INTO aircraft VALUES ('1','AIRBUS','A320-214','2010','N127UW','182','7') ; 
INSERT INTO aircraft VALUES ('2','AIRBUS','A320-214','2010','N128UW','182','7') ; 
INSERT INTO aircraft VALUES ('3','AIRBUS','A320-214','2010','N205FR','182','11') ; 
INSERT INTO aircraft VALUES ('4','AIRBUS','A320-214','2010','N206FR','182','3') ; 
INSERT INTO aircraft VALUES ('5','AIRBUS','A320-214','2010','N207FR','182','8') ; 
INSERT INTO aircraft VALUES ('6','AIRBUS','A330-243','2010','N380HA','377','16') ; 
INSERT INTO aircraft VALUES ('7','AIRBUS','A330-243','2010','N381HA','377','1') ; 
INSERT INTO aircraft VALUES ('8','AIRBUS','A330-243','2010','N382HA','377','4') ; 
INSERT INTO aircraft VALUES ('9','AIRBUS','A320-214','2010','N835VA','182','14') ; 
INSERT INTO aircraft VALUES ('10','AIRBUS','A320-214','2010','N836VA','182','2') ; 
INSERT INTO aircraft VALUES ('11','AIRBUS','A319-112','2010','N952FR','100','6') ; 
INSERT INTO aircraft VALUES ('12','AIRBUS','A319-112','2010','N953FR','100','15') ; 
INSERT INTO aircraft VALUES ('13','AIRBUS','A320-214','2011','N208FR','182','16') ; 
INSERT INTO aircraft VALUES ('14','AIRBUS','A320-214','2011','N209FR','182','11') ; 
INSERT INTO aircraft VALUES ('15','AIRBUS','A320-214','2011','N210FR','182','3') ; 
INSERT INTO aircraft VALUES ('16','AIRBUS','A320-214','2011','N211FR','182','16') ; 
INSERT INTO aircraft VALUES ('17','AIRBUS','A320-214','2011','N213FR','182','5') ; 
INSERT INTO aircraft VALUES ('18','AIRBUS','A320-214','2011','N214FR','182','7') ; 
INSERT INTO aircraft VALUES ('19','AIRBUS','A320-214','2011','N216FR','182','11') ; 
INSERT INTO aircraft VALUES ('20','AIRBUS','A330-243','2011','N383HA','377','3') ; 
INSERT INTO aircraft VALUES ('21','AIRBUS','A330-243','2011','N384HA','377','16') ; 
INSERT INTO aircraft VALUES ('22','AIRBUS','A321-231','2011','N543UW','379','2') ; 
INSERT INTO aircraft VALUES ('23','AIRBUS','A321-231','2011','N544UW','379','8') ; 
INSERT INTO aircraft VALUES ('24','AIRBUS','A321-231','2011','N545UW','379','2') ; 
INSERT INTO aircraft VALUES ('25','AIRBUS','A321-231','2011','N546UW','379','7') ; 
INSERT INTO aircraft VALUES ('26','AIRBUS','A321-231','2011','N547UW','379','6') ; 
INSERT INTO aircraft VALUES ('27','AIRBUS','A321-231','2011','N548UW','379','4') ; 
INSERT INTO aircraft VALUES ('28','AIRBUS','A321-231','2011','N549UW','379','15') ; 
INSERT INTO aircraft VALUES ('29','AIRBUS','A321-231','2011','N550UW','379','7') ; 
INSERT INTO aircraft VALUES ('30','AIRBUS','A321-231','2011','N551UW','379','6') ; 
INSERT INTO aircraft VALUES ('31','AIRBUS','A321-231','2011','N552UW','379','8') ; 
INSERT INTO aircraft VALUES ('32','AIRBUS','A321-231','2011','N553UW','379','11') ; 
INSERT INTO aircraft VALUES ('33','AIRBUS','A321-231','2011','N554UW','379','7') ; 
INSERT INTO aircraft VALUES ('34','AIRBUS','A320-232','2011','N784JB','200','3') ; 
INSERT INTO aircraft VALUES ('35','AIRBUS','A320-232','2011','N789JB','200','4') ; 
INSERT INTO aircraft VALUES ('36','AIRBUS','A320-232','2011','N793JB','200','2') ; 
INSERT INTO aircraft VALUES ('37','AIRBUS','A320-232','2011','N794JB','200','16') ; 
INSERT INTO aircraft VALUES ('38','AIRBUS','A320-214','2011','N837VA','182','12') ; 
INSERT INTO aircraft VALUES ('39','AIRBUS','A320-214','2011','N838VA','182','1') ; 
INSERT INTO aircraft VALUES ('40','AIRBUS','A320-214','2011','N839VA','182','2') ; 
INSERT INTO aircraft VALUES ('41','AIRBUS','A320-214','2011','N840VA','182','1') ; 
INSERT INTO aircraft VALUES ('42','AIRBUS','A320-214','2011','N842VA','182','6') ; 
INSERT INTO aircraft VALUES ('43','AIRBUS','A320-214','2011','N843VA','182','8') ; 
INSERT INTO aircraft VALUES ('44','AIRBUS','A320-214','2011','N844VA','182','5') ; 
INSERT INTO aircraft VALUES ('45','AIRBUS','A320-214','2011','N845VA','182','2') ; 
INSERT INTO aircraft VALUES ('46','AIRBUS','A320-214','2011','N846VA','182','11') ; 
INSERT INTO aircraft VALUES ('47','AIRBUS','A320-214','2011','N847VA','182','4') ; 
INSERT INTO aircraft VALUES ('48','AIRBUS','A320-214','2011','N848VA','182','7') ; 
INSERT INTO aircraft VALUES ('49','AIRBUS','A330-243','2012','N385HA','377','12') ; 
INSERT INTO aircraft VALUES ('50','AIRBUS','A330-243','2012','N386HA','377','13') ; 
INSERT INTO aircraft VALUES ('51','AIRBUS','A330-243','2012','N388HA','377','4') ; 
INSERT INTO aircraft VALUES ('52','AIRBUS','A321-231','2012','N555AY','379','3') ; 
INSERT INTO aircraft VALUES ('53','AIRBUS','A321-231','2012','N556UW','379','1') ; 
INSERT INTO aircraft VALUES ('54','AIRBUS','A321-231','2012','N557UW','379','10') ; 
INSERT INTO aircraft VALUES ('55','AIRBUS','A321-231','2012','N558UW','379','7') ; 
INSERT INTO aircraft VALUES ('56','AIRBUS','A321-231','2012','N559UW','379','2') ; 
INSERT INTO aircraft VALUES ('57','AIRBUS','A321-231','2012','N560UW','379','10') ; 
INSERT INTO aircraft VALUES ('58','AIRBUS','A321-231','2012','N561UW','379','16') ; 
INSERT INTO aircraft VALUES ('59','AIRBUS','A321-231','2012','N562UW','379','11') ; 
INSERT INTO aircraft VALUES ('60','AIRBUS','A321-231','2012','N563UW','379','11') ; 
INSERT INTO aircraft VALUES ('61','AIRBUS','A321-231','2012','N564UW','379','6') ; 
INSERT INTO aircraft VALUES ('62','AIRBUS','A321-231','2012','N565UW','379','2') ; 
INSERT INTO aircraft VALUES ('63','AIRBUS','A321-231','2012','N566UW','379','6') ; 
INSERT INTO aircraft VALUES ('64','AIRBUS','A320-232','2012','N796JB','200','3') ; 
INSERT INTO aircraft VALUES ('65','AIRBUS','A320-232','2012','N804JB','200','13') ; 
INSERT INTO aircraft VALUES ('66','AIRBUS','A320-232','2012','N805JB','200','15') ; 
INSERT INTO aircraft VALUES ('67','AIRBUS','A320-232','2012','N806JB','200','7') ; 
INSERT INTO aircraft VALUES ('68','AIRBUS','A320-232','2012','N807JB','200','5') ; 
INSERT INTO aircraft VALUES ('69','AIRBUS','A320-232','2012','N809JB','200','2') ; 
INSERT INTO aircraft VALUES ('70','AIRBUS','A320-232','2012','N821JB','200','5') ; 
INSERT INTO aircraft VALUES ('71','AIRBUS','A320-214','2012','N849VA','182','3') ; 
INSERT INTO aircraft VALUES ('72','AIRBUS','A320-214','2012','N851VA','182','13') ; 
INSERT INTO aircraft VALUES ('73','AIRBUS','A320-214','2012','N852VA','182','2') ; 
INSERT INTO aircraft VALUES ('74','AIRBUS','A320-214','2012','N853VA','182','11') ; 
INSERT INTO aircraft VALUES ('75','AIRBUS','A320-214','2012','N854VA','182','10') ; 
INSERT INTO aircraft VALUES ('76','AIRBUS','A320-214','2012','N855VA','182','4') ; 
INSERT INTO aircraft VALUES ('77','AIRBUS','A321-211','2013','N150UW','199','2') ; 
INSERT INTO aircraft VALUES ('78','AIRBUS','A321-211','2013','N151UW','199','11') ; 
INSERT INTO aircraft VALUES ('79','AIRBUS','A321-211','2013','N152UW','199','14') ; 
INSERT INTO aircraft VALUES ('80','AIRBUS','A321-211','2013','N153UW','199','14') ; 
INSERT INTO aircraft VALUES ('81','AIRBUS','A321-211','2013','N154UW','199','13') ; 
INSERT INTO aircraft VALUES ('82','AIRBUS','A321-211','2013','N155UW','199','16') ; 
INSERT INTO aircraft VALUES ('83','AIRBUS','A321-211','2013','N156UW','199','16') ; 
INSERT INTO aircraft VALUES ('84','AIRBUS','A321-211','2013','N157UW','199','13') ; 
INSERT INTO aircraft VALUES ('85','AIRBUS','A321-211','2013','N198UW','199','10') ; 
INSERT INTO aircraft VALUES ('86','AIRBUS','A321-211','2013','N199UW','199','9') ; 
INSERT INTO aircraft VALUES ('87','AIRBUS','A320-214','2013','N361VA','182','7') ; 
INSERT INTO aircraft VALUES ('88','AIRBUS','A330-243','2013','N390HA','377','8') ; 
INSERT INTO aircraft VALUES ('89','AIRBUS','A330-243','2013','N391HA','377','8') ; 
INSERT INTO aircraft VALUES ('90','AIRBUS','A330-243','2013','N392HA','377','2') ; 
INSERT INTO aircraft VALUES ('91','AIRBUS','A330-243','2013','N393HA','377','14') ; 
INSERT INTO aircraft VALUES ('92','AIRBUS','A330-243','2013','N395HA','377','14') ; 
INSERT INTO aircraft VALUES ('93','AIRBUS','A321-231','2013','N567UW','379','14') ; 
INSERT INTO aircraft VALUES ('94','AIRBUS','A321-231','2013','N568UW','379','13') ; 
INSERT INTO aircraft VALUES ('95','AIRBUS','A321-231','2013','N569UW','379','11') ; 
INSERT INTO aircraft VALUES ('96','AIRBUS','A321-231','2013','N570UW','379','1') ; 
INSERT INTO aircraft VALUES ('97','AIRBUS','A321-231','2013','N571UW','379','16') ; 
INSERT INTO aircraft VALUES ('98','AIRBUS','A320-232','2013','N827JB','200','6') ; 
INSERT INTO aircraft VALUES ('99','AIRBUS','A320-232','2013','N828JB','200','4') ; 
INSERT INTO aircraft VALUES ('100','AIRBUS','A320-232','2013','N834JB','200','14') ; 
INSERT INTO aircraft VALUES ('101','AIRBUS','A321-231','2013','N903JB','379','5') ; 
INSERT INTO aircraft VALUES ('102','AIRBUS','A321-231','2013','N913JB','379','15') ; 
INSERT INTO aircraft VALUES ('103','BOEING','737-924ER','2010','N36444','191','12') ; 
INSERT INTO aircraft VALUES ('104','BOEING','737-832','2010','N3772H','189','8') ; 
INSERT INTO aircraft VALUES ('105','BOEING','737-832','2010','N3773D','189','3') ; 
INSERT INTO aircraft VALUES ('106','BOEING','737-924ER','2010','N38443','191','15') ; 
INSERT INTO aircraft VALUES ('107','BOEING','737-890','2010','N529AS','149','1') ; 
INSERT INTO aircraft VALUES ('108','BOEING','737-890','2010','N530AS','149','12') ; 
INSERT INTO aircraft VALUES ('109','BOEING','737-890','2010','N531AS','149','9') ; 
INSERT INTO aircraft VALUES ('110','BOEING','737-890','2010','N532AS','149','16') ; 
INSERT INTO aircraft VALUES ('111','BOEING','737-824','2010','N76522','149','12') ; 
INSERT INTO aircraft VALUES ('112','BOEING','737-824','2010','N76523','149','1') ; 
INSERT INTO aircraft VALUES ('113','BOEING','737-824','2010','N76526','149','5') ; 
INSERT INTO aircraft VALUES ('114','BOEING','737-824','2010','N76528','149','12') ; 
INSERT INTO aircraft VALUES ('115','BOEING','737-824','2010','N76529','149','3') ; 
INSERT INTO aircraft VALUES ('116','BOEING','737-824','2010','N77520','149','2') ; 
INSERT INTO aircraft VALUES ('117','BOEING','737-824','2010','N77525','149','12') ; 
INSERT INTO aircraft VALUES ('118','BOEING','737-824','2010','N78524','149','16') ; 
INSERT INTO aircraft VALUES ('119','BOEING','737-824','2010','N79521','149','11') ; 
INSERT INTO aircraft VALUES ('120','BOEING','737-824','2010','N87527','149','1') ; 
INSERT INTO aircraft VALUES ('121','BOEING','737-7H4','2010','N943WN','140','6') ; 
INSERT INTO aircraft VALUES ('122','BOEING','737-7H4','2010','N944WN','140','2') ; 
INSERT INTO aircraft VALUES ('123','BOEING','737-7H4','2010','N945WN','140','3') ; 
INSERT INTO aircraft VALUES ('124','BOEING','737-7H4','2010','N946WN','140','5') ; 
INSERT INTO aircraft VALUES ('125','BOEING','737-7H4','2010','N947WN','140','7') ; 
INSERT INTO aircraft VALUES ('126','BOEING','737-7H4','2010','N948WN','140','7') ; 
INSERT INTO aircraft VALUES ('127','BOEING','737-7H4','2010','N949WN','140','13') ; 
INSERT INTO aircraft VALUES ('128','BOEING','737-7H4','2010','N950WN','140','5') ; 
INSERT INTO aircraft VALUES ('129','BOEING','737-7H4','2010','N951WN','140','6') ; 
INSERT INTO aircraft VALUES ('130','BOEING','737-7H4','2010','N952WN','140','14') ; 
INSERT INTO aircraft VALUES ('131','BOEING','737-7H4','2010','N953WN','140','16') ; 
INSERT INTO aircraft VALUES ('132','BOEING','737-890','2011','N533AS','149','12') ; 
INSERT INTO aircraft VALUES ('133','BOEING','737-890','2011','N534AS','149','11') ; 
INSERT INTO aircraft VALUES ('134','BOEING','737-890','2011','N535AS','149','1') ; 
INSERT INTO aircraft VALUES ('135','BOEING','737-7BD','2011','N555LV','149','4') ; 
INSERT INTO aircraft VALUES ('136','BOEING','737-7BD','2011','N556WN','149','9') ; 
INSERT INTO aircraft VALUES ('137','BOEING','737-924ER','2011','N73445','191','11') ; 
INSERT INTO aircraft VALUES ('138','BOEING','737-824','2011','N77530','149','7') ; 
INSERT INTO aircraft VALUES ('139','BOEING','737-824','2011','N87531','149','3') ; 
INSERT INTO aircraft VALUES ('140','BOEING','737-7H4','2011','N954WN','140','14') ; 
INSERT INTO aircraft VALUES ('141','BOEING','737-7H4','2011','N955WN','140','6') ; 
INSERT INTO aircraft VALUES ('142','BOEING','737-7H4','2011','N956WN','140','4') ; 
INSERT INTO aircraft VALUES ('143','BOEING','737-7H4','2011','N957WN','140','10') ; 
INSERT INTO aircraft VALUES ('144','BOEING','737-7H4','2011','N958WN','140','1') ; 
INSERT INTO aircraft VALUES ('145','BOEING','737-7H4','2011','N959WN','140','15') ; 
INSERT INTO aircraft VALUES ('146','BOEING','737-7H4','2011','N960WN','140','11') ; 
INSERT INTO aircraft VALUES ('147','BOEING','737-7H4','2011','N961WN','140','7') ; 
INSERT INTO aircraft VALUES ('148','BOEING','737-7H4','2011','N962WN','140','10') ; 
INSERT INTO aircraft VALUES ('149','BOEING','737-7H4','2011','N963WN','140','12') ; 
INSERT INTO aircraft VALUES ('150','BOEING','737-7H4','2011','N964WN','140','6') ; 
INSERT INTO aircraft VALUES ('151','BOEING','737-7H4','2011','N965WN','140','7') ; 
INSERT INTO aircraft VALUES ('152','BOEING','737-7H4','2011','N966WN','140','14') ; 
INSERT INTO aircraft VALUES ('153','BOEING','737-7H4','2011','N967WN','140','5') ; 
INSERT INTO aircraft VALUES ('154','BOEING','737-7H4','2011','N968WN','140','2') ; 
INSERT INTO aircraft VALUES ('155','BOEING','737-7H4','2011','N969WN','140','12') ; 
INSERT INTO aircraft VALUES ('156','BOEING','787-8','2012','N20904','260','10') ; 
INSERT INTO aircraft VALUES ('157','BOEING','787-8','2012','N26906','260','5') ; 
INSERT INTO aircraft VALUES ('158','BOEING','787-8','2012','N27901','260','2') ; 
INSERT INTO aircraft VALUES ('159','BOEING','737-924ER','2012','N28457','191','3') ; 
INSERT INTO aircraft VALUES ('160','BOEING','737-924ER','2012','N34455','191','1') ; 
INSERT INTO aircraft VALUES ('161','BOEING','737-924ER','2012','N34460','191','11') ; 
INSERT INTO aircraft VALUES ('162','BOEING','737-924ER','2012','N36447','191','12') ; 
INSERT INTO aircraft VALUES ('163','BOEING','737-924ER','2012','N37456','191','11') ; 
INSERT INTO aircraft VALUES ('164','BOEING','737-924ER','2012','N37462','191','8') ; 
INSERT INTO aircraft VALUES ('165','BOEING','737-924ER','2012','N37464','191','6') ; 
INSERT INTO aircraft VALUES ('166','BOEING','737-924ER','2012','N38446','191','16') ; 
INSERT INTO aircraft VALUES ('167','BOEING','737-924ER','2012','N38451','191','15') ; 
INSERT INTO aircraft VALUES ('168','BOEING','737-924ER','2012','N38454','191','6') ; 
INSERT INTO aircraft VALUES ('169','BOEING','737-924ER','2012','N38458','191','7') ; 
INSERT INTO aircraft VALUES ('170','BOEING','737-924ER','2012','N38459','191','7') ; 
INSERT INTO aircraft VALUES ('171','BOEING','737-924ER','2012','N39450','191','10') ; 
INSERT INTO aircraft VALUES ('172','BOEING','737-924ER','2012','N39461','191','10') ; 
INSERT INTO aircraft VALUES ('173','BOEING','737-924ER','2012','N39463','191','8') ; 
INSERT INTO aircraft VALUES ('174','BOEING','737-990ER','2012','N402AS','222','10') ; 
INSERT INTO aircraft VALUES ('175','BOEING','737-990ER','2012','N403AS','222','11') ; 
INSERT INTO aircraft VALUES ('176','BOEING','737-990ER','2012','N407AS','222','2') ; 
INSERT INTO aircraft VALUES ('177','BOEING','737-990ER','2012','N408AS','222','13') ; 
INSERT INTO aircraft VALUES ('178','BOEING','787-8','2012','N45905','260','9') ; 
INSERT INTO aircraft VALUES ('179','BOEING','737-890','2012','N536AS','149','1') ; 
INSERT INTO aircraft VALUES ('180','BOEING','737-890','2012','N537AS','149','5') ; 
INSERT INTO aircraft VALUES ('181','BOEING','737-890','2012','N538AS','149','8') ; 
INSERT INTO aircraft VALUES ('182','BOEING','737-924ER','2012','N68452','191','14') ; 
INSERT INTO aircraft VALUES ('183','BOEING','737-924ER','2012','N68453','191','16') ; 
INSERT INTO aircraft VALUES ('184','BOEING','737-924ER','2012','N78448','191','10') ; 
INSERT INTO aircraft VALUES ('185','BOEING','737-924ER','2012','N81449','191','6') ; 
INSERT INTO aircraft VALUES ('186','BOEING','737-8H4','2012','N8301J','140','6') ; 
INSERT INTO aircraft VALUES ('187','BOEING','737-8H4','2012','N8302F','140','14') ; 
INSERT INTO aircraft VALUES ('188','BOEING','737-8H4','2012','N8305E','140','3') ; 
INSERT INTO aircraft VALUES ('189','BOEING','737-8H4','2012','N8306H','140','2') ; 
INSERT INTO aircraft VALUES ('190','BOEING','737-8H4','2012','N8307K','140','10') ; 
INSERT INTO aircraft VALUES ('191','BOEING','737-8H4','2012','N8308K','140','9') ; 
INSERT INTO aircraft VALUES ('192','BOEING','737-8H4','2012','N8309C','140','15') ; 
INSERT INTO aircraft VALUES ('193','BOEING','737-8H4','2012','N8310C','140','16') ; 
INSERT INTO aircraft VALUES ('194','BOEING','737-8H4','2012','N8311Q','140','12') ; 
INSERT INTO aircraft VALUES ('195','BOEING','737-8H4','2012','N8312C','140','12') ; 
INSERT INTO aircraft VALUES ('196','BOEING','737-8H4','2012','N8313F','140','13') ; 
INSERT INTO aircraft VALUES ('197','BOEING','737-8H4','2012','N8314L','140','9') ; 
INSERT INTO aircraft VALUES ('198','BOEING','737-8H4','2012','N8315C','140','10') ; 
INSERT INTO aircraft VALUES ('199','BOEING','737-8H4','2012','N8316H','140','4') ; 
INSERT INTO aircraft VALUES ('200','BOEING','737-8H4','2012','N8317M','140','3') ; 
INSERT INTO aircraft VALUES ('201','BOEING','737-8H4','2012','N8318F','140','8') ; 
INSERT INTO aircraft VALUES ('202','BOEING','737-8H4','2012','N8319F','140','7') ; 
INSERT INTO aircraft VALUES ('203','BOEING','737-8H4','2012','N8320J','140','13') ; 
INSERT INTO aircraft VALUES ('204','BOEING','737-8H4','2012','N8321D','140','14') ; 
INSERT INTO aircraft VALUES ('205','BOEING','737-8H4','2012','N8322X','140','7') ; 
INSERT INTO aircraft VALUES ('206','BOEING','737-8H4','2012','N8323C','140','9') ; 
INSERT INTO aircraft VALUES ('207','BOEING','737-8H4','2012','N8324A','140','15') ; 
INSERT INTO aircraft VALUES ('208','BOEING','737-8H4','2012','N8325D','140','16') ; 
INSERT INTO aircraft VALUES ('209','BOEING','737-8H4','2012','N8326F','140','13') ; 
INSERT INTO aircraft VALUES ('210','BOEING','737-8H4','2012','N8327A','140','10') ; 
INSERT INTO aircraft VALUES ('211','BOEING','737-8H4','2012','N8328A','140','2') ; 
INSERT INTO aircraft VALUES ('212','BOEING','737-8H4','2012','N8329B','140','5') ; 
INSERT INTO aircraft VALUES ('213','BOEING','737-8H4','2012','N8600F','140','5') ; 
INSERT INTO aircraft VALUES ('214','BOEING','737-8H4','2012','N8601C','140','13') ; 
INSERT INTO aircraft VALUES ('215','BOEING','737-8H4','2012','N8602F','140','1') ; 
INSERT INTO aircraft VALUES ('216','BOEING','737-8H4','2012','N8603F','140','10') ; 
INSERT INTO aircraft VALUES ('217','BOEING','737-8H4','2012','N8604K','140','12') ; 
INSERT INTO aircraft VALUES ('218','BOEING','737-8H4','2012','N8605E','140','15') ; 
INSERT INTO aircraft VALUES ('219','BOEING','737-924ER','2013','N27477','191','15') ; 
INSERT INTO aircraft VALUES ('220','BOEING','737-924ER','2013','N28478','191','2') ; 
INSERT INTO aircraft VALUES ('221','BOEING','737-924ER','2013','N36469','191','6') ; 
INSERT INTO aircraft VALUES ('222','BOEING','737-924ER','2013','N36472','191','14') ; 
INSERT INTO aircraft VALUES ('223','BOEING','737-924ER','2013','N36476','191','15') ; 
INSERT INTO aircraft VALUES ('224','BOEING','737-924ER','2013','N37465','191','10') ; 
INSERT INTO aircraft VALUES ('225','BOEING','737-924ER','2013','N37466','191','16') ; 
INSERT INTO aircraft VALUES ('226','BOEING','737-924ER','2013','N37468','191','7') ; 
INSERT INTO aircraft VALUES ('227','BOEING','737-924ER','2013','N37470','191','6') ; 
INSERT INTO aircraft VALUES ('228','BOEING','737-924ER','2013','N37471','191','8') ; 
INSERT INTO aircraft VALUES ('229','BOEING','737-924ER','2013','N37474','191','16') ; 
INSERT INTO aircraft VALUES ('230','BOEING','737-924ER','2013','N38467','191','1') ; 
INSERT INTO aircraft VALUES ('231','BOEING','737-924ER','2013','N38473','191','11') ; 
INSERT INTO aircraft VALUES ('232','BOEING','737-924ER','2013','N39475','191','13') ; 
INSERT INTO aircraft VALUES ('233','BOEING','737-990ER','2013','N409AS','222','1') ; 
INSERT INTO aircraft VALUES ('234','BOEING','737-990ER','2013','N413AS','222','15') ; 
INSERT INTO aircraft VALUES ('235','BOEING','737-990ER','2013','N419AS','222','10') ; 
INSERT INTO aircraft VALUES ('236','BOEING','737-990ER','2013','N423AS','222','13') ; 
INSERT INTO aircraft VALUES ('237','BOEING','737-990ER','2013','N431AS','222','11') ; 
INSERT INTO aircraft VALUES ('238','BOEING','737-990ER','2013','N433AS','222','5') ; 
INSERT INTO aircraft VALUES ('239','BOEING','737-990ER','2013','N435AS','222','7') ; 
INSERT INTO aircraft VALUES ('240','BOEING','737-990ER','2013','N440AS','222','15') ; 
INSERT INTO aircraft VALUES ('241','BOEING','737-990ER','2013','N442AS','222','14') ; 
INSERT INTO aircraft VALUES ('242','BOEING','737-924ER','2013','N64809','191','11') ; 
INSERT INTO aircraft VALUES ('243','BOEING','737-924ER','2013','N66803','191','4') ; 
INSERT INTO aircraft VALUES ('244','BOEING','737-924ER','2013','N66808','191','13') ; 
INSERT INTO aircraft VALUES ('245','BOEING','737-924ER','2013','N68801','191','10') ; 
INSERT INTO aircraft VALUES ('246','BOEING','737-924ER','2013','N68802','191','3') ; 
INSERT INTO aircraft VALUES ('247','BOEING','737-924ER','2013','N68805','191','6') ; 
INSERT INTO aircraft VALUES ('248','BOEING','737-924ER','2013','N68807','191','16') ; 
INSERT INTO aircraft VALUES ('249','BOEING','737-924ER','2013','N69804','191','8') ; 
INSERT INTO aircraft VALUES ('250','BOEING','737-924ER','2013','N69806','191','11') ; 
INSERT INTO aircraft VALUES ('251','BOEING','737-8H4','2013','N8607M','140','9') ; 
INSERT INTO aircraft VALUES ('252','BOEING','737-8H4','2013','N8608N','140','6') ; 
INSERT INTO aircraft VALUES ('253','BOEING','737-8H4','2013','N8609A','140','12') ; 
INSERT INTO aircraft VALUES ('254','BOEING','737-8H4','2013','N8610A','140','1') ; 
INSERT INTO aircraft VALUES ('255','BOEING','737-8H4','2013','N8611F','140','11') ; 
INSERT INTO aircraft VALUES ('256','BOEING','737-8H4','2013','N8612K','140','1') ; 
INSERT INTO aircraft VALUES ('257','BOEING','737-8H4','2013','N8613K','140','2') ; 
INSERT INTO aircraft VALUES ('258','BOEING','737-8H4','2013','N8614M','140','16') ; 
INSERT INTO aircraft VALUES ('259','BOEING','737-8H4','2013','N8615E','140','16') ; 
INSERT INTO aircraft VALUES ('260','BOEING','737-8H4','2013','N8616C','140','7') ; 
INSERT INTO aircraft VALUES ('261','BOEING','737-8H4','2013','N8617E','140','8') ; 
INSERT INTO aircraft VALUES ('262','BOEING','737-8H4','2013','N8618N','140','2') ; 
INSERT INTO aircraft VALUES ('263','BOEING','737-8H4','2013','N8619F','140','7') ; 
INSERT INTO aircraft VALUES ('264','BOEING','737-8H4','2013','N8620H','140','6') ; 
INSERT INTO aircraft VALUES ('265','BOEING','737-8H4','2013','N8621A','140','1') ; 

INSERT INTO traveler VALUES ('1','Nixie','Tattershall') ; 
INSERT INTO traveler VALUES ('2','Gertrudis','Pues') ; 
INSERT INTO traveler VALUES ('3','Olenolin','Monkeman') ; 
INSERT INTO traveler VALUES ('4','Laurens','Rosenblum') ; 
INSERT INTO traveler VALUES ('5','Darice','Preene') ; 
INSERT INTO traveler VALUES ('6','Cirilo','Fishbourne') ; 
INSERT INTO traveler VALUES ('7','Arne','McMakin') ; 
INSERT INTO traveler VALUES ('8','Cammy','Graybeal') ; 
INSERT INTO traveler VALUES ('9','Damien','Laxon') ; 
INSERT INTO traveler VALUES ('10','Markos','Drain') ; 
INSERT INTO traveler VALUES ('11','Row','Frazier') ; 
INSERT INTO traveler VALUES ('12','Oliver','Vears') ; 
INSERT INTO traveler VALUES ('13','Joella','Asser') ; 
INSERT INTO traveler VALUES ('14','Wainwright','Tingcomb') ; 
INSERT INTO traveler VALUES ('15','Philly','Dobey') ; 
INSERT INTO traveler VALUES ('16','Wendel','Stapford') ; 
INSERT INTO traveler VALUES ('17','Ethelbert','Gerardot') ; 
INSERT INTO traveler VALUES ('18','Josie','Padefield') ; 
INSERT INTO traveler VALUES ('19','Bryan','Cabrales') ; 
INSERT INTO traveler VALUES ('20','Carolan','Callum') ; 
INSERT INTO traveler VALUES ('21','Way','Serman') ; 
INSERT INTO traveler VALUES ('22','Linzy','Sinncock') ; 
INSERT INTO traveler VALUES ('23','Gery','Alderwick') ; 
INSERT INTO traveler VALUES ('24','Brenden','Mepsted') ; 
INSERT INTO traveler VALUES ('25','Ferguson','Joynes') ; 
INSERT INTO traveler VALUES ('26','Mimi','Flute') ; 
INSERT INTO traveler VALUES ('27','Cam','Spat') ; 
INSERT INTO traveler VALUES ('28','Findlay','Lenihan') ; 
INSERT INTO traveler VALUES ('29','Page','Mealiffe') ; 
INSERT INTO traveler VALUES ('30','Davin','Creeghan') ; 
INSERT INTO traveler VALUES ('31','Lorin','Raittie') ; 
INSERT INTO traveler VALUES ('32','Burg','McOwen') ; 
INSERT INTO traveler VALUES ('33','Ludovika','Linny') ; 
INSERT INTO traveler VALUES ('34','Franny','Lubomirski') ; 
INSERT INTO traveler VALUES ('35','Laughton','Zamora') ; 
INSERT INTO traveler VALUES ('36','Gabie','Choat') ; 
INSERT INTO traveler VALUES ('37','Georgie','Roust') ; 
INSERT INTO traveler VALUES ('38','Larissa','Blankman') ; 
INSERT INTO traveler VALUES ('39','Flinn','Allanson') ; 
INSERT INTO traveler VALUES ('40','Rorie','Bentjens') ; 
INSERT INTO traveler VALUES ('41','Boyd','Raine') ; 
INSERT INTO traveler VALUES ('42','Kendall','Rawls') ; 
INSERT INTO traveler VALUES ('43','Miguel','Jaggard') ; 
INSERT INTO traveler VALUES ('44','Fabio','Corradengo') ; 
INSERT INTO traveler VALUES ('45','Fletcher','Cupitt') ; 
INSERT INTO traveler VALUES ('46','Judie','Rappa') ; 
INSERT INTO traveler VALUES ('47','Bert','Yarnell') ; 
INSERT INTO traveler VALUES ('48','Dunn','Doblin') ; 
INSERT INTO traveler VALUES ('49','Alma','Antognazzi') ; 
INSERT INTO traveler VALUES ('50','Celene','Abrahamian') ; 
INSERT INTO traveler VALUES ('51','Natala','Burnett') ; 
INSERT INTO traveler VALUES ('52','Joanna','Luebbert') ; 
INSERT INTO traveler VALUES ('53','Dunc','Toye') ; 
INSERT INTO traveler VALUES ('54','Brandon','Mordon') ; 
INSERT INTO traveler VALUES ('55','Valentia','Rudledge') ; 
INSERT INTO traveler VALUES ('56','Angela','Manklow') ; 
INSERT INTO traveler VALUES ('57','Ira','Akerman') ; 
INSERT INTO traveler VALUES ('58','Vidovik','Parcells') ; 
INSERT INTO traveler VALUES ('59','Valery','Kitson') ; 
INSERT INTO traveler VALUES ('60','Garreth','Hardwick') ; 
INSERT INTO traveler VALUES ('61','Nicola','Trigwell') ; 
INSERT INTO traveler VALUES ('62','Kevon','Van der Velde') ; 
INSERT INTO traveler VALUES ('63','Isabel','Poytres') ; 
INSERT INTO traveler VALUES ('64','Emmaline','Medlen') ; 
INSERT INTO traveler VALUES ('65','Aurea','Groves') ; 
INSERT INTO traveler VALUES ('66','Ally','Beretta') ; 
INSERT INTO traveler VALUES ('67','Tommie','Been') ; 
INSERT INTO traveler VALUES ('68','Maribelle','Ponnsett') ; 
INSERT INTO traveler VALUES ('69','Linn','Yalden') ; 
INSERT INTO traveler VALUES ('70','Cordi','Vinson') ; 
INSERT INTO traveler VALUES ('71','Bert','Gilby') ; 
INSERT INTO traveler VALUES ('72','Britney','Taffs') ; 
INSERT INTO traveler VALUES ('73','Iago','Harkins') ; 
INSERT INTO traveler VALUES ('74','Sherlocke','Bockett') ; 
INSERT INTO traveler VALUES ('75','Maynard','Lampke') ; 
INSERT INTO traveler VALUES ('76','Jackquelin','Zucker') ; 
INSERT INTO traveler VALUES ('77','Lurlene','Lovie') ; 
INSERT INTO traveler VALUES ('78','Catharina','Van Niekerk') ; 
INSERT INTO traveler VALUES ('79','Ozzy','Metcalfe') ; 
INSERT INTO traveler VALUES ('80','Silas','Loosley') ; 
INSERT INTO traveler VALUES ('81','Marjy','Edgson') ; 
INSERT INTO traveler VALUES ('82','Inesita','Mayou') ; 
INSERT INTO traveler VALUES ('83','Alvy','Butterly') ; 
INSERT INTO traveler VALUES ('84','Dmitri','Vernall') ; 
INSERT INTO traveler VALUES ('85','Idette','Marklund') ; 
INSERT INTO traveler VALUES ('86','Kip','Norcliff') ; 
INSERT INTO traveler VALUES ('87','Sabra','Craigg') ; 
INSERT INTO traveler VALUES ('88','Sandy','Harper') ; 
INSERT INTO traveler VALUES ('89','Alonzo','Goodhew') ; 
INSERT INTO traveler VALUES ('90','Emili','Gerbl') ; 
INSERT INTO traveler VALUES ('91','Radcliffe','Ellsbury') ; 
INSERT INTO traveler VALUES ('92','Bentley','Guerriero') ; 
INSERT INTO traveler VALUES ('93','Selestina','Pain') ; 
INSERT INTO traveler VALUES ('94','Merrill','Picheford') ; 
INSERT INTO traveler VALUES ('95','Dena','Coleman') ; 
INSERT INTO traveler VALUES ('96','Matthieu','Camois') ; 
INSERT INTO traveler VALUES ('97','Jay',"D'eath") ; 
INSERT INTO traveler VALUES ('98','Larisa','Dowding') ; 
INSERT INTO traveler VALUES ('99','Victor','Bennis') ; 
INSERT INTO traveler VALUES ('100','Corrie','Kiendl') ; 

INSERT INTO email VALUES ('1','aantognazzi1c@twitpic.com','49') ; 
INSERT INTO email VALUES ('2','aberetta1t@accuweather.com','66') ; 
INSERT INTO email VALUES ('3','abutterly2a@simplemachines.org','83') ; 
INSERT INTO email VALUES ('4','agoodhew2g@vk.com','89') ; 
INSERT INTO email VALUES ('5','agroves1s@liveinternet.ru','65') ; 
INSERT INTO email VALUES ('6','amanklow1j@amazon.co.jp','56') ; 
INSERT INTO email VALUES ('7','amcmakin6@altervista.org','7') ; 
INSERT INTO email VALUES ('8','bcabralesi@rakuten.co.jp','19') ; 
INSERT INTO email VALUES ('9','bgilby1y@freewebs.com','71') ; 
INSERT INTO email VALUES ('10','bguerriero2j@fema.gov','92') ; 
INSERT INTO email VALUES ('11','bmcowenv@buzzfeed.com','32') ; 
INSERT INTO email VALUES ('12','bmepstedn@salon.com','24') ; 
INSERT INTO email VALUES ('13','bmordon1h@youku.com','54') ; 
INSERT INTO email VALUES ('14','braine14@tuttocitta.it','41') ; 
INSERT INTO email VALUES ('15','btaffs1z@webmd.com','72') ; 
INSERT INTO email VALUES ('16','byarnell1a@trellian.com','47') ; 
INSERT INTO email VALUES ('17','cabrahamian1d@about.me','50') ; 
INSERT INTO email VALUES ('18','ccallumj@drupal.org','20') ; 
INSERT INTO email VALUES ('19','cfishbourne5@theatlantic.com','6') ; 
INSERT INTO email VALUES ('20','cgraybeal7@creativecommons.org','8') ; 
INSERT INTO email VALUES ('21','ckiendl2r@hp.com','100') ; 
INSERT INTO email VALUES ('22','cspatq@samsung.com','27') ; 
INSERT INTO email VALUES ('23','cvanniekerk25@a8.net','78') ; 
INSERT INTO email VALUES ('24','cvinson1x@csmonitor.com','70') ; 
INSERT INTO email VALUES ('25','dcoleman2m@cloudflare.com','95') ; 
INSERT INTO email VALUES ('26','dcreeghant@opera.com','30') ; 
INSERT INTO email VALUES ('27','ddoblin1b@feedburner.com','48') ; 
INSERT INTO email VALUES ('28','dlaxon8@friendfeed.com','9') ; 
INSERT INTO email VALUES ('29','dpreene4@amazon.de','5') ; 
INSERT INTO email VALUES ('30','dtoye1g@posterous.com','53') ; 
INSERT INTO email VALUES ('31','dvernall2b@si.edu','84') ; 
INSERT INTO email VALUES ('32','egerardotg@google.co.uk','17') ; 
INSERT INTO email VALUES ('33','egerbl2h@hibu.com','90') ; 
INSERT INTO email VALUES ('34','emedlen1r@hubpages.com','64') ; 
INSERT INTO email VALUES ('35','fallanson12@admin.ch','39') ; 
INSERT INTO email VALUES ('36','fcorradengo17@economist.com','44') ; 
INSERT INTO email VALUES ('37','fcupitt18@networksolutions.com','45') ; 
INSERT INTO email VALUES ('38','fjoyneso@mozilla.com','25') ; 
INSERT INTO email VALUES ('39','flenihanr@wordpress.com','28') ; 
INSERT INTO email VALUES ('40','flubomirskix@mysql.com','34') ; 
INSERT INTO email VALUES ('41','galderwickm@acquirethisname.com','23') ; 
INSERT INTO email VALUES ('42','gchoatz@parallels.com','36') ; 
INSERT INTO email VALUES ('43','ghardwick1n@wordpress.org','60') ; 
INSERT INTO email VALUES ('44','gpues1@washington.edu','2') ; 
INSERT INTO email VALUES ('45','groust10@arstechnica.com','37') ; 
INSERT INTO email VALUES ('46','iakerman1k@fotki.com','57') ; 
INSERT INTO email VALUES ('47','iharkins20@nydailynews.com','73') ; 
INSERT INTO email VALUES ('48','imarklund2c@gmpg.org','85') ; 
INSERT INTO email VALUES ('49','imayou29@cmu.edu','82') ; 
INSERT INTO email VALUES ('50','ipoytres1q@wp.com','63') ; 
INSERT INTO email VALUES ('51','jasserc@yellowpages.com','13') ; 
INSERT INTO email VALUES ('52','jdeath2o@unblog.fr','97') ; 
INSERT INTO email VALUES ('53','jluebbert1f@shutterfly.com','52') ; 
INSERT INTO email VALUES ('54','jpadefieldh@chronoengine.com','18') ; 
INSERT INTO email VALUES ('55','jrappa19@yahoo.com','46') ; 
INSERT INTO email VALUES ('56','jzucker23@drupal.org','76') ; 
INSERT INTO email VALUES ('57','knorcliff2d@google.es','86') ; 
INSERT INTO email VALUES ('58','krawls15@wikimedia.org','42') ; 
INSERT INTO email VALUES ('59','kvandervelde1p@chron.com','62') ; 
INSERT INTO email VALUES ('60','lblankman11@wufoo.com','38') ; 
INSERT INTO email VALUES ('61','ldowding2p@archive.org','98') ; 
INSERT INTO email VALUES ('62','llinnyw@webmd.com','33') ; 
INSERT INTO email VALUES ('63','llovie24@dion.ne.jp','77') ; 
INSERT INTO email VALUES ('64','lraittieu@ucla.edu','31') ; 
INSERT INTO email VALUES ('65','lrosenblum3@phpbb.com','4') ; 
INSERT INTO email VALUES ('66','lsinncockl@slashdot.org','22') ; 
INSERT INTO email VALUES ('67','lyalden1w@stanford.edu','69') ; 
INSERT INTO email VALUES ('68','lzamoray@economist.com','35') ; 
INSERT INTO email VALUES ('69','mcamois2n@angelfire.com','96') ; 
INSERT INTO email VALUES ('70','mdrain9@t-online.de','10') ; 
INSERT INTO email VALUES ('71','medgson28@trellian.com','81') ; 
INSERT INTO email VALUES ('72','mflutep@imageshack.us','26') ; 
INSERT INTO email VALUES ('73','mjaggard16@noaa.gov','43') ; 
INSERT INTO email VALUES ('74','mlampke22@vimeo.com','75') ; 
INSERT INTO email VALUES ('75','mpicheford2l@hostgator.com','94') ; 
INSERT INTO email VALUES ('76','mponnsett1v@answers.com','68') ; 
INSERT INTO email VALUES ('77','nburnett1e@sitemeter.com','51') ; 
INSERT INTO email VALUES ('78','ntattershall0@scientificamerican.com','1') ; 
INSERT INTO email VALUES ('79','ntrigwell1o@statcounter.com','61') ; 
INSERT INTO email VALUES ('80','ometcalfe26@indiegogo.com','79') ; 
INSERT INTO email VALUES ('81','omonkeman2@msu.edu','3') ; 
INSERT INTO email VALUES ('82','ovearsb@samsung.com','12') ; 
INSERT INTO email VALUES ('83','pdobeye@dropbox.com','15') ; 
INSERT INTO email VALUES ('84','pmealiffes@oakley.com','29') ; 
INSERT INTO email VALUES ('85','rbentjens13@noaa.gov','40') ; 
INSERT INTO email VALUES ('86','rellsbury2i@plala.or.jp','91') ; 
INSERT INTO email VALUES ('87','rfraziera@geocities.com','11') ; 
INSERT INTO email VALUES ('88','sbockett21@boston.com','74') ; 
INSERT INTO email VALUES ('89','scraigg2e@pbs.org','87') ; 
INSERT INTO email VALUES ('90','sharper2f@prlog.org','88') ; 
INSERT INTO email VALUES ('91','sloosley27@phpbb.com','80') ; 
INSERT INTO email VALUES ('92','spain2k@opensource.org','93') ; 
INSERT INTO email VALUES ('93','tbeen1u@ft.com','67') ; 
INSERT INTO email VALUES ('94','vbennis2q@ehow.com','99') ; 
INSERT INTO email VALUES ('95','vkitson1m@zimbio.com','59') ; 
INSERT INTO email VALUES ('96','vparcells1l@mit.edu','58') ; 
INSERT INTO email VALUES ('97','vrudledge1i@utexas.edu','55') ; 
INSERT INTO email VALUES ('98','wsermank@nydailynews.com','21') ; 
INSERT INTO email VALUES ('99','wstapfordf@webs.com','16') ; 
INSERT INTO email VALUES ('100','wtingcombd@reddit.com','14') ; 

INSERT INTO phone VALUES ('1','100-903-4437','71') ; 
INSERT INTO phone VALUES ('2','103-909-6392','76') ; 
INSERT INTO phone VALUES ('3','109-208-6704','23') ; 
INSERT INTO phone VALUES ('4','123-342-3005','93') ; 
INSERT INTO phone VALUES ('5','123-555-2704','53') ; 
INSERT INTO phone VALUES ('6','124-886-2506','69') ; 
INSERT INTO phone VALUES ('7','134-932-5780','40') ; 
INSERT INTO phone VALUES ('8','135-614-4276','63') ; 
INSERT INTO phone VALUES ('9','151-135-6425','74') ; 
INSERT INTO phone VALUES ('10','169-705-6410','56') ; 
INSERT INTO phone VALUES ('11','176-970-7658','99') ; 
INSERT INTO phone VALUES ('12','179-805-6091','13') ; 
INSERT INTO phone VALUES ('13','183-998-8077','16') ; 
INSERT INTO phone VALUES ('14','204-936-5986','44') ; 
INSERT INTO phone VALUES ('15','209-255-7208','72') ; 
INSERT INTO phone VALUES ('16','216-526-2986','46') ; 
INSERT INTO phone VALUES ('17','226-142-1121','78') ; 
INSERT INTO phone VALUES ('18','228-107-9678','70') ; 
INSERT INTO phone VALUES ('19','229-494-6873','52') ; 
INSERT INTO phone VALUES ('20','232-331-7584','86') ; 
INSERT INTO phone VALUES ('21','235-510-2142','32') ; 
INSERT INTO phone VALUES ('22','251-238-3403','12') ; 
INSERT INTO phone VALUES ('23','263-218-4635','45') ; 
INSERT INTO phone VALUES ('24','266-676-7796','29') ; 
INSERT INTO phone VALUES ('25','273-568-5143','9') ; 
INSERT INTO phone VALUES ('26','284-442-1937','75') ; 
INSERT INTO phone VALUES ('27','284-924-2150','38') ; 
INSERT INTO phone VALUES ('28','291-360-3816','8') ; 
INSERT INTO phone VALUES ('29','309-850-4730','82') ; 
INSERT INTO phone VALUES ('30','311-237-0616','61') ; 
INSERT INTO phone VALUES ('31','312-157-9246','66') ; 
INSERT INTO phone VALUES ('32','331-415-0290','48') ; 
INSERT INTO phone VALUES ('33','339-367-8624','55') ; 
INSERT INTO phone VALUES ('34','340-892-5148','36') ; 
INSERT INTO phone VALUES ('35','342-280-2987','95') ; 
INSERT INTO phone VALUES ('36','360-266-9661','30') ; 
INSERT INTO phone VALUES ('37','360-552-7603','81') ; 
INSERT INTO phone VALUES ('38','365-338-7150','57') ; 
INSERT INTO phone VALUES ('39','376-728-6268','67') ; 
INSERT INTO phone VALUES ('40','377-179-9241','100') ; 
INSERT INTO phone VALUES ('41','426-413-1018','33') ; 
INSERT INTO phone VALUES ('42','443-989-4609','85') ; 
INSERT INTO phone VALUES ('43','446-486-4967','43') ; 
INSERT INTO phone VALUES ('44','457-286-1774','94') ; 
INSERT INTO phone VALUES ('45','458-307-4004','83') ; 
INSERT INTO phone VALUES ('46','460-394-7971','26') ; 
INSERT INTO phone VALUES ('47','465-275-5850','6') ; 
INSERT INTO phone VALUES ('48','475-436-9567','77') ; 
INSERT INTO phone VALUES ('49','477-668-1672','21') ; 
INSERT INTO phone VALUES ('50','490-774-8505','58') ; 
INSERT INTO phone VALUES ('51','500-692-7033','65') ; 
INSERT INTO phone VALUES ('52','501-291-5417','88') ; 
INSERT INTO phone VALUES ('53','513-534-3636','31') ; 
INSERT INTO phone VALUES ('54','522-940-8846','17') ; 
INSERT INTO phone VALUES ('55','536-129-7919','7') ; 
INSERT INTO phone VALUES ('56','540-393-1497','19') ; 
INSERT INTO phone VALUES ('57','551-291-7346','92') ; 
INSERT INTO phone VALUES ('58','560-473-3651','24') ; 
INSERT INTO phone VALUES ('59','561-549-0700','84') ; 
INSERT INTO phone VALUES ('60','563-852-1948','80') ; 
INSERT INTO phone VALUES ('61','576-544-4679','20') ; 
INSERT INTO phone VALUES ('62','585-194-8676','60') ; 
INSERT INTO phone VALUES ('63','598-842-2847','96') ; 
INSERT INTO phone VALUES ('64','608-871-6119','47') ; 
INSERT INTO phone VALUES ('65','614-236-4266','87') ; 
INSERT INTO phone VALUES ('66','648-721-1817','15') ; 
INSERT INTO phone VALUES ('67','650-937-2476','35') ; 
INSERT INTO phone VALUES ('68','656-105-7242','64') ; 
INSERT INTO phone VALUES ('69','659-876-2008','79') ; 
INSERT INTO phone VALUES ('70','665-257-6602','3') ; 
INSERT INTO phone VALUES ('71','667-417-9006','50') ; 
INSERT INTO phone VALUES ('72','672-720-7032','49') ; 
INSERT INTO phone VALUES ('73','677-182-8636','91') ; 
INSERT INTO phone VALUES ('74','684-743-6399','11') ; 
INSERT INTO phone VALUES ('75','702-983-4224','54') ; 
INSERT INTO phone VALUES ('76','704-791-4946','62') ; 
INSERT INTO phone VALUES ('77','726-165-5462','34') ; 
INSERT INTO phone VALUES ('78','727-295-2129','4') ; 
INSERT INTO phone VALUES ('79','727-955-4738','2') ; 
INSERT INTO phone VALUES ('80','735-447-9981','90') ; 
INSERT INTO phone VALUES ('81','769-886-6501','51') ; 
INSERT INTO phone VALUES ('82','791-196-2327','39') ; 
INSERT INTO phone VALUES ('83','799-280-7851','98') ; 
INSERT INTO phone VALUES ('84','805-300-6152','27') ; 
INSERT INTO phone VALUES ('85','815-743-0640','41') ; 
INSERT INTO phone VALUES ('86','834-845-4034','73') ; 
INSERT INTO phone VALUES ('87','847-254-4657','42') ; 
INSERT INTO phone VALUES ('88','852-364-1660','10') ; 
INSERT INTO phone VALUES ('89','876-509-9383','59') ; 
INSERT INTO phone VALUES ('90','891-871-4293','97') ; 
INSERT INTO phone VALUES ('91','909-203-3615','37') ; 
INSERT INTO phone VALUES ('92','911-766-3419','14') ; 
INSERT INTO phone VALUES ('93','951-734-8267','18') ; 
INSERT INTO phone VALUES ('94','959-851-7193','89') ; 
INSERT INTO phone VALUES ('95','964-627-0707','25') ; 
INSERT INTO phone VALUES ('96','966-183-0642','68') ; 
INSERT INTO phone VALUES ('97','981-329-5784','1') ; 
INSERT INTO phone VALUES ('98','985-897-0047','5') ; 
INSERT INTO phone VALUES ('99','986-945-7547','22') ; 
INSERT INTO phone VALUES ('100','992-424-8508','28') ; 

INSERT INTO payment_card_type VALUES ('1','Visa') ; 
INSERT INTO payment_card_type VALUES ('2','Mastercard') ; 
INSERT INTO payment_card_type VALUES ('3','American Express') ; 
INSERT INTO payment_card_type VALUES ('4','Discover') ; 

INSERT INTO payment_card VALUES ('1','4075308087290424','2021-11-01','109','13','1') ; 
INSERT INTO payment_card VALUES ('2','5182749713138619','2021-05-01','110','40','2') ; 
INSERT INTO payment_card VALUES ('3','5384596672003300','2018-11-01','125','38','2') ; 
INSERT INTO payment_card VALUES ('4','4757960525875938','2023-01-01','126','5','1') ; 
INSERT INTO payment_card VALUES ('5','5529668484893537','2018-08-01','132','33','2') ; 
INSERT INTO payment_card VALUES ('6','5269618840638468','2020-04-01','133','46','2') ; 
INSERT INTO payment_card VALUES ('7','4716277640625415','2025-04-01','136','20','1') ; 
INSERT INTO payment_card VALUES ('8','5491103185289268','2020-11-01','144','30','2') ; 
INSERT INTO payment_card VALUES ('9','6011200625041744','2024-09-01','152','96','4') ; 
INSERT INTO payment_card VALUES ('10','6011639188243009','2022-12-01','155','82','4') ; 
INSERT INTO payment_card VALUES ('11','375111791664057','2024-07-01','158','52','3') ; 
INSERT INTO payment_card VALUES ('12','4532174538190796','2019-07-01','169','25','1') ; 
INSERT INTO payment_card VALUES ('13','6011851200173599','2021-12-01','179','80','4') ; 
INSERT INTO payment_card VALUES ('14','6011835973978631','2021-10-01','211','92','4') ; 
INSERT INTO payment_card VALUES ('15','375513972298144','2021-02-01','212','53','3') ; 
INSERT INTO payment_card VALUES ('16','346131960401624','2021-01-01','215','60','3') ; 
INSERT INTO payment_card VALUES ('17','372032812236092','2022-02-01','218','64','3') ; 
INSERT INTO payment_card VALUES ('18','4485016998816146','2020-11-01','220','6','1') ; 
INSERT INTO payment_card VALUES ('19','5417783449449781','2021-02-01','230','47','2') ; 
INSERT INTO payment_card VALUES ('20','6011724858199861','2024-12-01','239','99','4') ; 
INSERT INTO payment_card VALUES ('21','370181926274374','2019-08-01','242','70','3') ; 
INSERT INTO payment_card VALUES ('22','4916257882605471','2020-02-01','244','3','1') ; 
INSERT INTO payment_card VALUES ('23','343790024826119','2023-08-01','247','67','3') ; 
INSERT INTO payment_card VALUES ('24','6011327889559044','2021-04-01','255','98','4') ; 
INSERT INTO payment_card VALUES ('25','4556320804679092','2022-02-01','263','4','1') ; 
INSERT INTO payment_card VALUES ('26','6011195741306700','2021-03-01','270','95','4') ; 
INSERT INTO payment_card VALUES ('27','6011944595284640','2022-04-01','277','90','4') ; 
INSERT INTO payment_card VALUES ('28','344362810948199','2019-08-01','284','66','3') ; 
INSERT INTO payment_card VALUES ('29','4929152753254076','2019-05-01','291','12','1') ; 
INSERT INTO payment_card VALUES ('30','6011345833667325','2025-06-01','297','89','4') ; 
INSERT INTO payment_card VALUES ('31','4916537468320078','2022-04-01','306','19','1') ; 
INSERT INTO payment_card VALUES ('32','374107383166213','2019-03-01','318','58','3') ; 
INSERT INTO payment_card VALUES ('33','4929821560845108','2025-12-01','320','17','1') ; 
INSERT INTO payment_card VALUES ('34','5240528150345626','2023-08-01','323','39','2') ; 
INSERT INTO payment_card VALUES ('35','4024007137462098','2021-02-01','326','15','1') ; 
INSERT INTO payment_card VALUES ('36','341994695501397','2022-09-01','329','73','3') ; 
INSERT INTO payment_card VALUES ('37','4916418450362206','2018-11-01','338','23','1') ; 
INSERT INTO payment_card VALUES ('38','348755083449587','2023-06-01','348','71','3') ; 
INSERT INTO payment_card VALUES ('39','4556137206491870','2021-10-01','360','10','1') ; 
INSERT INTO payment_card VALUES ('40','4916846302864120','2020-10-01','364','1','1') ; 
INSERT INTO payment_card VALUES ('41','374215901647422','2020-07-01','365','61','3') ; 
INSERT INTO payment_card VALUES ('42','6011676952691211','2024-11-01','373','76','4') ; 
INSERT INTO payment_card VALUES ('43','377823259849313','2019-09-01','389','69','3') ; 
INSERT INTO payment_card VALUES ('44','5246406213894530','2021-07-01','393','32','2') ; 
INSERT INTO payment_card VALUES ('45','375198226286069','2020-08-01','402','75','3') ; 
INSERT INTO payment_card VALUES ('46','4556976180984644','2019-11-01','415','2','1') ; 
INSERT INTO payment_card VALUES ('47','6011626214810232','2023-04-01','424','87','4') ; 
INSERT INTO payment_card VALUES ('48','6011521196272479','2024-06-01','426','84','4') ; 
INSERT INTO payment_card VALUES ('49','6011221365941760','2025-05-01','442','100','4') ; 
INSERT INTO payment_card VALUES ('50','5181340196094288','2021-09-01','447','42','2') ; 
INSERT INTO payment_card VALUES ('51','4539748019282892','2020-01-01','452','9','1') ; 
INSERT INTO payment_card VALUES ('52','5185958032967189','2020-04-01','452','34','2') ; 
INSERT INTO payment_card VALUES ('53','4024007138845796','2024-10-01','465','18','1') ; 
INSERT INTO payment_card VALUES ('54','5416253563553801','2022-11-01','473','45','2') ; 
INSERT INTO payment_card VALUES ('55','5435166823556744','2024-11-01','477','26','2') ; 
INSERT INTO payment_card VALUES ('56','6011915964104114','2023-03-01','482','77','4') ; 
INSERT INTO payment_card VALUES ('57','6011729645727189','2020-12-01','484','91','4') ; 
INSERT INTO payment_card VALUES ('58','372121573290610','2019-12-01','511','59','3') ; 
INSERT INTO payment_card VALUES ('59','349703432561198','2022-06-01','513','55','3') ; 
INSERT INTO payment_card VALUES ('60','5359242664234923','2025-10-01','513','35','2') ; 
INSERT INTO payment_card VALUES ('61','5335456045942587','2022-04-01','515','48','2') ; 
INSERT INTO payment_card VALUES ('62','371734812523491','2020-05-01','518','57','3') ; 
INSERT INTO payment_card VALUES ('63','4485428110512240','2022-03-01','536','16','1') ; 
INSERT INTO payment_card VALUES ('64','5198207806596476','2021-05-01','549','43','2') ; 
INSERT INTO payment_card VALUES ('65','5431562708728024','2020-10-01','564','49','2') ; 
INSERT INTO payment_card VALUES ('66','6011554024132987','2020-05-01','584','78','4') ; 
INSERT INTO payment_card VALUES ('67','5303764320636081','2022-11-01','606','37','2') ; 
INSERT INTO payment_card VALUES ('68','5526686298778663','2021-11-01','615','29','2') ; 
INSERT INTO payment_card VALUES ('69','5393804977946929','2024-06-01','617','28','2') ; 
INSERT INTO payment_card VALUES ('70','5261525955972798','2025-02-01','635','44','2') ; 
INSERT INTO payment_card VALUES ('71','4024007148490880','2023-04-01','646','7','1') ; 
INSERT INTO payment_card VALUES ('72','378629857938591','2021-06-01','649','54','3') ; 
INSERT INTO payment_card VALUES ('73','372330140449431','2025-04-01','655','72','3') ; 
INSERT INTO payment_card VALUES ('74','377071163334606','2021-12-01','655','65','3') ; 
INSERT INTO payment_card VALUES ('75','4916484715914835','2021-09-01','665','21','1') ; 
INSERT INTO payment_card VALUES ('76','5541555361205378','2022-02-01','667','27','2') ; 
INSERT INTO payment_card VALUES ('77','6011907305678328','2022-02-01','671','86','4') ; 
INSERT INTO payment_card VALUES ('78','5121277020324593','2023-09-01','675','41','2') ; 
INSERT INTO payment_card VALUES ('79','6011240461463651','2020-02-01','688','94','4') ; 
INSERT INTO payment_card VALUES ('80','5355172157408920','2018-02-01','696','36','2') ; 
INSERT INTO payment_card VALUES ('81','6011020095725885','2024-08-01','712','83','4') ; 
INSERT INTO payment_card VALUES ('82','6011008907893330','2022-08-01','736','85','4') ; 
INSERT INTO payment_card VALUES ('83','6011788994303018','2024-02-01','746','93','4') ; 
INSERT INTO payment_card VALUES ('84','376156208199154','2024-03-01','761','74','3') ; 
INSERT INTO payment_card VALUES ('85','6011690463100786','2024-05-01','766','81','4') ; 
INSERT INTO payment_card VALUES ('86','374732694030996','2018-07-01','772','62','3') ; 
INSERT INTO payment_card VALUES ('87','6011764919112594','2023-08-01','788','97','4') ; 
INSERT INTO payment_card VALUES ('88','4716257120925709','2023-04-01','804','11','1') ; 
INSERT INTO payment_card VALUES ('89','6011621884556603','2020-10-01','811','79','4') ; 
INSERT INTO payment_card VALUES ('90','378451213772261','2024-09-01','822','68','3') ; 
INSERT INTO payment_card VALUES ('91','6011037292780810','2023-10-01','837','88','4') ; 
INSERT INTO payment_card VALUES ('92','4556111178222142','2019-10-01','848','14','1') ; 
INSERT INTO payment_card VALUES ('93','349062377192711','2019-02-01','878','51','3') ; 
INSERT INTO payment_card VALUES ('94','345700283345857','2019-03-01','931','63','3') ; 
INSERT INTO payment_card VALUES ('95','5124428054631315','2021-04-01','961','50','2') ; 
INSERT INTO payment_card VALUES ('96','5200225628360018','2019-11-01','969','31','2') ; 
INSERT INTO payment_card VALUES ('97','370539977782167','2021-08-01','973','56','3') ; 
INSERT INTO payment_card VALUES ('98','4485418616946729','2019-10-01','977','22','1') ; 
INSERT INTO payment_card VALUES ('99','4485055525194700','2024-02-01','978','24','1') ; 
INSERT INTO payment_card VALUES ('100','4024007133313584','2018-10-01','992','8','1') ; 

INSERT INTO class VALUES ('1','Economy/Coach','0.55') ; 
INSERT INTO class VALUES ('2','Premium economy','0.2') ; 
INSERT INTO class VALUES ('3','Business','0.15') ; 
INSERT INTO class VALUES ('4','First class','0.1') ; 

INSERT INTO price_factor VALUES ('1','1','1.3') ; 
INSERT INTO price_factor VALUES ('2','1','1.19') ; 
INSERT INTO price_factor VALUES ('3','1','1.12') ; 
INSERT INTO price_factor VALUES ('4','1','1.15') ; 
INSERT INTO price_factor VALUES ('5','1','1.31') ; 
INSERT INTO price_factor VALUES ('6','1','1.05') ; 
INSERT INTO price_factor VALUES ('7','1','1.26') ; 
INSERT INTO price_factor VALUES ('8','1','1.31') ; 
INSERT INTO price_factor VALUES ('9','1','1.13') ; 
INSERT INTO price_factor VALUES ('10','1','1.32') ; 
INSERT INTO price_factor VALUES ('11','1','1.07') ; 
INSERT INTO price_factor VALUES ('12','1','1.2') ; 
INSERT INTO price_factor VALUES ('13','1','1.32') ; 
INSERT INTO price_factor VALUES ('14','1','1.03') ; 
INSERT INTO price_factor VALUES ('15','1','1.05') ; 
INSERT INTO price_factor VALUES ('16','1','1.22') ; 
INSERT INTO price_factor VALUES ('1','2','1.55') ; 
INSERT INTO price_factor VALUES ('2','2','1.35') ; 
INSERT INTO price_factor VALUES ('3','2','1.44') ; 
INSERT INTO price_factor VALUES ('4','2','1.37') ; 
INSERT INTO price_factor VALUES ('5','2','1.31') ; 
INSERT INTO price_factor VALUES ('6','2','1.5') ; 
INSERT INTO price_factor VALUES ('7','2','1.42') ; 
INSERT INTO price_factor VALUES ('8','2','1.35') ; 
INSERT INTO price_factor VALUES ('9','2','1.36') ; 
INSERT INTO price_factor VALUES ('10','2','1.46') ; 
INSERT INTO price_factor VALUES ('11','2','1.46') ; 
INSERT INTO price_factor VALUES ('12','2','1.61') ; 
INSERT INTO price_factor VALUES ('13','2','1.46') ; 
INSERT INTO price_factor VALUES ('14','2','1.56') ; 
INSERT INTO price_factor VALUES ('15','2','1.36') ; 
INSERT INTO price_factor VALUES ('16','2','1.33') ; 
INSERT INTO price_factor VALUES ('1','3','1.65') ; 
INSERT INTO price_factor VALUES ('2','3','1.83') ; 
INSERT INTO price_factor VALUES ('3','3','1.91') ; 
INSERT INTO price_factor VALUES ('4','3','1.7') ; 
INSERT INTO price_factor VALUES ('5','3','1.83') ; 
INSERT INTO price_factor VALUES ('6','3','1.66') ; 
INSERT INTO price_factor VALUES ('7','3','1.84') ; 
INSERT INTO price_factor VALUES ('8','3','1.83') ; 
INSERT INTO price_factor VALUES ('9','3','1.66') ; 
INSERT INTO price_factor VALUES ('10','3','1.72') ; 
INSERT INTO price_factor VALUES ('11','3','1.62') ; 
INSERT INTO price_factor VALUES ('12','3','1.82') ; 
INSERT INTO price_factor VALUES ('13','3','1.74') ; 
INSERT INTO price_factor VALUES ('14','3','1.76') ; 
INSERT INTO price_factor VALUES ('15','3','1.67') ; 
INSERT INTO price_factor VALUES ('16','3','1.65') ; 
INSERT INTO price_factor VALUES ('1','4','2.21') ; 
INSERT INTO price_factor VALUES ('2','4','2.1') ; 
INSERT INTO price_factor VALUES ('3','4','2.21') ; 
INSERT INTO price_factor VALUES ('4','4','1.93') ; 
INSERT INTO price_factor VALUES ('5','4','2.13') ; 
INSERT INTO price_factor VALUES ('6','4','2.05') ; 
INSERT INTO price_factor VALUES ('7','4','2.05') ; 
INSERT INTO price_factor VALUES ('8','4','2.12') ; 
INSERT INTO price_factor VALUES ('9','4','2.13') ; 
INSERT INTO price_factor VALUES ('10','4','2.06') ; 
INSERT INTO price_factor VALUES ('11','4','1.93') ; 
INSERT INTO price_factor VALUES ('12','4','2.22') ; 
INSERT INTO price_factor VALUES ('13','4','2.19') ; 
INSERT INTO price_factor VALUES ('14','4','1.97') ; 
INSERT INTO price_factor VALUES ('15','4','2.22') ; 
INSERT INTO price_factor VALUES ('16','4','1.91') ; 

INSERT INTO reservation VALUES ('1','85','3','1','2018-06-15 05:53:14') ; 
INSERT INTO reservation VALUES ('2','23','1','3','2018-05-19 06:35:25') ; 
INSERT INTO reservation VALUES ('3','72','4','1','2018-07-28 03:42:30') ; 
INSERT INTO reservation VALUES ('4','28','2','2','2018-06-23 14:37:06') ; 
INSERT INTO reservation VALUES ('5','29','2','1','2018-05-13 14:13:53') ; 
INSERT INTO reservation VALUES ('6','99','2','3','2018-09-24 12:52:54') ; 
INSERT INTO reservation VALUES ('7','97','3','2','2018-05-26 12:44:53') ; 
INSERT INTO reservation VALUES ('8','22','4','1','2018-09-22 22:45:45') ; 
INSERT INTO reservation VALUES ('9','63','1','3','2018-06-14 23:33:58') ; 
INSERT INTO reservation VALUES ('10','50','4','1','2018-06-01 05:33:21') ; 
INSERT INTO reservation VALUES ('11','71','2','1','2018-09-29 14:24:56') ; 
INSERT INTO reservation VALUES ('12','78','3','2','2018-07-25 01:41:44') ; 
INSERT INTO reservation VALUES ('13','24','1','1','2018-06-03 08:37:11') ; 
INSERT INTO reservation VALUES ('14','47','1','3','2018-07-11 03:12:13') ; 
INSERT INTO reservation VALUES ('15','92','3','3','2018-07-19 11:06:34') ; 
INSERT INTO reservation VALUES ('16','84','4','1','2018-06-14 16:57:28') ; 
INSERT INTO reservation VALUES ('17','89','2','3','2018-05-07 23:34:41') ; 
INSERT INTO reservation VALUES ('18','68','1','1','2018-07-17 06:02:43') ; 
INSERT INTO reservation VALUES ('19','4','2','3','2018-09-12 08:26:21') ; 
INSERT INTO reservation VALUES ('20','12','2','1','2018-08-18 00:07:58') ; 
INSERT INTO reservation VALUES ('21','53','3','2','2018-05-29 09:21:45') ; 
INSERT INTO reservation VALUES ('22','83','2','1','2018-10-01 02:56:02') ; 
INSERT INTO reservation VALUES ('23','44','1','2','2018-10-21 13:19:07') ; 
INSERT INTO reservation VALUES ('24','3','2','1','2018-06-20 03:20:13') ; 
INSERT INTO reservation VALUES ('25','79','1','2','2018-08-25 05:03:20') ; 
INSERT INTO reservation VALUES ('26','60','1','1','2018-10-29 18:33:47') ; 
INSERT INTO reservation VALUES ('27','70','2','2','2018-09-18 00:59:33') ; 
INSERT INTO reservation VALUES ('28','74','4','2','2018-09-22 10:06:44') ; 
INSERT INTO reservation VALUES ('29','57','1','2','2018-10-29 13:37:55') ; 
INSERT INTO reservation VALUES ('30','17','1','2','2018-07-05 19:19:36') ; 
INSERT INTO reservation VALUES ('31','52','1','1','2018-06-19 05:43:47') ; 
INSERT INTO reservation VALUES ('32','45','2','3','2018-06-03 00:31:55') ; 
INSERT INTO reservation VALUES ('33','81','3','3','2018-08-09 08:03:22') ; 
INSERT INTO reservation VALUES ('34','75','2','3','2018-09-23 05:48:01') ; 
INSERT INTO reservation VALUES ('35','43','1','1','2018-06-21 23:50:51') ; 
INSERT INTO reservation VALUES ('36','37','1','2','2018-07-05 12:16:25') ; 
INSERT INTO reservation VALUES ('37','31','3','2','2018-09-15 06:01:35') ; 
INSERT INTO reservation VALUES ('38','8','2','2','2018-10-10 01:54:17') ; 
INSERT INTO reservation VALUES ('39','34','4','3','2018-05-18 00:51:31') ; 
INSERT INTO reservation VALUES ('40','32','2','2','2018-05-07 11:56:15') ; 
INSERT INTO reservation VALUES ('41','16','2','3','2018-07-03 13:57:43') ; 
INSERT INTO reservation VALUES ('42','18','2','1','2018-06-10 15:17:40') ; 
INSERT INTO reservation VALUES ('43','38','1','2','2018-07-30 05:47:28') ; 
INSERT INTO reservation VALUES ('44','25','3','3','2018-06-09 01:45:09') ; 
INSERT INTO reservation VALUES ('45','15','4','3','2018-05-15 16:22:28') ; 
INSERT INTO reservation VALUES ('46','42','2','2','2018-07-09 23:29:24') ; 
INSERT INTO reservation VALUES ('47','54','1','3','2018-06-19 14:19:44') ; 
INSERT INTO reservation VALUES ('48','39','4','1','2018-10-22 11:50:41') ; 
INSERT INTO reservation VALUES ('49','86','4','2','2018-10-20 22:48:00') ; 
INSERT INTO reservation VALUES ('50','90','1','1','2018-05-23 05:41:56') ; 
INSERT INTO reservation VALUES ('51','19','1','2','2018-08-28 02:36:22') ; 
INSERT INTO reservation VALUES ('52','26','1','1','2018-06-28 08:50:53') ; 
INSERT INTO reservation VALUES ('53','1','1','1','2018-08-19 21:52:11') ; 
INSERT INTO reservation VALUES ('54','5','2','2','2018-06-29 16:57:38') ; 
INSERT INTO reservation VALUES ('55','64','2','3','2018-07-07 05:27:16') ; 
INSERT INTO reservation VALUES ('56','65','2','2','2018-05-26 05:20:11') ; 
INSERT INTO reservation VALUES ('57','40','1','3','2018-05-03 11:52:31') ; 
INSERT INTO reservation VALUES ('58','69','2','2','2018-07-20 04:22:32') ; 
INSERT INTO reservation VALUES ('59','67','3','3','2018-06-27 06:59:17') ; 
INSERT INTO reservation VALUES ('60','10','4','3','2018-10-04 03:03:42') ; 
INSERT INTO reservation VALUES ('61','14','2','1','2018-08-09 11:56:20') ; 
INSERT INTO reservation VALUES ('62','88','1','2','2018-09-22 21:32:22') ; 
INSERT INTO reservation VALUES ('63','51','2','2','2018-09-02 18:25:57') ; 
INSERT INTO reservation VALUES ('64','49','1','3','2018-08-05 03:43:42') ; 
INSERT INTO reservation VALUES ('65','98','1','3','2018-06-07 06:57:03') ; 
INSERT INTO reservation VALUES ('66','7','3','1','2018-09-15 18:59:51') ; 
INSERT INTO reservation VALUES ('67','33','1','1','2018-09-12 21:13:46') ; 
INSERT INTO reservation VALUES ('68','6','4','2','2018-06-27 07:01:54') ; 
INSERT INTO reservation VALUES ('69','46','3','3','2018-10-16 05:19:28') ; 
INSERT INTO reservation VALUES ('70','56','4','3','2018-09-13 13:38:41') ; 
INSERT INTO reservation VALUES ('71','76','1','3','2018-06-08 20:51:56') ; 
INSERT INTO reservation VALUES ('72','66','4','1','2018-08-03 01:45:28') ; 
INSERT INTO reservation VALUES ('73','100','3','2','2018-09-26 12:41:17') ; 
INSERT INTO reservation VALUES ('74','13','2','3','2018-10-28 19:46:07') ; 
INSERT INTO reservation VALUES ('75','80','3','1','2018-06-29 09:08:52') ; 
INSERT INTO reservation VALUES ('76','58','2','1','2018-09-18 11:43:32') ; 
INSERT INTO reservation VALUES ('77','30','2','1','2018-06-16 12:40:59') ; 
INSERT INTO reservation VALUES ('78','11','1','1','2018-09-19 14:13:28') ; 
INSERT INTO reservation VALUES ('79','77','3','2','2018-06-10 12:30:36') ; 
INSERT INTO reservation VALUES ('80','82','3','1','2018-05-26 20:17:01') ; 
INSERT INTO reservation VALUES ('81','9','4','3','2018-10-27 20:58:59') ; 
INSERT INTO reservation VALUES ('82','35','3','3','2018-06-02 01:50:47') ; 
INSERT INTO reservation VALUES ('83','41','2','2','2018-05-22 03:57:31') ; 
INSERT INTO reservation VALUES ('84','48','1','2','2018-05-12 19:46:50') ; 
INSERT INTO reservation VALUES ('85','96','2','1','2018-08-30 22:49:20') ; 
INSERT INTO reservation VALUES ('86','2','3','3','2018-07-28 09:10:04') ; 
INSERT INTO reservation VALUES ('87','27','1','3','2018-06-13 08:28:19') ; 
INSERT INTO reservation VALUES ('88','55','3','1','2018-05-16 21:06:46') ; 
INSERT INTO reservation VALUES ('89','62','3','2','2018-06-17 22:33:59') ; 
INSERT INTO reservation VALUES ('90','93','3','3','2018-09-12 02:34:13') ; 
INSERT INTO reservation VALUES ('91','59','2','2','2018-06-27 08:35:57') ; 
INSERT INTO reservation VALUES ('92','87','2','2','2018-07-26 13:34:55') ; 
INSERT INTO reservation VALUES ('93','94','3','1','2018-08-05 06:43:51') ; 
INSERT INTO reservation VALUES ('94','36','4','3','2018-09-16 12:44:01') ; 
INSERT INTO reservation VALUES ('95','73','2','3','2018-06-19 17:36:27') ; 
INSERT INTO reservation VALUES ('96','61','2','1','2018-05-26 07:08:55') ; 
INSERT INTO reservation VALUES ('97','20','4','2','2018-08-29 22:31:10') ; 
INSERT INTO reservation VALUES ('98','95','3','2','2018-06-16 06:09:20') ; 
INSERT INTO reservation VALUES ('99','21','3','1','2018-06-27 21:08:12') ; 
INSERT INTO reservation VALUES ('100','91','4','2','2018-09-23 01:27:11') ; 

INSERT INTO state VALUES ('1','AL','Alabama') ; 
INSERT INTO state VALUES ('2','AK','Alaska') ; 
INSERT INTO state VALUES ('3','AZ','Arizona') ; 
INSERT INTO state VALUES ('4','AR','Arkansas') ; 
INSERT INTO state VALUES ('5','CA','California') ; 
INSERT INTO state VALUES ('6','CO','Colorado') ; 
INSERT INTO state VALUES ('7','CT','Connecticut') ; 
INSERT INTO state VALUES ('8','DE','Delaware') ; 
INSERT INTO state VALUES ('9','DC','District of Columbia') ; 
INSERT INTO state VALUES ('10','FL','Florida') ; 
INSERT INTO state VALUES ('11','GA','Georgia') ; 
INSERT INTO state VALUES ('12','HI','Hawaii') ; 
INSERT INTO state VALUES ('13','ID','Idaho') ; 
INSERT INTO state VALUES ('14','IL','Illinois') ; 
INSERT INTO state VALUES ('15','IN','Indiana') ; 
INSERT INTO state VALUES ('16','IA','Iowa') ; 
INSERT INTO state VALUES ('17','KS','Kansas') ; 
INSERT INTO state VALUES ('18','KY','Kentucky') ; 
INSERT INTO state VALUES ('19','LA','Louisiana') ; 
INSERT INTO state VALUES ('20','ME','Maine') ; 
INSERT INTO state VALUES ('21','MT','Montana') ; 
INSERT INTO state VALUES ('22','NE','Nebraska') ; 
INSERT INTO state VALUES ('23','NV','Nevada') ; 
INSERT INTO state VALUES ('24','NH','New Hampshire') ; 
INSERT INTO state VALUES ('25','NJ','New Jersey') ; 
INSERT INTO state VALUES ('26','NM','New Mexico') ; 
INSERT INTO state VALUES ('27','NY','New York') ; 
INSERT INTO state VALUES ('28','NC','North Carolina') ; 
INSERT INTO state VALUES ('29','ND','North Dakota') ; 
INSERT INTO state VALUES ('30','OH','Ohio') ; 
INSERT INTO state VALUES ('31','OK','Oklahoma') ; 
INSERT INTO state VALUES ('32','OR','Oregon') ; 
INSERT INTO state VALUES ('33','MD','Maryland') ; 
INSERT INTO state VALUES ('34','MA','Massachusetts') ; 
INSERT INTO state VALUES ('35','MI','Michigan') ; 
INSERT INTO state VALUES ('36','MN','Minnesota') ; 
INSERT INTO state VALUES ('37','MS','Mississippi') ; 
INSERT INTO state VALUES ('38','MO','Missouri') ; 
INSERT INTO state VALUES ('39','PA','Pennsylvania') ; 
INSERT INTO state VALUES ('40','RI','Rhode Island') ; 
INSERT INTO state VALUES ('41','SC','South Carolina') ; 
INSERT INTO state VALUES ('42','SD','South Dakota') ; 
INSERT INTO state VALUES ('43','TN','Tennessee') ; 
INSERT INTO state VALUES ('44','TX','Texas') ; 
INSERT INTO state VALUES ('45','UT','Utah') ; 
INSERT INTO state VALUES ('46','VT','Vermont') ; 
INSERT INTO state VALUES ('47','VA','Virginia') ; 
INSERT INTO state VALUES ('48','WA','Washington') ; 
INSERT INTO state VALUES ('49','WV','West Virginia') ; 
INSERT INTO state VALUES ('50','WI','Wisconsin') ; 
INSERT INTO state VALUES ('51','WY','Wyoming') ; 

INSERT INTO city VALUES ('1','Abilene','44') ; 
INSERT INTO city VALUES ('2','Alamogordo','26') ; 
INSERT INTO city VALUES ('3','Albuquerque','26') ; 
INSERT INTO city VALUES ('4','Altus','31') ; 
INSERT INTO city VALUES ('5','Amarillo','44') ; 
INSERT INTO city VALUES ('6','Anchorage','2') ; 
INSERT INTO city VALUES ('7','Asheville','28') ; 
INSERT INTO city VALUES ('8','Atlanta','11') ; 
INSERT INTO city VALUES ('9','Augusta','11') ; 
INSERT INTO city VALUES ('10','Austin','44') ; 
INSERT INTO city VALUES ('11','Baltimore','33') ; 
INSERT INTO city VALUES ('12','Bangor','20') ; 
INSERT INTO city VALUES ('13','Belleville','14') ; 
INSERT INTO city VALUES ('14','Billings','21') ; 
INSERT INTO city VALUES ('15','Birmingham','1') ; 
INSERT INTO city VALUES ('16','Bloomington/Normal','14') ; 
INSERT INTO city VALUES ('17','Boise','13') ; 
INSERT INTO city VALUES ('18','Bossier City','19') ; 
INSERT INTO city VALUES ('19','Boston','34') ; 
INSERT INTO city VALUES ('20','Bristol/Johnson/Kingsport','43') ; 
INSERT INTO city VALUES ('21','Buffalo','27') ; 
INSERT INTO city VALUES ('22','Camp Springs','33') ; 
INSERT INTO city VALUES ('23','Casper','51') ; 
INSERT INTO city VALUES ('24','Cedar Rapids','16') ; 
INSERT INTO city VALUES ('25','Charleston','41') ; 
INSERT INTO city VALUES ('26','Charleston','49') ; 
INSERT INTO city VALUES ('27','Charlotte','28') ; 
INSERT INTO city VALUES ('28','Chattanooga','43') ; 
INSERT INTO city VALUES ('29','Chicago','14') ; 
INSERT INTO city VALUES ('30','Chicago/Rockford','14') ; 
INSERT INTO city VALUES ('31','Cincinnati','18') ; 
INSERT INTO city VALUES ('32','Cleveland','30') ; 
INSERT INTO city VALUES ('33','Clovis','26') ; 
INSERT INTO city VALUES ('34','Columbia','41') ; 
INSERT INTO city VALUES ('35','Columbus','37') ; 
INSERT INTO city VALUES ('36','Columbus','30') ; 
INSERT INTO city VALUES ('37','Corpus Christi','44') ; 
INSERT INTO city VALUES ('38','Dallas','44') ; 
INSERT INTO city VALUES ('39','Dallas-Fort Worth','44') ; 
INSERT INTO city VALUES ('40','Dayton','30') ; 
INSERT INTO city VALUES ('41','Daytona Beach','10') ; 
INSERT INTO city VALUES ('42','Del Rio','44') ; 
INSERT INTO city VALUES ('43','Denver','6') ; 
INSERT INTO city VALUES ('44','Des Moines','16') ; 
INSERT INTO city VALUES ('45','Detroit','35') ; 
INSERT INTO city VALUES ('46','Dover','8') ; 
INSERT INTO city VALUES ('47','Dubuque','16') ; 
INSERT INTO city VALUES ('48','Duluth','36') ; 
INSERT INTO city VALUES ('49','Edwards','5') ; 
INSERT INTO city VALUES ('50','Enid','31') ; 
INSERT INTO city VALUES ('51','Erie','39') ; 
INSERT INTO city VALUES ('52','Fairbanks','2') ; 
INSERT INTO city VALUES ('53','Fairfield','5') ; 
INSERT INTO city VALUES ('54','Fort Lauderdale','10') ; 
INSERT INTO city VALUES ('55','Fort Myers','10') ; 
INSERT INTO city VALUES ('56','Fort Smith','4') ; 
INSERT INTO city VALUES ('57','Fort Wayne','15') ; 
INSERT INTO city VALUES ('58','Fort Worth','44') ; 
INSERT INTO city VALUES ('59','Glendale','3') ; 
INSERT INTO city VALUES ('60','Goldsboro','28') ; 
INSERT INTO city VALUES ('61','Green Bay','50') ; 
INSERT INTO city VALUES ('62','Greensboro','28') ; 
INSERT INTO city VALUES ('63','Greenville','41') ; 
INSERT INTO city VALUES ('64','Gulfport','37') ; 
INSERT INTO city VALUES ('65','Hampton','47') ; 
INSERT INTO city VALUES ('66','Hartford','7') ; 
INSERT INTO city VALUES ('67','Hibbing','36') ; 
INSERT INTO city VALUES ('68','Honolulu','12') ; 
INSERT INTO city VALUES ('69','Houston','44') ; 
INSERT INTO city VALUES ('70','Huntington','49') ; 
INSERT INTO city VALUES ('71','Huntsville','1') ; 
INSERT INTO city VALUES ('72','Indianapolis','15') ; 
INSERT INTO city VALUES ('73','Jackson','37') ; 
INSERT INTO city VALUES ('74','Jacksonville','10') ; 
INSERT INTO city VALUES ('75','Joplin','38') ; 
INSERT INTO city VALUES ('76','Kansas City','38') ; 
INSERT INTO city VALUES ('77','Knob Noster','38') ; 
INSERT INTO city VALUES ('78','Knoxville','43') ; 
INSERT INTO city VALUES ('79','Lafayette','19') ; 
INSERT INTO city VALUES ('80','Las Vegas','23') ; 
INSERT INTO city VALUES ('81','Lexington','18') ; 
INSERT INTO city VALUES ('82','Little Rock','4') ; 
INSERT INTO city VALUES ('83','Lompoc','5') ; 
INSERT INTO city VALUES ('84','Los Angeles','5') ; 
INSERT INTO city VALUES ('85','Louisville','18') ; 
INSERT INTO city VALUES ('86','Lubbock','44') ; 
INSERT INTO city VALUES ('87','Madison','50') ; 
INSERT INTO city VALUES ('88','Marietta','11') ; 
INSERT INTO city VALUES ('89','Marysville','5') ; 
INSERT INTO city VALUES ('90','Memphis','43') ; 
INSERT INTO city VALUES ('91','Miami','10') ; 
INSERT INTO city VALUES ('92','Milwaukee','50') ; 
INSERT INTO city VALUES ('93','Minneapolis','36') ; 
INSERT INTO city VALUES ('94','Mobile','1') ; 
INSERT INTO city VALUES ('95','Moline','14') ; 
INSERT INTO city VALUES ('96','Monroe','19') ; 
INSERT INTO city VALUES ('97','Montgomery','1') ; 
INSERT INTO city VALUES ('98','Mountain Home','13') ; 
INSERT INTO city VALUES ('99','Nashville','43') ; 
INSERT INTO city VALUES ('100','New Orleans','19') ; 
INSERT INTO city VALUES ('101','New York','27') ; 
INSERT INTO city VALUES ('102','Newark','25') ; 
INSERT INTO city VALUES ('103','Newport News','47') ; 
INSERT INTO city VALUES ('104','Norfolk','47') ; 
INSERT INTO city VALUES ('105','Oakland','5') ; 
INSERT INTO city VALUES ('106','Oklahoma City','31') ; 
INSERT INTO city VALUES ('107','Omaha','22') ; 
INSERT INTO city VALUES ('108','Ontario','5') ; 
INSERT INTO city VALUES ('109','Orlando','10') ; 
INSERT INTO city VALUES ('110','Panama City','10') ; 
INSERT INTO city VALUES ('111','Peoria','14') ; 
INSERT INTO city VALUES ('112','Peru','15') ; 
INSERT INTO city VALUES ('113','Philadelphia','39') ; 
INSERT INTO city VALUES ('114','Phoenix','3') ; 
INSERT INTO city VALUES ('115','Pittsburgh','39') ; 
INSERT INTO city VALUES ('116','Portland','32') ; 
INSERT INTO city VALUES ('117','Portland','20') ; 
INSERT INTO city VALUES ('118','Raleigh/Durham','28') ; 
INSERT INTO city VALUES ('119','Reno','23') ; 
INSERT INTO city VALUES ('120','Richmond','47') ; 
INSERT INTO city VALUES ('121','Roanoke','47') ; 
INSERT INTO city VALUES ('122','Rochester','27') ; 
INSERT INTO city VALUES ('123','Rochester','36') ; 
INSERT INTO city VALUES ('124','Sacramento','5') ; 
INSERT INTO city VALUES ('125','Saginaw','35') ; 
INSERT INTO city VALUES ('126','Salt Lake City','45') ; 
INSERT INTO city VALUES ('127','San Antonio','44') ; 
INSERT INTO city VALUES ('128','San Diego','5') ; 
INSERT INTO city VALUES ('129','San Francisco','5') ; 
INSERT INTO city VALUES ('130','San Jose','5') ; 
INSERT INTO city VALUES ('131','Santa Ana','5') ; 
INSERT INTO city VALUES ('132','Sarasota/Bradenton','10') ; 
INSERT INTO city VALUES ('133','Savannah','11') ; 
INSERT INTO city VALUES ('134','Seattle','48') ; 
INSERT INTO city VALUES ('135','Sioux City','16') ; 
INSERT INTO city VALUES ('136','South Bend','15') ; 
INSERT INTO city VALUES ('137','Spokane','48') ; 
INSERT INTO city VALUES ('138','Springfield','38') ; 
INSERT INTO city VALUES ('139','Springfield','14') ; 
INSERT INTO city VALUES ('140','St Louis','38') ; 
INSERT INTO city VALUES ('141','Sumter','41') ; 
INSERT INTO city VALUES ('142','Syracuse','27') ; 
INSERT INTO city VALUES ('143','Tacoma','48') ; 
INSERT INTO city VALUES ('144','Tallahassee','10') ; 
INSERT INTO city VALUES ('145','Tampa','10') ; 
INSERT INTO city VALUES ('146','Toledo','30') ; 
INSERT INTO city VALUES ('147','Tucson','3') ; 
INSERT INTO city VALUES ('148','Tulsa','31') ; 
INSERT INTO city VALUES ('149','Universal City','44') ; 
INSERT INTO city VALUES ('150','Valparaiso','10') ; 
INSERT INTO city VALUES ('151','Warner Robins','11') ; 
INSERT INTO city VALUES ('152','Washington','9') ; 
INSERT INTO city VALUES ('153','West Palm Beach','10') ; 
INSERT INTO city VALUES ('154','Wichita','17') ; 
INSERT INTO city VALUES ('155','Wichita Falls','44') ; 

INSERT INTO airport VALUES ('1','ABQ','Albuquerque International Sunport','3') ; 
INSERT INTO airport VALUES ('2','AFW','Fort Worth Alliance Airport','58') ; 
INSERT INTO airport VALUES ('3','AGS','Augusta Regional At Bush Field','9') ; 
INSERT INTO airport VALUES ('4','AMA','Rick Husband Amarillo International Airport','5') ; 
INSERT INTO airport VALUES ('5','ANC','Ted Stevens Anchorage International Airport','6') ; 
INSERT INTO airport VALUES ('6','ATL','Hartsfield Jackson Atlanta International Airport','8') ; 
INSERT INTO airport VALUES ('7','AUS','Austin Bergstrom International Airport','10') ; 
INSERT INTO airport VALUES ('8','AVL','Asheville Regional Airport','7') ; 
INSERT INTO airport VALUES ('9','BDL','Bradley International Airport','66') ; 
INSERT INTO airport VALUES ('10','BFI','Boeing Field King County International Airport','134') ; 
INSERT INTO airport VALUES ('11','BGR','Bangor International Airport','12') ; 
INSERT INTO airport VALUES ('12','BHM','Birmingham-Shuttlesworth International Airport','15') ; 
INSERT INTO airport VALUES ('13','BIL','Billings Logan International Airport','14') ; 
INSERT INTO airport VALUES ('14','BLV','Scott AFB/Midamerica Airport','13') ; 
INSERT INTO airport VALUES ('15','BMI','Central Illinois Regional Airport at Bloomington-Normal','16') ; 
INSERT INTO airport VALUES ('16','BNA','Nashville International Airport','99') ; 
INSERT INTO airport VALUES ('17','BOI','Boise Air Terminal/Gowen Field','17') ; 
INSERT INTO airport VALUES ('18','BOS','General Edward Lawrence Logan International Airport','19') ; 
INSERT INTO airport VALUES ('19','BUF','Buffalo Niagara International Airport','21') ; 
INSERT INTO airport VALUES ('20','BWI','Baltimore/Washington International Thurgood Marshall Airport','11') ; 
INSERT INTO airport VALUES ('21','CAE','Columbia Metropolitan Airport','34') ; 
INSERT INTO airport VALUES ('22','CHA','Lovell Field','28') ; 
INSERT INTO airport VALUES ('23','CHS','Charleston Air Force Base-International Airport','25') ; 
INSERT INTO airport VALUES ('24','CID','The Eastern Iowa Airport','24') ; 
INSERT INTO airport VALUES ('25','CLE','Cleveland Hopkins International Airport','32') ; 
INSERT INTO airport VALUES ('26','CLT','Charlotte Douglas International Airport','27') ; 
INSERT INTO airport VALUES ('27','CMH','John Glenn Columbus International Airport','35') ; 
INSERT INTO airport VALUES ('28','CPR','Casper-Natrona County International Airport','23') ; 
INSERT INTO airport VALUES ('29','CRP','Corpus Christi International Airport','37') ; 
INSERT INTO airport VALUES ('30','CRW','Yeager Airport','25') ; 
INSERT INTO airport VALUES ('31','CVG','Cincinnati Northern Kentucky International Airport','31') ; 
INSERT INTO airport VALUES ('32','DAB','Daytona Beach International Airport','41') ; 
INSERT INTO airport VALUES ('33','DAL','Dallas Love Field','38') ; 
INSERT INTO airport VALUES ('34','DAY','James M Cox Dayton International Airport','40') ; 
INSERT INTO airport VALUES ('35','DBQ','Dubuque Regional Airport','47') ; 
INSERT INTO airport VALUES ('36','DCA','Ronald Reagan Washington National Airport','152') ; 
INSERT INTO airport VALUES ('37','DEN','Denver International Airport','43') ; 
INSERT INTO airport VALUES ('38','DFW','Dallas Fort Worth International Airport','39') ; 
INSERT INTO airport VALUES ('39','DLH','Duluth International Airport','48') ; 
INSERT INTO airport VALUES ('40','DSM','Des Moines International Airport','44') ; 
INSERT INTO airport VALUES ('41','DTW','Detroit Metropolitan Wayne County Airport','45') ; 
INSERT INTO airport VALUES ('42','ERI','Erie International Tom Ridge Field','51') ; 
INSERT INTO airport VALUES ('43','EWR','Newark Liberty International Airport','102') ; 
INSERT INTO airport VALUES ('44','FAI','Fairbanks International Airport','52') ; 
INSERT INTO airport VALUES ('45','FLL','Fort Lauderdale Hollywood International Airport','54') ; 
INSERT INTO airport VALUES ('46','FSM','Fort Smith Regional Airport','56') ; 
INSERT INTO airport VALUES ('47','FTW','Fort Worth Meacham International Airport','58') ; 
INSERT INTO airport VALUES ('48','FWA','Fort Wayne International Airport','57') ; 
INSERT INTO airport VALUES ('49','GEG','Spokane International Airport','137') ; 
INSERT INTO airport VALUES ('50','GPT','Gulfport Biloxi International Airport','64') ; 
INSERT INTO airport VALUES ('51','GRB','Austin Straubel International Airport','61') ; 
INSERT INTO airport VALUES ('52','GSO','Piedmont Triad International Airport','62') ; 
INSERT INTO airport VALUES ('53','GSP','Greenville Spartanburg International Airport','63') ; 
INSERT INTO airport VALUES ('54','HIB','Range Regional Airport','67') ; 
INSERT INTO airport VALUES ('55','HNL','Daniel K Inouye International Airport','68') ; 
INSERT INTO airport VALUES ('56','HOU','William P Hobby Airport','69') ; 
INSERT INTO airport VALUES ('57','HSV','Huntsville International Carl T Jones Field','71') ; 
INSERT INTO airport VALUES ('58','HTS','Tri-State/Milton J. Ferguson Field','70') ; 
INSERT INTO airport VALUES ('59','IAD','Washington Dulles International Airport','152') ; 
INSERT INTO airport VALUES ('60','IAH','George Bush Intercontinental Houston Airport','69') ; 
INSERT INTO airport VALUES ('61','ICT','Wichita Eisenhower National Airport','154') ; 
INSERT INTO airport VALUES ('62','IND','Indianapolis International Airport','72') ; 
INSERT INTO airport VALUES ('63','JAN','Jackson-Medgar Wiley Evers International Airport','73') ; 
INSERT INTO airport VALUES ('64','JAX','Jacksonville International Airport','74') ; 
INSERT INTO airport VALUES ('65','JFK','John F Kennedy International Airport','101') ; 
INSERT INTO airport VALUES ('66','JLN','Joplin Regional Airport','75') ; 
INSERT INTO airport VALUES ('67','LAS','McCarran International Airport','80') ; 
INSERT INTO airport VALUES ('68','LAX','Los Angeles International Airport','84') ; 
INSERT INTO airport VALUES ('69','LBB','Lubbock Preston Smith International Airport','86') ; 
INSERT INTO airport VALUES ('70','LCK','Rickenbacker International Airport','35') ; 
INSERT INTO airport VALUES ('71','LEX','Blue Grass Airport','81') ; 
INSERT INTO airport VALUES ('72','LFT','Lafayette Regional Airport','79') ; 
INSERT INTO airport VALUES ('73','LGA','La Guardia Airport','101') ; 
INSERT INTO airport VALUES ('74','LIT','Bill & Hillary Clinton National Airport/Adams Field','82') ; 
INSERT INTO airport VALUES ('75','MBS','MBS International Airport','125') ; 
INSERT INTO airport VALUES ('76','MCI','Kansas City International Airport','76') ; 
INSERT INTO airport VALUES ('77','MCO','Orlando International Airport','109') ; 
INSERT INTO airport VALUES ('78','MDW','Chicago Midway International Airport','29') ; 
INSERT INTO airport VALUES ('79','MEM','Memphis International Airport','90') ; 
INSERT INTO airport VALUES ('80','MGM','Montgomery Regional (Dannelly Field) Airport','97') ; 
INSERT INTO airport VALUES ('81','MIA','Miami International Airport','91') ; 
INSERT INTO airport VALUES ('82','MKE','General Mitchell International Airport','92') ; 
INSERT INTO airport VALUES ('83','MLI','Quad City International Airport','95') ; 
INSERT INTO airport VALUES ('84','MLU','Monroe Regional Airport','96') ; 
INSERT INTO airport VALUES ('85','MOB','Mobile Regional Airport','94') ; 
INSERT INTO airport VALUES ('86','MSN','Dane County Regional Truax Field','87') ; 
INSERT INTO airport VALUES ('87','MSP','Minneapolis-St Paul International/Wold-Chamberlain Airport','93') ; 
INSERT INTO airport VALUES ('88','MSY','Louis Armstrong New Orleans International Airport','100') ; 
INSERT INTO airport VALUES ('89','OAK','Metropolitan Oakland International Airport','105') ; 
INSERT INTO airport VALUES ('90','OKC','Will Rogers World Airport','106') ; 
INSERT INTO airport VALUES ('91','OMA','Eppley Airfield','107') ; 
INSERT INTO airport VALUES ('92','ONT','Ontario International Airport','108') ; 
INSERT INTO airport VALUES ('93','ORD',"Chicago O'Hare International Airport",'29') ; 
INSERT INTO airport VALUES ('94','ORF','Norfolk International Airport','104') ; 
INSERT INTO airport VALUES ('95','PBI','Palm Beach International Airport','153') ; 
INSERT INTO airport VALUES ('96','PDX','Portland International Airport','116') ; 
INSERT INTO airport VALUES ('97','PHF','Newport News Williamsburg International Airport','103') ; 
INSERT INTO airport VALUES ('98','PHL','Philadelphia International Airport','113') ; 
INSERT INTO airport VALUES ('99','PHX','Phoenix Sky Harbor International Airport','114') ; 
INSERT INTO airport VALUES ('100','PIA','General Wayne A. Downing Peoria International Airport','111') ; 
INSERT INTO airport VALUES ('101','PIT','Pittsburgh International Airport','115') ; 
INSERT INTO airport VALUES ('102','PWM','Portland International Jetport Airport','116') ; 
INSERT INTO airport VALUES ('103','RDU','Raleigh Durham International Airport','118') ; 
INSERT INTO airport VALUES ('104','RFD','Chicago Rockford International Airport','30') ; 
INSERT INTO airport VALUES ('105','RIC','Richmond International Airport','120') ; 
INSERT INTO airport VALUES ('106','RNO','Reno Tahoe International Airport','119') ; 
INSERT INTO airport VALUES ('107','ROA','Roanoke–Blacksburg Regional Airport','121') ; 
INSERT INTO airport VALUES ('108','ROC','Greater Rochester International Airport','122') ; 
INSERT INTO airport VALUES ('109','RST','Rochester International Airport','122') ; 
INSERT INTO airport VALUES ('110','RSW','Southwest Florida International Airport','55') ; 
INSERT INTO airport VALUES ('111','SAN','San Diego International Airport','128') ; 
INSERT INTO airport VALUES ('112','SAT','San Antonio International Airport','127') ; 
INSERT INTO airport VALUES ('113','SAV','Savannah Hilton Head International Airport','133') ; 
INSERT INTO airport VALUES ('114','SBN','South Bend Regional Airport','136') ; 
INSERT INTO airport VALUES ('115','SDF','Louisville International Standiford Field','85') ; 
INSERT INTO airport VALUES ('116','SEA','Seattle Tacoma International Airport','134') ; 
INSERT INTO airport VALUES ('117','SFB','Orlando Sanford International Airport','109') ; 
INSERT INTO airport VALUES ('118','SFO','San Francisco International Airport','129') ; 
INSERT INTO airport VALUES ('119','SGF','Springfield Branson National Airport','138') ; 
INSERT INTO airport VALUES ('120','SJC','Norman Y. Mineta San Jose International Airport','130') ; 
INSERT INTO airport VALUES ('121','SLC','Salt Lake City International Airport','126') ; 
INSERT INTO airport VALUES ('122','SMF','Sacramento International Airport','124') ; 
INSERT INTO airport VALUES ('123','SNA','John Wayne Airport-Orange County Airport','131') ; 
INSERT INTO airport VALUES ('124','SPI','Abraham Lincoln Capital Airport','138') ; 
INSERT INTO airport VALUES ('125','SRQ','Sarasota Bradenton International Airport','132') ; 
INSERT INTO airport VALUES ('126','STL','St Louis Lambert International Airport','140') ; 
INSERT INTO airport VALUES ('127','SUS','Spirit of St Louis Airport','140') ; 
INSERT INTO airport VALUES ('128','SUX','Sioux Gateway Col. Bud Day Field','135') ; 
INSERT INTO airport VALUES ('129','SYR','Syracuse Hancock International Airport','142') ; 
INSERT INTO airport VALUES ('130','TLH','Tallahassee Regional Airport','144') ; 
INSERT INTO airport VALUES ('131','TOL','Toledo Express Airport','146') ; 
INSERT INTO airport VALUES ('132','TPA','Tampa International Airport','145') ; 
INSERT INTO airport VALUES ('133','TRI','Tri-Cities Regional TN/VA Airport','20') ; 
INSERT INTO airport VALUES ('134','TUL','Tulsa International Airport','148') ; 
INSERT INTO airport VALUES ('135','TUS','Tucson International Airport','147') ; 
INSERT INTO airport VALUES ('136','TYS','McGhee Tyson Airport','78') ; 
INSERT INTO airport VALUES ('137','VPS','Destin-Ft Walton Beach Airport','150') ; 

INSERT INTO flight VALUES ('1','2018-12-01 15:11:31','397','2208','383.27','156','67','26') ; 
INSERT INTO flight VALUES ('2','2018-12-01 08:53:05','445','2472','464.05','1','118','6') ; 
INSERT INTO flight VALUES ('3','2018-12-01 09:27:24','156','867','133.68','49','37','38') ; 
INSERT INTO flight VALUES ('4','2018-12-01 09:29:39','189','1049','190.00','260','38','26') ; 
INSERT INTO flight VALUES ('5','2018-12-01 17:14:45','239','1327','152.11','36','116','37') ; 
INSERT INTO flight VALUES ('6','2018-12-01 08:34:54','393','2184','343.65','225','116','38') ; 
INSERT INTO flight VALUES ('7','2018-12-01 16:30:22','135','748','143.50','109','67','37') ; 
INSERT INTO flight VALUES ('8','2018-12-01 04:42:50','217','1203','178.12','94','67','38') ; 
INSERT INTO flight VALUES ('9','2018-12-01 18:17:00','435','2419','370.48','220','68','26') ; 
INSERT INTO flight VALUES ('10','2018-12-01 17:14:50','159','881','132.95','190','6','65') ; 
INSERT INTO flight VALUES ('11','2018-12-01 04:06:42','454','2523','410.12','226','65','67') ; 
INSERT INTO flight VALUES ('12','2018-12-01 21:46:14','354','1965','381.48','37','6','67') ; 
INSERT INTO flight VALUES ('13','2018-12-01 20:13:31','500','2777','562.45','253','65','68') ; 
INSERT INTO flight VALUES ('14','2018-12-01 21:15:09','392','2176','289.57','148','6','68') ; 
INSERT INTO flight VALUES ('15','2018-12-01 12:03:13','156','867','193.41','208','38','37') ; 
INSERT INTO flight VALUES ('16','2018-12-01 15:28:17','116','643','102.58','165','26','65') ; 
INSERT INTO flight VALUES ('17','2018-12-01 08:28:19','397','2208','326.58','165','26','67') ; 
INSERT INTO flight VALUES ('18','2018-12-01 06:47:06','435','2419','345.86','126','26','68') ; 
INSERT INTO flight VALUES ('19','2018-12-01 04:11:04','489','2716','470.07','16','118','26') ; 
INSERT INTO flight VALUES ('20','2018-12-01 19:11:07','183','1016','137.27','3','68','37') ; 
INSERT INTO flight VALUES ('21','2018-12-01 05:19:22','255','1415','200.80','19','68','38') ; 
INSERT INTO flight VALUES ('22','2018-12-01 00:36:22','320','1778','320.91','175','37','65') ; 
INSERT INTO flight VALUES ('23','2018-12-01 07:35:09','228','1268','180.00','180','118','37') ; 
INSERT INTO flight VALUES ('24','2018-12-01 02:40:17','135','748','138.48','83','37','67') ; 
INSERT INTO flight VALUES ('25','2018-12-01 06:26:07','308','1712','303.82','27','118','38') ; 
INSERT INTO flight VALUES ('26','2018-12-01 12:45:11','183','1016','107.22','196','37','68') ; 
INSERT INTO flight VALUES ('27','2018-12-01 02:20:10','520','2887','356.33','231','116','65') ; 
INSERT INTO flight VALUES ('28','2018-12-01 12:09:22','226','1253','190.65','25','116','67') ; 
INSERT INTO flight VALUES ('29','2018-12-01 00:59:45','454','2523','414.59','236','67','65') ; 
INSERT INTO flight VALUES ('30','2018-12-01 10:24:05','205','1137','159.81','130','116','68') ; 
INSERT INTO flight VALUES ('31','2018-12-01 18:26:29','142','789','93.91','151','65','93') ; 
INSERT INTO flight VALUES ('32','2018-12-01 13:23:53','129','715','93.97','264','6','93') ; 
INSERT INTO flight VALUES ('33','2018-12-01 22:05:30','49','271','43.03','215','67','68') ; 
INSERT INTO flight VALUES ('34','2018-12-01 05:38:39','378','2100','339.29','184','93','116') ; 
INSERT INTO flight VALUES ('35','2018-12-01 11:00:39','384','2131','250.04','164','93','118') ; 
INSERT INTO flight VALUES ('36','2018-12-01 04:35:58','282','1566','230.67','87','38','65') ; 
INSERT INTO flight VALUES ('37','2018-12-01 07:35:26','135','749','135.55','147','26','93') ; 
INSERT INTO flight VALUES ('38','2018-12-01 08:30:13','217','1203','142.99','177','38','67') ; 
INSERT INTO flight VALUES ('39','2018-12-01 06:30:44','255','1415','193.18','55','38','68') ; 
INSERT INTO flight VALUES ('40','2018-12-01 04:49:36','500','2777','491.14','254','68','65') ; 
INSERT INTO flight VALUES ('41','2018-12-01 03:47:59','49','271','35.35','26','68','67') ; 
INSERT INTO flight VALUES ('42','2018-12-01 02:15:46','181','1003','163.35','176','37','93') ; 
INSERT INTO flight VALUES ('43','2018-12-01 14:20:40','129','715','135.62','82','93','6') ; 
INSERT INTO flight VALUES ('44','2018-12-01 19:23:09','523','2906','397.61','135','118','65') ; 
INSERT INTO flight VALUES ('45','2018-12-01 23:45:09','520','2887','323.53','28','65','116') ; 
INSERT INTO flight VALUES ('46','2018-12-01 06:46:54','102','566','58.96','135','118','67') ; 
INSERT INTO flight VALUES ('47','2018-12-01 16:11:47','378','2100','304.19','125','116','93') ; 
INSERT INTO flight VALUES ('48','2018-12-01 03:40:24','485','2693','515.54','19','6','116') ; 
INSERT INTO flight VALUES ('49','2018-12-01 13:31:26','69','381','42.65','138','118','68') ; 
INSERT INTO flight VALUES ('50','2018-12-01 11:33:40','523','2906','453.56','186','65','118') ; 
INSERT INTO flight VALUES ('51','2018-12-01 02:29:03','445','2472','386.41','166','6','118') ; 
INSERT INTO flight VALUES ('52','2018-12-01 17:15:46','314','1747','189.08','205','67','93') ; 
INSERT INTO flight VALUES ('53','2018-12-01 16:15:47','513','2851','336.90','12','26','116') ; 
INSERT INTO flight VALUES ('54','2018-12-01 09:02:14','489','2716','411.94','6','26','118') ; 
INSERT INTO flight VALUES ('55','2018-12-01 06:49:14','167','929','107.13','25','38','93') ; 
INSERT INTO flight VALUES ('56','2018-12-01 13:56:45','363','2015','335.11','207','68','93') ; 
INSERT INTO flight VALUES ('57','2018-12-01 02:13:30','135','749','130.03','110','93','26') ; 
INSERT INTO flight VALUES ('58','2018-12-01 12:30:06','159','881','119.90','245','65','6') ; 
INSERT INTO flight VALUES ('59','2018-12-01 06:38:13','239','1327','193.03','64','37','116') ; 
INSERT INTO flight VALUES ('60','2018-12-01 23:47:01','228','1268','138.29','107','37','118') ; 
INSERT INTO flight VALUES ('61','2018-12-01 11:56:20','44','244','36.23','192','26','6') ; 
INSERT INTO flight VALUES ('62','2018-12-01 08:11:09','146','809','105.69','155','116','118') ; 
INSERT INTO flight VALUES ('63','2018-12-01 00:02:43','384','2131','273.19','229','118','93') ; 
INSERT INTO flight VALUES ('64','2018-12-01 15:20:11','226','1253','242.32','62','67','116') ; 
INSERT INTO flight VALUES ('65','2018-12-01 14:59:51','102','566','68.92','53','67','118') ; 
INSERT INTO flight VALUES ('66','2018-12-01 18:46:04','181','1003','176.52','162','93','37') ; 
INSERT INTO flight VALUES ('67','2018-12-01 00:38:52','167','929','144.06','118','93','38') ; 
INSERT INTO flight VALUES ('68','2018-12-01 13:57:41','393','2184','401.17','265','38','116') ; 
INSERT INTO flight VALUES ('69','2018-12-01 09:22:28','308','1712','221.84','92','38','118') ; 
INSERT INTO flight VALUES ('70','2018-12-01 16:17:10','254','1409','292.26','234','37','6') ; 
INSERT INTO flight VALUES ('71','2018-12-01 14:51:57','116','643','65.46','81','65','26') ; 
INSERT INTO flight VALUES ('72','2018-12-01 02:49:19','44','244','35.51','20','6','26') ; 
INSERT INTO flight VALUES ('73','2018-12-01 11:40:26','205','1137','163.14','44','68','116') ; 
INSERT INTO flight VALUES ('74','2018-12-01 05:55:49','69','381','58.91','177','68','118') ; 
INSERT INTO flight VALUES ('75','2018-12-01 04:41:23','485','2693','499.37','250','116','6') ; 
INSERT INTO flight VALUES ('76','2018-12-01 11:06:57','354','1965','261.12','219','67','6') ; 
INSERT INTO flight VALUES ('77','2018-12-01 07:25:24','320','1778','260.23','53','65','37') ; 
INSERT INTO flight VALUES ('78','2018-12-01 11:40:25','146','809','118.17','51','118','116') ; 
INSERT INTO flight VALUES ('79','2018-12-01 14:08:04','254','1409','245.18','87','6','37') ; 
INSERT INTO flight VALUES ('80','2018-12-01 03:44:46','282','1566','229.82','164','65','38') ; 
INSERT INTO flight VALUES ('81','2018-12-01 09:49:56','145','803','115.74','62','6','38') ; 
INSERT INTO flight VALUES ('82','2018-12-01 17:28:25','145','803','117.39','67','38','6') ; 
INSERT INTO flight VALUES ('83','2018-12-01 10:25:15','283','1570','230.32','34','26','37') ; 
INSERT INTO flight VALUES ('84','2018-12-01 00:15:24','189','1049','172.35','71','26','38') ; 
INSERT INTO flight VALUES ('85','2018-12-01 23:44:20','392','2176','251.01','154','68','6') ; 
INSERT INTO flight VALUES ('86','2018-12-01 05:53:48','142','789','136.23','82','93','65') ; 
INSERT INTO flight VALUES ('87','2018-12-01 14:10:14','283','1570','317.87','53','37','26') ; 
INSERT INTO flight VALUES ('88','2018-12-01 20:06:54','314','1747','199.72','44','93','67') ; 
INSERT INTO flight VALUES ('89','2018-12-01 02:24:47','363','2015','296.24','75','93','68') ; 
INSERT INTO flight VALUES ('90','2018-12-01 04:48:48','513','2851','373.81','78','116','26') ; 
INSERT INTO flight VALUES ('91','2018-12-02 22:36:07','397','2208','301.33','154','67','26') ; 
INSERT INTO flight VALUES ('92','2018-12-02 07:07:45','445','2472','369.04','39','118','6') ; 
INSERT INTO flight VALUES ('93','2018-12-02 18:51:04','156','867','133.73','95','37','38') ; 
INSERT INTO flight VALUES ('94','2018-12-02 19:09:14','189','1049','192.58','214','38','26') ; 
INSERT INTO flight VALUES ('95','2018-12-02 04:40:28','239','1327','194.24','69','116','37') ; 
INSERT INTO flight VALUES ('96','2018-12-02 01:55:32','393','2184','315.00','75','116','38') ; 
INSERT INTO flight VALUES ('97','2018-12-02 22:44:33','135','748','139.93','48','67','37') ; 
INSERT INTO flight VALUES ('98','2018-12-02 10:04:40','217','1203','176.78','169','67','38') ; 
INSERT INTO flight VALUES ('99','2018-12-02 16:17:24','435','2419','330.21','89','68','26') ; 
INSERT INTO flight VALUES ('100','2018-12-02 09:24:54','159','881','122.03','80','6','65') ; 
INSERT INTO flight VALUES ('101','2018-12-02 01:26:25','454','2523','409.70','187','65','67') ; 
INSERT INTO flight VALUES ('102','2018-12-02 16:09:07','354','1965','333.14','7','6','67') ; 
INSERT INTO flight VALUES ('103','2018-12-02 05:50:01','500','2777','394.28','151','65','68') ; 
INSERT INTO flight VALUES ('104','2018-12-02 11:47:08','392','2176','253.86','35','6','68') ; 
INSERT INTO flight VALUES ('105','2018-12-02 11:31:34','156','867','184.90','137','38','37') ; 
INSERT INTO flight VALUES ('106','2018-12-02 00:03:04','116','643','98.39','99','26','65') ; 
INSERT INTO flight VALUES ('107','2018-12-02 16:22:35','397','2208','332.68','64','26','67') ; 
INSERT INTO flight VALUES ('108','2018-12-02 06:23:36','435','2419','394.48','239','26','68') ; 
INSERT INTO flight VALUES ('109','2018-12-02 11:47:22','489','2716','462.16','255','118','26') ; 
INSERT INTO flight VALUES ('110','2018-12-02 05:58:22','183','1016','124.58','184','68','37') ; 
INSERT INTO flight VALUES ('111','2018-12-02 08:05:07','255','1415','187.79','263','68','38') ; 
INSERT INTO flight VALUES ('112','2018-12-02 00:12:41','320','1778','253.63','184','37','65') ; 
INSERT INTO flight VALUES ('113','2018-12-02 08:25:35','228','1268','161.46','17','118','37') ; 
INSERT INTO flight VALUES ('114','2018-12-02 11:24:03','135','748','123.55','214','37','67') ; 
INSERT INTO flight VALUES ('115','2018-12-02 16:53:54','308','1712','280.70','127','118','38') ; 
INSERT INTO flight VALUES ('116','2018-12-02 00:45:31','183','1016','123.57','45','37','68') ; 
INSERT INTO flight VALUES ('117','2018-12-02 00:14:15','520','2887','301.68','11','116','65') ; 
INSERT INTO flight VALUES ('118','2018-12-02 02:30:30','226','1253','248.98','157','116','67') ; 
INSERT INTO flight VALUES ('119','2018-12-02 00:06:18','454','2523','468.74','252','67','65') ; 
INSERT INTO flight VALUES ('120','2018-12-02 23:26:22','205','1137','141.67','201','116','68') ; 
INSERT INTO flight VALUES ('121','2018-12-02 08:53:39','142','789','122.32','32','65','93') ; 
INSERT INTO flight VALUES ('122','2018-12-02 01:15:42','129','715','135.05','113','6','93') ; 
INSERT INTO flight VALUES ('123','2018-12-02 19:31:27','49','271','41.61','90','67','68') ; 
INSERT INTO flight VALUES ('124','2018-12-02 02:15:23','378','2100','331.79','242','93','116') ; 
INSERT INTO flight VALUES ('125','2018-12-02 03:23:35','384','2131','315.17','191','93','118') ; 
INSERT INTO flight VALUES ('126','2018-12-02 21:46:42','282','1566','248.97','181','38','65') ; 
INSERT INTO flight VALUES ('127','2018-12-02 19:03:37','135','749','135.77','58','26','93') ; 
INSERT INTO flight VALUES ('128','2018-12-02 08:41:55','217','1203','188.17','31','38','67') ; 
INSERT INTO flight VALUES ('129','2018-12-02 13:05:10','255','1415','180.60','62','38','68') ; 
INSERT INTO flight VALUES ('130','2018-12-02 21:48:48','500','2777','391.89','154','68','65') ; 
INSERT INTO flight VALUES ('131','2018-12-02 16:12:55','49','271','36.96','187','68','67') ; 
INSERT INTO flight VALUES ('132','2018-12-02 19:18:53','181','1003','158.28','148','37','93') ; 
INSERT INTO flight VALUES ('133','2018-12-02 23:40:19','129','715','142.32','22','93','6') ; 
INSERT INTO flight VALUES ('134','2018-12-02 12:20:07','523','2906','559.52','30','118','65') ; 
INSERT INTO flight VALUES ('135','2018-12-02 07:56:02','520','2887','276.82','71','65','116') ; 
INSERT INTO flight VALUES ('136','2018-12-02 19:35:18','102','566','75.02','187','118','67') ; 
INSERT INTO flight VALUES ('137','2018-12-02 17:03:40','378','2100','360.09','254','116','93') ; 
INSERT INTO flight VALUES ('138','2018-12-02 23:01:40','485','2693','384.60','157','6','116') ; 
INSERT INTO flight VALUES ('139','2018-12-02 08:01:26','69','381','59.49','74','118','68') ; 
INSERT INTO flight VALUES ('140','2018-12-02 02:20:59','523','2906','625.52','203','65','118') ; 
INSERT INTO flight VALUES ('141','2018-12-02 17:57:33','445','2472','397.19','20','6','118') ; 
INSERT INTO flight VALUES ('142','2018-12-02 14:23:21','314','1747','246.31','121','67','93') ; 
INSERT INTO flight VALUES ('143','2018-12-02 09:44:34','513','2851','394.70','140','26','116') ; 
INSERT INTO flight VALUES ('144','2018-12-02 08:36:20','489','2716','394.61','165','26','118') ; 
INSERT INTO flight VALUES ('145','2018-12-02 01:34:43','167','929','151.65','108','38','93') ; 
INSERT INTO flight VALUES ('146','2018-12-02 08:16:44','363','2015','307.89','171','68','93') ; 
INSERT INTO flight VALUES ('147','2018-12-02 10:00:04','135','749','153.20','127','93','26') ; 
INSERT INTO flight VALUES ('148','2018-12-02 01:15:02','159','881','145.74','8','65','6') ; 
INSERT INTO flight VALUES ('149','2018-12-02 01:22:41','239','1327','180.92','224','37','116') ; 
INSERT INTO flight VALUES ('150','2018-12-02 04:03:55','228','1268','168.57','41','37','118') ; 
INSERT INTO flight VALUES ('151','2018-12-02 17:01:11','44','244','38.66','265','26','6') ; 
INSERT INTO flight VALUES ('152','2018-12-02 11:21:01','146','809','103.45','229','116','118') ; 
INSERT INTO flight VALUES ('153','2018-12-02 16:42:48','384','2131','274.35','25','118','93') ; 
INSERT INTO flight VALUES ('154','2018-12-02 22:57:30','226','1253','210.32','159','67','116') ; 
INSERT INTO flight VALUES ('155','2018-12-02 10:47:03','102','566','50.86','159','67','118') ; 
INSERT INTO flight VALUES ('156','2018-12-02 08:25:25','181','1003','200.43','221','93','37') ; 
INSERT INTO flight VALUES ('157','2018-12-02 19:28:22','167','929','136.12','67','93','38') ; 
INSERT INTO flight VALUES ('158','2018-12-02 05:59:06','393','2184','363.80','51','38','116') ; 
INSERT INTO flight VALUES ('159','2018-12-02 20:58:02','308','1712','318.87','77','38','118') ; 
INSERT INTO flight VALUES ('160','2018-12-02 21:20:20','254','1409','234.50','98','37','6') ; 
INSERT INTO flight VALUES ('161','2018-12-02 04:20:11','116','643','86.77','4','65','26') ; 
INSERT INTO flight VALUES ('162','2018-12-02 08:10:34','44','244','37.20','113','6','26') ; 
INSERT INTO flight VALUES ('163','2018-12-02 02:51:20','205','1137','169.40','2','68','116') ; 
INSERT INTO flight VALUES ('164','2018-12-02 01:44:25','69','381','54.25','88','68','118') ; 
INSERT INTO flight VALUES ('165','2018-12-02 22:30:57','485','2693','364.72','219','116','6') ; 
INSERT INTO flight VALUES ('166','2018-12-02 21:24:19','354','1965','217.38','200','67','6') ; 
INSERT INTO flight VALUES ('167','2018-12-02 16:05:59','320','1778','244.13','246','65','37') ; 
INSERT INTO flight VALUES ('168','2018-12-02 04:24:38','146','809','120.11','59','118','116') ; 
INSERT INTO flight VALUES ('169','2018-12-02 17:04:00','254','1409','214.46','59','6','37') ; 
INSERT INTO flight VALUES ('170','2018-12-02 03:20:50','282','1566','185.64','57','65','38') ; 
INSERT INTO flight VALUES ('171','2018-12-02 18:26:58','145','803','124.12','143','6','38') ; 
INSERT INTO flight VALUES ('172','2018-12-02 07:05:35','145','803','97.77','44','38','6') ; 
INSERT INTO flight VALUES ('173','2018-12-02 17:16:20','283','1570','241.12','244','26','37') ; 
INSERT INTO flight VALUES ('174','2018-12-02 09:29:05','189','1049','179.01','78','26','38') ; 
INSERT INTO flight VALUES ('175','2018-12-02 15:44:46','392','2176','239.67','26','68','6') ; 
INSERT INTO flight VALUES ('176','2018-12-02 13:31:52','142','789','111.36','117','93','65') ; 
INSERT INTO flight VALUES ('177','2018-12-02 20:39:33','283','1570','276.41','126','37','26') ; 
INSERT INTO flight VALUES ('178','2018-12-02 01:12:43','314','1747','195.33','92','93','67') ; 
INSERT INTO flight VALUES ('179','2018-12-02 06:53:41','363','2015','308.92','100','93','68') ; 
INSERT INTO flight VALUES ('180','2018-12-02 20:42:22','513','2851','440.36','242','116','26') ; 
INSERT INTO flight VALUES ('181','2018-12-03 16:05:55','397','2208','307.14','54','67','26') ; 
INSERT INTO flight VALUES ('182','2018-12-03 02:42:36','445','2472','353.20','192','118','6') ; 
INSERT INTO flight VALUES ('183','2018-12-03 13:15:10','156','867','145.13','48','37','38') ; 
INSERT INTO flight VALUES ('184','2018-12-03 10:56:46','189','1049','164.35','116','38','26') ; 
INSERT INTO flight VALUES ('185','2018-12-03 09:45:07','239','1327','194.03','133','116','37') ; 
INSERT INTO flight VALUES ('186','2018-12-03 07:28:30','393','2184','272.08','45','116','38') ; 
INSERT INTO flight VALUES ('187','2018-12-03 06:36:15','135','748','131.97','37','67','37') ; 
INSERT INTO flight VALUES ('188','2018-12-03 17:33:21','217','1203','254.20','199','67','38') ; 
INSERT INTO flight VALUES ('189','2018-12-03 13:29:28','435','2419','449.52','210','68','26') ; 
INSERT INTO flight VALUES ('190','2018-12-03 13:05:52','159','881','116.30','143','6','65') ; 
INSERT INTO flight VALUES ('191','2018-12-03 07:57:09','454','2523','425.69','19','65','67') ; 
INSERT INTO flight VALUES ('192','2018-12-03 09:58:02','354','1965','352.92','206','6','67') ; 
INSERT INTO flight VALUES ('193','2018-12-03 14:44:26','500','2777','544.59','59','65','68') ; 
INSERT INTO flight VALUES ('194','2018-12-03 11:12:53','392','2176','295.47','247','6','68') ; 
INSERT INTO flight VALUES ('195','2018-12-03 05:15:28','156','867','167.76','18','38','37') ; 
INSERT INTO flight VALUES ('196','2018-12-03 12:43:00','116','643','114.93','7','26','65') ; 
INSERT INTO flight VALUES ('197','2018-12-03 10:14:26','397','2208','336.11','205','26','67') ; 
INSERT INTO flight VALUES ('198','2018-12-03 04:33:43','435','2419','450.01','240','26','68') ; 
INSERT INTO flight VALUES ('199','2018-12-03 05:42:44','489','2716','388.10','83','118','26') ; 
INSERT INTO flight VALUES ('200','2018-12-03 00:55:29','183','1016','121.54','71','68','37') ; 
INSERT INTO flight VALUES ('201','2018-12-03 02:57:37','255','1415','188.26','136','68','38') ; 
INSERT INTO flight VALUES ('202','2018-12-03 08:23:01','320','1778','249.06','130','37','65') ; 
INSERT INTO flight VALUES ('203','2018-12-03 08:37:51','228','1268','140.13','64','118','37') ; 
INSERT INTO flight VALUES ('204','2018-12-03 13:54:24','135','748','144.69','180','37','67') ; 
INSERT INTO flight VALUES ('205','2018-12-03 13:41:57','308','1712','267.38','177','118','38') ; 
INSERT INTO flight VALUES ('206','2018-12-03 23:23:08','183','1016','115.75','124','37','68') ; 
INSERT INTO flight VALUES ('207','2018-12-03 17:14:50','520','2887','354.61','33','116','65') ; 
INSERT INTO flight VALUES ('208','2018-12-03 23:03:03','226','1253','259.81','56','116','67') ; 
INSERT INTO flight VALUES ('209','2018-12-03 17:34:16','454','2523','427.89','179','67','65') ; 
INSERT INTO flight VALUES ('210','2018-12-03 14:08:16','205','1137','171.51','16','116','68') ; 
INSERT INTO flight VALUES ('211','2018-12-03 13:31:12','142','789','125.73','246','65','93') ; 
INSERT INTO flight VALUES ('212','2018-12-03 13:15:24','129','715','133.13','31','6','93') ; 
INSERT INTO flight VALUES ('213','2018-12-03 14:03:41','49','271','33.18','9','67','68') ; 
INSERT INTO flight VALUES ('214','2018-12-03 11:02:28','378','2100','348.33','176','93','116') ; 
INSERT INTO flight VALUES ('215','2018-12-03 06:28:42','384','2131','339.73','102','93','118') ; 
INSERT INTO flight VALUES ('216','2018-12-03 16:54:49','282','1566','230.79','249','38','65') ; 
INSERT INTO flight VALUES ('217','2018-12-03 06:52:49','135','749','156.13','142','26','93') ; 
INSERT INTO flight VALUES ('218','2018-12-03 04:38:44','217','1203','183.92','47','38','67') ; 
INSERT INTO flight VALUES ('219','2018-12-03 21:20:33','255','1415','220.49','218','38','68') ; 
INSERT INTO flight VALUES ('220','2018-12-03 16:29:52','500','2777','463.50','154','68','65') ; 
INSERT INTO flight VALUES ('221','2018-12-03 20:12:20','49','271','36.98','235','68','67') ; 
INSERT INTO flight VALUES ('222','2018-12-03 22:57:34','181','1003','175.97','99','37','93') ; 
INSERT INTO flight VALUES ('223','2018-12-03 10:55:17','129','715','100.44','9','93','6') ; 
INSERT INTO flight VALUES ('224','2018-12-03 16:38:13','523','2906','546.34','5','118','65') ; 
INSERT INTO flight VALUES ('225','2018-12-03 00:17:28','520','2887','270.66','43','65','116') ; 
INSERT INTO flight VALUES ('226','2018-12-03 01:08:13','102','566','82.53','84','118','67') ; 
INSERT INTO flight VALUES ('227','2018-12-03 11:33:58','378','2100','361.97','53','116','93') ; 
INSERT INTO flight VALUES ('228','2018-12-03 03:45:08','485','2693','398.91','238','6','116') ; 
INSERT INTO flight VALUES ('229','2018-12-03 04:53:03','69','381','41.28','15','118','68') ; 
INSERT INTO flight VALUES ('230','2018-12-03 00:44:25','523','2906','523.22','14','65','118') ; 
INSERT INTO flight VALUES ('231','2018-12-03 22:13:17','445','2472','392.60','7','6','118') ; 
INSERT INTO flight VALUES ('232','2018-12-03 22:43:39','314','1747','237.90','235','67','93') ; 
INSERT INTO flight VALUES ('233','2018-12-03 22:29:50','513','2851','309.20','149','26','116') ; 
INSERT INTO flight VALUES ('234','2018-12-03 13:38:09','489','2716','358.04','52','26','118') ; 
INSERT INTO flight VALUES ('235','2018-12-03 19:45:10','167','929','107.64','209','38','93') ; 
INSERT INTO flight VALUES ('236','2018-12-03 05:20:44','363','2015','340.30','248','68','93') ; 
INSERT INTO flight VALUES ('237','2018-12-03 03:34:59','135','749','144.79','187','93','26') ; 
INSERT INTO flight VALUES ('238','2018-12-03 02:31:27','159','881','148.01','209','65','6') ; 
INSERT INTO flight VALUES ('239','2018-12-03 01:03:13','239','1327','204.41','72','37','116') ; 
INSERT INTO flight VALUES ('240','2018-12-03 06:41:56','228','1268','123.09','122','37','118') ; 
INSERT INTO flight VALUES ('241','2018-12-03 16:28:55','44','244','40.14','28','26','6') ; 
INSERT INTO flight VALUES ('242','2018-12-03 23:01:23','146','809','92.12','178','116','118') ; 
INSERT INTO flight VALUES ('243','2018-12-03 22:07:24','384','2131','307.72','139','118','93') ; 
INSERT INTO flight VALUES ('244','2018-12-03 09:00:39','226','1253','248.91','28','67','116') ; 
INSERT INTO flight VALUES ('245','2018-12-03 23:08:50','102','566','54.28','143','67','118') ; 
INSERT INTO flight VALUES ('246','2018-12-03 23:06:31','181','1003','150.78','91','93','37') ; 
INSERT INTO flight VALUES ('247','2018-12-03 09:40:58','167','929','134.59','109','93','38') ; 
INSERT INTO flight VALUES ('248','2018-12-03 11:34:36','393','2184','298.72','221','38','116') ; 
INSERT INTO flight VALUES ('249','2018-12-03 08:14:32','308','1712','303.33','146','38','118') ; 
INSERT INTO flight VALUES ('250','2018-12-03 17:08:38','254','1409','291.51','186','37','6') ; 
INSERT INTO flight VALUES ('251','2018-12-03 00:59:04','116','643','97.47','102','65','26') ; 
INSERT INTO flight VALUES ('252','2018-12-03 05:20:21','44','244','31.45','209','6','26') ; 
INSERT INTO flight VALUES ('253','2018-12-03 21:18:37','205','1137','121.08','112','68','116') ; 
INSERT INTO flight VALUES ('254','2018-12-03 00:30:51','69','381','54.54','142','68','118') ; 
INSERT INTO flight VALUES ('255','2018-12-03 17:02:47','485','2693','474.56','55','116','6') ; 
INSERT INTO flight VALUES ('256','2018-12-03 11:01:46','354','1965','290.67','155','67','6') ; 
INSERT INTO flight VALUES ('257','2018-12-03 18:21:53','320','1778','309.01','97','65','37') ; 
INSERT INTO flight VALUES ('258','2018-12-03 17:30:27','146','809','90.18','56','118','116') ; 
INSERT INTO flight VALUES ('259','2018-12-03 07:50:52','254','1409','229.60','213','6','37') ; 
INSERT INTO flight VALUES ('260','2018-12-03 08:30:35','282','1566','267.50','1','65','38') ; 
INSERT INTO flight VALUES ('261','2018-12-03 09:25:01','145','803','113.11','74','6','38') ; 
INSERT INTO flight VALUES ('262','2018-12-03 07:09:08','145','803','113.21','13','38','6') ; 
INSERT INTO flight VALUES ('263','2018-12-03 02:50:20','283','1570','282.98','147','26','37') ; 
INSERT INTO flight VALUES ('264','2018-12-03 17:09:54','189','1049','213.70','212','26','38') ; 
INSERT INTO flight VALUES ('265','2018-12-03 04:25:32','392','2176','309.32','8','68','6') ; 
INSERT INTO flight VALUES ('266','2018-12-03 04:37:31','142','789','127.36','91','93','65') ; 
INSERT INTO flight VALUES ('267','2018-12-03 02:21:15','283','1570','248.74','254','37','26') ; 
INSERT INTO flight VALUES ('268','2018-12-03 23:30:40','314','1747','225.32','101','93','67') ; 
INSERT INTO flight VALUES ('269','2018-12-03 01:42:52','363','2015','294.80','42','93','68') ; 
INSERT INTO flight VALUES ('270','2018-12-03 15:52:26','513','2851','430.74','170','116','26') ; 
INSERT INTO flight VALUES ('271','2018-12-04 14:27:21','397','2208','302.26','10','67','26') ; 
INSERT INTO flight VALUES ('272','2018-12-04 14:43:28','445','2472','365.19','34','118','6') ; 
INSERT INTO flight VALUES ('273','2018-12-04 18:43:17','156','867','119.94','225','37','38') ; 
INSERT INTO flight VALUES ('274','2018-12-04 09:52:51','189','1049','139.67','235','38','26') ; 
INSERT INTO flight VALUES ('275','2018-12-04 11:04:04','239','1327','175.54','66','116','37') ; 
INSERT INTO flight VALUES ('276','2018-12-04 10:18:59','393','2184','248.33','30','116','38') ; 
INSERT INTO flight VALUES ('277','2018-12-04 14:35:56','135','748','136.04','257','67','37') ; 
INSERT INTO flight VALUES ('278','2018-12-04 11:29:21','217','1203','218.57','129','67','38') ; 
INSERT INTO flight VALUES ('279','2018-12-04 21:52:46','435','2419','398.23','259','68','26') ; 
INSERT INTO flight VALUES ('280','2018-12-04 10:19:11','159','881','142.87','6','6','65') ; 
INSERT INTO flight VALUES ('281','2018-12-04 23:32:53','454','2523','370.03','241','65','67') ; 
INSERT INTO flight VALUES ('282','2018-12-04 03:34:50','354','1965','375.04','226','6','67') ; 
INSERT INTO flight VALUES ('283','2018-12-04 10:25:08','500','2777','493.80','219','65','68') ; 
INSERT INTO flight VALUES ('284','2018-12-04 13:12:16','392','2176','309.27','108','6','68') ; 
INSERT INTO flight VALUES ('285','2018-12-04 15:33:09','156','867','151.77','110','38','37') ; 
INSERT INTO flight VALUES ('286','2018-12-04 14:55:39','116','643','108.14','259','26','65') ; 
INSERT INTO flight VALUES ('287','2018-12-04 22:09:03','397','2208','266.80','176','26','67') ; 
INSERT INTO flight VALUES ('288','2018-12-04 07:17:28','435','2419','341.25','169','26','68') ; 
INSERT INTO flight VALUES ('289','2018-12-04 20:26:28','489','2716','414.01','4','118','26') ; 
INSERT INTO flight VALUES ('290','2018-12-04 18:01:31','183','1016','156.63','257','68','37') ; 
INSERT INTO flight VALUES ('291','2018-12-04 13:06:07','255','1415','148.90','242','68','38') ; 
INSERT INTO flight VALUES ('292','2018-12-04 02:49:17','320','1778','268.58','180','37','65') ; 
INSERT INTO flight VALUES ('293','2018-12-04 12:39:28','228','1268','179.06','241','118','37') ; 
INSERT INTO flight VALUES ('294','2018-12-04 22:53:48','135','748','116.95','128','37','67') ; 
INSERT INTO flight VALUES ('295','2018-12-04 03:29:46','308','1712','365.14','219','118','38') ; 
INSERT INTO flight VALUES ('296','2018-12-04 11:51:42','183','1016','104.11','138','37','68') ; 
INSERT INTO flight VALUES ('297','2018-12-04 11:20:42','520','2887','433.62','126','116','65') ; 
INSERT INTO flight VALUES ('298','2018-12-04 08:44:52','226','1253','177.60','218','116','67') ; 
INSERT INTO flight VALUES ('299','2018-12-04 02:23:32','454','2523','483.72','189','67','65') ; 
INSERT INTO flight VALUES ('300','2018-12-04 23:49:24','205','1137','131.37','61','116','68') ; 
INSERT INTO flight VALUES ('301','2018-12-04 20:39:14','142','789','130.13','69','65','93') ; 
INSERT INTO flight VALUES ('302','2018-12-04 21:24:00','129','715','95.02','124','6','93') ; 
INSERT INTO flight VALUES ('303','2018-12-04 03:22:27','49','271','36.96','220','67','68') ; 
INSERT INTO flight VALUES ('304','2018-12-04 08:22:03','378','2100','331.55','157','93','116') ; 
INSERT INTO flight VALUES ('305','2018-12-04 00:48:10','384','2131','259.85','238','93','118') ; 
INSERT INTO flight VALUES ('306','2018-12-04 21:47:49','282','1566','294.75','159','38','65') ; 
INSERT INTO flight VALUES ('307','2018-12-04 16:00:11','135','749','153.02','225','26','93') ; 
INSERT INTO flight VALUES ('308','2018-12-04 02:55:01','217','1203','178.29','3','38','67') ; 
INSERT INTO flight VALUES ('309','2018-12-04 07:36:17','255','1415','186.89','250','38','68') ; 
INSERT INTO flight VALUES ('310','2018-12-04 12:42:29','500','2777','399.45','125','68','65') ; 
INSERT INTO flight VALUES ('311','2018-12-04 08:31:41','49','271','39.37','25','68','67') ; 
INSERT INTO flight VALUES ('312','2018-12-04 10:03:04','181','1003','147.07','36','37','93') ; 
INSERT INTO flight VALUES ('313','2018-12-04 12:02:14','129','715','140.86','239','93','6') ; 
INSERT INTO flight VALUES ('314','2018-12-04 03:51:12','523','2906','417.35','247','118','65') ; 
INSERT INTO flight VALUES ('315','2018-12-04 20:28:56','520','2887','361.09','251','65','116') ; 
INSERT INTO flight VALUES ('316','2018-12-04 20:24:40','102','566','55.70','122','118','67') ; 
INSERT INTO flight VALUES ('317','2018-12-04 14:40:00','378','2100','427.81','210','116','93') ; 
INSERT INTO flight VALUES ('318','2018-12-04 12:26:30','485','2693','362.18','39','6','116') ; 
INSERT INTO flight VALUES ('319','2018-12-04 23:33:43','69','381','52.49','34','118','68') ; 
INSERT INTO flight VALUES ('320','2018-12-04 16:01:08','523','2906','567.97','265','65','118') ; 
INSERT INTO flight VALUES ('321','2018-12-04 01:49:20','445','2472','340.09','240','6','118') ; 
INSERT INTO flight VALUES ('322','2018-12-04 22:48:32','314','1747','268.92','126','67','93') ; 
INSERT INTO flight VALUES ('323','2018-12-04 03:15:29','513','2851','388.29','25','26','116') ; 
INSERT INTO flight VALUES ('324','2018-12-04 14:50:53','489','2716','367.50','52','26','118') ; 
INSERT INTO flight VALUES ('325','2018-12-04 13:56:15','167','929','131.37','85','38','93') ; 
INSERT INTO flight VALUES ('326','2018-12-04 01:18:06','363','2015','350.65','237','68','93') ; 
INSERT INTO flight VALUES ('327','2018-12-04 12:31:35','135','749','146.19','68','93','26') ; 
INSERT INTO flight VALUES ('328','2018-12-04 09:28:37','159','881','134.29','135','65','6') ; 
INSERT INTO flight VALUES ('329','2018-12-04 03:53:01','239','1327','206.94','230','37','116') ; 
INSERT INTO flight VALUES ('330','2018-12-04 18:00:46','228','1268','165.76','72','37','118') ; 
INSERT INTO flight VALUES ('331','2018-12-04 22:45:27','44','244','37.94','117','26','6') ; 
INSERT INTO flight VALUES ('332','2018-12-04 09:36:33','146','809','119.95','74','116','118') ; 
INSERT INTO flight VALUES ('333','2018-12-04 21:34:51','384','2131','262.26','257','118','93') ; 
INSERT INTO flight VALUES ('334','2018-12-04 03:45:12','226','1253','228.47','11','67','116') ; 
INSERT INTO flight VALUES ('335','2018-12-04 11:04:29','102','566','53.22','59','67','118') ; 
INSERT INTO flight VALUES ('336','2018-12-04 19:41:28','181','1003','159.21','33','93','37') ; 
INSERT INTO flight VALUES ('337','2018-12-04 00:52:05','167','929','124.69','11','93','38') ; 
INSERT INTO flight VALUES ('338','2018-12-04 20:25:49','393','2184','302.16','118','38','116') ; 
INSERT INTO flight VALUES ('339','2018-12-04 02:37:27','308','1712','266.90','165','38','118') ; 
INSERT INTO flight VALUES ('340','2018-12-04 21:49:38','254','1409','280.84','220','37','6') ; 
INSERT INTO flight VALUES ('341','2018-12-04 14:47:11','116','643','79.74','67','65','26') ; 
INSERT INTO flight VALUES ('342','2018-12-04 08:54:48','44','244','39.17','19','6','26') ; 
INSERT INTO flight VALUES ('343','2018-12-04 21:34:53','205','1137','173.84','202','68','116') ; 
INSERT INTO flight VALUES ('344','2018-12-04 11:24:52','69','381','63.42','108','68','118') ; 
INSERT INTO flight VALUES ('345','2018-12-04 14:07:31','485','2693','410.44','135','116','6') ; 
INSERT INTO flight VALUES ('346','2018-12-04 08:38:13','354','1965','296.86','152','67','6') ; 
INSERT INTO flight VALUES ('347','2018-12-04 03:24:48','320','1778','351.30','9','65','37') ; 
INSERT INTO flight VALUES ('348','2018-12-04 08:32:32','146','809','96.42','248','118','116') ; 
INSERT INTO flight VALUES ('349','2018-12-04 10:27:04','254','1409','228.31','83','6','37') ; 
INSERT INTO flight VALUES ('350','2018-12-04 06:05:52','282','1566','182.80','143','65','38') ; 
INSERT INTO flight VALUES ('351','2018-12-04 07:02:18','145','803','95.13','81','6','38') ; 
INSERT INTO flight VALUES ('352','2018-12-04 22:49:47','145','803','120.49','158','38','6') ; 
INSERT INTO flight VALUES ('353','2018-12-04 23:47:23','283','1570','223.65','223','26','37') ; 
INSERT INTO flight VALUES ('354','2018-12-04 19:38:00','189','1049','171.71','3','26','38') ; 
INSERT INTO flight VALUES ('355','2018-12-04 00:03:22','392','2176','250.82','262','68','6') ; 
INSERT INTO flight VALUES ('356','2018-12-04 08:03:03','142','789','96.72','124','93','65') ; 
INSERT INTO flight VALUES ('357','2018-12-04 05:50:12','283','1570','264.74','87','37','26') ; 
INSERT INTO flight VALUES ('358','2018-12-04 14:28:26','314','1747','269.55','91','93','67') ; 
INSERT INTO flight VALUES ('359','2018-12-04 21:21:47','363','2015','418.90','99','93','68') ; 
INSERT INTO flight VALUES ('360','2018-12-04 01:32:11','513','2851','345.43','28','116','26') ; 
INSERT INTO flight VALUES ('361','2018-12-05 16:51:10','397','2208','364.59','79','67','26') ; 
INSERT INTO flight VALUES ('362','2018-12-05 20:27:38','445','2472','437.84','19','118','6') ; 
INSERT INTO flight VALUES ('363','2018-12-05 00:38:34','156','867','156.50','136','37','38') ; 
INSERT INTO flight VALUES ('364','2018-12-05 11:43:55','189','1049','192.55','82','38','26') ; 
INSERT INTO flight VALUES ('365','2018-12-05 20:56:22','239','1327','165.83','76','116','37') ; 
INSERT INTO flight VALUES ('366','2018-12-05 11:44:05','393','2184','360.06','231','116','38') ; 
INSERT INTO flight VALUES ('367','2018-12-05 18:07:23','135','748','103.82','69','67','37') ; 
INSERT INTO flight VALUES ('368','2018-12-05 02:53:39','217','1203','194.31','51','67','38') ; 
INSERT INTO flight VALUES ('369','2018-12-05 00:45:38','435','2419','359.66','46','68','26') ; 
INSERT INTO flight VALUES ('370','2018-12-05 16:00:53','159','881','119.73','251','6','65') ; 
INSERT INTO flight VALUES ('371','2018-12-05 03:56:21','454','2523','427.47','107','65','67') ; 
INSERT INTO flight VALUES ('372','2018-12-05 07:17:54','354','1965','336.06','32','6','67') ; 
INSERT INTO flight VALUES ('373','2018-12-05 05:50:26','500','2777','383.91','31','65','68') ; 
INSERT INTO flight VALUES ('374','2018-12-05 12:53:08','392','2176','213.89','200','6','68') ; 
INSERT INTO flight VALUES ('375','2018-12-05 06:26:51','156','867','137.63','70','38','37') ; 
INSERT INTO flight VALUES ('376','2018-12-05 20:42:33','116','643','81.17','243','26','65') ; 
INSERT INTO flight VALUES ('377','2018-12-05 04:55:41','397','2208','261.89','22','26','67') ; 
INSERT INTO flight VALUES ('378','2018-12-05 10:48:38','435','2419','330.59','27','26','68') ; 
INSERT INTO flight VALUES ('379','2018-12-05 15:36:17','489','2716','401.20','64','118','26') ; 
INSERT INTO flight VALUES ('380','2018-12-05 09:36:22','183','1016','153.72','63','68','37') ; 
INSERT INTO flight VALUES ('381','2018-12-05 23:40:19','255','1415','206.04','157','68','38') ; 
INSERT INTO flight VALUES ('382','2018-12-05 08:42:09','320','1778','272.04','237','37','65') ; 
INSERT INTO flight VALUES ('383','2018-12-05 20:07:13','228','1268','191.18','214','118','37') ; 
INSERT INTO flight VALUES ('384','2018-12-05 11:57:19','135','748','146.02','41','37','67') ; 
INSERT INTO flight VALUES ('385','2018-12-05 00:17:13','308','1712','300.63','109','118','38') ; 
INSERT INTO flight VALUES ('386','2018-12-05 09:14:31','183','1016','100.26','234','37','68') ; 
INSERT INTO flight VALUES ('387','2018-12-05 19:05:07','520','2887','428.19','169','116','65') ; 
INSERT INTO flight VALUES ('388','2018-12-05 06:12:26','226','1253','213.57','251','116','67') ; 
INSERT INTO flight VALUES ('389','2018-12-05 13:24:40','454','2523','377.75','191','67','65') ; 
INSERT INTO flight VALUES ('390','2018-12-05 14:56:28','205','1137','131.53','23','116','68') ; 
INSERT INTO flight VALUES ('391','2018-12-05 00:23:15','142','789','106.11','15','65','93') ; 
INSERT INTO flight VALUES ('392','2018-12-05 03:39:51','129','715','127.58','32','6','93') ; 
INSERT INTO flight VALUES ('393','2018-12-05 02:32:47','49','271','35.99','142','67','68') ; 
INSERT INTO flight VALUES ('394','2018-12-05 09:21:51','378','2100','331.88','264','93','116') ; 
INSERT INTO flight VALUES ('395','2018-12-05 00:58:39','384','2131','284.96','40','93','118') ; 
INSERT INTO flight VALUES ('396','2018-12-05 15:07:55','282','1566','247.14','41','38','65') ; 
INSERT INTO flight VALUES ('397','2018-12-05 04:51:04','135','749','112.05','25','26','93') ; 
INSERT INTO flight VALUES ('398','2018-12-05 09:59:31','217','1203','186.02','121','38','67') ; 
INSERT INTO flight VALUES ('399','2018-12-05 15:12:35','255','1415','223.22','161','38','68') ; 
INSERT INTO flight VALUES ('400','2018-12-05 08:17:39','500','2777','493.84','264','68','65') ; 
INSERT INTO flight VALUES ('401','2018-12-05 21:55:48','49','271','46.95','68','68','67') ; 
INSERT INTO flight VALUES ('402','2018-12-05 11:16:12','181','1003','181.66','77','37','93') ; 
INSERT INTO flight VALUES ('403','2018-12-05 14:19:39','129','715','102.08','142','93','6') ; 
INSERT INTO flight VALUES ('404','2018-12-05 03:19:59','523','2906','555.19','8','118','65') ; 
INSERT INTO flight VALUES ('405','2018-12-05 05:38:04','520','2887','300.15','237','65','116') ; 
INSERT INTO flight VALUES ('406','2018-12-05 20:14:09','102','566','68.21','54','118','67') ; 
INSERT INTO flight VALUES ('407','2018-12-05 14:36:27','378','2100','336.39','158','116','93') ; 
INSERT INTO flight VALUES ('408','2018-12-05 20:32:47','485','2693','500.47','205','6','116') ; 
INSERT INTO flight VALUES ('409','2018-12-05 12:15:46','69','381','45.04','173','118','68') ; 
INSERT INTO flight VALUES ('410','2018-12-05 10:12:29','523','2906','477.83','75','65','118') ; 
INSERT INTO flight VALUES ('411','2018-12-05 23:50:33','445','2472','444.55','197','6','118') ; 
INSERT INTO flight VALUES ('412','2018-12-05 04:43:53','314','1747','225.60','122','67','93') ; 
INSERT INTO flight VALUES ('413','2018-12-05 14:46:56','513','2851','415.76','209','26','116') ; 
INSERT INTO flight VALUES ('414','2018-12-05 08:58:34','489','2716','458.66','40','26','118') ; 
INSERT INTO flight VALUES ('415','2018-12-05 22:50:54','167','929','135.17','4','38','93') ; 
INSERT INTO flight VALUES ('416','2018-12-05 04:48:54','363','2015','373.75','191','68','93') ; 
INSERT INTO flight VALUES ('417','2018-12-05 00:53:16','135','749','145.02','165','93','26') ; 
INSERT INTO flight VALUES ('418','2018-12-05 12:58:35','159','881','142.47','181','65','6') ; 
INSERT INTO flight VALUES ('419','2018-12-05 21:39:46','239','1327','206.93','58','37','116') ; 
INSERT INTO flight VALUES ('420','2018-12-05 03:09:50','228','1268','176.52','81','37','118') ; 
INSERT INTO flight VALUES ('421','2018-12-05 15:02:58','44','244','28.40','86','26','6') ; 
INSERT INTO flight VALUES ('422','2018-12-05 20:40:44','146','809','84.36','124','116','118') ; 
INSERT INTO flight VALUES ('423','2018-12-05 18:08:58','384','2131','335.02','247','118','93') ; 
INSERT INTO flight VALUES ('424','2018-12-05 16:28:06','226','1253','254.84','153','67','116') ; 
INSERT INTO flight VALUES ('425','2018-12-05 09:42:32','102','566','48.88','135','67','118') ; 
INSERT INTO flight VALUES ('426','2018-12-05 09:05:56','181','1003','203.22','104','93','37') ; 
INSERT INTO flight VALUES ('427','2018-12-05 07:47:02','167','929','141.04','60','93','38') ; 
INSERT INTO flight VALUES ('428','2018-12-05 10:52:38','393','2184','311.24','204','38','116') ; 
INSERT INTO flight VALUES ('429','2018-12-05 09:48:23','308','1712','300.12','156','38','118') ; 
INSERT INTO flight VALUES ('430','2018-12-05 12:28:18','254','1409','236.29','12','37','6') ; 
INSERT INTO flight VALUES ('431','2018-12-05 15:11:15','116','643','88.01','116','65','26') ; 
INSERT INTO flight VALUES ('432','2018-12-05 08:28:54','44','244','30.57','199','6','26') ; 
INSERT INTO flight VALUES ('433','2018-12-05 12:58:57','205','1137','123.86','258','68','116') ; 
INSERT INTO flight VALUES ('434','2018-12-05 17:41:35','69','381','60.27','84','68','118') ; 
INSERT INTO flight VALUES ('435','2018-12-05 09:08:43','485','2693','404.63','63','116','6') ; 
INSERT INTO flight VALUES ('436','2018-12-05 14:43:03','354','1965','244.93','93','67','6') ; 
INSERT INTO flight VALUES ('437','2018-12-05 09:59:53','320','1778','256.67','228','65','37') ; 
INSERT INTO flight VALUES ('438','2018-12-05 05:09:06','146','809','108.84','232','118','116') ; 
INSERT INTO flight VALUES ('439','2018-12-05 20:48:10','254','1409','220.49','145','6','37') ; 
INSERT INTO flight VALUES ('440','2018-12-05 14:27:26','282','1566','265.71','76','65','38') ; 
INSERT INTO flight VALUES ('441','2018-12-05 05:34:08','145','803','119.60','16','6','38') ; 
INSERT INTO flight VALUES ('442','2018-12-05 09:19:24','145','803','110.03','86','38','6') ; 
INSERT INTO flight VALUES ('443','2018-12-05 20:52:19','283','1570','285.46','200','26','37') ; 
INSERT INTO flight VALUES ('444','2018-12-05 07:39:23','189','1049','177.68','66','26','38') ; 
INSERT INTO flight VALUES ('445','2018-12-05 06:54:36','392','2176','247.15','104','68','6') ; 
INSERT INTO flight VALUES ('446','2018-12-05 03:02:14','142','789','139.68','78','93','65') ; 
INSERT INTO flight VALUES ('447','2018-12-05 00:04:49','283','1570','320.35','143','37','26') ; 
INSERT INTO flight VALUES ('448','2018-12-05 21:56:47','314','1747','224.60','75','93','67') ; 
INSERT INTO flight VALUES ('449','2018-12-05 09:13:34','363','2015','399.63','241','93','68') ; 
INSERT INTO flight VALUES ('450','2018-12-05 21:28:23','513','2851','484.36','112','116','26') ; 
INSERT INTO flight VALUES ('451','2018-12-06 08:45:34','397','2208','330.58','213','67','26') ; 
INSERT INTO flight VALUES ('452','2018-12-06 17:35:53','445','2472','475.41','149','118','6') ; 
INSERT INTO flight VALUES ('453','2018-12-06 13:50:38','156','867','162.33','104','37','38') ; 
INSERT INTO flight VALUES ('454','2018-12-06 15:51:08','189','1049','165.53','213','38','26') ; 
INSERT INTO flight VALUES ('455','2018-12-06 04:46:35','239','1327','184.15','59','116','37') ; 
INSERT INTO flight VALUES ('456','2018-12-06 00:49:35','393','2184','352.92','210','116','38') ; 
INSERT INTO flight VALUES ('457','2018-12-06 23:49:59','135','748','146.47','75','67','37') ; 
INSERT INTO flight VALUES ('458','2018-12-06 09:48:27','217','1203','186.16','205','67','38') ; 
INSERT INTO flight VALUES ('459','2018-12-06 04:12:19','435','2419','439.05','5','68','26') ; 
INSERT INTO flight VALUES ('460','2018-12-06 13:02:23','159','881','110.52','121','6','65') ; 
INSERT INTO flight VALUES ('461','2018-12-06 03:09:16','454','2523','424.49','233','65','67') ; 
INSERT INTO flight VALUES ('462','2018-12-06 05:21:40','354','1965','358.60','18','6','67') ; 
INSERT INTO flight VALUES ('463','2018-12-06 05:50:34','500','2777','508.09','69','65','68') ; 
INSERT INTO flight VALUES ('464','2018-12-06 22:10:21','392','2176','306.05','235','6','68') ; 
INSERT INTO flight VALUES ('465','2018-12-06 17:10:46','156','867','143.13','14','38','37') ; 
INSERT INTO flight VALUES ('466','2018-12-06 22:34:04','116','643','104.96','76','26','65') ; 
INSERT INTO flight VALUES ('467','2018-12-06 18:54:11','397','2208','320.78','204','26','67') ; 
INSERT INTO flight VALUES ('468','2018-12-06 06:02:05','435','2419','446.90','208','26','68') ; 
INSERT INTO flight VALUES ('469','2018-12-06 14:09:35','489','2716','533.69','265','118','26') ; 
INSERT INTO flight VALUES ('470','2018-12-06 08:31:49','183','1016','137.77','254','68','37') ; 
INSERT INTO flight VALUES ('471','2018-12-06 10:39:12','255','1415','202.83','53','68','38') ; 
INSERT INTO flight VALUES ('472','2018-12-06 21:17:04','320','1778','278.98','256','37','65') ; 
INSERT INTO flight VALUES ('473','2018-12-06 16:16:25','228','1268','142.41','86','118','37') ; 
INSERT INTO flight VALUES ('474','2018-12-06 05:31:49','135','748','133.01','73','37','67') ; 
INSERT INTO flight VALUES ('475','2018-12-06 03:06:24','308','1712','301.29','84','118','38') ; 
INSERT INTO flight VALUES ('476','2018-12-06 00:29:28','183','1016','119.17','180','37','68') ; 
INSERT INTO flight VALUES ('477','2018-12-06 16:37:15','520','2887','328.38','67','116','65') ; 
INSERT INTO flight VALUES ('478','2018-12-06 12:18:05','226','1253','196.50','84','116','67') ; 
INSERT INTO flight VALUES ('479','2018-12-06 05:06:29','454','2523','479.57','120','67','65') ; 
INSERT INTO flight VALUES ('480','2018-12-06 09:25:28','205','1137','139.06','216','116','68') ; 
INSERT INTO flight VALUES ('481','2018-12-06 01:59:59','142','789','114.12','35','65','93') ; 
INSERT INTO flight VALUES ('482','2018-12-06 11:46:18','129','715','113.50','70','6','93') ; 
INSERT INTO flight VALUES ('483','2018-12-06 07:46:43','49','271','37.86','135','67','68') ; 
INSERT INTO flight VALUES ('484','2018-12-06 11:35:27','378','2100','271.18','232','93','116') ; 
INSERT INTO flight VALUES ('485','2018-12-06 19:47:14','384','2131','302.92','43','93','118') ; 
INSERT INTO flight VALUES ('486','2018-12-06 21:55:08','282','1566','237.61','52','38','65') ; 
INSERT INTO flight VALUES ('487','2018-12-06 09:40:44','135','749','147.44','227','26','93') ; 
INSERT INTO flight VALUES ('488','2018-12-06 15:23:37','217','1203','173.71','59','38','67') ; 
INSERT INTO flight VALUES ('489','2018-12-06 04:49:06','255','1415','176.58','251','38','68') ; 
INSERT INTO flight VALUES ('490','2018-12-06 05:32:17','500','2777','439.51','239','68','65') ; 
INSERT INTO flight VALUES ('491','2018-12-06 02:02:27','49','271','39.61','155','68','67') ; 
INSERT INTO flight VALUES ('492','2018-12-06 23:37:40','181','1003','178.16','253','37','93') ; 
INSERT INTO flight VALUES ('493','2018-12-06 08:54:53','129','715','119.51','163','93','6') ; 
INSERT INTO flight VALUES ('494','2018-12-06 12:58:47','523','2906','479.08','105','118','65') ; 
INSERT INTO flight VALUES ('495','2018-12-06 02:24:21','520','2887','361.16','196','65','116') ; 
INSERT INTO flight VALUES ('496','2018-12-06 23:21:01','102','566','69.05','223','118','67') ; 
INSERT INTO flight VALUES ('497','2018-12-06 08:15:18','378','2100','336.72','9','116','93') ; 
INSERT INTO flight VALUES ('498','2018-12-06 19:49:23','485','2693','390.47','187','6','116') ; 
INSERT INTO flight VALUES ('499','2018-12-06 08:49:46','69','381','49.81','127','118','68') ; 
INSERT INTO flight VALUES ('500','2018-12-06 14:49:13','523','2906','443.69','217','65','118') ; 
INSERT INTO flight VALUES ('501','2018-12-06 18:51:20','445','2472','487.86','182','6','118') ; 
INSERT INTO flight VALUES ('502','2018-12-06 20:35:20','314','1747','217.54','115','67','93') ; 
INSERT INTO flight VALUES ('503','2018-12-06 15:08:41','513','2851','405.81','91','26','116') ; 
INSERT INTO flight VALUES ('504','2018-12-06 15:24:56','489','2716','463.99','263','26','118') ; 
INSERT INTO flight VALUES ('505','2018-12-06 17:07:48','167','929','156.17','247','38','93') ; 
INSERT INTO flight VALUES ('506','2018-12-06 12:23:55','363','2015','275.53','24','68','93') ; 
INSERT INTO flight VALUES ('507','2018-12-06 22:52:03','135','749','115.69','134','93','26') ; 
INSERT INTO flight VALUES ('508','2018-12-06 05:45:28','159','881','120.69','215','65','6') ; 
INSERT INTO flight VALUES ('509','2018-12-06 17:48:57','239','1327','223.75','250','37','116') ; 
INSERT INTO flight VALUES ('510','2018-12-06 11:43:28','228','1268','176.54','155','37','118') ; 
INSERT INTO flight VALUES ('511','2018-12-06 09:25:57','44','244','38.08','262','26','6') ; 
INSERT INTO flight VALUES ('512','2018-12-06 02:44:07','146','809','119.44','240','116','118') ; 
INSERT INTO flight VALUES ('513','2018-12-06 20:59:12','384','2131','324.75','202','118','93') ; 
INSERT INTO flight VALUES ('514','2018-12-06 07:05:23','226','1253','249.17','207','67','116') ; 
INSERT INTO flight VALUES ('515','2018-12-06 12:17:53','102','566','56.06','118','67','118') ; 
INSERT INTO flight VALUES ('516','2018-12-06 01:31:49','181','1003','179.36','17','93','37') ; 
INSERT INTO flight VALUES ('517','2018-12-06 00:20:23','167','929','122.21','209','93','38') ; 
INSERT INTO flight VALUES ('518','2018-12-06 09:57:35','393','2184','415.23','166','38','116') ; 
INSERT INTO flight VALUES ('519','2018-12-06 07:21:33','308','1712','224.88','243','38','118') ; 
INSERT INTO flight VALUES ('520','2018-12-06 09:03:37','254','1409','241.23','180','37','6') ; 
INSERT INTO flight VALUES ('521','2018-12-06 20:46:22','116','643','73.52','50','65','26') ; 
INSERT INTO flight VALUES ('522','2018-12-06 11:34:37','44','244','32.14','261','6','26') ; 
INSERT INTO flight VALUES ('523','2018-12-06 04:24:21','205','1137','162.94','221','68','116') ; 
INSERT INTO flight VALUES ('524','2018-12-06 18:03:04','69','381','45.30','167','68','118') ; 
INSERT INTO flight VALUES ('525','2018-12-06 04:14:44','485','2693','397.38','115','116','6') ; 
INSERT INTO flight VALUES ('526','2018-12-06 09:39:12','354','1965','284.17','124','67','6') ; 
INSERT INTO flight VALUES ('527','2018-12-06 19:02:34','320','1778','249.05','251','65','37') ; 
INSERT INTO flight VALUES ('528','2018-12-06 09:59:43','146','809','110.34','71','118','116') ; 
INSERT INTO flight VALUES ('529','2018-12-06 11:10:36','254','1409','246.82','203','6','37') ; 
INSERT INTO flight VALUES ('530','2018-12-06 14:11:00','282','1566','247.91','128','65','38') ; 
INSERT INTO flight VALUES ('531','2018-12-06 20:12:20','145','803','128.19','34','6','38') ; 
INSERT INTO flight VALUES ('532','2018-12-06 11:31:35','145','803','89.95','36','38','6') ; 
INSERT INTO flight VALUES ('533','2018-12-06 22:31:00','283','1570','242.95','81','26','37') ; 
INSERT INTO flight VALUES ('534','2018-12-06 13:16:43','189','1049','207.15','252','26','38') ; 
INSERT INTO flight VALUES ('535','2018-12-06 04:54:57','392','2176','289.82','65','68','6') ; 
INSERT INTO flight VALUES ('536','2018-12-06 03:25:23','142','789','133.60','52','93','65') ; 
INSERT INTO flight VALUES ('537','2018-12-06 08:30:36','283','1570','312.20','189','37','26') ; 
INSERT INTO flight VALUES ('538','2018-12-06 04:22:09','314','1747','253.52','24','93','67') ; 
INSERT INTO flight VALUES ('539','2018-12-06 08:21:21','363','2015','417.95','161','93','68') ; 
INSERT INTO flight VALUES ('540','2018-12-06 18:11:32','513','2851','479.61','63','116','26') ; 
INSERT INTO flight VALUES ('541','2018-12-07 08:45:50','397','2208','341.76','40','67','26') ; 
INSERT INTO flight VALUES ('542','2018-12-07 01:45:32','445','2472','467.53','158','118','6') ; 
INSERT INTO flight VALUES ('543','2018-12-07 09:18:17','156','867','125.19','129','37','38') ; 
INSERT INTO flight VALUES ('544','2018-12-07 06:42:54','189','1049','136.45','144','38','26') ; 
INSERT INTO flight VALUES ('545','2018-12-07 00:55:04','239','1327','137.75','237','116','37') ; 
INSERT INTO flight VALUES ('546','2018-12-07 16:38:17','393','2184','253.87','151','116','38') ; 
INSERT INTO flight VALUES ('547','2018-12-07 22:20:12','135','748','140.93','104','67','37') ; 
INSERT INTO flight VALUES ('548','2018-12-07 19:20:53','217','1203','238.18','223','67','38') ; 
INSERT INTO flight VALUES ('549','2018-12-07 10:27:59','435','2419','403.54','256','68','26') ; 
INSERT INTO flight VALUES ('550','2018-12-07 07:54:56','159','881','122.72','45','6','65') ; 
INSERT INTO flight VALUES ('551','2018-12-07 20:54:32','454','2523','344.63','198','65','67') ; 
INSERT INTO flight VALUES ('552','2018-12-07 03:22:55','354','1965','311.68','179','6','67') ; 
INSERT INTO flight VALUES ('553','2018-12-07 21:24:15','500','2777','390.23','129','65','68') ; 
INSERT INTO flight VALUES ('554','2018-12-07 23:04:22','392','2176','236.90','67','6','68') ; 
INSERT INTO flight VALUES ('555','2018-12-07 17:53:42','156','867','161.00','240','38','37') ; 
INSERT INTO flight VALUES ('556','2018-12-07 23:03:03','116','643','82.31','47','26','65') ; 
INSERT INTO flight VALUES ('557','2018-12-07 09:18:17','397','2208','292.62','69','26','67') ; 
INSERT INTO flight VALUES ('558','2018-12-07 13:43:14','435','2419','314.01','132','26','68') ; 
INSERT INTO flight VALUES ('559','2018-12-07 23:26:04','489','2716','425.60','182','118','26') ; 
INSERT INTO flight VALUES ('560','2018-12-07 18:52:35','183','1016','140.76','233','68','37') ; 
INSERT INTO flight VALUES ('561','2018-12-07 15:44:19','255','1415','189.97','187','68','38') ; 
INSERT INTO flight VALUES ('562','2018-12-07 12:12:51','320','1778','328.20','121','37','65') ; 
INSERT INTO flight VALUES ('563','2018-12-07 14:32:47','228','1268','144.47','94','118','37') ; 
INSERT INTO flight VALUES ('564','2018-12-07 08:44:08','135','748','148.25','210','37','67') ; 
INSERT INTO flight VALUES ('565','2018-12-07 14:38:41','308','1712','297.79','19','118','38') ; 
INSERT INTO flight VALUES ('566','2018-12-07 02:53:59','183','1016','130.12','236','37','68') ; 
INSERT INTO flight VALUES ('567','2018-12-07 11:21:47','520','2887','373.00','48','116','65') ; 
INSERT INTO flight VALUES ('568','2018-12-07 02:48:54','226','1253','250.66','166','116','67') ; 
INSERT INTO flight VALUES ('569','2018-12-07 23:14:56','454','2523','391.04','5','67','65') ; 
INSERT INTO flight VALUES ('570','2018-12-07 13:26:27','205','1137','172.31','242','116','68') ; 
INSERT INTO flight VALUES ('571','2018-12-07 06:23:02','142','789','95.88','106','65','93') ; 
INSERT INTO flight VALUES ('572','2018-12-07 04:39:11','129','715','101.02','91','6','93') ; 
INSERT INTO flight VALUES ('573','2018-12-07 01:51:55','49','271','41.27','189','67','68') ; 
INSERT INTO flight VALUES ('574','2018-12-07 01:05:52','378','2100','328.72','3','93','116') ; 
INSERT INTO flight VALUES ('575','2018-12-07 07:13:33','384','2131','333.26','186','93','118') ; 
INSERT INTO flight VALUES ('576','2018-12-07 22:04:21','282','1566','209.07','220','38','65') ; 
INSERT INTO flight VALUES ('577','2018-12-07 16:37:16','135','749','126.88','163','26','93') ; 
INSERT INTO flight VALUES ('578','2018-12-07 07:42:30','217','1203','200.80','26','38','67') ; 
INSERT INTO flight VALUES ('579','2018-12-07 08:08:39','255','1415','200.92','10','38','68') ; 
INSERT INTO flight VALUES ('580','2018-12-07 11:01:40','500','2777','349.49','152','68','65') ; 
INSERT INTO flight VALUES ('581','2018-12-07 08:41:53','49','271','35.24','138','68','67') ; 
INSERT INTO flight VALUES ('582','2018-12-07 03:37:39','181','1003','187.57','1','37','93') ; 
INSERT INTO flight VALUES ('583','2018-12-07 22:49:29','129','715','107.44','16','93','6') ; 
INSERT INTO flight VALUES ('584','2018-12-07 17:33:33','523','2906','423.69','197','118','65') ; 
INSERT INTO flight VALUES ('585','2018-12-07 06:01:08','520','2887','305.91','217','65','116') ; 
INSERT INTO flight VALUES ('586','2018-12-07 11:40:11','102','566','77.06','46','118','67') ; 
INSERT INTO flight VALUES ('587','2018-12-07 02:25:04','378','2100','355.14','248','116','93') ; 
INSERT INTO flight VALUES ('588','2018-12-07 05:47:50','485','2693','369.40','13','6','116') ; 
INSERT INTO flight VALUES ('589','2018-12-07 07:08:02','69','381','44.84','91','118','68') ; 
INSERT INTO flight VALUES ('590','2018-12-07 16:29:15','523','2906','585.90','240','65','118') ; 
INSERT INTO flight VALUES ('591','2018-12-07 20:44:01','445','2472','409.67','54','6','118') ; 
INSERT INTO flight VALUES ('592','2018-12-07 10:10:15','314','1747','269.84','55','67','93') ; 
INSERT INTO flight VALUES ('593','2018-12-07 01:52:06','513','2851','337.10','50','26','116') ; 
INSERT INTO flight VALUES ('594','2018-12-07 04:43:00','489','2716','360.00','224','26','118') ; 
INSERT INTO flight VALUES ('595','2018-12-07 07:43:46','167','929','108.51','238','38','93') ; 
INSERT INTO flight VALUES ('596','2018-12-07 22:20:38','363','2015','360.23','121','68','93') ; 
INSERT INTO flight VALUES ('597','2018-12-07 23:17:47','135','749','143.70','139','93','26') ; 
INSERT INTO flight VALUES ('598','2018-12-07 08:05:22','159','881','120.70','259','65','6') ; 
INSERT INTO flight VALUES ('599','2018-12-07 20:46:11','239','1327','188.00','173','37','116') ; 
INSERT INTO flight VALUES ('600','2018-12-07 22:50:06','228','1268','149.27','167','37','118') ; 
INSERT INTO flight VALUES ('601','2018-12-07 16:25:45','44','244','39.17','80','26','6') ; 
INSERT INTO flight VALUES ('602','2018-12-07 23:07:02','146','809','106.51','141','116','118') ; 
INSERT INTO flight VALUES ('603','2018-12-07 14:27:10','384','2131','239.31','93','118','93') ; 
INSERT INTO flight VALUES ('604','2018-12-07 17:34:50','226','1253','246.58','262','67','116') ; 
INSERT INTO flight VALUES ('605','2018-12-07 00:53:29','102','566','61.53','162','67','118') ; 
INSERT INTO flight VALUES ('606','2018-12-07 08:21:48','181','1003','202.13','82','93','37') ; 
INSERT INTO flight VALUES ('607','2018-12-07 06:06:32','167','929','111.44','131','93','38') ; 
INSERT INTO flight VALUES ('608','2018-12-07 15:17:49','393','2184','314.86','63','38','116') ; 
INSERT INTO flight VALUES ('609','2018-12-07 01:02:47','308','1712','288.94','96','38','118') ; 
INSERT INTO flight VALUES ('610','2018-12-07 14:36:06','254','1409','272.04','221','37','6') ; 
INSERT INTO flight VALUES ('611','2018-12-07 21:02:24','116','643','83.03','191','65','26') ; 
INSERT INTO flight VALUES ('612','2018-12-07 12:41:47','44','244','34.24','131','6','26') ; 
INSERT INTO flight VALUES ('613','2018-12-07 22:12:51','205','1137','123.25','3','68','116') ; 
INSERT INTO flight VALUES ('614','2018-12-07 12:03:13','69','381','43.79','33','68','118') ; 
INSERT INTO flight VALUES ('615','2018-12-07 05:26:59','485','2693','426.30','206','116','6') ; 
INSERT INTO flight VALUES ('616','2018-12-07 22:04:26','354','1965','264.99','127','67','6') ; 
INSERT INTO flight VALUES ('617','2018-12-07 18:52:08','320','1778','314.11','10','65','37') ; 
INSERT INTO flight VALUES ('618','2018-12-07 22:24:35','146','809','127.70','114','118','116') ; 
INSERT INTO flight VALUES ('619','2018-12-07 04:59:55','254','1409','254.41','43','6','37') ; 
INSERT INTO flight VALUES ('620','2018-12-07 16:10:25','282','1566','214.06','232','65','38') ; 
INSERT INTO flight VALUES ('621','2018-12-07 07:43:43','145','803','117.13','264','6','38') ; 
INSERT INTO flight VALUES ('622','2018-12-07 07:57:09','145','803','91.60','175','38','6') ; 
INSERT INTO flight VALUES ('623','2018-12-07 17:58:36','283','1570','249.35','85','26','37') ; 
INSERT INTO flight VALUES ('624','2018-12-07 04:37:25','189','1049','213.05','66','26','38') ; 
INSERT INTO flight VALUES ('625','2018-12-07 01:29:12','392','2176','285.99','19','68','6') ; 
INSERT INTO flight VALUES ('626','2018-12-07 06:12:46','142','789','141.41','79','93','65') ; 
INSERT INTO flight VALUES ('627','2018-12-07 08:05:11','283','1570','240.79','61','37','26') ; 
INSERT INTO flight VALUES ('628','2018-12-07 15:15:31','314','1747','238.40','120','93','67') ; 
INSERT INTO flight VALUES ('629','2018-12-07 13:13:20','363','2015','379.37','165','93','68') ; 
INSERT INTO flight VALUES ('630','2018-12-07 06:43:13','513','2851','341.75','145','116','26') ; 
INSERT INTO flight VALUES ('631','2018-12-08 09:29:12','397','2208','300.31','219','67','26') ; 
INSERT INTO flight VALUES ('632','2018-12-08 10:19:09','445','2472','415.53','107','118','6') ; 
INSERT INTO flight VALUES ('633','2018-12-08 08:33:43','156','867','146.70','177','37','38') ; 
INSERT INTO flight VALUES ('634','2018-12-08 13:20:04','189','1049','139.79','103','38','26') ; 
INSERT INTO flight VALUES ('635','2018-12-08 04:11:06','239','1327','154.05','132','116','37') ; 
INSERT INTO flight VALUES ('636','2018-12-08 20:20:23','393','2184','322.45','169','116','38') ; 
INSERT INTO flight VALUES ('637','2018-12-08 00:42:18','135','748','135.38','101','67','37') ; 
INSERT INTO flight VALUES ('638','2018-12-08 20:08:32','217','1203','185.70','27','67','38') ; 
INSERT INTO flight VALUES ('639','2018-12-08 20:49:01','435','2419','454.46','42','68','26') ; 
INSERT INTO flight VALUES ('640','2018-12-08 21:46:40','159','881','122.21','38','6','65') ; 
INSERT INTO flight VALUES ('641','2018-12-08 01:57:50','454','2523','377.33','255','65','67') ; 
INSERT INTO flight VALUES ('642','2018-12-08 22:34:13','354','1965','303.94','68','6','67') ; 
INSERT INTO flight VALUES ('643','2018-12-08 20:41:24','500','2777','421.17','133','65','68') ; 
INSERT INTO flight VALUES ('644','2018-12-08 05:51:51','392','2176','310.59','180','6','68') ; 
INSERT INTO flight VALUES ('645','2018-12-08 22:42:44','156','867','162.13','61','38','37') ; 
INSERT INTO flight VALUES ('646','2018-12-08 05:47:12','116','643','113.77','56','26','65') ; 
INSERT INTO flight VALUES ('647','2018-12-08 18:16:52','397','2208','330.82','178','26','67') ; 
INSERT INTO flight VALUES ('648','2018-12-08 10:31:41','435','2419','349.30','179','26','68') ; 
INSERT INTO flight VALUES ('649','2018-12-08 11:43:05','489','2716','397.59','212','118','26') ; 
INSERT INTO flight VALUES ('650','2018-12-08 13:14:52','183','1016','133.83','209','68','37') ; 
INSERT INTO flight VALUES ('651','2018-12-08 06:34:26','255','1415','152.38','181','68','38') ; 
INSERT INTO flight VALUES ('652','2018-12-08 23:48:04','320','1778','323.47','114','37','65') ; 
INSERT INTO flight VALUES ('653','2018-12-08 20:21:18','228','1268','158.11','220','118','37') ; 
INSERT INTO flight VALUES ('654','2018-12-08 12:25:46','135','748','138.60','110','37','67') ; 
INSERT INTO flight VALUES ('655','2018-12-08 15:42:33','308','1712','261.52','195','118','38') ; 
INSERT INTO flight VALUES ('656','2018-12-08 01:02:53','183','1016','123.99','158','37','68') ; 
INSERT INTO flight VALUES ('657','2018-12-08 13:39:40','520','2887','369.45','72','116','65') ; 
INSERT INTO flight VALUES ('658','2018-12-08 10:37:45','226','1253','226.61','61','116','67') ; 
INSERT INTO flight VALUES ('659','2018-12-08 18:45:08','454','2523','438.58','111','67','65') ; 
INSERT INTO flight VALUES ('660','2018-12-08 04:38:09','205','1137','148.26','249','116','68') ; 
INSERT INTO flight VALUES ('661','2018-12-08 14:07:40','142','789','113.32','95','65','93') ; 
INSERT INTO flight VALUES ('662','2018-12-08 19:49:36','129','715','133.70','57','6','93') ; 
INSERT INTO flight VALUES ('663','2018-12-08 08:12:59','49','271','42.81','161','67','68') ; 
INSERT INTO flight VALUES ('664','2018-12-08 04:14:25','378','2100','308.48','69','93','116') ; 
INSERT INTO flight VALUES ('665','2018-12-08 01:06:59','384','2131','318.81','187','93','118') ; 
INSERT INTO flight VALUES ('666','2018-12-08 12:06:12','282','1566','229.47','166','38','65') ; 
INSERT INTO flight VALUES ('667','2018-12-08 11:30:35','135','749','142.95','145','26','93') ; 
INSERT INTO flight VALUES ('668','2018-12-08 07:25:24','217','1203','204.21','39','38','67') ; 
INSERT INTO flight VALUES ('669','2018-12-08 02:33:22','255','1415','189.48','13','38','68') ; 
INSERT INTO flight VALUES ('670','2018-12-08 10:15:54','500','2777','457.34','138','68','65') ; 
INSERT INTO flight VALUES ('671','2018-12-08 20:50:01','49','271','37.34','147','68','67') ; 
INSERT INTO flight VALUES ('672','2018-12-08 15:45:01','181','1003','136.25','259','37','93') ; 
INSERT INTO flight VALUES ('673','2018-12-08 11:01:55','129','715','129.46','39','93','6') ; 
INSERT INTO flight VALUES ('674','2018-12-08 06:28:03','523','2906','513.21','29','118','65') ; 
INSERT INTO flight VALUES ('675','2018-12-08 05:53:44','520','2887','312.52','113','65','116') ; 
INSERT INTO flight VALUES ('676','2018-12-08 04:35:38','102','566','72.13','227','118','67') ; 
INSERT INTO flight VALUES ('677','2018-12-08 18:24:28','378','2100','380.31','205','116','93') ; 
INSERT INTO flight VALUES ('678','2018-12-08 21:59:15','485','2693','483.52','174','6','116') ; 
INSERT INTO flight VALUES ('679','2018-12-08 21:48:35','69','381','55.20','141','118','68') ; 
INSERT INTO flight VALUES ('680','2018-12-08 08:22:05','523','2906','470.46','75','65','118') ; 
INSERT INTO flight VALUES ('681','2018-12-08 00:37:59','445','2472','382.98','233','6','118') ; 
INSERT INTO flight VALUES ('682','2018-12-08 20:38:30','314','1747','231.63','263','67','93') ; 
INSERT INTO flight VALUES ('683','2018-12-08 05:37:28','513','2851','320.64','16','26','116') ; 
INSERT INTO flight VALUES ('684','2018-12-08 20:28:22','489','2716','336.04','91','26','118') ; 
INSERT INTO flight VALUES ('685','2018-12-08 08:43:18','167','929','128.38','78','38','93') ; 
INSERT INTO flight VALUES ('686','2018-12-08 09:52:19','363','2015','336.30','144','68','93') ; 
INSERT INTO flight VALUES ('687','2018-12-08 06:34:46','135','749','152.03','82','93','26') ; 
INSERT INTO flight VALUES ('688','2018-12-08 15:33:27','159','881','128.03','174','65','6') ; 
INSERT INTO flight VALUES ('689','2018-12-08 00:39:56','239','1327','219.43','65','37','116') ; 
INSERT INTO flight VALUES ('690','2018-12-08 05:02:03','228','1268','152.21','251','37','118') ; 
INSERT INTO flight VALUES ('691','2018-12-08 13:18:12','44','244','32.93','234','26','6') ; 
INSERT INTO flight VALUES ('692','2018-12-08 14:54:20','146','809','103.92','234','116','118') ; 
INSERT INTO flight VALUES ('693','2018-12-08 20:11:01','384','2131','294.04','141','118','93') ; 
INSERT INTO flight VALUES ('694','2018-12-08 22:15:57','226','1253','211.74','95','67','116') ; 
INSERT INTO flight VALUES ('695','2018-12-08 22:09:57','102','566','65.09','44','67','118') ; 
INSERT INTO flight VALUES ('696','2018-12-08 19:05:16','181','1003','173.93','102','93','37') ; 
INSERT INTO flight VALUES ('697','2018-12-08 04:15:03','167','929','106.36','46','93','38') ; 
INSERT INTO flight VALUES ('698','2018-12-08 19:47:57','393','2184','408.95','34','38','116') ; 
INSERT INTO flight VALUES ('699','2018-12-08 08:17:42','308','1712','271.71','8','38','118') ; 
INSERT INTO flight VALUES ('700','2018-12-08 06:00:55','254','1409','285.51','190','37','6') ; 
INSERT INTO flight VALUES ('701','2018-12-08 20:27:39','116','643','67.32','262','65','26') ; 
INSERT INTO flight VALUES ('702','2018-12-08 08:10:53','44','244','27.77','137','6','26') ; 
INSERT INTO flight VALUES ('703','2018-12-08 04:46:02','205','1137','169.57','20','68','116') ; 
INSERT INTO flight VALUES ('704','2018-12-08 16:13:20','69','381','58.57','161','68','118') ; 
INSERT INTO flight VALUES ('705','2018-12-08 05:10:45','485','2693','475.09','239','116','6') ; 
INSERT INTO flight VALUES ('706','2018-12-08 16:30:22','354','1965','218.60','86','67','6') ; 
INSERT INTO flight VALUES ('707','2018-12-08 15:08:03','320','1778','284.12','23','65','37') ; 
INSERT INTO flight VALUES ('708','2018-12-08 01:18:12','146','809','97.34','57','118','116') ; 
INSERT INTO flight VALUES ('709','2018-12-08 22:03:39','254','1409','255.64','214','6','37') ; 
INSERT INTO flight VALUES ('710','2018-12-08 11:36:39','282','1566','212.64','242','65','38') ; 
INSERT INTO flight VALUES ('711','2018-12-08 12:52:06','145','803','94.20','87','6','38') ; 
INSERT INTO flight VALUES ('712','2018-12-08 20:36:02','145','803','88.62','231','38','6') ; 
INSERT INTO flight VALUES ('713','2018-12-08 07:26:50','283','1570','244.37','137','26','37') ; 
INSERT INTO flight VALUES ('714','2018-12-08 04:25:14','189','1049','162.24','78','26','38') ; 
INSERT INTO flight VALUES ('715','2018-12-08 12:16:43','392','2176','218.17','49','68','6') ; 
INSERT INTO flight VALUES ('716','2018-12-08 21:52:28','142','789','142.67','90','93','65') ; 
INSERT INTO flight VALUES ('717','2018-12-08 23:01:56','283','1570','252.20','127','37','26') ; 
INSERT INTO flight VALUES ('718','2018-12-08 06:01:44','314','1747','218.87','98','93','67') ; 
INSERT INTO flight VALUES ('719','2018-12-08 02:47:14','363','2015','385.88','7','93','68') ; 
INSERT INTO flight VALUES ('720','2018-12-08 00:09:41','513','2851','475.11','241','116','26') ; 
INSERT INTO flight VALUES ('721','2018-12-09 14:56:05','397','2208','299.20','203','67','26') ; 
INSERT INTO flight VALUES ('722','2018-12-09 12:33:54','445','2472','412.36','81','118','6') ; 
INSERT INTO flight VALUES ('723','2018-12-09 11:06:41','156','867','156.32','129','37','38') ; 
INSERT INTO flight VALUES ('724','2018-12-09 06:17:17','189','1049','183.01','6','38','26') ; 
INSERT INTO flight VALUES ('725','2018-12-09 14:06:45','239','1327','141.80','69','116','37') ; 
INSERT INTO flight VALUES ('726','2018-12-09 20:13:45','393','2184','320.21','107','116','38') ; 
INSERT INTO flight VALUES ('727','2018-12-09 11:06:14','135','748','123.57','142','67','37') ; 
INSERT INTO flight VALUES ('728','2018-12-09 14:01:10','217','1203','186.78','193','67','38') ; 
INSERT INTO flight VALUES ('729','2018-12-09 12:29:51','435','2419','356.37','187','68','26') ; 
INSERT INTO flight VALUES ('730','2018-12-09 17:32:30','159','881','127.87','169','6','65') ; 
INSERT INTO flight VALUES ('731','2018-12-09 04:07:56','454','2523','430.91','2','65','67') ; 
INSERT INTO flight VALUES ('732','2018-12-09 14:32:57','354','1965','288.57','42','6','67') ; 
INSERT INTO flight VALUES ('733','2018-12-09 04:48:24','500','2777','568.28','138','65','68') ; 
INSERT INTO flight VALUES ('734','2018-12-09 03:44:43','392','2176','267.46','93','6','68') ; 
INSERT INTO flight VALUES ('735','2018-12-09 08:50:13','156','867','164.31','257','38','37') ; 
INSERT INTO flight VALUES ('736','2018-12-09 21:08:52','116','643','89.13','80','26','65') ; 
INSERT INTO flight VALUES ('737','2018-12-09 10:34:17','397','2208','266.02','136','26','67') ; 
INSERT INTO flight VALUES ('738','2018-12-09 11:54:47','435','2419','346.25','121','26','68') ; 
INSERT INTO flight VALUES ('739','2018-12-09 14:27:27','489','2716','454.58','261','118','26') ; 
INSERT INTO flight VALUES ('740','2018-12-09 14:57:43','183','1016','125.69','220','68','37') ; 
INSERT INTO flight VALUES ('741','2018-12-09 20:22:40','255','1415','204.30','135','68','38') ; 
INSERT INTO flight VALUES ('742','2018-12-09 07:34:08','320','1778','335.39','72','37','65') ; 
INSERT INTO flight VALUES ('743','2018-12-09 17:25:59','228','1268','163.05','140','118','37') ; 
INSERT INTO flight VALUES ('744','2018-12-09 10:32:15','135','748','104.26','232','37','67') ; 
INSERT INTO flight VALUES ('745','2018-12-09 04:34:55','308','1712','335.27','81','118','38') ; 
INSERT INTO flight VALUES ('746','2018-12-09 07:52:36','183','1016','107.97','10','37','68') ; 
INSERT INTO flight VALUES ('747','2018-12-09 19:15:52','520','2887','366.66','27','116','65') ; 
INSERT INTO flight VALUES ('748','2018-12-09 19:24:02','226','1253','250.58','186','116','67') ; 
INSERT INTO flight VALUES ('749','2018-12-09 19:23:25','454','2523','483.94','6','67','65') ; 
INSERT INTO flight VALUES ('750','2018-12-09 19:58:21','205','1137','170.41','193','116','68') ; 
INSERT INTO flight VALUES ('751','2018-12-09 09:25:26','142','789','99.09','195','65','93') ; 
INSERT INTO flight VALUES ('752','2018-12-09 09:56:02','129','715','135.46','51','6','93') ; 
INSERT INTO flight VALUES ('753','2018-12-09 00:45:52','49','271','38.87','179','67','68') ; 
INSERT INTO flight VALUES ('754','2018-12-09 11:11:14','378','2100','274.85','67','93','116') ; 
INSERT INTO flight VALUES ('755','2018-12-09 17:16:43','384','2131','343.50','134','93','118') ; 
INSERT INTO flight VALUES ('756','2018-12-09 11:03:28','282','1566','291.99','140','38','65') ; 
INSERT INTO flight VALUES ('757','2018-12-09 15:03:05','135','749','153.41','102','26','93') ; 
INSERT INTO flight VALUES ('758','2018-12-09 17:38:39','217','1203','166.86','207','38','67') ; 
INSERT INTO flight VALUES ('759','2018-12-09 11:00:17','255','1415','216.64','132','38','68') ; 
INSERT INTO flight VALUES ('760','2018-12-09 13:03:05','500','2777','376.53','256','68','65') ; 
INSERT INTO flight VALUES ('761','2018-12-09 04:33:53','49','271','47.32','191','68','67') ; 
INSERT INTO flight VALUES ('762','2018-12-09 08:50:19','181','1003','189.07','191','37','93') ; 
INSERT INTO flight VALUES ('763','2018-12-09 19:22:27','129','715','97.21','151','93','6') ; 
INSERT INTO flight VALUES ('764','2018-12-09 21:21:23','523','2906','537.63','128','118','65') ; 
INSERT INTO flight VALUES ('765','2018-12-09 01:49:37','520','2887','341.97','11','65','116') ; 
INSERT INTO flight VALUES ('766','2018-12-09 22:09:58','102','566','67.26','114','118','67') ; 
INSERT INTO flight VALUES ('767','2018-12-09 23:16:09','378','2100','351.45','152','116','93') ; 
INSERT INTO flight VALUES ('768','2018-12-09 09:59:50','485','2693','354.16','40','6','116') ; 
INSERT INTO flight VALUES ('769','2018-12-09 19:03:17','69','381','42.40','59','118','68') ; 
INSERT INTO flight VALUES ('770','2018-12-09 13:56:31','523','2906','627.59','263','65','118') ; 
INSERT INTO flight VALUES ('771','2018-12-09 14:18:48','445','2472','495.19','26','6','118') ; 
INSERT INTO flight VALUES ('772','2018-12-09 06:04:04','314','1747','224.77','175','67','93') ; 
INSERT INTO flight VALUES ('773','2018-12-09 04:23:15','513','2851','401.22','37','26','116') ; 
INSERT INTO flight VALUES ('774','2018-12-09 07:59:26','489','2716','474.84','115','26','118') ; 
INSERT INTO flight VALUES ('775','2018-12-09 17:14:09','167','929','153.08','198','38','93') ; 
INSERT INTO flight VALUES ('776','2018-12-09 07:45:19','363','2015','326.19','254','68','93') ; 
INSERT INTO flight VALUES ('777','2018-12-09 05:27:36','135','749','133.34','100','93','26') ; 
INSERT INTO flight VALUES ('778','2018-12-09 17:33:11','159','881','129.89','52','65','6') ; 
INSERT INTO flight VALUES ('779','2018-12-09 09:35:15','239','1327','211.62','118','37','116') ; 
INSERT INTO flight VALUES ('780','2018-12-09 18:51:29','228','1268','136.69','73','37','118') ; 
INSERT INTO flight VALUES ('781','2018-12-09 14:10:40','44','244','32.20','190','26','6') ; 
INSERT INTO flight VALUES ('782','2018-12-09 23:08:21','146','809','108.75','12','116','118') ; 
INSERT INTO flight VALUES ('783','2018-12-09 02:02:49','384','2131','295.01','149','118','93') ; 
INSERT INTO flight VALUES ('784','2018-12-09 16:28:33','226','1253','220.35','257','67','116') ; 
INSERT INTO flight VALUES ('785','2018-12-09 18:02:48','102','566','62.92','62','67','118') ; 
INSERT INTO flight VALUES ('786','2018-12-09 07:14:11','181','1003','169.18','178','93','37') ; 
INSERT INTO flight VALUES ('787','2018-12-09 18:28:26','167','929','128.44','222','93','38') ; 
INSERT INTO flight VALUES ('788','2018-12-09 12:37:41','393','2184','405.44','211','38','116') ; 
INSERT INTO flight VALUES ('789','2018-12-09 15:44:46','308','1712','292.74','49','38','118') ; 
INSERT INTO flight VALUES ('790','2018-12-09 20:34:26','254','1409','256.81','206','37','6') ; 
INSERT INTO flight VALUES ('791','2018-12-09 22:42:39','116','643','76.31','113','65','26') ; 
INSERT INTO flight VALUES ('792','2018-12-09 01:00:17','44','244','35.66','211','6','26') ; 
INSERT INTO flight VALUES ('793','2018-12-09 06:46:19','205','1137','132.65','154','68','116') ; 
INSERT INTO flight VALUES ('794','2018-12-09 17:50:01','69','381','44.76','155','68','118') ; 
INSERT INTO flight VALUES ('795','2018-12-09 17:20:21','485','2693','430.70','114','116','6') ; 
INSERT INTO flight VALUES ('796','2018-12-09 07:12:30','354','1965','280.60','70','67','6') ; 
INSERT INTO flight VALUES ('797','2018-12-09 23:18:46','320','1778','346.95','148','65','37') ; 
INSERT INTO flight VALUES ('798','2018-12-09 07:46:28','146','809','124.97','222','118','116') ; 
INSERT INTO flight VALUES ('799','2018-12-09 17:20:39','254','1409','249.24','185','6','37') ; 
INSERT INTO flight VALUES ('800','2018-12-09 11:33:29','282','1566','202.55','248','65','38') ; 
INSERT INTO flight VALUES ('801','2018-12-09 05:51:32','145','803','122.93','18','6','38') ; 
INSERT INTO flight VALUES ('802','2018-12-09 23:36:26','145','803','128.73','106','38','6') ; 
INSERT INTO flight VALUES ('803','2018-12-09 19:33:57','283','1570','209.44','46','26','37') ; 
INSERT INTO flight VALUES ('804','2018-12-09 16:25:47','189','1049','171.71','240','26','38') ; 
INSERT INTO flight VALUES ('805','2018-12-09 04:57:12','392','2176','313.32','242','68','6') ; 
INSERT INTO flight VALUES ('806','2018-12-09 07:36:42','142','789','120.64','265','93','65') ; 
INSERT INTO flight VALUES ('807','2018-12-09 05:15:42','283','1570','224.79','264','37','26') ; 
INSERT INTO flight VALUES ('808','2018-12-09 17:17:54','314','1747','270.90','149','93','67') ; 
INSERT INTO flight VALUES ('809','2018-12-09 00:11:00','363','2015','319.03','203','93','68') ; 
INSERT INTO flight VALUES ('810','2018-12-09 13:46:35','513','2851','449.86','152','116','26') ; 
INSERT INTO flight VALUES ('811','2018-12-10 23:52:21','397','2208','337.33','75','67','26') ; 
INSERT INTO flight VALUES ('812','2018-12-10 01:28:10','445','2472','423.87','2','118','6') ; 
INSERT INTO flight VALUES ('813','2018-12-10 09:22:20','156','867','169.36','217','37','38') ; 
INSERT INTO flight VALUES ('814','2018-12-10 04:11:07','189','1049','171.67','199','38','26') ; 
INSERT INTO flight VALUES ('815','2018-12-10 16:38:29','239','1327','145.12','55','116','37') ; 
INSERT INTO flight VALUES ('816','2018-12-10 16:50:13','393','2184','334.79','38','116','38') ; 
INSERT INTO flight VALUES ('817','2018-12-10 17:04:00','135','748','118.00','261','67','37') ; 
INSERT INTO flight VALUES ('818','2018-12-10 12:15:01','217','1203','215.93','47','67','38') ; 
INSERT INTO flight VALUES ('819','2018-12-10 01:58:01','435','2419','405.92','96','68','26') ; 
INSERT INTO flight VALUES ('820','2018-12-10 01:18:55','159','881','157.53','209','6','65') ; 
INSERT INTO flight VALUES ('821','2018-12-10 09:27:01','454','2523','350.75','45','65','67') ; 
INSERT INTO flight VALUES ('822','2018-12-10 20:24:03','354','1965','365.53','229','6','67') ; 
INSERT INTO flight VALUES ('823','2018-12-10 06:10:56','500','2777','481.15','192','65','68') ; 
INSERT INTO flight VALUES ('824','2018-12-10 04:40:44','392','2176','292.79','118','6','68') ; 
INSERT INTO flight VALUES ('825','2018-12-10 00:04:16','156','867','173.87','88','38','37') ; 
INSERT INTO flight VALUES ('826','2018-12-10 06:29:33','116','643','92.73','61','26','65') ; 
INSERT INTO flight VALUES ('827','2018-12-10 14:33:39','397','2208','306.77','196','26','67') ; 
INSERT INTO flight VALUES ('828','2018-12-10 00:53:24','435','2419','449.35','157','26','68') ; 
INSERT INTO flight VALUES ('829','2018-12-10 18:06:57','489','2716','442.62','141','118','26') ; 
INSERT INTO flight VALUES ('830','2018-12-10 19:25:12','183','1016','130.66','36','68','37') ; 
INSERT INTO flight VALUES ('831','2018-12-10 14:16:58','255','1415','209.44','120','68','38') ; 
INSERT INTO flight VALUES ('832','2018-12-10 08:46:00','320','1778','301.13','238','37','65') ; 
INSERT INTO flight VALUES ('833','2018-12-10 04:02:09','228','1268','186.00','193','118','37') ; 
INSERT INTO flight VALUES ('834','2018-12-10 17:40:47','135','748','132.10','156','37','67') ; 
INSERT INTO flight VALUES ('835','2018-12-10 02:05:55','308','1712','308.77','112','118','38') ; 
INSERT INTO flight VALUES ('836','2018-12-10 09:55:18','183','1016','123.96','187','37','68') ; 
INSERT INTO flight VALUES ('837','2018-12-10 03:33:50','520','2887','343.37','125','116','65') ; 
INSERT INTO flight VALUES ('838','2018-12-10 04:27:18','226','1253','203.41','249','116','67') ; 
INSERT INTO flight VALUES ('839','2018-12-10 07:09:01','454','2523','479.74','187','67','65') ; 
INSERT INTO flight VALUES ('840','2018-12-10 11:37:54','205','1137','130.77','203','116','68') ; 
INSERT INTO flight VALUES ('841','2018-12-10 15:31:04','142','789','114.61','20','65','93') ; 
INSERT INTO flight VALUES ('842','2018-12-10 05:39:16','129','715','106.13','84','6','93') ; 
INSERT INTO flight VALUES ('843','2018-12-10 23:55:03','49','271','35.45','107','67','68') ; 
INSERT INTO flight VALUES ('844','2018-12-10 11:22:35','378','2100','264.45','28','93','116') ; 
INSERT INTO flight VALUES ('845','2018-12-10 11:22:18','384','2131','266.04','74','93','118') ; 
INSERT INTO flight VALUES ('846','2018-12-10 02:20:57','282','1566','292.38','60','38','65') ; 
INSERT INTO flight VALUES ('847','2018-12-10 08:47:51','135','749','112.10','157','26','93') ; 
INSERT INTO flight VALUES ('848','2018-12-10 05:32:29','217','1203','171.15','166','38','67') ; 
INSERT INTO flight VALUES ('849','2018-12-10 03:20:31','255','1415','197.42','219','38','68') ; 
INSERT INTO flight VALUES ('850','2018-12-10 07:45:25','500','2777','388.04','208','68','65') ; 
INSERT INTO flight VALUES ('851','2018-12-10 19:54:06','49','271','46.10','43','68','67') ; 
INSERT INTO flight VALUES ('852','2018-12-10 22:01:50','181','1003','160.66','206','37','93') ; 
INSERT INTO flight VALUES ('853','2018-12-10 21:24:18','129','715','97.57','220','93','6') ; 
INSERT INTO flight VALUES ('854','2018-12-10 05:04:45','523','2906','553.65','132','118','65') ; 
INSERT INTO flight VALUES ('855','2018-12-10 04:22:25','520','2887','350.69','232','65','116') ; 
INSERT INTO flight VALUES ('856','2018-12-10 14:11:27','102','566','60.93','29','118','67') ; 
INSERT INTO flight VALUES ('857','2018-12-10 11:11:34','378','2100','433.14','253','116','93') ; 
INSERT INTO flight VALUES ('858','2018-12-10 05:28:58','485','2693','443.48','135','6','116') ; 
INSERT INTO flight VALUES ('859','2018-12-10 09:00:42','69','381','51.46','144','118','68') ; 
INSERT INTO flight VALUES ('860','2018-12-10 11:33:11','523','2906','583.76','257','65','118') ; 
INSERT INTO flight VALUES ('861','2018-12-10 13:03:44','445','2472','479.22','197','6','118') ; 
INSERT INTO flight VALUES ('862','2018-12-10 00:02:51','314','1747','242.42','180','67','93') ; 
INSERT INTO flight VALUES ('863','2018-12-10 00:40:21','513','2851','306.13','62','26','116') ; 
INSERT INTO flight VALUES ('864','2018-12-10 16:14:28','489','2716','357.93','223','26','118') ; 
INSERT INTO flight VALUES ('865','2018-12-10 07:02:03','167','929','160.09','55','38','93') ; 
INSERT INTO flight VALUES ('866','2018-12-10 20:51:27','363','2015','313.50','215','68','93') ; 
INSERT INTO flight VALUES ('867','2018-12-10 13:52:30','135','749','137.36','77','93','26') ; 
INSERT INTO flight VALUES ('868','2018-12-10 03:29:08','159','881','107.29','12','65','6') ; 
INSERT INTO flight VALUES ('869','2018-12-10 02:27:01','239','1327','208.37','19','37','116') ; 
INSERT INTO flight VALUES ('870','2018-12-10 12:17:55','228','1268','155.84','103','37','118') ; 
INSERT INTO flight VALUES ('871','2018-12-10 15:13:40','44','244','32.87','219','26','6') ; 
INSERT INTO flight VALUES ('872','2018-12-10 10:27:01','146','809','104.47','100','116','118') ; 
INSERT INTO flight VALUES ('873','2018-12-10 18:00:08','384','2131','329.81','15','118','93') ; 
INSERT INTO flight VALUES ('874','2018-12-10 14:05:18','226','1253','200.58','222','67','116') ; 
INSERT INTO flight VALUES ('875','2018-12-10 16:41:46','102','566','58.95','265','67','118') ; 
INSERT INTO flight VALUES ('876','2018-12-10 20:13:20','181','1003','153.18','31','93','37') ; 
INSERT INTO flight VALUES ('877','2018-12-10 01:18:21','167','929','150.14','17','93','38') ; 
INSERT INTO flight VALUES ('878','2018-12-10 05:19:19','393','2184','355.08','140','38','116') ; 
INSERT INTO flight VALUES ('879','2018-12-10 14:32:39','308','1712','326.65','91','38','118') ; 
INSERT INTO flight VALUES ('880','2018-12-10 13:28:08','254','1409','208.74','143','37','6') ; 
INSERT INTO flight VALUES ('881','2018-12-10 06:40:22','116','643','85.74','171','65','26') ; 
INSERT INTO flight VALUES ('882','2018-12-10 19:53:43','44','244','29.73','9','6','26') ; 
INSERT INTO flight VALUES ('883','2018-12-10 03:41:13','205','1137','127.80','93','68','116') ; 
INSERT INTO flight VALUES ('884','2018-12-10 13:22:11','69','381','46.87','200','68','118') ; 
INSERT INTO flight VALUES ('885','2018-12-10 01:06:55','485','2693','475.19','48','116','6') ; 
INSERT INTO flight VALUES ('886','2018-12-10 03:45:00','354','1965','225.88','265','67','6') ; 
INSERT INTO flight VALUES ('887','2018-12-10 11:03:19','320','1778','352.16','122','65','37') ; 
INSERT INTO flight VALUES ('888','2018-12-10 05:57:03','146','809','107.66','191','118','116') ; 
INSERT INTO flight VALUES ('889','2018-12-10 13:56:38','254','1409','264.10','226','6','37') ; 
INSERT INTO flight VALUES ('890','2018-12-10 21:59:56','282','1566','245.14','205','65','38') ; 
INSERT INTO flight VALUES ('891','2018-12-10 01:41:10','145','803','129.33','81','6','38') ; 
INSERT INTO flight VALUES ('892','2018-12-10 06:56:39','145','803','120.83','134','38','6') ; 
INSERT INTO flight VALUES ('893','2018-12-10 03:22:47','283','1570','248.40','63','26','37') ; 
INSERT INTO flight VALUES ('894','2018-12-10 09:14:27','189','1049','183.30','263','26','38') ; 
INSERT INTO flight VALUES ('895','2018-12-10 02:39:52','392','2176','236.17','79','68','6') ; 
INSERT INTO flight VALUES ('896','2018-12-10 19:40:32','142','789','135.69','224','93','65') ; 
INSERT INTO flight VALUES ('897','2018-12-10 06:32:43','283','1570','220.71','141','37','26') ; 
INSERT INTO flight VALUES ('898','2018-12-10 13:12:19','314','1747','213.25','32','93','67') ; 
INSERT INTO flight VALUES ('899','2018-12-10 07:12:23','363','2015','318.34','80','93','68') ; 
INSERT INTO flight VALUES ('900','2018-12-10 06:38:00','513','2851','332.96','137','116','26') ; 

INSERT INTO trip VALUES ('254','1') ; 
INSERT INTO trip VALUES ('817','2') ; 
INSERT INTO trip VALUES ('4','3') ; 
INSERT INTO trip VALUES ('91','4') ; 
INSERT INTO trip VALUES ('624','5') ; 
INSERT INTO trip VALUES ('354','6') ; 
INSERT INTO trip VALUES ('5','7') ; 
INSERT INTO trip VALUES ('787','8') ; 
INSERT INTO trip VALUES ('499','9') ; 
INSERT INTO trip VALUES ('465','10') ; 
INSERT INTO trip VALUES ('397','11') ; 
INSERT INTO trip VALUES ('344','12') ; 
INSERT INTO trip VALUES ('892','13') ; 
INSERT INTO trip VALUES ('666','14') ; 
INSERT INTO trip VALUES ('178','15') ; 
INSERT INTO trip VALUES ('528','16') ; 
INSERT INTO trip VALUES ('513','17') ; 
INSERT INTO trip VALUES ('134','18') ; 
INSERT INTO trip VALUES ('624','19') ; 
INSERT INTO trip VALUES ('395','20') ; 
INSERT INTO trip VALUES ('281','21') ; 
INSERT INTO trip VALUES ('764','22') ; 
INSERT INTO trip VALUES ('299','23') ; 
INSERT INTO trip VALUES ('96','24') ; 
INSERT INTO trip VALUES ('411','25') ; 
INSERT INTO trip VALUES ('136','26') ; 
INSERT INTO trip VALUES ('874','27') ; 
INSERT INTO trip VALUES ('608','28') ; 
INSERT INTO trip VALUES ('161','29') ; 
INSERT INTO trip VALUES ('513','30') ; 
INSERT INTO trip VALUES ('508','31') ; 
INSERT INTO trip VALUES ('526','32') ; 
INSERT INTO trip VALUES ('422','33') ; 
INSERT INTO trip VALUES ('88','34') ; 
INSERT INTO trip VALUES ('299','35') ; 
INSERT INTO trip VALUES ('290','36') ; 
INSERT INTO trip VALUES ('195','37') ; 
INSERT INTO trip VALUES ('487','38') ; 
INSERT INTO trip VALUES ('252','39') ; 
INSERT INTO trip VALUES ('614','40') ; 
INSERT INTO trip VALUES ('9','41') ; 
INSERT INTO trip VALUES ('552','42') ; 
INSERT INTO trip VALUES ('163','43') ; 
INSERT INTO trip VALUES ('578','44') ; 
INSERT INTO trip VALUES ('554','45') ; 
INSERT INTO trip VALUES ('807','46') ; 
INSERT INTO trip VALUES ('779','47') ; 
INSERT INTO trip VALUES ('486','48') ; 
INSERT INTO trip VALUES ('407','49') ; 
INSERT INTO trip VALUES ('270','50') ; 
INSERT INTO trip VALUES ('704','51') ; 
INSERT INTO trip VALUES ('612','52') ; 
INSERT INTO trip VALUES ('795','53') ; 
INSERT INTO trip VALUES ('822','54') ; 
INSERT INTO trip VALUES ('819','55') ; 
INSERT INTO trip VALUES ('614','56') ; 
INSERT INTO trip VALUES ('100','57') ; 
INSERT INTO trip VALUES ('125','58') ; 
INSERT INTO trip VALUES ('745','59') ; 
INSERT INTO trip VALUES ('13','60') ; 
INSERT INTO trip VALUES ('571','61') ; 
INSERT INTO trip VALUES ('524','62') ; 
INSERT INTO trip VALUES ('444','63') ; 
INSERT INTO trip VALUES ('537','64') ; 
INSERT INTO trip VALUES ('427','65') ; 
INSERT INTO trip VALUES ('759','66') ; 
INSERT INTO trip VALUES ('865','67') ; 
INSERT INTO trip VALUES ('514','68') ; 
INSERT INTO trip VALUES ('630','69') ; 
INSERT INTO trip VALUES ('702','70') ; 
INSERT INTO trip VALUES ('549','71') ; 
INSERT INTO trip VALUES ('570','72') ; 
INSERT INTO trip VALUES ('63','73') ; 
INSERT INTO trip VALUES ('659','74') ; 
INSERT INTO trip VALUES ('579','75') ; 
INSERT INTO trip VALUES ('153','76') ; 
INSERT INTO trip VALUES ('58','77') ; 
INSERT INTO trip VALUES ('495','78') ; 
INSERT INTO trip VALUES ('738','79') ; 
INSERT INTO trip VALUES ('227','80') ; 
INSERT INTO trip VALUES ('192','81') ; 
INSERT INTO trip VALUES ('489','82') ; 
INSERT INTO trip VALUES ('553','83') ; 
INSERT INTO trip VALUES ('721','84') ; 
INSERT INTO trip VALUES ('553','85') ; 
INSERT INTO trip VALUES ('174','86') ; 
INSERT INTO trip VALUES ('720','87') ; 
INSERT INTO trip VALUES ('394','88') ; 
INSERT INTO trip VALUES ('331','89') ; 
INSERT INTO trip VALUES ('888','90') ; 
INSERT INTO trip VALUES ('893','91') ; 
INSERT INTO trip VALUES ('817','92') ; 
INSERT INTO trip VALUES ('615','93') ; 
INSERT INTO trip VALUES ('782','94') ; 
INSERT INTO trip VALUES ('150','95') ; 
INSERT INTO trip VALUES ('841','96') ; 
INSERT INTO trip VALUES ('897','97') ; 
INSERT INTO trip VALUES ('590','98') ; 
INSERT INTO trip VALUES ('701','99') ; 
INSERT INTO trip VALUES ('148','100') ; 

# ==============================================================================
# Procedure: Cancel a reservation
delimiter //
drop procedure if exists FindRoundTripFlights //
create procedure FindRoundTripFlights(in origin varchar(45), in destination
  varchar(45), in departureDate date, in returnDate date)
begin
  (select flight_id                                                     as 'Flight ID',
          a.airport_iata_code                                           as Origin,
          a2.airport_iata_code                                          as Destination,
          concat(date_format(f.flight_departure_date_time, '%a %b %e %Y '),
                 time_format(f.flight_departure_date_time, '%h:%i %p')) as
                                                                           'Departure Date/Time',
          time_format(date_add(f.flight_departure_date_time,
                               interval f.flight_duration_minutes minute),
                      '%h:%i %p')                                       as 'Arrival Time',
          concat(lpad(f.flight_duration_minutes div 60, 2, ' '), 'h ',
                 lpad(mod(f.flight_duration_minutes, 60), 2, ' '), 'm')
                                                                        as 'Duration',
          lpad(format(f.flight_distance, 0), 10, ' ')                   as 'Distance (mi)',
          concat('$',
                 lpad(format(f.flight_base_price, 2), 9,
                      ' '))                                             as 'Costs'
   from flight f
          join airport a on f.origin_id = a.airport_id
          join airport a2 on f.destination_id = a2.airport_id
   where a.airport_iata_code like origin
     and a2.airport_iata_code like destination
     and date(f.flight_departure_date_time) = departureDate
   order by f.flight_base_price, f.flight_departure_date_time
   limit 5)
  union
  (select flight_id                                                     as 'Flight ID',
          a.airport_iata_code                                           as Origin,
          a2.airport_iata_code                                          as Destination,
          concat(date_format(f.flight_departure_date_time, '%a %b %e %Y '),
                 time_format(f.flight_departure_date_time, '%h:%i %p')) as
                                                                           'Departure Date/Time',
          time_format(date_add(f.flight_departure_date_time,
                               interval f.flight_duration_minutes minute),
                      '%h:%i %p')                                       as 'Arrival Time',
          concat(lpad(f.flight_duration_minutes div 60, 2, ' '), 'h ',
                 lpad(mod(f.flight_duration_minutes, 60), 2, ' '), 'm')
                                                                        as 'Duration',
          lpad(format(f.flight_distance, 0), 10, ' ')                   as 'Distance (mi)',
          concat('$',
                 lpad(format(f.flight_base_price, 2), 9,
                      ' '))                                             as 'Costs'
   from flight f
          join airport a on f.origin_id = a.airport_id
          join airport a2 on f.destination_id = a2.airport_id
   where a.airport_iata_code like destination
     and a2.airport_iata_code like origin
     and date(f.flight_departure_date_time) = returnDate
   order by f.flight_base_price, f.flight_departure_date_time
   limit 5);
end //
delimiter ;

# ==============================================================================
# Procedure: Make a reservation
delimiter //
drop procedure if exists MakeReservation //
create procedure MakeReservation(in travelerId int, in flightId int, in
  classType
  varchar(45), in tickets int)
begin
  declare reservationId int default 0;
  insert into reservation (traveler_id, class_id, reservation_tickets,
                           reservation_date_time)
  values (travelerId,
          (select class_id
           from class
           where class_type like concat('%', classType, '%')),
          tickets, now());

  select max(reservation_id)
         into reservationId
  from reservation
  where traveler_id = travelerId;

  insert into trip (flight_id, reservation_id)
  values (flightId, reservationId);

  select reservationId as `Reservation Id`;
end //
delimiter ;

# ==============================================================================
# Procedure: Cancel a reservation
delimiter //
drop procedure if exists CancelReservation //
create procedure CancelReservation(in reservationId int)
begin
  delete
  from trip
  where reservation_id = reservationId;

  delete
  from reservation
  where reservation_id = reservationId;
end //
delimiter ;