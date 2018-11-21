CREATE DATABASE IF NOT EXISTS `travel_lite` DEFAULT CHARACTER SET utf8 ;
USE `travel_lite` ;

-- -----------------------------------------------------
-- Table `travel_lite`.`airlines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`airlines` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`airlines` (
  `airlines_id` INT NOT NULL AUTO_INCREMENT,
  `airlines_iata_code` CHAR(5) NOT NULL,
  `airlines_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`airlines_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`aircraft`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`aircraft` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`aircraft` (
  `aircraft_id` INT NOT NULL AUTO_INCREMENT,
  `aircraft_manufacturer` VARCHAR(45) NOT NULL,
  `aircraft_model` VARCHAR(45) NOT NULL,
  `aircraft_year` INT NOT NULL,
  `aircraft_tailnum` VARCHAR(45) NOT NULL,
  `aircraft_seats` INT NOT NULL,
  `airlines_id` INT NOT NULL,
  PRIMARY KEY (`aircraft_id`),
  INDEX `fk_aircraft_airlines1_idx` (`airlines_id` ASC),
  CONSTRAINT `fk_aircraft_airlines1`
    FOREIGN KEY (`airlines_id`)
    REFERENCES `travel_lite`.`airlines` (`airlines_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`state` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`state` (
  `state_id` INT NOT NULL AUTO_INCREMENT,
  `state_name_abbreviation` CHAR(2) NOT NULL,
  `state_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`state_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`city` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`city` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(45) NOT NULL,
  `state_id` INT NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `fk_city_state1_idx` (`state_id` ASC),
  CONSTRAINT `fk_city_state1`
    FOREIGN KEY (`state_id`)
    REFERENCES `travel_lite`.`state` (`state_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`airport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`airport` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`airport` (
  `airport_id` INT NOT NULL AUTO_INCREMENT,
  `airport_iata_code` CHAR(5) NOT NULL,
  `airport_name` VARCHAR(80) NOT NULL,
  `city_id` INT NOT NULL,
  PRIMARY KEY (`airport_id`),
  INDEX `fk_airport_city1_idx` (`city_id` ASC),
  CONSTRAINT `fk_airport_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `travel_lite`.`city` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`origin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`origin` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`origin` (
  `origin_id` INT NOT NULL AUTO_INCREMENT,
  `airport_id` INT NOT NULL,
  PRIMARY KEY (`origin_id`),
  INDEX `fk_origin_airport1_idx` (`airport_id` ASC),
  CONSTRAINT `fk_origin_airport1`
    FOREIGN KEY (`airport_id`)
    REFERENCES `travel_lite`.`airport` (`airport_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`destination`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`destination` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`destination` (
  `destination_id` INT NOT NULL,
  `airport_id` INT NOT NULL,
  PRIMARY KEY (`destination_id`),
  INDEX `fk_destination_airport1_idx` (`airport_id` ASC),
  CONSTRAINT `fk_destination_airport1`
    FOREIGN KEY (`airport_id`)
    REFERENCES `travel_lite`.`airport` (`airport_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`flight`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`flight` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`flight` (
  `flight_id` INT NOT NULL AUTO_INCREMENT,
  `flight_departure_date_time` DATETIME NOT NULL,
  `flight_duration_minutes` INT NOT NULL,
  `flgiht_distance` DECIMAL NOT NULL,
  `flight_base_price` DECIMAL(10,2) NOT NULL,
  `aircraft_id` INT NOT NULL,
  `origin_id` INT NOT NULL,
  `destination_id` INT NOT NULL,
  PRIMARY KEY (`flight_id`),
  INDEX `fk_flight_airplane1_idx` (`aircraft_id` ASC),
  INDEX `fk_flight_origin1_idx` (`origin_id` ASC),
  INDEX `fk_flight_destination1_idx` (`destination_id` ASC),
  CONSTRAINT `fk_flight_airplane1`
    FOREIGN KEY (`aircraft_id`)
    REFERENCES `travel_lite`.`aircraft` (`aircraft_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_origin1`
    FOREIGN KEY (`origin_id`)
    REFERENCES `travel_lite`.`origin` (`origin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_destination1`
    FOREIGN KEY (`destination_id`)
    REFERENCES `travel_lite`.`destination` (`destination_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`traveler`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`traveler` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`traveler` (
  `traveler_id` INT NOT NULL AUTO_INCREMENT,
  `traveler_first_name` VARCHAR(45) NOT NULL,
  `traveler_last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`traveler_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`trip_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`trip_type` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`trip_type` (
  `trip_type_id` INT NOT NULL AUTO_INCREMENT,
  `trip_type_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`trip_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`trip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`trip` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`trip` (
  `trip_id` INT NOT NULL AUTO_INCREMENT,
  `trip_type_id` INT NOT NULL,
  `origin_id` INT NOT NULL,
  `destination_id` INT NOT NULL,
  PRIMARY KEY (`trip_id`),
  INDEX `fk_trip_trip_type_idx` (`trip_type_id` ASC),
  INDEX `fk_trip_origin1_idx` (`origin_id` ASC),
  INDEX `fk_trip_destination1_idx` (`destination_id` ASC),
  CONSTRAINT `fk_trip_trip_type`
    FOREIGN KEY (`trip_type_id`)
    REFERENCES `travel_lite`.`trip_type` (`trip_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_trip_origin1`
    FOREIGN KEY (`origin_id`)
    REFERENCES `travel_lite`.`origin` (`origin_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_trip_destination1`
    FOREIGN KEY (`destination_id`)
    REFERENCES `travel_lite`.`destination` (`destination_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`class` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`class` (
  `class_id` INT NOT NULL AUTO_INCREMENT,
  `class_type` VARCHAR(45) NOT NULL,
  `class_seat_ratio` DECIMAL NOT NULL,
  PRIMARY KEY (`class_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`connection`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`connection` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`connection` (
  `trip_id` INT NOT NULL,
  `flight_id` INT NOT NULL,
  PRIMARY KEY (`trip_id`, `flight_id`),
  INDEX `fk_flight_has_trip_trip1_idx` (`trip_id` ASC),
  INDEX `fk_flight_has_trip_flight1_idx` (`flight_id` ASC),
  CONSTRAINT `fk_flight_has_trip_flight1`
    FOREIGN KEY (`flight_id`)
    REFERENCES `travel_lite`.`flight` (`flight_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flight_has_trip_trip1`
    FOREIGN KEY (`trip_id`)
    REFERENCES `travel_lite`.`trip` (`trip_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`reservation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`reservation` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`reservation` (
  `reservation_id` INT NOT NULL AUTO_INCREMENT,
  `traveler_id` INT NOT NULL,
  `trip_id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `reservation_tickets` INT NOT NULL DEFAULT 1,
  `reservation_date_time` DATETIME NOT NULL,
  PRIMARY KEY (`reservation_id`),
  INDEX `fk_reservation_customer1_idx` (`traveler_id` ASC),
  INDEX `fk_reservation_trip1_idx` (`trip_id` ASC),
  INDEX `fk_reservation_class1_idx` (`class_id` ASC),
  CONSTRAINT `fk_reservation_customer1`
    FOREIGN KEY (`traveler_id`)
    REFERENCES `travel_lite`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_trip1`
    FOREIGN KEY (`trip_id`)
    REFERENCES `travel_lite`.`trip` (`trip_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `travel_lite`.`class` (`class_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`payment_card_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`payment_card_type` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`payment_card_type` (
  `payment_card_type_id` INT NOT NULL AUTO_INCREMENT,
  `payment_card_type_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`payment_card_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`payment_card`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`payment_card` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`payment_card` (
  `payment_card_id` INT NOT NULL AUTO_INCREMENT,
  `payment_card_number` VARCHAR(45) NOT NULL,
  `payment_card_expiration_date` DATETIME NOT NULL,
  `payment_card_cvc` CHAR(5) NOT NULL,
  `customer_id` INT NOT NULL,
  `payment_card_type_id` INT NOT NULL,
  PRIMARY KEY (`payment_card_id`),
  INDEX `fk_payment_card_customer1_idx` (`customer_id` ASC),
  INDEX `fk_payment_card_payment_card_type1_idx` (`payment_card_type_id` ASC),
  CONSTRAINT `fk_payment_card_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `travel_lite`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_card_payment_card_type1`
    FOREIGN KEY (`payment_card_type_id`)
    REFERENCES `travel_lite`.`payment_card_type` (`payment_card_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`price_factor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`price_factor` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`price_factor` (
  `airlines_id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `price_factor` DECIMAL NOT NULL,
  INDEX `fk_airlines_has_class_class1_idx` (`class_id` ASC),
  INDEX `fk_airlines_has_class_airlines1_idx` (`airlines_id` ASC),
  PRIMARY KEY (`airlines_id`, `class_id`),
  CONSTRAINT `fk_airlines_has_class_airlines1`
    FOREIGN KEY (`airlines_id`)
    REFERENCES `travel_lite`.`airlines` (`airlines_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_airlines_has_class_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `travel_lite`.`class` (`class_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`phone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`phone` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`phone` (
  `phone_id` INT NOT NULL AUTO_INCREMENT,
  `phone_number` CHAR(12) NOT NULL,
  `traveler_id` INT NOT NULL,
  PRIMARY KEY (`phone_id`),
  INDEX `fk_phone_customer1_idx` (`traveler_id` ASC),
  CONSTRAINT `fk_phone_customer1`
    FOREIGN KEY (`traveler_id`)
    REFERENCES `travel_lite`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `travel_lite`.`email`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `travel_lite`.`email` ;

CREATE TABLE IF NOT EXISTS `travel_lite`.`email` (
  `email_id` INT NOT NULL AUTO_INCREMENT,
  `email_address` VARCHAR(45) NOT NULL,
  `traveler_id` INT NOT NULL,
  PRIMARY KEY (`email_id`),
  INDEX `fk_email_customer1_idx` (`traveler_id` ASC),
  CONSTRAINT `fk_email_customer1`
    FOREIGN KEY (`traveler_id`)
    REFERENCES `travel_lite`.`traveler` (`traveler_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `travel_lite` ; 

INSERT INTO `state` VALUES ('1','AL','Alabama') ; 
INSERT INTO `state` VALUES ('2','AK','Alaska') ; 
INSERT INTO `state` VALUES ('3','AZ','Arizona') ; 
INSERT INTO `state` VALUES ('4','AR','Arkansas') ; 
INSERT INTO `state` VALUES ('5','CA','California') ; 
INSERT INTO `state` VALUES ('6','CO','Colorado') ; 
INSERT INTO `state` VALUES ('7','CT','Connecticut') ; 
INSERT INTO `state` VALUES ('8','DE','Delaware') ; 
INSERT INTO `state` VALUES ('9','DC','District of Columbia') ; 
INSERT INTO `state` VALUES ('10','FL','Florida') ; 
INSERT INTO `state` VALUES ('11','GA','Georgia') ; 
INSERT INTO `state` VALUES ('12','HI','Hawaii') ; 
INSERT INTO `state` VALUES ('13','ID','Idaho') ; 
INSERT INTO `state` VALUES ('14','IL','Illinois') ; 
INSERT INTO `state` VALUES ('15','IN','Indiana') ; 
INSERT INTO `state` VALUES ('16','IA','Iowa') ; 
INSERT INTO `state` VALUES ('17','KS','Kansas') ; 
INSERT INTO `state` VALUES ('18','KY','Kentucky') ; 
INSERT INTO `state` VALUES ('19','LA','Louisiana') ; 
INSERT INTO `state` VALUES ('20','ME','Maine') ; 
INSERT INTO `state` VALUES ('21','MT','Montana') ; 
INSERT INTO `state` VALUES ('22','NE','Nebraska') ; 
INSERT INTO `state` VALUES ('23','NV','Nevada') ; 
INSERT INTO `state` VALUES ('24','NH','New Hampshire') ; 
INSERT INTO `state` VALUES ('25','NJ','New Jersey') ; 
INSERT INTO `state` VALUES ('26','NM','New Mexico') ; 
INSERT INTO `state` VALUES ('27','NY','New York') ; 
INSERT INTO `state` VALUES ('28','NC','North Carolina') ; 
INSERT INTO `state` VALUES ('29','ND','North Dakota') ; 
INSERT INTO `state` VALUES ('30','OH','Ohio') ; 
INSERT INTO `state` VALUES ('31','OK','Oklahoma') ; 
INSERT INTO `state` VALUES ('32','OR','Oregon') ; 
INSERT INTO `state` VALUES ('33','MD','Maryland') ; 
INSERT INTO `state` VALUES ('34','MA','Massachusetts') ; 
INSERT INTO `state` VALUES ('35','MI','Michigan') ; 
INSERT INTO `state` VALUES ('36','MN','Minnesota') ; 
INSERT INTO `state` VALUES ('37','MS','Mississippi') ; 
INSERT INTO `state` VALUES ('38','MO','Missouri') ; 
INSERT INTO `state` VALUES ('39','PA','Pennsylvania') ; 
INSERT INTO `state` VALUES ('40','RI','Rhode Island') ; 
INSERT INTO `state` VALUES ('41','SC','South Carolina') ; 
INSERT INTO `state` VALUES ('42','SD','South Dakota') ; 
INSERT INTO `state` VALUES ('43','TN','Tennessee') ; 
INSERT INTO `state` VALUES ('44','TX','Texas') ; 
INSERT INTO `state` VALUES ('45','UT','Utah') ; 
INSERT INTO `state` VALUES ('46','VT','Vermont') ; 
INSERT INTO `state` VALUES ('47','VA','Virginia') ; 
INSERT INTO `state` VALUES ('48','WA','Washington') ; 
INSERT INTO `state` VALUES ('49','WV','West Virginia') ; 
INSERT INTO `state` VALUES ('50','WI','Wisconsin') ; 
INSERT INTO `state` VALUES ('51','WY','Wyoming') ; 

INSERT INTO `city` VALUES ('1','Abilene','44') ; 
INSERT INTO `city` VALUES ('2','Alamogordo','26') ; 
INSERT INTO `city` VALUES ('3','Albuquerque','26') ; 
INSERT INTO `city` VALUES ('4','Altus','31') ; 
INSERT INTO `city` VALUES ('5','Amarillo','44') ; 
INSERT INTO `city` VALUES ('6','Anchorage','2') ; 
INSERT INTO `city` VALUES ('7','Asheville','28') ; 
INSERT INTO `city` VALUES ('8','Atlanta','11') ; 
INSERT INTO `city` VALUES ('9','Augusta','11') ; 
INSERT INTO `city` VALUES ('10','Austin','44') ; 
INSERT INTO `city` VALUES ('11','Baltimore','33') ; 
INSERT INTO `city` VALUES ('12','Bangor','20') ; 
INSERT INTO `city` VALUES ('13','Belleville','14') ; 
INSERT INTO `city` VALUES ('14','Billings','21') ; 
INSERT INTO `city` VALUES ('15','Birmingham','1') ; 
INSERT INTO `city` VALUES ('16','Bloomington/Normal','14') ; 
INSERT INTO `city` VALUES ('17','Boise','13') ; 
INSERT INTO `city` VALUES ('18','Bossier City','19') ; 
INSERT INTO `city` VALUES ('19','Boston','34') ; 
INSERT INTO `city` VALUES ('20','Bristol/Johnson/Kingsport','43') ; 
INSERT INTO `city` VALUES ('21','Buffalo','27') ; 
INSERT INTO `city` VALUES ('22','Camp Springs','33') ; 
INSERT INTO `city` VALUES ('23','Casper','51') ; 
INSERT INTO `city` VALUES ('24','Cedar Rapids','16') ; 
INSERT INTO `city` VALUES ('25','Charleston','41') ; 
INSERT INTO `city` VALUES ('26','Charleston','49') ; 
INSERT INTO `city` VALUES ('27','Charlotte','28') ; 
INSERT INTO `city` VALUES ('28','Chattanooga','43') ; 
INSERT INTO `city` VALUES ('29','Chicago','14') ; 
INSERT INTO `city` VALUES ('30','Chicago/Rockford','14') ; 
INSERT INTO `city` VALUES ('31','Cincinnati','18') ; 
INSERT INTO `city` VALUES ('32','Cleveland','30') ; 
INSERT INTO `city` VALUES ('33','Clovis','26') ; 
INSERT INTO `city` VALUES ('34','Columbia','41') ; 
INSERT INTO `city` VALUES ('35','Columbus','37') ; 
INSERT INTO `city` VALUES ('36','Columbus','30') ; 
INSERT INTO `city` VALUES ('37','Corpus Christi','44') ; 
INSERT INTO `city` VALUES ('38','Dallas','44') ; 
INSERT INTO `city` VALUES ('39','Dallas-Fort Worth','44') ; 
INSERT INTO `city` VALUES ('40','Dayton','30') ; 
INSERT INTO `city` VALUES ('41','Daytona Beach','10') ; 
INSERT INTO `city` VALUES ('42','Del Rio','44') ; 
INSERT INTO `city` VALUES ('43','Denver','6') ; 
INSERT INTO `city` VALUES ('44','Des Moines','16') ; 
INSERT INTO `city` VALUES ('45','Detroit','35') ; 
INSERT INTO `city` VALUES ('46','Dover','8') ; 
INSERT INTO `city` VALUES ('47','Dubuque','16') ; 
INSERT INTO `city` VALUES ('48','Duluth','36') ; 
INSERT INTO `city` VALUES ('49','Edwards','5') ; 
INSERT INTO `city` VALUES ('50','Enid','31') ; 
INSERT INTO `city` VALUES ('51','Erie','39') ; 
INSERT INTO `city` VALUES ('52','Fairbanks','2') ; 
INSERT INTO `city` VALUES ('53','Fairfield','5') ; 
INSERT INTO `city` VALUES ('54','Fort Lauderdale','10') ; 
INSERT INTO `city` VALUES ('55','Fort Myers','10') ; 
INSERT INTO `city` VALUES ('56','Fort Smith','4') ; 
INSERT INTO `city` VALUES ('57','Fort Wayne','15') ; 
INSERT INTO `city` VALUES ('58','Fort Worth','44') ; 
INSERT INTO `city` VALUES ('59','Glendale','3') ; 
INSERT INTO `city` VALUES ('60','Goldsboro','28') ; 
INSERT INTO `city` VALUES ('61','Green Bay','50') ; 
INSERT INTO `city` VALUES ('62','Greensboro','28') ; 
INSERT INTO `city` VALUES ('63','Greenville','41') ; 
INSERT INTO `city` VALUES ('64','Gulfport','37') ; 
INSERT INTO `city` VALUES ('65','Hampton','47') ; 
INSERT INTO `city` VALUES ('66','Hartford','7') ; 
INSERT INTO `city` VALUES ('67','Hibbing','36') ; 
INSERT INTO `city` VALUES ('68','Honolulu','12') ; 
INSERT INTO `city` VALUES ('69','Houston','44') ; 
INSERT INTO `city` VALUES ('70','Huntington','49') ; 
INSERT INTO `city` VALUES ('71','Huntsville','1') ; 
INSERT INTO `city` VALUES ('72','Indianapolis','15') ; 
INSERT INTO `city` VALUES ('73','Jackson','37') ; 
INSERT INTO `city` VALUES ('74','Jacksonville','10') ; 
INSERT INTO `city` VALUES ('75','Joplin','38') ; 
INSERT INTO `city` VALUES ('76','Kansas City','38') ; 
INSERT INTO `city` VALUES ('77','Knob Noster','38') ; 
INSERT INTO `city` VALUES ('78','Knoxville','43') ; 
INSERT INTO `city` VALUES ('79','Lafayette','19') ; 
INSERT INTO `city` VALUES ('80','Las Vegas','23') ; 
INSERT INTO `city` VALUES ('81','Lexington','18') ; 
INSERT INTO `city` VALUES ('82','Little Rock','4') ; 
INSERT INTO `city` VALUES ('83','Lompoc','5') ; 
INSERT INTO `city` VALUES ('84','Los Angeles','5') ; 
INSERT INTO `city` VALUES ('85','Louisville','18') ; 
INSERT INTO `city` VALUES ('86','Lubbock','44') ; 
INSERT INTO `city` VALUES ('87','Madison','50') ; 
INSERT INTO `city` VALUES ('88','Marietta','11') ; 
INSERT INTO `city` VALUES ('89','Marysville','5') ; 
INSERT INTO `city` VALUES ('90','Memphis','43') ; 
INSERT INTO `city` VALUES ('91','Miami','10') ; 
INSERT INTO `city` VALUES ('92','Milwaukee','50') ; 
INSERT INTO `city` VALUES ('93','Minneapolis','36') ; 
INSERT INTO `city` VALUES ('94','Mobile','1') ; 
INSERT INTO `city` VALUES ('95','Moline','14') ; 
INSERT INTO `city` VALUES ('96','Monroe','19') ; 
INSERT INTO `city` VALUES ('97','Montgomery','1') ; 
INSERT INTO `city` VALUES ('98','Mountain Home','13') ; 
INSERT INTO `city` VALUES ('99','Nashville','43') ; 
INSERT INTO `city` VALUES ('100','New Orleans','19') ; 
INSERT INTO `city` VALUES ('101','New York','27') ; 
INSERT INTO `city` VALUES ('102','Newark','25') ; 
INSERT INTO `city` VALUES ('103','Newport News','47') ; 
INSERT INTO `city` VALUES ('104','Norfolk','47') ; 
INSERT INTO `city` VALUES ('105','Oakland','5') ; 
INSERT INTO `city` VALUES ('106','Oklahoma City','31') ; 
INSERT INTO `city` VALUES ('107','Omaha','22') ; 
INSERT INTO `city` VALUES ('108','Ontario','5') ; 
INSERT INTO `city` VALUES ('109','Orlando','10') ; 
INSERT INTO `city` VALUES ('110','Panama City','10') ; 
INSERT INTO `city` VALUES ('111','Peoria','14') ; 
INSERT INTO `city` VALUES ('112','Peru','15') ; 
INSERT INTO `city` VALUES ('113','Philadelphia','39') ; 
INSERT INTO `city` VALUES ('114','Phoenix','3') ; 
INSERT INTO `city` VALUES ('115','Pittsburgh','39') ; 
INSERT INTO `city` VALUES ('116','Portland','32') ; 
INSERT INTO `city` VALUES ('117','Portland','20') ; 
INSERT INTO `city` VALUES ('118','Raleigh/Durham','28') ; 
INSERT INTO `city` VALUES ('119','Reno','23') ; 
INSERT INTO `city` VALUES ('120','Richmond','47') ; 
INSERT INTO `city` VALUES ('121','Roanoke','47') ; 
INSERT INTO `city` VALUES ('122','Rochester','27') ; 
INSERT INTO `city` VALUES ('123','Rochester','36') ; 
INSERT INTO `city` VALUES ('124','Sacramento','5') ; 
INSERT INTO `city` VALUES ('125','Saginaw','35') ; 
INSERT INTO `city` VALUES ('126','Salt Lake City','45') ; 
INSERT INTO `city` VALUES ('127','San Antonio','44') ; 
INSERT INTO `city` VALUES ('128','San Diego','5') ; 
INSERT INTO `city` VALUES ('129','San Francisco','5') ; 
INSERT INTO `city` VALUES ('130','San Jose','5') ; 
INSERT INTO `city` VALUES ('131','Santa Ana','5') ; 
INSERT INTO `city` VALUES ('132','Sarasota/Bradenton','10') ; 
INSERT INTO `city` VALUES ('133','Savannah','11') ; 
INSERT INTO `city` VALUES ('134','Seattle','48') ; 
INSERT INTO `city` VALUES ('135','Sioux City','16') ; 
INSERT INTO `city` VALUES ('136','South Bend','15') ; 
INSERT INTO `city` VALUES ('137','Spokane','48') ; 
INSERT INTO `city` VALUES ('138','Springfield','38') ; 
INSERT INTO `city` VALUES ('139','Springfield','14') ; 
INSERT INTO `city` VALUES ('140','St Louis','38') ; 
INSERT INTO `city` VALUES ('141','Sumter','41') ; 
INSERT INTO `city` VALUES ('142','Syracuse','27') ; 
INSERT INTO `city` VALUES ('143','Tacoma','48') ; 
INSERT INTO `city` VALUES ('144','Tallahassee','10') ; 
INSERT INTO `city` VALUES ('145','Tampa','10') ; 
INSERT INTO `city` VALUES ('146','Toledo','30') ; 
INSERT INTO `city` VALUES ('147','Tucson','3') ; 
INSERT INTO `city` VALUES ('148','Tulsa','31') ; 
INSERT INTO `city` VALUES ('149','Universal City','44') ; 
INSERT INTO `city` VALUES ('150','Valparaiso','10') ; 
INSERT INTO `city` VALUES ('151','Warner Robins','11') ; 
INSERT INTO `city` VALUES ('152','Washington','9') ; 
INSERT INTO `city` VALUES ('153','West Palm Beach','10') ; 
INSERT INTO `city` VALUES ('154','Wichita','17') ; 
INSERT INTO `city` VALUES ('155','Wichita Falls','44') ; 

INSERT INTO `airport` VALUES ('1','ABQ','Albuquerque International Sunport','3') ; 
INSERT INTO `airport` VALUES ('2','AFW','Fort Worth Alliance Airport','58') ; 
INSERT INTO `airport` VALUES ('3','AGS','Augusta Regional At Bush Field','9') ; 
INSERT INTO `airport` VALUES ('4','AMA','Rick Husband Amarillo International Airport','5') ; 
INSERT INTO `airport` VALUES ('5','ANC','Ted Stevens Anchorage International Airport','6') ; 
INSERT INTO `airport` VALUES ('6','ATL','Hartsfield Jackson Atlanta International Airport','8') ; 
INSERT INTO `airport` VALUES ('7','AUS','Austin Bergstrom International Airport','10') ; 
INSERT INTO `airport` VALUES ('8','AVL','Asheville Regional Airport','7') ; 
INSERT INTO `airport` VALUES ('9','BDL','Bradley International Airport','66') ; 
INSERT INTO `airport` VALUES ('10','BFI','Boeing Field King County International Airport','134') ; 
INSERT INTO `airport` VALUES ('11','BGR','Bangor International Airport','12') ; 
INSERT INTO `airport` VALUES ('12','BHM','Birmingham-Shuttlesworth International Airport','15') ; 
INSERT INTO `airport` VALUES ('13','BIL','Billings Logan International Airport','14') ; 
INSERT INTO `airport` VALUES ('14','BLV','Scott AFB/Midamerica Airport','13') ; 
INSERT INTO `airport` VALUES ('15','BMI','Central Illinois Regional Airport at Bloomington-Normal','16') ; 
INSERT INTO `airport` VALUES ('16','BNA','Nashville International Airport','99') ; 
INSERT INTO `airport` VALUES ('17','BOI','Boise Air Terminal/Gowen Field','17') ; 
INSERT INTO `airport` VALUES ('18','BOS','General Edward Lawrence Logan International Airport','19') ; 
INSERT INTO `airport` VALUES ('19','BUF','Buffalo Niagara International Airport','21') ; 
INSERT INTO `airport` VALUES ('20','BWI','Baltimore/Washington International Thurgood Marshall Airport','11') ; 
INSERT INTO `airport` VALUES ('21','CAE','Columbia Metropolitan Airport','34') ; 
INSERT INTO `airport` VALUES ('22','CHA','Lovell Field','28') ; 
INSERT INTO `airport` VALUES ('23','CHS','Charleston Air Force Base-International Airport','25') ; 
INSERT INTO `airport` VALUES ('24','CID','The Eastern Iowa Airport','24') ; 
INSERT INTO `airport` VALUES ('25','CLE','Cleveland Hopkins International Airport','32') ; 
INSERT INTO `airport` VALUES ('26','CLT','Charlotte Douglas International Airport','27') ; 
INSERT INTO `airport` VALUES ('27','CMH','John Glenn Columbus International Airport','35') ; 
INSERT INTO `airport` VALUES ('28','CPR','Casper-Natrona County International Airport','23') ; 
INSERT INTO `airport` VALUES ('29','CRP','Corpus Christi International Airport','37') ; 
INSERT INTO `airport` VALUES ('30','CRW','Yeager Airport','25') ; 
INSERT INTO `airport` VALUES ('31','CVG','Cincinnati Northern Kentucky International Airport','31') ; 
INSERT INTO `airport` VALUES ('32','DAB','Daytona Beach International Airport','41') ; 
INSERT INTO `airport` VALUES ('33','DAL','Dallas Love Field','38') ; 
INSERT INTO `airport` VALUES ('34','DAY','James M Cox Dayton International Airport','40') ; 
INSERT INTO `airport` VALUES ('35','DBQ','Dubuque Regional Airport','47') ; 
INSERT INTO `airport` VALUES ('36','DCA','Ronald Reagan Washington National Airport','152') ; 
INSERT INTO `airport` VALUES ('37','DEN','Denver International Airport','43') ; 
INSERT INTO `airport` VALUES ('38','DFW','Dallas Fort Worth International Airport','39') ; 
INSERT INTO `airport` VALUES ('39','DLH','Duluth International Airport','48') ; 
INSERT INTO `airport` VALUES ('40','DSM','Des Moines International Airport','44') ; 
INSERT INTO `airport` VALUES ('41','DTW','Detroit Metropolitan Wayne County Airport','45') ; 
INSERT INTO `airport` VALUES ('42','ERI','Erie International Tom Ridge Field','51') ; 
INSERT INTO `airport` VALUES ('43','EWR','Newark Liberty International Airport','102') ; 
INSERT INTO `airport` VALUES ('44','FAI','Fairbanks International Airport','52') ; 
INSERT INTO `airport` VALUES ('45','FLL','Fort Lauderdale Hollywood International Airport','54') ; 
INSERT INTO `airport` VALUES ('46','FSM','Fort Smith Regional Airport','56') ; 
INSERT INTO `airport` VALUES ('47','FTW','Fort Worth Meacham International Airport','58') ; 
INSERT INTO `airport` VALUES ('48','FWA','Fort Wayne International Airport','57') ; 
INSERT INTO `airport` VALUES ('49','GEG','Spokane International Airport','137') ; 
INSERT INTO `airport` VALUES ('50','GPT','Gulfport Biloxi International Airport','64') ; 
INSERT INTO `airport` VALUES ('51','GRB','Austin Straubel International Airport','61') ; 
INSERT INTO `airport` VALUES ('52','GSO','Piedmont Triad International Airport','62') ; 
INSERT INTO `airport` VALUES ('53','GSP','Greenville Spartanburg International Airport','63') ; 
INSERT INTO `airport` VALUES ('54','HIB','Range Regional Airport','67') ; 
INSERT INTO `airport` VALUES ('55','HNL','Daniel K Inouye International Airport','68') ; 
INSERT INTO `airport` VALUES ('56','HOU','William P Hobby Airport','69') ; 
INSERT INTO `airport` VALUES ('57','HSV','Huntsville International Carl T Jones Field','71') ; 
INSERT INTO `airport` VALUES ('58','HTS','Tri-State/Milton J. Ferguson Field','70') ; 
INSERT INTO `airport` VALUES ('59','IAD','Washington Dulles International Airport','152') ; 
INSERT INTO `airport` VALUES ('60','IAH','George Bush Intercontinental Houston Airport','69') ; 
INSERT INTO `airport` VALUES ('61','ICT','Wichita Eisenhower National Airport','154') ; 
INSERT INTO `airport` VALUES ('62','IND','Indianapolis International Airport','72') ; 
INSERT INTO `airport` VALUES ('63','JAN','Jackson-Medgar Wiley Evers International Airport','73') ; 
INSERT INTO `airport` VALUES ('64','JAX','Jacksonville International Airport','74') ; 
INSERT INTO `airport` VALUES ('65','JFK','John F Kennedy International Airport','101') ; 
INSERT INTO `airport` VALUES ('66','JLN','Joplin Regional Airport','75') ; 
INSERT INTO `airport` VALUES ('67','LAS','McCarran International Airport','80') ; 
INSERT INTO `airport` VALUES ('68','LAX','Los Angeles International Airport','84') ; 
INSERT INTO `airport` VALUES ('69','LBB','Lubbock Preston Smith International Airport','86') ; 
INSERT INTO `airport` VALUES ('70','LCK','Rickenbacker International Airport','35') ; 
INSERT INTO `airport` VALUES ('71','LEX','Blue Grass Airport','81') ; 
INSERT INTO `airport` VALUES ('72','LFT','Lafayette Regional Airport','79') ; 
INSERT INTO `airport` VALUES ('73','LGA','La Guardia Airport','101') ; 
INSERT INTO `airport` VALUES ('74','LIT','Bill & Hillary Clinton National Airport/Adams Field','82') ; 
INSERT INTO `airport` VALUES ('75','MBS','MBS International Airport','125') ; 
INSERT INTO `airport` VALUES ('76','MCI','Kansas City International Airport','76') ; 
INSERT INTO `airport` VALUES ('77','MCO','Orlando International Airport','109') ; 
INSERT INTO `airport` VALUES ('78','MDW','Chicago Midway International Airport','29') ; 
INSERT INTO `airport` VALUES ('79','MEM','Memphis International Airport','90') ; 
INSERT INTO `airport` VALUES ('80','MGM','Montgomery Regional (Dannelly Field) Airport','97') ; 
INSERT INTO `airport` VALUES ('81','MIA','Miami International Airport','91') ; 
INSERT INTO `airport` VALUES ('82','MKE','General Mitchell International Airport','92') ; 
INSERT INTO `airport` VALUES ('83','MLI','Quad City International Airport','95') ; 
INSERT INTO `airport` VALUES ('84','MLU','Monroe Regional Airport','96') ; 
INSERT INTO `airport` VALUES ('85','MOB','Mobile Regional Airport','94') ; 
INSERT INTO `airport` VALUES ('86','MSN','Dane County Regional Truax Field','87') ; 
INSERT INTO `airport` VALUES ('87','MSP','Minneapolis-St Paul International/Wold-Chamberlain Airport','93') ; 
INSERT INTO `airport` VALUES ('88','MSY','Louis Armstrong New Orleans International Airport','100') ; 
INSERT INTO `airport` VALUES ('89','OAK','Metropolitan Oakland International Airport','105') ; 
INSERT INTO `airport` VALUES ('90','OKC','Will Rogers World Airport','106') ; 
INSERT INTO `airport` VALUES ('91','OMA','Eppley Airfield','107') ; 
INSERT INTO `airport` VALUES ('92','ONT','Ontario International Airport','108') ; 
INSERT INTO `airport` VALUES ('93','ORD','Chicago O\'Hare International Airport','29') ; 
INSERT INTO `airport` VALUES ('94','ORF','Norfolk International Airport','104') ; 
INSERT INTO `airport` VALUES ('95','PBI','Palm Beach International Airport','153') ; 
INSERT INTO `airport` VALUES ('96','PDX','Portland International Airport','116') ; 
INSERT INTO `airport` VALUES ('97','PHF','Newport News Williamsburg International Airport','103') ; 
INSERT INTO `airport` VALUES ('98','PHL','Philadelphia International Airport','113') ; 
INSERT INTO `airport` VALUES ('99','PHX','Phoenix Sky Harbor International Airport','114') ; 
INSERT INTO `airport` VALUES ('100','PIA','General Wayne A. Downing Peoria International Airport','111') ; 
INSERT INTO `airport` VALUES ('101','PIT','Pittsburgh International Airport','115') ; 
INSERT INTO `airport` VALUES ('102','PWM','Portland International Jetport Airport','116') ; 
INSERT INTO `airport` VALUES ('103','RDU','Raleigh Durham International Airport','118') ; 
INSERT INTO `airport` VALUES ('104','RFD','Chicago Rockford International Airport','30') ; 
INSERT INTO `airport` VALUES ('105','RIC','Richmond International Airport','120') ; 
INSERT INTO `airport` VALUES ('106','RNO','Reno Tahoe International Airport','119') ; 
INSERT INTO `airport` VALUES ('107','ROA','Roanoke–Blacksburg Regional Airport','121') ; 
INSERT INTO `airport` VALUES ('108','ROC','Greater Rochester International Airport','122') ; 
INSERT INTO `airport` VALUES ('109','RST','Rochester International Airport','122') ; 
INSERT INTO `airport` VALUES ('110','RSW','Southwest Florida International Airport','55') ; 
INSERT INTO `airport` VALUES ('111','SAN','San Diego International Airport','128') ; 
INSERT INTO `airport` VALUES ('112','SAT','San Antonio International Airport','127') ; 
INSERT INTO `airport` VALUES ('113','SAV','Savannah Hilton Head International Airport','133') ; 
INSERT INTO `airport` VALUES ('114','SBN','South Bend Regional Airport','136') ; 
INSERT INTO `airport` VALUES ('115','SDF','Louisville International Standiford Field','85') ; 
INSERT INTO `airport` VALUES ('116','SEA','Seattle Tacoma International Airport','134') ; 
INSERT INTO `airport` VALUES ('117','SFB','Orlando Sanford International Airport','109') ; 
INSERT INTO `airport` VALUES ('118','SFO','San Francisco International Airport','129') ; 
INSERT INTO `airport` VALUES ('119','SGF','Springfield Branson National Airport','138') ; 
INSERT INTO `airport` VALUES ('120','SJC','Norman Y. Mineta San Jose International Airport','130') ; 
INSERT INTO `airport` VALUES ('121','SLC','Salt Lake City International Airport','126') ; 
INSERT INTO `airport` VALUES ('122','SMF','Sacramento International Airport','124') ; 
INSERT INTO `airport` VALUES ('123','SNA','John Wayne Airport-Orange County Airport','131') ; 
INSERT INTO `airport` VALUES ('124','SPI','Abraham Lincoln Capital Airport','138') ; 
INSERT INTO `airport` VALUES ('125','SRQ','Sarasota Bradenton International Airport','132') ; 
INSERT INTO `airport` VALUES ('126','STL','St Louis Lambert International Airport','140') ; 
INSERT INTO `airport` VALUES ('127','SUS','Spirit of St Louis Airport','140') ; 
INSERT INTO `airport` VALUES ('128','SUX','Sioux Gateway Col. Bud Day Field','135') ; 
INSERT INTO `airport` VALUES ('129','SYR','Syracuse Hancock International Airport','142') ; 
INSERT INTO `airport` VALUES ('130','TLH','Tallahassee Regional Airport','144') ; 
INSERT INTO `airport` VALUES ('131','TOL','Toledo Express Airport','146') ; 
INSERT INTO `airport` VALUES ('132','TPA','Tampa International Airport','145') ; 
INSERT INTO `airport` VALUES ('133','TRI','Tri-Cities Regional TN/VA Airport','20') ; 
INSERT INTO `airport` VALUES ('134','TUL','Tulsa International Airport','148') ; 
INSERT INTO `airport` VALUES ('135','TUS','Tucson International Airport','147') ; 
INSERT INTO `airport` VALUES ('136','TYS','McGhee Tyson Airport','78') ; 
INSERT INTO `airport` VALUES ('137','VPS','Destin-Ft Walton Beach Airport','150') ; 

INSERT INTO `origin` VALUES ('1','1') ; 
INSERT INTO `origin` VALUES ('2','2') ; 
INSERT INTO `origin` VALUES ('3','3') ; 
INSERT INTO `origin` VALUES ('4','4') ; 
INSERT INTO `origin` VALUES ('5','5') ; 
INSERT INTO `origin` VALUES ('6','6') ; 
INSERT INTO `origin` VALUES ('7','7') ; 
INSERT INTO `origin` VALUES ('8','8') ; 
INSERT INTO `origin` VALUES ('9','9') ; 
INSERT INTO `origin` VALUES ('10','10') ; 
INSERT INTO `origin` VALUES ('11','11') ; 
INSERT INTO `origin` VALUES ('12','12') ; 
INSERT INTO `origin` VALUES ('13','13') ; 
INSERT INTO `origin` VALUES ('14','14') ; 
INSERT INTO `origin` VALUES ('15','15') ; 
INSERT INTO `origin` VALUES ('16','16') ; 
INSERT INTO `origin` VALUES ('17','17') ; 
INSERT INTO `origin` VALUES ('18','18') ; 
INSERT INTO `origin` VALUES ('19','19') ; 
INSERT INTO `origin` VALUES ('20','20') ; 
INSERT INTO `origin` VALUES ('21','21') ; 
INSERT INTO `origin` VALUES ('22','22') ; 
INSERT INTO `origin` VALUES ('23','23') ; 
INSERT INTO `origin` VALUES ('24','24') ; 
INSERT INTO `origin` VALUES ('25','25') ; 
INSERT INTO `origin` VALUES ('26','26') ; 
INSERT INTO `origin` VALUES ('27','27') ; 
INSERT INTO `origin` VALUES ('28','28') ; 
INSERT INTO `origin` VALUES ('29','29') ; 
INSERT INTO `origin` VALUES ('30','30') ; 
INSERT INTO `origin` VALUES ('31','31') ; 
INSERT INTO `origin` VALUES ('32','32') ; 
INSERT INTO `origin` VALUES ('33','33') ; 
INSERT INTO `origin` VALUES ('34','34') ; 
INSERT INTO `origin` VALUES ('35','35') ; 
INSERT INTO `origin` VALUES ('36','36') ; 
INSERT INTO `origin` VALUES ('37','37') ; 
INSERT INTO `origin` VALUES ('38','38') ; 
INSERT INTO `origin` VALUES ('39','39') ; 
INSERT INTO `origin` VALUES ('40','40') ; 
INSERT INTO `origin` VALUES ('41','41') ; 
INSERT INTO `origin` VALUES ('42','42') ; 
INSERT INTO `origin` VALUES ('43','43') ; 
INSERT INTO `origin` VALUES ('44','44') ; 
INSERT INTO `origin` VALUES ('45','45') ; 
INSERT INTO `origin` VALUES ('46','46') ; 
INSERT INTO `origin` VALUES ('47','47') ; 
INSERT INTO `origin` VALUES ('48','48') ; 
INSERT INTO `origin` VALUES ('49','49') ; 
INSERT INTO `origin` VALUES ('50','50') ; 
INSERT INTO `origin` VALUES ('51','51') ; 
INSERT INTO `origin` VALUES ('52','52') ; 
INSERT INTO `origin` VALUES ('53','53') ; 
INSERT INTO `origin` VALUES ('54','54') ; 
INSERT INTO `origin` VALUES ('55','55') ; 
INSERT INTO `origin` VALUES ('56','56') ; 
INSERT INTO `origin` VALUES ('57','57') ; 
INSERT INTO `origin` VALUES ('58','58') ; 
INSERT INTO `origin` VALUES ('59','59') ; 
INSERT INTO `origin` VALUES ('60','60') ; 
INSERT INTO `origin` VALUES ('61','61') ; 
INSERT INTO `origin` VALUES ('62','62') ; 
INSERT INTO `origin` VALUES ('63','63') ; 
INSERT INTO `origin` VALUES ('64','64') ; 
INSERT INTO `origin` VALUES ('65','65') ; 
INSERT INTO `origin` VALUES ('66','66') ; 
INSERT INTO `origin` VALUES ('67','67') ; 
INSERT INTO `origin` VALUES ('68','68') ; 
INSERT INTO `origin` VALUES ('69','69') ; 
INSERT INTO `origin` VALUES ('70','70') ; 
INSERT INTO `origin` VALUES ('71','71') ; 
INSERT INTO `origin` VALUES ('72','72') ; 
INSERT INTO `origin` VALUES ('73','73') ; 
INSERT INTO `origin` VALUES ('74','74') ; 
INSERT INTO `origin` VALUES ('75','75') ; 
INSERT INTO `origin` VALUES ('76','76') ; 
INSERT INTO `origin` VALUES ('77','77') ; 
INSERT INTO `origin` VALUES ('78','78') ; 
INSERT INTO `origin` VALUES ('79','79') ; 
INSERT INTO `origin` VALUES ('80','80') ; 
INSERT INTO `origin` VALUES ('81','81') ; 
INSERT INTO `origin` VALUES ('82','82') ; 
INSERT INTO `origin` VALUES ('83','83') ; 
INSERT INTO `origin` VALUES ('84','84') ; 
INSERT INTO `origin` VALUES ('85','85') ; 
INSERT INTO `origin` VALUES ('86','86') ; 
INSERT INTO `origin` VALUES ('87','87') ; 
INSERT INTO `origin` VALUES ('88','88') ; 
INSERT INTO `origin` VALUES ('89','89') ; 
INSERT INTO `origin` VALUES ('90','90') ; 
INSERT INTO `origin` VALUES ('91','91') ; 
INSERT INTO `origin` VALUES ('92','92') ; 
INSERT INTO `origin` VALUES ('93','93') ; 
INSERT INTO `origin` VALUES ('94','94') ; 
INSERT INTO `origin` VALUES ('95','95') ; 
INSERT INTO `origin` VALUES ('96','96') ; 
INSERT INTO `origin` VALUES ('97','97') ; 
INSERT INTO `origin` VALUES ('98','98') ; 
INSERT INTO `origin` VALUES ('99','99') ; 
INSERT INTO `origin` VALUES ('100','100') ; 
INSERT INTO `origin` VALUES ('101','101') ; 
INSERT INTO `origin` VALUES ('102','102') ; 
INSERT INTO `origin` VALUES ('103','103') ; 
INSERT INTO `origin` VALUES ('104','104') ; 
INSERT INTO `origin` VALUES ('105','105') ; 
INSERT INTO `origin` VALUES ('106','106') ; 
INSERT INTO `origin` VALUES ('107','107') ; 
INSERT INTO `origin` VALUES ('108','108') ; 
INSERT INTO `origin` VALUES ('109','109') ; 
INSERT INTO `origin` VALUES ('110','110') ; 
INSERT INTO `origin` VALUES ('111','111') ; 
INSERT INTO `origin` VALUES ('112','112') ; 
INSERT INTO `origin` VALUES ('113','113') ; 
INSERT INTO `origin` VALUES ('114','114') ; 
INSERT INTO `origin` VALUES ('115','115') ; 
INSERT INTO `origin` VALUES ('116','116') ; 
INSERT INTO `origin` VALUES ('117','117') ; 
INSERT INTO `origin` VALUES ('118','118') ; 
INSERT INTO `origin` VALUES ('119','119') ; 
INSERT INTO `origin` VALUES ('120','120') ; 
INSERT INTO `origin` VALUES ('121','121') ; 
INSERT INTO `origin` VALUES ('122','122') ; 
INSERT INTO `origin` VALUES ('123','123') ; 
INSERT INTO `origin` VALUES ('124','124') ; 
INSERT INTO `origin` VALUES ('125','125') ; 
INSERT INTO `origin` VALUES ('126','126') ; 
INSERT INTO `origin` VALUES ('127','127') ; 
INSERT INTO `origin` VALUES ('128','128') ; 
INSERT INTO `origin` VALUES ('129','129') ; 
INSERT INTO `origin` VALUES ('130','130') ; 
INSERT INTO `origin` VALUES ('131','131') ; 
INSERT INTO `origin` VALUES ('132','132') ; 
INSERT INTO `origin` VALUES ('133','133') ; 
INSERT INTO `origin` VALUES ('134','134') ; 
INSERT INTO `origin` VALUES ('135','135') ; 
INSERT INTO `origin` VALUES ('136','136') ; 
INSERT INTO `origin` VALUES ('137','137') ; 

INSERT INTO `destination` VALUES ('1','1') ; 
INSERT INTO `destination` VALUES ('2','2') ; 
INSERT INTO `destination` VALUES ('3','3') ; 
INSERT INTO `destination` VALUES ('4','4') ; 
INSERT INTO `destination` VALUES ('5','5') ; 
INSERT INTO `destination` VALUES ('6','6') ; 
INSERT INTO `destination` VALUES ('7','7') ; 
INSERT INTO `destination` VALUES ('8','8') ; 
INSERT INTO `destination` VALUES ('9','9') ; 
INSERT INTO `destination` VALUES ('10','10') ; 
INSERT INTO `destination` VALUES ('11','11') ; 
INSERT INTO `destination` VALUES ('12','12') ; 
INSERT INTO `destination` VALUES ('13','13') ; 
INSERT INTO `destination` VALUES ('14','14') ; 
INSERT INTO `destination` VALUES ('15','15') ; 
INSERT INTO `destination` VALUES ('16','16') ; 
INSERT INTO `destination` VALUES ('17','17') ; 
INSERT INTO `destination` VALUES ('18','18') ; 
INSERT INTO `destination` VALUES ('19','19') ; 
INSERT INTO `destination` VALUES ('20','20') ; 
INSERT INTO `destination` VALUES ('21','21') ; 
INSERT INTO `destination` VALUES ('22','22') ; 
INSERT INTO `destination` VALUES ('23','23') ; 
INSERT INTO `destination` VALUES ('24','24') ; 
INSERT INTO `destination` VALUES ('25','25') ; 
INSERT INTO `destination` VALUES ('26','26') ; 
INSERT INTO `destination` VALUES ('27','27') ; 
INSERT INTO `destination` VALUES ('28','28') ; 
INSERT INTO `destination` VALUES ('29','29') ; 
INSERT INTO `destination` VALUES ('30','30') ; 
INSERT INTO `destination` VALUES ('31','31') ; 
INSERT INTO `destination` VALUES ('32','32') ; 
INSERT INTO `destination` VALUES ('33','33') ; 
INSERT INTO `destination` VALUES ('34','34') ; 
INSERT INTO `destination` VALUES ('35','35') ; 
INSERT INTO `destination` VALUES ('36','36') ; 
INSERT INTO `destination` VALUES ('37','37') ; 
INSERT INTO `destination` VALUES ('38','38') ; 
INSERT INTO `destination` VALUES ('39','39') ; 
INSERT INTO `destination` VALUES ('40','40') ; 
INSERT INTO `destination` VALUES ('41','41') ; 
INSERT INTO `destination` VALUES ('42','42') ; 
INSERT INTO `destination` VALUES ('43','43') ; 
INSERT INTO `destination` VALUES ('44','44') ; 
INSERT INTO `destination` VALUES ('45','45') ; 
INSERT INTO `destination` VALUES ('46','46') ; 
INSERT INTO `destination` VALUES ('47','47') ; 
INSERT INTO `destination` VALUES ('48','48') ; 
INSERT INTO `destination` VALUES ('49','49') ; 
INSERT INTO `destination` VALUES ('50','50') ; 
INSERT INTO `destination` VALUES ('51','51') ; 
INSERT INTO `destination` VALUES ('52','52') ; 
INSERT INTO `destination` VALUES ('53','53') ; 
INSERT INTO `destination` VALUES ('54','54') ; 
INSERT INTO `destination` VALUES ('55','55') ; 
INSERT INTO `destination` VALUES ('56','56') ; 
INSERT INTO `destination` VALUES ('57','57') ; 
INSERT INTO `destination` VALUES ('58','58') ; 
INSERT INTO `destination` VALUES ('59','59') ; 
INSERT INTO `destination` VALUES ('60','60') ; 
INSERT INTO `destination` VALUES ('61','61') ; 
INSERT INTO `destination` VALUES ('62','62') ; 
INSERT INTO `destination` VALUES ('63','63') ; 
INSERT INTO `destination` VALUES ('64','64') ; 
INSERT INTO `destination` VALUES ('65','65') ; 
INSERT INTO `destination` VALUES ('66','66') ; 
INSERT INTO `destination` VALUES ('67','67') ; 
INSERT INTO `destination` VALUES ('68','68') ; 
INSERT INTO `destination` VALUES ('69','69') ; 
INSERT INTO `destination` VALUES ('70','70') ; 
INSERT INTO `destination` VALUES ('71','71') ; 
INSERT INTO `destination` VALUES ('72','72') ; 
INSERT INTO `destination` VALUES ('73','73') ; 
INSERT INTO `destination` VALUES ('74','74') ; 
INSERT INTO `destination` VALUES ('75','75') ; 
INSERT INTO `destination` VALUES ('76','76') ; 
INSERT INTO `destination` VALUES ('77','77') ; 
INSERT INTO `destination` VALUES ('78','78') ; 
INSERT INTO `destination` VALUES ('79','79') ; 
INSERT INTO `destination` VALUES ('80','80') ; 
INSERT INTO `destination` VALUES ('81','81') ; 
INSERT INTO `destination` VALUES ('82','82') ; 
INSERT INTO `destination` VALUES ('83','83') ; 
INSERT INTO `destination` VALUES ('84','84') ; 
INSERT INTO `destination` VALUES ('85','85') ; 
INSERT INTO `destination` VALUES ('86','86') ; 
INSERT INTO `destination` VALUES ('87','87') ; 
INSERT INTO `destination` VALUES ('88','88') ; 
INSERT INTO `destination` VALUES ('89','89') ; 
INSERT INTO `destination` VALUES ('90','90') ; 
INSERT INTO `destination` VALUES ('91','91') ; 
INSERT INTO `destination` VALUES ('92','92') ; 
INSERT INTO `destination` VALUES ('93','93') ; 
INSERT INTO `destination` VALUES ('94','94') ; 
INSERT INTO `destination` VALUES ('95','95') ; 
INSERT INTO `destination` VALUES ('96','96') ; 
INSERT INTO `destination` VALUES ('97','97') ; 
INSERT INTO `destination` VALUES ('98','98') ; 
INSERT INTO `destination` VALUES ('99','99') ; 
INSERT INTO `destination` VALUES ('100','100') ; 
INSERT INTO `destination` VALUES ('101','101') ; 
INSERT INTO `destination` VALUES ('102','102') ; 
INSERT INTO `destination` VALUES ('103','103') ; 
INSERT INTO `destination` VALUES ('104','104') ; 
INSERT INTO `destination` VALUES ('105','105') ; 
INSERT INTO `destination` VALUES ('106','106') ; 
INSERT INTO `destination` VALUES ('107','107') ; 
INSERT INTO `destination` VALUES ('108','108') ; 
INSERT INTO `destination` VALUES ('109','109') ; 
INSERT INTO `destination` VALUES ('110','110') ; 
INSERT INTO `destination` VALUES ('111','111') ; 
INSERT INTO `destination` VALUES ('112','112') ; 
INSERT INTO `destination` VALUES ('113','113') ; 
INSERT INTO `destination` VALUES ('114','114') ; 
INSERT INTO `destination` VALUES ('115','115') ; 
INSERT INTO `destination` VALUES ('116','116') ; 
INSERT INTO `destination` VALUES ('117','117') ; 
INSERT INTO `destination` VALUES ('118','118') ; 
INSERT INTO `destination` VALUES ('119','119') ; 
INSERT INTO `destination` VALUES ('120','120') ; 
INSERT INTO `destination` VALUES ('121','121') ; 
INSERT INTO `destination` VALUES ('122','122') ; 
INSERT INTO `destination` VALUES ('123','123') ; 
INSERT INTO `destination` VALUES ('124','124') ; 
INSERT INTO `destination` VALUES ('125','125') ; 
INSERT INTO `destination` VALUES ('126','126') ; 
INSERT INTO `destination` VALUES ('127','127') ; 
INSERT INTO `destination` VALUES ('128','128') ; 
INSERT INTO `destination` VALUES ('129','129') ; 
INSERT INTO `destination` VALUES ('130','130') ; 
INSERT INTO `destination` VALUES ('131','131') ; 
INSERT INTO `destination` VALUES ('132','132') ; 
INSERT INTO `destination` VALUES ('133','133') ; 
INSERT INTO `destination` VALUES ('134','134') ; 
INSERT INTO `destination` VALUES ('135','135') ; 
INSERT INTO `destination` VALUES ('136','136') ; 
INSERT INTO `destination` VALUES ('137','137') ; 

INSERT INTO `airlines` VALUES ('1','9E','Endeavor Air Inc.') ; 
INSERT INTO `airlines` VALUES ('2','AA','American Airlines Inc.') ; 
INSERT INTO `airlines` VALUES ('3','AS','Alaska Airlines Inc.') ; 
INSERT INTO `airlines` VALUES ('4','B6','JetBlue Airways') ; 
INSERT INTO `airlines` VALUES ('5','DL','Delta Air Lines Inc.') ; 
INSERT INTO `airlines` VALUES ('6','EV','ExpressJet Airlines Inc.') ; 
INSERT INTO `airlines` VALUES ('7','F9','Frontier Airlines Inc.') ; 
INSERT INTO `airlines` VALUES ('8','FL','AirTran Airways Corporation') ; 
INSERT INTO `airlines` VALUES ('9','HA','Hawaiian Airlines Inc.') ; 
INSERT INTO `airlines` VALUES ('10','MQ','Envoy Air') ; 
INSERT INTO `airlines` VALUES ('11','OO','SkyWest Airlines Inc.') ; 
INSERT INTO `airlines` VALUES ('12','UA','United Air Lines Inc.') ; 
INSERT INTO `airlines` VALUES ('13','US','US Airways Inc.') ; 
INSERT INTO `airlines` VALUES ('14','VX','Virgin America') ; 
INSERT INTO `airlines` VALUES ('15','WN','Southwest Airlines Co.') ; 
INSERT INTO `airlines` VALUES ('16','YV','Mesa Airlines Inc.') ; 

INSERT INTO `aircraft` VALUES ('1','AIRBUS','A320-214','2010','N127UW','182','13') ; 
INSERT INTO `aircraft` VALUES ('2','AIRBUS','A320-214','2010','N128UW','182','11') ; 
INSERT INTO `aircraft` VALUES ('3','AIRBUS','A320-214','2010','N205FR','182','5') ; 
INSERT INTO `aircraft` VALUES ('4','AIRBUS','A320-214','2010','N206FR','182','2') ; 
INSERT INTO `aircraft` VALUES ('5','AIRBUS','A320-214','2010','N207FR','182','3') ; 
INSERT INTO `aircraft` VALUES ('6','AIRBUS','A330-243','2010','N380HA','377','16') ; 
INSERT INTO `aircraft` VALUES ('7','AIRBUS','A330-243','2010','N381HA','377','3') ; 
INSERT INTO `aircraft` VALUES ('8','AIRBUS','A330-243','2010','N382HA','377','15') ; 
INSERT INTO `aircraft` VALUES ('9','AIRBUS','A320-214','2010','N835VA','182','6') ; 
INSERT INTO `aircraft` VALUES ('10','AIRBUS','A320-214','2010','N836VA','182','15') ; 
INSERT INTO `aircraft` VALUES ('11','AIRBUS','A319-112','2010','N952FR','100','15') ; 
INSERT INTO `aircraft` VALUES ('12','AIRBUS','A319-112','2010','N953FR','100','3') ; 
INSERT INTO `aircraft` VALUES ('13','AIRBUS','A320-214','2011','N208FR','182','5') ; 
INSERT INTO `aircraft` VALUES ('14','AIRBUS','A320-214','2011','N209FR','182','1') ; 
INSERT INTO `aircraft` VALUES ('15','AIRBUS','A320-214','2011','N210FR','182','4') ; 
INSERT INTO `aircraft` VALUES ('16','AIRBUS','A320-214','2011','N211FR','182','9') ; 
INSERT INTO `aircraft` VALUES ('17','AIRBUS','A320-214','2011','N213FR','182','14') ; 
INSERT INTO `aircraft` VALUES ('18','AIRBUS','A320-214','2011','N214FR','182','12') ; 
INSERT INTO `aircraft` VALUES ('19','AIRBUS','A320-214','2011','N216FR','182','4') ; 
INSERT INTO `aircraft` VALUES ('20','AIRBUS','A330-243','2011','N383HA','377','8') ; 
INSERT INTO `aircraft` VALUES ('21','AIRBUS','A330-243','2011','N384HA','377','10') ; 
INSERT INTO `aircraft` VALUES ('22','AIRBUS','A321-231','2011','N543UW','379','15') ; 
INSERT INTO `aircraft` VALUES ('23','AIRBUS','A321-231','2011','N544UW','379','4') ; 
INSERT INTO `aircraft` VALUES ('24','AIRBUS','A321-231','2011','N545UW','379','6') ; 
INSERT INTO `aircraft` VALUES ('25','AIRBUS','A321-231','2011','N546UW','379','2') ; 
INSERT INTO `aircraft` VALUES ('26','AIRBUS','A321-231','2011','N547UW','379','16') ; 
INSERT INTO `aircraft` VALUES ('27','AIRBUS','A321-231','2011','N548UW','379','15') ; 
INSERT INTO `aircraft` VALUES ('28','AIRBUS','A321-231','2011','N549UW','379','13') ; 
INSERT INTO `aircraft` VALUES ('29','AIRBUS','A321-231','2011','N550UW','379','15') ; 
INSERT INTO `aircraft` VALUES ('30','AIRBUS','A321-231','2011','N551UW','379','13') ; 
INSERT INTO `aircraft` VALUES ('31','AIRBUS','A321-231','2011','N552UW','379','4') ; 
INSERT INTO `aircraft` VALUES ('32','AIRBUS','A321-231','2011','N553UW','379','11') ; 
INSERT INTO `aircraft` VALUES ('33','AIRBUS','A321-231','2011','N554UW','379','8') ; 
INSERT INTO `aircraft` VALUES ('34','AIRBUS','A320-232','2011','N784JB','200','4') ; 
INSERT INTO `aircraft` VALUES ('35','AIRBUS','A320-232','2011','N789JB','200','1') ; 
INSERT INTO `aircraft` VALUES ('36','AIRBUS','A320-232','2011','N793JB','200','8') ; 
INSERT INTO `aircraft` VALUES ('37','AIRBUS','A320-232','2011','N794JB','200','3') ; 
INSERT INTO `aircraft` VALUES ('38','AIRBUS','A320-214','2011','N837VA','182','3') ; 
INSERT INTO `aircraft` VALUES ('39','AIRBUS','A320-214','2011','N838VA','182','1') ; 
INSERT INTO `aircraft` VALUES ('40','AIRBUS','A320-214','2011','N839VA','182','3') ; 
INSERT INTO `aircraft` VALUES ('41','AIRBUS','A320-214','2011','N840VA','182','16') ; 
INSERT INTO `aircraft` VALUES ('42','AIRBUS','A320-214','2011','N842VA','182','1') ; 
INSERT INTO `aircraft` VALUES ('43','AIRBUS','A320-214','2011','N843VA','182','14') ; 
INSERT INTO `aircraft` VALUES ('44','AIRBUS','A320-214','2011','N844VA','182','2') ; 
INSERT INTO `aircraft` VALUES ('45','AIRBUS','A320-214','2011','N845VA','182','6') ; 
INSERT INTO `aircraft` VALUES ('46','AIRBUS','A320-214','2011','N846VA','182','7') ; 
INSERT INTO `aircraft` VALUES ('47','AIRBUS','A320-214','2011','N847VA','182','12') ; 
INSERT INTO `aircraft` VALUES ('48','AIRBUS','A320-214','2011','N848VA','182','10') ; 
INSERT INTO `aircraft` VALUES ('49','AIRBUS','A330-243','2012','N385HA','377','6') ; 
INSERT INTO `aircraft` VALUES ('50','AIRBUS','A330-243','2012','N386HA','377','11') ; 
INSERT INTO `aircraft` VALUES ('51','AIRBUS','A330-243','2012','N388HA','377','2') ; 
INSERT INTO `aircraft` VALUES ('52','AIRBUS','A321-231','2012','N555AY','379','14') ; 
INSERT INTO `aircraft` VALUES ('53','AIRBUS','A321-231','2012','N556UW','379','15') ; 
INSERT INTO `aircraft` VALUES ('54','AIRBUS','A321-231','2012','N557UW','379','2') ; 
INSERT INTO `aircraft` VALUES ('55','AIRBUS','A321-231','2012','N558UW','379','9') ; 
INSERT INTO `aircraft` VALUES ('56','AIRBUS','A321-231','2012','N559UW','379','16') ; 
INSERT INTO `aircraft` VALUES ('57','AIRBUS','A321-231','2012','N560UW','379','1') ; 
INSERT INTO `aircraft` VALUES ('58','AIRBUS','A321-231','2012','N561UW','379','1') ; 
INSERT INTO `aircraft` VALUES ('59','AIRBUS','A321-231','2012','N562UW','379','8') ; 
INSERT INTO `aircraft` VALUES ('60','AIRBUS','A321-231','2012','N563UW','379','11') ; 
INSERT INTO `aircraft` VALUES ('61','AIRBUS','A321-231','2012','N564UW','379','3') ; 
INSERT INTO `aircraft` VALUES ('62','AIRBUS','A321-231','2012','N565UW','379','7') ; 
INSERT INTO `aircraft` VALUES ('63','AIRBUS','A321-231','2012','N566UW','379','6') ; 
INSERT INTO `aircraft` VALUES ('64','AIRBUS','A320-232','2012','N796JB','200','7') ; 
INSERT INTO `aircraft` VALUES ('65','AIRBUS','A320-232','2012','N804JB','200','9') ; 
INSERT INTO `aircraft` VALUES ('66','AIRBUS','A320-232','2012','N805JB','200','12') ; 
INSERT INTO `aircraft` VALUES ('67','AIRBUS','A320-232','2012','N806JB','200','10') ; 
INSERT INTO `aircraft` VALUES ('68','AIRBUS','A320-232','2012','N807JB','200','8') ; 
INSERT INTO `aircraft` VALUES ('69','AIRBUS','A320-232','2012','N809JB','200','2') ; 
INSERT INTO `aircraft` VALUES ('70','AIRBUS','A320-232','2012','N821JB','200','2') ; 
INSERT INTO `aircraft` VALUES ('71','AIRBUS','A320-214','2012','N849VA','182','6') ; 
INSERT INTO `aircraft` VALUES ('72','AIRBUS','A320-214','2012','N851VA','182','16') ; 
INSERT INTO `aircraft` VALUES ('73','AIRBUS','A320-214','2012','N852VA','182','16') ; 
INSERT INTO `aircraft` VALUES ('74','AIRBUS','A320-214','2012','N853VA','182','14') ; 
INSERT INTO `aircraft` VALUES ('75','AIRBUS','A320-214','2012','N854VA','182','4') ; 
INSERT INTO `aircraft` VALUES ('76','AIRBUS','A320-214','2012','N855VA','182','3') ; 
INSERT INTO `aircraft` VALUES ('77','AIRBUS','A321-211','2013','N150UW','199','10') ; 
INSERT INTO `aircraft` VALUES ('78','AIRBUS','A321-211','2013','N151UW','199','3') ; 
INSERT INTO `aircraft` VALUES ('79','AIRBUS','A321-211','2013','N152UW','199','3') ; 
INSERT INTO `aircraft` VALUES ('80','AIRBUS','A321-211','2013','N153UW','199','5') ; 
INSERT INTO `aircraft` VALUES ('81','AIRBUS','A321-211','2013','N154UW','199','5') ; 
INSERT INTO `aircraft` VALUES ('82','AIRBUS','A321-211','2013','N155UW','199','16') ; 
INSERT INTO `aircraft` VALUES ('83','AIRBUS','A321-211','2013','N156UW','199','3') ; 
INSERT INTO `aircraft` VALUES ('84','AIRBUS','A321-211','2013','N157UW','199','6') ; 
INSERT INTO `aircraft` VALUES ('85','AIRBUS','A321-211','2013','N198UW','199','5') ; 
INSERT INTO `aircraft` VALUES ('86','AIRBUS','A321-211','2013','N199UW','199','5') ; 
INSERT INTO `aircraft` VALUES ('87','AIRBUS','A320-214','2013','N361VA','182','15') ; 
INSERT INTO `aircraft` VALUES ('88','AIRBUS','A330-243','2013','N390HA','377','3') ; 
INSERT INTO `aircraft` VALUES ('89','AIRBUS','A330-243','2013','N391HA','377','4') ; 
INSERT INTO `aircraft` VALUES ('90','AIRBUS','A330-243','2013','N392HA','377','16') ; 
INSERT INTO `aircraft` VALUES ('91','AIRBUS','A330-243','2013','N393HA','377','2') ; 
INSERT INTO `aircraft` VALUES ('92','AIRBUS','A330-243','2013','N395HA','377','3') ; 
INSERT INTO `aircraft` VALUES ('93','AIRBUS','A321-231','2013','N567UW','379','12') ; 
INSERT INTO `aircraft` VALUES ('94','AIRBUS','A321-231','2013','N568UW','379','11') ; 
INSERT INTO `aircraft` VALUES ('95','AIRBUS','A321-231','2013','N569UW','379','13') ; 
INSERT INTO `aircraft` VALUES ('96','AIRBUS','A321-231','2013','N570UW','379','10') ; 
INSERT INTO `aircraft` VALUES ('97','AIRBUS','A321-231','2013','N571UW','379','6') ; 
INSERT INTO `aircraft` VALUES ('98','AIRBUS','A320-232','2013','N827JB','200','3') ; 
INSERT INTO `aircraft` VALUES ('99','AIRBUS','A320-232','2013','N828JB','200','15') ; 
INSERT INTO `aircraft` VALUES ('100','AIRBUS','A320-232','2013','N834JB','200','11') ; 
INSERT INTO `aircraft` VALUES ('101','AIRBUS','A321-231','2013','N903JB','379','16') ; 
INSERT INTO `aircraft` VALUES ('102','AIRBUS','A321-231','2013','N913JB','379','13') ; 
INSERT INTO `aircraft` VALUES ('103','BOEING','737-924ER','2010','N36444','191','1') ; 
INSERT INTO `aircraft` VALUES ('104','BOEING','737-832','2010','N3772H','189','9') ; 
INSERT INTO `aircraft` VALUES ('105','BOEING','737-832','2010','N3773D','189','13') ; 
INSERT INTO `aircraft` VALUES ('106','BOEING','737-924ER','2010','N38443','191','11') ; 
INSERT INTO `aircraft` VALUES ('107','BOEING','737-890','2010','N529AS','149','6') ; 
INSERT INTO `aircraft` VALUES ('108','BOEING','737-890','2010','N530AS','149','10') ; 
INSERT INTO `aircraft` VALUES ('109','BOEING','737-890','2010','N531AS','149','16') ; 
INSERT INTO `aircraft` VALUES ('110','BOEING','737-890','2010','N532AS','149','3') ; 
INSERT INTO `aircraft` VALUES ('111','BOEING','737-824','2010','N76522','149','10') ; 
INSERT INTO `aircraft` VALUES ('112','BOEING','737-824','2010','N76523','149','16') ; 
INSERT INTO `aircraft` VALUES ('113','BOEING','737-824','2010','N76526','149','9') ; 
INSERT INTO `aircraft` VALUES ('114','BOEING','737-824','2010','N76528','149','12') ; 
INSERT INTO `aircraft` VALUES ('115','BOEING','737-824','2010','N76529','149','2') ; 
INSERT INTO `aircraft` VALUES ('116','BOEING','737-824','2010','N77520','149','11') ; 
INSERT INTO `aircraft` VALUES ('117','BOEING','737-824','2010','N77525','149','10') ; 
INSERT INTO `aircraft` VALUES ('118','BOEING','737-824','2010','N78524','149','2') ; 
INSERT INTO `aircraft` VALUES ('119','BOEING','737-824','2010','N79521','149','11') ; 
INSERT INTO `aircraft` VALUES ('120','BOEING','737-824','2010','N87527','149','14') ; 
INSERT INTO `aircraft` VALUES ('121','BOEING','737-7H4','2010','N943WN','140','12') ; 
INSERT INTO `aircraft` VALUES ('122','BOEING','737-7H4','2010','N944WN','140','6') ; 
INSERT INTO `aircraft` VALUES ('123','BOEING','737-7H4','2010','N945WN','140','1') ; 
INSERT INTO `aircraft` VALUES ('124','BOEING','737-7H4','2010','N946WN','140','2') ; 
INSERT INTO `aircraft` VALUES ('125','BOEING','737-7H4','2010','N947WN','140','7') ; 
INSERT INTO `aircraft` VALUES ('126','BOEING','737-7H4','2010','N948WN','140','4') ; 
INSERT INTO `aircraft` VALUES ('127','BOEING','737-7H4','2010','N949WN','140','7') ; 
INSERT INTO `aircraft` VALUES ('128','BOEING','737-7H4','2010','N950WN','140','8') ; 
INSERT INTO `aircraft` VALUES ('129','BOEING','737-7H4','2010','N951WN','140','15') ; 
INSERT INTO `aircraft` VALUES ('130','BOEING','737-7H4','2010','N952WN','140','10') ; 
INSERT INTO `aircraft` VALUES ('131','BOEING','737-7H4','2010','N953WN','140','12') ; 
INSERT INTO `aircraft` VALUES ('132','BOEING','737-890','2011','N533AS','149','14') ; 
INSERT INTO `aircraft` VALUES ('133','BOEING','737-890','2011','N534AS','149','10') ; 
INSERT INTO `aircraft` VALUES ('134','BOEING','737-890','2011','N535AS','149','9') ; 
INSERT INTO `aircraft` VALUES ('135','BOEING','737-7BD','2011','N555LV','149','4') ; 
INSERT INTO `aircraft` VALUES ('136','BOEING','737-7BD','2011','N556WN','149','14') ; 
INSERT INTO `aircraft` VALUES ('137','BOEING','737-924ER','2011','N73445','191','12') ; 
INSERT INTO `aircraft` VALUES ('138','BOEING','737-824','2011','N77530','149','7') ; 
INSERT INTO `aircraft` VALUES ('139','BOEING','737-824','2011','N87531','149','14') ; 
INSERT INTO `aircraft` VALUES ('140','BOEING','737-7H4','2011','N954WN','140','9') ; 
INSERT INTO `aircraft` VALUES ('141','BOEING','737-7H4','2011','N955WN','140','2') ; 
INSERT INTO `aircraft` VALUES ('142','BOEING','737-7H4','2011','N956WN','140','8') ; 
INSERT INTO `aircraft` VALUES ('143','BOEING','737-7H4','2011','N957WN','140','7') ; 
INSERT INTO `aircraft` VALUES ('144','BOEING','737-7H4','2011','N958WN','140','12') ; 
INSERT INTO `aircraft` VALUES ('145','BOEING','737-7H4','2011','N959WN','140','3') ; 
INSERT INTO `aircraft` VALUES ('146','BOEING','737-7H4','2011','N960WN','140','5') ; 
INSERT INTO `aircraft` VALUES ('147','BOEING','737-7H4','2011','N961WN','140','10') ; 
INSERT INTO `aircraft` VALUES ('148','BOEING','737-7H4','2011','N962WN','140','11') ; 
INSERT INTO `aircraft` VALUES ('149','BOEING','737-7H4','2011','N963WN','140','13') ; 
INSERT INTO `aircraft` VALUES ('150','BOEING','737-7H4','2011','N964WN','140','8') ; 
INSERT INTO `aircraft` VALUES ('151','BOEING','737-7H4','2011','N965WN','140','4') ; 
INSERT INTO `aircraft` VALUES ('152','BOEING','737-7H4','2011','N966WN','140','10') ; 
INSERT INTO `aircraft` VALUES ('153','BOEING','737-7H4','2011','N967WN','140','3') ; 
INSERT INTO `aircraft` VALUES ('154','BOEING','737-7H4','2011','N968WN','140','4') ; 
INSERT INTO `aircraft` VALUES ('155','BOEING','737-7H4','2011','N969WN','140','7') ; 
INSERT INTO `aircraft` VALUES ('156','BOEING','787-8','2012','N20904','260','1') ; 
INSERT INTO `aircraft` VALUES ('157','BOEING','787-8','2012','N26906','260','2') ; 
INSERT INTO `aircraft` VALUES ('158','BOEING','787-8','2012','N27901','260','8') ; 
INSERT INTO `aircraft` VALUES ('159','BOEING','737-924ER','2012','N28457','191','8') ; 
INSERT INTO `aircraft` VALUES ('160','BOEING','737-924ER','2012','N34455','191','3') ; 
INSERT INTO `aircraft` VALUES ('161','BOEING','737-924ER','2012','N34460','191','16') ; 
INSERT INTO `aircraft` VALUES ('162','BOEING','737-924ER','2012','N36447','191','14') ; 
INSERT INTO `aircraft` VALUES ('163','BOEING','737-924ER','2012','N37456','191','14') ; 
INSERT INTO `aircraft` VALUES ('164','BOEING','737-924ER','2012','N37462','191','11') ; 
INSERT INTO `aircraft` VALUES ('165','BOEING','737-924ER','2012','N37464','191','8') ; 
INSERT INTO `aircraft` VALUES ('166','BOEING','737-924ER','2012','N38446','191','8') ; 
INSERT INTO `aircraft` VALUES ('167','BOEING','737-924ER','2012','N38451','191','8') ; 
INSERT INTO `aircraft` VALUES ('168','BOEING','737-924ER','2012','N38454','191','11') ; 
INSERT INTO `aircraft` VALUES ('169','BOEING','737-924ER','2012','N38458','191','12') ; 
INSERT INTO `aircraft` VALUES ('170','BOEING','737-924ER','2012','N38459','191','10') ; 
INSERT INTO `aircraft` VALUES ('171','BOEING','737-924ER','2012','N39450','191','11') ; 
INSERT INTO `aircraft` VALUES ('172','BOEING','737-924ER','2012','N39461','191','16') ; 
INSERT INTO `aircraft` VALUES ('173','BOEING','737-924ER','2012','N39463','191','2') ; 
INSERT INTO `aircraft` VALUES ('174','BOEING','737-990ER','2012','N402AS','222','9') ; 
INSERT INTO `aircraft` VALUES ('175','BOEING','737-990ER','2012','N403AS','222','5') ; 
INSERT INTO `aircraft` VALUES ('176','BOEING','737-990ER','2012','N407AS','222','16') ; 
INSERT INTO `aircraft` VALUES ('177','BOEING','737-990ER','2012','N408AS','222','5') ; 
INSERT INTO `aircraft` VALUES ('178','BOEING','787-8','2012','N45905','260','9') ; 
INSERT INTO `aircraft` VALUES ('179','BOEING','737-890','2012','N536AS','149','5') ; 
INSERT INTO `aircraft` VALUES ('180','BOEING','737-890','2012','N537AS','149','3') ; 
INSERT INTO `aircraft` VALUES ('181','BOEING','737-890','2012','N538AS','149','6') ; 
INSERT INTO `aircraft` VALUES ('182','BOEING','737-924ER','2012','N68452','191','1') ; 
INSERT INTO `aircraft` VALUES ('183','BOEING','737-924ER','2012','N68453','191','4') ; 
INSERT INTO `aircraft` VALUES ('184','BOEING','737-924ER','2012','N78448','191','13') ; 
INSERT INTO `aircraft` VALUES ('185','BOEING','737-924ER','2012','N81449','191','11') ; 
INSERT INTO `aircraft` VALUES ('186','BOEING','737-8H4','2012','N8301J','140','12') ; 
INSERT INTO `aircraft` VALUES ('187','BOEING','737-8H4','2012','N8302F','140','7') ; 
INSERT INTO `aircraft` VALUES ('188','BOEING','737-8H4','2012','N8305E','140','9') ; 
INSERT INTO `aircraft` VALUES ('189','BOEING','737-8H4','2012','N8306H','140','4') ; 
INSERT INTO `aircraft` VALUES ('190','BOEING','737-8H4','2012','N8307K','140','14') ; 
INSERT INTO `aircraft` VALUES ('191','BOEING','737-8H4','2012','N8308K','140','4') ; 
INSERT INTO `aircraft` VALUES ('192','BOEING','737-8H4','2012','N8309C','140','4') ; 
INSERT INTO `aircraft` VALUES ('193','BOEING','737-8H4','2012','N8310C','140','16') ; 
INSERT INTO `aircraft` VALUES ('194','BOEING','737-8H4','2012','N8311Q','140','1') ; 
INSERT INTO `aircraft` VALUES ('195','BOEING','737-8H4','2012','N8312C','140','10') ; 
INSERT INTO `aircraft` VALUES ('196','BOEING','737-8H4','2012','N8313F','140','3') ; 
INSERT INTO `aircraft` VALUES ('197','BOEING','737-8H4','2012','N8314L','140','12') ; 
INSERT INTO `aircraft` VALUES ('198','BOEING','737-8H4','2012','N8315C','140','10') ; 
INSERT INTO `aircraft` VALUES ('199','BOEING','737-8H4','2012','N8316H','140','1') ; 
INSERT INTO `aircraft` VALUES ('200','BOEING','737-8H4','2012','N8317M','140','1') ; 
INSERT INTO `aircraft` VALUES ('201','BOEING','737-8H4','2012','N8318F','140','9') ; 
INSERT INTO `aircraft` VALUES ('202','BOEING','737-8H4','2012','N8319F','140','16') ; 
INSERT INTO `aircraft` VALUES ('203','BOEING','737-8H4','2012','N8320J','140','4') ; 
INSERT INTO `aircraft` VALUES ('204','BOEING','737-8H4','2012','N8321D','140','4') ; 
INSERT INTO `aircraft` VALUES ('205','BOEING','737-8H4','2012','N8322X','140','15') ; 
INSERT INTO `aircraft` VALUES ('206','BOEING','737-8H4','2012','N8323C','140','15') ; 
INSERT INTO `aircraft` VALUES ('207','BOEING','737-8H4','2012','N8324A','140','7') ; 
INSERT INTO `aircraft` VALUES ('208','BOEING','737-8H4','2012','N8325D','140','5') ; 
INSERT INTO `aircraft` VALUES ('209','BOEING','737-8H4','2012','N8326F','140','9') ; 
INSERT INTO `aircraft` VALUES ('210','BOEING','737-8H4','2012','N8327A','140','1') ; 
INSERT INTO `aircraft` VALUES ('211','BOEING','737-8H4','2012','N8328A','140','10') ; 
INSERT INTO `aircraft` VALUES ('212','BOEING','737-8H4','2012','N8329B','140','5') ; 
INSERT INTO `aircraft` VALUES ('213','BOEING','737-8H4','2012','N8600F','140','5') ; 
INSERT INTO `aircraft` VALUES ('214','BOEING','737-8H4','2012','N8601C','140','7') ; 
INSERT INTO `aircraft` VALUES ('215','BOEING','737-8H4','2012','N8602F','140','3') ; 
INSERT INTO `aircraft` VALUES ('216','BOEING','737-8H4','2012','N8603F','140','1') ; 
INSERT INTO `aircraft` VALUES ('217','BOEING','737-8H4','2012','N8604K','140','15') ; 
INSERT INTO `aircraft` VALUES ('218','BOEING','737-8H4','2012','N8605E','140','14') ; 
INSERT INTO `aircraft` VALUES ('219','BOEING','737-924ER','2013','N27477','191','16') ; 
INSERT INTO `aircraft` VALUES ('220','BOEING','737-924ER','2013','N28478','191','8') ; 
INSERT INTO `aircraft` VALUES ('221','BOEING','737-924ER','2013','N36469','191','7') ; 
INSERT INTO `aircraft` VALUES ('222','BOEING','737-924ER','2013','N36472','191','11') ; 
INSERT INTO `aircraft` VALUES ('223','BOEING','737-924ER','2013','N36476','191','2') ; 
INSERT INTO `aircraft` VALUES ('224','BOEING','737-924ER','2013','N37465','191','2') ; 
INSERT INTO `aircraft` VALUES ('225','BOEING','737-924ER','2013','N37466','191','15') ; 
INSERT INTO `aircraft` VALUES ('226','BOEING','737-924ER','2013','N37468','191','10') ; 
INSERT INTO `aircraft` VALUES ('227','BOEING','737-924ER','2013','N37470','191','9') ; 
INSERT INTO `aircraft` VALUES ('228','BOEING','737-924ER','2013','N37471','191','6') ; 
INSERT INTO `aircraft` VALUES ('229','BOEING','737-924ER','2013','N37474','191','10') ; 
INSERT INTO `aircraft` VALUES ('230','BOEING','737-924ER','2013','N38467','191','1') ; 
INSERT INTO `aircraft` VALUES ('231','BOEING','737-924ER','2013','N38473','191','9') ; 
INSERT INTO `aircraft` VALUES ('232','BOEING','737-924ER','2013','N39475','191','9') ; 
INSERT INTO `aircraft` VALUES ('233','BOEING','737-990ER','2013','N409AS','222','7') ; 
INSERT INTO `aircraft` VALUES ('234','BOEING','737-990ER','2013','N413AS','222','8') ; 
INSERT INTO `aircraft` VALUES ('235','BOEING','737-990ER','2013','N419AS','222','4') ; 
INSERT INTO `aircraft` VALUES ('236','BOEING','737-990ER','2013','N423AS','222','9') ; 
INSERT INTO `aircraft` VALUES ('237','BOEING','737-990ER','2013','N431AS','222','11') ; 
INSERT INTO `aircraft` VALUES ('238','BOEING','737-990ER','2013','N433AS','222','2') ; 
INSERT INTO `aircraft` VALUES ('239','BOEING','737-990ER','2013','N435AS','222','7') ; 
INSERT INTO `aircraft` VALUES ('240','BOEING','737-990ER','2013','N440AS','222','7') ; 
INSERT INTO `aircraft` VALUES ('241','BOEING','737-990ER','2013','N442AS','222','8') ; 
INSERT INTO `aircraft` VALUES ('242','BOEING','737-924ER','2013','N64809','191','11') ; 
INSERT INTO `aircraft` VALUES ('243','BOEING','737-924ER','2013','N66803','191','11') ; 
INSERT INTO `aircraft` VALUES ('244','BOEING','737-924ER','2013','N66808','191','4') ; 
INSERT INTO `aircraft` VALUES ('245','BOEING','737-924ER','2013','N68801','191','5') ; 
INSERT INTO `aircraft` VALUES ('246','BOEING','737-924ER','2013','N68802','191','7') ; 
INSERT INTO `aircraft` VALUES ('247','BOEING','737-924ER','2013','N68805','191','7') ; 
INSERT INTO `aircraft` VALUES ('248','BOEING','737-924ER','2013','N68807','191','13') ; 
INSERT INTO `aircraft` VALUES ('249','BOEING','737-924ER','2013','N69804','191','1') ; 
INSERT INTO `aircraft` VALUES ('250','BOEING','737-924ER','2013','N69806','191','5') ; 
INSERT INTO `aircraft` VALUES ('251','BOEING','737-8H4','2013','N8607M','140','14') ; 
INSERT INTO `aircraft` VALUES ('252','BOEING','737-8H4','2013','N8608N','140','10') ; 
INSERT INTO `aircraft` VALUES ('253','BOEING','737-8H4','2013','N8609A','140','11') ; 
INSERT INTO `aircraft` VALUES ('254','BOEING','737-8H4','2013','N8610A','140','1') ; 
INSERT INTO `aircraft` VALUES ('255','BOEING','737-8H4','2013','N8611F','140','4') ; 
INSERT INTO `aircraft` VALUES ('256','BOEING','737-8H4','2013','N8612K','140','7') ; 
INSERT INTO `aircraft` VALUES ('257','BOEING','737-8H4','2013','N8613K','140','1') ; 
INSERT INTO `aircraft` VALUES ('258','BOEING','737-8H4','2013','N8614M','140','1') ; 
INSERT INTO `aircraft` VALUES ('259','BOEING','737-8H4','2013','N8615E','140','1') ; 
INSERT INTO `aircraft` VALUES ('260','BOEING','737-8H4','2013','N8616C','140','8') ; 
INSERT INTO `aircraft` VALUES ('261','BOEING','737-8H4','2013','N8617E','140','4') ; 
INSERT INTO `aircraft` VALUES ('262','BOEING','737-8H4','2013','N8618N','140','6') ; 
INSERT INTO `aircraft` VALUES ('263','BOEING','737-8H4','2013','N8619F','140','4') ; 
INSERT INTO `aircraft` VALUES ('264','BOEING','737-8H4','2013','N8620H','140','11') ; 
INSERT INTO `aircraft` VALUES ('265','BOEING','737-8H4','2013','N8621A','140','6') ; 

INSERT INTO `flight` VALUES ('1','2018-12-01 12:00:45','397','2208','434.84','177','67','26') ; 
INSERT INTO `flight` VALUES ('2','2018-12-01 21:31:08','445','2472','247.38','11','118','6') ; 
INSERT INTO `flight` VALUES ('3','2018-12-01 08:20:02','156','867','113.25','46','37','38') ; 
INSERT INTO `flight` VALUES ('4','2018-12-01 04:51:00','189','1049','123.15','63','38','26') ; 
INSERT INTO `flight` VALUES ('5','2018-12-01 06:37:26','239','1327','256.49','18','116','37') ; 
INSERT INTO `flight` VALUES ('6','2018-12-01 11:27:21','393','2184','422.60','262','116','38') ; 
INSERT INTO `flight` VALUES ('7','2018-12-01 15:40:15','135','748','123.10','116','67','37') ; 
INSERT INTO `flight` VALUES ('8','2018-12-01 06:39:33','217','1203','153.79','123','67','38') ; 
INSERT INTO `flight` VALUES ('9','2018-12-01 03:47:48','435','2419','300.17','111','68','26') ; 
INSERT INTO `flight` VALUES ('10','2018-12-01 00:10:43','159','881','168.93','216','6','65') ; 
INSERT INTO `flight` VALUES ('11','2018-12-01 07:49:33','454','2523','393.09','64','65','67') ; 
INSERT INTO `flight` VALUES ('12','2018-12-01 15:02:17','354','1965','265.26','74','6','67') ; 
INSERT INTO `flight` VALUES ('13','2018-12-01 23:40:49','500','2777','459.82','5','65','68') ; 
INSERT INTO `flight` VALUES ('14','2018-12-01 10:00:57','392','2176','265.39','179','6','68') ; 
INSERT INTO `flight` VALUES ('15','2018-12-01 10:26:07','156','867','114.38','38','38','37') ; 
INSERT INTO `flight` VALUES ('16','2018-12-01 20:54:14','116','643','83.78','43','26','65') ; 
INSERT INTO `flight` VALUES ('17','2018-12-01 16:40:58','397','2208','355.35','159','26','67') ; 
INSERT INTO `flight` VALUES ('18','2018-12-01 01:28:08','435','2419','367.82','99','26','68') ; 
INSERT INTO `flight` VALUES ('19','2018-12-01 23:06:09','489','2716','486.01','25','118','26') ; 
INSERT INTO `flight` VALUES ('20','2018-12-01 08:20:53','183','1016','150.00','202','68','37') ; 
INSERT INTO `flight` VALUES ('21','2018-12-01 09:26:17','255','1415','207.45','121','68','38') ; 
INSERT INTO `flight` VALUES ('22','2018-12-01 19:25:08','320','1778','374.35','40','37','65') ; 
INSERT INTO `flight` VALUES ('23','2018-12-01 06:08:14','228','1268','152.95','15','118','37') ; 
INSERT INTO `flight` VALUES ('24','2018-12-01 22:30:42','135','748','100.68','56','37','67') ; 
INSERT INTO `flight` VALUES ('25','2018-12-01 09:01:26','308','1712','260.34','146','118','38') ; 
INSERT INTO `flight` VALUES ('26','2018-12-01 18:55:45','183','1016','139.23','23','37','68') ; 
INSERT INTO `flight` VALUES ('27','2018-12-01 01:50:52','520','2887','450.36','70','116','65') ; 
INSERT INTO `flight` VALUES ('28','2018-12-01 11:59:54','226','1253','185.72','25','116','67') ; 
INSERT INTO `flight` VALUES ('29','2018-12-01 01:18:13','454','2523','356.11','215','67','65') ; 
INSERT INTO `flight` VALUES ('30','2018-12-01 07:59:15','205','1137','184.98','29','116','68') ; 
INSERT INTO `flight` VALUES ('31','2018-12-01 21:40:21','142','789','106.51','88','65','93') ; 
INSERT INTO `flight` VALUES ('32','2018-12-01 13:04:36','129','715','115.50','198','6','93') ; 
INSERT INTO `flight` VALUES ('33','2018-12-01 07:04:14','49','271','36.18','40','67','68') ; 
INSERT INTO `flight` VALUES ('34','2018-12-01 08:33:07','378','2100','323.94','114','93','116') ; 
INSERT INTO `flight` VALUES ('35','2018-12-01 06:59:18','384','2131','374.58','166','93','118') ; 
INSERT INTO `flight` VALUES ('36','2018-12-01 00:00:55','282','1566','248.37','216','38','65') ; 
INSERT INTO `flight` VALUES ('37','2018-12-01 13:07:18','135','749','141.73','225','26','93') ; 
INSERT INTO `flight` VALUES ('38','2018-12-01 23:20:24','217','1203','203.40','118','38','67') ; 
INSERT INTO `flight` VALUES ('39','2018-12-01 19:18:40','255','1415','298.14','117','38','68') ; 
INSERT INTO `flight` VALUES ('40','2018-12-01 03:38:49','500','2777','465.58','218','68','65') ; 
INSERT INTO `flight` VALUES ('41','2018-12-01 02:29:33','49','271','40.26','114','68','67') ; 
INSERT INTO `flight` VALUES ('42','2018-12-01 01:13:35','181','1003','161.06','232','37','93') ; 
INSERT INTO `flight` VALUES ('43','2018-12-01 00:34:55','129','715','115.38','101','93','6') ; 
INSERT INTO `flight` VALUES ('44','2018-12-01 05:44:11','523','2906','362.20','51','118','65') ; 
INSERT INTO `flight` VALUES ('45','2018-12-01 04:06:18','520','2887','381.79','175','65','116') ; 
INSERT INTO `flight` VALUES ('46','2018-12-01 16:21:59','102','566','113.98','145','118','67') ; 
INSERT INTO `flight` VALUES ('47','2018-12-01 21:48:59','378','2100','197.63','41','116','93') ; 
INSERT INTO `flight` VALUES ('48','2018-12-01 13:40:23','485','2693','403.02','188','6','116') ; 
INSERT INTO `flight` VALUES ('49','2018-12-01 08:27:10','69','381','67.58','191','118','68') ; 
INSERT INTO `flight` VALUES ('50','2018-12-01 08:14:25','523','2906','520.16','208','65','118') ; 
INSERT INTO `flight` VALUES ('51','2018-12-01 18:03:59','445','2472','342.77','137','6','118') ; 
INSERT INTO `flight` VALUES ('52','2018-12-01 06:03:32','314','1747','311.48','144','67','93') ; 
INSERT INTO `flight` VALUES ('53','2018-12-01 13:49:16','513','2851','457.91','130','26','116') ; 
INSERT INTO `flight` VALUES ('54','2018-12-01 19:01:54','489','2716','334.24','10','26','118') ; 
INSERT INTO `flight` VALUES ('55','2018-12-01 04:28:56','167','929','133.05','13','38','93') ; 
INSERT INTO `flight` VALUES ('56','2018-12-01 10:41:39','363','2015','270.83','198','68','93') ; 
INSERT INTO `flight` VALUES ('57','2018-12-01 16:07:56','135','749','153.61','102','93','26') ; 
INSERT INTO `flight` VALUES ('58','2018-12-01 08:39:33','159','881','163.37','130','65','6') ; 
INSERT INTO `flight` VALUES ('59','2018-12-01 02:02:54','239','1327','244.38','222','37','116') ; 
INSERT INTO `flight` VALUES ('60','2018-12-01 07:45:51','228','1268','176.51','9','37','118') ; 
INSERT INTO `flight` VALUES ('61','2018-12-01 02:51:12','44','244','27.86','257','26','6') ; 
INSERT INTO `flight` VALUES ('62','2018-12-01 18:06:03','146','809','166.17','16','116','118') ; 
INSERT INTO `flight` VALUES ('63','2018-12-01 19:30:01','384','2131','327.87','173','118','93') ; 
INSERT INTO `flight` VALUES ('64','2018-12-01 12:43:40','226','1253','137.82','169','67','116') ; 
INSERT INTO `flight` VALUES ('65','2018-12-01 22:05:41','102','566','135.95','139','67','118') ; 
INSERT INTO `flight` VALUES ('66','2018-12-01 14:29:19','181','1003','189.49','240','93','37') ; 
INSERT INTO `flight` VALUES ('67','2018-12-01 02:00:17','167','929','110.93','183','93','38') ; 
INSERT INTO `flight` VALUES ('68','2018-12-01 03:08:30','393','2184','292.37','240','38','116') ; 
INSERT INTO `flight` VALUES ('69','2018-12-01 17:07:34','308','1712','205.46','169','38','118') ; 
INSERT INTO `flight` VALUES ('70','2018-12-01 05:02:55','254','1409','212.60','58','37','6') ; 
INSERT INTO `flight` VALUES ('71','2018-12-01 05:33:51','116','643','79.80','5','65','26') ; 
INSERT INTO `flight` VALUES ('72','2018-12-01 05:33:07','44','244','27.81','162','6','26') ; 
INSERT INTO `flight` VALUES ('73','2018-12-01 15:05:44','205','1137','240.38','131','68','116') ; 
INSERT INTO `flight` VALUES ('74','2018-12-01 06:46:14','69','381','55.78','169','68','118') ; 
INSERT INTO `flight` VALUES ('75','2018-12-01 23:54:52','485','2693','560.02','250','116','6') ; 
INSERT INTO `flight` VALUES ('76','2018-12-01 09:24:15','354','1965','306.56','50','67','6') ; 
INSERT INTO `flight` VALUES ('77','2018-12-01 03:33:02','320','1778','275.89','120','65','37') ; 
INSERT INTO `flight` VALUES ('78','2018-12-01 09:14:13','146','809','146.12','105','118','116') ; 
INSERT INTO `flight` VALUES ('79','2018-12-01 02:46:11','254','1409','230.67','249','6','37') ; 
INSERT INTO `flight` VALUES ('80','2018-12-01 16:35:45','282','1566','220.24','79','65','38') ; 
INSERT INTO `flight` VALUES ('81','2018-12-01 12:28:09','145','803','103.60','93','6','38') ; 
INSERT INTO `flight` VALUES ('82','2018-12-01 02:56:06','145','803','85.00','214','38','6') ; 
INSERT INTO `flight` VALUES ('83','2018-12-01 10:12:56','283','1570','295.36','22','26','37') ; 
INSERT INTO `flight` VALUES ('84','2018-12-01 11:24:31','189','1049','171.33','16','26','38') ; 
INSERT INTO `flight` VALUES ('85','2018-12-01 18:41:40','392','2176','315.21','183','68','6') ; 
INSERT INTO `flight` VALUES ('86','2018-12-01 05:46:43','142','789','123.59','178','93','65') ; 
INSERT INTO `flight` VALUES ('87','2018-12-01 09:09:08','283','1570','249.80','182','37','26') ; 
INSERT INTO `flight` VALUES ('88','2018-12-01 16:34:52','314','1747','341.57','87','93','67') ; 
INSERT INTO `flight` VALUES ('89','2018-12-01 01:39:04','363','2015','295.31','173','93','68') ; 
INSERT INTO `flight` VALUES ('90','2018-12-01 16:14:39','513','2851','359.40','216','116','26') ; 
INSERT INTO `flight` VALUES ('91','2018-12-02 15:41:29','397','2208','357.21','98','67','26') ; 
INSERT INTO `flight` VALUES ('92','2018-12-02 23:54:37','445','2472','332.26','108','118','6') ; 
INSERT INTO `flight` VALUES ('93','2018-12-02 01:15:37','156','867','147.22','160','37','38') ; 
INSERT INTO `flight` VALUES ('94','2018-12-02 00:24:56','189','1049','153.96','259','38','26') ; 
INSERT INTO `flight` VALUES ('95','2018-12-02 19:21:47','239','1327','256.92','142','116','37') ; 
INSERT INTO `flight` VALUES ('96','2018-12-02 09:45:10','393','2184','333.15','43','116','38') ; 
INSERT INTO `flight` VALUES ('97','2018-12-02 17:43:50','135','748','114.36','239','67','37') ; 
INSERT INTO `flight` VALUES ('98','2018-12-02 16:28:48','217','1203','172.35','89','67','38') ; 
INSERT INTO `flight` VALUES ('99','2018-12-02 06:51:11','435','2419','396.35','144','68','26') ; 
INSERT INTO `flight` VALUES ('100','2018-12-02 14:25:00','159','881','184.06','248','6','65') ; 
INSERT INTO `flight` VALUES ('101','2018-12-02 01:34:01','454','2523','363.26','187','65','67') ; 
INSERT INTO `flight` VALUES ('102','2018-12-02 10:13:09','354','1965','355.68','88','6','67') ; 
INSERT INTO `flight` VALUES ('103','2018-12-02 19:11:56','500','2777','446.93','225','65','68') ; 
INSERT INTO `flight` VALUES ('104','2018-12-02 13:38:48','392','2176','360.92','106','6','68') ; 
INSERT INTO `flight` VALUES ('105','2018-12-02 02:30:13','156','867','121.91','116','38','37') ; 
INSERT INTO `flight` VALUES ('106','2018-12-02 11:07:58','116','643','67.17','195','26','65') ; 
INSERT INTO `flight` VALUES ('107','2018-12-02 03:58:44','397','2208','366.16','3','26','67') ; 
INSERT INTO `flight` VALUES ('108','2018-12-02 03:16:59','435','2419','380.55','86','26','68') ; 
INSERT INTO `flight` VALUES ('109','2018-12-02 05:02:19','489','2716','539.22','7','118','26') ; 
INSERT INTO `flight` VALUES ('110','2018-12-02 00:25:57','183','1016','134.94','189','68','37') ; 
INSERT INTO `flight` VALUES ('111','2018-12-02 03:45:44','255','1415','208.99','147','68','38') ; 
INSERT INTO `flight` VALUES ('112','2018-12-02 15:25:05','320','1778','324.47','40','37','65') ; 
INSERT INTO `flight` VALUES ('113','2018-12-02 03:03:20','228','1268','151.28','241','118','37') ; 
INSERT INTO `flight` VALUES ('114','2018-12-02 21:56:28','135','748','106.79','89','37','67') ; 
INSERT INTO `flight` VALUES ('115','2018-12-02 13:37:10','308','1712','255.90','1','118','38') ; 
INSERT INTO `flight` VALUES ('116','2018-12-02 04:46:38','183','1016','122.06','62','37','68') ; 
INSERT INTO `flight` VALUES ('117','2018-12-02 15:24:33','520','2887','479.19','160','116','65') ; 
INSERT INTO `flight` VALUES ('118','2018-12-02 00:02:48','226','1253','180.14','32','116','67') ; 
INSERT INTO `flight` VALUES ('119','2018-12-02 11:21:15','454','2523','428.21','237','67','65') ; 
INSERT INTO `flight` VALUES ('120','2018-12-02 00:31:08','205','1137','150.77','206','116','68') ; 
INSERT INTO `flight` VALUES ('121','2018-12-02 06:38:44','142','789','108.36','90','65','93') ; 
INSERT INTO `flight` VALUES ('122','2018-12-02 01:14:19','129','715','129.80','133','6','93') ; 
INSERT INTO `flight` VALUES ('123','2018-12-02 06:05:12','49','271','50.99','134','67','68') ; 
INSERT INTO `flight` VALUES ('124','2018-12-02 01:59:13','378','2100','302.90','227','93','116') ; 
INSERT INTO `flight` VALUES ('125','2018-12-02 17:43:14','384','2131','327.22','12','93','118') ; 
INSERT INTO `flight` VALUES ('126','2018-12-02 19:48:05','282','1566','222.46','62','38','65') ; 
INSERT INTO `flight` VALUES ('127','2018-12-02 18:28:51','135','749','106.45','120','26','93') ; 
INSERT INTO `flight` VALUES ('128','2018-12-02 13:58:07','217','1203','166.79','263','38','67') ; 
INSERT INTO `flight` VALUES ('129','2018-12-02 03:03:21','255','1415','291.06','255','38','68') ; 
INSERT INTO `flight` VALUES ('130','2018-12-02 04:24:55','500','2777','360.99','65','68','65') ; 
INSERT INTO `flight` VALUES ('131','2018-12-02 07:38:54','49','271','34.19','82','68','67') ; 
INSERT INTO `flight` VALUES ('132','2018-12-02 09:23:47','181','1003','139.48','14','37','93') ; 
INSERT INTO `flight` VALUES ('133','2018-12-02 01:48:13','129','715','128.37','81','93','6') ; 
INSERT INTO `flight` VALUES ('134','2018-12-02 15:46:39','523','2906','440.11','146','118','65') ; 
INSERT INTO `flight` VALUES ('135','2018-12-02 10:50:28','520','2887','466.63','80','65','116') ; 
INSERT INTO `flight` VALUES ('136','2018-12-02 09:57:27','102','566','99.05','62','118','67') ; 
INSERT INTO `flight` VALUES ('137','2018-12-02 17:10:39','378','2100','207.59','212','116','93') ; 
INSERT INTO `flight` VALUES ('138','2018-12-02 11:19:40','485','2693','424.43','10','6','116') ; 
INSERT INTO `flight` VALUES ('139','2018-12-02 01:20:06','69','381','69.87','197','118','68') ; 
INSERT INTO `flight` VALUES ('140','2018-12-02 15:20:33','523','2906','372.39','56','65','118') ; 
INSERT INTO `flight` VALUES ('141','2018-12-02 01:28:29','445','2472','401.39','87','6','118') ; 
INSERT INTO `flight` VALUES ('142','2018-12-02 15:55:49','314','1747','346.27','229','67','93') ; 
INSERT INTO `flight` VALUES ('143','2018-12-02 13:56:50','513','2851','473.77','60','26','116') ; 
INSERT INTO `flight` VALUES ('144','2018-12-02 11:13:21','489','2716','409.17','199','26','118') ; 
INSERT INTO `flight` VALUES ('145','2018-12-02 16:42:14','167','929','133.21','93','38','93') ; 
INSERT INTO `flight` VALUES ('146','2018-12-02 21:43:37','363','2015','329.04','233','68','93') ; 
INSERT INTO `flight` VALUES ('147','2018-12-02 13:51:48','135','749','130.24','5','93','26') ; 
INSERT INTO `flight` VALUES ('148','2018-12-02 03:54:53','159','881','153.26','166','65','6') ; 
INSERT INTO `flight` VALUES ('149','2018-12-02 20:02:41','239','1327','221.92','136','37','116') ; 
INSERT INTO `flight` VALUES ('150','2018-12-02 23:08:23','228','1268','202.75','45','37','118') ; 
INSERT INTO `flight` VALUES ('151','2018-12-02 13:16:26','44','244','27.13','45','26','6') ; 
INSERT INTO `flight` VALUES ('152','2018-12-02 01:58:18','146','809','120.35','220','116','118') ; 
INSERT INTO `flight` VALUES ('153','2018-12-02 19:38:31','384','2131','297.83','256','118','93') ; 
INSERT INTO `flight` VALUES ('154','2018-12-02 17:18:09','226','1253','177.58','38','67','116') ; 
INSERT INTO `flight` VALUES ('155','2018-12-02 18:26:23','102','566','121.33','172','67','118') ; 
INSERT INTO `flight` VALUES ('156','2018-12-02 20:04:37','181','1003','157.35','236','93','37') ; 
INSERT INTO `flight` VALUES ('157','2018-12-02 20:33:29','167','929','80.53','181','93','38') ; 
INSERT INTO `flight` VALUES ('158','2018-12-02 06:30:47','393','2184','349.29','238','38','116') ; 
INSERT INTO `flight` VALUES ('159','2018-12-02 21:57:08','308','1712','271.32','220','38','118') ; 
INSERT INTO `flight` VALUES ('160','2018-12-02 06:20:28','254','1409','228.97','213','37','6') ; 
INSERT INTO `flight` VALUES ('161','2018-12-02 22:19:51','116','643','64.11','5','65','26') ; 
INSERT INTO `flight` VALUES ('162','2018-12-02 09:34:42','44','244','34.64','227','6','26') ; 
INSERT INTO `flight` VALUES ('163','2018-12-02 07:24:53','205','1137','181.15','71','68','116') ; 
INSERT INTO `flight` VALUES ('164','2018-12-02 21:02:50','69','381','49.07','222','68','118') ; 
INSERT INTO `flight` VALUES ('165','2018-12-02 08:35:09','485','2693','521.63','141','116','6') ; 
INSERT INTO `flight` VALUES ('166','2018-12-02 18:57:35','354','1965','389.10','206','67','6') ; 
INSERT INTO `flight` VALUES ('167','2018-12-02 22:01:24','320','1778','271.04','117','65','37') ; 
INSERT INTO `flight` VALUES ('168','2018-12-02 22:51:54','146','809','145.43','21','118','116') ; 
INSERT INTO `flight` VALUES ('169','2018-12-02 16:44:25','254','1409','311.67','50','6','37') ; 
INSERT INTO `flight` VALUES ('170','2018-12-02 21:06:43','282','1566','200.60','81','65','38') ; 
INSERT INTO `flight` VALUES ('171','2018-12-02 21:27:32','145','803','97.88','67','6','38') ; 
INSERT INTO `flight` VALUES ('172','2018-12-02 22:33:43','145','803','89.06','185','38','6') ; 
INSERT INTO `flight` VALUES ('173','2018-12-02 09:11:36','283','1570','314.67','42','26','37') ; 
INSERT INTO `flight` VALUES ('174','2018-12-02 09:46:56','189','1049','147.73','34','26','38') ; 
INSERT INTO `flight` VALUES ('175','2018-12-02 19:04:21','392','2176','368.41','138','68','6') ; 
INSERT INTO `flight` VALUES ('176','2018-12-02 17:55:19','142','789','113.48','140','93','65') ; 
INSERT INTO `flight` VALUES ('177','2018-12-02 18:32:18','283','1570','275.83','257','37','26') ; 
INSERT INTO `flight` VALUES ('178','2018-12-02 04:13:43','314','1747','280.64','203','93','67') ; 
INSERT INTO `flight` VALUES ('179','2018-12-02 11:09:21','363','2015','286.97','135','93','68') ; 
INSERT INTO `flight` VALUES ('180','2018-12-02 07:04:18','513','2851','485.25','158','116','26') ; 
INSERT INTO `flight` VALUES ('181','2018-12-03 09:08:09','397','2208','304.00','181','67','26') ; 
INSERT INTO `flight` VALUES ('182','2018-12-03 17:22:30','445','2472','331.79','92','118','6') ; 
INSERT INTO `flight` VALUES ('183','2018-12-03 22:13:00','156','867','111.79','11','37','38') ; 
INSERT INTO `flight` VALUES ('184','2018-12-03 20:35:55','189','1049','135.69','246','38','26') ; 
INSERT INTO `flight` VALUES ('185','2018-12-03 00:33:38','239','1327','267.46','148','116','37') ; 
INSERT INTO `flight` VALUES ('186','2018-12-03 17:45:01','393','2184','344.01','180','116','38') ; 
INSERT INTO `flight` VALUES ('187','2018-12-03 19:12:08','135','748','92.86','213','67','37') ; 
INSERT INTO `flight` VALUES ('188','2018-12-03 07:47:17','217','1203','133.15','197','67','38') ; 
INSERT INTO `flight` VALUES ('189','2018-12-03 13:55:55','435','2419','341.22','182','68','26') ; 
INSERT INTO `flight` VALUES ('190','2018-12-03 18:18:38','159','881','181.91','86','6','65') ; 
INSERT INTO `flight` VALUES ('191','2018-12-03 15:10:30','454','2523','428.40','188','65','67') ; 
INSERT INTO `flight` VALUES ('192','2018-12-03 06:44:24','354','1965','336.65','234','6','67') ; 
INSERT INTO `flight` VALUES ('193','2018-12-03 15:55:15','500','2777','468.74','227','65','68') ; 
INSERT INTO `flight` VALUES ('194','2018-12-03 22:27:41','392','2176','288.10','199','6','68') ; 
INSERT INTO `flight` VALUES ('195','2018-12-03 11:34:57','156','867','143.56','177','38','37') ; 
INSERT INTO `flight` VALUES ('196','2018-12-03 18:17:34','116','643','80.97','183','26','65') ; 
INSERT INTO `flight` VALUES ('197','2018-12-03 13:19:07','397','2208','435.30','50','26','67') ; 
INSERT INTO `flight` VALUES ('198','2018-12-03 08:21:12','435','2419','333.47','81','26','68') ; 
INSERT INTO `flight` VALUES ('199','2018-12-03 12:41:37','489','2716','495.95','248','118','26') ; 
INSERT INTO `flight` VALUES ('200','2018-12-03 22:33:39','183','1016','147.73','18','68','37') ; 
INSERT INTO `flight` VALUES ('201','2018-12-03 23:59:21','255','1415','193.53','223','68','38') ; 
INSERT INTO `flight` VALUES ('202','2018-12-03 18:19:40','320','1778','333.21','41','37','65') ; 
INSERT INTO `flight` VALUES ('203','2018-12-03 17:33:35','228','1268','166.82','98','118','37') ; 
INSERT INTO `flight` VALUES ('204','2018-12-03 20:09:05','135','748','96.65','264','37','67') ; 
INSERT INTO `flight` VALUES ('205','2018-12-03 09:29:46','308','1712','270.91','8','118','38') ; 
INSERT INTO `flight` VALUES ('206','2018-12-03 18:19:37','183','1016','137.52','13','37','68') ; 
INSERT INTO `flight` VALUES ('207','2018-12-03 20:58:18','520','2887','443.65','162','116','65') ; 
INSERT INTO `flight` VALUES ('208','2018-12-03 13:32:29','226','1253','188.74','251','116','67') ; 
INSERT INTO `flight` VALUES ('209','2018-12-03 17:18:31','454','2523','492.18','80','67','65') ; 
INSERT INTO `flight` VALUES ('210','2018-12-03 07:30:05','205','1137','154.68','243','116','68') ; 
INSERT INTO `flight` VALUES ('211','2018-12-03 03:16:20','142','789','124.58','1','65','93') ; 
INSERT INTO `flight` VALUES ('212','2018-12-03 00:16:32','129','715','133.23','68','6','93') ; 
INSERT INTO `flight` VALUES ('213','2018-12-03 21:20:18','49','271','51.48','263','67','68') ; 
INSERT INTO `flight` VALUES ('214','2018-12-03 01:01:43','378','2100','266.96','222','93','116') ; 
INSERT INTO `flight` VALUES ('215','2018-12-03 08:13:32','384','2131','314.28','2','93','118') ; 
INSERT INTO `flight` VALUES ('216','2018-12-03 22:14:35','282','1566','234.98','249','38','65') ; 
INSERT INTO `flight` VALUES ('217','2018-12-03 07:03:40','135','749','117.80','12','26','93') ; 
INSERT INTO `flight` VALUES ('218','2018-12-03 16:58:39','217','1203','212.73','114','38','67') ; 
INSERT INTO `flight` VALUES ('219','2018-12-03 21:03:54','255','1415','299.57','110','38','68') ; 
INSERT INTO `flight` VALUES ('220','2018-12-03 05:26:29','500','2777','391.55','209','68','65') ; 
INSERT INTO `flight` VALUES ('221','2018-12-03 02:30:21','49','271','44.20','80','68','67') ; 
INSERT INTO `flight` VALUES ('222','2018-12-03 21:25:33','181','1003','190.72','43','37','93') ; 
INSERT INTO `flight` VALUES ('223','2018-12-03 20:10:53','129','715','132.79','251','93','6') ; 
INSERT INTO `flight` VALUES ('224','2018-12-03 02:10:37','523','2906','334.02','140','118','65') ; 
INSERT INTO `flight` VALUES ('225','2018-12-03 12:24:25','520','2887','412.54','90','65','116') ; 
INSERT INTO `flight` VALUES ('226','2018-12-03 04:15:39','102','566','90.49','39','118','67') ; 
INSERT INTO `flight` VALUES ('227','2018-12-03 04:08:13','378','2100','201.35','143','116','93') ; 
INSERT INTO `flight` VALUES ('228','2018-12-03 21:42:06','485','2693','429.31','63','6','116') ; 
INSERT INTO `flight` VALUES ('229','2018-12-03 20:36:47','69','381','54.35','184','118','68') ; 
INSERT INTO `flight` VALUES ('230','2018-12-03 01:05:04','523','2906','395.07','127','65','118') ; 
INSERT INTO `flight` VALUES ('231','2018-12-03 20:38:24','445','2472','354.89','108','6','118') ; 
INSERT INTO `flight` VALUES ('232','2018-12-03 23:52:54','314','1747','316.83','248','67','93') ; 
INSERT INTO `flight` VALUES ('233','2018-12-03 20:52:10','513','2851','526.69','24','26','116') ; 
INSERT INTO `flight` VALUES ('234','2018-12-03 02:59:42','489','2716','334.43','201','26','118') ; 
INSERT INTO `flight` VALUES ('235','2018-12-03 10:41:13','167','929','136.42','163','38','93') ; 
INSERT INTO `flight` VALUES ('236','2018-12-03 03:35:31','363','2015','245.29','52','68','93') ; 
INSERT INTO `flight` VALUES ('237','2018-12-03 16:38:47','135','749','116.69','49','93','26') ; 
INSERT INTO `flight` VALUES ('238','2018-12-03 21:17:09','159','881','164.30','161','65','6') ; 
INSERT INTO `flight` VALUES ('239','2018-12-03 20:00:03','239','1327','197.03','208','37','116') ; 
INSERT INTO `flight` VALUES ('240','2018-12-03 15:44:24','228','1268','184.50','132','37','118') ; 
INSERT INTO `flight` VALUES ('241','2018-12-03 23:10:57','44','244','34.90','176','26','6') ; 
INSERT INTO `flight` VALUES ('242','2018-12-03 16:28:37','146','809','117.67','96','116','118') ; 
INSERT INTO `flight` VALUES ('243','2018-12-03 03:00:56','384','2131','359.88','29','118','93') ; 
INSERT INTO `flight` VALUES ('244','2018-12-03 17:56:30','226','1253','170.76','72','67','116') ; 
INSERT INTO `flight` VALUES ('245','2018-12-03 19:14:04','102','566','131.44','67','67','118') ; 
INSERT INTO `flight` VALUES ('246','2018-12-03 15:24:16','181','1003','172.16','19','93','37') ; 
INSERT INTO `flight` VALUES ('247','2018-12-03 04:32:09','167','929','111.03','226','93','38') ; 
INSERT INTO `flight` VALUES ('248','2018-12-03 06:22:03','393','2184','334.22','264','38','116') ; 
INSERT INTO `flight` VALUES ('249','2018-12-03 19:22:11','308','1712','279.07','83','38','118') ; 
INSERT INTO `flight` VALUES ('250','2018-12-03 10:43:46','254','1409','235.61','108','37','6') ; 
INSERT INTO `flight` VALUES ('251','2018-12-03 07:01:47','116','643','62.41','118','65','26') ; 
INSERT INTO `flight` VALUES ('252','2018-12-03 11:29:32','44','244','36.12','10','6','26') ; 
INSERT INTO `flight` VALUES ('253','2018-12-03 18:24:30','205','1137','239.04','29','68','116') ; 
INSERT INTO `flight` VALUES ('254','2018-12-03 15:38:43','69','381','56.08','128','68','118') ; 
INSERT INTO `flight` VALUES ('255','2018-12-03 09:20:32','485','2693','428.30','259','116','6') ; 
INSERT INTO `flight` VALUES ('256','2018-12-03 17:25:45','354','1965','386.39','25','67','6') ; 
INSERT INTO `flight` VALUES ('257','2018-12-03 00:57:58','320','1778','365.43','12','65','37') ; 
INSERT INTO `flight` VALUES ('258','2018-12-03 03:58:37','146','809','149.30','210','118','116') ; 
INSERT INTO `flight` VALUES ('259','2018-12-03 07:05:56','254','1409','289.54','16','6','37') ; 
INSERT INTO `flight` VALUES ('260','2018-12-03 18:43:26','282','1566','264.64','123','65','38') ; 
INSERT INTO `flight` VALUES ('261','2018-12-03 03:57:31','145','803','101.90','49','6','38') ; 
INSERT INTO `flight` VALUES ('262','2018-12-03 17:33:04','145','803','94.73','194','38','6') ; 
INSERT INTO `flight` VALUES ('263','2018-12-03 16:00:19','283','1570','284.62','119','26','37') ; 
INSERT INTO `flight` VALUES ('264','2018-12-03 05:32:28','189','1049','148.49','180','26','38') ; 
INSERT INTO `flight` VALUES ('265','2018-12-03 03:21:48','392','2176','419.11','51','68','6') ; 
INSERT INTO `flight` VALUES ('266','2018-12-03 03:45:24','142','789','86.54','160','93','65') ; 
INSERT INTO `flight` VALUES ('267','2018-12-03 23:02:10','283','1570','315.56','50','37','26') ; 
INSERT INTO `flight` VALUES ('268','2018-12-03 12:32:26','314','1747','287.35','252','93','67') ; 
INSERT INTO `flight` VALUES ('269','2018-12-03 17:52:10','363','2015','304.34','237','93','68') ; 
INSERT INTO `flight` VALUES ('270','2018-12-03 22:38:53','513','2851','497.20','98','116','26') ; 
INSERT INTO `flight` VALUES ('271','2018-12-04 07:39:09','397','2208','389.47','112','67','26') ; 
INSERT INTO `flight` VALUES ('272','2018-12-04 02:35:23','445','2472','313.95','116','118','6') ; 
INSERT INTO `flight` VALUES ('273','2018-12-04 20:12:50','156','867','124.44','57','37','38') ; 
INSERT INTO `flight` VALUES ('274','2018-12-04 04:05:30','189','1049','146.75','157','38','26') ; 
INSERT INTO `flight` VALUES ('275','2018-12-04 15:12:10','239','1327','213.89','166','116','37') ; 
INSERT INTO `flight` VALUES ('276','2018-12-04 16:27:56','393','2184','288.09','2','116','38') ; 
INSERT INTO `flight` VALUES ('277','2018-12-04 14:35:27','135','748','108.50','143','67','37') ; 
INSERT INTO `flight` VALUES ('278','2018-12-04 10:24:53','217','1203','134.92','118','67','38') ; 
INSERT INTO `flight` VALUES ('279','2018-12-04 11:41:06','435','2419','366.74','101','68','26') ; 
INSERT INTO `flight` VALUES ('280','2018-12-04 14:44:04','159','881','175.99','52','6','65') ; 
INSERT INTO `flight` VALUES ('281','2018-12-04 17:06:46','454','2523','419.92','252','65','67') ; 
INSERT INTO `flight` VALUES ('282','2018-12-04 02:29:10','354','1965','295.01','100','6','67') ; 
INSERT INTO `flight` VALUES ('283','2018-12-04 12:27:11','500','2777','545.77','93','65','68') ; 
INSERT INTO `flight` VALUES ('284','2018-12-04 01:07:02','392','2176','359.58','91','6','68') ; 
INSERT INTO `flight` VALUES ('285','2018-12-04 18:24:00','156','867','119.52','130','38','37') ; 
INSERT INTO `flight` VALUES ('286','2018-12-04 03:54:54','116','643','94.00','3','26','65') ; 
INSERT INTO `flight` VALUES ('287','2018-12-04 06:35:44','397','2208','363.51','132','26','67') ; 
INSERT INTO `flight` VALUES ('288','2018-12-04 19:54:43','435','2419','287.60','28','26','68') ; 
INSERT INTO `flight` VALUES ('289','2018-12-04 20:11:51','489','2716','505.14','225','118','26') ; 
INSERT INTO `flight` VALUES ('290','2018-12-04 15:41:19','183','1016','148.07','14','68','37') ; 
INSERT INTO `flight` VALUES ('291','2018-12-04 18:18:16','255','1415','192.57','170','68','38') ; 
INSERT INTO `flight` VALUES ('292','2018-12-04 21:36:59','320','1778','253.70','41','37','65') ; 
INSERT INTO `flight` VALUES ('293','2018-12-04 02:16:26','228','1268','219.03','227','118','37') ; 
INSERT INTO `flight` VALUES ('294','2018-12-04 18:46:02','135','748','137.07','72','37','67') ; 
INSERT INTO `flight` VALUES ('295','2018-12-04 11:27:37','308','1712','193.85','152','118','38') ; 
INSERT INTO `flight` VALUES ('296','2018-12-04 12:27:39','183','1016','165.33','218','37','68') ; 
INSERT INTO `flight` VALUES ('297','2018-12-04 20:17:25','520','2887','482.18','61','116','65') ; 
INSERT INTO `flight` VALUES ('298','2018-12-04 07:55:49','226','1253','141.65','10','116','67') ; 
INSERT INTO `flight` VALUES ('299','2018-12-04 19:14:10','454','2523','486.57','139','67','65') ; 
INSERT INTO `flight` VALUES ('300','2018-12-04 16:30:59','205','1137','193.64','150','116','68') ; 
INSERT INTO `flight` VALUES ('301','2018-12-04 17:01:35','142','789','104.89','244','65','93') ; 
INSERT INTO `flight` VALUES ('302','2018-12-04 00:56:54','129','715','116.22','124','6','93') ; 
INSERT INTO `flight` VALUES ('303','2018-12-04 18:14:40','49','271','42.65','81','67','68') ; 
INSERT INTO `flight` VALUES ('304','2018-12-04 02:27:43','378','2100','270.06','68','93','116') ; 
INSERT INTO `flight` VALUES ('305','2018-12-04 16:23:17','384','2131','289.68','123','93','118') ; 
INSERT INTO `flight` VALUES ('306','2018-12-04 19:58:30','282','1566','271.65','44','38','65') ; 
INSERT INTO `flight` VALUES ('307','2018-12-04 08:01:43','135','749','130.67','113','26','93') ; 
INSERT INTO `flight` VALUES ('308','2018-12-04 08:24:34','217','1203','156.02','151','38','67') ; 
INSERT INTO `flight` VALUES ('309','2018-12-04 19:54:32','255','1415','215.82','114','38','68') ; 
INSERT INTO `flight` VALUES ('310','2018-12-04 04:51:03','500','2777','455.65','182','68','65') ; 
INSERT INTO `flight` VALUES ('311','2018-12-04 18:24:58','49','271','39.89','187','68','67') ; 
INSERT INTO `flight` VALUES ('312','2018-12-04 01:09:51','181','1003','195.10','31','37','93') ; 
INSERT INTO `flight` VALUES ('313','2018-12-04 15:12:01','129','715','147.73','118','93','6') ; 
INSERT INTO `flight` VALUES ('314','2018-12-04 21:48:25','523','2906','454.74','209','118','65') ; 
INSERT INTO `flight` VALUES ('315','2018-12-04 17:45:39','520','2887','367.94','122','65','116') ; 
INSERT INTO `flight` VALUES ('316','2018-12-04 05:48:45','102','566','86.16','47','118','67') ; 
INSERT INTO `flight` VALUES ('317','2018-12-04 03:20:35','378','2100','256.01','211','116','93') ; 
INSERT INTO `flight` VALUES ('318','2018-12-04 00:27:54','485','2693','374.98','125','6','116') ; 
INSERT INTO `flight` VALUES ('319','2018-12-04 05:36:28','69','381','50.94','117','118','68') ; 
INSERT INTO `flight` VALUES ('320','2018-12-04 22:13:06','523','2906','351.85','75','65','118') ; 
INSERT INTO `flight` VALUES ('321','2018-12-04 00:11:27','445','2472','378.96','189','6','118') ; 
INSERT INTO `flight` VALUES ('322','2018-12-04 11:04:02','314','1747','297.55','155','67','93') ; 
INSERT INTO `flight` VALUES ('323','2018-12-04 17:30:44','513','2851','542.73','251','26','116') ; 
INSERT INTO `flight` VALUES ('324','2018-12-04 03:35:02','489','2716','454.67','56','26','118') ; 
INSERT INTO `flight` VALUES ('325','2018-12-04 16:06:12','167','929','111.04','146','38','93') ; 
INSERT INTO `flight` VALUES ('326','2018-12-04 08:25:59','363','2015','361.50','7','68','93') ; 
INSERT INTO `flight` VALUES ('327','2018-12-04 13:45:21','135','749','146.40','114','93','26') ; 
INSERT INTO `flight` VALUES ('328','2018-12-04 14:28:22','159','881','139.28','79','65','6') ; 
INSERT INTO `flight` VALUES ('329','2018-12-04 22:46:30','239','1327','233.31','173','37','116') ; 
INSERT INTO `flight` VALUES ('330','2018-12-04 15:52:07','228','1268','218.04','99','37','118') ; 
INSERT INTO `flight` VALUES ('331','2018-12-04 02:47:51','44','244','35.80','95','26','6') ; 
INSERT INTO `flight` VALUES ('332','2018-12-04 23:28:58','146','809','144.28','4','116','118') ; 
INSERT INTO `flight` VALUES ('333','2018-12-04 16:51:57','384','2131','353.07','183','118','93') ; 
INSERT INTO `flight` VALUES ('334','2018-12-04 00:07:34','226','1253','159.81','97','67','116') ; 
INSERT INTO `flight` VALUES ('335','2018-12-04 14:54:45','102','566','138.18','214','67','118') ; 
INSERT INTO `flight` VALUES ('336','2018-12-04 10:05:49','181','1003','190.72','161','93','37') ; 
INSERT INTO `flight` VALUES ('337','2018-12-04 08:12:06','167','929','106.03','156','93','38') ; 
INSERT INTO `flight` VALUES ('338','2018-12-04 00:36:50','393','2184','429.04','118','38','116') ; 
INSERT INTO `flight` VALUES ('339','2018-12-04 14:20:44','308','1712','281.51','264','38','118') ; 
INSERT INTO `flight` VALUES ('340','2018-12-04 10:32:26','254','1409','248.82','149','37','6') ; 
INSERT INTO `flight` VALUES ('341','2018-12-04 23:05:31','116','643','86.75','250','65','26') ; 
INSERT INTO `flight` VALUES ('342','2018-12-04 08:24:04','44','244','31.13','265','6','26') ; 
INSERT INTO `flight` VALUES ('343','2018-12-04 06:38:46','205','1137','224.86','141','68','116') ; 
INSERT INTO `flight` VALUES ('344','2018-12-04 01:18:10','69','381','62.00','186','68','118') ; 
INSERT INTO `flight` VALUES ('345','2018-12-04 19:26:02','485','2693','488.16','51','116','6') ; 
INSERT INTO `flight` VALUES ('346','2018-12-04 05:39:16','354','1965','271.74','30','67','6') ; 
INSERT INTO `flight` VALUES ('347','2018-12-04 03:30:56','320','1778','350.51','154','65','37') ; 
INSERT INTO `flight` VALUES ('348','2018-12-04 12:25:41','146','809','152.21','128','118','116') ; 
INSERT INTO `flight` VALUES ('349','2018-12-04 19:19:05','254','1409','273.41','256','6','37') ; 
INSERT INTO `flight` VALUES ('350','2018-12-04 10:06:51','282','1566','289.01','68','65','38') ; 
INSERT INTO `flight` VALUES ('351','2018-12-04 18:20:18','145','803','101.79','79','6','38') ; 
INSERT INTO `flight` VALUES ('352','2018-12-04 11:07:52','145','803','93.59','31','38','6') ; 
INSERT INTO `flight` VALUES ('353','2018-12-04 09:42:02','283','1570','268.07','253','26','37') ; 
INSERT INTO `flight` VALUES ('354','2018-12-04 16:14:04','189','1049','149.31','8','26','38') ; 
INSERT INTO `flight` VALUES ('355','2018-12-04 06:17:36','392','2176','335.94','220','68','6') ; 
INSERT INTO `flight` VALUES ('356','2018-12-04 02:33:37','142','789','120.17','163','93','65') ; 
INSERT INTO `flight` VALUES ('357','2018-12-04 11:37:30','283','1570','313.18','229','37','26') ; 
INSERT INTO `flight` VALUES ('358','2018-12-04 04:12:54','314','1747','378.24','258','93','67') ; 
INSERT INTO `flight` VALUES ('359','2018-12-04 15:03:06','363','2015','312.70','39','93','68') ; 
INSERT INTO `flight` VALUES ('360','2018-12-04 14:00:43','513','2851','475.85','72','116','26') ; 
INSERT INTO `flight` VALUES ('361','2018-12-05 23:27:29','397','2208','395.88','204','67','26') ; 
INSERT INTO `flight` VALUES ('362','2018-12-05 02:56:17','445','2472','250.70','25','118','6') ; 
INSERT INTO `flight` VALUES ('363','2018-12-05 23:24:05','156','867','140.00','72','37','38') ; 
INSERT INTO `flight` VALUES ('364','2018-12-05 18:55:03','189','1049','138.14','17','38','26') ; 
INSERT INTO `flight` VALUES ('365','2018-12-05 22:59:09','239','1327','252.81','259','116','37') ; 
INSERT INTO `flight` VALUES ('366','2018-12-05 00:26:06','393','2184','404.52','110','116','38') ; 
INSERT INTO `flight` VALUES ('367','2018-12-05 18:20:56','135','748','93.95','248','67','37') ; 
INSERT INTO `flight` VALUES ('368','2018-12-05 21:35:29','217','1203','159.42','82','67','38') ; 
INSERT INTO `flight` VALUES ('369','2018-12-05 22:30:49','435','2419','380.36','119','68','26') ; 
INSERT INTO `flight` VALUES ('370','2018-12-05 18:46:22','159','881','183.62','160','6','65') ; 
INSERT INTO `flight` VALUES ('371','2018-12-05 01:08:17','454','2523','373.15','106','65','67') ; 
INSERT INTO `flight` VALUES ('372','2018-12-05 15:29:52','354','1965','352.75','27','6','67') ; 
INSERT INTO `flight` VALUES ('373','2018-12-05 21:47:05','500','2777','447.92','2','65','68') ; 
INSERT INTO `flight` VALUES ('374','2018-12-05 02:27:11','392','2176','260.91','78','6','68') ; 
INSERT INTO `flight` VALUES ('375','2018-12-05 04:53:34','156','867','129.01','8','38','37') ; 
INSERT INTO `flight` VALUES ('376','2018-12-05 12:43:03','116','643','70.35','245','26','65') ; 
INSERT INTO `flight` VALUES ('377','2018-12-05 13:49:27','397','2208','360.29','212','26','67') ; 
INSERT INTO `flight` VALUES ('378','2018-12-05 20:20:08','435','2419','301.21','146','26','68') ; 
INSERT INTO `flight` VALUES ('379','2018-12-05 12:52:54','489','2716','471.51','93','118','26') ; 
INSERT INTO `flight` VALUES ('380','2018-12-05 23:16:57','183','1016','141.41','125','68','37') ; 
INSERT INTO `flight` VALUES ('381','2018-12-05 21:41:14','255','1415','185.43','173','68','38') ; 
INSERT INTO `flight` VALUES ('382','2018-12-05 18:04:01','320','1778','337.79','59','37','65') ; 
INSERT INTO `flight` VALUES ('383','2018-12-05 04:24:00','228','1268','195.73','131','118','37') ; 
INSERT INTO `flight` VALUES ('384','2018-12-05 08:29:42','135','748','105.01','216','37','67') ; 
INSERT INTO `flight` VALUES ('385','2018-12-05 18:28:25','308','1712','222.21','227','118','38') ; 
INSERT INTO `flight` VALUES ('386','2018-12-05 05:08:42','183','1016','167.06','73','37','68') ; 
INSERT INTO `flight` VALUES ('387','2018-12-05 13:08:05','520','2887','510.90','210','116','65') ; 
INSERT INTO `flight` VALUES ('388','2018-12-05 14:02:00','226','1253','186.88','150','116','67') ; 
INSERT INTO `flight` VALUES ('389','2018-12-05 16:23:48','454','2523','352.09','51','67','65') ; 
INSERT INTO `flight` VALUES ('390','2018-12-05 21:39:51','205','1137','147.02','152','116','68') ; 
INSERT INTO `flight` VALUES ('391','2018-12-05 07:37:35','142','789','109.52','30','65','93') ; 
INSERT INTO `flight` VALUES ('392','2018-12-05 17:02:41','129','715','101.69','176','6','93') ; 
INSERT INTO `flight` VALUES ('393','2018-12-05 05:28:58','49','271','45.26','32','67','68') ; 
INSERT INTO `flight` VALUES ('394','2018-12-05 22:40:38','378','2100','315.50','17','93','116') ; 
INSERT INTO `flight` VALUES ('395','2018-12-05 03:01:18','384','2131','333.28','114','93','118') ; 
INSERT INTO `flight` VALUES ('396','2018-12-05 15:39:31','282','1566','272.83','234','38','65') ; 
INSERT INTO `flight` VALUES ('397','2018-12-05 13:02:35','135','749','134.68','233','26','93') ; 
INSERT INTO `flight` VALUES ('398','2018-12-05 11:25:34','217','1203','203.83','226','38','67') ; 
INSERT INTO `flight` VALUES ('399','2018-12-05 17:01:26','255','1415','261.29','135','38','68') ; 
INSERT INTO `flight` VALUES ('400','2018-12-05 14:45:26','500','2777','462.11','142','68','65') ; 
INSERT INTO `flight` VALUES ('401','2018-12-05 19:30:12','49','271','38.53','45','68','67') ; 
INSERT INTO `flight` VALUES ('402','2018-12-05 12:20:10','181','1003','198.41','198','37','93') ; 
INSERT INTO `flight` VALUES ('403','2018-12-05 10:08:12','129','715','147.06','107','93','6') ; 
INSERT INTO `flight` VALUES ('404','2018-12-05 21:51:56','523','2906','379.39','38','118','65') ; 
INSERT INTO `flight` VALUES ('405','2018-12-05 13:51:09','520','2887','332.22','24','65','116') ; 
INSERT INTO `flight` VALUES ('406','2018-12-05 08:57:47','102','566','104.81','13','118','67') ; 
INSERT INTO `flight` VALUES ('407','2018-12-05 01:43:25','378','2100','263.56','147','116','93') ; 
INSERT INTO `flight` VALUES ('408','2018-12-05 03:06:31','485','2693','387.03','237','6','116') ; 
INSERT INTO `flight` VALUES ('409','2018-12-05 20:32:16','69','381','60.50','206','118','68') ; 
INSERT INTO `flight` VALUES ('410','2018-12-05 19:33:10','523','2906','484.55','215','65','118') ; 
INSERT INTO `flight` VALUES ('411','2018-12-05 07:35:12','445','2472','364.31','201','6','118') ; 
INSERT INTO `flight` VALUES ('412','2018-12-05 02:59:32','314','1747','262.88','50','67','93') ; 
INSERT INTO `flight` VALUES ('413','2018-12-05 13:13:55','513','2851','502.01','102','26','116') ; 
INSERT INTO `flight` VALUES ('414','2018-12-05 21:31:11','489','2716','316.56','55','26','118') ; 
INSERT INTO `flight` VALUES ('415','2018-12-05 14:52:29','167','929','141.80','101','38','93') ; 
INSERT INTO `flight` VALUES ('416','2018-12-05 11:26:42','363','2015','306.88','202','68','93') ; 
INSERT INTO `flight` VALUES ('417','2018-12-05 23:45:17','135','749','103.79','203','93','26') ; 
INSERT INTO `flight` VALUES ('418','2018-12-05 02:12:53','159','881','162.22','205','65','6') ; 
INSERT INTO `flight` VALUES ('419','2018-12-05 10:12:15','239','1327','214.83','21','37','116') ; 
INSERT INTO `flight` VALUES ('420','2018-12-05 21:55:19','228','1268','168.29','5','37','118') ; 
INSERT INTO `flight` VALUES ('421','2018-12-05 06:50:31','44','244','29.87','165','26','6') ; 
INSERT INTO `flight` VALUES ('422','2018-12-05 13:13:13','146','809','151.90','99','116','118') ; 
INSERT INTO `flight` VALUES ('423','2018-12-05 21:24:11','384','2131','321.89','154','118','93') ; 
INSERT INTO `flight` VALUES ('424','2018-12-05 19:56:47','226','1253','154.84','28','67','116') ; 
INSERT INTO `flight` VALUES ('425','2018-12-05 14:28:29','102','566','104.01','215','67','118') ; 
INSERT INTO `flight` VALUES ('426','2018-12-05 02:08:54','181','1003','189.77','187','93','37') ; 
INSERT INTO `flight` VALUES ('427','2018-12-05 04:06:33','167','929','96.51','256','93','38') ; 
INSERT INTO `flight` VALUES ('428','2018-12-05 06:16:54','393','2184','394.34','161','38','116') ; 
INSERT INTO `flight` VALUES ('429','2018-12-05 18:27:47','308','1712','203.03','18','38','118') ; 
INSERT INTO `flight` VALUES ('430','2018-12-05 03:18:14','254','1409','230.19','99','37','6') ; 
INSERT INTO `flight` VALUES ('431','2018-12-05 13:18:06','116','643','79.42','231','65','26') ; 
INSERT INTO `flight` VALUES ('432','2018-12-05 04:58:46','44','244','28.80','241','6','26') ; 
INSERT INTO `flight` VALUES ('433','2018-12-05 17:04:12','205','1137','196.86','38','68','116') ; 
INSERT INTO `flight` VALUES ('434','2018-12-05 17:11:41','69','381','57.75','241','68','118') ; 
INSERT INTO `flight` VALUES ('435','2018-12-05 18:15:40','485','2693','492.20','192','116','6') ; 
INSERT INTO `flight` VALUES ('436','2018-12-05 20:08:31','354','1965','269.55','258','67','6') ; 
INSERT INTO `flight` VALUES ('437','2018-12-05 19:09:27','320','1778','285.29','4','65','37') ; 
INSERT INTO `flight` VALUES ('438','2018-12-05 06:55:57','146','809','157.61','234','118','116') ; 
INSERT INTO `flight` VALUES ('439','2018-12-05 09:46:59','254','1409','308.79','3','6','37') ; 
INSERT INTO `flight` VALUES ('440','2018-12-05 06:44:05','282','1566','277.25','155','65','38') ; 
INSERT INTO `flight` VALUES ('441','2018-12-05 06:07:00','145','803','114.97','121','6','38') ; 
INSERT INTO `flight` VALUES ('442','2018-12-05 13:28:55','145','803','94.89','45','38','6') ; 
INSERT INTO `flight` VALUES ('443','2018-12-05 19:42:23','283','1570','225.30','137','26','37') ; 
INSERT INTO `flight` VALUES ('444','2018-12-05 17:07:46','189','1049','155.05','265','26','38') ; 
INSERT INTO `flight` VALUES ('445','2018-12-05 21:18:47','392','2176','331.40','71','68','6') ; 
INSERT INTO `flight` VALUES ('446','2018-12-05 19:46:25','142','789','102.02','34','93','65') ; 
INSERT INTO `flight` VALUES ('447','2018-12-05 23:07:11','283','1570','308.19','105','37','26') ; 
INSERT INTO `flight` VALUES ('448','2018-12-05 22:17:35','314','1747','340.23','60','93','67') ; 
INSERT INTO `flight` VALUES ('449','2018-12-05 08:51:41','363','2015','321.41','164','93','68') ; 
INSERT INTO `flight` VALUES ('450','2018-12-05 19:54:12','513','2851','466.13','263','116','26') ; 
INSERT INTO `flight` VALUES ('451','2018-12-06 22:32:08','397','2208','410.29','138','67','26') ; 
INSERT INTO `flight` VALUES ('452','2018-12-06 03:40:34','445','2472','347.08','83','118','6') ; 
INSERT INTO `flight` VALUES ('453','2018-12-06 20:56:35','156','867','110.18','185','37','38') ; 
INSERT INTO `flight` VALUES ('454','2018-12-06 20:47:05','189','1049','136.67','111','38','26') ; 
INSERT INTO `flight` VALUES ('455','2018-12-06 20:50:54','239','1327','256.40','181','116','37') ; 
INSERT INTO `flight` VALUES ('456','2018-12-06 00:48:20','393','2184','349.95','158','116','38') ; 
INSERT INTO `flight` VALUES ('457','2018-12-06 09:49:36','135','748','92.60','85','67','37') ; 
INSERT INTO `flight` VALUES ('458','2018-12-06 19:21:45','217','1203','177.59','170','67','38') ; 
INSERT INTO `flight` VALUES ('459','2018-12-06 15:36:47','435','2419','312.17','55','68','26') ; 
INSERT INTO `flight` VALUES ('460','2018-12-06 23:31:40','159','881','172.38','100','6','65') ; 
INSERT INTO `flight` VALUES ('461','2018-12-06 19:16:43','454','2523','451.48','179','65','67') ; 
INSERT INTO `flight` VALUES ('462','2018-12-06 14:38:56','354','1965','273.57','106','6','67') ; 
INSERT INTO `flight` VALUES ('463','2018-12-06 18:54:02','500','2777','478.73','245','65','68') ; 
INSERT INTO `flight` VALUES ('464','2018-12-06 05:47:12','392','2176','252.94','227','6','68') ; 
INSERT INTO `flight` VALUES ('465','2018-12-06 17:44:22','156','867','116.10','9','38','37') ; 
INSERT INTO `flight` VALUES ('466','2018-12-06 10:06:55','116','643','69.86','78','26','65') ; 
INSERT INTO `flight` VALUES ('467','2018-12-06 18:17:05','397','2208','352.01','145','26','67') ; 
INSERT INTO `flight` VALUES ('468','2018-12-06 10:47:28','435','2419','378.67','142','26','68') ; 
INSERT INTO `flight` VALUES ('469','2018-12-06 06:44:07','489','2716','516.47','44','118','26') ; 
INSERT INTO `flight` VALUES ('470','2018-12-06 17:42:19','183','1016','148.93','67','68','37') ; 
INSERT INTO `flight` VALUES ('471','2018-12-06 18:37:27','255','1415','197.48','206','68','38') ; 
INSERT INTO `flight` VALUES ('472','2018-12-06 01:29:20','320','1778','295.32','183','37','65') ; 
INSERT INTO `flight` VALUES ('473','2018-12-06 23:30:19','228','1268','178.79','262','118','37') ; 
INSERT INTO `flight` VALUES ('474','2018-12-06 05:02:11','135','748','130.53','41','37','67') ; 
INSERT INTO `flight` VALUES ('475','2018-12-06 10:41:11','308','1712','262.40','235','118','38') ; 
INSERT INTO `flight` VALUES ('476','2018-12-06 02:47:29','183','1016','154.70','156','37','68') ; 
INSERT INTO `flight` VALUES ('477','2018-12-06 00:51:26','520','2887','424.78','156','116','65') ; 
INSERT INTO `flight` VALUES ('478','2018-12-06 13:56:10','226','1253','133.66','41','116','67') ; 
INSERT INTO `flight` VALUES ('479','2018-12-06 20:38:19','454','2523','446.96','27','67','65') ; 
INSERT INTO `flight` VALUES ('480','2018-12-06 08:48:29','205','1137','169.57','169','116','68') ; 
INSERT INTO `flight` VALUES ('481','2018-12-06 12:21:43','142','789','111.36','6','65','93') ; 
INSERT INTO `flight` VALUES ('482','2018-12-06 13:55:19','129','715','122.44','253','6','93') ; 
INSERT INTO `flight` VALUES ('483','2018-12-06 17:54:14','49','271','47.08','108','67','68') ; 
INSERT INTO `flight` VALUES ('484','2018-12-06 15:30:32','378','2100','262.94','255','93','116') ; 
INSERT INTO `flight` VALUES ('485','2018-12-06 14:40:56','384','2131','281.45','52','93','118') ; 
INSERT INTO `flight` VALUES ('486','2018-12-06 07:36:39','282','1566','301.88','214','38','65') ; 
INSERT INTO `flight` VALUES ('487','2018-12-06 03:27:57','135','749','120.87','221','26','93') ; 
INSERT INTO `flight` VALUES ('488','2018-12-06 03:26:33','217','1203','161.21','39','38','67') ; 
INSERT INTO `flight` VALUES ('489','2018-12-06 17:06:19','255','1415','285.89','35','38','68') ; 
INSERT INTO `flight` VALUES ('490','2018-12-06 10:39:17','500','2777','353.26','231','68','65') ; 
INSERT INTO `flight` VALUES ('491','2018-12-06 16:48:35','49','271','39.57','93','68','67') ; 
INSERT INTO `flight` VALUES ('492','2018-12-06 19:52:38','181','1003','152.75','224','37','93') ; 
INSERT INTO `flight` VALUES ('493','2018-12-06 18:36:29','129','715','111.52','28','93','6') ; 
INSERT INTO `flight` VALUES ('494','2018-12-06 20:40:27','523','2906','360.58','146','118','65') ; 
INSERT INTO `flight` VALUES ('495','2018-12-06 05:03:23','520','2887','382.77','253','65','116') ; 
INSERT INTO `flight` VALUES ('496','2018-12-06 18:12:53','102','566','114.67','218','118','67') ; 
INSERT INTO `flight` VALUES ('497','2018-12-06 07:40:33','378','2100','204.05','74','116','93') ; 
INSERT INTO `flight` VALUES ('498','2018-12-06 17:27:41','485','2693','393.96','114','6','116') ; 
INSERT INTO `flight` VALUES ('499','2018-12-06 09:54:40','69','381','66.53','11','118','68') ; 
INSERT INTO `flight` VALUES ('500','2018-12-06 06:18:21','523','2906','477.93','31','65','118') ; 
INSERT INTO `flight` VALUES ('501','2018-12-06 17:54:19','445','2472','333.83','155','6','118') ; 
INSERT INTO `flight` VALUES ('502','2018-12-06 11:23:24','314','1747','335.92','51','67','93') ; 
INSERT INTO `flight` VALUES ('503','2018-12-06 23:20:42','513','2851','429.58','19','26','116') ; 
INSERT INTO `flight` VALUES ('504','2018-12-06 01:47:38','489','2716','329.20','145','26','118') ; 
INSERT INTO `flight` VALUES ('505','2018-12-06 00:06:26','167','929','130.73','126','38','93') ; 
INSERT INTO `flight` VALUES ('506','2018-12-06 03:15:46','363','2015','359.77','216','68','93') ; 
INSERT INTO `flight` VALUES ('507','2018-12-06 06:41:46','135','749','138.04','54','93','26') ; 
INSERT INTO `flight` VALUES ('508','2018-12-06 23:22:44','159','881','130.51','53','65','6') ; 
INSERT INTO `flight` VALUES ('509','2018-12-06 00:07:56','239','1327','242.85','159','37','116') ; 
INSERT INTO `flight` VALUES ('510','2018-12-06 16:40:09','228','1268','186.23','77','37','118') ; 
INSERT INTO `flight` VALUES ('511','2018-12-06 00:32:18','44','244','29.58','100','26','6') ; 
INSERT INTO `flight` VALUES ('512','2018-12-06 01:27:29','146','809','172.22','115','116','118') ; 
INSERT INTO `flight` VALUES ('513','2018-12-06 18:44:12','384','2131','355.82','90','118','93') ; 
INSERT INTO `flight` VALUES ('514','2018-12-06 07:26:24','226','1253','136.72','92','67','116') ; 
INSERT INTO `flight` VALUES ('515','2018-12-06 20:28:29','102','566','118.80','88','67','118') ; 
INSERT INTO `flight` VALUES ('516','2018-12-06 05:46:06','181','1003','151.03','138','93','37') ; 
INSERT INTO `flight` VALUES ('517','2018-12-06 21:30:30','167','929','78.43','178','93','38') ; 
INSERT INTO `flight` VALUES ('518','2018-12-06 21:29:53','393','2184','394.61','105','38','116') ; 
INSERT INTO `flight` VALUES ('519','2018-12-06 20:57:12','308','1712','194.45','161','38','118') ; 
INSERT INTO `flight` VALUES ('520','2018-12-06 09:33:32','254','1409','192.82','28','37','6') ; 
INSERT INTO `flight` VALUES ('521','2018-12-06 09:24:11','116','643','62.46','228','65','26') ; 
INSERT INTO `flight` VALUES ('522','2018-12-06 07:22:46','44','244','26.67','51','6','26') ; 
INSERT INTO `flight` VALUES ('523','2018-12-06 17:37:00','205','1137','184.50','13','68','116') ; 
INSERT INTO `flight` VALUES ('524','2018-12-06 17:38:21','69','381','44.30','157','68','118') ; 
INSERT INTO `flight` VALUES ('525','2018-12-06 05:52:27','485','2693','500.77','217','116','6') ; 
INSERT INTO `flight` VALUES ('526','2018-12-06 17:31:37','354','1965','307.52','175','67','6') ; 
INSERT INTO `flight` VALUES ('527','2018-12-06 18:00:18','320','1778','295.19','32','65','37') ; 
INSERT INTO `flight` VALUES ('528','2018-12-06 06:31:05','146','809','132.12','76','118','116') ; 
INSERT INTO `flight` VALUES ('529','2018-12-06 18:55:00','254','1409','305.75','242','6','37') ; 
INSERT INTO `flight` VALUES ('530','2018-12-06 08:42:42','282','1566','293.55','1','65','38') ; 
INSERT INTO `flight` VALUES ('531','2018-12-06 16:32:52','145','803','102.39','34','6','38') ; 
INSERT INTO `flight` VALUES ('532','2018-12-06 07:31:12','145','803','108.35','105','38','6') ; 
INSERT INTO `flight` VALUES ('533','2018-12-06 11:38:12','283','1570','297.84','46','26','37') ; 
INSERT INTO `flight` VALUES ('534','2018-12-06 04:57:29','189','1049','169.91','78','26','38') ; 
INSERT INTO `flight` VALUES ('535','2018-12-06 19:15:56','392','2176','298.05','227','68','6') ; 
INSERT INTO `flight` VALUES ('536','2018-12-06 22:50:18','142','789','107.40','163','93','65') ; 
INSERT INTO `flight` VALUES ('537','2018-12-06 01:40:18','283','1570','333.82','12','37','26') ; 
INSERT INTO `flight` VALUES ('538','2018-12-06 14:33:50','314','1747','363.95','144','93','67') ; 
INSERT INTO `flight` VALUES ('539','2018-12-06 16:34:45','363','2015','288.36','205','93','68') ; 
INSERT INTO `flight` VALUES ('540','2018-12-06 13:13:25','513','2851','481.85','123','116','26') ; 
INSERT INTO `flight` VALUES ('541','2018-12-07 09:59:16','397','2208','349.54','114','67','26') ; 
INSERT INTO `flight` VALUES ('542','2018-12-07 03:51:11','445','2472','289.03','5','118','6') ; 
INSERT INTO `flight` VALUES ('543','2018-12-07 18:22:19','156','867','112.41','220','37','38') ; 
INSERT INTO `flight` VALUES ('544','2018-12-07 07:41:36','189','1049','130.46','184','38','26') ; 
INSERT INTO `flight` VALUES ('545','2018-12-07 20:57:22','239','1327','183.50','234','116','37') ; 
INSERT INTO `flight` VALUES ('546','2018-12-07 10:48:17','393','2184','338.89','124','116','38') ; 
INSERT INTO `flight` VALUES ('547','2018-12-07 10:14:25','135','748','87.29','91','67','37') ; 
INSERT INTO `flight` VALUES ('548','2018-12-07 08:28:38','217','1203','158.80','10','67','38') ; 
INSERT INTO `flight` VALUES ('549','2018-12-07 08:39:03','435','2419','298.37','82','68','26') ; 
INSERT INTO `flight` VALUES ('550','2018-12-07 20:28:54','159','881','155.99','214','6','65') ; 
INSERT INTO `flight` VALUES ('551','2018-12-07 15:15:59','454','2523','482.06','146','65','67') ; 
INSERT INTO `flight` VALUES ('552','2018-12-07 12:49:42','354','1965','377.34','144','6','67') ; 
INSERT INTO `flight` VALUES ('553','2018-12-07 01:37:25','500','2777','399.20','22','65','68') ; 
INSERT INTO `flight` VALUES ('554','2018-12-07 17:02:35','392','2176','264.55','108','6','68') ; 
INSERT INTO `flight` VALUES ('555','2018-12-07 15:35:07','156','867','143.89','88','38','37') ; 
INSERT INTO `flight` VALUES ('556','2018-12-07 11:04:39','116','643','95.04','134','26','65') ; 
INSERT INTO `flight` VALUES ('557','2018-12-07 03:36:42','397','2208','327.29','168','26','67') ; 
INSERT INTO `flight` VALUES ('558','2018-12-07 14:01:52','435','2419','300.84','64','26','68') ; 
INSERT INTO `flight` VALUES ('559','2018-12-07 05:27:23','489','2716','497.27','109','118','26') ; 
INSERT INTO `flight` VALUES ('560','2018-12-07 09:08:53','183','1016','103.28','133','68','37') ; 
INSERT INTO `flight` VALUES ('561','2018-12-07 23:05:53','255','1415','218.22','53','68','38') ; 
INSERT INTO `flight` VALUES ('562','2018-12-07 01:53:09','320','1778','292.87','186','37','65') ; 
INSERT INTO `flight` VALUES ('563','2018-12-07 02:52:25','228','1268','176.81','49','118','37') ; 
INSERT INTO `flight` VALUES ('564','2018-12-07 05:21:29','135','748','118.57','149','37','67') ; 
INSERT INTO `flight` VALUES ('565','2018-12-07 10:02:56','308','1712','255.93','28','118','38') ; 
INSERT INTO `flight` VALUES ('566','2018-12-07 21:05:09','183','1016','143.11','21','37','68') ; 
INSERT INTO `flight` VALUES ('567','2018-12-07 14:33:31','520','2887','398.44','133','116','65') ; 
INSERT INTO `flight` VALUES ('568','2018-12-07 06:26:14','226','1253','180.94','242','116','67') ; 
INSERT INTO `flight` VALUES ('569','2018-12-07 05:26:33','454','2523','405.92','178','67','65') ; 
INSERT INTO `flight` VALUES ('570','2018-12-07 17:54:53','205','1137','163.14','226','116','68') ; 
INSERT INTO `flight` VALUES ('571','2018-12-07 17:30:04','142','789','102.55','42','65','93') ; 
INSERT INTO `flight` VALUES ('572','2018-12-07 17:36:40','129','715','112.79','221','6','93') ; 
INSERT INTO `flight` VALUES ('573','2018-12-07 06:48:38','49','271','48.00','82','67','68') ; 
INSERT INTO `flight` VALUES ('574','2018-12-07 20:51:02','378','2100','263.63','110','93','116') ; 
INSERT INTO `flight` VALUES ('575','2018-12-07 02:45:43','384','2131','369.46','260','93','118') ; 
INSERT INTO `flight` VALUES ('576','2018-12-07 06:29:23','282','1566','223.50','256','38','65') ; 
INSERT INTO `flight` VALUES ('577','2018-12-07 10:03:11','135','749','131.92','245','26','93') ; 
INSERT INTO `flight` VALUES ('578','2018-12-07 04:17:21','217','1203','144.64','111','38','67') ; 
INSERT INTO `flight` VALUES ('579','2018-12-07 03:05:11','255','1415','248.38','14','38','68') ; 
INSERT INTO `flight` VALUES ('580','2018-12-07 18:17:21','500','2777','346.07','83','68','65') ; 
INSERT INTO `flight` VALUES ('581','2018-12-07 19:53:56','49','271','32.83','77','68','67') ; 
INSERT INTO `flight` VALUES ('582','2018-12-07 12:01:08','181','1003','184.75','128','37','93') ; 
INSERT INTO `flight` VALUES ('583','2018-12-07 22:21:32','129','715','137.90','159','93','6') ; 
INSERT INTO `flight` VALUES ('584','2018-12-07 23:34:04','523','2906','421.84','131','118','65') ; 
INSERT INTO `flight` VALUES ('585','2018-12-07 05:28:24','520','2887','450.50','117','65','116') ; 
INSERT INTO `flight` VALUES ('586','2018-12-07 12:12:22','102','566','105.93','190','118','67') ; 
INSERT INTO `flight` VALUES ('587','2018-12-07 16:03:51','378','2100','208.78','63','116','93') ; 
INSERT INTO `flight` VALUES ('588','2018-12-07 07:35:15','485','2693','506.48','78','6','116') ; 
INSERT INTO `flight` VALUES ('589','2018-12-07 15:23:50','69','381','50.67','141','118','68') ; 
INSERT INTO `flight` VALUES ('590','2018-12-07 18:38:08','523','2906','465.34','183','65','118') ; 
INSERT INTO `flight` VALUES ('591','2018-12-07 17:30:28','445','2472','372.74','91','6','118') ; 
INSERT INTO `flight` VALUES ('592','2018-12-07 15:54:44','314','1747','253.58','151','67','93') ; 
INSERT INTO `flight` VALUES ('593','2018-12-07 17:30:55','513','2851','565.30','71','26','116') ; 
INSERT INTO `flight` VALUES ('594','2018-12-07 14:49:08','489','2716','318.71','92','26','118') ; 
INSERT INTO `flight` VALUES ('595','2018-12-07 21:11:25','167','929','115.25','119','38','93') ; 
INSERT INTO `flight` VALUES ('596','2018-12-07 07:35:40','363','2015','279.20','123','68','93') ; 
INSERT INTO `flight` VALUES ('597','2018-12-07 10:41:12','135','749','115.31','76','93','26') ; 
INSERT INTO `flight` VALUES ('598','2018-12-07 04:22:55','159','881','142.02','102','65','6') ; 
INSERT INTO `flight` VALUES ('599','2018-12-07 11:34:50','239','1327','193.35','232','37','116') ; 
INSERT INTO `flight` VALUES ('600','2018-12-07 23:19:31','228','1268','216.80','56','37','118') ; 
INSERT INTO `flight` VALUES ('601','2018-12-07 12:43:22','44','244','29.41','15','26','6') ; 
INSERT INTO `flight` VALUES ('602','2018-12-07 17:35:02','146','809','150.59','140','116','118') ; 
INSERT INTO `flight` VALUES ('603','2018-12-07 13:03:58','384','2131','366.62','201','118','93') ; 
INSERT INTO `flight` VALUES ('604','2018-12-07 09:07:08','226','1253','164.29','191','67','116') ; 
INSERT INTO `flight` VALUES ('605','2018-12-07 07:47:41','102','566','127.20','176','67','118') ; 
INSERT INTO `flight` VALUES ('606','2018-12-07 02:43:03','181','1003','146.34','154','93','37') ; 
INSERT INTO `flight` VALUES ('607','2018-12-07 10:32:36','167','929','80.48','73','93','38') ; 
INSERT INTO `flight` VALUES ('608','2018-12-07 21:01:31','393','2184','325.12','28','38','116') ; 
INSERT INTO `flight` VALUES ('609','2018-12-07 02:53:44','308','1712','199.34','164','38','118') ; 
INSERT INTO `flight` VALUES ('610','2018-12-07 02:30:21','254','1409','218.76','136','37','6') ; 
INSERT INTO `flight` VALUES ('611','2018-12-07 15:20:02','116','643','71.15','130','65','26') ; 
INSERT INTO `flight` VALUES ('612','2018-12-07 06:30:16','44','244','29.79','8','6','26') ; 
INSERT INTO `flight` VALUES ('613','2018-12-07 11:07:52','205','1137','209.39','141','68','116') ; 
INSERT INTO `flight` VALUES ('614','2018-12-07 23:09:12','69','381','55.67','225','68','118') ; 
INSERT INTO `flight` VALUES ('615','2018-12-07 10:21:04','485','2693','524.91','72','116','6') ; 
INSERT INTO `flight` VALUES ('616','2018-12-07 04:04:29','354','1965','283.53','262','67','6') ; 
INSERT INTO `flight` VALUES ('617','2018-12-07 15:36:16','320','1778','365.09','180','65','37') ; 
INSERT INTO `flight` VALUES ('618','2018-12-07 02:42:51','146','809','127.55','69','118','116') ; 
INSERT INTO `flight` VALUES ('619','2018-12-07 07:26:24','254','1409','317.98','3','6','37') ; 
INSERT INTO `flight` VALUES ('620','2018-12-07 09:47:37','282','1566','269.91','158','65','38') ; 
INSERT INTO `flight` VALUES ('621','2018-12-07 03:56:04','145','803','92.75','199','6','38') ; 
INSERT INTO `flight` VALUES ('622','2018-12-07 06:26:31','145','803','109.41','232','38','6') ; 
INSERT INTO `flight` VALUES ('623','2018-12-07 15:21:08','283','1570','224.20','23','26','37') ; 
INSERT INTO `flight` VALUES ('624','2018-12-07 15:39:15','189','1049','167.87','17','26','38') ; 
INSERT INTO `flight` VALUES ('625','2018-12-07 03:06:36','392','2176','368.81','118','68','6') ; 
INSERT INTO `flight` VALUES ('626','2018-12-07 05:22:01','142','789','89.82','182','93','65') ; 
INSERT INTO `flight` VALUES ('627','2018-12-07 22:57:31','283','1570','337.95','225','37','26') ; 
INSERT INTO `flight` VALUES ('628','2018-12-07 06:03:03','314','1747','357.29','213','93','67') ; 
INSERT INTO `flight` VALUES ('629','2018-12-07 18:20:49','363','2015','362.50','143','93','68') ; 
INSERT INTO `flight` VALUES ('630','2018-12-07 00:35:38','513','2851','401.73','244','116','26') ; 
INSERT INTO `flight` VALUES ('631','2018-12-08 07:57:20','397','2208','402.38','93','67','26') ; 
INSERT INTO `flight` VALUES ('632','2018-12-08 05:35:35','445','2472','329.43','262','118','6') ; 
INSERT INTO `flight` VALUES ('633','2018-12-08 11:30:22','156','867','116.22','180','37','38') ; 
INSERT INTO `flight` VALUES ('634','2018-12-08 15:45:39','189','1049','125.96','73','38','26') ; 
INSERT INTO `flight` VALUES ('635','2018-12-08 00:25:16','239','1327','223.25','114','116','37') ; 
INSERT INTO `flight` VALUES ('636','2018-12-08 00:44:31','393','2184','324.76','58','116','38') ; 
INSERT INTO `flight` VALUES ('637','2018-12-08 17:10:28','135','748','86.34','5','67','37') ; 
INSERT INTO `flight` VALUES ('638','2018-12-08 11:42:54','217','1203','153.81','99','67','38') ; 
INSERT INTO `flight` VALUES ('639','2018-12-08 23:18:08','435','2419','299.74','66','68','26') ; 
INSERT INTO `flight` VALUES ('640','2018-12-08 15:09:17','159','881','139.07','178','6','65') ; 
INSERT INTO `flight` VALUES ('641','2018-12-08 12:15:29','454','2523','343.46','202','65','67') ; 
INSERT INTO `flight` VALUES ('642','2018-12-08 08:12:10','354','1965','324.41','243','6','67') ; 
INSERT INTO `flight` VALUES ('643','2018-12-08 09:53:04','500','2777','559.68','101','65','68') ; 
INSERT INTO `flight` VALUES ('644','2018-12-08 05:15:02','392','2176','293.04','97','6','68') ; 
INSERT INTO `flight` VALUES ('645','2018-12-08 03:45:39','156','867','153.51','4','38','37') ; 
INSERT INTO `flight` VALUES ('646','2018-12-08 09:26:25','116','643','71.10','5','26','65') ; 
INSERT INTO `flight` VALUES ('647','2018-12-08 00:39:28','397','2208','374.82','23','26','67') ; 
INSERT INTO `flight` VALUES ('648','2018-12-08 15:23:39','435','2419','343.53','58','26','68') ; 
INSERT INTO `flight` VALUES ('649','2018-12-08 12:48:18','489','2716','529.48','14','118','26') ; 
INSERT INTO `flight` VALUES ('650','2018-12-08 16:29:02','183','1016','133.02','111','68','37') ; 
INSERT INTO `flight` VALUES ('651','2018-12-08 16:03:56','255','1415','237.13','67','68','38') ; 
INSERT INTO `flight` VALUES ('652','2018-12-08 18:19:46','320','1778','260.82','81','37','65') ; 
INSERT INTO `flight` VALUES ('653','2018-12-08 11:44:15','228','1268','217.73','84','118','37') ; 
INSERT INTO `flight` VALUES ('654','2018-12-08 02:47:33','135','748','125.48','122','37','67') ; 
INSERT INTO `flight` VALUES ('655','2018-12-08 14:10:44','308','1712','258.72','61','118','38') ; 
INSERT INTO `flight` VALUES ('656','2018-12-08 20:40:40','183','1016','146.14','215','37','68') ; 
INSERT INTO `flight` VALUES ('657','2018-12-08 16:45:41','520','2887','471.93','155','116','65') ; 
INSERT INTO `flight` VALUES ('658','2018-12-08 08:54:39','226','1253','159.53','217','116','67') ; 
INSERT INTO `flight` VALUES ('659','2018-12-08 14:00:55','454','2523','387.20','83','67','65') ; 
INSERT INTO `flight` VALUES ('660','2018-12-08 03:30:05','205','1137','186.16','123','116','68') ; 
INSERT INTO `flight` VALUES ('661','2018-12-08 20:53:56','142','789','128.83','41','65','93') ; 
INSERT INTO `flight` VALUES ('662','2018-12-08 03:14:47','129','715','120.03','66','6','93') ; 
INSERT INTO `flight` VALUES ('663','2018-12-08 14:48:19','49','271','41.99','132','67','68') ; 
INSERT INTO `flight` VALUES ('664','2018-12-08 13:29:31','378','2100','238.35','234','93','116') ; 
INSERT INTO `flight` VALUES ('665','2018-12-08 10:16:42','384','2131','262.40','63','93','118') ; 
INSERT INTO `flight` VALUES ('666','2018-12-08 00:34:10','282','1566','236.79','207','38','65') ; 
INSERT INTO `flight` VALUES ('667','2018-12-08 01:59:47','135','749','148.59','154','26','93') ; 
INSERT INTO `flight` VALUES ('668','2018-12-08 09:22:24','217','1203','196.61','48','38','67') ; 
INSERT INTO `flight` VALUES ('669','2018-12-08 15:29:59','255','1415','237.36','218','38','68') ; 
INSERT INTO `flight` VALUES ('670','2018-12-08 00:52:50','500','2777','454.96','168','68','65') ; 
INSERT INTO `flight` VALUES ('671','2018-12-08 11:11:28','49','271','35.18','46','68','67') ; 
INSERT INTO `flight` VALUES ('672','2018-12-08 06:45:34','181','1003','167.34','110','37','93') ; 
INSERT INTO `flight` VALUES ('673','2018-12-08 09:06:09','129','715','147.19','212','93','6') ; 
INSERT INTO `flight` VALUES ('674','2018-12-08 10:07:22','523','2906','450.76','50','118','65') ; 
INSERT INTO `flight` VALUES ('675','2018-12-08 00:56:37','520','2887','351.20','1','65','116') ; 
INSERT INTO `flight` VALUES ('676','2018-12-08 18:50:25','102','566','97.38','248','118','67') ; 
INSERT INTO `flight` VALUES ('677','2018-12-08 16:50:36','378','2100','193.35','105','116','93') ; 
INSERT INTO `flight` VALUES ('678','2018-12-08 04:11:57','485','2693','439.59','124','6','116') ; 
INSERT INTO `flight` VALUES ('679','2018-12-08 12:47:37','69','381','54.18','208','118','68') ; 
INSERT INTO `flight` VALUES ('680','2018-12-08 11:21:18','523','2906','491.69','90','65','118') ; 
INSERT INTO `flight` VALUES ('681','2018-12-08 23:34:34','445','2472','324.25','177','6','118') ; 
INSERT INTO `flight` VALUES ('682','2018-12-08 13:54:41','314','1747','258.80','253','67','93') ; 
INSERT INTO `flight` VALUES ('683','2018-12-08 22:08:37','513','2851','481.27','210','26','116') ; 
INSERT INTO `flight` VALUES ('684','2018-12-08 15:34:55','489','2716','388.18','146','26','118') ; 
INSERT INTO `flight` VALUES ('685','2018-12-08 03:10:16','167','929','122.39','194','38','93') ; 
INSERT INTO `flight` VALUES ('686','2018-12-08 22:48:58','363','2015','348.54','121','68','93') ; 
INSERT INTO `flight` VALUES ('687','2018-12-08 05:46:44','135','749','124.95','95','93','26') ; 
INSERT INTO `flight` VALUES ('688','2018-12-08 01:21:06','159','881','168.06','88','65','6') ; 
INSERT INTO `flight` VALUES ('689','2018-12-08 03:59:55','239','1327','199.95','90','37','116') ; 
INSERT INTO `flight` VALUES ('690','2018-12-08 12:21:55','228','1268','210.91','59','37','118') ; 
INSERT INTO `flight` VALUES ('691','2018-12-08 13:24:23','44','244','26.85','55','26','6') ; 
INSERT INTO `flight` VALUES ('692','2018-12-08 04:40:41','146','809','159.82','227','116','118') ; 
INSERT INTO `flight` VALUES ('693','2018-12-08 16:57:06','384','2131','298.03','199','118','93') ; 
INSERT INTO `flight` VALUES ('694','2018-12-08 02:00:01','226','1253','175.19','213','67','116') ; 
INSERT INTO `flight` VALUES ('695','2018-12-08 03:19:46','102','566','103.06','195','67','118') ; 
INSERT INTO `flight` VALUES ('696','2018-12-08 05:33:03','181','1003','166.38','167','93','37') ; 
INSERT INTO `flight` VALUES ('697','2018-12-08 19:41:39','167','929','84.35','29','93','38') ; 
INSERT INTO `flight` VALUES ('698','2018-12-08 06:12:00','393','2184','309.51','137','38','116') ; 
INSERT INTO `flight` VALUES ('699','2018-12-08 11:36:56','308','1712','254.50','168','38','118') ; 
INSERT INTO `flight` VALUES ('700','2018-12-08 13:09:28','254','1409','260.73','140','37','6') ; 
INSERT INTO `flight` VALUES ('701','2018-12-08 03:12:47','116','643','59.79','243','65','26') ; 
INSERT INTO `flight` VALUES ('702','2018-12-08 06:24:39','44','244','28.65','74','6','26') ; 
INSERT INTO `flight` VALUES ('703','2018-12-08 09:24:51','205','1137','164.64','7','68','116') ; 
INSERT INTO `flight` VALUES ('704','2018-12-08 05:46:38','69','381','49.33','101','68','118') ; 
INSERT INTO `flight` VALUES ('705','2018-12-08 14:57:09','485','2693','569.15','125','116','6') ; 
INSERT INTO `flight` VALUES ('706','2018-12-08 06:20:21','354','1965','369.68','89','67','6') ; 
INSERT INTO `flight` VALUES ('707','2018-12-08 10:26:10','320','1778','318.43','229','65','37') ; 
INSERT INTO `flight` VALUES ('708','2018-12-08 06:56:30','146','809','120.81','147','118','116') ; 
INSERT INTO `flight` VALUES ('709','2018-12-08 20:26:43','254','1409','278.50','208','6','37') ; 
INSERT INTO `flight` VALUES ('710','2018-12-08 02:31:19','282','1566','252.76','47','65','38') ; 
INSERT INTO `flight` VALUES ('711','2018-12-08 21:41:18','145','803','112.49','233','6','38') ; 
INSERT INTO `flight` VALUES ('712','2018-12-08 05:00:49','145','803','91.52','180','38','6') ; 
INSERT INTO `flight` VALUES ('713','2018-12-08 21:08:12','283','1570','272.85','239','26','37') ; 
INSERT INTO `flight` VALUES ('714','2018-12-08 01:44:34','189','1049','147.10','77','26','38') ; 
INSERT INTO `flight` VALUES ('715','2018-12-08 09:24:16','392','2176','424.12','236','68','6') ; 
INSERT INTO `flight` VALUES ('716','2018-12-08 20:46:31','142','789','100.87','70','93','65') ; 
INSERT INTO `flight` VALUES ('717','2018-12-08 06:00:28','283','1570','294.25','224','37','26') ; 
INSERT INTO `flight` VALUES ('718','2018-12-08 05:14:13','314','1747','363.44','69','93','67') ; 
INSERT INTO `flight` VALUES ('719','2018-12-08 06:43:02','363','2015','333.67','257','93','68') ; 
INSERT INTO `flight` VALUES ('720','2018-12-08 14:22:31','513','2851','453.15','142','116','26') ; 
INSERT INTO `flight` VALUES ('721','2018-12-09 06:55:13','397','2208','366.74','213','67','26') ; 
INSERT INTO `flight` VALUES ('722','2018-12-09 00:58:40','445','2472','268.53','248','118','6') ; 
INSERT INTO `flight` VALUES ('723','2018-12-09 18:33:53','156','867','157.65','92','37','38') ; 
INSERT INTO `flight` VALUES ('724','2018-12-09 20:00:38','189','1049','140.24','80','38','26') ; 
INSERT INTO `flight` VALUES ('725','2018-12-09 09:59:10','239','1327','200.53','127','116','37') ; 
INSERT INTO `flight` VALUES ('726','2018-12-09 22:46:53','393','2184','352.55','238','116','38') ; 
INSERT INTO `flight` VALUES ('727','2018-12-09 09:51:53','135','748','120.35','36','67','37') ; 
INSERT INTO `flight` VALUES ('728','2018-12-09 17:23:05','217','1203','135.49','19','67','38') ; 
INSERT INTO `flight` VALUES ('729','2018-12-09 23:45:29','435','2419','350.17','157','68','26') ; 
INSERT INTO `flight` VALUES ('730','2018-12-09 10:57:11','159','881','141.09','7','6','65') ; 
INSERT INTO `flight` VALUES ('731','2018-12-09 14:25:13','454','2523','448.06','190','65','67') ; 
INSERT INTO `flight` VALUES ('732','2018-12-09 01:58:45','354','1965','367.60','50','6','67') ; 
INSERT INTO `flight` VALUES ('733','2018-12-09 08:47:43','500','2777','398.13','22','65','68') ; 
INSERT INTO `flight` VALUES ('734','2018-12-09 10:46:54','392','2176','292.97','63','6','68') ; 
INSERT INTO `flight` VALUES ('735','2018-12-09 19:14:46','156','867','122.43','56','38','37') ; 
INSERT INTO `flight` VALUES ('736','2018-12-09 15:48:51','116','643','73.64','146','26','65') ; 
INSERT INTO `flight` VALUES ('737','2018-12-09 22:33:26','397','2208','338.11','213','26','67') ; 
INSERT INTO `flight` VALUES ('738','2018-12-09 05:37:29','435','2419','289.32','257','26','68') ; 
INSERT INTO `flight` VALUES ('739','2018-12-09 01:06:49','489','2716','451.08','110','118','26') ; 
INSERT INTO `flight` VALUES ('740','2018-12-09 19:58:31','183','1016','107.31','9','68','37') ; 
INSERT INTO `flight` VALUES ('741','2018-12-09 15:38:31','255','1415','240.85','103','68','38') ; 
INSERT INTO `flight` VALUES ('742','2018-12-09 13:56:48','320','1778','266.87','119','37','65') ; 
INSERT INTO `flight` VALUES ('743','2018-12-09 21:45:55','228','1268','172.66','173','118','37') ; 
INSERT INTO `flight` VALUES ('744','2018-12-09 18:27:37','135','748','119.43','141','37','67') ; 
INSERT INTO `flight` VALUES ('745','2018-12-09 05:28:10','308','1712','252.00','109','118','38') ; 
INSERT INTO `flight` VALUES ('746','2018-12-09 06:19:38','183','1016','129.69','168','37','68') ; 
INSERT INTO `flight` VALUES ('747','2018-12-09 01:08:01','520','2887','466.82','173','116','65') ; 
INSERT INTO `flight` VALUES ('748','2018-12-09 00:55:14','226','1253','185.07','135','116','67') ; 
INSERT INTO `flight` VALUES ('749','2018-12-09 04:47:17','454','2523','404.92','35','67','65') ; 
INSERT INTO `flight` VALUES ('750','2018-12-09 04:23:20','205','1137','202.30','247','116','68') ; 
INSERT INTO `flight` VALUES ('751','2018-12-09 22:15:01','142','789','131.02','39','65','93') ; 
INSERT INTO `flight` VALUES ('752','2018-12-09 09:22:23','129','715','100.25','144','6','93') ; 
INSERT INTO `flight` VALUES ('753','2018-12-09 17:10:05','49','271','37.47','115','67','68') ; 
INSERT INTO `flight` VALUES ('754','2018-12-09 02:10:38','378','2100','290.99','240','93','116') ; 
INSERT INTO `flight` VALUES ('755','2018-12-09 09:53:00','384','2131','311.75','78','93','118') ; 
INSERT INTO `flight` VALUES ('756','2018-12-09 16:11:58','282','1566','304.15','133','38','65') ; 
INSERT INTO `flight` VALUES ('757','2018-12-09 09:30:38','135','749','119.89','209','26','93') ; 
INSERT INTO `flight` VALUES ('758','2018-12-09 21:32:12','217','1203','205.13','231','38','67') ; 
INSERT INTO `flight` VALUES ('759','2018-12-09 07:41:46','255','1415','215.66','230','38','68') ; 
INSERT INTO `flight` VALUES ('760','2018-12-09 09:54:59','500','2777','433.05','79','68','65') ; 
INSERT INTO `flight` VALUES ('761','2018-12-09 22:28:41','49','271','43.54','81','68','67') ; 
INSERT INTO `flight` VALUES ('762','2018-12-09 15:33:03','181','1003','162.18','65','37','93') ; 
INSERT INTO `flight` VALUES ('763','2018-12-09 20:33:57','129','715','134.99','65','93','6') ; 
INSERT INTO `flight` VALUES ('764','2018-12-09 19:31:00','523','2906','382.94','16','118','65') ; 
INSERT INTO `flight` VALUES ('765','2018-12-09 16:56:50','520','2887','400.68','236','65','116') ; 
INSERT INTO `flight` VALUES ('766','2018-12-09 15:29:38','102','566','86.76','86','118','67') ; 
INSERT INTO `flight` VALUES ('767','2018-12-09 18:58:15','378','2100','280.38','99','116','93') ; 
INSERT INTO `flight` VALUES ('768','2018-12-09 07:42:46','485','2693','498.26','87','6','116') ; 
INSERT INTO `flight` VALUES ('769','2018-12-09 07:21:45','69','381','69.84','162','118','68') ; 
INSERT INTO `flight` VALUES ('770','2018-12-09 23:00:17','523','2906','369.26','76','65','118') ; 
INSERT INTO `flight` VALUES ('771','2018-12-09 03:05:06','445','2472','303.53','126','6','118') ; 
INSERT INTO `flight` VALUES ('772','2018-12-09 11:02:21','314','1747','304.04','47','67','93') ; 
INSERT INTO `flight` VALUES ('773','2018-12-09 08:54:37','513','2851','422.69','125','26','116') ; 
INSERT INTO `flight` VALUES ('774','2018-12-09 11:36:28','489','2716','417.44','208','26','118') ; 
INSERT INTO `flight` VALUES ('775','2018-12-09 12:18:32','167','929','112.98','89','38','93') ; 
INSERT INTO `flight` VALUES ('776','2018-12-09 10:22:34','363','2015','338.23','135','68','93') ; 
INSERT INTO `flight` VALUES ('777','2018-12-09 21:20:00','135','749','127.63','233','93','26') ; 
INSERT INTO `flight` VALUES ('778','2018-12-09 01:48:44','159','881','132.27','47','65','6') ; 
INSERT INTO `flight` VALUES ('779','2018-12-09 20:07:56','239','1327','242.91','54','37','116') ; 
INSERT INTO `flight` VALUES ('780','2018-12-09 11:22:21','228','1268','205.10','93','37','118') ; 
INSERT INTO `flight` VALUES ('781','2018-12-09 13:44:56','44','244','33.11','35','26','6') ; 
INSERT INTO `flight` VALUES ('782','2018-12-09 15:45:50','146','809','143.22','11','116','118') ; 
INSERT INTO `flight` VALUES ('783','2018-12-09 01:24:51','384','2131','355.62','43','118','93') ; 
INSERT INTO `flight` VALUES ('784','2018-12-09 19:44:09','226','1253','136.73','57','67','116') ; 
INSERT INTO `flight` VALUES ('785','2018-12-09 18:22:00','102','566','104.63','223','67','118') ; 
INSERT INTO `flight` VALUES ('786','2018-12-09 13:37:12','181','1003','166.42','40','93','37') ; 
INSERT INTO `flight` VALUES ('787','2018-12-09 02:24:42','167','929','94.15','30','93','38') ; 
INSERT INTO `flight` VALUES ('788','2018-12-09 17:23:08','393','2184','419.67','14','38','116') ; 
INSERT INTO `flight` VALUES ('789','2018-12-09 18:44:36','308','1712','208.08','48','38','118') ; 
INSERT INTO `flight` VALUES ('790','2018-12-09 00:07:21','254','1409','248.16','143','37','6') ; 
INSERT INTO `flight` VALUES ('791','2018-12-09 17:43:42','116','643','84.74','257','65','26') ; 
INSERT INTO `flight` VALUES ('792','2018-12-09 05:35:39','44','244','37.72','86','6','26') ; 
INSERT INTO `flight` VALUES ('793','2018-12-09 14:13:15','205','1137','218.85','176','68','116') ; 
INSERT INTO `flight` VALUES ('794','2018-12-09 00:06:41','69','381','48.64','90','68','118') ; 
INSERT INTO `flight` VALUES ('795','2018-12-09 16:20:58','485','2693','534.62','151','116','6') ; 
INSERT INTO `flight` VALUES ('796','2018-12-09 20:11:30','354','1965','303.71','27','67','6') ; 
INSERT INTO `flight` VALUES ('797','2018-12-09 15:41:26','320','1778','315.03','113','65','37') ; 
INSERT INTO `flight` VALUES ('798','2018-12-09 07:59:50','146','809','137.81','136','118','116') ; 
INSERT INTO `flight` VALUES ('799','2018-12-09 03:50:05','254','1409','224.63','182','6','37') ; 
INSERT INTO `flight` VALUES ('800','2018-12-09 04:20:30','282','1566','277.40','242','65','38') ; 
INSERT INTO `flight` VALUES ('801','2018-12-09 15:10:47','145','803','95.02','197','6','38') ; 
INSERT INTO `flight` VALUES ('802','2018-12-09 06:57:52','145','803','81.99','69','38','6') ; 
INSERT INTO `flight` VALUES ('803','2018-12-09 23:07:18','283','1570','305.29','53','26','37') ; 
INSERT INTO `flight` VALUES ('804','2018-12-09 10:52:44','189','1049','146.34','14','26','38') ; 
INSERT INTO `flight` VALUES ('805','2018-12-09 09:40:41','392','2176','427.41','218','68','6') ; 
INSERT INTO `flight` VALUES ('806','2018-12-09 02:57:54','142','789','104.87','223','93','65') ; 
INSERT INTO `flight` VALUES ('807','2018-12-09 17:55:08','283','1570','361.72','255','37','26') ; 
INSERT INTO `flight` VALUES ('808','2018-12-09 04:51:59','314','1747','379.75','54','93','67') ; 
INSERT INTO `flight` VALUES ('809','2018-12-09 12:13:21','363','2015','247.62','216','93','68') ; 
INSERT INTO `flight` VALUES ('810','2018-12-09 12:27:00','513','2851','351.80','4','116','26') ; 
INSERT INTO `flight` VALUES ('811','2018-12-10 01:43:32','397','2208','324.82','37','67','26') ; 
INSERT INTO `flight` VALUES ('812','2018-12-10 22:45:29','445','2472','336.14','121','118','6') ; 
INSERT INTO `flight` VALUES ('813','2018-12-10 00:17:29','156','867','156.58','253','37','38') ; 
INSERT INTO `flight` VALUES ('814','2018-12-10 21:23:05','189','1049','150.28','225','38','26') ; 
INSERT INTO `flight` VALUES ('815','2018-12-10 06:48:10','239','1327','239.34','103','116','37') ; 
INSERT INTO `flight` VALUES ('816','2018-12-10 11:26:26','393','2184','333.98','143','116','38') ; 
INSERT INTO `flight` VALUES ('817','2018-12-10 19:36:44','135','748','99.16','127','67','37') ; 
INSERT INTO `flight` VALUES ('818','2018-12-10 00:55:52','217','1203','193.15','239','67','38') ; 
INSERT INTO `flight` VALUES ('819','2018-12-10 16:17:26','435','2419','390.98','170','68','26') ; 
INSERT INTO `flight` VALUES ('820','2018-12-10 11:58:45','159','881','167.08','188','6','65') ; 
INSERT INTO `flight` VALUES ('821','2018-12-10 07:59:27','454','2523','377.77','246','65','67') ; 
INSERT INTO `flight` VALUES ('822','2018-12-10 19:57:16','354','1965','353.64','173','6','67') ; 
INSERT INTO `flight` VALUES ('823','2018-12-10 02:43:41','500','2777','473.46','227','65','68') ; 
INSERT INTO `flight` VALUES ('824','2018-12-10 18:51:26','392','2176','292.90','52','6','68') ; 
INSERT INTO `flight` VALUES ('825','2018-12-10 22:53:44','156','867','116.58','14','38','37') ; 
INSERT INTO `flight` VALUES ('826','2018-12-10 23:27:37','116','643','93.53','185','26','65') ; 
INSERT INTO `flight` VALUES ('827','2018-12-10 13:27:08','397','2208','342.18','225','26','67') ; 
INSERT INTO `flight` VALUES ('828','2018-12-10 14:47:40','435','2419','317.23','73','26','68') ; 
INSERT INTO `flight` VALUES ('829','2018-12-10 06:39:01','489','2716','428.24','91','118','26') ; 
INSERT INTO `flight` VALUES ('830','2018-12-10 00:35:04','183','1016','125.96','178','68','37') ; 
INSERT INTO `flight` VALUES ('831','2018-12-10 10:08:47','255','1415','215.83','18','68','38') ; 
INSERT INTO `flight` VALUES ('832','2018-12-10 07:48:27','320','1778','290.52','59','37','65') ; 
INSERT INTO `flight` VALUES ('833','2018-12-10 14:31:51','228','1268','218.64','62','118','37') ; 
INSERT INTO `flight` VALUES ('834','2018-12-10 15:53:41','135','748','140.22','113','37','67') ; 
INSERT INTO `flight` VALUES ('835','2018-12-10 12:12:34','308','1712','242.48','173','118','38') ; 
INSERT INTO `flight` VALUES ('836','2018-12-10 16:13:12','183','1016','119.50','114','37','68') ; 
INSERT INTO `flight` VALUES ('837','2018-12-10 04:25:24','520','2887','477.73','56','116','65') ; 
INSERT INTO `flight` VALUES ('838','2018-12-10 02:11:11','226','1253','155.05','207','116','67') ; 
INSERT INTO `flight` VALUES ('839','2018-12-10 07:53:48','454','2523','511.99','82','67','65') ; 
INSERT INTO `flight` VALUES ('840','2018-12-10 12:04:04','205','1137','170.90','34','116','68') ; 
INSERT INTO `flight` VALUES ('841','2018-12-10 09:20:25','142','789','99.65','127','65','93') ; 
INSERT INTO `flight` VALUES ('842','2018-12-10 05:27:46','129','715','106.72','72','6','93') ; 
INSERT INTO `flight` VALUES ('843','2018-12-10 01:42:35','49','271','46.89','7','67','68') ; 
INSERT INTO `flight` VALUES ('844','2018-12-10 11:34:30','378','2100','262.79','260','93','116') ; 
INSERT INTO `flight` VALUES ('845','2018-12-10 02:07:26','384','2131','321.05','87','93','118') ; 
INSERT INTO `flight` VALUES ('846','2018-12-10 18:08:41','282','1566','277.52','186','38','65') ; 
INSERT INTO `flight` VALUES ('847','2018-12-10 11:56:28','135','749','121.08','222','26','93') ; 
INSERT INTO `flight` VALUES ('848','2018-12-10 18:47:37','217','1203','184.70','126','38','67') ; 
INSERT INTO `flight` VALUES ('849','2018-12-10 20:28:50','255','1415','281.89','104','38','68') ; 
INSERT INTO `flight` VALUES ('850','2018-12-10 21:51:42','500','2777','451.49','21','68','65') ; 
INSERT INTO `flight` VALUES ('851','2018-12-10 04:43:12','49','271','39.99','114','68','67') ; 
INSERT INTO `flight` VALUES ('852','2018-12-10 10:21:38','181','1003','193.27','77','37','93') ; 
INSERT INTO `flight` VALUES ('853','2018-12-10 05:10:23','129','715','149.49','237','93','6') ; 
INSERT INTO `flight` VALUES ('854','2018-12-10 19:44:02','523','2906','343.58','226','118','65') ; 
INSERT INTO `flight` VALUES ('855','2018-12-10 21:40:40','520','2887','446.98','39','65','116') ; 
INSERT INTO `flight` VALUES ('856','2018-12-10 20:24:22','102','566','87.87','103','118','67') ; 
INSERT INTO `flight` VALUES ('857','2018-12-10 12:35:08','378','2100','220.18','50','116','93') ; 
INSERT INTO `flight` VALUES ('858','2018-12-10 09:27:43','485','2693','365.70','30','6','116') ; 
INSERT INTO `flight` VALUES ('859','2018-12-10 14:11:51','69','381','57.42','181','118','68') ; 
INSERT INTO `flight` VALUES ('860','2018-12-10 00:50:54','523','2906','398.05','67','65','118') ; 
INSERT INTO `flight` VALUES ('861','2018-12-10 22:31:11','445','2472','288.06','8','6','118') ; 
INSERT INTO `flight` VALUES ('862','2018-12-10 03:26:17','314','1747','338.96','208','67','93') ; 
INSERT INTO `flight` VALUES ('863','2018-12-10 19:42:18','513','2851','430.72','252','26','116') ; 
INSERT INTO `flight` VALUES ('864','2018-12-10 11:30:18','489','2716','473.85','87','26','118') ; 
INSERT INTO `flight` VALUES ('865','2018-12-10 03:09:52','167','929','136.33','176','38','93') ; 
INSERT INTO `flight` VALUES ('866','2018-12-10 08:27:39','363','2015','324.38','150','68','93') ; 
INSERT INTO `flight` VALUES ('867','2018-12-10 21:01:20','135','749','137.46','194','93','26') ; 
INSERT INTO `flight` VALUES ('868','2018-12-10 09:48:54','159','881','149.14','90','65','6') ; 
INSERT INTO `flight` VALUES ('869','2018-12-10 05:23:02','239','1327','188.59','44','37','116') ; 
INSERT INTO `flight` VALUES ('870','2018-12-10 22:03:03','228','1268','181.95','113','37','118') ; 
INSERT INTO `flight` VALUES ('871','2018-12-10 22:29:37','44','244','35.59','218','26','6') ; 
INSERT INTO `flight` VALUES ('872','2018-12-10 13:38:05','146','809','168.80','235','116','118') ; 
INSERT INTO `flight` VALUES ('873','2018-12-10 05:07:07','384','2131','325.50','79','118','93') ; 
INSERT INTO `flight` VALUES ('874','2018-12-10 10:39:42','226','1253','191.85','89','67','116') ; 
INSERT INTO `flight` VALUES ('875','2018-12-10 23:21:53','102','566','143.43','89','67','118') ; 
INSERT INTO `flight` VALUES ('876','2018-12-10 22:39:59','181','1003','189.25','96','93','37') ; 
INSERT INTO `flight` VALUES ('877','2018-12-10 03:18:39','167','929','104.69','123','93','38') ; 
INSERT INTO `flight` VALUES ('878','2018-12-10 01:43:15','393','2184','394.01','156','38','116') ; 
INSERT INTO `flight` VALUES ('879','2018-12-10 05:35:03','308','1712','228.92','75','38','118') ; 
INSERT INTO `flight` VALUES ('880','2018-12-10 20:27:48','254','1409','261.65','74','37','6') ; 
INSERT INTO `flight` VALUES ('881','2018-12-10 02:52:44','116','643','68.11','95','65','26') ; 
INSERT INTO `flight` VALUES ('882','2018-12-10 04:07:51','44','244','30.94','2','6','26') ; 
INSERT INTO `flight` VALUES ('883','2018-12-10 18:59:38','205','1137','167.38','142','68','116') ; 
INSERT INTO `flight` VALUES ('884','2018-12-10 21:53:45','69','381','52.67','11','68','118') ; 
INSERT INTO `flight` VALUES ('885','2018-12-10 10:28:42','485','2693','470.38','69','116','6') ; 
INSERT INTO `flight` VALUES ('886','2018-12-10 05:43:37','354','1965','285.33','234','67','6') ; 
INSERT INTO `flight` VALUES ('887','2018-12-10 08:31:37','320','1778','342.35','251','65','37') ; 
INSERT INTO `flight` VALUES ('888','2018-12-10 16:17:21','146','809','113.27','111','118','116') ; 
INSERT INTO `flight` VALUES ('889','2018-12-10 22:26:51','254','1409','264.95','67','6','37') ; 
INSERT INTO `flight` VALUES ('890','2018-12-10 20:22:17','282','1566','244.80','18','65','38') ; 
INSERT INTO `flight` VALUES ('891','2018-12-10 09:40:11','145','803','122.63','25','6','38') ; 
INSERT INTO `flight` VALUES ('892','2018-12-10 22:05:27','145','803','79.33','105','38','6') ; 
INSERT INTO `flight` VALUES ('893','2018-12-10 21:55:28','283','1570','322.35','76','26','37') ; 
INSERT INTO `flight` VALUES ('894','2018-12-10 23:08:04','189','1049','126.49','260','26','38') ; 
INSERT INTO `flight` VALUES ('895','2018-12-10 18:04:42','392','2176','368.23','229','68','6') ; 
INSERT INTO `flight` VALUES ('896','2018-12-10 15:15:03','142','789','91.38','244','93','65') ; 
INSERT INTO `flight` VALUES ('897','2018-12-10 14:58:15','283','1570','308.02','262','37','26') ; 
INSERT INTO `flight` VALUES ('898','2018-12-10 10:13:05','314','1747','346.82','12','93','67') ; 
INSERT INTO `flight` VALUES ('899','2018-12-10 22:12:17','363','2015','289.93','258','93','68') ; 
INSERT INTO `flight` VALUES ('900','2018-12-10 09:06:17','513','2851','478.08','264','116','26') ; 

INSERT INTO `trip_type` VALUES ('1','One way') ; 
INSERT INTO `trip_type` VALUES ('2','Roundtrip') ; 

INSERT INTO `trip` VALUES ('1','1','65','118') ; 
INSERT INTO `trip` VALUES ('2','1','37','116') ; 
INSERT INTO `trip` VALUES ('3','1','67','38') ; 
INSERT INTO `trip` VALUES ('4','1','68','118') ; 
INSERT INTO `trip` VALUES ('5','1','93','26') ; 
INSERT INTO `trip` VALUES ('6','2','67','65') ; 
INSERT INTO `trip` VALUES ('7','1','65','38') ; 
INSERT INTO `trip` VALUES ('8','1','118','26') ; 
INSERT INTO `trip` VALUES ('9','2','65','67') ; 
INSERT INTO `trip` VALUES ('10','2','37','67') ; 
INSERT INTO `trip` VALUES ('11','1','26','65') ; 
INSERT INTO `trip` VALUES ('12','1','67','6') ; 
INSERT INTO `trip` VALUES ('13','2','68','116') ; 
INSERT INTO `trip` VALUES ('14','2','6','26') ; 
INSERT INTO `trip` VALUES ('15','1','118','6') ; 
INSERT INTO `trip` VALUES ('16','2','38','118') ; 
INSERT INTO `trip` VALUES ('17','2','6','37') ; 
INSERT INTO `trip` VALUES ('18','1','93','116') ; 
INSERT INTO `trip` VALUES ('19','2','118','26') ; 
INSERT INTO `trip` VALUES ('20','2','118','37') ; 
INSERT INTO `trip` VALUES ('21','2','93','118') ; 
INSERT INTO `trip` VALUES ('22','1','118','38') ; 
INSERT INTO `trip` VALUES ('23','1','116','68') ; 
INSERT INTO `trip` VALUES ('24','2','26','65') ; 
INSERT INTO `trip` VALUES ('25','2','118','93') ; 
INSERT INTO `trip` VALUES ('26','2','65','118') ; 
INSERT INTO `trip` VALUES ('27','2','116','26') ; 
INSERT INTO `trip` VALUES ('28','2','68','26') ; 
INSERT INTO `trip` VALUES ('29','2','93','6') ; 
INSERT INTO `trip` VALUES ('30','1','6','67') ; 
INSERT INTO `trip` VALUES ('31','1','116','67') ; 
INSERT INTO `trip` VALUES ('32','2','65','67') ; 
INSERT INTO `trip` VALUES ('33','2','118','6') ; 
INSERT INTO `trip` VALUES ('34','2','38','26') ; 
INSERT INTO `trip` VALUES ('35','2','118','6') ; 
INSERT INTO `trip` VALUES ('36','2','38','93') ; 
INSERT INTO `trip` VALUES ('37','1','118','6') ; 
INSERT INTO `trip` VALUES ('38','2','38','118') ; 
INSERT INTO `trip` VALUES ('39','2','38','65') ; 
INSERT INTO `trip` VALUES ('40','2','38','6') ; 
INSERT INTO `trip` VALUES ('41','1','93','6') ; 
INSERT INTO `trip` VALUES ('42','1','37','65') ; 
INSERT INTO `trip` VALUES ('43','2','6','67') ; 
INSERT INTO `trip` VALUES ('44','2','37','65') ; 
INSERT INTO `trip` VALUES ('45','1','65','68') ; 
INSERT INTO `trip` VALUES ('46','2','67','116') ; 
INSERT INTO `trip` VALUES ('47','1','118','37') ; 
INSERT INTO `trip` VALUES ('48','1','65','118') ; 
INSERT INTO `trip` VALUES ('49','1','93','38') ; 
INSERT INTO `trip` VALUES ('50','1','26','116') ; 
INSERT INTO `trip` VALUES ('51','1','93','116') ; 
INSERT INTO `trip` VALUES ('52','2','116','118') ; 
INSERT INTO `trip` VALUES ('53','1','68','118') ; 
INSERT INTO `trip` VALUES ('54','2','65','37') ; 
INSERT INTO `trip` VALUES ('55','2','65','68') ; 
INSERT INTO `trip` VALUES ('56','2','93','26') ; 
INSERT INTO `trip` VALUES ('57','2','93','37') ; 
INSERT INTO `trip` VALUES ('58','1','118','26') ; 
INSERT INTO `trip` VALUES ('59','1','38','68') ; 
INSERT INTO `trip` VALUES ('60','2','26','67') ; 
INSERT INTO `trip` VALUES ('61','2','38','68') ; 
INSERT INTO `trip` VALUES ('62','1','93','118') ; 
INSERT INTO `trip` VALUES ('63','2','38','26') ; 
INSERT INTO `trip` VALUES ('64','1','37','93') ; 
INSERT INTO `trip` VALUES ('65','1','116','118') ; 
INSERT INTO `trip` VALUES ('66','2','38','116') ; 
INSERT INTO `trip` VALUES ('67','2','6','65') ; 
INSERT INTO `trip` VALUES ('68','1','38','68') ; 
INSERT INTO `trip` VALUES ('69','1','68','38') ; 
INSERT INTO `trip` VALUES ('70','1','38','116') ; 
INSERT INTO `trip` VALUES ('71','1','93','118') ; 
INSERT INTO `trip` VALUES ('72','2','37','6') ; 
INSERT INTO `trip` VALUES ('73','1','26','118') ; 
INSERT INTO `trip` VALUES ('74','2','38','118') ; 
INSERT INTO `trip` VALUES ('75','1','67','116') ; 
INSERT INTO `trip` VALUES ('76','2','93','67') ; 
INSERT INTO `trip` VALUES ('77','2','65','37') ; 
INSERT INTO `trip` VALUES ('78','1','118','37') ; 
INSERT INTO `trip` VALUES ('79','1','26','116') ; 
INSERT INTO `trip` VALUES ('80','2','118','38') ; 
INSERT INTO `trip` VALUES ('81','1','93','26') ; 
INSERT INTO `trip` VALUES ('82','2','68','67') ; 
INSERT INTO `trip` VALUES ('83','1','67','116') ; 
INSERT INTO `trip` VALUES ('84','2','38','93') ; 
INSERT INTO `trip` VALUES ('85','2','118','93') ; 
INSERT INTO `trip` VALUES ('86','1','38','118') ; 
INSERT INTO `trip` VALUES ('87','2','65','93') ; 
INSERT INTO `trip` VALUES ('88','2','68','37') ; 
INSERT INTO `trip` VALUES ('89','1','116','67') ; 
INSERT INTO `trip` VALUES ('90','1','93','38') ; 
INSERT INTO `trip` VALUES ('91','2','93','37') ; 
INSERT INTO `trip` VALUES ('92','1','68','65') ; 
INSERT INTO `trip` VALUES ('93','2','68','65') ; 
INSERT INTO `trip` VALUES ('94','2','93','6') ; 
INSERT INTO `trip` VALUES ('95','2','68','26') ; 
INSERT INTO `trip` VALUES ('96','2','67','26') ; 
INSERT INTO `trip` VALUES ('97','2','68','67') ; 
INSERT INTO `trip` VALUES ('98','1','68','65') ; 
INSERT INTO `trip` VALUES ('99','1','68','38') ; 
INSERT INTO `trip` VALUES ('100','2','26','38') ; 

INSERT INTO `connection` VALUES ('1','257') ; 
INSERT INTO `connection` VALUES ('1','240') ; 
INSERT INTO `connection` VALUES ('2','149') ; 
INSERT INTO `connection` VALUES ('3','188') ; 
INSERT INTO `connection` VALUES ('4','400') ; 
INSERT INTO `connection` VALUES ('4','495') ; 
INSERT INTO `connection` VALUES ('4','602') ; 
INSERT INTO `connection` VALUES ('5','34') ; 
INSERT INTO `connection` VALUES ('5','90') ; 
INSERT INTO `connection` VALUES ('6','91') ; 
INSERT INTO `connection` VALUES ('6','241') ; 
INSERT INTO `connection` VALUES ('6','280') ; 
INSERT INTO `connection` VALUES ('6','682') ; 
INSERT INTO `connection` VALUES ('6','786') ; 
INSERT INTO `connection` VALUES ('6','832') ; 
INSERT INTO `connection` VALUES ('7','80') ; 
INSERT INTO `connection` VALUES ('8','136') ; 
INSERT INTO `connection` VALUES ('8','97') ; 
INSERT INTO `connection` VALUES ('8','267') ; 
INSERT INTO `connection` VALUES ('9','11') ; 
INSERT INTO `connection` VALUES ('9','641') ; 
INSERT INTO `connection` VALUES ('10','267') ; 
INSERT INTO `connection` VALUES ('10','414') ; 
INSERT INTO `connection` VALUES ('10','496') ; 
INSERT INTO `connection` VALUES ('10','474') ; 
INSERT INTO `connection` VALUES ('11','18') ; 
INSERT INTO `connection` VALUES ('11','73') ; 
INSERT INTO `connection` VALUES ('11','117') ; 
INSERT INTO `connection` VALUES ('12','436') ; 
INSERT INTO `connection` VALUES ('13','253') ; 
INSERT INTO `connection` VALUES ('13','703') ; 
INSERT INTO `connection` VALUES ('14','261') ; 
INSERT INTO `connection` VALUES ('14','184') ; 
INSERT INTO `connection` VALUES ('14','644') ; 
INSERT INTO `connection` VALUES ('14','650') ; 
INSERT INTO `connection` VALUES ('14','807') ; 
INSERT INTO `connection` VALUES ('15','314') ; 
INSERT INTO `connection` VALUES ('15','508') ; 
INSERT INTO `connection` VALUES ('16','39') ; 
INSERT INTO `connection` VALUES ('16','164') ; 
INSERT INTO `connection` VALUES ('16','608') ; 
INSERT INTO `connection` VALUES ('16','705') ; 
INSERT INTO `connection` VALUES ('16','681') ; 
INSERT INTO `connection` VALUES ('17','102') ; 
INSERT INTO `connection` VALUES ('17','97') ; 
INSERT INTO `connection` VALUES ('17','612') ; 
INSERT INTO `connection` VALUES ('17','556') ; 
INSERT INTO `connection` VALUES ('17','617') ; 
INSERT INTO `connection` VALUES ('18','484') ; 
INSERT INTO `connection` VALUES ('19','49') ; 
INSERT INTO `connection` VALUES ('19','131') ; 
INSERT INTO `connection` VALUES ('19','91') ; 
INSERT INTO `connection` VALUES ('19','494') ; 
INSERT INTO `connection` VALUES ('19','617') ; 
INSERT INTO `connection` VALUES ('19','627') ; 
INSERT INTO `connection` VALUES ('20','44') ; 
INSERT INTO `connection` VALUES ('20','31') ; 
INSERT INTO `connection` VALUES ('20','156') ; 
INSERT INTO `connection` VALUES ('20','542') ; 
INSERT INTO `connection` VALUES ('20','554') ; 
INSERT INTO `connection` VALUES ('20','650') ; 
INSERT INTO `connection` VALUES ('21','43') ; 
INSERT INTO `connection` VALUES ('21','51') ; 
INSERT INTO `connection` VALUES ('21','574') ; 
INSERT INTO `connection` VALUES ('21','692') ; 
INSERT INTO `connection` VALUES ('22','452') ; 
INSERT INTO `connection` VALUES ('22','531') ; 
INSERT INTO `connection` VALUES ('23','276') ; 
INSERT INTO `connection` VALUES ('23','429') ; 
INSERT INTO `connection` VALUES ('23','499') ; 
INSERT INTO `connection` VALUES ('24','16') ; 
INSERT INTO `connection` VALUES ('24','714') ; 
INSERT INTO `connection` VALUES ('24','698') ; 
INSERT INTO `connection` VALUES ('24','657') ; 
INSERT INTO `connection` VALUES ('25','23') ; 
INSERT INTO `connection` VALUES ('25','24') ; 
INSERT INTO `connection` VALUES ('25','142') ; 
INSERT INTO `connection` VALUES ('25','469') ; 
INSERT INTO `connection` VALUES ('25','577') ; 
INSERT INTO `connection` VALUES ('26','211') ; 
INSERT INTO `connection` VALUES ('26','237') ; 
INSERT INTO `connection` VALUES ('26','324') ; 
INSERT INTO `connection` VALUES ('26','463') ; 
INSERT INTO `connection` VALUES ('26','614') ; 
INSERT INTO `connection` VALUES ('27','137') ; 
INSERT INTO `connection` VALUES ('27','237') ; 
INSERT INTO `connection` VALUES ('27','630') ; 
INSERT INTO `connection` VALUES ('28','221') ; 
INSERT INTO `connection` VALUES ('28','181') ; 
INSERT INTO `connection` VALUES ('28','715') ; 
INSERT INTO `connection` VALUES ('28','752') ; 
INSERT INTO `connection` VALUES ('28','777') ; 
INSERT INTO `connection` VALUES ('29','266') ; 
INSERT INTO `connection` VALUES ('29','193') ; 
INSERT INTO `connection` VALUES ('29','355') ; 
INSERT INTO `connection` VALUES ('29','583') ; 
INSERT INTO `connection` VALUES ('30','104') ; 
INSERT INTO `connection` VALUES ('30','221') ; 
INSERT INTO `connection` VALUES ('31','95') ; 
INSERT INTO `connection` VALUES ('31','204') ; 
INSERT INTO `connection` VALUES ('32','140') ; 
INSERT INTO `connection` VALUES ('32','226') ; 
INSERT INTO `connection` VALUES ('32','641') ; 
INSERT INTO `connection` VALUES ('33','226') ; 
INSERT INTO `connection` VALUES ('33','256') ; 
INSERT INTO `connection` VALUES ('33','559') ; 
INSERT INTO `connection` VALUES ('33','691') ; 
INSERT INTO `connection` VALUES ('34','145') ; 
INSERT INTO `connection` VALUES ('34','266') ; 
INSERT INTO `connection` VALUES ('34','251') ; 
INSERT INTO `connection` VALUES ('34','622') ; 
INSERT INTO `connection` VALUES ('34','591') ; 
INSERT INTO `connection` VALUES ('34','649') ; 
INSERT INTO `connection` VALUES ('35','44') ; 
INSERT INTO `connection` VALUES ('35','167') ; 
INSERT INTO `connection` VALUES ('35','250') ; 
INSERT INTO `connection` VALUES ('35','473') ; 
INSERT INTO `connection` VALUES ('35','599') ; 
INSERT INTO `connection` VALUES ('35','705') ; 
INSERT INTO `connection` VALUES ('36','82') ; 
INSERT INTO `connection` VALUES ('36','32') ; 
INSERT INTO `connection` VALUES ('36','486') ; 
INSERT INTO `connection` VALUES ('36','585') ; 
INSERT INTO `connection` VALUES ('36','587') ; 
INSERT INTO `connection` VALUES ('37','362') ; 
INSERT INTO `connection` VALUES ('38','15') ; 
INSERT INTO `connection` VALUES ('38','22') ; 
INSERT INTO `connection` VALUES ('38','140') ; 
INSERT INTO `connection` VALUES ('38','488') ; 
INSERT INTO `connection` VALUES ('38','515') ; 
INSERT INTO `connection` VALUES ('39','195') ; 
INSERT INTO `connection` VALUES ('39','239') ; 
INSERT INTO `connection` VALUES ('39','297') ; 
INSERT INTO `connection` VALUES ('39','685') ; 
INSERT INTO `connection` VALUES ('39','716') ; 
INSERT INTO `connection` VALUES ('40','218') ; 
INSERT INTO `connection` VALUES ('40','335') ; 
INSERT INTO `connection` VALUES ('40','362') ; 
INSERT INTO `connection` VALUES ('40','622') ; 
INSERT INTO `connection` VALUES ('41','359') ; 
INSERT INTO `connection` VALUES ('41','433') ; 
INSERT INTO `connection` VALUES ('41','525') ; 
INSERT INTO `connection` VALUES ('42','112') ; 
INSERT INTO `connection` VALUES ('43','259') ; 
INSERT INTO `connection` VALUES ('43','239') ; 
INSERT INTO `connection` VALUES ('43','298') ; 
INSERT INTO `connection` VALUES ('43','642') ; 
INSERT INTO `connection` VALUES ('44','160') ; 
INSERT INTO `connection` VALUES ('44','104') ; 
INSERT INTO `connection` VALUES ('44','220') ; 
INSERT INTO `connection` VALUES ('44','472') ; 
INSERT INTO `connection` VALUES ('45','193') ; 
INSERT INTO `connection` VALUES ('46','244') ; 
INSERT INTO `connection` VALUES ('46','604') ; 
INSERT INTO `connection` VALUES ('47','113') ; 
INSERT INTO `connection` VALUES ('48','45') ; 
INSERT INTO `connection` VALUES ('48','118') ; 
INSERT INTO `connection` VALUES ('48','155') ; 
INSERT INTO `connection` VALUES ('49','67') ; 
INSERT INTO `connection` VALUES ('50','143') ; 
INSERT INTO `connection` VALUES ('51','356') ; 
INSERT INTO `connection` VALUES ('51','315') ; 
INSERT INTO `connection` VALUES ('52','28') ; 
INSERT INTO `connection` VALUES ('52','65') ; 
INSERT INTO `connection` VALUES ('52','657') ; 
INSERT INTO `connection` VALUES ('52','778') ; 
INSERT INTO `connection` VALUES ('52','861') ; 
INSERT INTO `connection` VALUES ('53','310') ; 
INSERT INTO `connection` VALUES ('53','320') ; 
INSERT INTO `connection` VALUES ('54','148') ; 
INSERT INTO `connection` VALUES ('54','169') ; 
INSERT INTO `connection` VALUES ('54','500') ; 
INSERT INTO `connection` VALUES ('54','473') ; 
INSERT INTO `connection` VALUES ('55','167') ; 
INSERT INTO `connection` VALUES ('55','206') ; 
INSERT INTO `connection` VALUES ('55','643') ; 
INSERT INTO `connection` VALUES ('56','176') ; 
INSERT INTO `connection` VALUES ('56','225') ; 
INSERT INTO `connection` VALUES ('56','270') ; 
INSERT INTO `connection` VALUES ('56','597') ; 
INSERT INTO `connection` VALUES ('57','223') ; 
INSERT INTO `connection` VALUES ('57','349') ; 
INSERT INTO `connection` VALUES ('57','597') ; 
INSERT INTO `connection` VALUES ('57','594') ; 
INSERT INTO `connection` VALUES ('57','653') ; 
INSERT INTO `connection` VALUES ('58','46') ; 
INSERT INTO `connection` VALUES ('58','98') ; 
INSERT INTO `connection` VALUES ('58','184') ; 
INSERT INTO `connection` VALUES ('59','442') ; 
INSERT INTO `connection` VALUES ('59','498') ; 
INSERT INTO `connection` VALUES ('59','570') ; 
INSERT INTO `connection` VALUES ('60','17') ; 
INSERT INTO `connection` VALUES ('60','667') ; 
INSERT INTO `connection` VALUES ('60','673') ; 
INSERT INTO `connection` VALUES ('60','732') ; 
INSERT INTO `connection` VALUES ('61','262') ; 
INSERT INTO `connection` VALUES ('61','194') ; 
INSERT INTO `connection` VALUES ('61','465') ; 
INSERT INTO `connection` VALUES ('61','627') ; 
INSERT INTO `connection` VALUES ('61','648') ; 
INSERT INTO `connection` VALUES ('62','507') ; 
INSERT INTO `connection` VALUES ('62','594') ; 
INSERT INTO `connection` VALUES ('63','184') ; 
INSERT INTO `connection` VALUES ('63','519') ; 
INSERT INTO `connection` VALUES ('63','589') ; 
INSERT INTO `connection` VALUES ('63','639') ; 
INSERT INTO `connection` VALUES ('64','267') ; 
INSERT INTO `connection` VALUES ('64','286') ; 
INSERT INTO `connection` VALUES ('64','301') ; 
INSERT INTO `connection` VALUES ('65','117') ; 
INSERT INTO `connection` VALUES ('65','230') ; 
INSERT INTO `connection` VALUES ('66','69') ; 
INSERT INTO `connection` VALUES ('66','168') ; 
INSERT INTO `connection` VALUES ('66','519') ; 
INSERT INTO `connection` VALUES ('66','618') ; 
INSERT INTO `connection` VALUES ('67','100') ; 
INSERT INTO `connection` VALUES ('67','482') ; 
INSERT INTO `connection` VALUES ('67','517') ; 
INSERT INTO `connection` VALUES ('67','576') ; 
INSERT INTO `connection` VALUES ('68','489') ; 
INSERT INTO `connection` VALUES ('69','524') ; 
INSERT INTO `connection` VALUES ('69','586') ; 
INSERT INTO `connection` VALUES ('69','638') ; 
INSERT INTO `connection` VALUES ('70','428') ; 
INSERT INTO `connection` VALUES ('71','359') ; 
INSERT INTO `connection` VALUES ('71','434') ; 
INSERT INTO `connection` VALUES ('72','26') ; 
INSERT INTO `connection` VALUES ('72','130') ; 
INSERT INTO `connection` VALUES ('72','238') ; 
INSERT INTO `connection` VALUES ('72','509') ; 
INSERT INTO `connection` VALUES ('72','497') ; 
INSERT INTO `connection` VALUES ('72','493') ; 
INSERT INTO `connection` VALUES ('73','16') ; 
INSERT INTO `connection` VALUES ('73','140') ; 
INSERT INTO `connection` VALUES ('74','128') ; 
INSERT INTO `connection` VALUES ('74','97') ; 
INSERT INTO `connection` VALUES ('74','150') ; 
INSERT INTO `connection` VALUES ('74','609') ; 
INSERT INTO `connection` VALUES ('75','346') ; 
INSERT INTO `connection` VALUES ('75','408') ; 
INSERT INTO `connection` VALUES ('76','178') ; 
INSERT INTO `connection` VALUES ('76','517') ; 
INSERT INTO `connection` VALUES ('76','578') ; 
INSERT INTO `connection` VALUES ('77','191') ; 
INSERT INTO `connection` VALUES ('77','335') ; 
INSERT INTO `connection` VALUES ('77','383') ; 
INSERT INTO `connection` VALUES ('77','617') ; 
INSERT INTO `connection` VALUES ('78','473') ; 
INSERT INTO `connection` VALUES ('79','414') ; 
INSERT INTO `connection` VALUES ('79','528') ; 
INSERT INTO `connection` VALUES ('80','134') ; 
INSERT INTO `connection` VALUES ('80','260') ; 
INSERT INTO `connection` VALUES ('80','475') ; 
INSERT INTO `connection` VALUES ('81','237') ; 
INSERT INTO `connection` VALUES ('82','131') ; 
INSERT INTO `connection` VALUES ('82','651') ; 
INSERT INTO `connection` VALUES ('82','789') ; 
INSERT INTO `connection` VALUES ('82','856') ; 
INSERT INTO `connection` VALUES ('83','412') ; 
INSERT INTO `connection` VALUES ('83','446') ; 
INSERT INTO `connection` VALUES ('83','495') ; 
INSERT INTO `connection` VALUES ('84','126') ; 
INSERT INTO `connection` VALUES ('84','193') ; 
INSERT INTO `connection` VALUES ('84','326') ; 
INSERT INTO `connection` VALUES ('84','595') ; 
INSERT INTO `connection` VALUES ('85','63') ; 
INSERT INTO `connection` VALUES ('85','565') ; 
INSERT INTO `connection` VALUES ('85','595') ; 
INSERT INTO `connection` VALUES ('86','429') ; 
INSERT INTO `connection` VALUES ('87','31') ; 
INSERT INTO `connection` VALUES ('87','500') ; 
INSERT INTO `connection` VALUES ('87','589') ; 
INSERT INTO `connection` VALUES ('87','686') ; 
INSERT INTO `connection` VALUES ('88','253') ; 
INSERT INTO `connection` VALUES ('88','332') ; 
INSERT INTO `connection` VALUES ('88','383') ; 
INSERT INTO `connection` VALUES ('88','670') ; 
INSERT INTO `connection` VALUES ('88','661') ; 
INSERT INTO `connection` VALUES ('88','786') ; 
INSERT INTO `connection` VALUES ('89','455') ; 
INSERT INTO `connection` VALUES ('89','610') ; 
INSERT INTO `connection` VALUES ('89','552') ; 
INSERT INTO `connection` VALUES ('90','223') ; 
INSERT INTO `connection` VALUES ('90','351') ; 
INSERT INTO `connection` VALUES ('91','247') ; 
INSERT INTO `connection` VALUES ('91','195') ; 
INSERT INTO `connection` VALUES ('91','538') ; 
INSERT INTO `connection` VALUES ('91','573') ; 
INSERT INTO `connection` VALUES ('91','560') ; 
INSERT INTO `connection` VALUES ('92','434') ; 
INSERT INTO `connection` VALUES ('92','496') ; 
INSERT INTO `connection` VALUES ('92','479') ; 
INSERT INTO `connection` VALUES ('93','200') ; 
INSERT INTO `connection` VALUES ('93','292') ; 
INSERT INTO `connection` VALUES ('93','523') ; 
INSERT INTO `connection` VALUES ('93','567') ; 
INSERT INTO `connection` VALUES ('94','89') ; 
INSERT INTO `connection` VALUES ('94','21') ; 
INSERT INTO `connection` VALUES ('94','172') ; 
INSERT INTO `connection` VALUES ('94','664') ; 
INSERT INTO `connection` VALUES ('94','795') ; 
INSERT INTO `connection` VALUES ('95','40') ; 
INSERT INTO `connection` VALUES ('95','161') ; 
INSERT INTO `connection` VALUES ('95','580') ; 
INSERT INTO `connection` VALUES ('95','778') ; 
INSERT INTO `connection` VALUES ('95','792') ; 
INSERT INTO `connection` VALUES ('96','209') ; 
INSERT INTO `connection` VALUES ('96','341') ; 
INSERT INTO `connection` VALUES ('96','502') ; 
INSERT INTO `connection` VALUES ('96','574') ; 
INSERT INTO `connection` VALUES ('96','720') ; 
INSERT INTO `connection` VALUES ('97','41') ; 
INSERT INTO `connection` VALUES ('97','671') ; 
INSERT INTO `connection` VALUES ('98','220') ; 
INSERT INTO `connection` VALUES ('99','220') ; 
INSERT INTO `connection` VALUES ('99','341') ; 
INSERT INTO `connection` VALUES ('99','444') ; 
INSERT INTO `connection` VALUES ('100','217') ; 
INSERT INTO `connection` VALUES ('100','246') ; 
INSERT INTO `connection` VALUES ('100','183') ; 
INSERT INTO `connection` VALUES ('100','558') ; 
INSERT INTO `connection` VALUES ('100','561') ; 

INSERT INTO `class` VALUES ('1','Economy/Coach','0.55') ; 
INSERT INTO `class` VALUES ('2','Preminum economy','0.2') ; 
INSERT INTO `class` VALUES ('3','Business','0.15') ; 
INSERT INTO `class` VALUES ('4','First class','0.1') ; 

INSERT INTO `price_factor` VALUES ('1','1','1.3') ; 
INSERT INTO `price_factor` VALUES ('2','1','1.19') ; 
INSERT INTO `price_factor` VALUES ('3','1','1.12') ; 
INSERT INTO `price_factor` VALUES ('4','1','1.15') ; 
INSERT INTO `price_factor` VALUES ('5','1','1.31') ; 
INSERT INTO `price_factor` VALUES ('6','1','1.05') ; 
INSERT INTO `price_factor` VALUES ('7','1','1.26') ; 
INSERT INTO `price_factor` VALUES ('8','1','1.31') ; 
INSERT INTO `price_factor` VALUES ('9','1','1.13') ; 
INSERT INTO `price_factor` VALUES ('10','1','1.32') ; 
INSERT INTO `price_factor` VALUES ('11','1','1.07') ; 
INSERT INTO `price_factor` VALUES ('12','1','1.2') ; 
INSERT INTO `price_factor` VALUES ('13','1','1.32') ; 
INSERT INTO `price_factor` VALUES ('14','1','1.03') ; 
INSERT INTO `price_factor` VALUES ('15','1','1.05') ; 
INSERT INTO `price_factor` VALUES ('16','1','1.22') ; 
INSERT INTO `price_factor` VALUES ('1','2','1.55') ; 
INSERT INTO `price_factor` VALUES ('2','2','1.35') ; 
INSERT INTO `price_factor` VALUES ('3','2','1.44') ; 
INSERT INTO `price_factor` VALUES ('4','2','1.37') ; 
INSERT INTO `price_factor` VALUES ('5','2','1.31') ; 
INSERT INTO `price_factor` VALUES ('6','2','1.5') ; 
INSERT INTO `price_factor` VALUES ('7','2','1.42') ; 
INSERT INTO `price_factor` VALUES ('8','2','1.35') ; 
INSERT INTO `price_factor` VALUES ('9','2','1.36') ; 
INSERT INTO `price_factor` VALUES ('10','2','1.46') ; 
INSERT INTO `price_factor` VALUES ('11','2','1.46') ; 
INSERT INTO `price_factor` VALUES ('12','2','1.61') ; 
INSERT INTO `price_factor` VALUES ('13','2','1.46') ; 
INSERT INTO `price_factor` VALUES ('14','2','1.56') ; 
INSERT INTO `price_factor` VALUES ('15','2','1.36') ; 
INSERT INTO `price_factor` VALUES ('16','2','1.33') ; 
INSERT INTO `price_factor` VALUES ('1','3','1.65') ; 
INSERT INTO `price_factor` VALUES ('2','3','1.83') ; 
INSERT INTO `price_factor` VALUES ('3','3','1.91') ; 
INSERT INTO `price_factor` VALUES ('4','3','1.7') ; 
INSERT INTO `price_factor` VALUES ('5','3','1.83') ; 
INSERT INTO `price_factor` VALUES ('6','3','1.66') ; 
INSERT INTO `price_factor` VALUES ('7','3','1.84') ; 
INSERT INTO `price_factor` VALUES ('8','3','1.83') ; 
INSERT INTO `price_factor` VALUES ('9','3','1.66') ; 
INSERT INTO `price_factor` VALUES ('10','3','1.72') ; 
INSERT INTO `price_factor` VALUES ('11','3','1.62') ; 
INSERT INTO `price_factor` VALUES ('12','3','1.82') ; 
INSERT INTO `price_factor` VALUES ('13','3','1.74') ; 
INSERT INTO `price_factor` VALUES ('14','3','1.76') ; 
INSERT INTO `price_factor` VALUES ('15','3','1.67') ; 
INSERT INTO `price_factor` VALUES ('16','3','1.65') ; 
INSERT INTO `price_factor` VALUES ('1','4','2.21') ; 
INSERT INTO `price_factor` VALUES ('2','4','2.1') ; 
INSERT INTO `price_factor` VALUES ('3','4','2.21') ; 
INSERT INTO `price_factor` VALUES ('4','4','1.93') ; 
INSERT INTO `price_factor` VALUES ('5','4','2.13') ; 
INSERT INTO `price_factor` VALUES ('6','4','2.05') ; 
INSERT INTO `price_factor` VALUES ('7','4','2.05') ; 
INSERT INTO `price_factor` VALUES ('8','4','2.12') ; 
INSERT INTO `price_factor` VALUES ('9','4','2.13') ; 
INSERT INTO `price_factor` VALUES ('10','4','2.06') ; 
INSERT INTO `price_factor` VALUES ('11','4','1.93') ; 
INSERT INTO `price_factor` VALUES ('12','4','2.22') ; 
INSERT INTO `price_factor` VALUES ('13','4','2.19') ; 
INSERT INTO `price_factor` VALUES ('14','4','1.97') ; 
INSERT INTO `price_factor` VALUES ('15','4','2.22') ; 
INSERT INTO `price_factor` VALUES ('16','4','1.91') ; 

INSERT INTO `traveler` VALUES ('1','Nixie','Tattershall') ; 
INSERT INTO `traveler` VALUES ('2','Gertrudis','Pues') ; 
INSERT INTO `traveler` VALUES ('3','Olenolin','Monkeman') ; 
INSERT INTO `traveler` VALUES ('4','Laurens','Rosenblum') ; 
INSERT INTO `traveler` VALUES ('5','Darice','Preene') ; 
INSERT INTO `traveler` VALUES ('6','Cirilo','Fishbourne') ; 
INSERT INTO `traveler` VALUES ('7','Arne','McMakin') ; 
INSERT INTO `traveler` VALUES ('8','Cammy','Graybeal') ; 
INSERT INTO `traveler` VALUES ('9','Damien','Laxon') ; 
INSERT INTO `traveler` VALUES ('10','Markos','Drain') ; 
INSERT INTO `traveler` VALUES ('11','Row','Frazier') ; 
INSERT INTO `traveler` VALUES ('12','Oliver','Vears') ; 
INSERT INTO `traveler` VALUES ('13','Joella','Asser') ; 
INSERT INTO `traveler` VALUES ('14','Wainwright','Tingcomb') ; 
INSERT INTO `traveler` VALUES ('15','Philly','Dobey') ; 
INSERT INTO `traveler` VALUES ('16','Wendel','Stapford') ; 
INSERT INTO `traveler` VALUES ('17','Ethelbert','Gerardot') ; 
INSERT INTO `traveler` VALUES ('18','Josie','Padefield') ; 
INSERT INTO `traveler` VALUES ('19','Bryan','Cabrales') ; 
INSERT INTO `traveler` VALUES ('20','Carolan','Callum') ; 
INSERT INTO `traveler` VALUES ('21','Way','Serman') ; 
INSERT INTO `traveler` VALUES ('22','Linzy','Sinncock') ; 
INSERT INTO `traveler` VALUES ('23','Gery','Alderwick') ; 
INSERT INTO `traveler` VALUES ('24','Brenden','Mepsted') ; 
INSERT INTO `traveler` VALUES ('25','Ferguson','Joynes') ; 
INSERT INTO `traveler` VALUES ('26','Mimi','Flute') ; 
INSERT INTO `traveler` VALUES ('27','Cam','Spat') ; 
INSERT INTO `traveler` VALUES ('28','Findlay','Lenihan') ; 
INSERT INTO `traveler` VALUES ('29','Page','Mealiffe') ; 
INSERT INTO `traveler` VALUES ('30','Davin','Creeghan') ; 
INSERT INTO `traveler` VALUES ('31','Lorin','Raittie') ; 
INSERT INTO `traveler` VALUES ('32','Burg','McOwen') ; 
INSERT INTO `traveler` VALUES ('33','Ludovika','Linny') ; 
INSERT INTO `traveler` VALUES ('34','Franny','Lubomirski') ; 
INSERT INTO `traveler` VALUES ('35','Laughton','Zamora') ; 
INSERT INTO `traveler` VALUES ('36','Gabie','Choat') ; 
INSERT INTO `traveler` VALUES ('37','Georgie','Roust') ; 
INSERT INTO `traveler` VALUES ('38','Larissa','Blankman') ; 
INSERT INTO `traveler` VALUES ('39','Flinn','Allanson') ; 
INSERT INTO `traveler` VALUES ('40','Rorie','Bentjens') ; 
INSERT INTO `traveler` VALUES ('41','Boyd','Raine') ; 
INSERT INTO `traveler` VALUES ('42','Kendall','Rawls') ; 
INSERT INTO `traveler` VALUES ('43','Miguel','Jaggard') ; 
INSERT INTO `traveler` VALUES ('44','Fabio','Corradengo') ; 
INSERT INTO `traveler` VALUES ('45','Fletcher','Cupitt') ; 
INSERT INTO `traveler` VALUES ('46','Judie','Rappa') ; 
INSERT INTO `traveler` VALUES ('47','Bert','Yarnell') ; 
INSERT INTO `traveler` VALUES ('48','Dunn','Doblin') ; 
INSERT INTO `traveler` VALUES ('49','Alma','Antognazzi') ; 
INSERT INTO `traveler` VALUES ('50','Celene','Abrahamian') ; 
INSERT INTO `traveler` VALUES ('51','Natala','Burnett') ; 
INSERT INTO `traveler` VALUES ('52','Joanna','Luebbert') ; 
INSERT INTO `traveler` VALUES ('53','Dunc','Toye') ; 
INSERT INTO `traveler` VALUES ('54','Brandon','Mordon') ; 
INSERT INTO `traveler` VALUES ('55','Valentia','Rudledge') ; 
INSERT INTO `traveler` VALUES ('56','Angela','Manklow') ; 
INSERT INTO `traveler` VALUES ('57','Ira','Akerman') ; 
INSERT INTO `traveler` VALUES ('58','Vidovik','Parcells') ; 
INSERT INTO `traveler` VALUES ('59','Valery','Kitson') ; 
INSERT INTO `traveler` VALUES ('60','Garreth','Hardwick') ; 
INSERT INTO `traveler` VALUES ('61','Nicola','Trigwell') ; 
INSERT INTO `traveler` VALUES ('62','Kevon','Van der Velde') ; 
INSERT INTO `traveler` VALUES ('63','Isabel','Poytres') ; 
INSERT INTO `traveler` VALUES ('64','Emmaline','Medlen') ; 
INSERT INTO `traveler` VALUES ('65','Aurea','Groves') ; 
INSERT INTO `traveler` VALUES ('66','Ally','Beretta') ; 
INSERT INTO `traveler` VALUES ('67','Tommie','Been') ; 
INSERT INTO `traveler` VALUES ('68','Maribelle','Ponnsett') ; 
INSERT INTO `traveler` VALUES ('69','Linn','Yalden') ; 
INSERT INTO `traveler` VALUES ('70','Cordi','Vinson') ; 
INSERT INTO `traveler` VALUES ('71','Bert','Gilby') ; 
INSERT INTO `traveler` VALUES ('72','Britney','Taffs') ; 
INSERT INTO `traveler` VALUES ('73','Iago','Harkins') ; 
INSERT INTO `traveler` VALUES ('74','Sherlocke','Bockett') ; 
INSERT INTO `traveler` VALUES ('75','Maynard','Lampke') ; 
INSERT INTO `traveler` VALUES ('76','Jackquelin','Zucker') ; 
INSERT INTO `traveler` VALUES ('77','Lurlene','Lovie') ; 
INSERT INTO `traveler` VALUES ('78','Catharina','Van Niekerk') ; 
INSERT INTO `traveler` VALUES ('79','Ozzy','Metcalfe') ; 
INSERT INTO `traveler` VALUES ('80','Silas','Loosley') ; 
INSERT INTO `traveler` VALUES ('81','Marjy','Edgson') ; 
INSERT INTO `traveler` VALUES ('82','Inesita','Mayou') ; 
INSERT INTO `traveler` VALUES ('83','Alvy','Butterly') ; 
INSERT INTO `traveler` VALUES ('84','Dmitri','Vernall') ; 
INSERT INTO `traveler` VALUES ('85','Idette','Marklund') ; 
INSERT INTO `traveler` VALUES ('86','Kip','Norcliff') ; 
INSERT INTO `traveler` VALUES ('87','Sabra','Craigg') ; 
INSERT INTO `traveler` VALUES ('88','Sandy','Harper') ; 
INSERT INTO `traveler` VALUES ('89','Alonzo','Goodhew') ; 
INSERT INTO `traveler` VALUES ('90','Emili','Gerbl') ; 
INSERT INTO `traveler` VALUES ('91','Radcliffe','Ellsbury') ; 
INSERT INTO `traveler` VALUES ('92','Bentley','Guerriero') ; 
INSERT INTO `traveler` VALUES ('93','Selestina','Pain') ; 
INSERT INTO `traveler` VALUES ('94','Merrill','Picheford') ; 
INSERT INTO `traveler` VALUES ('95','Dena','Coleman') ; 
INSERT INTO `traveler` VALUES ('96','Matthieu','Camois') ; 
INSERT INTO `traveler` VALUES ('97','Jay','D\'eath') ; 
INSERT INTO `traveler` VALUES ('98','Larisa','Dowding') ; 
INSERT INTO `traveler` VALUES ('99','Victor','Bennis') ; 
INSERT INTO `traveler` VALUES ('100','Corrie','Kiendl') ; 

INSERT INTO `email` VALUES ('1','aantognazzi1c@twitpic.com','49') ; 
INSERT INTO `email` VALUES ('2','aberetta1t@accuweather.com','66') ; 
INSERT INTO `email` VALUES ('3','abutterly2a@simplemachines.org','83') ; 
INSERT INTO `email` VALUES ('4','agoodhew2g@vk.com','89') ; 
INSERT INTO `email` VALUES ('5','agroves1s@liveinternet.ru','65') ; 
INSERT INTO `email` VALUES ('6','amanklow1j@amazon.co.jp','56') ; 
INSERT INTO `email` VALUES ('7','amcmakin6@altervista.org','7') ; 
INSERT INTO `email` VALUES ('8','bcabralesi@rakuten.co.jp','19') ; 
INSERT INTO `email` VALUES ('9','bgilby1y@freewebs.com','71') ; 
INSERT INTO `email` VALUES ('10','bguerriero2j@fema.gov','92') ; 
INSERT INTO `email` VALUES ('11','bmcowenv@buzzfeed.com','32') ; 
INSERT INTO `email` VALUES ('12','bmepstedn@salon.com','24') ; 
INSERT INTO `email` VALUES ('13','bmordon1h@youku.com','54') ; 
INSERT INTO `email` VALUES ('14','braine14@tuttocitta.it','41') ; 
INSERT INTO `email` VALUES ('15','btaffs1z@webmd.com','72') ; 
INSERT INTO `email` VALUES ('16','byarnell1a@trellian.com','47') ; 
INSERT INTO `email` VALUES ('17','cabrahamian1d@about.me','50') ; 
INSERT INTO `email` VALUES ('18','ccallumj@drupal.org','20') ; 
INSERT INTO `email` VALUES ('19','cfishbourne5@theatlantic.com','6') ; 
INSERT INTO `email` VALUES ('20','cgraybeal7@creativecommons.org','8') ; 
INSERT INTO `email` VALUES ('21','ckiendl2r@hp.com','100') ; 
INSERT INTO `email` VALUES ('22','cspatq@samsung.com','27') ; 
INSERT INTO `email` VALUES ('23','cvanniekerk25@a8.net','78') ; 
INSERT INTO `email` VALUES ('24','cvinson1x@csmonitor.com','70') ; 
INSERT INTO `email` VALUES ('25','dcoleman2m@cloudflare.com','95') ; 
INSERT INTO `email` VALUES ('26','dcreeghant@opera.com','30') ; 
INSERT INTO `email` VALUES ('27','ddoblin1b@feedburner.com','48') ; 
INSERT INTO `email` VALUES ('28','dlaxon8@friendfeed.com','9') ; 
INSERT INTO `email` VALUES ('29','dpreene4@amazon.de','5') ; 
INSERT INTO `email` VALUES ('30','dtoye1g@posterous.com','53') ; 
INSERT INTO `email` VALUES ('31','dvernall2b@si.edu','84') ; 
INSERT INTO `email` VALUES ('32','egerardotg@google.co.uk','17') ; 
INSERT INTO `email` VALUES ('33','egerbl2h@hibu.com','90') ; 
INSERT INTO `email` VALUES ('34','emedlen1r@hubpages.com','64') ; 
INSERT INTO `email` VALUES ('35','fallanson12@admin.ch','39') ; 
INSERT INTO `email` VALUES ('36','fcorradengo17@economist.com','44') ; 
INSERT INTO `email` VALUES ('37','fcupitt18@networksolutions.com','45') ; 
INSERT INTO `email` VALUES ('38','fjoyneso@mozilla.com','25') ; 
INSERT INTO `email` VALUES ('39','flenihanr@wordpress.com','28') ; 
INSERT INTO `email` VALUES ('40','flubomirskix@mysql.com','34') ; 
INSERT INTO `email` VALUES ('41','galderwickm@acquirethisname.com','23') ; 
INSERT INTO `email` VALUES ('42','gchoatz@parallels.com','36') ; 
INSERT INTO `email` VALUES ('43','ghardwick1n@wordpress.org','60') ; 
INSERT INTO `email` VALUES ('44','gpues1@washington.edu','2') ; 
INSERT INTO `email` VALUES ('45','groust10@arstechnica.com','37') ; 
INSERT INTO `email` VALUES ('46','iakerman1k@fotki.com','57') ; 
INSERT INTO `email` VALUES ('47','iharkins20@nydailynews.com','73') ; 
INSERT INTO `email` VALUES ('48','imarklund2c@gmpg.org','85') ; 
INSERT INTO `email` VALUES ('49','imayou29@cmu.edu','82') ; 
INSERT INTO `email` VALUES ('50','ipoytres1q@wp.com','63') ; 
INSERT INTO `email` VALUES ('51','jasserc@yellowpages.com','13') ; 
INSERT INTO `email` VALUES ('52','jdeath2o@unblog.fr','97') ; 
INSERT INTO `email` VALUES ('53','jluebbert1f@shutterfly.com','52') ; 
INSERT INTO `email` VALUES ('54','jpadefieldh@chronoengine.com','18') ; 
INSERT INTO `email` VALUES ('55','jrappa19@yahoo.com','46') ; 
INSERT INTO `email` VALUES ('56','jzucker23@drupal.org','76') ; 
INSERT INTO `email` VALUES ('57','knorcliff2d@google.es','86') ; 
INSERT INTO `email` VALUES ('58','krawls15@wikimedia.org','42') ; 
INSERT INTO `email` VALUES ('59','kvandervelde1p@chron.com','62') ; 
INSERT INTO `email` VALUES ('60','lblankman11@wufoo.com','38') ; 
INSERT INTO `email` VALUES ('61','ldowding2p@archive.org','98') ; 
INSERT INTO `email` VALUES ('62','llinnyw@webmd.com','33') ; 
INSERT INTO `email` VALUES ('63','llovie24@dion.ne.jp','77') ; 
INSERT INTO `email` VALUES ('64','lraittieu@ucla.edu','31') ; 
INSERT INTO `email` VALUES ('65','lrosenblum3@phpbb.com','4') ; 
INSERT INTO `email` VALUES ('66','lsinncockl@slashdot.org','22') ; 
INSERT INTO `email` VALUES ('67','lyalden1w@stanford.edu','69') ; 
INSERT INTO `email` VALUES ('68','lzamoray@economist.com','35') ; 
INSERT INTO `email` VALUES ('69','mcamois2n@angelfire.com','96') ; 
INSERT INTO `email` VALUES ('70','mdrain9@t-online.de','10') ; 
INSERT INTO `email` VALUES ('71','medgson28@trellian.com','81') ; 
INSERT INTO `email` VALUES ('72','mflutep@imageshack.us','26') ; 
INSERT INTO `email` VALUES ('73','mjaggard16@noaa.gov','43') ; 
INSERT INTO `email` VALUES ('74','mlampke22@vimeo.com','75') ; 
INSERT INTO `email` VALUES ('75','mpicheford2l@hostgator.com','94') ; 
INSERT INTO `email` VALUES ('76','mponnsett1v@answers.com','68') ; 
INSERT INTO `email` VALUES ('77','nburnett1e@sitemeter.com','51') ; 
INSERT INTO `email` VALUES ('78','ntattershall0@scientificamerican.com','1') ; 
INSERT INTO `email` VALUES ('79','ntrigwell1o@statcounter.com','61') ; 
INSERT INTO `email` VALUES ('80','ometcalfe26@indiegogo.com','79') ; 
INSERT INTO `email` VALUES ('81','omonkeman2@msu.edu','3') ; 
INSERT INTO `email` VALUES ('82','ovearsb@samsung.com','12') ; 
INSERT INTO `email` VALUES ('83','pdobeye@dropbox.com','15') ; 
INSERT INTO `email` VALUES ('84','pmealiffes@oakley.com','29') ; 
INSERT INTO `email` VALUES ('85','rbentjens13@noaa.gov','40') ; 
INSERT INTO `email` VALUES ('86','rellsbury2i@plala.or.jp','91') ; 
INSERT INTO `email` VALUES ('87','rfraziera@geocities.com','11') ; 
INSERT INTO `email` VALUES ('88','sbockett21@boston.com','74') ; 
INSERT INTO `email` VALUES ('89','scraigg2e@pbs.org','87') ; 
INSERT INTO `email` VALUES ('90','sharper2f@prlog.org','88') ; 
INSERT INTO `email` VALUES ('91','sloosley27@phpbb.com','80') ; 
INSERT INTO `email` VALUES ('92','spain2k@opensource.org','93') ; 
INSERT INTO `email` VALUES ('93','tbeen1u@ft.com','67') ; 
INSERT INTO `email` VALUES ('94','vbennis2q@ehow.com','99') ; 
INSERT INTO `email` VALUES ('95','vkitson1m@zimbio.com','59') ; 
INSERT INTO `email` VALUES ('96','vparcells1l@mit.edu','58') ; 
INSERT INTO `email` VALUES ('97','vrudledge1i@utexas.edu','55') ; 
INSERT INTO `email` VALUES ('98','wsermank@nydailynews.com','21') ; 
INSERT INTO `email` VALUES ('99','wstapfordf@webs.com','16') ; 
INSERT INTO `email` VALUES ('100','wtingcombd@reddit.com','14') ; 

INSERT INTO `reservation` VALUES ('1','85','10','3','1','2018-06-15 05:53:14') ; 
INSERT INTO `reservation` VALUES ('2','23','76','1','3','2018-05-19 06:35:25') ; 
INSERT INTO `reservation` VALUES ('3','72','13','4','1','2018-07-28 03:42:30') ; 
INSERT INTO `reservation` VALUES ('4','28','97','2','2','2018-06-23 14:37:06') ; 
INSERT INTO `reservation` VALUES ('5','29','35','2','1','2018-05-13 14:13:53') ; 
INSERT INTO `reservation` VALUES ('6','99','31','2','3','2018-09-24 12:52:54') ; 
INSERT INTO `reservation` VALUES ('7','97','19','3','2','2018-05-26 12:44:53') ; 
INSERT INTO `reservation` VALUES ('8','22','47','4','1','2018-09-22 22:45:45') ; 
INSERT INTO `reservation` VALUES ('9','63','20','1','3','2018-06-14 23:33:58') ; 
INSERT INTO `reservation` VALUES ('10','50','34','4','1','2018-06-01 05:33:21') ; 
INSERT INTO `reservation` VALUES ('11','71','11','2','1','2018-09-29 14:24:56') ; 
INSERT INTO `reservation` VALUES ('12','78','17','3','2','2018-07-25 01:41:44') ; 
INSERT INTO `reservation` VALUES ('13','24','64','1','1','2018-06-03 08:37:11') ; 
INSERT INTO `reservation` VALUES ('14','47','66','1','3','2018-07-11 03:12:13') ; 
INSERT INTO `reservation` VALUES ('15','92','18','3','3','2018-07-19 11:06:34') ; 
INSERT INTO `reservation` VALUES ('16','84','45','4','1','2018-06-14 16:57:28') ; 
INSERT INTO `reservation` VALUES ('17','89','7','2','3','2018-05-07 23:34:41') ; 
INSERT INTO `reservation` VALUES ('18','68','74','1','1','2018-07-17 06:02:43') ; 
INSERT INTO `reservation` VALUES ('19','4','29','2','3','2018-09-12 08:26:21') ; 
INSERT INTO `reservation` VALUES ('20','12','4','2','1','2018-08-18 00:07:58') ; 
INSERT INTO `reservation` VALUES ('21','53','1','3','2','2018-05-29 09:21:45') ; 
INSERT INTO `reservation` VALUES ('22','83','61','2','1','2018-10-01 02:56:02') ; 
INSERT INTO `reservation` VALUES ('23','44','56','1','2','2018-10-21 13:19:07') ; 
INSERT INTO `reservation` VALUES ('24','3','44','2','1','2018-06-20 03:20:13') ; 
INSERT INTO `reservation` VALUES ('25','79','28','1','2','2018-08-25 05:03:20') ; 
INSERT INTO `reservation` VALUES ('26','60','91','1','1','2018-10-29 18:33:47') ; 
INSERT INTO `reservation` VALUES ('27','70','49','2','2','2018-09-18 00:59:33') ; 
INSERT INTO `reservation` VALUES ('28','74','84','4','2','2018-09-22 10:06:44') ; 
INSERT INTO `reservation` VALUES ('29','57','90','1','2','2018-10-29 13:37:55') ; 
INSERT INTO `reservation` VALUES ('30','17','57','1','2','2018-07-05 19:19:36') ; 
INSERT INTO `reservation` VALUES ('31','52','5','1','1','2018-06-19 05:43:47') ; 
INSERT INTO `reservation` VALUES ('32','45','98','2','3','2018-06-03 00:31:55') ; 
INSERT INTO `reservation` VALUES ('33','81','65','3','3','2018-08-09 08:03:22') ; 
INSERT INTO `reservation` VALUES ('34','75','63','2','3','2018-09-23 05:48:01') ; 
INSERT INTO `reservation` VALUES ('35','43','69','1','1','2018-06-21 23:50:51') ; 
INSERT INTO `reservation` VALUES ('36','37','25','1','2','2018-07-05 12:16:25') ; 
INSERT INTO `reservation` VALUES ('37','31','92','3','2','2018-09-15 06:01:35') ; 
INSERT INTO `reservation` VALUES ('38','8','59','2','2','2018-10-10 01:54:17') ; 
INSERT INTO `reservation` VALUES ('39','34','71','4','3','2018-05-18 00:51:31') ; 
INSERT INTO `reservation` VALUES ('40','32','94','2','2','2018-05-07 11:56:15') ; 
INSERT INTO `reservation` VALUES ('41','16','48','2','3','2018-07-03 13:57:43') ; 
INSERT INTO `reservation` VALUES ('42','18','2','2','1','2018-06-10 15:17:40') ; 
INSERT INTO `reservation` VALUES ('43','38','86','1','2','2018-07-30 05:47:28') ; 
INSERT INTO `reservation` VALUES ('44','25','40','3','3','2018-06-09 01:45:09') ; 
INSERT INTO `reservation` VALUES ('45','15','33','4','3','2018-05-15 16:22:28') ; 
INSERT INTO `reservation` VALUES ('46','42','24','2','2','2018-07-09 23:29:24') ; 
INSERT INTO `reservation` VALUES ('47','54','96','1','3','2018-06-19 14:19:44') ; 
INSERT INTO `reservation` VALUES ('48','39','60','4','1','2018-10-22 11:50:41') ; 
INSERT INTO `reservation` VALUES ('49','86','39','4','2','2018-10-20 22:48:00') ; 
INSERT INTO `reservation` VALUES ('50','90','15','1','1','2018-05-23 05:41:56') ; 
INSERT INTO `reservation` VALUES ('51','19','79','1','2','2018-08-28 02:36:22') ; 
INSERT INTO `reservation` VALUES ('52','26','9','1','1','2018-06-28 08:50:53') ; 
INSERT INTO `reservation` VALUES ('53','1','95','1','1','2018-08-19 21:52:11') ; 
INSERT INTO `reservation` VALUES ('54','5','38','2','2','2018-06-29 16:57:38') ; 
INSERT INTO `reservation` VALUES ('55','64','42','2','3','2018-07-07 05:27:16') ; 
INSERT INTO `reservation` VALUES ('56','65','50','2','2','2018-05-26 05:20:11') ; 
INSERT INTO `reservation` VALUES ('57','40','78','1','3','2018-05-03 11:52:31') ; 
INSERT INTO `reservation` VALUES ('58','69','82','2','2','2018-07-20 04:22:32') ; 
INSERT INTO `reservation` VALUES ('59','67','87','3','3','2018-06-27 06:59:17') ; 
INSERT INTO `reservation` VALUES ('60','10','12','4','3','2018-10-04 03:03:42') ; 
INSERT INTO `reservation` VALUES ('61','14','3','2','1','2018-08-09 11:56:20') ; 
INSERT INTO `reservation` VALUES ('62','88','16','1','2','2018-09-22 21:32:22') ; 
INSERT INTO `reservation` VALUES ('63','51','85','2','2','2018-09-02 18:25:57') ; 
INSERT INTO `reservation` VALUES ('64','49','81','1','3','2018-08-05 03:43:42') ; 
INSERT INTO `reservation` VALUES ('65','98','30','1','3','2018-06-07 06:57:03') ; 
INSERT INTO `reservation` VALUES ('66','7','14','3','1','2018-09-15 18:59:51') ; 
INSERT INTO `reservation` VALUES ('67','33','36','1','1','2018-09-12 21:13:46') ; 
INSERT INTO `reservation` VALUES ('68','6','51','4','2','2018-06-27 07:01:54') ; 
INSERT INTO `reservation` VALUES ('69','46','83','3','3','2018-10-16 05:19:28') ; 
INSERT INTO `reservation` VALUES ('70','56','43','4','3','2018-09-13 13:38:41') ; 
INSERT INTO `reservation` VALUES ('71','76','100','1','3','2018-06-08 20:51:56') ; 
INSERT INTO `reservation` VALUES ('72','66','41','4','1','2018-08-03 01:45:28') ; 
INSERT INTO `reservation` VALUES ('73','100','70','3','2','2018-09-26 12:41:17') ; 
INSERT INTO `reservation` VALUES ('74','13','27','2','3','2018-10-28 19:46:07') ; 
INSERT INTO `reservation` VALUES ('75','80','93','3','1','2018-06-29 09:08:52') ; 
INSERT INTO `reservation` VALUES ('76','58','46','2','1','2018-09-18 11:43:32') ; 
INSERT INTO `reservation` VALUES ('77','30','62','2','1','2018-06-16 12:40:59') ; 
INSERT INTO `reservation` VALUES ('78','11','67','1','1','2018-09-19 14:13:28') ; 
INSERT INTO `reservation` VALUES ('79','77','73','3','2','2018-06-10 12:30:36') ; 
INSERT INTO `reservation` VALUES ('80','82','23','3','1','2018-05-26 20:17:01') ; 
INSERT INTO `reservation` VALUES ('81','9','99','4','3','2018-10-27 20:58:59') ; 
INSERT INTO `reservation` VALUES ('82','35','72','3','3','2018-06-02 01:50:47') ; 
INSERT INTO `reservation` VALUES ('83','41','55','2','2','2018-05-22 03:57:31') ; 
INSERT INTO `reservation` VALUES ('84','48','6','1','2','2018-05-12 19:46:50') ; 
INSERT INTO `reservation` VALUES ('85','96','37','2','1','2018-08-30 22:49:20') ; 
INSERT INTO `reservation` VALUES ('86','2','32','3','3','2018-07-28 09:10:04') ; 
INSERT INTO `reservation` VALUES ('87','27','54','1','3','2018-06-13 08:28:19') ; 
INSERT INTO `reservation` VALUES ('88','55','77','3','1','2018-05-16 21:06:46') ; 
INSERT INTO `reservation` VALUES ('89','62','52','3','2','2018-06-17 22:33:59') ; 
INSERT INTO `reservation` VALUES ('90','93','21','3','3','2018-09-12 02:34:13') ; 
INSERT INTO `reservation` VALUES ('91','59','58','2','2','2018-06-27 08:35:57') ; 
INSERT INTO `reservation` VALUES ('92','87','68','2','2','2018-07-26 13:34:55') ; 
INSERT INTO `reservation` VALUES ('93','94','22','3','1','2018-08-05 06:43:51') ; 
INSERT INTO `reservation` VALUES ('94','36','88','4','3','2018-09-16 12:44:01') ; 
INSERT INTO `reservation` VALUES ('95','73','75','2','3','2018-06-19 17:36:27') ; 
INSERT INTO `reservation` VALUES ('96','61','80','2','1','2018-05-26 07:08:55') ; 
INSERT INTO `reservation` VALUES ('97','20','53','4','2','2018-08-29 22:31:10') ; 
INSERT INTO `reservation` VALUES ('98','95','8','3','2','2018-06-16 06:09:20') ; 
INSERT INTO `reservation` VALUES ('99','21','89','3','1','2018-06-27 21:08:12') ; 
INSERT INTO `reservation` VALUES ('100','91','26','4','2','2018-09-23 01:27:11') ; 

INSERT INTO `phone` VALUES ('1','100-903-4437','71') ; 
INSERT INTO `phone` VALUES ('2','103-909-6392','76') ; 
INSERT INTO `phone` VALUES ('3','109-208-6704','23') ; 
INSERT INTO `phone` VALUES ('4','123-342-3005','93') ; 
INSERT INTO `phone` VALUES ('5','123-555-2704','53') ; 
INSERT INTO `phone` VALUES ('6','124-886-2506','69') ; 
INSERT INTO `phone` VALUES ('7','134-932-5780','40') ; 
INSERT INTO `phone` VALUES ('8','135-614-4276','63') ; 
INSERT INTO `phone` VALUES ('9','151-135-6425','74') ; 
INSERT INTO `phone` VALUES ('10','169-705-6410','56') ; 
INSERT INTO `phone` VALUES ('11','176-970-7658','99') ; 
INSERT INTO `phone` VALUES ('12','179-805-6091','13') ; 
INSERT INTO `phone` VALUES ('13','183-998-8077','16') ; 
INSERT INTO `phone` VALUES ('14','204-936-5986','44') ; 
INSERT INTO `phone` VALUES ('15','209-255-7208','72') ; 
INSERT INTO `phone` VALUES ('16','216-526-2986','46') ; 
INSERT INTO `phone` VALUES ('17','226-142-1121','78') ; 
INSERT INTO `phone` VALUES ('18','228-107-9678','70') ; 
INSERT INTO `phone` VALUES ('19','229-494-6873','52') ; 
INSERT INTO `phone` VALUES ('20','232-331-7584','86') ; 
INSERT INTO `phone` VALUES ('21','235-510-2142','32') ; 
INSERT INTO `phone` VALUES ('22','251-238-3403','12') ; 
INSERT INTO `phone` VALUES ('23','263-218-4635','45') ; 
INSERT INTO `phone` VALUES ('24','266-676-7796','29') ; 
INSERT INTO `phone` VALUES ('25','273-568-5143','9') ; 
INSERT INTO `phone` VALUES ('26','284-442-1937','75') ; 
INSERT INTO `phone` VALUES ('27','284-924-2150','38') ; 
INSERT INTO `phone` VALUES ('28','291-360-3816','8') ; 
INSERT INTO `phone` VALUES ('29','309-850-4730','82') ; 
INSERT INTO `phone` VALUES ('30','311-237-0616','61') ; 
INSERT INTO `phone` VALUES ('31','312-157-9246','66') ; 
INSERT INTO `phone` VALUES ('32','331-415-0290','48') ; 
INSERT INTO `phone` VALUES ('33','339-367-8624','55') ; 
INSERT INTO `phone` VALUES ('34','340-892-5148','36') ; 
INSERT INTO `phone` VALUES ('35','342-280-2987','95') ; 
INSERT INTO `phone` VALUES ('36','360-266-9661','30') ; 
INSERT INTO `phone` VALUES ('37','360-552-7603','81') ; 
INSERT INTO `phone` VALUES ('38','365-338-7150','57') ; 
INSERT INTO `phone` VALUES ('39','376-728-6268','67') ; 
INSERT INTO `phone` VALUES ('40','377-179-9241','100') ; 
INSERT INTO `phone` VALUES ('41','426-413-1018','33') ; 
INSERT INTO `phone` VALUES ('42','443-989-4609','85') ; 
INSERT INTO `phone` VALUES ('43','446-486-4967','43') ; 
INSERT INTO `phone` VALUES ('44','457-286-1774','94') ; 
INSERT INTO `phone` VALUES ('45','458-307-4004','83') ; 
INSERT INTO `phone` VALUES ('46','460-394-7971','26') ; 
INSERT INTO `phone` VALUES ('47','465-275-5850','6') ; 
INSERT INTO `phone` VALUES ('48','475-436-9567','77') ; 
INSERT INTO `phone` VALUES ('49','477-668-1672','21') ; 
INSERT INTO `phone` VALUES ('50','490-774-8505','58') ; 
INSERT INTO `phone` VALUES ('51','500-692-7033','65') ; 
INSERT INTO `phone` VALUES ('52','501-291-5417','88') ; 
INSERT INTO `phone` VALUES ('53','513-534-3636','31') ; 
INSERT INTO `phone` VALUES ('54','522-940-8846','17') ; 
INSERT INTO `phone` VALUES ('55','536-129-7919','7') ; 
INSERT INTO `phone` VALUES ('56','540-393-1497','19') ; 
INSERT INTO `phone` VALUES ('57','551-291-7346','92') ; 
INSERT INTO `phone` VALUES ('58','560-473-3651','24') ; 
INSERT INTO `phone` VALUES ('59','561-549-0700','84') ; 
INSERT INTO `phone` VALUES ('60','563-852-1948','80') ; 
INSERT INTO `phone` VALUES ('61','576-544-4679','20') ; 
INSERT INTO `phone` VALUES ('62','585-194-8676','60') ; 
INSERT INTO `phone` VALUES ('63','598-842-2847','96') ; 
INSERT INTO `phone` VALUES ('64','608-871-6119','47') ; 
INSERT INTO `phone` VALUES ('65','614-236-4266','87') ; 
INSERT INTO `phone` VALUES ('66','648-721-1817','15') ; 
INSERT INTO `phone` VALUES ('67','650-937-2476','35') ; 
INSERT INTO `phone` VALUES ('68','656-105-7242','64') ; 
INSERT INTO `phone` VALUES ('69','659-876-2008','79') ; 
INSERT INTO `phone` VALUES ('70','665-257-6602','3') ; 
INSERT INTO `phone` VALUES ('71','667-417-9006','50') ; 
INSERT INTO `phone` VALUES ('72','672-720-7032','49') ; 
INSERT INTO `phone` VALUES ('73','677-182-8636','91') ; 
INSERT INTO `phone` VALUES ('74','684-743-6399','11') ; 
INSERT INTO `phone` VALUES ('75','702-983-4224','54') ; 
INSERT INTO `phone` VALUES ('76','704-791-4946','62') ; 
INSERT INTO `phone` VALUES ('77','726-165-5462','34') ; 
INSERT INTO `phone` VALUES ('78','727-295-2129','4') ; 
INSERT INTO `phone` VALUES ('79','727-955-4738','2') ; 
INSERT INTO `phone` VALUES ('80','735-447-9981','90') ; 
INSERT INTO `phone` VALUES ('81','769-886-6501','51') ; 
INSERT INTO `phone` VALUES ('82','791-196-2327','39') ; 
INSERT INTO `phone` VALUES ('83','799-280-7851','98') ; 
INSERT INTO `phone` VALUES ('84','805-300-6152','27') ; 
INSERT INTO `phone` VALUES ('85','815-743-0640','41') ; 
INSERT INTO `phone` VALUES ('86','834-845-4034','73') ; 
INSERT INTO `phone` VALUES ('87','847-254-4657','42') ; 
INSERT INTO `phone` VALUES ('88','852-364-1660','10') ; 
INSERT INTO `phone` VALUES ('89','876-509-9383','59') ; 
INSERT INTO `phone` VALUES ('90','891-871-4293','97') ; 
INSERT INTO `phone` VALUES ('91','909-203-3615','37') ; 
INSERT INTO `phone` VALUES ('92','911-766-3419','14') ; 
INSERT INTO `phone` VALUES ('93','951-734-8267','18') ; 
INSERT INTO `phone` VALUES ('94','959-851-7193','89') ; 
INSERT INTO `phone` VALUES ('95','964-627-0707','25') ; 
INSERT INTO `phone` VALUES ('96','966-183-0642','68') ; 
INSERT INTO `phone` VALUES ('97','981-329-5784','1') ; 
INSERT INTO `phone` VALUES ('98','985-897-0047','5') ; 
INSERT INTO `phone` VALUES ('99','986-945-7547','22') ; 
INSERT INTO `phone` VALUES ('100','992-424-8508','28') ; 

INSERT INTO `payment_card_type` VALUES ('1','Visa') ; 
INSERT INTO `payment_card_type` VALUES ('2','Mastercard') ; 
INSERT INTO `payment_card_type` VALUES ('3','American Express') ; 
INSERT INTO `payment_card_type` VALUES ('4','Discover') ; 

INSERT INTO `payment_card` VALUES ('1','4075308087290424','2021-11-01','109','13','1') ; 
INSERT INTO `payment_card` VALUES ('2','5182749713138619','2021-05-01','110','40','2') ; 
INSERT INTO `payment_card` VALUES ('3','5384596672003300','2018-11-01','125','38','2') ; 
INSERT INTO `payment_card` VALUES ('4','4757960525875938','2023-01-01','126','5','1') ; 
INSERT INTO `payment_card` VALUES ('5','5529668484893537','2018-08-01','132','33','2') ; 
INSERT INTO `payment_card` VALUES ('6','5269618840638468','2020-04-01','133','46','2') ; 
INSERT INTO `payment_card` VALUES ('7','4716277640625415','2025-04-01','136','20','1') ; 
INSERT INTO `payment_card` VALUES ('8','5491103185289268','2020-11-01','144','30','2') ; 
INSERT INTO `payment_card` VALUES ('9','6011200625041744','2024-09-01','152','96','4') ; 
INSERT INTO `payment_card` VALUES ('10','6011639188243009','2022-12-01','155','82','4') ; 
INSERT INTO `payment_card` VALUES ('11','375111791664057','2024-07-01','158','52','3') ; 
INSERT INTO `payment_card` VALUES ('12','4532174538190796','2019-07-01','169','25','1') ; 
INSERT INTO `payment_card` VALUES ('13','6011851200173599','2021-12-01','179','80','4') ; 
INSERT INTO `payment_card` VALUES ('14','6011835973978631','2021-10-01','211','92','4') ; 
INSERT INTO `payment_card` VALUES ('15','375513972298144','2021-02-01','212','53','3') ; 
INSERT INTO `payment_card` VALUES ('16','346131960401624','2021-01-01','215','60','3') ; 
INSERT INTO `payment_card` VALUES ('17','372032812236092','2022-02-01','218','64','3') ; 
INSERT INTO `payment_card` VALUES ('18','4485016998816146','2020-11-01','220','6','1') ; 
INSERT INTO `payment_card` VALUES ('19','5417783449449781','2021-02-01','230','47','2') ; 
INSERT INTO `payment_card` VALUES ('20','6011724858199861','2024-12-01','239','99','4') ; 
INSERT INTO `payment_card` VALUES ('21','370181926274374','2019-08-01','242','70','3') ; 
INSERT INTO `payment_card` VALUES ('22','4916257882605471','2020-02-01','244','3','1') ; 
INSERT INTO `payment_card` VALUES ('23','343790024826119','2023-08-01','247','67','3') ; 
INSERT INTO `payment_card` VALUES ('24','6011327889559044','2021-04-01','255','98','4') ; 
INSERT INTO `payment_card` VALUES ('25','4556320804679092','2022-02-01','263','4','1') ; 
INSERT INTO `payment_card` VALUES ('26','6011195741306700','2021-03-01','270','95','4') ; 
INSERT INTO `payment_card` VALUES ('27','6011944595284640','2022-04-01','277','90','4') ; 
INSERT INTO `payment_card` VALUES ('28','344362810948199','2019-08-01','284','66','3') ; 
INSERT INTO `payment_card` VALUES ('29','4929152753254076','2019-05-01','291','12','1') ; 
INSERT INTO `payment_card` VALUES ('30','6011345833667325','2025-06-01','297','89','4') ; 
INSERT INTO `payment_card` VALUES ('31','4916537468320078','2022-04-01','306','19','1') ; 
INSERT INTO `payment_card` VALUES ('32','374107383166213','2019-03-01','318','58','3') ; 
INSERT INTO `payment_card` VALUES ('33','4929821560845108','2025-12-01','320','17','1') ; 
INSERT INTO `payment_card` VALUES ('34','5240528150345626','2023-08-01','323','39','2') ; 
INSERT INTO `payment_card` VALUES ('35','4024007137462098','2021-02-01','326','15','1') ; 
INSERT INTO `payment_card` VALUES ('36','341994695501397','2022-09-01','329','73','3') ; 
INSERT INTO `payment_card` VALUES ('37','4916418450362206','2018-11-01','338','23','1') ; 
INSERT INTO `payment_card` VALUES ('38','348755083449587','2023-06-01','348','71','3') ; 
INSERT INTO `payment_card` VALUES ('39','4556137206491870','2021-10-01','360','10','1') ; 
INSERT INTO `payment_card` VALUES ('40','4916846302864120','2020-10-01','364','1','1') ; 
INSERT INTO `payment_card` VALUES ('41','374215901647422','2020-07-01','365','61','3') ; 
INSERT INTO `payment_card` VALUES ('42','6011676952691211','2024-11-01','373','76','4') ; 
INSERT INTO `payment_card` VALUES ('43','377823259849313','2019-09-01','389','69','3') ; 
INSERT INTO `payment_card` VALUES ('44','5246406213894530','2021-07-01','393','32','2') ; 
INSERT INTO `payment_card` VALUES ('45','375198226286069','2020-08-01','402','75','3') ; 
INSERT INTO `payment_card` VALUES ('46','4556976180984644','2019-11-01','415','2','1') ; 
INSERT INTO `payment_card` VALUES ('47','6011626214810232','2023-04-01','424','87','4') ; 
INSERT INTO `payment_card` VALUES ('48','6011521196272479','2024-06-01','426','84','4') ; 
INSERT INTO `payment_card` VALUES ('49','6011221365941760','2025-05-01','442','100','4') ; 
INSERT INTO `payment_card` VALUES ('50','5181340196094288','2021-09-01','447','42','2') ; 
INSERT INTO `payment_card` VALUES ('51','4539748019282892','2020-01-01','452','9','1') ; 
INSERT INTO `payment_card` VALUES ('52','5185958032967189','2020-04-01','452','34','2') ; 
INSERT INTO `payment_card` VALUES ('53','4024007138845796','2024-10-01','465','18','1') ; 
INSERT INTO `payment_card` VALUES ('54','5416253563553801','2022-11-01','473','45','2') ; 
INSERT INTO `payment_card` VALUES ('55','5435166823556744','2024-11-01','477','26','2') ; 
INSERT INTO `payment_card` VALUES ('56','6011915964104114','2023-03-01','482','77','4') ; 
INSERT INTO `payment_card` VALUES ('57','6011729645727189','2020-12-01','484','91','4') ; 
INSERT INTO `payment_card` VALUES ('58','372121573290610','2019-12-01','511','59','3') ; 
INSERT INTO `payment_card` VALUES ('59','349703432561198','2022-06-01','513','55','3') ; 
INSERT INTO `payment_card` VALUES ('60','5359242664234923','2025-10-01','513','35','2') ; 
INSERT INTO `payment_card` VALUES ('61','5335456045942587','2022-04-01','515','48','2') ; 
INSERT INTO `payment_card` VALUES ('62','371734812523491','2020-05-01','518','57','3') ; 
INSERT INTO `payment_card` VALUES ('63','4485428110512240','2022-03-01','536','16','1') ; 
INSERT INTO `payment_card` VALUES ('64','5198207806596476','2021-05-01','549','43','2') ; 
INSERT INTO `payment_card` VALUES ('65','5431562708728024','2020-10-01','564','49','2') ; 
INSERT INTO `payment_card` VALUES ('66','6011554024132987','2020-05-01','584','78','4') ; 
INSERT INTO `payment_card` VALUES ('67','5303764320636081','2022-11-01','606','37','2') ; 
INSERT INTO `payment_card` VALUES ('68','5526686298778663','2021-11-01','615','29','2') ; 
INSERT INTO `payment_card` VALUES ('69','5393804977946929','2024-06-01','617','28','2') ; 
INSERT INTO `payment_card` VALUES ('70','5261525955972798','2025-02-01','635','44','2') ; 
INSERT INTO `payment_card` VALUES ('71','4024007148490880','2023-04-01','646','7','1') ; 
INSERT INTO `payment_card` VALUES ('72','378629857938591','2021-06-01','649','54','3') ; 
INSERT INTO `payment_card` VALUES ('73','372330140449431','2025-04-01','655','72','3') ; 
INSERT INTO `payment_card` VALUES ('74','377071163334606','2021-12-01','655','65','3') ; 
INSERT INTO `payment_card` VALUES ('75','4916484715914835','2021-09-01','665','21','1') ; 
INSERT INTO `payment_card` VALUES ('76','5541555361205378','2022-02-01','667','27','2') ; 
INSERT INTO `payment_card` VALUES ('77','6011907305678328','2022-02-01','671','86','4') ; 
INSERT INTO `payment_card` VALUES ('78','5121277020324593','2023-09-01','675','41','2') ; 
INSERT INTO `payment_card` VALUES ('79','6011240461463651','2020-02-01','688','94','4') ; 
INSERT INTO `payment_card` VALUES ('80','5355172157408920','2018-02-01','696','36','2') ; 
INSERT INTO `payment_card` VALUES ('81','6011020095725885','2024-08-01','712','83','4') ; 
INSERT INTO `payment_card` VALUES ('82','6011008907893330','2022-08-01','736','85','4') ; 
INSERT INTO `payment_card` VALUES ('83','6011788994303018','2024-02-01','746','93','4') ; 
INSERT INTO `payment_card` VALUES ('84','376156208199154','2024-03-01','761','74','3') ; 
INSERT INTO `payment_card` VALUES ('85','6011690463100786','2024-05-01','766','81','4') ; 
INSERT INTO `payment_card` VALUES ('86','374732694030996','2018-07-01','772','62','3') ; 
INSERT INTO `payment_card` VALUES ('87','6011764919112594','2023-08-01','788','97','4') ; 
INSERT INTO `payment_card` VALUES ('88','4716257120925709','2023-04-01','804','11','1') ; 
INSERT INTO `payment_card` VALUES ('89','6011621884556603','2020-10-01','811','79','4') ; 
INSERT INTO `payment_card` VALUES ('90','378451213772261','2024-09-01','822','68','3') ; 
INSERT INTO `payment_card` VALUES ('91','6011037292780810','2023-10-01','837','88','4') ; 
INSERT INTO `payment_card` VALUES ('92','4556111178222142','2019-10-01','848','14','1') ; 
INSERT INTO `payment_card` VALUES ('93','349062377192711','2019-02-01','878','51','3') ; 
INSERT INTO `payment_card` VALUES ('94','345700283345857','2019-03-01','931','63','3') ; 
INSERT INTO `payment_card` VALUES ('95','5124428054631315','2021-04-01','961','50','2') ; 
INSERT INTO `payment_card` VALUES ('96','5200225628360018','2019-11-01','969','31','2') ; 
INSERT INTO `payment_card` VALUES ('97','370539977782167','2021-08-01','973','56','3') ; 
INSERT INTO `payment_card` VALUES ('98','4485418616946729','2019-10-01','977','22','1') ; 
INSERT INTO `payment_card` VALUES ('99','4485055525194700','2024-02-01','978','24','1') ; 
INSERT INTO `payment_card` VALUES ('100','4024007133313584','2018-10-01','992','8','1') ; 

