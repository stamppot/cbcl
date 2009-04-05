# HeidiSQL Dump 
#
# --------------------------------------------------------
# Host:                 localhost
# Database:             cbcl_development
# Server version:       4.1.22-community-log
# Server OS:            Win32
# HeidiSQL version:     3.0 RC3 Revision: 111
# --------------------------------------------------------

SET CHARACTER SET latin1;


#
# Database structure for database 'cbcl_development'
#

USE `cbcl_development`;

DROP TABLE IF EXISTS `login_users`;
# [ActiveRBAC 0.1]
# This is database creation SQL script in MySQL dialect.


#----------------------------
# Table structure for login_users
#----------------------------
CREATE TABLE `login_users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_logged_in_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `login_failure_count` int(10) unsigned NOT NULL default '0',
  `login` varchar(100) NOT NULL collate latin1_danish_ci default '',
  `email` varchar(200) NOT NULL default '',
  `password` varchar(100) NOT NULL default '',
  `password_hash_type` varchar(20) NOT NULL default '',
  `password_salt` char(10) NOT NULL default '1234512345',
  `state` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_password_index` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_danish_ci;