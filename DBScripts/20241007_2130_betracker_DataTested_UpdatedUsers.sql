-- MySQL dump 10.13  Distrib 9.0.1, for Win64 (x86_64)
--
-- Host: localhost    Database: betracker
-- ------------------------------------------------------
-- Server version	9.0.1

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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (13,'ING Savings','M transaction account',53,1000,900,'2014-01-01','2030-04-01',1000,'2030-04-01'),(14,'CBA Savings (M)','M main savings account',53,100,1000,'2000-04-01','2050-04-01',2000,'2050-04-01'),(15,'CBA Savings (H)','H main savings account',53,100,3000,'2014-01-01','2050-12-31',500,'2050-12-31'),(16,'Super (M)','M superannuation account with main salary income',54,100,500000,'1990-06-30','2030-04-01',1000000,'2030-04-01');
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
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assettypes`
--

LOCK TABLES `assettypes` WRITE;
/*!40000 ALTER TABLE `assettypes` DISABLE KEYS */;
INSERT INTO `assettypes` VALUES (53,'Bank','Savings Bank Accounts'),(54,'Super','Super Annuation Accounts');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES (2,'Food','Weekly groceries',7,NULL,4,'2024-10-01','2025-10-01',250,1,'2024-10-01',NULL,1),(3,'Personal Loan Periodic Charge','Personal loan periodic repayment including principal and interest',9,NULL,6,'2024-10-21','2025-10-21',200,2,'2024-10-21',NULL,1),(4,'Home Loan Periodic Charge','Home loan periodic repayment including principal and interest',9,NULL,5,'2024-10-21','2027-10-21',2000,3,'2024-10-21',NULL,1),(5,'Water Rates','Council water rates and usage',13,NULL,4,'2024-10-21','2027-10-21',300,4,'2024-10-21',NULL,1),(6,'Council Rates','Council rates for land and services',13,NULL,4,'2024-10-21','2027-10-21',500,5,'2024-10-21',NULL,1),(7,'Visa Account Fee','Yealy account fee for Visa credit card',11,NULL,4,'2024-10-21','2027-10-21',100,6,'2014-10-21',NULL,1),(9,'Partial Visa Payment','Partial visa payment',14,13,NULL,'2024-10-01','2025-10-01',500,1,'2024-10-01',NULL,1),(10,'Person Loan Repay','Personal loan periodic payment',14,13,NULL,'2024-10-21','2025-10-21',200,2,'2024-10-21',NULL,1),(11,'Home Loan Repay','Home loan periodic payment',14,13,NULL,'2024-10-21','2027-10-21',4000,3,'2024-10-21',NULL,1),(12,'Home Loan Extra','Home loan extra payment',14,13,NULL,'2024-10-21','2027-10-21',500,4,'2024-10-21',NULL,1),(13,'Personal Loan Extra','Personal loan extra payment',14,15,NULL,'2024-10-21','2027-10-21',250,5,'2024-10-21',NULL,1),(14,'Visa Account Fee','Yearly visa account keeping fee',14,15,NULL,'2024-10-21','2027-10-21',150,6,'2024-10-21',NULL,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expensetypes`
--

