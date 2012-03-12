-- MySQL dump 10.13  Distrib 5.1.61, for apple-darwin10.3.0 (i386)
--
-- Host: localhost    Database: cbcl_production
-- ------------------------------------------------------
-- Server version	5.5.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_group_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `short_name` varchar(255) DEFAULT NULL,
  `sum` int(11) DEFAULT NULL,
  `scale` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `score_scale_id` int(11) DEFAULT NULL,
  `items_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `variable` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_scores_surveys` (`survey_id`),
  KEY `fk_scores_score_groups` (`score_group_id`),
  CONSTRAINT `fk_scores_score_groups` FOREIGN KEY (`score_group_id`) REFERENCES `score_groups` (`id`),
  CONSTRAINT `fk_scores_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores`
--

LOCK TABLES `scores` WRITE;
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
INSERT INTO `scores` VALUES (1,1,1,'Total problem score','CBCL',1,0,1,1,100,'2010-01-05 14:12:47','2012-03-12 19:49:05','cctotal'),(2,1,2,'Eksternalisering','CBCL',1,0,2,1,35,'2010-01-05 14:12:47','2012-03-12 19:49:27','ccyekste'),(3,1,2,'Internalisering','CBCL',1,0,3,1,32,'2010-01-05 14:12:47','2012-03-12 19:50:03','ccyinter'),(23,1,5,'Total Problem Score','YSR',1,0,1,1,105,'2010-01-05 14:12:47','2012-03-12 19:49:05','ycytotal'),(24,1,5,'Eksternalisering','YSR',1,0,2,1,32,'2010-01-05 14:12:47','2012-03-12 19:49:27','ycyekste'),(25,1,5,'Internalisering','YSR',1,0,3,1,31,'2010-01-05 14:12:47','2012-03-12 19:50:03','ycyinter'),(26,1,4,'Total Problem Score','TRF',1,0,1,1,119,'2010-01-05 14:12:47','2012-03-12 19:49:05','tttotal'),(27,1,4,'Eksternalisering','TRF',1,0,2,1,34,'2010-01-05 14:12:47','2012-03-12 19:49:27','ttekste'),(28,1,4,'Internalisering','TRF',1,0,3,1,32,'2010-01-05 14:12:47','2012-03-12 19:50:03','ttinter'),(30,1,1,'Angst problemer','CBCL',1,0,2,3,10,'2010-01-05 14:12:47','2012-03-12 19:50:12','ccangst'),(31,1,1,'Affektive problemer','CBCL',1,3,1,3,10,'2010-01-05 14:12:47','2012-03-12 19:50:28','ccaffek'),(35,1,1,'Gennemgribende udv.forst.probl.','CBCL',1,0,4,3,13,'2010-01-05 14:12:47','2012-03-12 19:53:01','ccudvfo'),(36,1,1,'ADHD problemer','CBCL',1,0,4,3,6,'2010-01-05 14:12:47','2012-03-12 19:53:11','ccadhd'),(37,1,1,'Oppositionelle adfÃ¦rdsproblemer','CBCL',1,0,4,3,6,'2010-01-05 14:12:47','2012-03-12 19:53:27','ccopadf'),(38,1,1,'Eksternalisering','CBCL',1,0,2,1,24,'2010-01-05 14:12:47','2012-03-12 19:49:27','ccekste'),(39,1,1,'Internalisering','CBCL',1,0,3,1,36,'2010-01-05 14:12:47','2012-03-12 19:50:03','ccinter'),(40,1,2,'Total problem score','CBCL',1,0,1,1,119,'2010-01-05 14:12:47','2012-03-12 19:49:05','ccytotal'),(41,1,3,'Total problem score','C-TRF',1,0,1,1,100,'2010-01-05 14:12:47','2012-03-12 19:49:05','cttotal'),(42,1,3,'Eksternalisering','C-TRF',1,0,2,1,24,'2010-01-05 14:12:47','2012-03-12 19:49:27','ctekste'),(43,1,3,'Internalisering','C-TRF',1,0,3,1,36,'2010-01-05 14:12:47','2012-03-12 19:50:03','ctinter'),(44,1,3,'Affektive problemer','C-TRF',1,0,1,3,10,'2010-01-05 14:12:47','2012-03-12 19:50:28','ctaffek'),(45,1,3,'Gennemgribende udv.forst.probl.','C-TRF',1,0,4,3,13,'2010-01-05 14:12:47','2012-03-12 19:53:01','ctudvfo'),(47,NULL,3,'Angst problemer','C-TRF',1,NULL,2,3,10,'2010-01-05 14:12:47','2012-03-12 19:50:12','ctangst'),(48,NULL,3,'ADHD problemer','C-TRF',1,NULL,4,3,6,'2010-01-05 14:12:47','2012-03-12 19:53:11','ctadhd'),(49,NULL,3,'Oppositionelle adfÃ¦rdsproblemer','C-TRF',1,NULL,4,3,6,'2010-01-05 14:12:47','2012-03-12 19:53:27','ctopadf'),(51,NULL,2,'ADHD problemer','CBCL',1,NULL,4,3,7,'2010-01-05 14:12:47','2012-03-12 19:53:11','ccyadhd'),(52,NULL,2,'Affektive problemer','CBCL',1,NULL,1,3,13,'2010-01-05 14:12:47','2012-03-12 19:50:28','ccyaffek'),(53,NULL,2,'Angst problemer','CBCL',1,NULL,2,3,6,'2010-01-05 14:12:47','2012-03-12 19:50:12','ccyangst'),(54,NULL,2,'Somatisering','CBCL',1,NULL,3,3,7,'2010-01-05 14:12:47','2012-03-12 19:53:39','ccysomat'),(55,NULL,2,'Oppositionelle adfÃ¦rdsproblemer','CBCL',1,NULL,4,3,5,'2010-01-05 14:12:47','2012-03-12 19:53:27','ccyopadf'),(56,NULL,2,'AdfÃ¦rdsforstyrrelse','CBCL',1,NULL,5,3,17,'2010-01-05 14:12:47','2012-03-12 19:53:54','ccyadfae'),(57,NULL,4,'ADHD problemer','TRF',1,NULL,4,3,13,'2010-01-05 14:12:47','2012-03-12 19:53:11','ttadhd'),(60,NULL,4,'Affektive problemer','TRF',1,NULL,1,3,10,'2010-01-05 14:12:47','2012-03-12 19:50:28','ttaffek'),(61,NULL,4,'Angst problemer','TRF',1,NULL,2,3,6,'2010-01-05 14:12:47','2012-03-12 19:50:12','ttangst'),(62,NULL,4,'Somatisering','TRF',1,NULL,3,3,7,'2010-01-05 14:12:47','2012-03-12 19:53:39','ttsomat'),(63,NULL,4,'Oppositionelle adfÃ¦rdsproblemer','TRF',1,NULL,4,3,5,'2010-01-05 14:12:47','2012-03-12 19:53:27','ttopadf'),(64,NULL,4,'AdfÃ¦rdsforstyrrelse','TRF',1,NULL,5,3,13,'2010-01-05 14:12:47','2012-03-12 19:53:54','ttadfae'),(65,NULL,5,'Affektive problemer','YSR',1,NULL,6,3,13,'2011-05-17 19:37:19','2012-03-12 19:50:28','ycyaffek'),(66,NULL,5,'Angst problemer','YSR',1,NULL,7,3,6,'2011-05-17 19:46:38','2012-03-12 19:50:12','ycyangst'),(67,NULL,5,'Somatisering','YSR',1,NULL,8,3,7,'2011-05-17 19:55:09','2012-03-12 19:53:39','ycysomat'),(68,NULL,5,'ADHD problemer','YSR',1,NULL,9,3,7,'2011-05-19 10:09:25','2012-03-12 19:53:11','ycyadhd'),(69,NULL,5,'Oppositionelle adfÃ¦rdsproblemer','YSR',1,NULL,10,3,5,'2011-05-19 10:13:17','2012-03-12 19:53:27','ycyopadf'),(70,NULL,5,'AdfÃ¦rdsforstyrrelse','YSR',1,NULL,11,3,15,'2011-05-19 10:15:29','2012-03-12 19:53:54','ycyadfae');
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-03-12 20:54:32
