# HeidiSQL Dump 
#
# --------------------------------------------------------
# Host:                 localhost
# Database:             cbcl_development
# Server version:       4.1.22-community-log
# Server OS:            Win32
# HeidiSQL version:     3.0 RC3 Revision: 111
# --------------------------------------------------------
-- SET CHARACTER SET utf8;
#
# Database structure for database 'cbcl_development'
#
#CREATE DATABASE IF NOT EXISTS `cbcl_development`;
#USE `cbcl_development`;
DROP TABLE IF EXISTS user_registrations;
DROP TABLE IF EXISTS roles_users;
DROP TABLE IF EXISTS roles_static_permissions;
DROP TABLE IF EXISTS groups_users;
DROP TABLE IF EXISTS groups_roles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS static_permissions;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS groups;
# This is database creation SQL script in MySQL dialect.

#----------------------------
# Table structure for groups
#  code and type were added
#----------------------------
CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `title` varchar(200) NOT NULL default '',
  `code` int(4) unsigned default NULL,
  `type` varchar(16) NOT NULL default '',
  `parent_id` int(10) unsigned default NULL,
	`center_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `groups_parent_id_index` (`parent_id`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION,
	KEY `groups_center_id_index` (`center_id`),
	CONSTRAINT `groups_ibfk_2` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for roles
#----------------------------
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL auto_increment,
	`identifier` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `title` varchar(100) NOT NULL default '',
  `parent_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `roles_parent_id_index` (`parent_id`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `roles` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for static_permissions
#----------------------------
CREATE TABLE `static_permissions` (
  `id` int(10) unsigned NOT NULL auto_increment,
	`identifier` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL default '',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `static_permissions_title_index` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for users
#----------------------------
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_logged_in_at` timestamp,
  `login_failure_count` int(10) unsigned NOT NULL default '0',
  `login` varchar(100) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `email` varchar(200) NOT NULL default '',
  `password` varchar(128) NOT NULL default '',
  `password_hash_type` varchar(10) NOT NULL default '',
  `password_salt` char(100) NOT NULL default '1234512345',
  `state` int(10) unsigned NOT NULL default '1',
  `center_id` int(10) unsigned NULL default NULL,
  `login_user` tinyint(1) unsigned NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_password_index` (`password`),
  KEY `users_center_id_index` (`center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for groups_roles
#----------------------------
CREATE TABLE `groups_roles` (
  `group_id` int(10) unsigned NOT NULL default '0',
  `role_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `groups_roles_all_index` (`group_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `groups_roles_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `groups_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for groups_users
#----------------------------
CREATE TABLE `groups_users` (
  `group_id` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`group_id`,`user_id`),
  UNIQUE KEY `groups_users_all_index` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `groups_users_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `groups_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for roles_static_permissions
#----------------------------
CREATE TABLE `roles_static_permissions` (
  `role_id` int(10) unsigned NOT NULL default '0',
  `static_permission_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `roles_static_permissions_all_index` (`static_permission_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_static_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `roles_static_permissions_ibfk_2` FOREIGN KEY (`static_permission_id`) REFERENCES `static_permissions` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for roles_users
#----------------------------
CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL default '0',
  `role_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `roles_users_all_index` (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;

#----------------------------
# Table structure for user_registrations
#----------------------------
CREATE TABLE `user_registrations` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `token` text NOT NULL,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `expires_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_registrations_user_id_index` (`user_id`),
  KEY `user_registrations_expires_at_index` (`expires_at`),
  CONSTRAINT `user_registrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COLLATE=utf8_danish_ci;
#
# Dumping data for table 'groups'
#
ALTER TABLE `groups` DISABLE KEYS;
LOCK TABLES `groups` WRITE;
INSERT INTO `groups` (`id`, `created_at`, `updated_at`, `title`, `parent_id`, `center_id`, `code`, `type`) VALUES ('1','2008-03-20 10:27:32','2008-03-20 10:27:32','Det børne- og ungdomspsykiatriske Hus',NULL,NULL,'4202','Center');
INSERT INTO `groups` (`id`, `created_at`, `updated_at`, `title`, `parent_id`, `center_id`, `code`, `type`) VALUES ('2','2007-01-17 18:38:16','2007-01-17 18:38:16','BUPH',NULL,NULL,'1000','Center');
INSERT INTO `groups` (`id`, `created_at`, `updated_at`, `title`, `parent_id`, `center_id`, `code`, `type`) VALUES ('3','2008-03-20 10:29:40','2008-03-20 10:29:40','Forskningsteam','1','1','350','Team');
UNLOCK TABLES;
ALTER TABLE `groups` ENABLE KEYS;
#
# Dumping data for table 'roles'
#
ALTER TABLE `roles` DISABLE KEYS;
LOCK TABLES `roles` WRITE;
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('10','2007-01-17 17:58:30','2007-01-17 17:58:30','login_bruger',NULL);
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('16','2007-01-17 17:57:51','2007-01-17 17:57:51','indtaster',NULL);
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('11','2007-01-17 17:59:43','2007-01-17 17:59:43','parent','10');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('12','2007-01-17 17:59:53','2007-01-17 17:59:53','teacher','10');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('13','2007-01-17 18:00:03','2007-01-17 18:00:03','pedagogue','10');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('14','2007-01-17 18:00:16','2007-01-17 18:00:16','youth','10');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('15','2007-01-17 18:00:16','2007-01-17 18:00:16','other','10');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('5','2007-01-17 17:56:56','2007-01-17 17:56:56','behandler',NULL);
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('4','2007-01-17 17:56:56','2007-01-17 17:56:56','teamadministrator','5');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('3','2007-01-17 17:57:11','2007-01-17 17:57:11',':centeradmin','4');
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('2','2007-01-17 17:57:30','2007-01-17 17:57:30','admin',NULL);
INSERT INTO `roles` (`id`, `created_at`, `updated_at`, `title`, `parent_id`) VALUES ('1','2007-01-17 17:57:40','2007-01-17 17:57:40','superadmin',NULL);
UNLOCK TABLES;
ALTER TABLE `roles` ENABLE KEYS;
#
# Dumping data for table 'users'
#
ALTER TABLE `users` DISABLE KEYS;
LOCK TABLES `users` WRITE;
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('5','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','cbcl-admin','CBCL Administrator','admin@test.dk','b2abc86652cec508579af52c006181b7','md5','DVXGApwOYP','2',NULL,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('4','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','superadmin','superadmin','stamppot@gmail.com','6563322ab85e26abaef99e483fffcd12','md5','S58h18RfGe','2',NULL,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('1','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','jens','Jens Rasmussen','stamppot@gmail.com','55664753bfaaeea23b7b1c380502d94a','md5','W2LeHQTHFM','2',NULL,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('2','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','Bente Anthony','Bente Anthony','test@test.dk','45cffaac640bff5260455d8094efe146','md5','H7XNZgTHfL','2',NULL,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('3','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','Niels Bilenberg','Niels Bilenberg','test@test.dk','0ce31b2c8697fa148e2b62529955108a','md5','vi00wMQnmM','2',NULL,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('10','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','Leo Lummerkrog','Leo Lummerkrog','lummerkrog@pladderballe.dk','b8a26f09d55cbda8407ce167cef418e6','md5','4wqDU/AaT7','2',2,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('11','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','Gombert','Gombert','gombert@pladderballe.dk','98a99f808a593a100175319d512f3065','md5','P77dDk4YvK','2',2,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('12','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','Flanhart','Flanhart','flanhart@pladderballe.dk','36597df79f8030a26162686f167c1c5f','md5','HrXHElkPrD','2',2,0);
INSERT INTO `users` (`id`, `created_at`, `updated_at`, `last_logged_in_at`, `login_failure_count`, `login`, `name`, `email`, `password`, `password_hash_type`, `password_salt`, `state`, `center_id`, `login_user`) VALUES ('15','2008-01-01 12:00:00','2008-01-01 12:00:00','2008-01-01 12:00:00','0','Tina Ravn','Tina Ravn','tina.ravn@ouh.regionsyddanmark.dk','7b44c209e304babfe3a21b25332039b9','md5','8eGZWXb9L9',2,1,0);
UNLOCK TABLES;
ALTER TABLE `users` ENABLE KEYS;
#
# Dumping data for table 'groups_users'
#
ALTER TABLE `groups_users` DISABLE KEYS;
LOCK TABLES `groups_users` WRITE;
INSERT INTO `groups_users` (`group_id`, `user_id`, `created_at`) VALUES ('2','10','2008-01-01 12:00:00');
INSERT INTO `groups_users` (`group_id`, `user_id`, `created_at`) VALUES ('3','11','2008-01-01 12:00:00');
INSERT INTO `groups_users` (`group_id`, `user_id`, `created_at`) VALUES ('3','12','2008-01-01 12:00:00');
INSERT INTO `groups_users` (`group_id`, `user_id`, `created_at`) VALUES ('3','15','2008-01-01 12:00:00');
UNLOCK TABLES;
ALTER TABLE `groups_users` ENABLE KEYS;
#
# Dumping data for table 'roles_users'
#
ALTER TABLE `roles_users` DISABLE KEYS;
LOCK TABLES `roles_users` WRITE;
INSERT INTO `roles_users` (`user_id`,`role_id`,`created_at`) VALUES ('1','1','2007-01-17 17:57:40');
INSERT INTO `roles_users` (`user_id`,`role_id`,`created_at`) VALUES ('2','1','2007-01-17 17:57:40');
INSERT INTO `roles_users` (`user_id`,`role_id`,`created_at`) VALUES ('3','1','2007-01-17 17:57:40');
INSERT INTO `roles_users` (`user_id`,`role_id`,`created_at`) VALUES ('4','1','2007-01-17 17:57:40');
INSERT INTO `roles_users` (`user_id`,`role_id`,`created_at`) VALUES ('5','2','2008-03-12 11:57:40');
INSERT INTO `roles_users` (`user_id`, `role_id`, `created_at`) VALUES ('10','3','2007-01-17 17:57:11');
INSERT INTO `roles_users` (`user_id`, `role_id`, `created_at`) VALUES ('11','4','2007-01-17 17:56:56');
INSERT INTO `roles_users` (`user_id`, `role_id`, `created_at`) VALUES ('12','5','2007-01-17 17:56:57');
INSERT INTO `roles_users` (`user_id`, `role_id`, `created_at`) VALUES ('15','3','2007-01-18 01:57:11');
UNLOCK TABLES;
ALTER TABLE `roles_users` ENABLE KEYS;