LOCK TABLES `expensetypes` WRITE;
/*!40000 ALTER TABLE `expensetypes` DISABLE KEYS */;
INSERT INTO `expensetypes` VALUES (7,'Essentials','Day to day neccessary expenses'),(8,'Utilities','Utilities such as gas, electricity, water etc.'),(9,'Loan Repayment Charge','Loan periodically repayment charged to loan account'),(10,'Credit Card Periodic Repayment','Credit card periodic repayment bill'),(11,'Financial Fees','Fees charged by financial institutions for account keeping and penalties'),(13,'Council','Fees and Rates chatged by local council'),(14,'Transfer (Source)','Transfered funds source');
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
  KEY `finbreakdowns_ibfk_2` (`ExpenseID`)
) ENGINE=InnoDB AUTO_INCREMENT=669 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finbreakdowns`
--

LOCK TABLES `finbreakdowns` WRITE;
/*!40000 ALTER TABLE `finbreakdowns` DISABLE KEYS */;
INSERT INTO `finbreakdowns` VALUES (105,225,NULL,'2024-10-21','Visa Account Fee',150,0),(106,225,NULL,'2025-10-21','Visa Account Fee',150,1),(107,225,NULL,'2026-10-21','Visa Account Fee',150,2),(108,225,NULL,'2027-10-21','Visa Account Fee',150,3),(109,220,NULL,'2024-10-01','Partial Visa Payment',500,0),(110,220,NULL,'2024-10-08','Partial Visa Payment',500,1),(111,220,NULL,'2024-10-15','Partial Visa Payment',500,2),(112,220,NULL,'2024-10-22','Partial Visa Payment',500,3),(113,220,NULL,'2024-10-29','Partial Visa Payment',500,4),(114,220,NULL,'2024-11-05','Partial Visa Payment',500,5),(115,220,NULL,'2024-11-12','Partial Visa Payment',500,6),(116,220,NULL,'2024-11-19','Partial Visa Payment',500,7),(117,220,NULL,'2024-11-26','Partial Visa Payment',500,8),(118,220,NULL,'2024-12-03','Partial Visa Payment',500,9),(119,220,NULL,'2024-12-10','Partial Visa Payment',500,10),(120,220,NULL,'2024-12-17','Partial Visa Payment',500,11),(121,220,NULL,'2024-12-24','Partial Visa Payment',500,12),(122,220,NULL,'2024-12-31','Partial Visa Payment',500,13),(123,220,NULL,'2025-01-07','Partial Visa Payment',500,14),(124,220,NULL,'2025-01-14','Partial Visa Payment',500,15),(125,220,NULL,'2025-01-21','Partial Visa Payment',500,16),(126,220,NULL,'2025-01-28','Partial Visa Payment',500,17),(127,220,NULL,'2025-02-04','Partial Visa Payment',500,18),(128,220,NULL,'2025-02-11','Partial Visa Payment',500,19),(129,220,NULL,'2025-02-18','Partial Visa Payment',500,20),(130,220,NULL,'2025-02-25','Partial Visa Payment',500,21),(131,220,NULL,'2025-03-04','Partial Visa Payment',500,22),(132,220,NULL,'2025-03-11','Partial Visa Payment',500,23),(133,220,NULL,'2025-03-18','Partial Visa Payment',500,24),(134,220,NULL,'2025-03-25','Partial Visa Payment',500,25),(135,220,NULL,'2025-04-01','Partial Visa Payment',500,26),(136,220,NULL,'2025-04-08','Partial Visa Payment',500,27),(137,220,NULL,'2025-04-15','Partial Visa Payment',500,28),(138,220,NULL,'2025-04-22','Partial Visa Payment',500,29),(139,220,NULL,'2025-04-29','Partial Visa Payment',500,30),(140,220,NULL,'2025-05-06','Partial Visa Payment',500,31),(141,220,NULL,'2025-05-13','Partial Visa Payment',500,32),(142,220,NULL,'2025-05-20','Partial Visa Payment',500,33),(143,220,NULL,'2025-05-27','Partial Visa Payment',500,34),(144,220,NULL,'2025-06-03','Partial Visa Payment',500,35),(145,220,NULL,'2025-06-10','Partial Visa Payment',500,36),(146,220,NULL,'2025-06-17','Partial Visa Payment',500,37),(147,220,NULL,'2025-06-24','Partial Visa Payment',500,38),(148,220,NULL,'2025-07-01','Partial Visa Payment',500,39),(149,220,NULL,'2025-07-08','Partial Visa Payment',500,40),(150,220,NULL,'2025-07-15','Partial Visa Payment',500,41),(151,220,NULL,'2025-07-22','Partial Visa Payment',500,42),(152,220,NULL,'2025-07-29','Partial Visa Payment',500,43),(153,220,NULL,'2025-08-05','Partial Visa Payment',500,44),(154,220,NULL,'2025-08-12','Partial Visa Payment',500,45),(155,220,NULL,'2025-08-19','Partial Visa Payment',500,46),(156,220,NULL,'2025-08-26','Partial Visa Payment',500,47),(157,220,NULL,'2025-09-02','Partial Visa Payment',500,48),(158,220,NULL,'2025-09-09','Partial Visa Payment',500,49),(159,220,NULL,'2025-09-16','Partial Visa Payment',500,50),(160,220,NULL,'2025-09-23','Partial Visa Payment',500,51),(161,220,NULL,'2025-09-30','Partial Visa Payment',500,52),(162,213,NULL,'2024-10-01','Rent',450,0),(163,213,NULL,'2024-10-08','Rent',450,1),(164,213,NULL,'2024-10-15','Rent',450,2),(165,213,NULL,'2024-10-22','Rent',450,3),(166,213,NULL,'2024-10-29','Rent',450,4),(167,213,NULL,'2024-11-05','Rent',450,5),(168,213,NULL,'2024-11-12','Rent',450,6),(169,213,NULL,'2024-11-19','Rent',450,7),(170,213,NULL,'2024-11-26','Rent',450,8),(171,213,NULL,'2024-12-03','Rent',450,9),(172,213,NULL,'2024-12-10','Rent',450,10),(173,213,NULL,'2024-12-17','Rent',450,11),(174,213,NULL,'2024-12-24','Rent',450,12),(175,213,NULL,'2024-12-31','Rent',450,13),(176,213,NULL,'2025-01-07','Rent',450,14),(177,213,NULL,'2025-01-14','Rent',450,15),(178,213,NULL,'2025-01-21','Rent',450,16),(179,213,NULL,'2025-01-28','Rent',450,17),(180,213,NULL,'2025-02-04','Rent',450,18),(181,213,NULL,'2025-02-11','Rent',450,19),(182,213,NULL,'2025-02-18','Rent',450,20),(183,213,NULL,'2025-02-25','Rent',450,21),(184,213,NULL,'2025-03-04','Rent',450,22),(185,213,NULL,'2025-03-11','Rent',450,23),(186,213,NULL,'2025-03-18','Rent',450,24),(187,213,NULL,'2025-03-25','Rent',450,25),(188,213,NULL,'2025-04-01','Rent',450,26),(189,213,NULL,'2025-04-08','Rent',450,27),(190,213,NULL,'2025-04-15','Rent',450,28),(191,213,NULL,'2025-04-22','Rent',450,29),(192,213,NULL,'2025-04-29','Rent',450,30),(193,213,NULL,'2025-05-06','Rent',450,31),(194,213,NULL,'2025-05-13','Rent',450,32),(195,213,NULL,'2025-05-20','Rent',450,33),(196,213,NULL,'2025-05-27','Rent',450,34),(197,213,NULL,'2025-06-03','Rent',450,35),(198,213,NULL,'2025-06-10','Rent',450,36),(199,213,NULL,'2025-06-17','Rent',450,37),(200,213,NULL,'2025-06-24','Rent',450,38),(201,213,NULL,'2025-07-01','Rent',450,39),(202,213,NULL,'2025-07-08','Rent',450,40),(203,213,NULL,'2025-07-15','Rent',450,41),(204,213,NULL,'2025-07-22','Rent',450,42),(205,213,NULL,'2025-07-29','Rent',450,43),(206,213,NULL,'2025-08-05','Rent',450,44),(207,213,NULL,'2025-08-12','Rent',450,45),(208,213,NULL,'2025-08-19','Rent',450,46),(209,213,NULL,'2025-08-26','Rent',450,47),(210,213,NULL,'2025-09-02','Rent',450,48),(211,213,NULL,'2025-09-09','Rent',450,49),(212,213,NULL,'2025-09-16','Rent',450,50),(213,213,NULL,'2025-09-23','Rent',450,51),(214,213,NULL,'2025-09-30','Rent',450,52),(215,215,NULL,'2024-10-21','Salary (M)',5000,0),(216,215,NULL,'2024-11-04','Salary (M)',5000,1),(217,215,NULL,'2024-11-18','Salary (M)',5000,2),(218,215,NULL,'2024-12-02','Salary (M)',5000,3),(219,215,NULL,'2024-12-16','Salary (M)',5000,4),(220,215,NULL,'2024-12-30','Salary (M)',5000,5),(221,215,NULL,'2025-01-13','Salary (M)',5000,6),(222,215,NULL,'2025-01-27','Salary (M)',5000,7),(223,215,NULL,'2025-02-10','Salary (M)',5000,8),(224,215,NULL,'2025-02-24','Salary (M)',5000,9),(225,215,NULL,'2025-03-10','Salary (M)',5000,10),(226,215,NULL,'2025-03-24','Salary (M)',5000,11),(227,215,NULL,'2025-04-07','Salary (M)',5000,12),(228,215,NULL,'2025-04-21','Salary (M)',5000,13),(229,215,NULL,'2025-05-05','Salary (M)',5000,14),(230,215,NULL,'2025-05-19','Salary (M)',5000,15),(231,215,NULL,'2025-06-02','Salary (M)',5000,16),(232,215,NULL,'2025-06-16','Salary (M)',5000,17),(233,215,NULL,'2025-06-30','Salary (M)',5000,18),(234,215,NULL,'2025-07-14','Salary (M)',5000,19),(235,215,NULL,'2025-07-28','Salary (M)',5000,20),(236,215,NULL,'2025-08-11','Salary (M)',5000,21),(237,215,NULL,'2025-08-25','Salary (M)',5000,22),(238,215,NULL,'2025-09-08','Salary (M)',5000,23),(239,215,NULL,'2025-09-22','Salary (M)',5000,24),(240,215,NULL,'2025-10-06','Salary (M)',5000,25),(241,215,NULL,'2025-10-20','Salary (M)',5000,26),(242,216,NULL,'2024-10-21','Salary (H)',3000,0),(243,216,NULL,'2024-11-21','Salary (H)',3000,1),(244,216,NULL,'2024-12-21','Salary (H)',3000,2),(245,216,NULL,'2025-01-21','Salary (H)',3000,3),(246,216,NULL,'2025-02-21','Salary (H)',3000,4),(247,216,NULL,'2025-03-21','Salary (H)',3000,5),(248,216,NULL,'2025-04-21','Salary (H)',3000,6),(249,216,NULL,'2025-05-21','Salary (H)',3000,7),(250,216,NULL,'2025-06-21','Salary (H)',3000,8),(251,216,NULL,'2025-07-21','Salary (H)',3000,9),(252,216,NULL,'2025-08-21','Salary (H)',3000,10),(253,216,NULL,'2025-09-21','Salary (H)',3000,11),(254,216,NULL,'2025-10-21','Salary (H)',3000,12),(255,216,NULL,'2025-11-21','Salary (H)',3000,13),(256,216,NULL,'2025-12-21','Salary (H)',3000,14),(257,216,NULL,'2026-01-21','Salary (H)',3000,15),(258,216,NULL,'2026-02-21','Salary (H)',3000,16),(259,216,NULL,'2026-03-21','Salary (H)',3000,17),(260,216,NULL,'2026-04-21','Salary (H)',3000,18),(261,216,NULL,'2026-05-21','Salary (H)',3000,19),(262,216,NULL,'2026-06-21','Salary (H)',3000,20),(263,216,NULL,'2026-07-21','Salary (H)',3000,21),(264,216,NULL,'2026-08-21','Salary (H)',3000,22),(265,216,NULL,'2026-09-21','Salary (H)',3000,23),(266,216,NULL,'2026-10-21','Salary (H)',3000,24),(267,216,NULL,'2026-11-21','Salary (H)',3000,25),(268,216,NULL,'2026-12-21','Salary (H)',3000,26),(269,216,NULL,'2027-01-21','Salary (H)',3000,27),(270,216,NULL,'2027-02-21','Salary (H)',3000,28),(271,216,NULL,'2027-03-21','Salary (H)',3000,29),(272,216,NULL,'2027-04-21','Salary (H)',3000,30),(273,216,NULL,'2027-05-21','Salary (H)',3000,31),(274,216,NULL,'2027-06-21','Salary (H)',3000,32),(275,216,NULL,'2027-07-21','Salary (H)',3000,33),(276,216,NULL,'2027-08-21','Salary (H)',3000,34),(277,216,NULL,'2027-09-21','Salary (H)',3000,35),(278,216,NULL,'2027-10-21','Salary (H)',3000,36),(279,217,NULL,'2024-10-21','Internet Sales',3000,0),(280,217,NULL,'2025-01-21','Internet Sales',3000,1),(281,217,NULL,'2025-04-21','Internet Sales',3000,2),(282,217,NULL,'2025-07-21','Internet Sales',3000,3),(283,217,NULL,'2025-10-21','Internet Sales',3000,4),(284,217,NULL,'2026-01-21','Internet Sales',3000,5),(285,217,NULL,'2026-04-21','Internet Sales',3000,6),(286,217,NULL,'2026-07-21','Internet Sales',3000,7),(287,217,NULL,'2026-10-21','Internet Sales',3000,8),(288,217,NULL,'2027-01-21','Internet Sales',3000,9),(289,217,NULL,'2027-04-21','Internet Sales',3000,10),(290,217,NULL,'2027-07-21','Internet Sales',3000,11),(291,217,NULL,'2027-10-21','Internet Sales',3000,12),(292,218,NULL,'2024-10-21','CBA Interest (H)',50,0),(293,218,NULL,'2025-04-21','CBA Interest (H)',50,1),(294,218,NULL,'2025-10-21','CBA Interest (H)',50,2),(295,218,NULL,'2026-04-21','CBA Interest (H)',50,3),(296,218,NULL,'2026-10-21','CBA Interest (H)',50,4),(297,218,NULL,'2027-04-21','CBA Interest (H)',50,5),(298,218,NULL,'2027-10-21','CBA Interest (H)',50,6),(299,219,NULL,'2024-10-21','CBA Savings (M)',10,0),(300,219,NULL,'2025-10-21','CBA Savings (M)',10,1),(301,219,NULL,'2026-10-21','CBA Savings (M)',10,2),(302,219,NULL,'2027-10-21','CBA Savings (M)',10,3),(303,221,NULL,'2024-10-21','Person Loan Repay',200,0),(304,221,NULL,'2024-11-04','Person Loan Repay',200,1),(305,221,NULL,'2024-11-18','Person Loan Repay',200,2),(306,221,NULL,'2024-12-02','Person Loan Repay',200,3),(307,221,NULL,'2024-12-16','Person Loan Repay',200,4),(308,221,NULL,'2024-12-30','Person Loan Repay',200,5),(309,221,NULL,'2025-01-13','Person Loan Repay',200,6),(310,221,NULL,'2025-01-27','Person Loan Repay',200,7),(311,221,NULL,'2025-02-10','Person Loan Repay',200,8),(312,221,NULL,'2025-02-24','Person Loan Repay',200,9),(313,221,NULL,'2025-03-10','Person Loan Repay',200,10),(314,221,NULL,'2025-03-24','Person Loan Repay',200,11),(315,221,NULL,'2025-04-07','Person Loan Repay',200,12),(316,221,NULL,'2025-04-21','Person Loan Repay',200,13),(317,221,NULL,'2025-05-05','Person Loan Repay',200,14),(318,221,NULL,'2025-05-19','Person Loan Repay',200,15),(319,221,NULL,'2025-06-02','Person Loan Repay',200,16),(320,221,NULL,'2025-06-16','Person Loan Repay',200,17),(321,221,NULL,'2025-06-30','Person Loan Repay',200,18),(322,221,NULL,'2025-07-14','Person Loan Repay',200,19),(323,221,NULL,'2025-07-28','Person Loan Repay',200,20),(324,221,NULL,'2025-08-11','Person Loan Repay',200,21),(325,221,NULL,'2025-08-25','Person Loan Repay',200,22),(326,221,NULL,'2025-09-08','Person Loan Repay',200,23),(327,221,NULL,'2025-09-22','Person Loan Repay',200,24),(328,221,NULL,'2025-10-06','Person Loan Repay',200,25),(329,221,NULL,'2025-10-20','Person Loan Repay',200,26),(330,222,NULL,'2024-10-21','Home Loan Repay',4000,0),(331,222,NULL,'2024-11-21','Home Loan Repay',4000,1),(332,222,NULL,'2024-12-21','Home Loan Repay',4000,2),(333,222,NULL,'2025-01-21','Home Loan Repay',4000,3),(334,222,NULL,'2025-02-21','Home Loan Repay',4000,4),(335,222,NULL,'2025-03-21','Home Loan Repay',4000,5),(336,222,NULL,'2025-04-21','Home Loan Repay',4000,6),(337,222,NULL,'2025-05-21','Home Loan Repay',4000,7),(338,222,NULL,'2025-06-21','Home Loan Repay',4000,8),(339,222,NULL,'2025-07-21','Home Loan Repay',4000,9),(340,222,NULL,'2025-08-21','Home Loan Repay',4000,10),(341,222,NULL,'2025-09-21','Home Loan Repay',4000,11),(342,222,NULL,'2025-10-21','Home Loan Repay',4000,12),(343,222,NULL,'2025-11-21','Home Loan Repay',4000,13),(344,222,NULL,'2025-12-21','Home Loan Repay',4000,14),(345,222,NULL,'2026-01-21','Home Loan Repay',4000,15),(346,222,NULL,'2026-02-21','Home Loan Repay',4000,16),(347,222,NULL,'2026-03-21','Home Loan Repay',4000,17),(348,222,NULL,'2026-04-21','Home Loan Repay',4000,18),(349,222,NULL,'2026-05-21','Home Loan Repay',4000,19),(350,222,NULL,'2026-06-21','Home Loan Repay',4000,20),(351,222,NULL,'2026-07-21','Home Loan Repay',4000,21),(352,222,NULL,'2026-08-21','Home Loan Repay',4000,22),(353,222,NULL,'2026-09-21','Home Loan Repay',4000,23),(354,222,NULL,'2026-10-21','Home Loan Repay',4000,24),(355,222,NULL,'2026-11-21','Home Loan Repay',4000,25),(356,222,NULL,'2026-12-21','Home Loan Repay',4000,26),(357,222,NULL,'2027-01-21','Home Loan Repay',4000,27),(358,222,NULL,'2027-02-21','Home Loan Repay',4000,28),(359,222,NULL,'2027-03-21','Home Loan Repay',4000,29),(360,222,NULL,'2027-04-21','Home Loan Repay',4000,30),(361,222,NULL,'2027-05-21','Home Loan Repay',4000,31),(362,222,NULL,'2027-06-21','Home Loan Repay',4000,32),(363,222,NULL,'2027-07-21','Home Loan Repay',4000,33),(364,222,NULL,'2027-08-21','Home Loan Repay',4000,34),(365,222,NULL,'2027-09-21','Home Loan Repay',4000,35),(366,222,NULL,'2027-10-21','Home Loan Repay',4000,36),(367,223,NULL,'2024-10-21','Home Loan Extra',500,0),(368,223,NULL,'2025-01-21','Home Loan Extra',500,1),(369,223,NULL,'2025-04-21','Home Loan Extra',500,2),(370,223,NULL,'2025-07-21','Home Loan Extra',500,3),(371,223,NULL,'2025-10-21','Home Loan Extra',500,4),(372,223,NULL,'2026-01-21','Home Loan Extra',500,5),(373,223,NULL,'2026-04-21','Home Loan Extra',500,6),(374,223,NULL,'2026-07-21','Home Loan Extra',500,7),(375,223,NULL,'2026-10-21','Home Loan Extra',500,8),(376,223,NULL,'2027-01-21','Home Loan Extra',500,9),(377,223,NULL,'2027-04-21','Home Loan Extra',500,10),(378,223,NULL,'2027-07-21','Home Loan Extra',500,11),(379,223,NULL,'2027-10-21','Home Loan Extra',500,12),(380,224,NULL,'2024-10-21','Personal Loan Extra',250,0),(381,224,NULL,'2025-04-21','Personal Loan Extra',250,1),(382,224,NULL,'2025-10-21','Personal Loan Extra',250,2),(383,224,NULL,'2026-04-21','Personal Loan Extra',250,3),(384,224,NULL,'2026-10-21','Personal Loan Extra',250,4),(385,224,NULL,'2027-04-21','Personal Loan Extra',250,5),(386,224,NULL,'2027-10-21','Personal Loan Extra',250,6),(387,NULL,2,'2024-10-01','Food',250,0),(388,NULL,2,'2024-10-08','Food',250,1),(389,NULL,2,'2024-10-15','Food',250,2),(390,NULL,2,'2024-10-22','Food',250,3),(391,NULL,2,'2024-10-29','Food',250,4),(392,NULL,2,'2024-11-05','Food',250,5),(393,NULL,2,'2024-11-12','Food',250,6),(394,NULL,2,'2024-11-19','Food',250,7),(395,NULL,2,'2024-11-26','Food',250,8),(396,NULL,2,'2024-12-03','Food',250,9),(397,NULL,2,'2024-12-10','Food',250,10),(398,NULL,2,'2024-12-17','Food',250,11),(399,NULL,2,'2024-12-24','Food',250,12),(400,NULL,2,'2024-12-31','Food',250,13),(401,NULL,2,'2025-01-07','Food',250,14),(402,NULL,2,'2025-01-14','Food',250,15),(403,NULL,2,'2025-01-21','Food',250,16),(404,NULL,2,'2025-01-28','Food',250,17),(405,NULL,2,'2025-02-04','Food',250,18),(406,NULL,2,'2025-02-11','Food',250,19),(407,NULL,2,'2025-02-18','Food',250,20),(408,NULL,2,'2025-02-25','Food',250,21),(409,NULL,2,'2025-03-04','Food',250,22),(410,NULL,2,'2025-03-11','Food',250,23),(411,NULL,2,'2025-03-18','Food',250,24),(412,NULL,2,'2025-03-25','Food',250,25),(413,NULL,2,'2025-04-01','Food',250,26),(414,NULL,2,'2025-04-08','Food',250,27),(415,NULL,2,'2025-04-15','Food',250,28),(416,NULL,2,'2025-04-22','Food',250,29),(417,NULL,2,'2025-04-29','Food',250,30),(418,NULL,2,'2025-05-06','Food',250,31),(419,NULL,2,'2025-05-13','Food',250,32),(420,NULL,2,'2025-05-20','Food',250,33),(421,NULL,2,'2025-05-27','Food',250,34),(422,NULL,2,'2025-06-03','Food',250,35),(423,NULL,2,'2025-06-10','Food',250,36),(424,NULL,2,'2025-06-17','Food',250,37),(425,NULL,2,'2025-06-24','Food',250,38),(426,NULL,2,'2025-07-01','Food',250,39),(427,NULL,2,'2025-07-08','Food',250,40),(428,NULL,2,'2025-07-15','Food',250,41),(429,NULL,2,'2025-07-22','Food',250,42),(430,NULL,2,'2025-07-29','Food',250,43),(431,NULL,2,'2025-08-05','Food',250,44),(432,NULL,2,'2025-08-12','Food',250,45),(433,NULL,2,'2025-08-19','Food',250,46),(434,NULL,2,'2025-08-26','Food',250,47),(435,NULL,2,'2025-09-02','Food',250,48),(436,NULL,2,'2025-09-09','Food',250,49),(437,NULL,2,'2025-09-16','Food',250,50),(438,NULL,2,'2025-09-23','Food',250,51),(439,NULL,2,'2025-09-30','Food',250,52),(440,NULL,3,'2024-10-21','Personal Loan Periodic Charge',200,0),(441,NULL,3,'2024-11-04','Personal Loan Periodic Charge',200,1),(442,NULL,3,'2024-11-18','Personal Loan Periodic Charge',200,2),(443,NULL,3,'2024-12-02','Personal Loan Periodic Charge',200,3),(444,NULL,3,'2024-12-16','Personal Loan Periodic Charge',200,4),(445,NULL,3,'2024-12-30','Personal Loan Periodic Charge',200,5),(446,NULL,3,'2025-01-13','Personal Loan Periodic Charge',200,6),(447,NULL,3,'2025-01-27','Personal Loan Periodic Charge',200,7),(448,NULL,3,'2025-02-10','Personal Loan Periodic Charge',200,8),(449,NULL,3,'2025-02-24','Personal Loan Periodic Charge',200,9),(450,NULL,3,'2025-03-10','Personal Loan Periodic Charge',200,10),(451,NULL,3,'2025-03-24','Personal Loan Periodic Charge',200,11),(452,NULL,3,'2025-04-07','Personal Loan Periodic Charge',200,12),(453,NULL,3,'2025-04-21','Personal Loan Periodic Charge',200,13),(454,NULL,3,'2025-05-05','Personal Loan Periodic Charge',200,14),(455,NULL,3,'2025-05-19','Personal Loan Periodic Charge',200,15),(456,NULL,3,'2025-06-02','Personal Loan Periodic Charge',200,16),(457,NULL,3,'2025-06-16','Personal Loan Periodic Charge',200,17),(458,NULL,3,'2025-06-30','Personal Loan Periodic Charge',200,18),(459,NULL,3,'2025-07-14','Personal Loan Periodic Charge',200,19),(460,NULL,3,'2025-07-28','Personal Loan Periodic Charge',200,20),(461,NULL,3,'2025-08-11','Personal Loan Periodic Charge',200,21),(462,NULL,3,'2025-08-25','Personal Loan Periodic Charge',200,22),(463,NULL,3,'2025-09-08','Personal Loan Periodic Charge',200,23),(464,NULL,3,'2025-09-22','Personal Loan Periodic Charge',200,24),(465,NULL,3,'2025-10-06','Personal Loan Periodic Charge',200,25),(466,NULL,3,'2025-10-20','Personal Loan Periodic Charge',200,26),(467,NULL,4,'2024-10-21','Home Loan Periodic Charge',2000,0),(468,NULL,4,'2024-11-21','Home Loan Periodic Charge',2000,1),(469,NULL,4,'2024-12-21','Home Loan Periodic Charge',2000,2),(470,NULL,4,'2025-01-21','Home Loan Periodic Charge',2000,3),(471,NULL,4,'2025-02-21','Home Loan Periodic Charge',2000,4),(472,NULL,4,'2025-03-21','Home Loan Periodic Charge',2000,5),(473,NULL,4,'2025-04-21','Home Loan Periodic Charge',2000,6),(474,NULL,4,'2025-05-21','Home Loan Periodic Charge',2000,7),(475,NULL,4,'2025-06-21','Home Loan Periodic Charge',2000,8),(476,NULL,4,'2025-07-21','Home Loan Periodic Charge',2000,9),(477,NULL,4,'2025-08-21','Home Loan Periodic Charge',2000,10),(478,NULL,4,'2025-09-21','Home Loan Periodic Charge',2000,11),(479,NULL,4,'2025-10-21','Home Loan Periodic Charge',2000,12),(480,NULL,4,'2025-11-21','Home Loan Periodic Charge',2000,13),(481,NULL,4,'2025-12-21','Home Loan Periodic Charge',2000,14),(482,NULL,4,'2026-01-21','Home Loan Periodic Charge',2000,15),(483,NULL,4,'2026-02-21','Home Loan Periodic Charge',2000,16),(484,NULL,4,'2026-03-21','Home Loan Periodic Charge',2000,17),(485,NULL,4,'2026-04-21','Home Loan Periodic Charge',2000,18),(486,NULL,4,'2026-05-21','Home Loan Periodic Charge',2000,19),(487,NULL,4,'2026-06-21','Home Loan Periodic Charge',2000,20),(488,NULL,4,'2026-07-21','Home Loan Periodic Charge',2000,21),(489,NULL,4,'2026-08-21','Home Loan Periodic Charge',2000,22),(490,NULL,4,'2026-09-21','Home Loan Periodic Charge',2000,23),(491,NULL,4,'2026-10-21','Home Loan Periodic Charge',2000,24),(492,NULL,4,'2026-11-21','Home Loan Periodic Charge',2000,25),(493,NULL,4,'2026-12-21','Home Loan Periodic Charge',2000,26),(494,NULL,4,'2027-01-21','Home Loan Periodic Charge',2000,27),(495,NULL,4,'2027-02-21','Home Loan Periodic Charge',2000,28),(496,NULL,4,'2027-03-21','Home Loan Periodic Charge',2000,29),(497,NULL,4,'2027-04-21','Home Loan Periodic Charge',2000,30),(498,NULL,4,'2027-05-21','Home Loan Periodic Charge',2000,31),(499,NULL,4,'2027-06-21','Home Loan Periodic Charge',2000,32),(500,NULL,4,'2027-07-21','Home Loan Periodic Charge',2000,33),(501,NULL,4,'2027-08-21','Home Loan Periodic Charge',2000,34),(502,NULL,4,'2027-09-21','Home Loan Periodic Charge',2000,35),(503,NULL,4,'2027-10-21','Home Loan Periodic Charge',2000,36),(504,NULL,5,'2024-10-21','Water Rates',300,0),(505,NULL,5,'2025-01-21','Water Rates',300,1),(506,NULL,5,'2025-04-21','Water Rates',300,2),(507,NULL,5,'2025-07-21','Water Rates',300,3),(508,NULL,5,'2025-10-21','Water Rates',300,4),(509,NULL,5,'2026-01-21','Water Rates',300,5),(510,NULL,5,'2026-04-21','Water Rates',300,6),(511,NULL,5,'2026-07-21','Water Rates',300,7),(512,NULL,5,'2026-10-21','Water Rates',300,8),(513,NULL,5,'2027-01-21','Water Rates',300,9),(514,NULL,5,'2027-04-21','Water Rates',300,10),(515,NULL,5,'2027-07-21','Water Rates',300,11),(516,NULL,5,'2027-10-21','Water Rates',300,12),(517,NULL,6,'2024-10-21','Council Rates',500,0),(518,NULL,6,'2025-04-21','Council Rates',500,1),(519,NULL,6,'2025-10-21','Council Rates',500,2),(520,NULL,6,'2026-04-21','Council Rates',500,3),(521,NULL,6,'2026-10-21','Council Rates',500,4),(522,NULL,6,'2027-04-21','Council Rates',500,5),(523,NULL,6,'2027-10-21','Council Rates',500,6),(524,NULL,7,'2024-10-21','Visa Account Fee',100,0),(525,NULL,7,'2025-10-21','Visa Account Fee',100,1),(526,NULL,7,'2026-10-21','Visa Account Fee',100,2),(527,NULL,7,'2027-10-21','Visa Account Fee',100,3),(528,NULL,9,'2024-10-01','Partial Visa Payment',500,0),(529,NULL,9,'2024-10-08','Partial Visa Payment',500,1),(530,NULL,9,'2024-10-15','Partial Visa Payment',500,2),(531,NULL,9,'2024-10-22','Partial Visa Payment',500,3),(532,NULL,9,'2024-10-29','Partial Visa Payment',500,4),(533,NULL,9,'2024-11-05','Partial Visa Payment',500,5),(534,NULL,9,'2024-11-12','Partial Visa Payment',500,6),(535,NULL,9,'2024-11-19','Partial Visa Payment',500,7),(536,NULL,9,'2024-11-26','Partial Visa Payment',500,8),(537,NULL,9,'2024-12-03','Partial Visa Payment',500,9),(538,NULL,9,'2024-12-10','Partial Visa Payment',500,10),(539,NULL,9,'2024-12-17','Partial Visa Payment',500,11),(540,NULL,9,'2024-12-24','Partial Visa Payment',500,12),(541,NULL,9,'2024-12-31','Partial Visa Payment',500,13),(542,NULL,9,'2025-01-07','Partial Visa Payment',500,14),(543,NULL,9,'2025-01-14','Partial Visa Payment',500,15),(544,NULL,9,'2025-01-21','Partial Visa Payment',500,16),(545,NULL,9,'2025-01-28','Partial Visa Payment',500,17),(546,NULL,9,'2025-02-04','Partial Visa Payment',500,18),(547,NULL,9,'2025-02-11','Partial Visa Payment',500,19),(548,NULL,9,'2025-02-18','Partial Visa Payment',500,20),(549,NULL,9,'2025-02-25','Partial Visa Payment',500,21),(550,NULL,9,'2025-03-04','Partial Visa Payment',500,22),(551,NULL,9,'2025-03-11','Partial Visa Payment',500,23),(552,NULL,9,'2025-03-18','Partial Visa Payment',500,24),(553,NULL,9,'2025-03-25','Partial Visa Payment',500,25),(554,NULL,9,'2025-04-01','Partial Visa Payment',500,26),(555,NULL,9,'2025-04-08','Partial Visa Payment',500,27),(556,NULL,9,'2025-04-15','Partial Visa Payment',500,28),(557,NULL,9,'2025-04-22','Partial Visa Payment',500,29),(558,NULL,9,'2025-04-29','Partial Visa Payment',500,30),(559,NULL,9,'2025-05-06','Partial Visa Payment',500,31),(560,NULL,9,'2025-05-13','Partial Visa Payment',500,32),(561,NULL,9,'2025-05-20','Partial Visa Payment',500,33),(562,NULL,9,'2025-05-27','Partial Visa Payment',500,34),(563,NULL,9,'2025-06-03','Partial Visa Payment',500,35),(564,NULL,9,'2025-06-10','Partial Visa Payment',500,36),(565,NULL,9,'2025-06-17','Partial Visa Payment',500,37),(566,NULL,9,'2025-06-24','Partial Visa Payment',500,38),(567,NULL,9,'2025-07-01','Partial Visa Payment',500,39),(568,NULL,9,'2025-07-08','Partial Visa Payment',500,40),(569,NULL,9,'2025-07-15','Partial Visa Payment',500,41),(570,NULL,9,'2025-07-22','Partial Visa Payment',500,42),(571,NULL,9,'2025-07-29','Partial Visa Payment',500,43),(572,NULL,9,'2025-08-05','Partial Visa Payment',500,44),(573,NULL,9,'2025-08-12','Partial Visa Payment',500,45),(574,NULL,9,'2025-08-19','Partial Visa Payment',500,46),(575,NULL,9,'2025-08-26','Partial Visa Payment',500,47),(576,NULL,9,'2025-09-02','Partial Visa Payment',500,48),(577,NULL,9,'2025-09-09','Partial Visa Payment',500,49),(578,NULL,9,'2025-09-16','Partial Visa Payment',500,50),(579,NULL,9,'2025-09-23','Partial Visa Payment',500,51),(580,NULL,9,'2025-09-30','Partial Visa Payment',500,52),(581,NULL,10,'2024-10-21','Person Loan Repay',200,0),(582,NULL,10,'2024-11-04','Person Loan Repay',200,1),(583,NULL,10,'2024-11-18','Person Loan Repay',200,2),(584,NULL,10,'2024-12-02','Person Loan Repay',200,3),(585,NULL,10,'2024-12-16','Person Loan Repay',200,4),(586,NULL,10,'2024-12-30','Person Loan Repay',200,5),(587,NULL,10,'2025-01-13','Person Loan Repay',200,6),(588,NULL,10,'2025-01-27','Person Loan Repay',200,7),(589,NULL,10,'2025-02-10','Person Loan Repay',200,8),(590,NULL,10,'2025-02-24','Person Loan Repay',200,9),(591,NULL,10,'2025-03-10','Person Loan Repay',200,10),(592,NULL,10,'2025-03-24','Person Loan Repay',200,11),(593,NULL,10,'2025-04-07','Person Loan Repay',200,12),(594,NULL,10,'2025-04-21','Person Loan Repay',200,13),(595,NULL,10,'2025-05-05','Person Loan Repay',200,14),(596,NULL,10,'2025-05-19','Person Loan Repay',200,15),(597,NULL,10,'2025-06-02','Person Loan Repay',200,16),(598,NULL,10,'2025-06-16','Person Loan Repay',200,17),(599,NULL,10,'2025-06-30','Person Loan Repay',200,18),(600,NULL,10,'2025-07-14','Person Loan Repay',200,19),(601,NULL,10,'2025-07-28','Person Loan Repay',200,20),(602,NULL,10,'2025-08-11','Person Loan Repay',200,21),(603,NULL,10,'2025-08-25','Person Loan Repay',200,22),(604,NULL,10,'2025-09-08','Person Loan Repay',200,23),(605,NULL,10,'2025-09-22','Person Loan Repay',200,24),(606,NULL,10,'2025-10-06','Person Loan Repay',200,25),(607,NULL,10,'2025-10-20','Person Loan Repay',200,26),(608,NULL,11,'2024-10-21','Home Loan Repay',4000,0),(609,NULL,11,'2024-11-21','Home Loan Repay',4000,1),(610,NULL,11,'2024-12-21','Home Loan Repay',4000,2),(611,NULL,11,'2025-01-21','Home Loan Repay',4000,3),(612,NULL,11,'2025-02-21','Home Loan Repay',4000,4),(613,NULL,11,'2025-03-21','Home Loan Repay',4000,5),(614,NULL,11,'2025-04-21','Home Loan Repay',4000,6),(615,NULL,11,'2025-05-21','Home Loan Repay',4000,7),(616,NULL,11,'2025-06-21','Home Loan Repay',4000,8),(617,NULL,11,'2025-07-21','Home Loan Repay',4000,9),(618,NULL,11,'2025-08-21','Home Loan Repay',4000,10),(619,NULL,11,'2025-09-21','Home Loan Repay',4000,11),(620,NULL,11,'2025-10-21','Home Loan Repay',4000,12),(621,NULL,11,'2025-11-21','Home Loan Repay',4000,13),(622,NULL,11,'2025-12-21','Home Loan Repay',4000,14),(623,NULL,11,'2026-01-21','Home Loan Repay',4000,15),(624,NULL,11,'2026-02-21','Home Loan Repay',4000,16),(625,NULL,11,'2026-03-21','Home Loan Repay',4000,17),(626,NULL,11,'2026-04-21','Home Loan Repay',4000,18),(627,NULL,11,'2026-05-21','Home Loan Repay',4000,19),(628,NULL,11,'2026-06-21','Home Loan Repay',4000,20),(629,NULL,11,'2026-07-21','Home Loan Repay',4000,21),(630,NULL,11,'2026-08-21','Home Loan Repay',4000,22),(631,NULL,11,'2026-09-21','Home Loan Repay',4000,23),(632,NULL,11,'2026-10-21','Home Loan Repay',4000,24),(633,NULL,11,'2026-11-21','Home Loan Repay',4000,25),(634,NULL,11,'2026-12-21','Home Loan Repay',4000,26),(635,NULL,11,'2027-01-21','Home Loan Repay',4000,27),(636,NULL,11,'2027-02-21','Home Loan Repay',4000,28),(637,NULL,11,'2027-03-21','Home Loan Repay',4000,29),(638,NULL,11,'2027-04-21','Home Loan Repay',4000,30),(639,NULL,11,'2027-05-21','Home Loan Repay',4000,31),(640,NULL,11,'2027-06-21','Home Loan Repay',4000,32),(641,NULL,11,'2027-07-21','Home Loan Repay',4000,33),(642,NULL,11,'2027-08-21','Home Loan Repay',4000,34),(643,NULL,11,'2027-09-21','Home Loan Repay',4000,35),(644,NULL,11,'2027-10-21','Home Loan Repay',4000,36),(645,NULL,12,'2024-10-21','Home Loan Extra',500,0),(646,NULL,12,'2025-01-21','Home Loan Extra',500,1),(647,NULL,12,'2025-04-21','Home Loan Extra',500,2),(648,NULL,12,'2025-07-21','Home Loan Extra',500,3),(649,NULL,12,'2025-10-21','Home Loan Extra',500,4),(650,NULL,12,'2026-01-21','Home Loan Extra',500,5),(651,NULL,12,'2026-04-21','Home Loan Extra',500,6),(652,NULL,12,'2026-07-21','Home Loan Extra',500,7),(653,NULL,12,'2026-10-21','Home Loan Extra',500,8),(654,NULL,12,'2027-01-21','Home Loan Extra',500,9),(655,NULL,12,'2027-04-21','Home Loan Extra',500,10),(656,NULL,12,'2027-07-21','Home Loan Extra',500,11),(657,NULL,12,'2027-10-21','Home Loan Extra',500,12),(658,NULL,13,'2024-10-21','Personal Loan Extra',250,0),(659,NULL,13,'2025-04-21','Personal Loan Extra',250,1),(660,NULL,13,'2025-10-21','Personal Loan Extra',250,2),(661,NULL,13,'2026-04-21','Personal Loan Extra',250,3),(662,NULL,13,'2026-10-21','Personal Loan Extra',250,4),(663,NULL,13,'2027-04-21','Personal Loan Extra',250,5),(664,NULL,13,'2027-10-21','Personal Loan Extra',250,6),(665,NULL,14,'2024-10-21','Visa Account Fee',150,0),(666,NULL,14,'2025-10-21','Visa Account Fee',150,1),(667,NULL,14,'2026-10-21','Visa Account Fee',150,2),(668,NULL,14,'2027-10-21','Visa Account Fee',150,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fincols`
--

