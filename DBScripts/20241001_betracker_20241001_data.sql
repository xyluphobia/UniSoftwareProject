-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: betracker
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets` (
  `AssetID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `AssetTypeID` int DEFAULT NULL,
  `InitialBalance` decimal(10,0) DEFAULT NULL,
  `CurrentBalance` decimal(10,0) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `TargetBalance` decimal(10,0) DEFAULT NULL,
  `TargetDate` date DEFAULT NULL,
  PRIMARY KEY (`AssetID`),
  KEY `AssetTypeID` (`AssetTypeID`),
  CONSTRAINT `assets_ibfk_1` FOREIGN KEY (`AssetTypeID`) REFERENCES `assettypes` (`AssetTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (13,'Bank','Bank',53,1000,500,'2024-09-30','2026-09-30',10000,'2026-09-30');
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assettypes`
--

DROP TABLE IF EXISTS `assettypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assettypes` (
  `AssetTypeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`AssetTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assettypes`
--

LOCK TABLES `assettypes` WRITE;
/*!40000 ALTER TABLE `assettypes` DISABLE KEYS */;
INSERT INTO `assettypes` VALUES (53,'Financial','Financial');
/*!40000 ALTER TABLE `assettypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authlevels`
--

DROP TABLE IF EXISTS `authlevels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authlevels` (
  `AuthLevelID` int NOT NULL,
  `LevelName` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`AuthLevelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authlevels`
--

LOCK TABLES `authlevels` WRITE;
/*!40000 ALTER TABLE `authlevels` DISABLE KEYS */;
/*!40000 ALTER TABLE `authlevels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `budgetitems`
--

DROP TABLE IF EXISTS `budgetitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budgetitems` (
  `BudgetItemID` int NOT NULL,
  `BudgetID` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `ExpenseID` int DEFAULT NULL,
  `IncomeID` int DEFAULT NULL,
  `AssetID` int DEFAULT NULL,
  `LiabilityID` int DEFAULT NULL,
  PRIMARY KEY (`BudgetItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `budgetitems`
--

LOCK TABLES `budgetitems` WRITE;
/*!40000 ALTER TABLE `budgetitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `budgetitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `ExpenseID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `ExpenseTypeID` int DEFAULT NULL,
  `AssetID` int DEFAULT NULL,
  `LiabilityID` int DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Amount` decimal(10,0) DEFAULT NULL,
  `RecurringPeriodID` int DEFAULT NULL,
  `LastPaidDate` date DEFAULT NULL,
  `AutoPaid` tinyint(1) DEFAULT NULL,
  `Applied` tinyint DEFAULT '0',
  PRIMARY KEY (`ExpenseID`),
  KEY `ExpenseTypeID` (`ExpenseTypeID`),
  KEY `AssetID` (`AssetID`),
  KEY `LiabilityID` (`LiabilityID`),
  KEY `RecurringPeriodID` (`RecurringPeriodID`),
  CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`ExpenseTypeID`) REFERENCES `expensetypes` (`ExpenseTypeID`),
  CONSTRAINT `expenses_ibfk_2` FOREIGN KEY (`AssetID`) REFERENCES `assets` (`AssetID`),
  CONSTRAINT `expenses_ibfk_3` FOREIGN KEY (`LiabilityID`) REFERENCES `liabilities` (`LiabilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expensetypes`
--

DROP TABLE IF EXISTS `expensetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expensetypes` (
  `ExpenseTypeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`ExpenseTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expensetypes`
--

LOCK TABLES `expensetypes` WRITE;
/*!40000 ALTER TABLE `expensetypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `expensetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finbreakdowns`
--

DROP TABLE IF EXISTS `finbreakdowns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finbreakdowns` (
  `FinBreakdownID` int NOT NULL AUTO_INCREMENT,
  `IncomeID` int DEFAULT NULL,
  `ExpenseID` int DEFAULT NULL,
  `ItemDate` date DEFAULT NULL,
  `ItemName` varchar(255) DEFAULT NULL,
  `ItemAmount` decimal(10,0) DEFAULT NULL,
  `ItemIteration` int DEFAULT NULL,
  PRIMARY KEY (`FinBreakdownID`),
  KEY `finbreakdowns_ibfk_1` (`IncomeID`),
  KEY `finbreakdowns_ibfk_2` (`ExpenseID`),
  CONSTRAINT `finbreakdowns_ibfk_1` FOREIGN KEY (`IncomeID`) REFERENCES `incomes` (`IncomeID`),
  CONSTRAINT `finbreakdowns_ibfk_2` FOREIGN KEY (`ExpenseID`) REFERENCES `expenses` (`ExpenseID`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finbreakdowns`
--

LOCK TABLES `finbreakdowns` WRITE;
/*!40000 ALTER TABLE `finbreakdowns` DISABLE KEYS */;
INSERT INTO `finbreakdowns` VALUES (105,213,NULL,'2024-09-30','Job',2500,0),(106,213,NULL,'2024-10-14','Job',2500,1),(107,213,NULL,'2024-10-28','Job',2500,2),(108,213,NULL,'2024-11-11','Job',2500,3),(109,213,NULL,'2024-11-25','Job',2500,4),(110,213,NULL,'2024-12-09','Job',2500,5),(111,213,NULL,'2024-12-23','Job',2500,6),(112,213,NULL,'2025-01-06','Job',2500,7),(113,213,NULL,'2025-01-20','Job',2500,8),(114,213,NULL,'2025-02-03','Job',2500,9),(115,213,NULL,'2025-02-17','Job',2500,10),(116,213,NULL,'2025-03-03','Job',2500,11),(117,213,NULL,'2025-03-17','Job',2500,12),(118,213,NULL,'2025-03-31','Job',2500,13),(119,213,NULL,'2025-04-14','Job',2500,14),(120,213,NULL,'2025-04-28','Job',2500,15),(121,213,NULL,'2025-05-12','Job',2500,16),(122,213,NULL,'2025-05-26','Job',2500,17),(123,213,NULL,'2025-06-09','Job',2500,18),(124,213,NULL,'2025-06-23','Job',2500,19),(125,213,NULL,'2025-07-07','Job',2500,20),(126,213,NULL,'2025-07-21','Job',2500,21),(127,213,NULL,'2025-08-04','Job',2500,22),(128,213,NULL,'2025-08-18','Job',2500,23),(129,213,NULL,'2025-09-01','Job',2500,24),(130,213,NULL,'2025-09-15','Job',2500,25),(131,213,NULL,'2025-09-29','Job',2500,26);
/*!40000 ALTER TABLE `finbreakdowns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fincols`
--

DROP TABLE IF EXISTS `fincols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fincols` (
  `FinColID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL DEFAULT '0',
  `SequenceID` int NOT NULL DEFAULT '0',
  `AssetID` int DEFAULT NULL,
  `LiabilityID` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`FinColID`),
  KEY `fincols_ibfk_1` (`AssetID`),
  KEY `fincols_ibfk_2` (`LiabilityID`),
  CONSTRAINT `fincols_ibfk_1` FOREIGN KEY (`AssetID`) REFERENCES `assets` (`AssetID`),
  CONSTRAINT `fincols_ibfk_2` FOREIGN KEY (`LiabilityID`) REFERENCES `liabilities` (`LiabilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fincols`
--

LOCK TABLES `fincols` WRITE;
/*!40000 ALTER TABLE `fincols` DISABLE KEYS */;
INSERT INTO `fincols` VALUES (11,0,999,13,NULL,'Bank');
/*!40000 ALTER TABLE `fincols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finlines`
--

DROP TABLE IF EXISTS `finlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finlines` (
  `FinLineID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL DEFAULT '0',
  `SequenceID` int NOT NULL DEFAULT '0',
  `AssetID` int DEFAULT NULL,
  `LiabilityID` int DEFAULT NULL,
  `LineDate` date DEFAULT NULL,
  `LineBalance` float DEFAULT NULL,
  PRIMARY KEY (`FinLineID`),
  KEY `finlines_ibfk_1` (`AssetID`),
  KEY `finlines_ibfk_2` (`LiabilityID`),
  CONSTRAINT `finlines_ibfk_1` FOREIGN KEY (`AssetID`) REFERENCES `assets` (`AssetID`),
  CONSTRAINT `finlines_ibfk_2` FOREIGN KEY (`LiabilityID`) REFERENCES `liabilities` (`LiabilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=276 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finlines`
--

LOCK TABLES `finlines` WRITE;
/*!40000 ALTER TABLE `finlines` DISABLE KEYS */;
INSERT INTO `finlines` VALUES (249,0,1,13,NULL,'2024-09-30',2500),(250,0,1,13,NULL,'2024-10-14',5000),(251,0,1,13,NULL,'2024-10-28',7500),(252,0,1,13,NULL,'2024-11-11',10000),(253,0,1,13,NULL,'2024-11-25',12500),(254,0,1,13,NULL,'2024-12-09',15000),(255,0,1,13,NULL,'2024-12-23',17500),(256,0,1,13,NULL,'2025-01-06',20000),(257,0,1,13,NULL,'2025-01-20',22500),(258,0,1,13,NULL,'2025-02-03',25000),(259,0,1,13,NULL,'2025-02-17',27500),(260,0,1,13,NULL,'2025-03-03',30000),(261,0,1,13,NULL,'2025-03-17',32500),(262,0,1,13,NULL,'2025-03-31',35000),(263,0,1,13,NULL,'2025-04-14',37500),(264,0,1,13,NULL,'2025-04-28',40000),(265,0,1,13,NULL,'2025-05-12',42500),(266,0,1,13,NULL,'2025-05-26',45000),(267,0,1,13,NULL,'2025-06-09',47500),(268,0,1,13,NULL,'2025-06-23',50000),(269,0,1,13,NULL,'2025-07-07',52500),(270,0,1,13,NULL,'2025-07-21',55000),(271,0,1,13,NULL,'2025-08-04',57500),(272,0,1,13,NULL,'2025-08-18',60000),(273,0,1,13,NULL,'2025-09-01',62500),(274,0,1,13,NULL,'2025-09-15',65000),(275,0,1,13,NULL,'2025-09-29',67500);
/*!40000 ALTER TABLE `finlines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graphs`
--

DROP TABLE IF EXISTS `graphs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `graphs` (
  `GraphID` int NOT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Description` text,
  `XAxisTitle` varchar(255) DEFAULT NULL,
  `YAxisTitle` varchar(255) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `BudgetItemID` int DEFAULT NULL,
  PRIMARY KEY (`GraphID`),
  KEY `BudgetItemID` (`BudgetItemID`),
  CONSTRAINT `graphs_ibfk_1` FOREIGN KEY (`BudgetItemID`) REFERENCES `budgetitems` (`BudgetItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graphs`
--

LOCK TABLES `graphs` WRITE;
/*!40000 ALTER TABLE `graphs` DISABLE KEYS */;
/*!40000 ALTER TABLE `graphs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incomes`
--

DROP TABLE IF EXISTS `incomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incomes` (
  `IncomeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `IncomeTypeID` int DEFAULT NULL,
  `AssetID` int DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Amount` decimal(10,0) DEFAULT NULL,
  `RecurringPeriodID` int DEFAULT NULL,
  `LastReceivedDate` date DEFAULT NULL,
  `LiabilityID` int DEFAULT NULL,
  `Applied` tinyint DEFAULT '0',
  PRIMARY KEY (`IncomeID`),
  KEY `IncomeTypeID` (`IncomeTypeID`),
  KEY `AssetID` (`AssetID`),
  KEY `RecurringPeriodID` (`RecurringPeriodID`),
  KEY `incomes_ibfk_3` (`LiabilityID`),
  CONSTRAINT `incomes_ibfk_1` FOREIGN KEY (`IncomeTypeID`) REFERENCES `incometypes` (`IncomeTypeID`),
  CONSTRAINT `incomes_ibfk_2` FOREIGN KEY (`AssetID`) REFERENCES `assets` (`AssetID`),
  CONSTRAINT `incomes_ibfk_3` FOREIGN KEY (`LiabilityID`) REFERENCES `liabilities` (`LiabilityID`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomes`
--

LOCK TABLES `incomes` WRITE;
/*!40000 ALTER TABLE `incomes` DISABLE KEYS */;
INSERT INTO `incomes` VALUES (213,'Job','Job',4,13,'2024-09-30','2025-09-30',2500,2,'2024-09-30',NULL,1);
/*!40000 ALTER TABLE `incomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incometypes`
--

DROP TABLE IF EXISTS `incometypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incometypes` (
  `IncomeTypeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`IncomeTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incometypes`
--

LOCK TABLES `incometypes` WRITE;
/*!40000 ALTER TABLE `incometypes` DISABLE KEYS */;
INSERT INTO `incometypes` VALUES (4,'Salary','Salary');
/*!40000 ALTER TABLE `incometypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `liabilities`
--

DROP TABLE IF EXISTS `liabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liabilities` (
  `LiabilityID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `LiabilityTypeID` int DEFAULT NULL,
  `InitialBalance` decimal(10,0) DEFAULT NULL,
  `CurrentBalance` decimal(10,0) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `TargetBalance` decimal(10,0) DEFAULT NULL,
  `TargetDate` date DEFAULT NULL,
  PRIMARY KEY (`LiabilityID`),
  KEY `LiabilityTypeID` (`LiabilityTypeID`),
  CONSTRAINT `liabilities_ibfk_1` FOREIGN KEY (`LiabilityTypeID`) REFERENCES `liabilitytypes` (`LiabilityTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liabilities`
--

LOCK TABLES `liabilities` WRITE;
/*!40000 ALTER TABLE `liabilities` DISABLE KEYS */;
INSERT INTO `liabilities` VALUES (4,'Card','Credit Card',5,NULL,-1000,'2024-09-30','2026-09-30',NULL,'2026-09-30');
/*!40000 ALTER TABLE `liabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `liabilitytypes`
--

DROP TABLE IF EXISTS `liabilitytypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liabilitytypes` (
  `LiabilityTypeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`LiabilityTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liabilitytypes`
--

LOCK TABLES `liabilitytypes` WRITE;
/*!40000 ALTER TABLE `liabilitytypes` DISABLE KEYS */;
INSERT INTO `liabilitytypes` VALUES (5,'LOC','Line of Credit');
/*!40000 ALTER TABLE `liabilitytypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `LocationID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periods`
--

DROP TABLE IF EXISTS `periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `periods` (
  `PeriodID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Rule` text,
  `WeekendRule` text,
  `PublicHolidayRule` text,
  PRIMARY KEY (`PeriodID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periods`
--

LOCK TABLES `periods` WRITE;
/*!40000 ALTER TABLE `periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publicholidays`
--

DROP TABLE IF EXISTS `publicholidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicholidays` (
  `HolidayID` int NOT NULL,
  `LocationID` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  PRIMARY KEY (`HolidayID`),
  KEY `LocationID` (`LocationID`),
  CONSTRAINT `publicholidays_ibfk_1` FOREIGN KEY (`LocationID`) REFERENCES `locations` (`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicholidays`
--

LOCK TABLES `publicholidays` WRITE;
/*!40000 ALTER TABLE `publicholidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `publicholidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `RoleID` int NOT NULL,
  `RoleName` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfers`
--

DROP TABLE IF EXISTS `transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfers` (
  `TransferID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `SourceAssetID` int DEFAULT NULL,
  `DestinationAssetID` int DEFAULT NULL,
  `Amount` decimal(10,0) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  PRIMARY KEY (`TransferID`),
  KEY `SourceAssetID` (`SourceAssetID`),
  KEY `DestinationAssetID` (`DestinationAssetID`),
  CONSTRAINT `transfers_ibfk_1` FOREIGN KEY (`SourceAssetID`) REFERENCES `assets` (`AssetID`),
  CONSTRAINT `transfers_ibfk_2` FOREIGN KEY (`DestinationAssetID`) REFERENCES `assets` (`AssetID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfers`
--

LOCK TABLES `transfers` WRITE;
/*!40000 ALTER TABLE `transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `UserID` int NOT NULL,
  `Username` varchar(255) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `AuthLevel` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  `OtherDetails` text,
  PRIMARY KEY (`UserID`),
  KEY `AuthLevel` (`AuthLevel`),
  KEY `LocationID` (`LocationID`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`AuthLevel`) REFERENCES `authlevels` (`AuthLevelID`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`LocationID`) REFERENCES `locations` (`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-30 21:02:09

use betracker;
alter table finbreakdowns drop foreign key finbreakdowns_ibfk_1;
alter table finbreakdowns drop foreign key finbreakdowns_ibfk_2;