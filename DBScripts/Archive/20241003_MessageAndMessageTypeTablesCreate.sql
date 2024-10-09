use betracker;

DROP TABLE IF EXISTS `messagetypes`;

CREATE TABLE `messagetypes` (
  `MessageTypeID` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  `Colour` int DEFAULT 0,
  PRIMARY KEY (`MessageTypeID`)
);

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `MessageID` int NOT NULL,
  `MessageTypeID` int NOT NULL,
  `ContextInfo` varchar(255),
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`MessageID`),
  KEY `MessageTypeID` (`MessageTypeID`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`MessageTypeID`) REFERENCES `messagetypes` (`MessageTypeID`)
);