LOCK TABLES `fincols` WRITE;
/*!40000 ALTER TABLE `fincols` DISABLE KEYS */;
INSERT INTO `fincols` VALUES (11,0,1,NULL,4,'Visa'),(12,0,2,NULL,5,'HL'),(13,0,3,NULL,6,'PL'),(14,0,4,13,NULL,'ING'),(15,0,5,14,NULL,'CBA (M)'),(16,0,6,15,NULL,'CBA (H)'),(17,0,7,16,NULL,'Super');
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
) ENGINE=InnoDB AUTO_INCREMENT=499 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finlines`
--

LOCK TABLES `finlines` WRITE;
/*!40000 ALTER TABLE `finlines` DISABLE KEYS */;
INSERT INTO `finlines` VALUES (249,0,1,NULL,4,'2024-10-21',-1750),(250,0,1,NULL,4,'2025-10-20',8350),(251,0,1,NULL,4,'2026-10-19',6200),(252,0,1,NULL,4,'2027-10-18',4050),(253,0,1,NULL,4,'2024-09-30',-1750),(254,0,1,NULL,4,'2024-10-07',-1500),(255,0,1,NULL,4,'2024-10-14',-1250),(256,0,1,NULL,4,'2024-10-28',-1500),(257,0,1,NULL,4,'2024-11-04',-1250),(258,0,1,NULL,4,'2024-11-11',-1000),(259,0,1,NULL,4,'2024-11-18',-750),(260,0,1,NULL,4,'2024-11-25',-500),(261,0,1,NULL,4,'2024-12-02',-250),(262,0,1,NULL,4,'2024-12-09',0),(263,0,1,NULL,4,'2024-12-16',250),(264,0,1,NULL,4,'2024-12-23',500),(265,0,1,NULL,4,'2024-12-30',750),(266,0,1,NULL,4,'2025-01-06',1000),(267,0,1,NULL,4,'2025-01-13',1250),(268,0,1,NULL,4,'2025-01-20',1200),(269,0,1,NULL,4,'2025-01-27',1450),(270,0,1,NULL,4,'2025-02-03',1700),(271,0,1,NULL,4,'2025-02-10',1950),(272,0,1,NULL,4,'2025-02-17',2200),(273,0,1,NULL,4,'2025-02-24',2450),(274,0,1,NULL,4,'2025-03-03',2700),(275,0,1,NULL,4,'2025-03-10',2950),(276,0,1,NULL,4,'2025-03-17',3200),(277,0,1,NULL,4,'2025-03-24',3450),(278,0,1,NULL,4,'2025-03-31',3700),(279,0,1,NULL,4,'2025-04-07',3950),(280,0,1,NULL,4,'2025-04-14',4200),(281,0,1,NULL,4,'2025-04-21',3650),(282,0,1,NULL,4,'2025-04-28',3900),(283,0,1,NULL,4,'2025-05-05',4150),(284,0,1,NULL,4,'2025-05-12',4400),(285,0,1,NULL,4,'2025-05-19',4650),(286,0,1,NULL,4,'2025-05-26',4900),(287,0,1,NULL,4,'2025-06-02',5150),(288,0,1,NULL,4,'2025-06-09',5400),(289,0,1,NULL,4,'2025-06-16',5650),(290,0,1,NULL,4,'2025-06-23',5900),(291,0,1,NULL,4,'2025-06-30',6150),(292,0,1,NULL,4,'2025-07-07',6400),(293,0,1,NULL,4,'2025-07-14',6650),(294,0,1,NULL,4,'2025-07-21',6600),(295,0,1,NULL,4,'2025-07-28',6850),(296,0,1,NULL,4,'2025-08-04',7100),(297,0,1,NULL,4,'2025-08-11',7350),(298,0,1,NULL,4,'2025-08-18',7600),(299,0,1,NULL,4,'2025-08-25',7850),(300,0,1,NULL,4,'2025-09-01',8100),(301,0,1,NULL,4,'2025-09-08',8350),(302,0,1,NULL,4,'2025-09-15',8600),(303,0,1,NULL,4,'2025-09-22',8850),(304,0,1,NULL,4,'2025-09-29',9100),(305,0,1,13,NULL,'2024-09-30',850),(306,0,1,13,NULL,'2024-10-07',800),(307,0,1,13,NULL,'2024-10-14',750),(308,0,1,13,NULL,'2024-10-21',4000),(309,0,1,13,NULL,'2024-10-28',3950),(310,0,1,13,NULL,'2024-11-04',8700),(311,0,1,13,NULL,'2024-11-11',8650),(312,0,1,13,NULL,'2024-11-18',9400),(313,0,1,13,NULL,'2024-11-25',9350),(314,0,1,13,NULL,'2024-12-02',14100),(315,0,1,13,NULL,'2024-12-09',14050),(316,0,1,13,NULL,'2024-12-16',14800),(317,0,1,13,NULL,'2024-12-23',14750),(318,0,1,13,NULL,'2024-12-30',19500),(319,0,1,13,NULL,'2025-01-06',19450),(320,0,1,13,NULL,'2025-01-13',24200),(321,0,1,13,NULL,'2025-01-20',22650),(322,0,1,13,NULL,'2025-01-27',27400),(323,0,1,13,NULL,'2025-02-03',27350),(324,0,1,13,NULL,'2025-02-10',32100),(325,0,1,13,NULL,'2025-02-17',28050),(326,0,1,13,NULL,'2025-02-24',32800),(327,0,1,13,NULL,'2025-03-03',32750),(328,0,1,13,NULL,'2025-03-10',37500),(329,0,1,13,NULL,'2025-03-17',33450),(330,0,1,13,NULL,'2025-03-24',38200),(331,0,1,13,NULL,'2025-03-31',38150),(332,0,1,13,NULL,'2025-04-07',42900),(333,0,1,13,NULL,'2025-04-14',42850),(334,0,1,13,NULL,'2025-04-21',46100),(335,0,1,13,NULL,'2025-04-28',46050),(336,0,1,13,NULL,'2025-05-05',50800),(337,0,1,13,NULL,'2025-05-12',50750),(338,0,1,13,NULL,'2025-05-19',51500),(339,0,1,13,NULL,'2025-05-26',51450),(340,0,1,13,NULL,'2025-06-02',56200),(341,0,1,13,NULL,'2025-06-09',56150),(342,0,1,13,NULL,'2025-06-16',56900),(343,0,1,13,NULL,'2025-06-23',56850),(344,0,1,13,NULL,'2025-06-30',61600),(345,0,1,13,NULL,'2025-07-07',61550),(346,0,1,13,NULL,'2025-07-14',66300),(347,0,1,13,NULL,'2025-07-21',64750),(348,0,1,13,NULL,'2025-07-28',69500),(349,0,1,13,NULL,'2025-08-04',69450),(350,0,1,13,NULL,'2025-08-11',74200),(351,0,1,13,NULL,'2025-08-18',70150),(352,0,1,13,NULL,'2025-08-25',74900),(353,0,1,13,NULL,'2025-09-01',74850),(354,0,1,13,NULL,'2025-09-08',79600),(355,0,1,13,NULL,'2025-09-15',75550),(356,0,1,13,NULL,'2025-09-22',80300),(357,0,1,13,NULL,'2025-09-29',80250),(358,0,1,13,NULL,'2025-10-06',85050),(359,0,1,13,NULL,'2025-10-20',88350),(360,0,1,15,NULL,'2024-10-21',5650),(361,0,1,15,NULL,'2024-11-18',8650),(362,0,1,15,NULL,'2024-12-16',11650),(363,0,1,15,NULL,'2025-01-20',14650),(364,0,1,15,NULL,'2025-02-17',17650),(365,0,1,15,NULL,'2025-03-17',20650),(366,0,1,15,NULL,'2025-04-21',23450),(367,0,1,15,NULL,'2025-05-19',26450),(368,0,1,15,NULL,'2025-06-16',29450),(369,0,1,15,NULL,'2025-07-21',32450),(370,0,1,15,NULL,'2025-08-18',35450),(371,0,1,15,NULL,'2025-09-15',38450),(372,0,1,15,NULL,'2025-10-20',41100),(373,0,1,15,NULL,'2025-11-17',44100),(374,0,1,15,NULL,'2025-12-15',47100),(375,0,1,15,NULL,'2026-01-19',50100),(376,0,1,15,NULL,'2026-02-16',53100),(377,0,1,15,NULL,'2026-03-16',56100),(378,0,1,15,NULL,'2026-04-20',58900),(379,0,1,15,NULL,'2026-05-18',61900),(380,0,1,15,NULL,'2026-06-15',64900),(381,0,1,15,NULL,'2026-07-20',67900),(382,0,1,15,NULL,'2026-08-17',70900),(383,0,1,15,NULL,'2026-09-21',73900),(384,0,1,15,NULL,'2026-10-19',76550),(385,0,1,15,NULL,'2026-11-16',79550),(386,0,1,15,NULL,'2026-12-21',82550),(387,0,1,15,NULL,'2027-01-18',85550),(388,0,1,15,NULL,'2027-02-15',88550),(389,0,1,15,NULL,'2027-03-15',91550),(390,0,1,15,NULL,'2027-04-19',94350),(391,0,1,15,NULL,'2027-05-17',97350),(392,0,1,15,NULL,'2027-06-21',100350),(393,0,1,15,NULL,'2027-07-19',103350),(394,0,1,15,NULL,'2027-08-16',106350),(395,0,1,15,NULL,'2027-09-20',109350),(396,0,1,15,NULL,'2027-10-18',112000),(397,0,1,13,NULL,'2026-01-19',78850),(398,0,1,13,NULL,'2026-04-20',69350),(399,0,1,13,NULL,'2026-07-20',59850),(400,0,1,13,NULL,'2026-10-19',50350),(401,0,1,13,NULL,'2027-01-18',40850),(402,0,1,13,NULL,'2027-04-19',31350),(403,0,1,13,NULL,'2027-07-19',21850),(404,0,1,13,NULL,'2027-10-18',12350),(405,0,1,14,NULL,'2024-10-21',1010),(406,0,1,14,NULL,'2025-10-20',1020),(407,0,1,14,NULL,'2026-10-19',1030),(408,0,1,14,NULL,'2027-10-18',1040),(409,0,1,NULL,6,'2024-10-21',-9750),(410,0,1,NULL,6,'2024-11-04',-9750),(411,0,1,NULL,6,'2024-11-18',-9750),(412,0,1,NULL,6,'2024-12-02',-9750),(413,0,1,NULL,6,'2024-12-16',-9750),(414,0,1,NULL,6,'2024-12-30',-9750),(415,0,1,NULL,6,'2025-01-13',-9750),(416,0,1,NULL,6,'2025-01-27',-9750),(417,0,1,NULL,6,'2025-02-10',-9750),(418,0,1,NULL,6,'2025-02-24',-9750),(419,0,1,NULL,6,'2025-03-10',-9750),(420,0,1,NULL,6,'2025-03-24',-9750),(421,0,1,NULL,6,'2025-04-07',-9750),(422,0,1,NULL,6,'2025-04-21',-9500),(423,0,1,NULL,6,'2025-05-05',-9500),(424,0,1,NULL,6,'2025-05-19',-9500),(425,0,1,NULL,6,'2025-06-02',-9500),(426,0,1,NULL,6,'2025-06-16',-9500),(427,0,1,NULL,6,'2025-06-30',-9500),(428,0,1,NULL,6,'2025-07-14',-9500),(429,0,1,NULL,6,'2025-07-28',-9500),(430,0,1,NULL,6,'2025-08-11',-9500),(431,0,1,NULL,6,'2025-08-25',-9500),(432,0,1,NULL,6,'2025-09-08',-9500),(433,0,1,NULL,6,'2025-09-22',-9500),(434,0,1,NULL,6,'2025-10-06',-9500),(435,0,1,NULL,6,'2025-10-20',-9250),(436,0,1,NULL,5,'2024-10-21',-447500),(437,0,1,NULL,5,'2024-11-18',-445500),(438,0,1,NULL,5,'2024-12-16',-443500),(439,0,1,NULL,5,'2025-01-20',-441000),(440,0,1,NULL,5,'2025-02-17',-439000),(441,0,1,NULL,5,'2025-03-17',-437000),(442,0,1,NULL,5,'2025-04-21',-434500),(443,0,1,NULL,5,'2025-05-19',-432500),(444,0,1,NULL,5,'2025-06-16',-430500),(445,0,1,NULL,5,'2025-07-21',-428000),(446,0,1,NULL,5,'2025-08-18',-426000),(447,0,1,NULL,5,'2025-09-15',-424000),(448,0,1,NULL,5,'2025-10-20',-421500),(449,0,1,NULL,5,'2025-11-17',-419500),(450,0,1,NULL,5,'2025-12-15',-417500),(451,0,1,NULL,5,'2026-01-19',-415000),(452,0,1,NULL,5,'2026-02-16',-413000),(453,0,1,NULL,5,'2026-03-16',-411000),(454,0,1,NULL,5,'2026-04-20',-408500),(455,0,1,NULL,5,'2026-05-18',-406500),(456,0,1,NULL,5,'2026-06-15',-404500),(457,0,1,NULL,5,'2026-07-20',-402000),(458,0,1,NULL,5,'2026-08-17',-400000),(459,0,1,NULL,5,'2026-09-21',-398000),(460,0,1,NULL,5,'2026-10-19',-395500),(461,0,1,NULL,5,'2026-11-16',-393500),(462,0,1,NULL,5,'2026-12-21',-391500),(463,0,1,NULL,5,'2027-01-18',-389000),(464,0,1,NULL,5,'2027-02-15',-387000),(465,0,1,NULL,5,'2027-03-15',-385000),(466,0,1,NULL,5,'2027-04-19',-382500),(467,0,1,NULL,5,'2027-05-17',-380500),(468,0,1,NULL,5,'2027-06-21',-378500),(469,0,1,NULL,5,'2027-07-19',-376000),(470,0,1,NULL,5,'2027-08-16',-374000),(471,0,1,NULL,5,'2027-09-20',-372000),(472,0,1,NULL,5,'2027-10-18',-369500),(473,0,1,NULL,6,'2026-04-20',-9000),(474,0,1,NULL,6,'2026-10-19',-8750),(475,0,1,NULL,6,'2027-04-19',-8500),(476,0,1,NULL,6,'2027-10-18',-8250),(477,0,1,NULL,4,'2026-01-19',8050),(478,0,1,NULL,4,'2026-04-20',7250),(479,0,1,NULL,4,'2026-07-20',6950),(480,0,1,NULL,4,'2027-01-18',5900),(481,0,1,NULL,4,'2027-04-19',5100),(482,0,1,NULL,4,'2027-07-19',4800),(483,0,1,13,NULL,'2025-11-17',84350),(484,0,1,13,NULL,'2025-12-15',80350),(485,0,1,13,NULL,'2026-02-16',74850),(486,0,1,13,NULL,'2026-03-16',70850),(487,0,1,13,NULL,'2026-05-18',65350),(488,0,1,13,NULL,'2026-06-15',61350),(489,0,1,13,NULL,'2026-08-17',55850),(490,0,1,13,NULL,'2026-09-21',51850),(491,0,1,13,NULL,'2026-11-16',46350),(492,0,1,13,NULL,'2026-12-21',42350),(493,0,1,13,NULL,'2027-02-15',36850),(494,0,1,13,NULL,'2027-03-15',32850),(495,0,1,13,NULL,'2027-05-17',27350),(496,0,1,13,NULL,'2027-06-21',23350),(497,0,1,13,NULL,'2027-08-16',17850),(498,0,1,13,NULL,'2027-09-20',13850);
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
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomes`
--

