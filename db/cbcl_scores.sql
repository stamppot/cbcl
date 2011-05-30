-- SET CHARACTER SET utf8;
--
-- Dumping data for table `score_groups`
--
LOCK TABLES `score_groups` WRITE;
INSERT INTO `score_groups` VALUES (1,'CBCL Skemaer','Alle skemaer relateret til CBCL.');
UNLOCK TABLES;
--
-- Dumping data for table `scores`
--
LOCK TABLES `scores` WRITE;
INSERT INTO `scores` VALUES (1,1,1,'Total problem score','CBCL',1,0,1,1,100,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(2,1,2,'Eksternalisering','CBCL',1,0,2,1,35,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(3,1,2,'Internalisering','CBCL',1,0,3,1,32,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(23,1,5,'Total Problem Score','YSR',1,0,1,1,105,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(24,1,5,'Eksternalisering','YSR',1,0,2,1,32,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(25,1,5,'Internalisering','YSR',1,0,3,1,31,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(26,1,4,'Total Problem Score','TRF',1,0,1,1,119,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(27,1,4,'Eksternalisering','TRF',1,0,2,1,34,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(28,1,4,'Internalisering','TRF',1,0,3,1,32,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(30,1,1,'Angst problemer','CBCL',1,0,2,3,10,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(31,1,1,'Affektive problemer','CBCL',1,3,1,3,10,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(35,1,1,'Gennemgribende udv.forst.probl.','CBCL',1,0,4,3,13,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(36,1,1,'ADHD problemer','CBCL',1,0,4,3,6,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(37,1,1,'Oppositionelle adfÃ¦rdsproblemer','CBCL',1,0,4,3,6,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(38,1,1,'Eksternalisering','CBCL',1,0,2,1,24,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(39,1,1,'Internalisering','CBCL',1,0,3,1,36,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(40,1,2,'Total problem score','CBCL',1,0,1,1,119,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(41,1,3,'Total problem score','C-TRF',1,0,1,1,100,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(42,1,3,'Eksternalisering','C-TRF',1,0,2,1,24,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(43,1,3,'Internalisering','C-TRF',1,0,3,1,36,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(44,1,3,'Affektive problemer','C-TRF',1,0,1,3,10,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(45,1,3,'Gennemgribende udv.forst.probl.','C-TRF',1,0,4,3,13,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(47,NULL,3,'Angst problemer','C-TRF',1,NULL,2,3,10,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(48,NULL,3,'ADHD problemer','C-TRF',1,NULL,4,3,6,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(49,NULL,3,'Oppositionelle adfÃ¦rdsproblemer','C-TRF',1,NULL,4,3,6,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(51,NULL,2,'ADHD problemer','CBCL',1,NULL,4,3,7,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(52,NULL,2,'Affektive problemer','CBCL',1,NULL,1,3,13,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(53,NULL,2,'Angst problemer','CBCL',1,NULL,2,3,6,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(54,NULL,2,'Somatisering','CBCL',1,NULL,3,3,7,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(55,NULL,2,'Oppositionelle adfÃ¦rdsproblemer','CBCL',1,NULL,4,3,5,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(56,NULL,2,'AdfÃ¦rdsforstyrrelse','CBCL',1,NULL,5,3,17,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(57,NULL,4,'ADHD problemer','TRF',1,NULL,4,3,13,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(60,NULL,4,'Affektive problemer','TRF',1,NULL,1,3,10,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(61,NULL,4,'Angst problemer','TRF',1,NULL,2,3,6,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(62,NULL,4,'Somatisering','TRF',1,NULL,3,3,7,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(63,NULL,4,'Oppositionelle adfÃ¦rdsproblemer','TRF',1,NULL,4,3,5,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(64,NULL,4,'AdfÃ¦rdsforstyrrelse','TRF',1,NULL,5,3,13,'2010-01-05 14:12:47','2011-01-05 22:12:47'),
(65,NULL,5,'Affektive problemer','YSR',1,NULL,6,3,13,'2011-05-17 19:37:19','2011-05-17 19:41:52'),
(66,NULL,5,'Angst problemer','YSR',1,NULL,7,3,6,'2011-05-17 19:46:38','2011-05-17 19:50:48'),
(67,NULL,5,'Somatisering','YSR',1,NULL,8,3,7,'2011-05-17 19:55:09','2011-05-17 19:57:27'),
(68,NULL,5,'ADHD problemer','YSR',1,NULL,9,3,7,'2011-05-19 10:09:25','2011-05-19 10:12:31'),
(69,NULL,5,'Oppositionelle adfÃ¦rdsproblemer','YSR',1,NULL,10,3,5,'2011-05-19 10:13:17','2011-05-19 10:14:57'),
(70,NULL,5,'AdfÃ¦rdsforstyrrelse','YSR',1,NULL,11,3,15,'2011-05-19 10:15:29','2011-05-19 10:18:01');

UNLOCK TABLES;
--
-- Dumping data for table `score_items`
--
LOCK TABLES `score_items` WRITE;
INSERT INTO `score_items` VALUES (7,1,20,'','0-236',1,10);
INSERT INTO `score_items` VALUES (8,2,20,'2,3,16,19,20,21,22,23,26,28,37,39,43,57,63,67,68,72,73,81,82,86,87,88,89,90,94,95,96,97,99,101,104,105,106','0-70',0,10);
INSERT INTO `score_items` VALUES (14,10,20,'9,18,40,46,58,59,60,66,70,76,83,84,85,92,100','0-30',0,10);
INSERT INTO `score_items` VALUES (15,15,19,'7,16,19,20,21,22,23,25,26,37,38,43,57,67,68,74,81,82,87,90,93,94,95,97,104','0-25',0,8);
INSERT INTO `score_items` VALUES (16,16,19,'1,8,10,13,19,20,25,41,48,62,64,104','0-12',0,8);
INSERT INTO `score_items` VALUES (17,17,19,'12,14,31,33,34,35,52,91,103,112','0-10',0,8);
INSERT INTO `score_items` VALUES (62,26,18,'','0-236',1,12);
INSERT INTO `score_items` VALUES (66,27,18,'3,6,15,16,19,20,21,22,23,26,28,37,39,43,57,63,67,68,76,81,82,86,87,88,89,90,94,95,96,97,99,101,104,105','0-68',0,12);
INSERT INTO `score_items` VALUES (68,9,20,'11,12,25,27,34,36,38,48,62,64,79','0-22',0,10);
INSERT INTO `score_items` VALUES (71,28,18,'5,14,29,30,31,32,33,35,42,45,47,50,51,52,54,56a,56b,56c,56d,56e,56f,56g,65,69,71,75,81,91,102,103,111,112','0-64',0,12);
INSERT INTO `score_items` VALUES (91,18,19,'17,29,45,50,65,66,70,71,75,84,85,111','0-12',0,8);
INSERT INTO `score_items` VALUES (92,19,18,'7,16,19,20,21,23,25,26,37,38,43,57,68,74,82,87,88,90,93,94,95,97,104','0-23',0,12);
INSERT INTO `score_items` VALUES (93,20,18,'1,8,10,13,19,20,25,41,48,62,64,104','0-12',0,12);
INSERT INTO `score_items` VALUES (94,21,18,'12,14,31,33,34,35,52,91,103,112','0-10',0,12);
INSERT INTO `score_items` VALUES (95,22,18,'17,29,45,50,65,66,70,71,75,80,84,85,111','0-13',0,12);
INSERT INTO `score_items` VALUES (96,23,19,'6,15,28,49,59,60,73,78,80,88,92,98,106,107,108,109','0-200',2,8);
INSERT INTO `score_items` VALUES (97,24,19,'3,7,16,19,20,21,23,26,27,37,39,43,57,63,67,68,72,74,81,82,86,87,90,93,94,95,97,101,104,105','0-60',0,8);
INSERT INTO `score_items` VALUES (98,25,19,'12,14,18,31,32,33,34,35,42,45,50,51,52,54,56a,56b,56c,56d,56e,56f,56g,65,69,71,75,89,91,102,103,111,112','0-62',0,8);
INSERT INTO `score_items` VALUES (99,3,20,'5,14,29,30,31,32,33,35,42,45,47,49,50,51,52,54,56a,56b,56c,56d,56e,56f,56g,65,69,71,75,91,102,103,111,112','0-64',0,10);
INSERT INTO `score_items` VALUES (102,13,20,'3,16,19,20,21,22,23,37,57,68,86,87,88,89,94,95,97,104','0-36',0,10);
INSERT INTO `score_items` VALUES (103,8,20,'14,29,30,31,32,33,35,45,50,52,71,91,112','0-26',0,10);
INSERT INTO `score_items` VALUES (107,14,20,'47,49,51,54,56a,56b,56c,56d,56e,56f,56g','0-22',0,10);
INSERT INTO `score_items` VALUES (112,12,20,'2,26,28,39,43,63,67,72,73,81,82,90,96,99,101,105,106','0-34',0,10);
INSERT INTO `score_items` VALUES (115,11,20,'1,4,8,10,13,17,41,61,78,80','0-20',0,10);
INSERT INTO `score_items` VALUES (118,4,20,'7,16,19,20,21,22,23,25,26,37,38,43,57,67,68,74,81,82,87,88,90,93,94,95,97,104,106','0-27',0,10);
INSERT INTO `score_items` VALUES (121,5,20,'12,14,31,33,34,35,52,91,103,112','0-10',0,10);
INSERT INTO `score_items` VALUES (124,6,20,'17,29,45,50,65,66,70,71,75,80,84,85,111','0-13',0,10);
INSERT INTO `score_items` VALUES (127,7,20,'1,8,10,13,19,20,25,41,48,62,64,104','0-12',0,10);
INSERT INTO `score_items` VALUES (133,29,20,'5,42,65,69,75,102,103,111','0-16',0,10);
INSERT INTO `score_items` VALUES (134,30,25,'10,22,28,32,37,47,48,51,87,99','0-20',0,1);
INSERT INTO `score_items` VALUES (135,31,25,'13,24,38,43,49,50,71,74,89,90','0-20',0,1);
--
-- Dumping data for table `score_refs`
--
LOCK TABLES `score_refs` WRITE;
INSERT INTO `score_refs` VALUES (1,1,1,'4-10',20.2,56,69);
INSERT INTO `score_refs` VALUES (2,1,2,'4-10',15.8,36,45);
INSERT INTO `score_refs` VALUES (3,1,1,'11-16',19,55,85);
INSERT INTO `score_refs` VALUES (4,1,2,'11-16',16.4,48,68);
INSERT INTO `score_refs` VALUES (5,2,1,'4-10',7.7,20,26);
INSERT INTO `score_refs` VALUES (6,2,2,'4-10',5.6,17,20);
INSERT INTO `score_refs` VALUES (7,2,1,'11-16',7,23,29);
INSERT INTO `score_refs` VALUES (8,2,2,'11-16',5.3,15,22);
INSERT INTO `score_refs` VALUES (9,3,1,'4-10',4.5,15,17);
INSERT INTO `score_refs` VALUES (10,3,2,'4-10',3.9,12,15);
INSERT INTO `score_refs` VALUES (11,3,1,'11-16',5.4,17,26);
INSERT INTO `score_refs` VALUES (12,3,2,'11-16',5,14,22);
INSERT INTO `score_refs` VALUES (13,4,1,'4-10',4.8,14,15);
INSERT INTO `score_refs` VALUES (14,4,2,'4-10',3.3,11,13);
INSERT INTO `score_refs` VALUES (15,4,1,'11-16',4.1,15,18);
INSERT INTO `score_refs` VALUES (16,4,2,'11-16',2.9,10,12);
INSERT INTO `score_refs` VALUES (17,7,1,'4-10',2.7,8,9);
INSERT INTO `score_refs` VALUES (18,7,2,'4-10',1.5,5,6);
INSERT INTO `score_refs` VALUES (19,7,1,'11-16',2.4,8,11);
INSERT INTO `score_refs` VALUES (20,7,2,'11-16',1.5,6,7);
INSERT INTO `score_refs` VALUES (21,5,1,'4-10',1.4,6,7);
INSERT INTO `score_refs` VALUES (22,5,2,'4-10',1.3,5,7);
INSERT INTO `score_refs` VALUES (23,5,1,'11-16',1.6,7,8);
INSERT INTO `score_refs` VALUES (24,5,2,'11-16',1.6,6,8);
INSERT INTO `score_refs` VALUES (25,6,1,'4-10',1.7,5,7);
INSERT INTO `score_refs` VALUES (26,6,2,'4-10',1.7,5,6);
INSERT INTO `score_refs` VALUES (27,6,1,'11-16',1.6,4,7);
INSERT INTO `score_refs` VALUES (28,6,2,'11-16',1.7,5,6);
INSERT INTO `score_refs` VALUES (29,15,1,'11-16',6.5,16,18);
INSERT INTO `score_refs` VALUES (30,15,2,'11-16',5.1,11,13);
INSERT INTO `score_refs` VALUES (31,16,1,'11-16',3.3,9,10);
INSERT INTO `score_refs` VALUES (32,16,2,'11-16',3,7,9);
INSERT INTO `score_refs` VALUES (33,17,1,'11-16',2,7,8);
INSERT INTO `score_refs` VALUES (34,17,2,'11-16',2.7,8,9);
INSERT INTO `score_refs` VALUES (35,18,1,'11-16',2.7,8,10);
INSERT INTO `score_refs` VALUES (36,18,2,'11-16',3.6,8,9);
INSERT INTO `score_refs` VALUES (37,19,1,'6-10',3.3,15,19);
INSERT INTO `score_refs` VALUES (38,19,2,'6-10',1.2,7,11);
INSERT INTO `score_refs` VALUES (39,19,1,'11-16',2.9,11,15);
INSERT INTO `score_refs` VALUES (40,19,2,'11-16',2,10,11);
INSERT INTO `score_refs` VALUES (41,20,1,'6-10',2.4,9,10);
INSERT INTO `score_refs` VALUES (42,20,2,'6-10',1,5,8);
INSERT INTO `score_refs` VALUES (43,20,1,'11-16',2.5,9,10);
INSERT INTO `score_refs` VALUES (44,20,2,'11-16',1.6,7,8);
INSERT INTO `score_refs` VALUES (45,21,1,'6-10',1.3,6,7);
INSERT INTO `score_refs` VALUES (46,21,2,'6-10',1.1,5,7);
INSERT INTO `score_refs` VALUES (47,21,1,'11-16',0.9,5,6);
INSERT INTO `score_refs` VALUES (48,21,2,'11-16',1.3,5,7);
INSERT INTO `score_refs` VALUES (49,22,1,'6-10',1.4,5,6);
INSERT INTO `score_refs` VALUES (50,22,2,'6-10',1.4,5,7);
INSERT INTO `score_refs` VALUES (51,22,1,'11-16',1.1,4,6);
INSERT INTO `score_refs` VALUES (53,22,2,'11-16',1.3,5,6);
INSERT INTO `score_refs` VALUES (54,23,1,'11-16',30,65,80);
INSERT INTO `score_refs` VALUES (55,23,2,'11-16',31.7,66,75);
INSERT INTO `score_refs` VALUES (56,24,1,'11-16',11,23,30);
INSERT INTO `score_refs` VALUES (57,24,2,'11-16',9.7,20,23);
INSERT INTO `score_refs` VALUES (58,25,1,'11-16',7.7,23,26);
INSERT INTO `score_refs` VALUES (59,25,2,'11-16',9.9,24,29);
INSERT INTO `score_refs` VALUES (60,26,1,'6-10',20.7,76,95);
INSERT INTO `score_refs` VALUES (61,26,2,'6-10',12.1,34,72);
INSERT INTO `score_refs` VALUES (62,26,1,'11-16',20,72,84);
INSERT INTO `score_refs` VALUES (63,26,2,'11-16',16.1,54,85);
INSERT INTO `score_refs` VALUES (64,27,1,'6-10',6.5,30,43);
INSERT INTO `score_refs` VALUES (65,27,2,'6-10',2.8,12,25);
INSERT INTO `score_refs` VALUES (66,27,1,'11-16',6.5,26,35);
INSERT INTO `score_refs` VALUES (67,27,2,'11-16',4.7,21,26);
INSERT INTO `score_refs` VALUES (68,28,1,'6-10',5.5,19,30);
INSERT INTO `score_refs` VALUES (69,28,2,'6-10',5.3,18,24);
INSERT INTO `score_refs` VALUES (70,28,1,'11-16',4.2,15,26);
INSERT INTO `score_refs` VALUES (71,28,2,'11-16',4.6,14,23);
UNLOCK TABLES;