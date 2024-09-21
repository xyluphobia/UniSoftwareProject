use betracker;

-- Finance Column --
CREATE TABLE IF NOT EXISTS `betracker`.`fincols` (
  `FinColID` INT NOT NULL auto_increment,
  `UserID` INT NOT NULL default 0,
  `SequenceID` INT NOT NULL default 0,
  `AssetID` INT NULL DEFAULT NULL,
  `LiabilityID` INT NULL DEFAULT NULL,
  `Name` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`FinColID`),
  CONSTRAINT `fincols_ibfk_1`
    FOREIGN KEY (`AssetID`)
    REFERENCES `betracker`.`assets` (`AssetID`),
  CONSTRAINT `fincols_ibfk_2`
    FOREIGN KEY (`LiabilityID`)
    REFERENCES `betracker`.`liabilities` (`LiabilityID`));

-- Finance Row --
CREATE TABLE IF NOT EXISTS `betracker`.`finlines` (
  `FinLineID` INT NOT NULL AUTO_INCREMENT,
  `UserID` INT NOT NULL default 0,
  `SequenceID` INT NOT NULL default 0,  
  `AssetID` INT NULL DEFAULT NULL,
  `LiabilityID` INT NULL DEFAULT NULL,
  `LineDate` DATE NULL DEFAULT NULL,
  `LineBalance` DECIMAL(10,0) NULL DEFAULT NULL,
  PRIMARY KEY (`FinLineID`),
  CONSTRAINT `finlines_ibfk_1`
    FOREIGN KEY (`AssetID`)
    REFERENCES `betracker`.`assets` (`AssetID`),
  CONSTRAINT `finlines_ibfk_2`
    FOREIGN KEY (`LiabilityID`)
    REFERENCES `betracker`.`liabilities` (`LiabilityID`));    

-- Finance Breakdown --    
CREATE TABLE IF NOT EXISTS `betracker`.`finbreakdowns` (
  `FinBreakdownID` INT NOT NULL AUTO_INCREMENT,
  `IncomeID` INT NULL DEFAULT NULL,
  `ExpenseID` INT NULL DEFAULT NULL,
  `ItemDate` DATE NULL DEFAULT NULL,
  `ItemName` VARCHAR(255) NULL DEFAULT NULL,
  `ItemAmount` DECIMAL(10,0) NULL DEFAULT NULL,
  `ItemIteration` INT NULL DEFAULT NULL,
  PRIMARY KEY (`FinBreakdownID`),
  CONSTRAINT `finbreakdowns_ibfk_1`
    FOREIGN KEY (`IncomeID`)
    REFERENCES `betracker`.`incomes` (`IncomeID`),
  CONSTRAINT `finbreakdowns_ibfk_2`
    FOREIGN KEY (`ExpenseID`)
    REFERENCES `betracker`.`expenses` (`ExpenseID`));
