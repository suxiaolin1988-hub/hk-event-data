CREATE TABLE `bigchanges` (
  `atDate` date NOT NULL,
  `issueID` mediumint unsigned NOT NULL,
  `partID` smallint unsigned NOT NULL,
  `stkchg` float DEFAULT NULL,
  `prevDate` date DEFAULT NULL,
  PRIMARY KEY (`atDate`,`issueID`,`partID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `calendar` (
  `tradeDate` date NOT NULL,
  `settleDate` date NOT NULL,
  `deferred` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Settlement date shared with the next trading day due to Xmas/NY/CNY eve having no settlement and half-day trading.',
  PRIMARY KEY (`tradeDate`),
  KEY `settleDate` (`settleDate`,`tradeDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='the HK settlement calendar, after adjustment for typhoons, public holidays etc';

CREATE TABLE `dailylog` (
  `atDate` date NOT NULL,
  `issueID` mediumint unsigned NOT NULL,
  `intermedHldg` bigint unsigned NOT NULL DEFAULT '0',
  `intermedCnt` smallint unsigned NOT NULL DEFAULT '0',
  `NCIPhldg` bigint unsigned NOT NULL DEFAULT '0',
  `NCIPcnt` smallint unsigned NOT NULL DEFAULT '0',
  `CIPhldg` bigint unsigned NOT NULL DEFAULT '0',
  `CIPcnt` smallint unsigned NOT NULL DEFAULT '0',
  `c5` bigint unsigned NOT NULL DEFAULT '0',
  `c10` bigint unsigned NOT NULL DEFAULT '0',
  `CustHldg` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Custodian holdings',
  `BrokHldg` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'Broker holdings',
  PRIMARY KEY (`issueID`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `holdings` (
  `partID` smallint unsigned NOT NULL,
  `issueID` mediumint unsigned NOT NULL,
  `holding` bigint NOT NULL,
  `atDate` date NOT NULL,
  PRIMARY KEY (`issueID`,`partID`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `missing` (
  `atDate` date NOT NULL,
  `issueID` mediumint unsigned NOT NULL,
  `stockCode` mediumint unsigned NOT NULL,
  PRIMARY KEY (`atDate`,`issueID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Missing records from daily CCASS run';

CREATE TABLE `oldnames` (
  `oldNameID` int unsigned NOT NULL AUTO_INCREMENT,
  `oldName` varchar(255) NOT NULL,
  `dateChanged` date NOT NULL,
  `partID` smallint unsigned NOT NULL,
  PRIMARY KEY (`oldNameID`),
  KEY `FK_oldnames_Part` (`partID`),
  CONSTRAINT `FK_oldnames_Part` FOREIGN KEY (`partID`) REFERENCES `participants` (`partID`)
) ENGINE=InnoDB AUTO_INCREMENT=908 DEFAULT CHARSET=latin1;

CREATE TABLE `parthold` (
  `partID` smallint unsigned NOT NULL,
  `issueID` mediumint unsigned NOT NULL,
  `holding` bigint NOT NULL,
  `atDate` date NOT NULL,
  PRIMARY KEY (`partID`,`issueID`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `participants` (
  `partID` smallint unsigned NOT NULL AUTO_INCREMENT COMMENT 'The Webb-site participant ID for this CCASS Participant',
  `CCASSID` varchar(6) DEFAULT NULL,
  `partName` varchar(255) NOT NULL COMMENT 'The current name of this CCASS Participant as shown on the CCASS pages. Not necessarily the full legal name.',
  `atDate` date NOT NULL,
  `addedDate` date DEFAULT NULL,
  `personID` int unsigned DEFAULT NULL,
  `hadHoldings` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`partID`) USING BTREE,
  KEY `CCASSID` (`CCASSID`),
  KEY `partName` (`partName`)
) ENGINE=InnoDB AUTO_INCREMENT=1747 DEFAULT CHARSET=latin1;

CREATE TABLE `pquotes` (
  `issueID` mediumint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `prevClose` float unsigned NOT NULL DEFAULT '0',
  `closing` float unsigned NOT NULL DEFAULT '0',
  `ask` float unsigned NOT NULL DEFAULT '0',
  `bid` float unsigned NOT NULL DEFAULT '0',
  `high` float unsigned NOT NULL DEFAULT '0',
  `low` float unsigned NOT NULL DEFAULT '0',
  `vol` bigint unsigned NOT NULL DEFAULT '0',
  `turn` bigint unsigned NOT NULL DEFAULT '0',
  `susp` bit(1) NOT NULL DEFAULT b'0',
  `newsusp` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Whether the stock was newly suspended today. This includes an all-day or part-day suspension in effect at the market close.',
  `noclose` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`issueID`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='quotes for parallel-trading counters on SEHK';

CREATE TABLE `quotes` (
  `issueID` mediumint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `prevClose` float unsigned DEFAULT '0',
  `closing` float unsigned NOT NULL DEFAULT '0',
  `ask` float unsigned NOT NULL DEFAULT '0',
  `bid` float unsigned NOT NULL DEFAULT '0',
  `high` float unsigned NOT NULL DEFAULT '0',
  `low` float unsigned NOT NULL DEFAULT '0',
  `vol` bigint unsigned NOT NULL DEFAULT '0',
  `turn` bigint unsigned NOT NULL DEFAULT '0',
  `susp` bit(1) NOT NULL DEFAULT b'0',
  `newsusp` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Whether the stock was newly suspended today. This includes an all-day or part-day suspension in effect at the market close.',
  `noclose` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Indicates no meaningful closing price.For dates up to 30-Jan-2004 (quotes from SEHK CDs): the stock was suspended all day, so the closing price is not meaningful. For dates after 30-Jan-2004: the closing price is zero because the stock was suspended all day.',
  PRIMARY KEY (`issueID`,`atDate`) USING BTREE,
  UNIQUE KEY `nozero` (`issueID`,`noclose`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sehkmonthend` (
  `monthEnd` date NOT NULL,
  PRIMARY KEY (`monthEnd`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `shortnames` (
  `issueID` mediumint unsigned DEFAULT NULL,
  `shortName` varchar(45) NOT NULL,
  `fromDate` date NOT NULL,
  `toDate` date DEFAULT NULL,
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `stockCode` varchar(5) DEFAULT NULL,
  `useDate` date NOT NULL,
  `stockExID` tinyint unsigned NOT NULL,
  `parallel` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `nameindex` (`shortName`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46464 DEFAULT CHARSET=latin1;

CREATE TABLE `specialdays` (
  `specialDate` date NOT NULL,
  `pubHol` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether this is a public holiday',
  `partSess` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether there was a partial session of trading with late start or early termination of AM or PM session due to weather',
  `noAM` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether the HK market was shut for the morning session',
  `noPM` bit(1) NOT NULL DEFAULT b'0' COMMENT 'whether the market was shut for the afternoon session',
  `noSettle` bit(1) NOT NULL DEFAULT b'0' COMMENT 'for non-holidays, whether there is no settlement today (for example, on Xmas or NY eve with no PM session)',
  PRIMARY KEY (`specialDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='General holidays, typhoon days etc. Used to generate the calendar entries for HK settlement. Excludes weekends.';

CREATE TABLE `unquotes` (
  `stockCode` mediumint unsigned NOT NULL,
  `atDate` date NOT NULL,
  `prevClose` float unsigned DEFAULT '0',
  `closing` float unsigned NOT NULL DEFAULT '0',
  `ask` float unsigned NOT NULL DEFAULT '0',
  `bid` float unsigned NOT NULL DEFAULT '0',
  `high` float unsigned NOT NULL DEFAULT '0',
  `low` float unsigned NOT NULL DEFAULT '0',
  `vol` bigint unsigned NOT NULL DEFAULT '0',
  `turn` bigint unsigned NOT NULL DEFAULT '0',
  `susp` bit(1) NOT NULL DEFAULT b'0',
  `newsusp` bit(1) NOT NULL DEFAULT b'0' COMMENT 'The stock was newly suspended today. This includes an all-day or part-day suspension in effect at the market close.',
  `noclose` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Indicates no meaningful closing price.\nFor dates up to 30-Jan-2004 (quotes from SEHK CDs): the stock was suspended all day, so the closing price is not meaningful\nFor dates after 30-Jan-2004: the closing price is zero because the stock was suspended all day',
  PRIMARY KEY (`stockCode`,`atDate`) USING BTREE,
  UNIQUE KEY `nozero` (`stockCode`,`noclose`,`atDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

