-- MySQL dump 10.13  Distrib 5.1.40, for apple-darwin10.2.0 (i386)
--
-- Host: localhost    Database: cbcl_test
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
-- Table structure for table `answer_cells`
--

DROP TABLE IF EXISTS `answer_cells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer_id` int(11) NOT NULL DEFAULT '0',
  `col` int(11) NOT NULL DEFAULT '0',
  `row` int(11) NOT NULL DEFAULT '0',
  `item` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rating` tinyint(1) DEFAULT NULL,
  `value_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text` tinyint(1) DEFAULT NULL,
  `cell_type` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answer_cells_on_answer_id` (`answer_id`),
  KEY `index_answer_cells_on_row` (`row`),
  CONSTRAINT `fk_answer_cells_answers` FOREIGN KEY (`answer_id`) REFERENCES `answers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer_cells`
--

LOCK TABLES `answer_cells` WRITE;
/*!40000 ALTER TABLE `answer_cells` DISABLE KEYS */;
/*!40000 ALTER TABLE `answer_cells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_answer_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `ratings_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_answers_questions` (`question_id`),
  KEY `index_answers_on_survey_answer_id` (`survey_answer_id`),
  KEY `index_answers_on_number` (`number`),
  CONSTRAINT `fk_answers_questions` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `fk_answers_survey_answers` FOREIGN KEY (`survey_answer_id`) REFERENCES `survey_answers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `center_infos`
--

DROP TABLE IF EXISTS `center_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `center_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `center_id` int(11) DEFAULT NULL,
  `street` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telephone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ean` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `person` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_center_infos_centers` (`center_id`),
  CONSTRAINT `fk_center_infos_centers` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `center_infos`
--

LOCK TABLES `center_infos` WRITE;
/*!40000 ALTER TABLE `center_infos` DISABLE KEYS */;
/*!40000 ALTER TABLE `center_infos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `center_settings`
--

DROP TABLE IF EXISTS `center_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `center_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `center_id` int(11) DEFAULT NULL,
  `settings` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `center_settings`
--

LOCK TABLES `center_settings` WRITE;
/*!40000 ALTER TABLE `center_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `center_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copies`
--

DROP TABLE IF EXISTS `copies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `copies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) NOT NULL DEFAULT '0',
  `used` int(11) NOT NULL DEFAULT '0',
  `consolidated` tinyint(1) DEFAULT '0',
  `consolidated_on` date DEFAULT NULL,
  `created_on` date DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copies`
--

LOCK TABLES `copies` WRITE;
/*!40000 ALTER TABLE `copies` DISABLE KEYS */;
/*!40000 ALTER TABLE `copies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `csv_answers`
--

DROP TABLE IF EXISTS `csv_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `csv_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_answer_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `journal_entry_id` int(11) DEFAULT NULL,
  `journal_id` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL,
  `answer` text COLLATE utf8_unicode_ci,
  `header` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `journal_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_csv_answers_survey_answers` (`survey_answer_id`),
  CONSTRAINT `fk_csv_answers_survey_answers` FOREIGN KEY (`survey_answer_id`) REFERENCES `survey_answers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `csv_answers`
--

LOCK TABLES `csv_answers` WRITE;
/*!40000 ALTER TABLE `csv_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `csv_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `export_files`
--

DROP TABLE IF EXISTS `export_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `export_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_files`
--

LOCK TABLES `export_files` WRITE;
/*!40000 ALTER TABLE `export_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `export_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faq_sections`
--

DROP TABLE IF EXISTS `faq_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faq_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq_sections`
--

LOCK TABLES `faq_sections` WRITE;
/*!40000 ALTER TABLE `faq_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `faq_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faqs`
--

DROP TABLE IF EXISTS `faqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faq_section_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `question` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `answer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_faqs_faq_sections` (`faq_section_id`),
  CONSTRAINT `fk_faqs_faq_sections` FOREIGN KEY (`faq_section_id`) REFERENCES `faq_sections` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faqs`
--

LOCK TABLES `faqs` WRITE;
/*!40000 ALTER TABLE `faqs` DISABLE KEYS */;
/*!40000 ALTER TABLE `faqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `code` int(11) DEFAULT NULL,
  `type` varchar(16) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `parent_id` int(11) DEFAULT NULL,
  `center_id` int(11) DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_groups_on_center_id` (`center_id`),
  KEY `index_groups_on_code` (`code`),
  KEY `index_groups_on_delta` (`delta`),
  KEY `index_groups_on_type` (`type`),
  KEY `index_groups_on_parent_id` (`parent_id`),
  CONSTRAINT `fk_groups_parents` FOREIGN KEY (`parent_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fk_groups_centers` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_roles`
--

DROP TABLE IF EXISTS `groups_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups_roles` (
  `group_id` int(11) NOT NULL DEFAULT '0',
  `role_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `groups_roles_all_index` (`group_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `fk_groups_roles_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_groups_roles_groups` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_roles`
--

LOCK TABLES `groups_roles` WRITE;
/*!40000 ALTER TABLE `groups_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_users`
--

DROP TABLE IF EXISTS `groups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups_users` (
  `group_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `groups_users_all_index` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fk_groups_users_groups` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fk_groups_users_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_users`
--

LOCK TABLES `groups_users` WRITE;
/*!40000 ALTER TABLE `groups_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal_entries`
--

DROP TABLE IF EXISTS `journal_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `journal_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL,
  `survey_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `survey_answer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `answered_at` datetime DEFAULT NULL,
  `state` int(11) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_journal_entries_journals` (`journal_id`),
  KEY `fk_journal_entries_surveys` (`survey_id`),
  KEY `fk_journal_entries_users` (`user_id`),
  CONSTRAINT `fk_journal_entries_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_journal_entries_journals` FOREIGN KEY (`journal_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fk_journal_entries_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal_entries`
--

LOCK TABLES `journal_entries` WRITE;
/*!40000 ALTER TABLE `journal_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `letters`
--

DROP TABLE IF EXISTS `letters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `letters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `letter` text COLLATE utf8_unicode_ci,
  `surveytype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_letters_groups` (`group_id`),
  CONSTRAINT `fk_letters_groups` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `letters`
--

LOCK TABLES `letters` WRITE;
/*!40000 ALTER TABLE `letters` DISABLE KEYS */;
/*!40000 ALTER TABLE `letters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nationalities`
--

DROP TABLE IF EXISTS `nationalities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nationalities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_code` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nationalities`
--

LOCK TABLES `nationalities` WRITE;
/*!40000 ALTER TABLE `nationalities` DISABLE KEYS */;
/*!40000 ALTER TABLE `nationalities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periods`
--

DROP TABLE IF EXISTS `periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `periods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) NOT NULL,
  `used` int(11) NOT NULL DEFAULT '0',
  `paid` tinyint(1) DEFAULT '0',
  `paid_on` date DEFAULT NULL,
  `created_on` date DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_periods_subscriptions` (`subscription_id`),
  CONSTRAINT `fk_periods_subscriptions` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periods`
--

LOCK TABLES `periods` WRITE;
/*!40000 ALTER TABLE `periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person_infos`
--

DROP TABLE IF EXISTS `person_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sex` int(11) NOT NULL,
  `birthdate` date NOT NULL,
  `nationality` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `cpr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT '1',
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_person_infos_journals` (`journal_id`),
  CONSTRAINT `fk_person_infos_journals` FOREIGN KEY (`journal_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person_infos`
--

LOCK TABLES `person_infos` WRITE;
/*!40000 ALTER TABLE `person_infos` DISABLE KEYS */;
/*!40000 ALTER TABLE `person_infos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_cells`
--

DROP TABLE IF EXISTS `question_cells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `type` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `col` int(11) DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `answer_item` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `items` text COLLATE utf8_unicode_ci,
  `preferences` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `datatype` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_question_cells_questions` (`question_id`),
  CONSTRAINT `fk_question_cells_questions` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_cells`
--

LOCK TABLES `question_cells` WRITE;
/*!40000 ALTER TABLE `question_cells` DISABLE KEYS */;
/*!40000 ALTER TABLE `question_cells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `ratings_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_questions_surveys` (`survey_id`),
  CONSTRAINT `fk_questions_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `roles_parent_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `role_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  UNIQUE KEY `roles_users_all_index` (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `fk_roles_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_roles_users_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('1'),('10'),('11'),('12'),('13'),('14'),('15'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_groups`
--

DROP TABLE IF EXISTS `score_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_groups`
--

LOCK TABLES `score_groups` WRITE;
/*!40000 ALTER TABLE `score_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `score_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_items`
--

DROP TABLE IF EXISTS `score_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `items` text COLLATE utf8_unicode_ci,
  `range` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qualifier` int(11) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_score_items_scores` (`score_id`),
  CONSTRAINT `fk_score_items_scores` FOREIGN KEY (`score_id`) REFERENCES `scores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_items`
--

LOCK TABLES `score_items` WRITE;
/*!40000 ALTER TABLE `score_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `score_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_rapports`
--

DROP TABLE IF EXISTS `score_rapports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_rapports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `survey_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `survey_answer_id` int(11) DEFAULT NULL,
  `unanswered` int(11) DEFAULT NULL,
  `gender` int(11) NOT NULL,
  `age_group` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `age` int(11) DEFAULT NULL,
  `center_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_score_rapports_survey_answers` (`survey_answer_id`),
  KEY `fk_score_rapports_centers` (`center_id`),
  CONSTRAINT `fk_score_rapports_centers` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fk_score_rapports_survey_answers` FOREIGN KEY (`survey_answer_id`) REFERENCES `survey_answers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_rapports`
--

LOCK TABLES `score_rapports` WRITE;
/*!40000 ALTER TABLE `score_rapports` DISABLE KEYS */;
/*!40000 ALTER TABLE `score_rapports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_refs`
--

DROP TABLE IF EXISTS `score_refs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_refs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_id` int(11) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `age_group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mean` float DEFAULT NULL,
  `percent95` int(11) DEFAULT NULL,
  `percent98` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_score_refs_scores` (`score_id`),
  CONSTRAINT `fk_score_refs_scores` FOREIGN KEY (`score_id`) REFERENCES `scores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_refs`
--

LOCK TABLES `score_refs` WRITE;
/*!40000 ALTER TABLE `score_refs` DISABLE KEYS */;
/*!40000 ALTER TABLE `score_refs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_results`
--

DROP TABLE IF EXISTS `score_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_rapport_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `score_id` int(11) DEFAULT NULL,
  `result` int(11) DEFAULT NULL,
  `percentile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scale` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `score_scale_id` int(11) DEFAULT NULL,
  `missing` int(11) DEFAULT '0',
  `missing_percentage` float DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `valid_percentage` tinyint(1) DEFAULT NULL,
  `mean` float DEFAULT NULL,
  `deviation` tinyint(1) DEFAULT NULL,
  `percentile_98` tinyint(1) DEFAULT NULL,
  `percentile_95` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_score_results_score_rapports` (`score_rapport_id`),
  CONSTRAINT `fk_score_results_score_rapports` FOREIGN KEY (`score_rapport_id`) REFERENCES `score_rapports` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_results`
--

LOCK TABLES `score_results` WRITE;
/*!40000 ALTER TABLE `score_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `score_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `score_scales`
--

DROP TABLE IF EXISTS `score_scales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score_scales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score_scales`
--

LOCK TABLES `score_scales` WRITE;
/*!40000 ALTER TABLE `score_scales` DISABLE KEYS */;
/*!40000 ALTER TABLE `score_scales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_group_id` int(11) DEFAULT NULL,
  `survey_id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sum` int(11) NOT NULL,
  `scale` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `score_scale_id` int(11) DEFAULT NULL,
  `items_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_scores_surveys` (`survey_id`),
  KEY `fk_scores_score_groups` (`score_group_id`),
  CONSTRAINT `fk_scores_score_groups` FOREIGN KEY (`score_group_id`) REFERENCES `score_groups` (`id`),
  CONSTRAINT `fk_scores_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores`
--

LOCK TABLES `scores` WRITE;
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scores_surveys`
--

DROP TABLE IF EXISTS `scores_surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scores_surveys` (
  `score_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  KEY `index_scores_surveys_on_score_id` (`score_id`),
  KEY `index_scores_surveys_on_survey_id` (`survey_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores_surveys`
--

LOCK TABLES `scores_surveys` WRITE;
/*!40000 ALTER TABLE `scores_surveys` DISABLE KEYS */;
/*!40000 ALTER TABLE `scores_surveys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `center_id` int(11) NOT NULL,
  `survey_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` int(11) NOT NULL,
  `note` text COLLATE utf8_unicode_ci,
  `total_used` int(11) DEFAULT NULL,
  `total_paid` int(11) DEFAULT NULL,
  `active_used` int(11) DEFAULT NULL,
  `most_recent_payment` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_subscriptions_centers` (`center_id`),
  KEY `fk_subscriptions_surveys` (`survey_id`),
  CONSTRAINT `fk_subscriptions_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`),
  CONSTRAINT `fk_subscriptions_centers` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_answers`
--

DROP TABLE IF EXISTS `survey_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `survey_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `surveytype` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `answered_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `age` int(11) NOT NULL,
  `sex` int(11) NOT NULL,
  `nationality` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `journal_entry_id` int(11) NOT NULL,
  `done` tinyint(1) DEFAULT '0',
  `journal_id` int(11) DEFAULT NULL,
  `center_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_survey_answers_journals` (`journal_id`),
  KEY `fk_survey_answers_surveys` (`survey_id`),
  KEY `fk_survey_answers_centers` (`center_id`),
  KEY `fk_survey_answers_journal_entry` (`journal_entry_id`),
  CONSTRAINT `fk_survey_answers_journal_entry` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`),
  CONSTRAINT `fk_survey_answers_centers` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fk_survey_answers_journals` FOREIGN KEY (`journal_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `fk_survey_answers_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_answers`
--

LOCK TABLES `survey_answers` WRITE;
/*!40000 ALTER TABLE `survey_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `survey_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surveys`
--

DROP TABLE IF EXISTS `surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `age` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `surveytype` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT '99',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surveys`
--

LOCK TABLES `surveys` WRITE;
/*!40000 ALTER TABLE `surveys` DISABLE KEYS */;
/*!40000 ALTER TABLE `surveys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `export_file_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `last_logged_in_at` datetime NOT NULL,
  `login_failure_count` int(11) NOT NULL DEFAULT '0',
  `login` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `email` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `password_hash_type` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `password_salt` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '1234512345',
  `state` int(11) NOT NULL DEFAULT '1',
  `center_id` int(11) DEFAULT NULL,
  `login_user` tinyint(1) DEFAULT '0',
  `delta` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_center_id_index` (`center_id`),
  KEY `users_password_index` (`password`),
  CONSTRAINT `fk_users_centers` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variables`
--

DROP TABLE IF EXISTS `variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `col` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `datatype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_variables_surveys` (`survey_id`),
  KEY `fk_variables_questions` (`question_id`),
  CONSTRAINT `fk_variables_questions` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `fk_variables_surveys` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variables`
--

LOCK TABLES `variables` WRITE;
/*!40000 ALTER TABLE `variables` DISABLE KEYS */;
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

-- Dump completed on 2011-05-29 21:58:04
