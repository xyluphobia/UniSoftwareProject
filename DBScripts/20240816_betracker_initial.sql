-- Create Database
CREATE DATABASE IF NOT EXISTS betracker;
USE FinancialManagement;

-- Create Tables

-- Locations Table
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);

-- AuthLevels Table
CREATE TABLE AuthLevels (
    AuthLevelID INT PRIMARY KEY,
    LevelName VARCHAR(255),
    Description TEXT
);

-- Users Table (needs AuthLevels and Locations to be created first)
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(255),
    Password VARCHAR(255),
    AuthLevel INT,
    LocationID INT,
    OtherDetails TEXT,
    FOREIGN KEY (AuthLevel) REFERENCES AuthLevels(AuthLevelID),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- Roles Table
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(255),
    Description TEXT
);

-- Periods Table
CREATE TABLE Periods (
    PeriodID INT PRIMARY KEY,
    Name VARCHAR(255),
    Rule TEXT,
    WeekendRule TEXT,
    PublicHolidayRule TEXT
);

-- PublicHolidays Table (needs Locations to be created first)
CREATE TABLE PublicHolidays (
    HolidayID INT PRIMARY KEY,
    LocationID INT,
    Name VARCHAR(255),
    Date DATE,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- AssetTypes Table
CREATE TABLE AssetTypes (
    AssetTypeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);

-- LiabilityTypes Table
CREATE TABLE LiabilityTypes (
    LiabilityTypeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);

-- ExpenseTypes Table
CREATE TABLE ExpenseTypes (
    ExpenseTypeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);

-- IncomeTypes Table
CREATE TABLE IncomeTypes (
    IncomeTypeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT
);

-- Assets Table (needed by Expenses and Incomes)
CREATE TABLE Assets (
    AssetID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    AssetTypeID INT,
    InitialBalance DECIMAL,
    CurrentBalance DECIMAL,
    StartDate DATE,
    EndDate DATE,
    TargetBalance DECIMAL,
    TargetDate DATE,
    FOREIGN KEY (AssetTypeID) REFERENCES AssetTypes(AssetTypeID)
);

-- Liabilities Table (needed by Expenses)
CREATE TABLE Liabilities (
    LiabilityID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    LiabilityTypeID INT,
    InitialBalance DECIMAL,
    CurrentBalance DECIMAL,
    StartDate DATE,
    EndDate DATE,
    TargetBalance DECIMAL,
    TargetDate DATE,
    FOREIGN KEY (LiabilityTypeID) REFERENCES LiabilityTypes(LiabilityTypeID)
);

-- Expenses Table (needs ExpenseTypes, Assets, Liabilities, and Periods to be created first)
CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    ExpenseTypeID INT,
    AssetID INT,
    LiabilityID INT,
    StartDate DATE,
    EndDate DATE,
    Amount DECIMAL,
    RecurringPeriodID INT,
    LastPaidDate DATE,
    AutoPaid BOOLEAN,
    FOREIGN KEY (ExpenseTypeID) REFERENCES ExpenseTypes(ExpenseTypeID),
    FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
    FOREIGN KEY (LiabilityID) REFERENCES Liabilities(LiabilityID),
    FOREIGN KEY (RecurringPeriodID) REFERENCES Periods(PeriodID)
);

-- Incomes Table (needs IncomeTypes, Assets, and Periods to be created first)
CREATE TABLE Incomes (
    IncomeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    IncomeTypeID INT,
    AssetID INT,
    StartDate DATE,
    EndDate DATE,
    Amount DECIMAL,
    RecurringPeriodID INT,
    LastReceivedDate DATE,
    FOREIGN KEY (IncomeTypeID) REFERENCES IncomeTypes(IncomeTypeID),
    FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
    FOREIGN KEY (RecurringPeriodID) REFERENCES Periods(PeriodID)
);

-- Transfers Table (needs Assets to be created first)
CREATE TABLE Transfers (
    TransferID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    SourceAssetID INT,
    DestinationAssetID INT,
    Amount DECIMAL,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (SourceAssetID) REFERENCES Assets(AssetID),
    FOREIGN KEY (DestinationAssetID) REFERENCES Assets(AssetID)
);

-- BudgetItems Table
CREATE TABLE BudgetItems (
    BudgetItemID INT PRIMARY KEY,
    BudgetID INT,
    Name VARCHAR(255),
    Description TEXT,
    ExpenseID INT,
    IncomeID INT,
    AssetID INT,
    LiabilityID INT
);

-- Graphs Table (needs BudgetItems to be created first)
CREATE TABLE Graphs (
    GraphID INT PRIMARY KEY,
    Title VARCHAR(255),
    Description TEXT,
    XAxisTitle VARCHAR(255),
    YAxisTitle VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    BudgetItemID INT,
    FOREIGN KEY (BudgetItemID) REFERENCES BudgetItems(BudgetItemID)
);
