-- MySQL dump 10.13  Distrib 5.1.40, for apple-darwin10.2.0 (i386)
--
-- Host: localhost    Database: cbcl_production
-- ------------------------------------------------------
-- Server version	5.1.40

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
-- Table structure for table `variables`
--

DROP TABLE IF EXISTS `variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var` varchar(255) DEFAULT NULL,
  `item` varchar(255) DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `col` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `datatype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=797 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variables`
--

LOCK TABLES `variables` WRITE;
/*!40000 ALTER TABLE `variables` DISABLE KEYS */;
INSERT INTO `variables` VALUES (1,'cc1','1',3,1,1,25,'Numeric'),(2,'cc2','2',4,1,1,25,'Numeric'),(3,'cc3','3',5,1,1,25,'Numeric'),(4,'cc4','4',6,1,1,25,'Numeric'),(5,'cc5','5',7,1,1,25,'Numeric'),(6,'cc6','6',8,1,1,25,'Numeric'),(7,'cc7','7',9,1,1,25,'Numeric'),(8,'cc8','8',10,1,1,25,'Numeric'),(9,'cc9','9',11,1,1,25,'Numeric'),(10,'cc10','10',12,1,1,25,'Numeric'),(11,'cc11','11',13,1,1,25,'Numeric'),(12,'cc12','12',14,1,1,25,'Numeric'),(13,'cc13','13',15,1,1,25,'Numeric'),(14,'cc14','14',16,1,1,25,'Numeric'),(15,'cc15','15',17,1,1,25,'Numeric'),(16,'cc16','16',18,1,1,25,'Numeric'),(17,'cc17','17',19,1,1,25,'Numeric'),(18,'cc18','18',20,1,1,25,'Numeric'),(19,'cc19','19',21,1,1,25,'Numeric'),(20,'cc20','20',22,1,1,25,'Numeric'),(21,'cc21','21',23,1,1,25,'Numeric'),(22,'cc22','22',24,1,1,25,'Numeric'),(23,'cc23','23',25,1,1,25,'Numeric'),(24,'cc24','24',26,1,1,25,'Numeric'),(25,'cc24hv','24hv',26,2,1,25,'String'),(26,'cc25','25',27,1,1,25,'Numeric'),(27,'cc26','26',28,1,1,25,'Numeric'),(28,'cc27','27',29,1,1,25,'Numeric'),(29,'cc28','28',30,1,1,25,'Numeric'),(30,'cc29','29',31,1,1,25,'Numeric'),(31,'cc30','30',32,1,1,25,'Numeric'),(32,'cc31','31',33,1,1,25,'Numeric'),(33,'cc31hv','31hv',33,2,1,25,'String'),(34,'cc32','32',34,1,1,25,'Numeric'),(35,'cc32hv','32hv',34,2,1,25,'String'),(36,'cc33','33',35,1,1,25,'Numeric'),(37,'cc34','34',36,1,1,25,'Numeric'),(38,'cc35','35',37,1,1,25,'Numeric'),(39,'cc36','36',38,1,1,25,'Numeric'),(40,'cc37','37',39,1,1,25,'Numeric'),(41,'cc38','38',40,1,1,25,'Numeric'),(42,'cc39','39',41,1,1,25,'Numeric'),(43,'cc40','40',42,1,1,25,'Numeric'),(44,'cc41','41',43,1,1,25,'Numeric'),(45,'cc42','42',44,1,1,25,'Numeric'),(46,'cc43','43',45,1,1,25,'Numeric'),(47,'cc44','44',46,1,1,25,'Numeric'),(48,'cc45','45',47,1,1,25,'Numeric'),(49,'cc46','46',48,1,1,25,'Numeric'),(50,'cc46hv','46hv',48,2,1,25,'String'),(51,'cc47','47',49,1,1,25,'Numeric'),(52,'cc48','48',50,1,1,25,'Numeric'),(53,'cc49','49',51,1,1,25,'Numeric'),(54,'cc50','50',52,1,1,25,'Numeric'),(55,'cc51','51',53,1,1,25,'Numeric'),(56,'cc52','52',54,1,1,25,'Numeric'),(57,'cc53','53',55,1,1,25,'Numeric'),(58,'cc54','54',56,1,1,25,'Numeric'),(59,'cc54hv','54hv',56,2,1,25,'String'),(60,'cc55','55',57,1,1,25,'Numeric'),(61,'cc56','56',58,1,1,25,'Numeric'),(62,'cc57','57',59,1,1,25,'Numeric'),(63,'cc58','58',60,1,1,25,'Numeric'),(64,'cc59','59',61,1,1,25,'Numeric'),(65,'cc60','60',62,1,1,25,'Numeric'),(66,'cc61','61',63,1,1,25,'Numeric'),(67,'cc62','62',64,1,1,25,'Numeric'),(68,'cc63','63',65,1,1,25,'Numeric'),(69,'cc64','64',66,1,1,25,'Numeric'),(70,'cc65','65',67,1,1,25,'Numeric'),(71,'cc66','66',68,1,1,25,'Numeric'),(72,'cc67','67',69,1,1,25,'Numeric'),(73,'cc68','68',70,1,1,25,'Numeric'),(74,'cc69','69',71,1,1,25,'Numeric'),(75,'cc70','70',72,1,1,25,'Numeric'),(76,'cc71','71',73,1,1,25,'Numeric'),(77,'cc72','72',74,1,1,25,'Numeric'),(78,'cc73','73',75,1,1,25,'Numeric'),(79,'cc74','74',76,1,1,25,'Numeric'),(80,'cc74hv','74hv',76,2,1,25,'String'),(81,'cc75','75',77,1,1,25,'Numeric'),(82,'cc76','76',78,1,1,25,'Numeric'),(83,'cc76hv','76hv',78,2,1,25,'String'),(84,'cc77','77',79,1,1,25,'Numeric'),(85,'cc78','78',80,1,1,25,'Numeric'),(86,'cc79','79',81,1,1,25,'Numeric'),(87,'cc80','80',82,1,1,25,'Numeric'),(88,'cc80hv','80hv',82,2,1,25,'String'),(89,'cc81','81',83,1,1,25,'Numeric'),(90,'cc82','82',84,1,1,25,'Numeric'),(91,'cc83','83',85,1,1,25,'Numeric'),(92,'cc84','84',86,1,1,25,'Numeric'),(93,'cc85','85',87,1,1,25,'Numeric'),(94,'cc86','86',88,1,1,25,'Numeric'),(95,'cc87','87',89,1,1,25,'Numeric'),(96,'cc88','88',90,1,1,25,'Numeric'),(97,'cc89','89',91,1,1,25,'Numeric'),(98,'cc90','90',92,1,1,25,'Numeric'),(99,'cc91','91',93,1,1,25,'Numeric'),(100,'cc92','92',94,1,1,25,'Numeric'),(101,'cc92hv','92hv',94,2,1,25,'String'),(102,'cc93','93',95,1,1,25,'Numeric'),(103,'cc94','94',96,1,1,25,'Numeric'),(104,'cc95','95',97,1,1,25,'Numeric'),(105,'cc96','96',98,1,1,25,'Numeric'),(106,'cc97','97',99,1,1,25,'Numeric'),(107,'cc98','98',100,1,1,25,'Numeric'),(108,'cc99','99',101,1,1,25,'Numeric'),(109,'cc100','100',102,1,1,25,'Numeric'),(110,'cc100hv','100hv',102,2,1,25,'String'),(111,'cchandic','1',1,2,1,8,'Numeric'),(112,'cchandhv','hv',1,3,1,8,'Numeric'),(113,'ccbekyhv','2hv',2,2,1,8,'String'),(114,'ccbedshv','3hv',3,2,1,8,'String'),(115,'ccfodtid','1',2,2,1,10,'Numeric'),(116,'ccfodg','2hv',3,2,1,10,'Numeric'),(117,'ccorebet','3',4,2,1,10,'Numeric'),(118,'ccsproan','4',5,2,1,10,'Numeric'),(119,'ccsprohv','4hv',5,3,1,10,'String'),(120,'cctale','5',6,2,1,10,'Numeric'),(121,'cctalehv','5hv',6,3,1,10,'Numeric'),(122,'ccsprobe','7',7,2,1,10,'Numeric'),(123,'ccsprobehv','6hv',7,3,1,10,'String'),(124,'ccudvian','7hv',8,2,1,10,'String'),(125,'ccyispor','',2,1,2,1,'Numeric'),(126,'ccyiaspg','1a',3,3,2,1,'Numeric'),(127,'ccyibspg','1b',4,3,2,1,'Numeric'),(128,'ccyicspg','1c',5,3,2,1,'Numeric'),(129,'ccyiihob','',2,1,2,2,'Numeric'),(130,'ccyiiahg','1a',3,3,2,2,'Numeric'),(131,'ccyiibhg','1b',4,3,2,2,'Numeric'),(132,'ccyiichg','1c',5,3,2,2,'Numeric'),(133,'ccyiiifo','',2,1,2,3,'Numeric'),(134,'ccyiiia','1a',3,1,2,3,'Numeric'),(135,'ccyiiib','1b',4,1,2,3,'Numeric'),(136,'ccyiiic','1c',5,1,2,3,'Numeric'),(137,'ccyivjob','',2,1,2,4,'Numeric'),(138,'ccyivjag','1a',3,2,2,4,'Numeric'),(139,'ccyivjbg','1b',4,2,2,4,'Numeric'),(140,'ccyivjcg','1c',5,2,2,4,'Numeric'),(141,'ccyv1ven','1',1,2,2,5,'Numeric'),(142,'ccyv2vea','2',2,2,2,5,'Numeric'),(143,'ccyvisos','1a',2,2,2,6,'Numeric'),(144,'ccyvibor','1b',3,2,2,6,'Numeric'),(145,'ccyvifor','1c',4,2,2,6,'Numeric'),(146,'ccyviale','1d',5,2,2,6,'Numeric'),(147,'ccyviisko','',1,1,2,7,'Numeric'),(148,'ccyviiund','hv',1,2,2,7,'String'),(149,'caviilae','1a',3,2,2,7,'Numeric'),(150,'caviista','1b',4,2,2,7,'Numeric'),(151,'caviimat','1c',5,2,2,7,'Numeric'),(152,'caviinat','1d',6,2,2,7,'Numeric'),(153,'caviieng','1e',7,2,2,7,'Numeric'),(154,'caviivu1','1f',8,2,2,7,'Numeric'),(155,'caviivu2','1g',9,2,2,7,'Numeric'),(156,'ctcundty','2',10,3,2,7,'Numeric'),(157,'ctcgomkl','3',11,3,2,7,'Numeric'),(158,'ctcgomhv','3hv',11,4,2,7,'String'),(159,'ccyvii4pr','4',12,2,2,7,'Numeric'),(160,'ccyvii4hv','4hv',12,3,2,7,'String'),(161,'ccyvii4ho','5',13,2,2,7,'Numeric'),(162,'ccyhandi','1',1,2,2,9,'Numeric'),(163,'ccyhandhv','hv',1,3,2,9,'String'),(164,'ccyviii2hv','2hv',2,2,2,9,'String'),(165,'ccyviii3hv','3hv',3,2,2,9,'String'),(166,'ccy1','1',3,1,2,20,'Numeric'),(167,'ccy2','2',4,1,2,20,'Numeric'),(168,'ccy2hv','2hv',4,2,2,20,'String'),(169,'ccy3','3',5,1,2,20,'Numeric'),(170,'ccy4','4',6,1,2,20,'Numeric'),(171,'ccy5','5',7,1,2,20,'Numeric'),(172,'ccy6','6',8,1,2,20,'Numeric'),(173,'ccy7','7',9,1,2,20,'Numeric'),(174,'ccy8','8',10,1,2,20,'Numeric'),(175,'ccy9','9',11,1,2,20,'Numeric'),(176,'ccy9hv','9hv',11,2,2,20,'String'),(177,'ccy10','10',12,1,2,20,'Numeric'),(178,'ccy11','11',13,1,2,20,'Numeric'),(179,'ccy12','12',14,1,2,20,'Numeric'),(180,'ccy13','13',15,1,2,20,'Numeric'),(181,'ccy14','14',16,1,2,20,'Numeric'),(182,'ccy15','15',17,1,2,20,'Numeric'),(183,'ccy16','16',18,1,2,20,'Numeric'),(184,'ccy17','17',19,1,2,20,'Numeric'),(185,'ccy18','18',20,1,2,20,'Numeric'),(186,'ccy19','19',21,1,2,20,'Numeric'),(187,'ccy20','20',22,1,2,20,'Numeric'),(188,'ccy21','21',23,1,2,20,'Numeric'),(189,'ccy22','22',24,1,2,20,'Numeric'),(190,'ccy23','23',25,1,2,20,'Numeric'),(191,'ccy24','24',26,1,2,20,'Numeric'),(192,'ccy25','25',27,1,2,20,'Numeric'),(193,'ccy26','26',28,1,2,20,'Numeric'),(194,'ccy27','27',29,1,2,20,'Numeric'),(195,'ccy28','28',30,1,2,20,'Numeric'),(196,'ccy29','29',31,1,2,20,'Numeric'),(197,'ccy29hv','29hv',31,2,2,20,'String'),(198,'ccy30','30',32,1,2,20,'Numeric'),(199,'ccy31','31',33,1,2,20,'Numeric'),(200,'ccy32','32',34,1,2,20,'Numeric'),(201,'ccy33','33',35,1,2,20,'Numeric'),(202,'ccy34','34',36,1,2,20,'Numeric'),(203,'ccy35','35',37,1,2,20,'Numeric'),(204,'ccy36','36',38,1,2,20,'Numeric'),(205,'ccy37','37',39,1,2,20,'Numeric'),(206,'ccy38','38',40,1,2,20,'Numeric'),(207,'ccy39','39',41,1,2,20,'Numeric'),(208,'ccy40','40',42,1,2,20,'Numeric'),(209,'ccy40hv','40hv',42,2,2,20,'String'),(210,'ccy41','41',43,1,2,20,'Numeric'),(211,'ccy42','42',44,1,2,20,'Numeric'),(212,'ccy43','43',45,1,2,20,'Numeric'),(213,'ccy44','44',46,1,2,20,'Numeric'),(214,'ccy45','45',47,1,2,20,'Numeric'),(215,'ccy46','46',48,1,2,20,'Numeric'),(216,'ccy46hv','46hv',48,2,2,20,'String'),(217,'ccy47','47',49,1,2,20,'Numeric'),(218,'ccy48','48',50,1,2,20,'Numeric'),(219,'ccy49','49',51,1,2,20,'Numeric'),(220,'ccy50','50',52,1,2,20,'Numeric'),(221,'ccy51','51',53,1,2,20,'Numeric'),(222,'ccy52','52',54,1,2,20,'Numeric'),(223,'ccy53','53',55,1,2,20,'Numeric'),(224,'ccy54','54',56,1,2,20,'Numeric'),(225,'ccy55','55',57,1,2,20,'Numeric'),(226,'ccy56a','56a',59,1,2,20,'Numeric'),(227,'ccy56b','56b',60,1,2,20,'Numeric'),(228,'ccy56c','56c',61,1,2,20,'Numeric'),(229,'ccy56d','56d',62,1,2,20,'Numeric'),(230,'ccy56dhv','56dhv',62,2,2,20,'String'),(231,'ccy56e','56e',63,1,2,20,'Numeric'),(232,'ccy56f','56f',64,1,2,20,'Numeric'),(233,'ccy56g','56g',65,1,2,20,'Numeric'),(234,'ccy56h','56h',66,1,2,20,'Numeric'),(235,'ccy56hhv','56hhv',66,2,2,20,'String'),(236,'ccy57','57',67,1,2,20,'Numeric'),(237,'ccy58','58',68,1,2,20,'Numeric'),(238,'ccy58hv','58hv',68,2,2,20,'String'),(239,'ccy59','59',69,1,2,20,'Numeric'),(240,'ccy60','60',70,1,2,20,'Numeric'),(241,'ccy61','61',71,1,2,20,'Numeric'),(242,'ccy62','62',72,1,2,20,'Numeric'),(243,'ccy63','63',73,1,2,20,'Numeric'),(244,'ccy64','64',74,1,2,20,'Numeric'),(245,'ccy65','65',75,1,2,20,'Numeric'),(246,'ccy66','66',76,1,2,20,'Numeric'),(247,'ccy66hv','66hv',76,2,2,20,'String'),(248,'ccy67','67',77,1,2,20,'Numeric'),(249,'ccy68','68',78,1,2,20,'Numeric'),(250,'ccy69','69',79,1,2,20,'Numeric'),(251,'ccy70','70',80,1,2,20,'Numeric'),(252,'ccy70hv','70hv',80,2,2,20,'String'),(253,'ccy71','71',81,1,2,20,'Numeric'),(254,'ccy72','72',82,1,2,20,'Numeric'),(255,'ccy73','73',83,1,2,20,'Numeric'),(256,'ccy73hv','73hv',83,2,2,20,'String'),(257,'ccy74','74',84,1,2,20,'Numeric'),(258,'ccy75','75',85,1,2,20,'Numeric'),(259,'ccy76','76',86,1,2,20,'Numeric'),(260,'ccy77','77',87,1,2,20,'Numeric'),(261,'ccy77hv','77hv',87,2,2,20,'String'),(262,'ccy78','78',88,1,2,20,'Numeric'),(263,'ccy79','79',89,1,2,20,'Numeric'),(264,'ccy79hv','79hv',89,2,2,20,'String'),(265,'ccy80','80',90,1,2,20,'Numeric'),(266,'ccy81','81',91,1,2,20,'Numeric'),(267,'ccy82','82',92,1,2,20,'Numeric'),(268,'ccy83','83',93,1,2,20,'Numeric'),(269,'ccy83hv','83hv',93,2,2,20,'String'),(270,'ccy84','84',94,1,2,20,'Numeric'),(271,'ccy84hv','84hv',94,2,2,20,'String'),(272,'ccy85','85',95,1,2,20,'Numeric'),(273,'ccy85hv','85hv',95,2,2,20,'String'),(274,'ccy86','86',96,1,2,20,'Numeric'),(275,'ccy87','87',97,1,2,20,'Numeric'),(276,'ccy88','88',98,1,2,20,'Numeric'),(277,'ccy89','89',99,1,2,20,'Numeric'),(278,'ccy90','90',100,1,2,20,'Numeric'),(279,'ccy91','91',101,1,2,20,'Numeric'),(280,'ccy92','92',102,1,2,20,'Numeric'),(281,'ccy92hv','92hv',102,2,2,20,'String'),(282,'ccy93','93',103,1,2,20,'Numeric'),(283,'ccy94','94',104,1,2,20,'Numeric'),(284,'ccy95','95',105,1,2,20,'Numeric'),(285,'ccy96','96',106,1,2,20,'Numeric'),(286,'ccy97','97',107,1,2,20,'Numeric'),(287,'ccy98','98',108,1,2,20,'Numeric'),(288,'ccy99','99',109,1,2,20,'Numeric'),(289,'ccy100','100',110,1,2,20,'Numeric'),(290,'ccy100hv','100hv',110,2,2,20,'String'),(291,'ccy101','101',111,1,2,20,'Numeric'),(292,'ccy102','102',112,1,2,20,'Numeric'),(293,'ccy103','103',113,1,2,20,'Numeric'),(294,'ccy104','104',114,1,2,20,'Numeric'),(295,'ccy105','105',115,1,2,20,'Numeric'),(296,'ccy105hv','105hv',115,2,2,20,'String'),(297,'ccy106','106',116,1,2,20,'Numeric'),(298,'ccy107','107',117,1,2,20,'Numeric'),(299,'ccy108','108',118,1,2,20,'Numeric'),(300,'ccy109','109',119,1,2,20,'Numeric'),(301,'ccy110','110',120,1,2,20,'Numeric'),(302,'ccy111','111',121,1,2,20,'Numeric'),(303,'ccy112','112',122,1,2,20,'Numeric'),(304,'ccy113hv','hv',123,2,2,20,'String'),(305,'ctinst','1hv',1,2,3,31,'String'),(306,'ctpasty','2',2,2,3,31,'Numeric'),(307,'ctpashv','2hv',2,3,3,31,'Numeric'),(308,'ctborn','hv',1,1,3,32,'Numeric'),(309,'cttimer','1hv',1,1,3,33,'Numeric'),(311,'ctkentid','1',1,2,3,34,'Numeric'),(312,'cttraen','1',1,2,3,237,'Numeric'),(313,'cttraehv','1hv',1,3,3,237,'Numeric'),(314,'ct1','1',3,1,3,272,'Numeric'),(315,'ct2','2',4,1,3,272,'Numeric'),(316,'ct3','3',5,1,3,272,'Numeric'),(317,'ct4','4',6,1,3,272,'Numeric'),(318,'ct5','5',7,1,3,272,'Numeric'),(319,'ct6','6',8,1,3,272,'Numeric'),(320,'ct7','7',9,1,3,272,'Numeric'),(321,'ct8','8',10,1,3,272,'Numeric'),(322,'ct9','9',11,1,3,272,'Numeric'),(323,'ct10','10',12,1,3,272,'Numeric'),(324,'ct11','11',13,1,3,272,'Numeric'),(325,'ct12','12',14,1,3,272,'Numeric'),(326,'ct13','13',15,1,3,272,'Numeric'),(327,'ct14','14',16,1,3,272,'Numeric'),(328,'ct15','15',17,1,3,272,'Numeric'),(329,'ct16','16',18,1,3,272,'Numeric'),(330,'ct17','17',19,1,3,272,'Numeric'),(331,'ct18','18',20,1,3,272,'Numeric'),(332,'ct19','19',21,1,3,272,'Numeric'),(333,'ct20','20',22,1,3,272,'Numeric'),(334,'ct21','21',23,1,3,272,'Numeric'),(335,'ct22','22',24,1,3,272,'Numeric'),(336,'ct23','23',25,1,3,272,'Numeric'),(337,'ct24','24',26,1,3,272,'Numeric'),(338,'ct25','25',27,1,3,272,'Numeric'),(339,'ct26','26',28,1,3,272,'Numeric'),(340,'ct27','27',29,1,3,272,'Numeric'),(341,'ct28','28',30,1,3,272,'Numeric'),(342,'ct29','29',31,1,3,272,'Numeric'),(343,'ct30','30',32,1,3,272,'Numeric'),(344,'ct31','31',33,1,3,272,'Numeric'),(345,'ct31hv','31hv',33,2,3,272,'String'),(346,'ct32','32',34,1,3,272,'Numeric'),(347,'ct32hv','32hv',34,2,3,272,'String'),(348,'ct33','33',35,1,3,272,'Numeric'),(349,'ct34','34',36,1,3,272,'Numeric'),(350,'ct35','35',37,1,3,272,'Numeric'),(351,'ct36','36',38,1,3,272,'Numeric'),(352,'ct37','37',39,1,3,272,'Numeric'),(353,'ct38','38',40,1,3,272,'Numeric'),(354,'ct39','39',41,1,3,272,'Numeric'),(355,'ct40','40',42,1,3,272,'Numeric'),(356,'ct41','41',43,1,3,272,'Numeric'),(357,'ct42','42',44,1,3,272,'Numeric'),(358,'ct43','43',45,1,3,272,'Numeric'),(359,'ct44','44',46,1,3,272,'Numeric'),(360,'ct45','45',47,1,3,272,'Numeric'),(361,'ct46','46',48,1,3,272,'Numeric'),(362,'ct46hv','46hv',48,2,3,272,'String'),(363,'ct47','47',49,1,3,272,'Numeric'),(364,'ct48','48',50,1,3,272,'Numeric'),(365,'ct49','49',51,1,3,272,'Numeric'),(366,'ct50','50',52,1,3,272,'Numeric'),(367,'ct51','51',53,1,3,272,'Numeric'),(368,'ct52','52',54,1,3,272,'Numeric'),(369,'ct53','53',55,1,3,272,'Numeric'),(370,'ct54','54',56,1,3,272,'Numeric'),(371,'ct54hv','54hv',56,2,3,272,'String'),(372,'ct55','55',57,1,3,272,'Numeric'),(373,'ct56','56',58,1,3,272,'Numeric'),(374,'ct57','57',59,1,3,272,'Numeric'),(375,'ct58','58',60,1,3,272,'Numeric'),(376,'ct59','59',61,1,3,272,'Numeric'),(377,'ct60','60',62,1,3,272,'Numeric'),(378,'ct61','61',63,1,3,272,'Numeric'),(379,'ct62','62',64,1,3,272,'Numeric'),(380,'ct63','63',65,1,3,272,'Numeric'),(381,'ct64','64',66,1,3,272,'Numeric'),(382,'ct65','65',67,1,3,272,'Numeric'),(383,'ct66','66',68,1,3,272,'Numeric'),(384,'ct67','67',69,1,3,272,'Numeric'),(385,'ct68','68',70,1,3,272,'Numeric'),(386,'ct69','69',71,1,3,272,'Numeric'),(387,'ct70','70',72,1,3,272,'Numeric'),(388,'ct71','71',73,1,3,272,'Numeric'),(389,'ct72','72',74,1,3,272,'Numeric'),(390,'ct73','73',75,1,3,272,'Numeric'),(391,'ct74','74',76,1,3,272,'Numeric'),(392,'ct75','75',77,1,3,272,'Numeric'),(393,'ct76','76',78,1,3,272,'Numeric'),(394,'ct76hv','76hv',78,2,3,272,'String'),(395,'ct77','77',79,1,3,272,'Numeric'),(396,'ct78','78',80,1,3,272,'Numeric'),(397,'ct79','79',81,1,3,272,'Numeric'),(398,'ct80','80',82,1,3,272,'Numeric'),(399,'ct80hv','80hv',82,2,3,272,'String'),(400,'ct81','81',83,1,3,272,'Numeric'),(401,'ct82','82',84,1,3,272,'Numeric'),(402,'ct83','83',85,1,3,272,'Numeric'),(403,'ct84','84',86,1,3,272,'Numeric'),(404,'ct85','85',87,1,3,272,'Numeric'),(405,'ct86','86',88,1,3,272,'Numeric'),(406,'ct87','87',89,1,3,272,'Numeric'),(407,'ct88','88',90,1,3,272,'Numeric'),(408,'ct89','89',91,1,3,272,'Numeric'),(409,'ct90','90',92,1,3,272,'Numeric'),(410,'ct91','91',93,1,3,272,'Numeric'),(411,'ct92','92',94,1,3,272,'Numeric'),(412,'ct92hv','92hv',94,2,3,272,'String'),(413,'ct93','93',95,1,3,272,'Numeric'),(414,'ct94','94',96,1,3,272,'Numeric'),(415,'ct95','95',97,1,3,272,'Numeric'),(416,'ct96','96',98,1,3,272,'Numeric'),(417,'ct97','97',99,1,3,272,'Numeric'),(418,'ct98','98',100,1,3,272,'Numeric'),(419,'ct99','99',101,1,3,272,'Numeric'),(420,'ct100','100',102,1,3,272,'Numeric'),(421,'ct100hv','100hv',102,2,3,272,'String'),(422,'cthandic','1',1,2,3,11,'Numeric'),(423,'cthandhv','1hv',1,3,3,11,'String'),(424,'ctbekyhv','2hv',2,2,3,11,'String'),(425,'ctbedshv','3hv',3,2,3,11,'String'),(426,'ttkltrin','',1,2,4,275,'Numeric'),(427,'ttskolen','hv',2,2,4,275,'String'),(428,'ttiikend','1',1,2,4,214,'Numeric'),(429,'ttlekt','1hv',1,2,4,215,'String'),(430,'ttv','',1,3,4,276,'String'),(431,'ttcgomkl','',1,3,4,277,'Numeric'),(432,'ttcgomhv','hv',1,4,4,277,'Numeric'),(433,'taviivu2','',9,2,4,219,'Numeric'),(434,'taviian1','6',8,1,4,219,'Numeric'),(435,'taviian2','7',9,1,4,219,'Numeric'),(436,'ttviiihu','',5,2,4,220,'Numeric'),(437,'ttixhandhv','1hv',1,2,4,221,'String'),(438,'ttxbekym','1hv',1,2,4,222,'Numeric'),(439,'ttxibedsthv','1hv',1,2,4,223,'Numeric'),(440,'tt1','1',3,1,4,18,'Numeric'),(441,'tt2','2',4,1,4,18,'Numeric'),(442,'tt3','3',5,1,4,18,'Numeric'),(443,'tt4','4',6,1,4,18,'Numeric'),(444,'tt5','5',7,1,4,18,'Numeric'),(445,'tt6','6',8,1,4,18,'Numeric'),(446,'tt7','7',9,1,4,18,'Numeric'),(447,'tt8','8',10,1,4,18,'Numeric'),(448,'tt9','9',11,1,4,18,'Numeric'),(449,'tt9hv','9hv',11,2,4,18,'String'),(450,'tt10','10',12,1,4,18,'Numeric'),(451,'tt11','11',13,1,4,18,'Numeric'),(452,'tt12','12',14,1,4,18,'Numeric'),(453,'tt13','13',15,1,4,18,'Numeric'),(454,'tt14','14',16,1,4,18,'Numeric'),(455,'tt15','15',17,1,4,18,'Numeric'),(456,'tt16','16',18,1,4,18,'Numeric'),(457,'tt17','17',19,1,4,18,'Numeric'),(458,'tt18','18',20,1,4,18,'Numeric'),(459,'tt19','19',21,1,4,18,'Numeric'),(460,'tt20','20',22,1,4,18,'Numeric'),(461,'tt21','21',23,1,4,18,'Numeric'),(462,'tt22','22',24,1,4,18,'Numeric'),(463,'tt23','23',25,1,4,18,'Numeric'),(464,'tt24','24',26,1,4,18,'Numeric'),(465,'tt25','25',27,1,4,18,'Numeric'),(466,'tt26','26',28,1,4,18,'Numeric'),(467,'tt27','27',29,1,4,18,'Numeric'),(468,'tt28','28',30,1,4,18,'Numeric'),(469,'tt29','29',31,1,4,18,'Numeric'),(470,'tt29hv','29hv',31,2,4,18,'String'),(471,'tt30','30',32,1,4,18,'Numeric'),(472,'tt31','31',33,1,4,18,'Numeric'),(473,'tt32','32',34,1,4,18,'Numeric'),(474,'tt33','33',35,1,4,18,'Numeric'),(475,'tt34','34',36,1,4,18,'Numeric'),(476,'tt35','35',37,1,4,18,'Numeric'),(477,'tt36','36',38,1,4,18,'Numeric'),(478,'tt37','37',39,1,4,18,'Numeric'),(479,'tt38','38',40,1,4,18,'Numeric'),(480,'tt39','39',41,1,4,18,'Numeric'),(481,'tt40','40',42,1,4,18,'Numeric'),(482,'tt40hv','40hv',42,2,4,18,'String'),(483,'tt41','41',43,1,4,18,'Numeric'),(484,'tt42','42',44,1,4,18,'Numeric'),(485,'tt43','43',45,1,4,18,'Numeric'),(486,'tt44','44',46,1,4,18,'Numeric'),(487,'tt45','45',47,1,4,18,'Numeric'),(488,'tt46','46',48,1,4,18,'Numeric'),(489,'tt46hv','46hv',48,2,4,18,'String'),(490,'tt47','47',49,1,4,18,'Numeric'),(491,'tt48','48',50,1,4,18,'Numeric'),(492,'tt49','49',51,1,4,18,'Numeric'),(493,'tt50','50',52,1,4,18,'Numeric'),(494,'tt51','51',53,1,4,18,'Numeric'),(495,'tt52','52',54,1,4,18,'Numeric'),(496,'tt53','53',55,1,4,18,'Numeric'),(497,'tt54','54',56,1,4,18,'Numeric'),(498,'tt55','55',57,1,4,18,'Numeric'),(499,'tt56a','56a',59,1,4,18,'Numeric'),(500,'tt56b','56b',60,1,4,18,'Numeric'),(501,'tt56c','56c',61,1,4,18,'Numeric'),(502,'tt56d','56d',62,1,4,18,'Numeric'),(503,'tt56dhv','56dhv',62,2,4,18,'String'),(504,'tt56e','56e',63,1,4,18,'Numeric'),(505,'tt56f','56f',64,1,4,18,'Numeric'),(506,'tt56g','56g',65,1,4,18,'Numeric'),(507,'tt56h','56h',66,1,4,18,'Numeric'),(508,'tt56hhv','56hhv',66,2,4,18,'String'),(509,'tt57','57',67,1,4,18,'Numeric'),(510,'tt58','58',68,1,4,18,'Numeric'),(511,'tt58hv','58hv',68,2,4,18,'String'),(512,'tt59','59',69,1,4,18,'Numeric'),(513,'tt60','60',70,1,4,18,'Numeric'),(514,'tt61','61',71,1,4,18,'Numeric'),(515,'tt62','62',72,1,4,18,'Numeric'),(516,'tt63','63',73,1,4,18,'Numeric'),(517,'tt64','64',74,1,4,18,'Numeric'),(518,'tt65','65',75,1,4,18,'Numeric'),(519,'tt66','66',76,1,4,18,'Numeric'),(520,'tt66hv','66hv',76,2,4,18,'String'),(521,'tt67','67',77,1,4,18,'Numeric'),(522,'tt68','68',78,1,4,18,'Numeric'),(523,'tt69','69',79,1,4,18,'Numeric'),(524,'tt70','70',80,1,4,18,'Numeric'),(525,'tt70hv','70hv',80,2,4,18,'String'),(526,'tt71','71',81,1,4,18,'Numeric'),(527,'tt72','72',82,1,4,18,'Numeric'),(528,'tt73','73',83,1,4,18,'Numeric'),(529,'tt73hv','73hv',83,2,4,18,'String'),(530,'tt74','74',84,1,4,18,'Numeric'),(531,'tt75','75',85,1,4,18,'Numeric'),(532,'tt76','76',86,1,4,18,'Numeric'),(533,'tt77','77',87,1,4,18,'Numeric'),(534,'tt78','78',88,1,4,18,'Numeric'),(535,'tt79','79',89,1,4,18,'Numeric'),(536,'tt79hv','79hv',89,2,4,18,'String'),(537,'tt80','80',90,1,4,18,'Numeric'),(538,'tt81','81',91,1,4,18,'Numeric'),(539,'tt82','82',92,1,4,18,'Numeric'),(540,'tt83','83',93,1,4,18,'Numeric'),(541,'tt83hv','83hv',93,2,4,18,'String'),(542,'tt84','84',94,1,4,18,'Numeric'),(543,'tt84hv','84hv',94,2,4,18,'String'),(544,'tt85','85',95,1,4,18,'Numeric'),(545,'tt85hv','85hv',95,2,4,18,'String'),(546,'tt86','86',96,1,4,18,'Numeric'),(547,'tt87','87',97,1,4,18,'Numeric'),(548,'tt88','88',98,1,4,18,'Numeric'),(549,'tt89','89',99,1,4,18,'Numeric'),(550,'tt90','90',100,1,4,18,'Numeric'),(551,'tt91','91',101,1,4,18,'Numeric'),(552,'tt92','92',102,1,4,18,'Numeric'),(553,'tt93','93',103,1,4,18,'Numeric'),(554,'tt94','94',104,1,4,18,'Numeric'),(555,'tt95','95',105,1,4,18,'Numeric'),(556,'tt96','96',106,1,4,18,'Numeric'),(557,'tt97','97',107,1,4,18,'Numeric'),(558,'tt98','98',108,1,4,18,'Numeric'),(559,'tt99','99',109,1,4,18,'Numeric'),(560,'tt100','100',110,1,4,18,'Numeric'),(561,'tt101','101',111,1,4,18,'Numeric'),(562,'tt102','102',112,1,4,18,'Numeric'),(563,'tt103','103',113,1,4,18,'Numeric'),(564,'tt104','104',114,1,4,18,'Numeric'),(565,'tt105','105',115,1,4,18,'Numeric'),(566,'tt105hv','105hv',115,2,4,18,'String'),(567,'tt106','106',116,1,4,18,'Numeric'),(568,'tt107','107',117,1,4,18,'Numeric'),(569,'tt108','108',118,1,4,18,'Numeric'),(570,'tt109','109',119,1,4,18,'Numeric'),(571,'tt110','110',120,1,4,18,'Numeric'),(572,'tt111','111',121,1,4,18,'Numeric'),(573,'tt112','112',122,1,4,18,'Numeric'),(574,'tt113hv','hv',123,2,4,18,'String'),(576,'ycyiaspg','1a',3,3,5,51,'Numeric'),(577,'ycyibspg','1b',4,3,5,51,'Numeric'),(578,'ycyicspg','1c',5,3,5,51,'Numeric'),(579,'ycyiihob','',2,1,5,52,'Numeric'),(580,'ycyiiahg','1a',3,3,5,52,'Numeric'),(581,'ycyiibhg','1b',4,3,5,52,'Numeric'),(582,'ycyiichg','1c',5,3,5,52,'Numeric'),(583,'ycyiiifo','',2,1,5,53,'Numeric'),(584,'ycyiiiaa','1',3,2,5,53,'Numeric'),(585,'ycyiiiba','1b',4,2,5,53,'Numeric'),(586,'ycyiiica','1c',5,2,5,53,'Numeric'),(587,'ycyivjob','',2,1,5,54,'Numeric'),(588,'ycyivjag','1a',3,2,5,54,'Numeric'),(589,'ycyivjbg','1b',4,2,5,54,'Numeric'),(590,'ycyivjcg','1c',5,2,5,54,'Numeric'),(591,'ycyv1ven','1',1,2,5,55,'Numeric'),(592,'ycyv2vea','2',2,2,5,55,'Numeric'),(593,'ycyvisos','1a',2,2,5,56,'Numeric'),(594,'ycyvibor','1b',3,2,5,56,'Numeric'),(595,'ycyvifor','1c',4,2,5,56,'Numeric'),(596,'ycyviale','1d',5,2,5,56,'Numeric'),(597,'yaviilae','1a',2,2,5,57,'Numeric'),(598,'yaviista','1b',3,2,5,57,'Numeric'),(599,'yaviimat','1c',4,2,5,57,'Numeric'),(600,'yaviinat','1d',5,2,5,57,'Numeric'),(601,'yaviieng','1e',6,2,5,57,'Numeric'),(602,'yaviivu1','1f',7,2,5,57,'Numeric'),(603,'yaviivu2','1g',8,2,5,57,'Numeric'),(604,'ycy1','1',3,1,5,19,'Numeric'),(605,'ycy2','2',4,1,5,19,'Numeric'),(606,'ycy2hv','2hv',4,2,5,19,'String'),(607,'ycy3','3',5,1,5,19,'Numeric'),(608,'ycy4','4',6,1,5,19,'Numeric'),(609,'ycy5','5',7,1,5,19,'Numeric'),(610,'ycy6','6',8,1,5,19,'Numeric'),(611,'ycy7','7',9,1,5,19,'Numeric'),(612,'ycy8','8',10,1,5,19,'Numeric'),(613,'ycy9','9',11,1,5,19,'Numeric'),(614,'ycy9hv','9hv',11,2,5,19,'String'),(615,'ycy10','10',12,1,5,19,'Numeric'),(616,'ycy11','11',13,1,5,19,'Numeric'),(617,'ycy12','12',14,1,5,19,'Numeric'),(618,'ycy13','13',15,1,5,19,'Numeric'),(619,'ycy14','14',16,1,5,19,'Numeric'),(620,'ycy15','15',17,1,5,19,'Numeric'),(621,'ycy16','16',18,1,5,19,'Numeric'),(622,'ycy17','17',19,1,5,19,'Numeric'),(623,'ycy18','18',20,1,5,19,'Numeric'),(624,'ycy19','19',21,1,5,19,'Numeric'),(625,'ycy20','20',22,1,5,19,'Numeric'),(626,'ycy21','21',23,1,5,19,'Numeric'),(627,'ycy22','22',24,1,5,19,'Numeric'),(628,'ycy23','23',25,1,5,19,'Numeric'),(629,'ycy24','24',26,1,5,19,'Numeric'),(630,'ycy25','25',27,1,5,19,'Numeric'),(631,'ycy26','26',28,1,5,19,'Numeric'),(632,'ycy27','27',29,1,5,19,'Numeric'),(633,'ycy28','28',30,1,5,19,'Numeric'),(634,'ycy29','29',31,1,5,19,'Numeric'),(635,'ycy29hv','29hv',31,2,5,19,'String'),(636,'ycy30','30',32,1,5,19,'Numeric'),(637,'ycy31','31',33,1,5,19,'Numeric'),(638,'ycy32','32',34,1,5,19,'Numeric'),(639,'ycy33','33',35,1,5,19,'Numeric'),(640,'ycy34','34',36,1,5,19,'Numeric'),(641,'ycy35','35',37,1,5,19,'Numeric'),(642,'ycy36','36',38,1,5,19,'Numeric'),(643,'ycy37','37',39,1,5,19,'Numeric'),(644,'ycy38','38',40,1,5,19,'Numeric'),(645,'ycy39','39',41,1,5,19,'Numeric'),(646,'ycy40','40',42,1,5,19,'Numeric'),(647,'ycy40hv','40hv',42,2,5,19,'String'),(648,'ycy41','41',43,1,5,19,'Numeric'),(649,'ycy42','42',44,1,5,19,'Numeric'),(650,'ycy43','43',45,1,5,19,'Numeric'),(651,'ycy44','44',46,1,5,19,'Numeric'),(652,'ycy45','45',47,1,5,19,'Numeric'),(653,'ycy46','46',48,1,5,19,'Numeric'),(654,'ycy46hv','46hv',48,2,5,19,'String'),(655,'ycy47','47',49,1,5,19,'Numeric'),(656,'ycy48','48',50,1,5,19,'Numeric'),(657,'ycy49','49',51,1,5,19,'Numeric'),(658,'ycy50','50',52,1,5,19,'Numeric'),(659,'ycy51','51',53,1,5,19,'Numeric'),(660,'ycy52','52',54,1,5,19,'Numeric'),(661,'ycy53','53',55,1,5,19,'Numeric'),(662,'ycy54','54',56,1,5,19,'Numeric'),(663,'ycy55','55',57,1,5,19,'Numeric'),(664,'ycy56a','56a',59,1,5,19,'Numeric'),(665,'ycy56b','56b',60,1,5,19,'Numeric'),(666,'ycy56c','56c',61,1,5,19,'Numeric'),(667,'ycy56d','56d',62,1,5,19,'Numeric'),(668,'ycy56dhv','56dhv',62,2,5,19,'String'),(669,'ycy56e','56e',63,1,5,19,'Numeric'),(670,'ycy56f','56f',64,1,5,19,'Numeric'),(671,'ycy56g','56g',65,1,5,19,'Numeric'),(672,'ycy56h','56h',66,1,5,19,'Numeric'),(673,'ycy56hhv','56hhv',66,2,5,19,'String'),(674,'ycy57','57',67,1,5,19,'Numeric'),(675,'ycy58','58',68,1,5,19,'Numeric'),(676,'ycy58hv','58hv',68,2,5,19,'String'),(677,'ycy59','59',69,1,5,19,'Numeric'),(678,'ycy60','60',70,1,5,19,'Numeric'),(679,'ycy61','61',71,1,5,19,'Numeric'),(680,'ycy62','62',72,1,5,19,'Numeric'),(681,'ycy63','63',73,1,5,19,'Numeric'),(682,'ycy64','64',74,1,5,19,'Numeric'),(683,'ycy65','65',75,1,5,19,'Numeric'),(684,'ycy66','66',76,1,5,19,'Numeric'),(685,'ycy66hv','66hv',76,2,5,19,'String'),(686,'ycy67','67',77,1,5,19,'Numeric'),(687,'ycy68','68',78,1,5,19,'Numeric'),(688,'ycy69','69',79,1,5,19,'Numeric'),(689,'ycy70','70',80,1,5,19,'Numeric'),(690,'ycy70hv','70hv',80,2,5,19,'String'),(691,'ycy71','71',81,1,5,19,'Numeric'),(692,'ycy72','72',82,1,5,19,'Numeric'),(693,'ycy73','73',83,1,5,19,'Numeric'),(694,'ycy74','74',84,1,5,19,'Numeric'),(695,'ycy75','75',85,1,5,19,'Numeric'),(696,'ycy76','76',86,1,5,19,'Numeric'),(697,'ycy77','77',87,1,5,19,'Numeric'),(698,'ycy78','78',88,1,5,19,'Numeric'),(699,'ycy79','79',89,1,5,19,'Numeric'),(700,'ycy79hv','79hv',89,2,5,19,'String'),(701,'ycy80','80',90,1,5,19,'Numeric'),(702,'ycy81','81',91,1,5,19,'Numeric'),(703,'ycy82','82',92,1,5,19,'Numeric'),(704,'ycy83','83',93,1,5,19,'Numeric'),(705,'ycy83hv','83hv',93,2,5,19,'String'),(706,'ycy84','84',94,1,5,19,'Numeric'),(707,'ycy84hv','84hv',94,2,5,19,'String'),(708,'ycy85','85',95,1,5,19,'Numeric'),(709,'ycy85hv','85hv',95,2,5,19,'String'),(710,'ycy86','86',96,1,5,19,'Numeric'),(711,'ycy87','87',97,1,5,19,'Numeric'),(712,'ycy88','88',98,1,5,19,'Numeric'),(713,'ycy89','89',99,1,5,19,'Numeric'),(714,'ycy90','90',100,1,5,19,'Numeric'),(715,'ycy91','91',101,1,5,19,'Numeric'),(716,'ycy92','92',102,1,5,19,'Numeric'),(717,'ycy93','93',103,1,5,19,'Numeric'),(718,'ycy94','94',104,1,5,19,'Numeric'),(719,'ycy95','95',105,1,5,19,'Numeric'),(720,'ycy96','96',106,1,5,19,'Numeric'),(721,'ycy97','97',107,1,5,19,'Numeric'),(722,'ycy98','98',108,1,5,19,'Numeric'),(723,'ycy99','99',109,1,5,19,'Numeric'),(724,'ycy100','100',110,1,5,19,'Numeric'),(725,'ycy100hv','100hv',110,2,5,19,'String'),(726,'ycy101','101',111,1,5,19,'Numeric'),(727,'ycy102','102',112,1,5,19,'Numeric'),(728,'ycy103','103',113,1,5,19,'Numeric'),(729,'ycy104','104',114,1,5,19,'Numeric'),(730,'ycy105','105',115,1,5,19,'Numeric'),(731,'ycy105hv','105hv',115,2,5,19,'String'),(732,'ycy106','106',116,1,5,19,'Numeric'),(733,'ycy107','107',117,1,5,19,'Numeric'),(734,'ycy108','108',118,1,5,19,'Numeric'),(735,'ycy109','109',119,1,5,19,'Numeric'),(736,'ycy110','110',120,1,5,19,'Numeric'),(737,'ycy111','111',121,1,5,19,'Numeric'),(738,'ycy112','112',122,1,5,19,'Numeric'),(739,'ccyiaspt','',3,2,2,1,'Numeric'),(740,'ccyibspt','',4,2,2,1,'Numeric'),(741,'ccyicspt','',5,2,2,1,'Numeric'),(742,'ccyiasp','',3,1,2,1,'Numeric'),(743,'ccyibsp','',4,1,2,1,'Numeric'),(744,'ccyicsp','',5,1,2,1,'Numeric'),(745,'ccyiiah','',3,1,2,2,'Numeric'),(746,'ccyiiaht','',3,2,2,2,'Numeric'),(747,'ccyiibh','',4,1,2,2,'Numeric'),(748,'ccyiich','',5,1,2,2,'Numeric'),(749,'ccyiibht','',4,2,2,2,'Numeric'),(750,'ccyiicht','',5,2,2,2,'Numeric'),(751,'ccyiiiaa','',3,2,2,3,'Numeric'),(752,'ccyiiiba','',4,2,2,3,'Numeric'),(753,'ccyiiica','',5,2,2,3,'Numeric'),(754,'ccyivja','',3,1,2,4,'Numeric'),(755,'ccyivjb','',4,1,2,4,'Numeric'),(756,'ccyivjc','',5,1,2,4,'Numeric'),(757,'caviian1','',8,1,2,7,'Numeric'),(758,'caviian2','',9,1,2,7,'Numeric'),(759,'ctcunder','',10,2,2,7,'Numeric'),(760,'ctcgaaom','',11,2,2,7,'Numeric'),(761,'ycyispor','',2,1,5,51,'Numeric'),(762,'ycyiaspt','',3,2,5,51,'Numeric'),(763,'ycyibspt','',4,2,5,51,'Numeric'),(764,'ycyicspt','',5,2,5,51,'Numeric'),(765,'ycyiasp','',3,1,5,51,'Numeric'),(766,'ycyibsp','',4,1,5,51,'Numeric'),(767,'ycyicsp','',5,1,5,51,'Numeric'),(768,'ycyiaht','',3,2,5,52,'Numeric'),(769,'ycyiah','',3,1,5,52,'Numeric'),(770,'ycyibh','',4,1,5,52,'Numeric'),(771,'ycyibht','',4,2,5,52,'Numeric'),(772,'ycyicht','',5,2,5,52,'Numeric'),(773,'ycyich','',5,1,5,52,'Numeric'),(774,'ycyiiia','',3,1,5,53,'Numeric'),(775,'ycyiiib','',4,1,5,53,'Numeric'),(776,'ycyiiic','',5,1,5,53,'Numeric'),(777,'ycyivja','',3,1,5,54,'Numeric'),(778,'ycyivjb','',4,1,5,54,'Numeric'),(779,'ycyivjc','',5,1,5,54,'Numeric'),(780,'yaviian1','',7,1,5,57,'Numeric'),(781,'yaviian2','',8,1,5,57,'Numeric'),(782,'ttkent','',1,2,4,224,'Numeric'),(783,'ttfag','',1,2,4,216,'String'),(784,'ttcunder','',1,2,4,276,'Numeric'),(785,'ttcundty','',1,3,4,276,'Numeric'),(786,'ttcgaaom','',1,2,4,277,'Numeric'),(787,'taviivu1','',8,2,4,219,'Numeric'),(788,'taviilae','',3,2,4,219,'Numeric'),(789,'taviista','',4,2,4,219,'Numeric'),(790,'taviimat','',5,2,4,219,'Numeric'),(791,'taviinat','',6,2,4,219,'Numeric'),(792,'taviieng','',7,2,4,219,'Numeric'),(793,'ttviiiar','',2,2,4,220,'Numeric'),(794,'ttviiiop','',3,2,4,220,'Numeric'),(795,'ttviiila','',4,2,4,220,'Numeric'),(796,'ccfoduge','',2,3,1,10,'Numeric');
/*!40000 ALTER TABLE `variables` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-06-09 19:43:21
