CREATE TABLE `acdata` (
  `acItem` int unsigned NOT NULL COMMENT 'Table for accounting data, starting with HKMA Exchange Fund Balance Sheet',
  `atDate` date NOT NULL,
  `acVal` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`acItem`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `acitems` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `datasource` int unsigned NOT NULL,
  `sourceName` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dispName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `refDate` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `sourceName` (`datasource`,`sourceName`),
  CONSTRAINT `datasource` FOREIGN KEY (`datasource`) REFERENCES `datasource` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `activity` (
  `ID` tinyint unsigned NOT NULL,
  `actName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `adjustments` (
  `issueID` int unsigned NOT NULL,
  `exDate` date NOT NULL,
  `cumAdjust` double unsigned NOT NULL,
  PRIMARY KEY (`issueID`,`exDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `advisers` (
  `PersonID` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`PersonID`),
  CONSTRAINT `FK_advisers_orgs` FOREIGN KEY (`PersonID`) REFERENCES `organisations` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `adviserships` (
  `Company` int unsigned NOT NULL,
  `Adviser` int unsigned NOT NULL,
  `Role` tinyint NOT NULL,
  `AddDate` date DEFAULT NULL,
  `AddAcc` tinyint unsigned DEFAULT NULL,
  `RemDate` date DEFAULT NULL,
  `RemAcc` tinyint unsigned DEFAULT NULL,
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `FK_adviserships_role` (`Role`),
  KEY `FK_adviserships_adviser` (`Adviser`),
  KEY `FK_adviserships_orgs` (`Company`),
  CONSTRAINT `FK_adviserships_adviser` FOREIGN KEY (`Adviser`) REFERENCES `advisers` (`PersonID`),
  CONSTRAINT `FK_adviserships_orgs` FOREIGN KEY (`Company`) REFERENCES `organisations` (`PersonID`),
  CONSTRAINT `FK_adviserships_role` FOREIGN KEY (`Role`) REFERENCES `roles` (`RoleID`)
) ENGINE=InnoDB AUTO_INCREMENT=135226 DEFAULT CHARSET=latin1;

CREATE TABLE `airlines` (
  `ICAO` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enName` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tcName` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scName` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ICAO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Airlines table from HK Airport';

CREATE TABLE `airports` (
  `IATA` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enName` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tcName` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scName` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`IATA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `alias` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `personID` int unsigned NOT NULL,
  `n1` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n2` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cn` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alias` bit(1) NOT NULL DEFAULT b'0',
  `dn1` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dn2` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `alias` (`n1`,`n2`,`cn`,`personID`),
  KEY `alias-people_idx` (`personID`),
  FULLTEXT KEY `ftalias` (`dn1`,`dn2`),
  FULLTEXT KEY `ftadn1` (`dn1`),
  FULLTEXT KEY `ftadn2` (`dn2`),
  CONSTRAINT `alias-people` FOREIGN KEY (`personID`) REFERENCES `people` (`PersonID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3911 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='For alternate and former names';

CREATE TABLE `bbexch` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `des` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The description SEHK uses',
  `name` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name we use',
  `fileDate` date DEFAULT NULL,
  `mapTo` tinyint unsigned DEFAULT NULL COMMENT 'for description typos, map to a different ID in this table',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `des` (`des`) /*!80000 INVISIBLE */
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='A list of buyback methods seen in SEHK buyback reports';

CREATE TABLE `bodytype` (
  `ID` tinyint unsigned NOT NULL,
  `des` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Body types for Transport Department tables';

CREATE TABLE `buybacklog` (
  `LastRun` datetime NOT NULL,
  `mainBoardDate` date NOT NULL,
  `GEMDate` date NOT NULL,
  PRIMARY KEY (`LastRun`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `campaign` (
  `CampID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `CampText` varchar(50) NOT NULL,
  `Recipient` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`CampID`),
  KEY `FK_campaign_recip` (`Recipient`),
  CONSTRAINT `FK_campaign_recip` FOREIGN KEY (`Recipient`) REFERENCES `people` (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `capacity` (
  `ID` smallint unsigned NOT NULL,
  `capShort` varchar(11) NOT NULL,
  `capLong` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `capchanges` (
  `CCID` int unsigned NOT NULL AUTO_INCREMENT,
  `IssueID` mediumint unsigned NOT NULL DEFAULT '0',
  `EffDate` date NOT NULL,
  `CapChangeType` tinyint unsigned NOT NULL,
  `exchID` tinyint unsigned DEFAULT NULL COMMENT 'ID from bbexch for buybacks',
  `shares` int DEFAULT NULL,
  `Value` double DEFAULT NULL,
  `Price` float DEFAULT NULL,
  `Currency` tinyint DEFAULT NULL,
  `Descrip` varchar(50) DEFAULT NULL,
  `fileDate` date DEFAULT NULL,
  PRIMARY KEY (`CCID`),
  UNIQUE KEY `unique` (`IssueID`,`EffDate`,`CapChangeType`,`exchID`),
  KEY `FK_capchanges_type` (`CapChangeType`),
  KEY `capchanges_issue_idx` (`IssueID`),
  CONSTRAINT `capchanges_issue` FOREIGN KEY (`IssueID`) REFERENCES `issue` (`ID1`),
  CONSTRAINT `FK_capchanges_type` FOREIGN KEY (`CapChangeType`) REFERENCES `capchangetypes` (`CapChangeType`)
) ENGINE=InnoDB AUTO_INCREMENT=121446 DEFAULT CHARSET=latin1;

CREATE TABLE `capchangetypes` (
  `CapChangeType` tinyint unsigned NOT NULL DEFAULT '0',
  `Change` varchar(30) DEFAULT NULL,
  `NegDescrip` varchar(50) DEFAULT NULL,
  `Descrip` varchar(50) DEFAULT NULL,
  `dist` bit(1) NOT NULL DEFAULT b'0',
  `likestr` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CapChangeType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `casetypes` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `prefix` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `des` varchar(63) COLLATE utf8mb4_unicode_ci NOT NULL,
  `courtID` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `caseTypesCourt_idx` (`courtID`),
  CONSTRAINT `caseTypesCourt` FOREIGN KEY (`courtID`) REFERENCES `courts` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categories` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=latin1;

CREATE TABLE `cattree` (
  `ChildCat` smallint unsigned NOT NULL,
  `ParentCat` smallint unsigned NOT NULL,
  PRIMARY KEY (`ChildCat`,`ParentCat`),
  KEY `FK_cattree_parent` (`ParentCat`),
  CONSTRAINT `FK_cattree_child` FOREIGN KEY (`ChildCat`) REFERENCES `categories` (`ID`),
  CONSTRAINT `FK_cattree_parent` FOREIGN KEY (`ParentCat`) REFERENCES `categories` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `chartitems` (
  `chartID` smallint unsigned NOT NULL,
  `dataitem` smallint unsigned NOT NULL,
  `typeID` tinyint unsigned NOT NULL DEFAULT '2',
  `negate` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`chartID`,`dataitem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='dataitems to be included in a chart';

CREATE TABLE `charts` (
  `ID` smallint unsigned NOT NULL,
  `title` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quant` bit(1) NOT NULL DEFAULT b'1' COMMENT 'whether the chart is of quantity per period or a point-in-time value such as a price or temperature',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `charttypes` (
  `ID` tinyint unsigned NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `classifications` (
  `Company` int unsigned NOT NULL,
  `Category` smallint unsigned NOT NULL,
  PRIMARY KEY (`Company`,`Category`),
  KEY `FK_classifications_cats` (`Category`),
  CONSTRAINT `FK_classifications_cats` FOREIGN KEY (`Category`) REFERENCES `categories` (`ID`),
  CONSTRAINT `FK_classifications_org` FOREIGN KEY (`Company`) REFERENCES `organisations` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `codeshare` (
  `flightID` int NOT NULL,
  `flightNo` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `airline` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`flightID`,`flightNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Other flight numbers for the same flight';

CREATE TABLE `comeets` (
  `orgID` int unsigned NOT NULL,
  `comID` tinyint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `mtngs` tinyint unsigned NOT NULL COMMENT 'Number of committee meetings during the financial year',
  `userID` mediumint unsigned NOT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`orgID`,`comID`,`atDate`),
  CONSTRAINT `comeetsOrg` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `comex` (
  `orgID` int unsigned NOT NULL,
  `atDate` date NOT NULL,
  `comID` tinyint unsigned NOT NULL,
  PRIMARY KEY (`orgID`,`atDate`,`comID`),
  CONSTRAINT `comexOrg` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Table of orgs without committees on the snapshot date';

CREATE TABLE `compos` (
  `orgID` int unsigned NOT NULL,
  `dirID` int unsigned NOT NULL,
  `comID` tinyint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `posn` tinyint unsigned DEFAULT NULL,
  `userID` mediumint unsigned NOT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `attend` tinyint unsigned DEFAULT NULL,
  `mtngs` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`orgID`,`dirID`,`comID`,`atDate`),
  KEY `composPeople_idx` (`dirID`),
  CONSTRAINT `composOrg` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `composPeople` FOREIGN KEY (`dirID`) REFERENCES `people` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `coms` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `comName` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `corpwords` (
  `word` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `courts` (
  `ID` tinyint unsigned NOT NULL,
  `des` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ncPref` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `currencies` (
  `ID` tinyint unsigned NOT NULL DEFAULT '0',
  `currency` varchar(3) DEFAULT NULL,
  `HKEXcurr` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `curr` (`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `currpair` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `curr1` tinyint unsigned NOT NULL,
  `curr2` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COMMENT='Currency pairs for forexrates table. Rates are one unit of curr1 expressed in curr2';

CREATE TABLE `data` (
  `item` smallint unsigned NOT NULL,
  `d` date NOT NULL,
  `v` float NOT NULL,
  PRIMARY KEY (`item`,`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dataitems` (
  `ID` smallint unsigned NOT NULL,
  `ddes` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dp` tinyint unsigned NOT NULL DEFAULT '2' COMMENT 'number of decimal places to display',
  `sv` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The variable name used in source data',
  `units` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `freq` tinyint unsigned NOT NULL COMMENT 'Frequency of data. 1=monthly 2=quarterly 3=annual',
  `shortname` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `datasource` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `URL` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `swagger` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL to swagger data dictionary',
  `fieldlist` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dateaccuracy` (
  `AccID` tinyint unsigned NOT NULL DEFAULT '0',
  `AccText` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`AccID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `destor` (
  `flightID` int NOT NULL,
  `seq` tinyint unsigned NOT NULL,
  `IATA` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`flightID`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='destination or origin cities (in visit order)';

CREATE TABLE `directorships` (
  `ID1` int unsigned NOT NULL AUTO_INCREMENT,
  `Company` int unsigned NOT NULL,
  `Director` int unsigned NOT NULL,
  `JoinedY` smallint DEFAULT NULL,
  `ApptDate` date DEFAULT NULL,
  `ApptAcc` tinyint DEFAULT NULL,
  `ResDate` date DEFAULT NULL,
  `ResAcc` tinyint DEFAULT NULL,
  `positionID` smallint unsigned NOT NULL,
  `source` tinyint unsigned DEFAULT NULL COMMENT '1=HKlawSoc law firms (lsposts), 2=HKlawSoc non-law (lsjobs), 3=UKCH',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID1`),
  KEY `FK_directorships_org` (`Company`),
  KEY `FK_directorships_posn_idx` (`positionID`),
  KEY `FK_directorships_persons_idx` (`Director`),
  CONSTRAINT `FK_directorships_orgs` FOREIGN KEY (`Company`) REFERENCES `organisations` (`PersonID`),
  CONSTRAINT `FK_directorships_persons` FOREIGN KEY (`Director`) REFERENCES `persons` (`PersonID`),
  CONSTRAINT `FK_directorships_posn` FOREIGN KEY (`positionID`) REFERENCES `positions` (`positionID`)
) ENGINE=InnoDB AUTO_INCREMENT=32104940 DEFAULT CHARSET=latin1;

CREATE TABLE `dismodes` (
  `ID` tinyint unsigned NOT NULL,
  `disModeTxt` varchar(45) NOT NULL,
  `UKuri` varchar(45) DEFAULT NULL,
  `UKapi` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dlreasons` (
  `ReasonID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `Reason` varchar(45) NOT NULL,
  PRIMARY KEY (`ReasonID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

CREATE TABLE `doctypes` (
  `DocTypeID` tinyint NOT NULL,
  `DocShort` varchar(50) DEFAULT NULL,
  `DocLong` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DocTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `documents` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `OrgID` int unsigned NOT NULL DEFAULT '0',
  `DocTypeID` tinyint NOT NULL,
  `RecordDate` date NOT NULL,
  `MidDay` bit(1) DEFAULT b'0',
  `ReportDate` date DEFAULT NULL,
  `Adv` bit(1) DEFAULT b'0',
  `Dir` bit(1) DEFAULT b'0',
  `pay` bit(1) DEFAULT b'0',
  `SAI` bit(1) DEFAULT b'0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `repID` mediumint unsigned DEFAULT NULL,
  `resID` mediumint unsigned DEFAULT NULL,
  `payPage` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_docs_doctypes` (`DocTypeID`),
  KEY `FK_docs_orgs` (`OrgID`),
  KEY `docs_repfilings_idx` (`repID`) /*!80000 INVISIBLE */,
  KEY `docOrgDate` (`OrgID`,`DocTypeID`,`RecordDate` DESC),
  CONSTRAINT `docs_repfilings` FOREIGN KEY (`repID`) REFERENCES `repfilings` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_docs_doctypes` FOREIGN KEY (`DocTypeID`) REFERENCES `doctypes` (`DocTypeID`),
  CONSTRAINT `FK_documents_orgs` FOREIGN KEY (`OrgID`) REFERENCES `organisations` (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=124284 DEFAULT CHARSET=latin1;

CREATE TABLE `domchanges` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `orgID` int unsigned NOT NULL,
  `dateChanged` date NOT NULL,
  `dateAcc` tinyint unsigned DEFAULT NULL,
  `oldDom` smallint unsigned NOT NULL,
  `oldIncID` varchar(14) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `org-dc` (`orgID`,`dateChanged`),
  KEY `domchanges_org_idx` (`orgID`),
  KEY `domchanges_dom_idx` (`oldDom`),
  CONSTRAINT `domchanges_dom` FOREIGN KEY (`oldDom`) REFERENCES `domiciles` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `domchanges_org` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `domiciles` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `ShortName` varchar(6) NOT NULL,
  `FullName` varchar(50) NOT NULL,
  `HKExDomicile` varchar(50) DEFAULT NULL,
  `A2` varchar(4) NOT NULL COMMENT 'ISO 3166-1 Alpha 2 code',
  `friendly` varchar(30) NOT NULL,
  `HKCR` varchar(45) DEFAULT NULL COMMENT 'name used by HK Companies Registry for non-HK companies',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=331 DEFAULT CHARSET=latin1;

CREATE TABLE `donations` (
  `Campaign` tinyint unsigned NOT NULL,
  `Donor` int unsigned NOT NULL,
  `DonCurr` tinyint unsigned NOT NULL DEFAULT '0',
  `DonAmnt` int unsigned NOT NULL,
  `Receipt` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`Campaign`,`Donor`),
  KEY `FK_donations_donor` (`Donor`),
  KEY `FK_donations_currency` (`DonCurr`),
  CONSTRAINT `FK_donations_campaign` FOREIGN KEY (`Campaign`) REFERENCES `campaign` (`CampID`),
  CONSTRAINT `FK_donations_currency` FOREIGN KEY (`DonCurr`) REFERENCES `currencies` (`ID`),
  CONSTRAINT `FK_donations_donor` FOREIGN KEY (`Donor`) REFERENCES `persons` (`PersonID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dtsquotes` (
  `stockCode` int unsigned NOT NULL,
  `stockID` int unsigned DEFAULT NULL,
  `date` date NOT NULL,
  `high` float unsigned NOT NULL,
  `low` float unsigned NOT NULL,
  `closing` float unsigned NOT NULL,
  `vol` bigint unsigned NOT NULL,
  `turn` bigint unsigned NOT NULL,
  `deals` int unsigned NOT NULL,
  `bid` float unsigned NOT NULL,
  `ask` float unsigned NOT NULL,
  `susp` bit(1) NOT NULL,
  `last` float unsigned DEFAULT NULL,
  PRIMARY KEY (`stockCode`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `enginesize` (
  `ID` tinyint unsigned NOT NULL,
  `des` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TD` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ENGINE_SIZE column from table 4.2',
  `TD2` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'New TD description for 2022-07 onwards',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Engine sizes for Transport Dept Private Cars table 4.2';

CREATE TABLE `entitlements` (
  `importID` int unsigned NOT NULL AUTO_INCREMENT,
  `daily` bit(1) NOT NULL DEFAULT b'0',
  `AutoProcess` bit(1) DEFAULT b'0',
  `IgnoreRow` bit(1) DEFAULT b'0',
  `STOCK` varchar(5) DEFAULT NULL,
  `SEHKID` int unsigned DEFAULT NULL,
  `IssueID` mediumint unsigned DEFAULT NULL,
  `STK_NAME` varchar(60) DEFAULT NULL,
  `TYPE` varchar(4) DEFAULT NULL,
  `Announced` date DEFAULT NULL,
  `YearEnd` date DEFAULT NULL,
  `DETAILS_1` varchar(63) DEFAULT NULL,
  `DETAILS_2` varchar(63) DEFAULT NULL,
  `DETAILS_3` varchar(63) DEFAULT NULL,
  `DETAILS_4` varchar(63) DEFAULT NULL,
  `DETAILS_5` varchar(63) DEFAULT NULL,
  `DETAILS_6` varchar(63) DEFAULT NULL,
  `BookCloseFr` date DEFAULT NULL,
  `BookCloseTo` date DEFAULT NULL,
  `PayDate` date DEFAULT NULL,
  `ExDate` date DEFAULT NULL,
  `CapChangeType1` tinyint unsigned DEFAULT NULL,
  `Curr1` tinyint unsigned DEFAULT NULL,
  `Price1` double unsigned DEFAULT NULL,
  `PriceHKD1` double unsigned DEFAULT NULL,
  `Old1` double unsigned DEFAULT NULL,
  `New1` double unsigned DEFAULT NULL,
  `Date1` date DEFAULT NULL,
  `IssueID1` int unsigned DEFAULT NULL,
  `Descrip1` varchar(255) DEFAULT NULL,
  `CapChangeType2` tinyint unsigned DEFAULT NULL,
  `Curr2` tinyint unsigned DEFAULT NULL,
  `Price2` double DEFAULT NULL,
  `PriceHKD2` double DEFAULT NULL,
  `Old2` double unsigned DEFAULT NULL,
  `New2` double unsigned DEFAULT NULL,
  `Date2` date DEFAULT NULL,
  `IssueID2` int unsigned DEFAULT NULL,
  `Descrip2` varchar(255) DEFAULT NULL,
  `CapChangeType3` tinyint unsigned DEFAULT NULL,
  `Curr3` tinyint unsigned DEFAULT NULL,
  `Price3` double DEFAULT NULL,
  `PriceHKD3` double DEFAULT NULL,
  `Old3` double unsigned DEFAULT NULL,
  `New3` double unsigned DEFAULT NULL,
  `Date3` date DEFAULT NULL,
  `IssueID3` int unsigned DEFAULT NULL,
  `Descrip3` varchar(255) DEFAULT NULL,
  `CapChangeType4` tinyint unsigned DEFAULT NULL,
  `Curr4` tinyint unsigned DEFAULT NULL,
  `Price4` double DEFAULT NULL,
  `PriceHKD4` double DEFAULT NULL,
  `Old4` double unsigned DEFAULT NULL,
  `New4` double unsigned DEFAULT NULL,
  `Date4` date DEFAULT NULL,
  `IssueID4` int unsigned DEFAULT NULL,
  `Descrip4` varchar(255) DEFAULT NULL,
  `Event1` int unsigned DEFAULT NULL,
  `Event2` int unsigned DEFAULT NULL,
  `Event3` int unsigned DEFAULT NULL,
  `Event4` int unsigned DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `col1` bit(1) NOT NULL DEFAULT b'0',
  `col2` bit(1) NOT NULL DEFAULT b'0',
  `col3` bit(1) NOT NULL DEFAULT b'0',
  `col4` bit(1) NOT NULL DEFAULT b'0',
  `col5` bit(1) NOT NULL DEFAULT b'0',
  `col6` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`importID`) USING BTREE,
  KEY `FK_entitlements_event1` (`Event1`),
  KEY `FK_entitlements_event2` (`Event2`),
  KEY `FK_entitlements_event3` (`Event3`),
  KEY `FK_entitlements_event4` (`Event4`),
  KEY `FK_entitlements_type1` (`CapChangeType1`),
  KEY `FK_entitlements_type2` (`CapChangeType2`),
  KEY `FK_entitlements_type3` (`CapChangeType3`),
  KEY `FK_entitlements_type4` (`CapChangeType4`),
  KEY `entitlements_issue_idx` (`IssueID`),
  CONSTRAINT `entitlements_issue` FOREIGN KEY (`IssueID`) REFERENCES `issue` (`ID1`),
  CONSTRAINT `FK_entitlements_event1` FOREIGN KEY (`Event1`) REFERENCES `events` (`eventID`) ON DELETE SET NULL,
  CONSTRAINT `FK_entitlements_event2` FOREIGN KEY (`Event2`) REFERENCES `events` (`eventID`) ON DELETE SET NULL,
  CONSTRAINT `FK_entitlements_event3` FOREIGN KEY (`Event3`) REFERENCES `events` (`eventID`) ON DELETE SET NULL,
  CONSTRAINT `FK_entitlements_event4` FOREIGN KEY (`Event4`) REFERENCES `events` (`eventID`) ON DELETE SET NULL,
  CONSTRAINT `FK_entitlements_type1` FOREIGN KEY (`CapChangeType1`) REFERENCES `capchangetypes` (`CapChangeType`),
  CONSTRAINT `FK_entitlements_type2` FOREIGN KEY (`CapChangeType2`) REFERENCES `capchangetypes` (`CapChangeType`),
  CONSTRAINT `FK_entitlements_type3` FOREIGN KEY (`CapChangeType3`) REFERENCES `capchangetypes` (`CapChangeType`),
  CONSTRAINT `FK_entitlements_type4` FOREIGN KEY (`CapChangeType4`) REFERENCES `capchangetypes` (`CapChangeType`)
) ENGINE=InnoDB AUTO_INCREMENT=122790 DEFAULT CHARSET=latin1;

CREATE TABLE `errorlog` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `proc` varchar(45) DEFAULT NULL,
  `descrip` varchar(1000) DEFAULT NULL,
  `errTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3536 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ess` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `eName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phase` tinyint unsigned NOT NULL DEFAULT '1',
  `amt` int NOT NULL,
  `heads` int NOT NULL,
  `orgID` int unsigned DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `name` (`eName`,`cName`),
  KEY `ESSpersons_idx` (`orgID`),
  FULLTEXT KEY `ftn` (`eName`)
) ENGINE=InnoDB AUTO_INCREMENT=304606 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Employment Support Subsidy';

CREATE TABLE `events` (
  `eventID` int unsigned NOT NULL AUTO_INCREMENT,
  `importID` int unsigned DEFAULT NULL,
  `subEnt` tinyint unsigned DEFAULT NULL,
  `issueID` mediumint unsigned NOT NULL,
  `announced` date DEFAULT NULL,
  `eventType` tinyint unsigned NOT NULL,
  `yearEnd` date DEFAULT NULL,
  `exDate` date DEFAULT NULL,
  `bookCloseFr` date DEFAULT NULL,
  `bookCloseTo` date DEFAULT NULL,
  `acceptDate` date DEFAULT NULL,
  `distDate` date DEFAULT NULL,
  `new` double unsigned DEFAULT NULL,
  `old` double unsigned DEFAULT NULL,
  `currID` tinyint unsigned DEFAULT NULL,
  `price` double unsigned DEFAULT NULL,
  `priceHKD` double unsigned DEFAULT NULL,
  `issue2` mediumint unsigned DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `cumDate` date DEFAULT NULL,
  `cumPrice` float unsigned DEFAULT NULL,
  `afterEvent` int unsigned DEFAULT NULL,
  `adjust` double unsigned DEFAULT NULL,
  `cancelDate` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `FXdate` date DEFAULT NULL COMMENT 'date for FX estimate',
  `tempEntry` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`eventID`) USING BTREE,
  KEY `issue2_issue_idx` (`issue2`),
  KEY `issueCum` (`issueID`,`cumDate`,`eventType`),
  KEY `issueEx` (`issueID`,`exDate`,`eventType`),
  KEY `importCol` (`importID`,`subEnt`),
  KEY `capChangeType_idx` (`eventType`),
  CONSTRAINT `capChangeType` FOREIGN KEY (`eventType`) REFERENCES `capchangetypes` (`CapChangeType`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_events_entit` FOREIGN KEY (`importID`) REFERENCES `entitlements` (`importID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `issue1_issue` FOREIGN KEY (`issueID`) REFERENCES `issue` (`ID1`),
  CONSTRAINT `issue2_issue` FOREIGN KEY (`issue2`) REFERENCES `issue` (`ID1`)
) ENGINE=InnoDB AUTO_INCREMENT=173737 DEFAULT CHARSET=latin1;

CREATE TABLE `filingcodes` (
  `repID` mediumint unsigned NOT NULL,
  `sc` mediumint unsigned NOT NULL,
  PRIMARY KEY (`repID`,`sc`),
  CONSTRAINT `filingcodes_reps` FOREIGN KEY (`repID`) REFERENCES `repfilings` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='one or more stock codes for each filing in repfilings';

CREATE TABLE `flights` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `sched` datetime NOT NULL,
  `flightNo` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `airline` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual` datetime DEFAULT NULL,
  `terminal` tinyint unsigned DEFAULT NULL,
  `aisle` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gate` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stand` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `baggage` tinyint unsigned DEFAULT NULL,
  `hall` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `arrival` bit(1) NOT NULL,
  `cargo` bit(1) NOT NULL DEFAULT b'0',
  `cancelled` bit(1) NOT NULL DEFAULT b'0',
  `lastSeen` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `schedFNarr` (`sched`,`flightNo`,`arrival`)
) ENGINE=InnoDB AUTO_INCREMENT=1253304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `forexrates` (
  `currpair` tinyint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `rate` float unsigned NOT NULL,
  PRIMARY KEY (`currpair`,`atDate`) USING BTREE,
  CONSTRAINT `FK_currpair` FOREIGN KEY (`currpair`) REFERENCES `currpair` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `freg` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `orgID` int unsigned NOT NULL,
  `hostDom` smallint unsigned NOT NULL,
  `regID` varchar(11) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `regDate` date DEFAULT NULL,
  `cesDate` date DEFAULT NULL,
  `regUpd` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `freg-2` (`hostDom`,`regID`),
  KEY `freg-org_idx` (`orgID`),
  CONSTRAINT `freg-dom` FOREIGN KEY (`hostDom`) REFERENCES `domiciles` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `freg-org` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=37477 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='overseas registrations of companies';

CREATE TABLE `freq` (
  `ID` tinyint unsigned NOT NULL,
  `fdes` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `frstatus` (
  `ID` tinyint unsigned NOT NULL,
  `des` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Transport Dept FIRST_REG_STATUS (up to 2018-12-31) and FIRST_REG_STATUS_REV thereafter';

CREATE TABLE `fueltype` (
  `ID` tinyint unsigned NOT NULL,
  `des` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `friendly` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Fuel type for Transport Department tables';

CREATE TABLE `govac` (
  `d` date NOT NULL,
  `govItem` smallint unsigned NOT NULL,
  `ann` bit(1) NOT NULL DEFAULT b'1' COMMENT 'Annual (true) or quarterly (false)',
  `est` int NOT NULL DEFAULT '0',
  `act` int NOT NULL DEFAULT '0',
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`d`,`govItem`,`ann`),
  KEY `govac_idx` (`govItem`),
  CONSTRAINT `govac` FOREIGN KEY (`govItem`) REFERENCES `govitems` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Accounts of the HKSAR Government';

CREATE TABLE `govadopt` (
  `tree` smallint unsigned NOT NULL COMMENT 'The ID of the tree. Will be specified with a govitem when calling for a presentation. One govitem can be in multiple trees, but each govitem has a default parentID if not in this table.',
  `govitem` smallint unsigned NOT NULL,
  `parentID` smallint unsigned NOT NULL COMMENT 'The govitem of the adoptive parent',
  `txt` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'alternative text to display in this context',
  `short` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'alternative description for graphs in this tree',
  `priority` tinyint DEFAULT NULL,
  PRIMARY KEY (`tree`,`govitem`),
  KEY `FKadoptitems` (`govitem`),
  CONSTRAINT `FKadoptitems` FOREIGN KEY (`govitem`) REFERENCES `govitems` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Record alternative groupings of govitems with adoptive parentID for different trees';

CREATE TABLE `govitems` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `parentID` smallint unsigned DEFAULT NULL,
  `h1` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `h2` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `h3` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `govtxt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The text used by Govt in its files. Do not amend even for typos, as we often use it for matching when no head-numbers are provided. Use txt field for our version.',
  `txt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `short` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstd` date NOT NULL COMMENT 'First date for which records under this heading are complete (e.g. Stamp Duty may go back longer than all Internal Revenue).',
  `priority` tinyint NOT NULL DEFAULT '0' COMMENT 'The priority for display. Typically 0 but -1 for "Other" items. Allows ordered layouts.',
  `approved` int unsigned DEFAULT NULL COMMENT 'Approved amount of budget for capital project',
  `rev` bit(1) NOT NULL DEFAULT b'0' COMMENT '0=expenditure 1=revenue',
  `reimb` bit(1) NOT NULL DEFAULT b'0' COMMENT 'In expenditure, whether this is a reimbursed lineitem ',
  `head` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Whether this is just a heading (1) or has data(0)',
  `transfer` bit(1) NOT NULL DEFAULT b'0' COMMENT 'The item is a transfer between funds, or an "additional commitment" line which is only used in estimates, not actual accounts. Hide from display.',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `heads` (`rev`,`h1`,`h2`,`h3`) /*!80000 INVISIBLE */,
  KEY `parentID` (`parentID`),
  KEY `tranferReimburse` (`transfer`,`reimb`),
  FULLTEXT KEY `search` (`txt`)
) ENGINE=InnoDB AUTO_INCREMENT=6751 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Items in government accounts';

CREATE TABLE `heldas` (
  `ID` tinyint unsigned NOT NULL,
  `heldAsTxt` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `hkcrtypes` (
  `prefix` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CRtype` varchar(42) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orgType` tinyint unsigned NOT NULL,
  PRIMARY KEY (`prefix`),
  KEY `orgType_idx` (`orgType`),
  CONSTRAINT `orgType` FOREIGN KEY (`orgType`) REFERENCES `orgtypes` (`orgType`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Org types based on Companies Registry prefix';

CREATE TABLE `hkdistrict` (
  `ID` tinyint unsigned NOT NULL,
  `en` varchar(17) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cn` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `regionID` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `en_UNIQUE` (`en`),
  KEY `district_region_idx` (`regionID`),
  CONSTRAINT `district_region` FOREIGN KEY (`regionID`) REFERENCES `hkregion` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HK districts';

CREATE TABLE `hkexdata` (
  `StockCode` varchar(5) NOT NULL,
  `Domicile` varchar(50) DEFAULT NULL,
  `BoardLot` int unsigned DEFAULT NULL,
  `NomPrice` double DEFAULT NULL,
  `PriceDate` datetime DEFAULT NULL,
  `IssueID` mediumint unsigned NOT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`IssueID`),
  KEY `FK_hkexdata_issue` (`IssueID`),
  CONSTRAINT `hkexdata_issue` FOREIGN KEY (`IssueID`) REFERENCES `issue` (`ID1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `hkports` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HK immigration control points';

CREATE TABLE `hkpx` (
  `d` date NOT NULL,
  `port` tinyint unsigned NOT NULL,
  `pxType` tinyint unsigned NOT NULL,
  `arrivals` int NOT NULL DEFAULT '0' COMMENT '0=departure, 1=arrival',
  `departures` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`d`,`port`,`pxType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Passenger traffic at HK control points';

CREATE TABLE `hkpxtypes` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Types of passenger in HK immigration statistics';

CREATE TABLE `hkregion` (
  `ID` tinyint unsigned NOT NULL,
  `en` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cn` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `en_UNIQUE` (`en`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The 3 regions of HK';

CREATE TABLE `issue` (
  `ID1` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `issuer` int unsigned NOT NULL,
  `SEHKID` int DEFAULT NULL,
  `typeID` tinyint unsigned NOT NULL,
  `expmat` date DEFAULT NULL,
  `expAcc` tinyint unsigned DEFAULT NULL,
  `SEHKcurr` tinyint unsigned DEFAULT NULL COMMENT 'currency on SEHK if not HKD',
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  `coupon` float DEFAULT NULL,
  `floating` bit(1) DEFAULT b'0',
  `HKEXwvr` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Whether this is the "class carrying weighted voting rights" not listed but outstanding shares are disclosed in HKEXdata as either class_A or class_B',
  PRIMARY KEY (`ID1`),
  KEY `FK_issue_orgs` (`issuer`),
  CONSTRAINT `FK_issue_orgs` FOREIGN KEY (`issuer`) REFERENCES `organisations` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36774 DEFAULT CHARSET=latin1;

CREATE TABLE `issuedshares` (
  `issueID` mediumint unsigned NOT NULL DEFAULT '0',
  `atDate` date NOT NULL,
  `outstanding` double DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`issueID`,`atDate`),
  CONSTRAINT `issuedshares_issue` FOREIGN KEY (`issueID`) REFERENCES `issue` (`ID1`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `jails` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `jailtypes` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `txt` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `txt` (`txt`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `judgments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `uploaded` date DEFAULT NULL,
  `jDate` date DEFAULT NULL,
  `DIS` int unsigned NOT NULL COMMENT 'page number for link to web page of the case',
  `caseNum` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `caseType` tinyint unsigned DEFAULT NULL,
  `neutCit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parties` varchar(511) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rep` varchar(63) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lang` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `star` bit(1) NOT NULL DEFAULT b'0',
  `RV` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Whether this judgment is a Reasons for Verdict',
  `RS` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Whether this judgment is a Reasons for Sentence',
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `caseYear` smallint unsigned DEFAULT NULL,
  `caseSeq` mediumint unsigned DEFAULT NULL,
  `ncYear` smallint unsigned DEFAULT NULL,
  `ncSeq` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `DIS` (`DIS`),
  KEY `judgmentsCaseType_idx` (`caseType`),
  KEY `caseNum` (`caseType`,`caseYear`,`caseSeq`),
  CONSTRAINT `judgmentsCaseType` FOREIGN KEY (`caseType`) REFERENCES `casetypes` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=159554 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Details captured from Judiciary Newly Added Judgments page';

CREATE TABLE `landreg` (
  `statID` smallint unsigned NOT NULL,
  `d` date NOT NULL,
  `units` int NOT NULL,
  `consid` int DEFAULT NULL,
  PRIMARY KEY (`statID`,`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `licrec` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `staffID` int unsigned NOT NULL,
  `orgID` int unsigned NOT NULL,
  `role` tinyint unsigned NOT NULL COMMENT '0=rep, 1=RO',
  `actType` tinyint unsigned NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `licrecOrgs_idx` (`orgID`),
  KEY `licrecPeople_idx` (`staffID`),
  KEY `licrecActs_idx` (`actType`) /*!80000 INVISIBLE */,
  CONSTRAINT `licrecActs` FOREIGN KEY (`actType`) REFERENCES `activity` (`ID`),
  CONSTRAINT `licrecOrgs` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`),
  CONSTRAINT `licrecPeople` FOREIGN KEY (`staffID`) REFERENCES `people` (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=864438 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='detailed SFC licence records for staff';

CREATE TABLE `licrecsum` (
  `actType` tinyint unsigned NOT NULL COMMENT 'activity type',
  `d` date NOT NULL,
  `total` mediumint unsigned NOT NULL COMMENT 'DISTINCT licensees',
  `RO` mediumint unsigned NOT NULL COMMENT 'DISTINCT responsible officers',
  PRIMARY KEY (`actType`,`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Summary table of licensees to speed up the all-firms page SFChistall';

CREATE TABLE `lirorgteam` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `orgID` int unsigned NOT NULL,
  `teamID` tinyint unsigned NOT NULL,
  `firstseen` date NOT NULL,
  `lastseen` date NOT NULL,
  `dead` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Team number for each HK-listed company.';

CREATE TABLE `lirroles` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `lirstaff` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `n1` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n2` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cn` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tel` int unsigned NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `lirteams` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `teamno` smallint unsigned NOT NULL COMMENT 'the number used by the Listing Division',
  `firstseen` date DEFAULT NULL,
  `lastseen` date DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `teamno` (`teamno`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The teams of the Listing Division';

CREATE TABLE `lirteamstaff` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `teamID` tinyint unsigned NOT NULL,
  `staffID` smallint unsigned NOT NULL,
  `posID` tinyint unsigned NOT NULL,
  `firstSeen` date NOT NULL,
  `lastSeen` date NOT NULL,
  `dead` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `FKlirteams` (`teamID`),
  KEY `FKlirstaff_idx` (`staffID`),
  CONSTRAINT `FKlirstaff` FOREIGN KEY (`staffID`) REFERENCES `lirstaff` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKlirteams` FOREIGN KEY (`teamID`) REFERENCES `lirteams` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The staff members of each Listing team. They may change rank without changing team';

CREATE TABLE `listings` (
  `stockExID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `shortName` varchar(10) DEFAULT NULL,
  `longName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`stockExID`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=latin1;

CREATE TABLE `log` (
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='For storing locations and logs';

CREATE TABLE `lsadm` (
  `lsid` int unsigned NOT NULL,
  `lsdom` tinyint unsigned NOT NULL,
  `adm` date NOT NULL,
  `admAcc` tinyint unsigned DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`lsid`,`lsdom`),
  KEY `lsadm-lsdom_idx` (`lsdom`),
  CONSTRAINT `lsadm-lsdom` FOREIGN KEY (`lsdom`) REFERENCES `lsdoms` (`lsdom`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='LawSoc admissions in other jurisdictions ';

CREATE TABLE `lsalias` (
  `lsid` int unsigned NOT NULL,
  `aliase` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aliasc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstSeen` datetime DEFAULT NULL,
  PRIMARY KEY (`lsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `lsdoms` (
  `lsdom` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `domName` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `domID` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`lsdom`),
  UNIQUE KEY `domName_UNIQUE` (`domName`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Domiciles for Law Society admission';

CREATE TABLE `lsemps` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `empName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `personID` int unsigned DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `lsemps-orgs_idx` (`personID`),
  CONSTRAINT `lsemps-orgs` FOREIGN KEY (`personID`) REFERENCES `organisations` (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=2316 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Non-law firms named as employers by Law Soc';

CREATE TABLE `lsjobs` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `lsppl` int unsigned NOT NULL,
  `empID` int unsigned NOT NULL,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `lsjobs-emps_idx` (`empID`),
  KEY `lsjobs-lsppl_idx` (`lsppl`),
  CONSTRAINT `lsjobs-emps` FOREIGN KEY (`empID`) REFERENCES `lsemps` (`ID`),
  CONSTRAINT `lsjobs-lsppl` FOREIGN KEY (`lsppl`) REFERENCES `lsppl` (`lsid`)
) ENGINE=InnoDB AUTO_INCREMENT=14337 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Jobs of Law Society solicitors not in law firms';

CREATE TABLE `lsorgs` (
  `lsid` int unsigned NOT NULL,
  `lsename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lscname` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'use as a matching device when a firm name changes',
  `name1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orgType` tinyint unsigned DEFAULT NULL,
  `personID` int unsigned DEFAULT NULL,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`lsid`),
  KEY `lsorgs-orgs_idx` (`personID`),
  CONSTRAINT `lsorgs-orgs` FOREIGN KEY (`personID`) REFERENCES `organisations` (`PersonID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Law Society member firms';

CREATE TABLE `lsposts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `lsorg` int unsigned NOT NULL,
  `lsppl` int unsigned NOT NULL,
  `post` tinyint unsigned NOT NULL,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `posts-ppl_idx` (`lsppl`),
  KEY `posts-orgs_idx` (`lsorg`),
  CONSTRAINT `lsposts-lsorgs` FOREIGN KEY (`lsorg`) REFERENCES `lsorgs` (`lsid`),
  CONSTRAINT `lsposts-lsppl` FOREIGN KEY (`lsppl`) REFERENCES `lsppl` (`lsid`)
) ENGINE=InnoDB AUTO_INCREMENT=50478 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Positions of people in Law Society member firms';

CREATE TABLE `lsppl` (
  `lsid` int unsigned NOT NULL,
  `lsename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lscname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admHK` date DEFAULT NULL,
  `admAcc` tinyint DEFAULT NULL,
  `name1` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name2` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `personID` int unsigned DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`lsid`),
  KEY `lsppl-people_idx` (`personID`),
  KEY `lsppl-name` (`name1`,`name2`,`admHK`),
  CONSTRAINT `lsppl-people` FOREIGN KEY (`personID`) REFERENCES `people` (`PersonID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Law Society people';

CREATE TABLE `lsroles` (
  `ID` tinyint NOT NULL,
  `posID` smallint unsigned NOT NULL,
  `LStxt` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `marketsforweb` (
  `StockExID` tinyint unsigned NOT NULL DEFAULT '0',
  `Order` tinyint DEFAULT NULL,
  PRIMARY KEY (`StockExID`),
  CONSTRAINT `FK_marketsforweb_listings` FOREIGN KEY (`StockExID`) REFERENCES `listings` (`stockExID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `mergedpersons` (
  `oldp` int unsigned NOT NULL,
  `newp` int unsigned NOT NULL,
  `merged` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`oldp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Map persons who have been merged from their old personID to the new one. Can be chained. Used to forward web pages from old links.';

CREATE TABLE `missingcr` (
  `CR` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `BRN` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `eName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cName` varchar(127) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`CR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Temporary table to record missing entities from the CR mapping CSV';

CREATE TABLE `missingorg` (
  `orgID` int unsigned NOT NULL,
  `added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`orgID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Orgs discovered when reading CR changes';

CREATE TABLE `months` (
  `MonthID` tinyint NOT NULL,
  `ShortName` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`MonthID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `namechanges` (
  `ID1` int unsigned NOT NULL AUTO_INCREMENT,
  `personID` int unsigned NOT NULL DEFAULT '0',
  `oldName` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `oldcName` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dateChanged` date DEFAULT NULL,
  `dateAcc` tinyint DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `nameHash` bigint unsigned DEFAULT NULL,
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID1`),
  KEY `oldName` (`oldName`) USING BTREE,
  KEY `dateName` (`dateChanged`,`oldName`) USING BTREE,
  KEY `FK_namechanges_org` (`personID`) USING BTREE,
  KEY `nameHash` (`nameHash`),
  FULLTEXT KEY `ftoldname` (`oldName`),
  CONSTRAINT `FK_namechanges_orgs` FOREIGN KEY (`personID`) REFERENCES `organisations` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61071690 DEFAULT CHARSET=latin1;

CREATE TABLE `namesex` (
  `ID` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sex` varchar(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dsex` varchar(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=575496 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `nationality` (
  `personID` int unsigned NOT NULL,
  `UKCHnat` smallint unsigned NOT NULL,
  `latest` date NOT NULL,
  PRIMARY KEY (`personID`,`UKCHnat`),
  KEY `FK_nats_UKCHnats_idx` (`UKCHnat`),
  CONSTRAINT `FK_nats_people` FOREIGN KEY (`personID`) REFERENCES `people` (`PersonID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `FK_nats_UKCHnats` FOREIGN KEY (`UKCHnat`) REFERENCES `ukchnats` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `oldcr` (
  `personID` int unsigned NOT NULL,
  `crn` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brn` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`personID`),
  UNIQUE KEY `CRn` (`crn`),
  CONSTRAINT `oldcr-org` FOREIGN KEY (`personID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The old company number for each entity in the Companies Registry';

CREATE TABLE `oldcrf` (
  `fregID` int unsigned NOT NULL,
  `crn` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brn` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`fregID`),
  UNIQUE KEY `CRn` (`crn`),
  CONSTRAINT `oldcrf-freg` FOREIGN KEY (`fregID`) REFERENCES `freg` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The old registry F- number for each foreign entity in the Companies Registry';

CREATE TABLE `oldlots` (
  `issueID` int unsigned NOT NULL,
  `until` date NOT NULL COMMENT 'first date of new board lot size',
  `lot` int unsigned NOT NULL,
  PRIMARY KEY (`issueID`,`until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Old board lot sizes on HKEX, based on issueID';

CREATE TABLE `oldlsjobs` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `lsppl` int unsigned NOT NULL,
  `empID` int unsigned NOT NULL,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `lsjobs-emps_idx` (`empID`),
  KEY `lsjobs-lsppl_idx` (`lsppl`)
) ENGINE=InnoDB AUTO_INCREMENT=8192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Jobs of Law Society solicitors not in law firms seen prior to renumbering on 2021-07-22. Retained for historical record only.';

CREATE TABLE `oldlsorgs` (
  `lsid` int unsigned NOT NULL,
  `lsename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lscname` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'use as a matching device when a firm name changes',
  `name1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orgType` tinyint unsigned DEFAULT NULL,
  `personID` int unsigned DEFAULT NULL,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`lsid`),
  KEY `lsorgs-orgs_idx` (`personID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Law Society member firms seen prior to renumbering on 2021-07-22. Retained for historical record only.';

CREATE TABLE `oldlsposts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `lsorg` int unsigned NOT NULL,
  `lsppl` int unsigned NOT NULL,
  `post` tinyint unsigned NOT NULL,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `posts-ppl_idx` (`lsppl`),
  KEY `posts-orgs_idx` (`lsorg`)
) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Positions of people in Law Society law firms seen prior to renumbering on 2021-07-22. Retained for historical record only.';

CREATE TABLE `oldlsppl` (
  `lsid` int unsigned NOT NULL,
  `lsename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lscname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admHK` date DEFAULT NULL,
  `admAcc` tinyint DEFAULT NULL,
  `name1` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name2` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `personID` int unsigned DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `firstSeen` datetime DEFAULT NULL,
  `lastSeen` datetime DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`lsid`),
  KEY `lsppl-people_idx` (`personID`),
  KEY `lsppl-name` (`name1`,`name2`,`admHK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Law Society people seen prior to renumbering on 2021-07-22. Retained for historical record only.';

CREATE TABLE `oldsfcids` (
  `SFCID` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SFCri` bit(1) NOT NULL DEFAULT b'0',
  `until` date DEFAULT NULL,
  `orgID` int unsigned NOT NULL,
  PRIMARY KEY (`SFCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Old SFCID of amalgamated company';

CREATE TABLE `olicrec` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `orgID` int unsigned NOT NULL,
  `ri` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether it was a registered institution (true) or licensed corp (false)',
  `actType` tinyint unsigned NOT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `licrecOrgs_idx` (`orgID`),
  KEY `licrecActs_idx` (`actType`),
  CONSTRAINT `olicrec_acts` FOREIGN KEY (`actType`) REFERENCES `activity` (`ID`),
  CONSTRAINT `olicrec_org` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=21352 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='detailed SFC licence records for orgs';

CREATE TABLE `organisations` (
  `PersonID` int unsigned NOT NULL DEFAULT '0',
  `Domicile` smallint unsigned DEFAULT NULL,
  `Name1` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `orgType` tinyint unsigned DEFAULT NULL,
  `SFCID` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `cName` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `SFCupd` datetime DEFAULT NULL,
  `incDate` date DEFAULT NULL,
  `disDate` date DEFAULT NULL,
  `disMode` tinyint unsigned DEFAULT NULL,
  `incAcc` tinyint unsigned DEFAULT NULL,
  `incID` varchar(14) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'incorporation number',
  `incUpd` datetime DEFAULT NULL COMMENT 'last update from place of incorporation',
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  `incName` bit(1) NOT NULL DEFAULT b'0' COMMENT 'true if name history from place of incorporation overrides ICRIS. Use when UK name is out of sync',
  `SFCri` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether the org is a registered institution',
  `UKURI` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether the UK company has been archived to the URI system in Companies House',
  `nameHash` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`PersonID`),
  UNIQUE KEY `Name` (`Name1`),
  UNIQUE KEY `SFCID` (`SFCID`),
  UNIQUE KEY `domincID` (`Domicile`,`incID`),
  KEY `FK_organisations_dom` (`Domicile`),
  KEY `FK_orgs_disMode` (`disMode`),
  KEY `nameHash` (`nameHash`),
  KEY `FK_orgs_orgtype_idx` (`orgType`),
  KEY `disdate_idx` (`disDate`),
  KEY `incDate_idx` (`incDate`),
  FULLTEXT KEY `ftn` (`Name1`),
  CONSTRAINT `FK_organisations_dom` FOREIGN KEY (`Domicile`) REFERENCES `domiciles` (`ID`),
  CONSTRAINT `FK_organisations_persons` FOREIGN KEY (`PersonID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_orgs_disMode` FOREIGN KEY (`disMode`) REFERENCES `dismodes` (`ID`),
  CONSTRAINT `FK_orgs_orgtype` FOREIGN KEY (`orgType`) REFERENCES `orgtypes` (`orgType`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `orgdata` (
  `PersonID` int unsigned NOT NULL DEFAULT '0',
  `YearEndDate` tinyint DEFAULT NULL,
  `YearEndMonth` tinyint DEFAULT NULL,
  `Addr1` varchar(255) DEFAULT NULL,
  `Addr2` varchar(127) DEFAULT NULL,
  `Addr3` varchar(127) DEFAULT NULL,
  `District` varchar(50) DEFAULT NULL,
  `Territory` smallint unsigned DEFAULT NULL,
  `AddrDate` date DEFAULT NULL,
  `Notes` mediumtext,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `D&Afinal` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`PersonID`),
  KEY `FK_orgdata_terr` (`Territory`),
  CONSTRAINT `FK_orgdata_dom` FOREIGN KEY (`Territory`) REFERENCES `domiciles` (`ID`),
  CONSTRAINT `FK_orgdata_orgs` FOREIGN KEY (`PersonID`) REFERENCES `organisations` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `orgtypes` (
  `orgType` tinyint unsigned NOT NULL,
  `typeName` varchar(45) NOT NULL,
  `HKCRname` varchar(45) DEFAULT NULL COMMENT 'name used in HK Companies Registry',
  PRIMARY KEY (`orgType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ownerprof` (
  `orgID` int unsigned NOT NULL,
  `atDate` date NOT NULL,
  `dirStake` double NOT NULL DEFAULT '0',
  `famStake` double NOT NULL DEFAULT '0',
  `amStake` double NOT NULL DEFAULT '0',
  `govStake` double NOT NULL DEFAULT '0',
  `othStake` double NOT NULL DEFAULT '0',
  `OT` tinyint DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`orgID`,`atDate`),
  CONSTRAINT `FKorg` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ownership profile of cos on snapshot dates, by voting rights';

CREATE TABLE `ownerstks` (
  `orgID` int unsigned NOT NULL,
  `atDate` date NOT NULL COMMENT 'the snapshot date (not necessarily the shareholding date which may be earlier)',
  `ultimID` int NOT NULL COMMENT 'the personID of the ultimate controller of this holding',
  `OT` tinyint unsigned NOT NULL COMMENT 'the owner type of the ultimID, relative to the issuer',
  `shares` double unsigned DEFAULT NULL,
  `stake` float unsigned DEFAULT NULL,
  `econShares` double unsigned DEFAULT NULL COMMENT 'the economic interest in shares of the ultimate controller of this holding',
  `econStake` float unsigned DEFAULT NULL,
  `weakest` float unsigned DEFAULT NULL,
  PRIMARY KEY (`orgID`,`atDate`,`ultimID`,`OT`),
  CONSTRAINT `ownerstksOrgs` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Attributed shares and holdings with economic shares and holdings';

CREATE TABLE `ownertype` (
  `ID` tinyint unsigned NOT NULL,
  `ownShort` varchar(2) NOT NULL,
  `ownLong` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Types of shareholders';

CREATE TABLE `pay` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `orgID` int unsigned NOT NULL,
  `pplID` int unsigned NOT NULL,
  `pRank` tinyint unsigned NOT NULL DEFAULT '1',
  `d` date NOT NULL,
  `currID` tinyint unsigned NOT NULL,
  `fees` mediumint DEFAULT NULL,
  `salary` mediumint DEFAULT NULL,
  `bonus` mediumint DEFAULT NULL,
  `retire` mediumint DEFAULT NULL,
  `share` int DEFAULT NULL,
  `total` int DEFAULT NULL,
  `userID` mediumint unsigned NOT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uq` (`orgID`,`pplID`,`pRank`,`d`),
  UNIQUE KEY `uq2` (`pplID`,`orgID`,`pRank`,`d`),
  KEY `payPpl_idx` (`pplID`) /*!80000 INVISIBLE */,
  KEY `payCurr_idx` (`currID`),
  KEY `payUser_idx` (`userID`),
  CONSTRAINT `payCurr` FOREIGN KEY (`currID`) REFERENCES `currencies` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payOrg` FOREIGN KEY (`orgID`) REFERENCES `organisations` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payPpl` FOREIGN KEY (`pplID`) REFERENCES `people` (`PersonID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payUser` FOREIGN KEY (`userID`) REFERENCES `users` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=374289 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `payerrors` (
  `docID` int unsigned NOT NULL,
  `errID` tinyint unsigned NOT NULL,
  `userID` mediumint NOT NULL,
  `reported` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `resolvedBy` mediumint unsigned DEFAULT NULL COMMENT 'userID of editor who cleared the error',
  `resolved` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`docID`,`errID`,`userID`),
  KEY `payErrType_idx` (`errID`),
  CONSTRAINT `payErrType` FOREIGN KEY (`errID`) REFERENCES `payerrtype` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='recording error reports from db editors of the pay table';

CREATE TABLE `payerrtype` (
  `ID` tinyint unsigned NOT NULL,
  `txt` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Types of errors for pay-years in the pay table';

CREATE TABLE `payfx` (
  `d` date NOT NULL,
  `repCurr` tinyint unsigned NOT NULL,
  `dispCurr` tinyint unsigned NOT NULL,
  `f` float unsigned NOT NULL,
  PRIMARY KEY (`d`,`repCurr`,`dispCurr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Precomputed table for FX factors used in the pay displays';

CREATE TABLE `paylineerrors` (
  `payID` int unsigned NOT NULL,
  `errID` tinyint unsigned NOT NULL DEFAULT '6',
  `userID` mediumint unsigned NOT NULL,
  `reported` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolvedBy` mediumint unsigned DEFAULT NULL COMMENT 'userID of editor who cleared the error',
  `resolved` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`payID`,`errID`,`userID`),
  KEY `errType_idx` (`errID`),
  CONSTRAINT `errType` FOREIGN KEY (`errID`) REFERENCES `paylineerrtype` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `pay` FOREIGN KEY (`payID`) REFERENCES `pay` (`ID`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Report errors with individual paylines';

CREATE TABLE `paylineerrtype` (
  `ID` tinyint unsigned NOT NULL,
  `txt` varchar(127) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ord` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Types of errors for paylines in the pay table';

CREATE TABLE `payreview` (
  `docID` int unsigned NOT NULL,
  `userID` mediumint unsigned NOT NULL,
  `submitted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`docID`,`userID`),
  KEY `userIDusers_idx` (`userID`),
  KEY `submitted` (`submitted` DESC),
  CONSTRAINT `docIDdocs` FOREIGN KEY (`docID`) REFERENCES `documents` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `userIDusers` FOREIGN KEY (`userID`) REFERENCES `users` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Log submissions of editors for pay table';

CREATE TABLE `people` (
  `PersonID` int unsigned NOT NULL DEFAULT '0',
  `Sex` varchar(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `YOB` smallint unsigned DEFAULT NULL,
  `MOB` tinyint unsigned DEFAULT NULL,
  `DOB` tinyint unsigned DEFAULT NULL,
  `YOD` smallint unsigned DEFAULT NULL,
  `MonD` tinyint unsigned DEFAULT NULL,
  `DOD` tinyint unsigned DEFAULT NULL,
  `TitleID` tinyint unsigned DEFAULT NULL COMMENT 'We don''t disclose this field on Webb-site but have maintained it internally to help find some individuals more easily when entering data in Access.',
  `Name1` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name2` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `HKID` varchar(8) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'Like all our data, HKIDs are collected from public sources, but we only display them on Webb-site if the HKIDsource column (containing a URL) is not null, and even then only with a "find it yourself" link to the source.',
  `SFCID` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `cName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SFCupd` datetime DEFAULT NULL,
  `SFClastDate` date DEFAULT NULL,
  `HKIDsource` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'URL for ID source',
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  `nameStem` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'used for rapid indexing of combined name1<space>name2 to speed up name lookup boxes in Access. This field is maintained by MySQL triggers.',
  `dn1` varchar(90) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'dn1 and dn2 contain stripped versions of name1 and name 2 without distinguishing extensions. These are used for search purposes such as "Find matching names". These fields are maintained by MySQL triggers.',
  `dn2` varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'dn1 and dn2 contain stripped versions of name1 and name 2 without distinguishing extensions. These are used for search purposes such as "Find matching names". These fields are maintained by MySQL triggers.',
  `dSex` varchar(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  PRIMARY KEY (`PersonID`),
  UNIQUE KEY `Name` (`Name1`,`Name2`),
  UNIQUE KEY `SFCID` (`SFCID`),
  UNIQUE KEY `HKID` (`HKID`),
  KEY `FK_people_titles` (`TitleID`),
  KEY `nameStem` (`nameStem`),
  KEY `dn` (`dn1`,`dn2`),
  KEY `birthday` (`MOB`,`DOB`),
  KEY `bYMD` (`YOB`,`MOB`,`DOB`),
  FULLTEXT KEY `ftdn` (`dn1`,`dn2`),
  FULLTEXT KEY `ftdn1` (`dn1`),
  FULLTEXT KEY `ftdn2` (`dn2`),
  CONSTRAINT `FK_people_persons` FOREIGN KEY (`PersonID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_people_titles` FOREIGN KEY (`TitleID`) REFERENCES `titles` (`TitleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `persons` (
  `PersonID` int unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=34413826 DEFAULT CHARSET=latin1 COMMENT='A unique identifier assigned to either an entity in the organisations table or a human in the people table but not both. The original reason for this is that shareholders can be either people or orgs, and orgs can be directors, so we want to use the personID in the relevant tables.';

CREATE TABLE `personstories` (
  `PersonID` int unsigned NOT NULL,
  `StoryID` mediumint unsigned NOT NULL,
  PRIMARY KEY (`PersonID`,`StoryID`),
  KEY `FK_personstories_1` (`StoryID`),
  CONSTRAINT `FK_personstories_1` FOREIGN KEY (`StoryID`) REFERENCES `stories` (`StoryID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_personstories_persons` FOREIGN KEY (`PersonID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `positions` (
  `positionID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `posShort` varchar(21) NOT NULL,
  `posLong` varchar(70) NOT NULL,
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `rank` tinyint unsigned NOT NULL,
  `LSrole` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`positionID`),
  KEY `FK_positions_status` (`status`),
  KEY `FK_positions_rank` (`rank`),
  CONSTRAINT `FK_positions_rank` FOREIGN KEY (`rank`) REFERENCES `rank` (`rankID`),
  CONSTRAINT `FK_positions_status` FOREIGN KEY (`status`) REFERENCES `status` (`statusID`)
) ENGINE=InnoDB AUTO_INCREMENT=728 DEFAULT CHARSET=latin1;

CREATE TABLE `prhblock` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `en` varchar(127) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cn` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estateID` smallint unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `est_block` (`estateID`,`en`),
  KEY `prhblock_estate_idx` (`estateID`),
  CONSTRAINT `prhblock_estate` FOREIGN KEY (`estateID`) REFERENCES `prhestate` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1662 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blocks in HA Public Rental Housing estates';

CREATE TABLE `prhestate` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `en` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'English name',
  `cn` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Chinese name',
  `district` tinyint unsigned NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `en_UNIQUE` (`en`),
  KEY `estate_district_idx` (`district`),
  CONSTRAINT `estate_district` FOREIGN KEY (`district`) REFERENCES `hkdistrict` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Housing Authority Public Rental Housing Estates';

CREATE TABLE `prhflat` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `blockID` int unsigned NOT NULL,
  `floor` varchar(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `flat` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `area` float unsigned NOT NULL DEFAULT '0' COMMENT 'internal floor area',
  `elevator` bit(1) NOT NULL DEFAULT b'1',
  `firstSeen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastSeen` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `block_flat` (`blockID`,`flat`),
  KEY `blockID_prhblock_idx` (`blockID`),
  CONSTRAINT `blockID_prhblock` FOREIGN KEY (`blockID`) REFERENCES `prhblock` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1011584 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `prisoners` (
  `jail` tinyint unsigned NOT NULL,
  `d` date NOT NULL,
  `convict` smallint unsigned NOT NULL,
  `remand` smallint unsigned NOT NULL,
  `detain` smallint unsigned NOT NULL,
  PRIMARY KEY (`jail`,`d`),
  CONSTRAINT `prisoners_jail` FOREIGN KEY (`jail`) REFERENCES `jails` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `prisorigin` (
  `d` date NOT NULL,
  `local` mediumint unsigned DEFAULT NULL COMMENT 'Persons holding HK Identity Card but excluding imported labour, foreign domestic helpers and consulate staff.',
  `MTM` mediumint unsigned DEFAULT NULL COMMENT 'Mainland Taiwan Macau',
  `nonlocal` mediumint unsigned DEFAULT NULL,
  PRIMARY KEY (`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='prisoners by origin';

CREATE TABLE `ptoperators` (
  `ID` tinyint unsigned NOT NULL,
  `TDabbrev` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `orgID` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Public Transport Operators';

CREATE TABLE `qt` (
  `qtID` tinyint unsigned NOT NULL,
  `d` date NOT NULL,
  `capUnit` smallint unsigned DEFAULT NULL,
  `useUnit` smallint unsigned DEFAULT NULL,
  `pax` smallint unsigned DEFAULT NULL,
  `availUnit` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`qtID`,`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quarantine centre data';

CREATE TABLE `qtbytype` (
  `d` date NOT NULL,
  `cumCC` mediumint unsigned NOT NULL COMMENT 'Cumulative Close Contacts',
  `cumNCC` mediumint unsigned NOT NULL COMMENT 'Cumulative Non-Close Contacts',
  `CC` smallint unsigned NOT NULL COMMENT 'Close Contacts',
  `NCC` smallint unsigned NOT NULL COMMENT 'Non-Close Contacts',
  PRIMARY KEY (`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='People in govt quarantine centres';

CREATE TABLE `qtcentres` (
  `ID` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Quarantine centres';

CREATE TABLE `rank` (
  `rankID` tinyint unsigned NOT NULL DEFAULT '0',
  `rankText` varchar(50) NOT NULL,
  `rankShort` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`rankID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `relationships` (
  `ID` tinyint unsigned NOT NULL DEFAULT '0',
  `relation` varchar(20) NOT NULL,
  `invRel` varchar(20) NOT NULL,
  `level` tinyint NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `relatives` (
  `Rel1` int unsigned NOT NULL,
  `RelID` tinyint unsigned NOT NULL DEFAULT '0',
  `Rel2` int unsigned NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Rel1`,`Rel2`),
  KEY `FK_relatives_relationships` (`RelID`),
  KEY `FK_rel2_people` (`Rel2`),
  CONSTRAINT `FK_relatives_Rel1` FOREIGN KEY (`Rel1`) REFERENCES `people` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_relatives_Rel2` FOREIGN KEY (`Rel2`) REFERENCES `people` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_relatives_relID` FOREIGN KEY (`RelID`) REFERENCES `relationships` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reorg` (
  `fromOrg` int unsigned NOT NULL,
  `toOrg` int unsigned NOT NULL,
  `effDate` date DEFAULT NULL,
  `effAcc` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`fromOrg`,`toOrg`) USING BTREE,
  KEY `FK_toOrg` (`toOrg`),
  CONSTRAINT `FK_fromOrg` FOREIGN KEY (`fromOrg`) REFERENCES `organisations` (`PersonID`),
  CONSTRAINT `FK_toOrg` FOREIGN KEY (`toOrg`) REFERENCES `organisations` (`PersonID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `repdocs` (
  `repID` mediumint unsigned NOT NULL,
  `file` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `docName` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`repID`,`file`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Document list from multi-file documents on display';

CREATE TABLE `repfilings` (
  `ID` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `repFiled` datetime NOT NULL,
  `URL` varchar(255) NOT NULL,
  `descrip` varchar(511) NOT NULL,
  `descrip2` varchar(511) DEFAULT NULL,
  `docType` tinyint unsigned DEFAULT NULL,
  `fsize` mediumint unsigned DEFAULT NULL COMMENT 'file size in KB',
  `newsID` int unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `newsID` (`newsID`),
  KEY `URL` (`URL`)
) ENGINE=InnoDB AUTO_INCREMENT=159542 DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `RoleID` tinyint NOT NULL,
  `Role` varchar(30) DEFAULT NULL,
  `OneTime` bit(1) DEFAULT b'0',
  `roleLong` varchar(45) NOT NULL,
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sdi` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `form` tinyint NOT NULL,
  `filing` int DEFAULT NULL,
  `name1` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `name2` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `cName` varchar(40) DEFAULT NULL,
  `ccc` varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `stockCode` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `stockName` varchar(255) DEFAULT NULL,
  `relDate` date DEFAULT NULL,
  `awDate` date DEFAULT NULL,
  `issueID` mediumint unsigned DEFAULT NULL,
  `dir` int unsigned DEFAULT NULL,
  `longShs1` double DEFAULT NULL,
  `longStk1` float DEFAULT NULL,
  `shortShs1` double DEFAULT NULL,
  `shortStk1` float DEFAULT NULL,
  `longShs2` double DEFAULT NULL,
  `longStk2` float DEFAULT NULL,
  `shortShs2` double DEFAULT NULL,
  `shortStk2` float DEFAULT NULL,
  `shsOut` double DEFAULT NULL,
  `signDate` date DEFAULT NULL,
  `curr` tinyint unsigned DEFAULT NULL,
  `hiPrice` float DEFAULT NULL,
  `avPrice` float DEFAULT NULL,
  `avCon` float DEFAULT NULL,
  `conCode` tinyint unsigned DEFAULT NULL,
  `serNo` char(16) DEFAULT NULL,
  `serNoAmend` char(16) DEFAULT NULL COMMENT 'this filing replaces the filing with this serial number',
  `serNoSuper` char(16) DEFAULT NULL COMMENT 'this filing is superseded by filing number serNoSuper',
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `formFiling` (`form`,`filing`),
  UNIQUE KEY `serNo_UNIQUE` (`serNo`),
  KEY `sdi_people_idx` (`dir`),
  KEY `nameIndex` (`name1`,`name2`),
  KEY `cName_idx` (`cName`),
  KEY `sdi_currency_idx` (`curr`),
  KEY `relDate` (`relDate`),
  KEY `sdi_issue_idx` (`issueID`),
  CONSTRAINT `sdi_currency` FOREIGN KEY (`curr`) REFERENCES `currencies` (`ID`),
  CONSTRAINT `sdi_issue` FOREIGN KEY (`issueID`) REFERENCES `issue` (`ID1`),
  CONSTRAINT `sdi_persons` FOREIGN KEY (`dir`) REFERENCES `persons` (`PersonID`)
) ENGINE=InnoDB AUTO_INCREMENT=341150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sdicap` (
  `sdiID` int unsigned NOT NULL COMMENT 'ID of sdi table',
  `capID` smallint unsigned NOT NULL,
  `posType` tinyint unsigned NOT NULL,
  `shares` double NOT NULL,
  PRIMARY KEY (`sdiID`,`capID`,`posType`),
  KEY `sdicap_capacity_idx` (`capID`),
  CONSTRAINT `sdicap_capacity` FOREIGN KEY (`capID`) REFERENCES `capacity` (`ID`),
  CONSTRAINT `sdicap_sdi` FOREIGN KEY (`sdiID`) REFERENCES `sdi` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='box 16 (director) or 20 (substantial) of SDI forms - capacity in which interests are held';

CREATE TABLE `sdievent` (
  `sdiID` int unsigned NOT NULL,
  `posType` tinyint NOT NULL,
  `reason` smallint unsigned DEFAULT NULL,
  `capBefore` smallint unsigned DEFAULT NULL,
  `capAfter` smallint unsigned DEFAULT NULL,
  `shsInv` double DEFAULT NULL,
  `probReason` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`sdiID`,`posType`),
  KEY `reason_idx` (`reason`),
  KEY `capbefore_cap_idx` (`capBefore`),
  KEY `capafter_cap_idx` (`capAfter`),
  CONSTRAINT `capafter_cap` FOREIGN KEY (`capAfter`) REFERENCES `capacity` (`ID`),
  CONSTRAINT `capbefore_cap` FOREIGN KEY (`capBefore`) REFERENCES `capacity` (`ID`),
  CONSTRAINT `reason` FOREIGN KEY (`reason`) REFERENCES `sdireason` (`ID`),
  CONSTRAINT `sdievent_sdi` FOREIGN KEY (`sdiID`) REFERENCES `sdi` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='from box 14 on form 3A';

CREATE TABLE `sdireason` (
  `ID` smallint unsigned NOT NULL,
  `rsnSht` varchar(12) NOT NULL,
  `rsnLng` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sectypes` (
  `typeID` tinyint unsigned NOT NULL,
  `typeShort` varchar(8) NOT NULL,
  `typeLong` varchar(45) NOT NULL,
  `listOrd` tinyint unsigned NOT NULL,
  `canExpire` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`typeID`),
  UNIQUE KEY `typeShort` (`typeShort`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sfcnews` (
  `StoryID` mediumint NOT NULL,
  `titleEN` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `htmlEN` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `issueDate` datetime NOT NULL,
  `modTime` datetime NOT NULL,
  `titleTC` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `htmlTC` text COLLATE utf8mb4_unicode_ci,
  `SDA` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'filename of the statement of disciplinary action stored in codocs folder',
  PRIMARY KEY (`StoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `sfcshort` (
  `issueID` int NOT NULL,
  `atDate` date NOT NULL,
  `stockCode` mediumint unsigned NOT NULL,
  `stockName` varchar(20) NOT NULL,
  `shares` double NOT NULL,
  `value` double NOT NULL,
  PRIMARY KEY (`issueID`,`atDate`),
  UNIQUE KEY `dateIssue` (`atDate`,`issueID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sholdings` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `holderID` int unsigned NOT NULL DEFAULT '0',
  `issueID` mediumint unsigned NOT NULL DEFAULT '0',
  `atDate` date DEFAULT NULL,
  `shares` double unsigned DEFAULT NULL,
  `stake` float DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userID` mediumint unsigned NOT NULL DEFAULT '0',
  `heldAs` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `quad` (`issueID`,`holderID`,`atDate`,`heldAs`),
  KEY `sholders_holder_idx` (`holderID`),
  KEY `sholders_issue_idx` (`issueID`),
  CONSTRAINT `sholders_holder` FOREIGN KEY (`holderID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `sholders_issue` FOREIGN KEY (`issueID`) REFERENCES `issue` (`ID1`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=172593 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `snaplog` (
  `orgID` int unsigned NOT NULL,
  `snapDate` date NOT NULL,
  `userID` mediumint unsigned NOT NULL,
  `project` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '0=holdings, 1=committees',
  `status` bit(1) NOT NULL DEFAULT b'0',
  `done` bit(1) NOT NULL DEFAULT b'0',
  `entered` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `notes` text,
  PRIMARY KEY (`orgID`,`snapDate`,`userID`,`project`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `sources` (
  `sourceID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `sourceName` varchar(255) NOT NULL,
  PRIMARY KEY (`sourceID`),
  UNIQUE KEY `sourceName` (`sourceName`)
) ENGINE=InnoDB AUTO_INCREMENT=288 DEFAULT CHARSET=latin1;

CREATE TABLE `statgov` (
  `descrip` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `statsID` smallint unsigned NOT NULL,
  PRIMARY KEY (`descrip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `stats` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `statName` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Statistics with our name for them',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `status` (
  `statusID` tinyint unsigned NOT NULL DEFAULT '0',
  `statusText` varchar(50) NOT NULL,
  PRIMARY KEY (`statusID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `stocklistings` (
  `IssueID` mediumint unsigned NOT NULL DEFAULT '0',
  `StockCode` varchar(8) DEFAULT NULL,
  `StockExID` tinyint unsigned NOT NULL,
  `FirstTradeDate` date DEFAULT NULL,
  `FinalTradeDate` date DEFAULT NULL,
  `DelistDate` date DEFAULT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ReasonID` tinyint unsigned DEFAULT NULL,
  `2ndCtr` bit(1) NOT NULL DEFAULT b'0' COMMENT '2nd counter: if true, this issue should be ignored when looking for total returns for directors, advisers',
  `sedol` varchar(7) DEFAULT NULL,
  `isin` varchar(12) DEFAULT NULL,
  `stockId` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_stocklistings_listing` (`StockExID`),
  KEY `FK_stocklistings_dlreason` (`ReasonID`),
  KEY `stocklistings_issue_idx` (`IssueID`),
  CONSTRAINT `FK_stocklistings_dlreason` FOREIGN KEY (`ReasonID`) REFERENCES `dlreasons` (`ReasonID`),
  CONSTRAINT `FK_stocklistings_listing` FOREIGN KEY (`StockExID`) REFERENCES `listings` (`stockExID`),
  CONSTRAINT `stocklistings_issue` FOREIGN KEY (`IssueID`) REFERENCES `issue` (`ID1`)
) ENGINE=InnoDB AUTO_INCREMENT=16791 DEFAULT CHARSET=latin1;

CREATE TABLE `stories` (
  `StoryID` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `StoryDate` datetime DEFAULT NULL,
  `URL` varchar(255) NOT NULL,
  `SourceID` smallint unsigned DEFAULT NULL,
  `URL2` varchar(255) DEFAULT NULL,
  `URL2text` varchar(255) DEFAULT NULL,
  `pubDate` datetime NOT NULL,
  `tweeted` datetime DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`StoryID`) USING BTREE,
  UNIQUE KEY `URL` (`URL`),
  KEY `FK_stories_source` (`SourceID`),
  KEY `index_StoryDate` (`StoryDate`),
  CONSTRAINT `FK_stories_source` FOREIGN KEY (`SourceID`) REFERENCES `sources` (`sourceID`)
) ENGINE=InnoDB AUTO_INCREMENT=15820 DEFAULT CHARSET=latin1;

CREATE TABLE `storytags` (
  `storyID` mediumint unsigned NOT NULL,
  `catID` smallint unsigned NOT NULL,
  PRIMARY KEY (`storyID`,`catID`),
  KEY `FK_storytags_cats_idx` (`catID`),
  CONSTRAINT `FK_storytags_cats` FOREIGN KEY (`catID`) REFERENCES `categories` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_storytags_stories` FOREIGN KEY (`storyID`) REFERENCES `stories` (`StoryID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tdjourneys` (
  `d` date NOT NULL,
  `vc` tinyint unsigned NOT NULL,
  `j` int unsigned DEFAULT NULL,
  `km` int unsigned DEFAULT NULL,
  `kmCH` int unsigned DEFAULT NULL,
  `paxcap` mediumint unsigned DEFAULT NULL,
  `provJ` bit(1) NOT NULL DEFAULT b'0',
  `provkm` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`d`,`vc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tdreglic` (
  `d` date NOT NULL,
  `vc` tinyint NOT NULL,
  `FR` smallint unsigned NOT NULL DEFAULT '0',
  `totReg` mediumint unsigned NOT NULL DEFAULT '0',
  `totLic` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`d`,`vc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Transport Dept  monthly first registration and total registration and licences by vehicle class from Table 4.1(a)';

CREATE TABLE `tempsfc` (
  `orgID` int unsigned NOT NULL,
  `started` date DEFAULT NULL,
  `ended` date DEFAULT NULL,
  `role` tinyint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `titles` (
  `TitleID` tinyint unsigned NOT NULL,
  `Title` varchar(30) NOT NULL,
  `Sex` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`TitleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tundir` (
  `ID` tinyint unsigned NOT NULL,
  `defdir` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `altdir` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `defTD` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `altTD` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tunnel directions .Each tunnel, bridge or crossing can be East-West, North-South, or In/Out. Record in tunnel table';

CREATE TABLE `tunnels` (
  `ID` tinyint unsigned NOT NULL,
  `TD` varchar(6) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'TUN_BRIDGE_CODE in TD files',
  `name` varchar(37) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tundirID` tinyint unsigned NOT NULL COMMENT 'The pair of tunnel directions in the tundir table',
  `TDtable` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `opened` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tunnel IDs and codes for Transport Dept Tables 3.1';

CREATE TABLE `tuntraff` (
  `tunID` tinyint unsigned NOT NULL,
  `vc` tinyint unsigned NOT NULL,
  `d` date NOT NULL,
  `defcnt` mediumint unsigned NOT NULL DEFAULT '0',
  `altcnt` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`tunID`,`vc`,`d`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Traffic via tunnels & bridges from TD tables 3.1, 3.2';

CREATE TABLE `ukappres` (
  `orgID` int unsigned NOT NULL,
  `CHID` varchar(27) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `appDate` date NOT NULL,
  `resDate` date NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`orgID`,`CHID`,`appDate`,`resDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='UK appointments where the resignation is before the appointment';

CREATE TABLE `ukch` (
  `UKtype` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `api` varchar(127) NOT NULL,
  `meaning` varchar(255) DEFAULT NULL,
  `orgType` tinyint unsigned NOT NULL,
  PRIMARY KEY (`UKtype`),
  UNIQUE KEY `api_UNIQUE` (`api`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ukchnats` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `descrip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `domicile` smallint unsigned DEFAULT NULL COMMENT 'nationalities found in UKCH people. Map to domiciles.',
  `UKlist` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `descrip_UNIQUE` (`descrip`)
) ENGINE=InnoDB AUTO_INCREMENT=15264 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ukhons` (
  `ukhons` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ukhons`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Suffixes used in UKCH honours';

CREATE TABLE `uklog` (
  `prefix` char(2) NOT NULL DEFAULT '',
  `lastCo` int unsigned DEFAULT NULL,
  `domID` smallint unsigned NOT NULL,
  `lastCoAdded` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `uknonhuman` (
  `CHID` varchar(27) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CHID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ukppl` (
  `CHID` varchar(27) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `personID` int unsigned NOT NULL,
  PRIMARY KEY (`CHID`),
  KEY `ukppl-people_idx` (`personID`),
  CONSTRAINT `ukppl-people` FOREIGN KEY (`personID`) REFERENCES `people` (`PersonID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='People in UK Companies House';

CREATE TABLE `users` (
  `ID` mediumint unsigned NOT NULL,
  `name` varchar(15) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `userName_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `vax` (
  `d` date NOT NULL,
  `cohort` tinyint unsigned NOT NULL,
  `male` bit(1) NOT NULL,
  `prov` bit(1) NOT NULL DEFAULT b'0',
  `sino1` smallint unsigned NOT NULL DEFAULT '0',
  `sino2` smallint unsigned NOT NULL DEFAULT '0',
  `sino3` smallint unsigned NOT NULL DEFAULT '0',
  `sino4` smallint unsigned NOT NULL DEFAULT '0',
  `sino5` smallint unsigned NOT NULL DEFAULT '0',
  `sino6` smallint unsigned NOT NULL DEFAULT '0',
  `sino7` smallint unsigned NOT NULL DEFAULT '0',
  `sino8` smallint unsigned NOT NULL DEFAULT '0',
  `sino9` smallint unsigned NOT NULL DEFAULT '0',
  `sino10` smallint unsigned NOT NULL DEFAULT '0',
  `bion1` smallint unsigned NOT NULL DEFAULT '0',
  `bion2` smallint unsigned NOT NULL DEFAULT '0',
  `bion3` smallint unsigned NOT NULL DEFAULT '0',
  `bion4` smallint unsigned NOT NULL DEFAULT '0',
  `bion5` smallint unsigned NOT NULL DEFAULT '0',
  `bion6` smallint unsigned NOT NULL DEFAULT '0',
  `bion7` smallint unsigned NOT NULL DEFAULT '0',
  `bion8` smallint unsigned NOT NULL DEFAULT '0',
  `bion9` smallint unsigned NOT NULL DEFAULT '0',
  `bion10` smallint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`d`,`cohort`,`male`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vaccination data for COVID-19';

CREATE TABLE `vaxcohorts` (
  `ID` tinyint unsigned NOT NULL,
  `txt` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `govtxt` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `minAge` tinyint unsigned NOT NULL,
  `popn` mediumint unsigned NOT NULL,
  `mpopn` mediumint unsigned NOT NULL,
  `fpopn` mediumint unsigned NOT NULL,
  `sino1` mediumint unsigned NOT NULL COMMENT 'The latest cumulative total sinovac dose 1  shown on the govt dashboard by age and extracted from barAge.csv',
  `sino2` mediumint unsigned NOT NULL,
  `sino3` mediumint unsigned NOT NULL,
  `bion1` mediumint unsigned NOT NULL,
  `bion2` mediumint unsigned NOT NULL,
  `bion3` mediumint unsigned NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='HK vaccination data age groups';

CREATE TABLE `veengine` (
  `d` date NOT NULL,
  `engID` tinyint unsigned NOT NULL,
  `FR` smallint unsigned NOT NULL,
  `totReg` mediumint unsigned NOT NULL,
  PRIMARY KEY (`d`,`engID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Private cars by engine size from TD table 4.2';

CREATE TABLE `vehicleclass` (
  `ID` tinyint unsigned NOT NULL,
  `parent` tinyint unsigned DEFAULT NULL,
  `fuelparent` tinyint DEFAULT NULL COMMENT 'For table 4.4 which groups some lines together',
  `jparent` tinyint unsigned DEFAULT NULL,
  `des` varchar(255) CHARACTER SET latin1 NOT NULL,
  `govType` varchar(45) DEFAULT NULL,
  `operator` tinyint unsigned DEFAULT NULL,
  `DD` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Double-decker',
  `franchise` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `vehiclefr` (
  `vc` tinyint unsigned NOT NULL,
  `d` date NOT NULL,
  `makeID` smallint unsigned NOT NULL,
  `fuelID` tinyint unsigned NOT NULL,
  `bodyID` tinyint unsigned NOT NULL,
  `FRstatID` tinyint unsigned NOT NULL,
  `Freg` smallint unsigned NOT NULL,
  PRIMARY KEY (`vc`,`d`,`makeID`,`fuelID`,`bodyID`,`FRstatID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='First Registrations of private cars by make etc from TD table 4.1(e)';

CREATE TABLE `vehiclefuel` (
  `d` date NOT NULL,
  `vc` tinyint unsigned NOT NULL,
  `fuelID` tinyint unsigned NOT NULL,
  `totReg` mediumint unsigned NOT NULL,
  `totLic` mediumint unsigned NOT NULL,
  PRIMARY KEY (`d`,`vc`,`fuelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='For Transport Dept table 4.4';

CREATE TABLE `vehiclemakes` (
  `ID` smallint unsigned NOT NULL AUTO_INCREMENT,
  `make` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=282 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Makes of car as listed in TD table 4.1(e)';

CREATE TABLE `vehicletypos` (
  `wrong` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correct` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`wrong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Correction table for TD vehicle brands';

CREATE TABLE `web` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `PersonID` int unsigned NOT NULL,
  `URL` varchar(255) NOT NULL,
  `source` smallint unsigned DEFAULT NULL,
  `dead` bit(1) DEFAULT b'0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique` (`PersonID`,`URL`),
  KEY `FK_web_persons` (`PersonID`) /*!80000 INVISIBLE */,
  KEY `web_sources_idx` (`source`),
  CONSTRAINT `FK_web_persons` FOREIGN KEY (`PersonID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `web_sources` FOREIGN KEY (`source`) REFERENCES `sources` (`sourceID`)
) ENGINE=InnoDB AUTO_INCREMENT=18232 DEFAULT CHARSET=latin1;

CREATE TABLE `webbhold` (
  `issueID` mediumint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `shares` int unsigned NOT NULL,
  `stake` float unsigned NOT NULL,
  `filing` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`issueID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wsprivs` (
  `userID` mediumint unsigned NOT NULL,
  `roleID` tinyint unsigned NOT NULL,
  `uRank` tinyint unsigned NOT NULL DEFAULT '1',
  `live` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`userID`,`roleID`),
  KEY `privs_roles_idx` (`roleID`),
  CONSTRAINT `privs_roles` FOREIGN KEY (`roleID`) REFERENCES `wsroles` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `privs_users` FOREIGN KEY (`userID`) REFERENCES `users` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Roles of each user and their ranking in that role';

CREATE TABLE `wsroles` (
  `ID` tinyint unsigned NOT NULL,
  `MSuser` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cred` blob,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='roles for editors working on various pages';

CREATE TABLE `wsroletabs` (
  `roleID` tinyint unsigned NOT NULL,
  `tblname` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`roleID`,`tblname`),
  CONSTRAINT `roletabs_roles` FOREIGN KEY (`roleID`) REFERENCES `wsroles` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tables which a wsrole can insert, update, delete. Maximum one role per table.';