LOCK TABLES `incomes` WRITE;
/*!40000 ALTER TABLE `incomes` DISABLE KEYS */;
INSERT INTO `incomes` VALUES (213,'Rent','Rent from investment property',5,13,'2024-10-01','2025-10-01',450,1,'2024-10-01',NULL,1),(215,'Salary (M)','M main income stream',4,13,'2024-10-21','2025-10-21',5000,2,'2024-11-03',NULL,1),(216,'Salary (H)','H main income stream',4,15,'2024-10-21','2027-10-21',3000,3,'2024-11-21',NULL,1),(217,'Internet Sales','Saves through buying and selling items on the internet for a profit',6,13,'2024-10-21','2027-10-21',3000,4,'2024-09-30',NULL,1),(218,'CBA Interest (H)','Daily interest calculated and deposited half-yearly from CBA ',7,15,'2024-10-21','2027-10-21',50,5,'2024-06-30',NULL,1),(219,'CBA Savings (M)','Daily interest calculated and deposited yearly from CBA ',7,14,'2024-10-21','2027-10-21',10,6,'2023-12-31',NULL,1),(220,'Partial Visa Payment','Partial visa payment',9,NULL,'2024-10-01','2025-10-01',500,1,'2024-10-01',4,1),(221,'Person Loan Repay','Personal loan periodic payment',9,NULL,'2024-10-21','2025-10-21',200,2,'2024-10-21',6,1),(222,'Home Loan Repay','Home loan periodic payment',9,NULL,'2024-10-21','2027-10-21',4000,3,'2024-10-21',5,1),(223,'Home Loan Extra','Home loan extra payment',9,NULL,'2024-10-21','2027-10-21',500,4,'2024-06-30',5,1),(224,'Personal Loan Extra','Personal loan extra payment',9,NULL,'2024-10-21','2027-10-21',250,5,'2024-12-31',6,1),(225,'Visa Account Fee','Yearly visa account keeping fee',9,NULL,'2024-10-21','2027-10-21',150,6,'2023-12-31',4,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incometypes`
--

LOCK TABLES `incometypes` WRITE;
/*!40000 ALTER TABLE `incometypes` DISABLE KEYS */;
INSERT INTO `incometypes` VALUES (4,'Salary','Salary income from paid work'),(5,'Investment','Investment income'),(6,'Extra Income','Extra income from casual work and hobbies'),(7,'Interest','Interest from investments'),(9,'Transfer (Destination)','Transfered funds destination');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liabilities`
--

LOCK TABLES `liabilities` WRITE;
/*!40000 ALTER TABLE `liabilities` DISABLE KEYS */;
INSERT INTO `liabilities` VALUES (4,'CBA Visa','Main credit card for everyday transactions from CBA',6,-50,-2000,'2000-05-15','2050-04-01',-100,'2050-04-01'),(5,'CBA Home Loan','Primary home loan from CBA',5,-500000,-450000,'2020-01-30','2030-12-01',-5000,'2030-12-01'),(6,'Personal Loan','Personal loan to buy car',5,-15000,-10000,'2024-01-31','2029-01-31',-100,'2029-01-31');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liabilitytypes`
--

LOCK TABLES `liabilitytypes` WRITE;
/*!40000 ALTER TABLE `liabilitytypes` DISABLE KEYS */;
INSERT INTO `liabilitytypes` VALUES (5,'Bank Loan','Loans from banks'),(6,'Credit Cards','Credit cards such as visa, master card and american express');
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
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `MessageID` int NOT NULL,
  `MessageTypeID` int NOT NULL,
  `ContextInfo` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`MessageID`),
  KEY `MessageTypeID` (`MessageTypeID`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`MessageTypeID`) REFERENCES `messagetypes` (`MessageTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messagetypes`
--

DROP TABLE IF EXISTS `messagetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messagetypes` (
  `MessageTypeID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `Colour` int DEFAULT '0',
  PRIMARY KEY (`MessageTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messagetypes`
--

LOCK TABLES `messagetypes` WRITE;
/*!40000 ALTER TABLE `messagetypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `messagetypes` ENABLE KEYS */;
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
  `PhoneNumber` varchar(255) DEFAULT NULL,
  `EmailAddress` varchar(255) DEFAULT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
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
INSERT INTO `users` VALUES (1,'SuperAdmin','password', 3, null, null, '0412345678', 'SuperAdmin@Omnibits.com', 'Super', 'Admin'),(2,'Admin','password', 2, null, null, '0423456789', 'Admin@Omnibits.com', 'Admin', '1'),(3,'User','password', 1, null, null, '0434567890', 'User@Omnibits.com', 'User', '1');
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

-- Dump completed on 2024-10-07 21:33:18
