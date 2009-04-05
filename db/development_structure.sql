CREATE TABLE `answer_cells` (
  `id` int(11) NOT NULL auto_increment,
  `answer_id` int(11) NOT NULL default '0',
  `answertype` varchar(20) default NULL,
  `col` int(11) NOT NULL default '0',
  `row` int(11) NOT NULL default '0',
  `item` varchar(5) default NULL,
  `value` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_answer_cells_on_answer_id` (`answer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `answers` (
  `id` int(11) NOT NULL auto_increment,
  `survey_answer_id` int(11) NOT NULL default '0',
  `number` int(11) NOT NULL default '0',
  `question_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `index_answers_on_survey_answer_id` (`survey_answer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `copies` (
  `id` int(11) NOT NULL auto_increment,
  `subscription_id` int(11) NOT NULL default '0',
  `used` int(11) NOT NULL default '0',
  `consolidated` tinyint(1) default '0',
  `consolidated_on` date default NULL,
  `created_on` date default NULL,
  `updated_on` datetime default NULL,
  `active` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `title` varchar(200) collate utf8_danish_ci NOT NULL default '',
  `code` int(4) unsigned default NULL,
  `type` varchar(16) collate utf8_danish_ci NOT NULL default '',
  `parent_id` int(10) unsigned default NULL,
  `center_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `groups_parent_id_index` (`parent_id`),
  KEY `groups_center_id_index` (`center_id`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `groups_ibfk_2` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `groups_roles` (
  `group_id` int(10) unsigned NOT NULL default '0',
  `role_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `groups_roles_all_index` (`group_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `groups_roles_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `groups_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `groups_users` (
  `group_id` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`group_id`,`user_id`),
  UNIQUE KEY `groups_users_all_index` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `groups_users_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `groups_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `journal_entries` (
  `id` int(11) NOT NULL auto_increment,
  `journal_id` int(11) NOT NULL default '0',
  `survey_id` int(11) NOT NULL default '0',
  `user_id` int(11) default NULL,
  `parent_id` int(11) NOT NULL default '0',
  `survey_answer_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `answered_at` datetime default NULL,
  `state` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `nationalities` (
  `id` int(11) NOT NULL auto_increment,
  `country` varchar(40) default NULL,
  `country_code` varchar(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `person_infos` (
  `id` int(11) NOT NULL auto_increment,
  `journal_id` int(11) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `sex` int(11) NOT NULL default '0',
  `birthdate` date NOT NULL default '0000-00-00',
  `nationality` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `question_cells` (
  `id` int(11) NOT NULL auto_increment,
  `question_id` int(11) NOT NULL default '0',
  `type` varchar(20) collate utf8_danish_ci default NULL,
  `col` int(11) default NULL,
  `row` int(11) default NULL,
  `answer_item` varchar(5) collate utf8_danish_ci default NULL,
  `items` text collate utf8_danish_ci,
  `preferences` varchar(255) collate utf8_danish_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL auto_increment,
  `survey_id` int(11) NOT NULL default '0',
  `number` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `identifier` varchar(50) collate utf8_danish_ci NOT NULL default '',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `title` varchar(100) collate utf8_danish_ci NOT NULL default '',
  `parent_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY `roles_parent_id_index` (`parent_id`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `roles` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `roles_static_permissions` (
  `role_id` int(10) unsigned NOT NULL default '0',
  `static_permission_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `roles_static_permissions_all_index` (`static_permission_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_static_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `roles_static_permissions_ibfk_2` FOREIGN KEY (`static_permission_id`) REFERENCES `static_permissions` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL default '0',
  `role_id` int(10) unsigned NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  UNIQUE KEY `roles_users_all_index` (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `score_groups` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `description` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `score_items` (
  `id` int(11) NOT NULL auto_increment,
  `score_id` int(11) default NULL,
  `survey_id` int(11) default NULL,
  `question` int(11) default NULL,
  `items` tinytext,
  `range` varchar(255) default NULL,
  `qualifier` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_score_items_on_score_id` (`score_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `score_refs` (
  `id` int(11) NOT NULL auto_increment,
  `score_id` int(11) default NULL,
  `survey_id` int(11) default NULL,
  `gender` int(11) default NULL,
  `age_group` varchar(255) default NULL,
  `mean` float default NULL,
  `percent95` int(11) default NULL,
  `percent98` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_score_refs_on_score_id` (`score_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `scores` (
  `id` int(11) NOT NULL auto_increment,
  `score_group_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `short_name` varchar(255) default NULL,
  `sum` int(11) default NULL,
  `scale` int(11) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `scores_surveys` (
  `score_id` int(11) default NULL,
  `survey_id` int(11) default NULL,
  KEY `index_scores_surveys_on_score_id` (`score_id`),
  KEY `index_scores_surveys_on_survey_id` (`survey_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `static_permissions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `identifier` varchar(50) collate utf8_danish_ci NOT NULL default '',
  `title` varchar(200) collate utf8_danish_ci NOT NULL default '',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `static_permissions_title_index` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL auto_increment,
  `center_id` int(11) NOT NULL default '0',
  `survey_id` int(11) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `state` int(11) NOT NULL default '0',
  `note` text,
  PRIMARY KEY  (`id`),
  KEY `index_subscriptions_on_center_id` (`center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `survey_answers` (
  `id` int(11) NOT NULL auto_increment,
  `survey_id` int(11) NOT NULL default '0',
  `surveytype` varchar(15) default NULL,
  `answered_by` varchar(15) default NULL,
  `created_at` datetime default NULL,
  `age` int(11) NOT NULL default '0',
  `sex` int(11) NOT NULL default '0',
  `nationality` varchar(30) default NULL,
  `journal_id` varchar(15) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_survey_answers_on_journal_id` (`journal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `surveys` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(40) collate utf8_danish_ci default NULL,
  `category` varchar(255) collate utf8_danish_ci default NULL,
  `description` text collate utf8_danish_ci,
  `age` varchar(255) collate utf8_danish_ci default NULL,
  `surveytype` varchar(15) collate utf8_danish_ci default NULL,
  `color` varchar(7) collate utf8_danish_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `user_registrations` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `token` text collate utf8_danish_ci NOT NULL,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `expires_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `user_registrations_user_id_index` (`user_id`),
  KEY `user_registrations_expires_at_index` (`expires_at`),
  CONSTRAINT `user_registrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_logged_in_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `login_failure_count` int(10) unsigned NOT NULL default '0',
  `login` varchar(100) collate utf8_danish_ci NOT NULL default '',
  `name` varchar(100) collate utf8_danish_ci NOT NULL default '',
  `email` varchar(200) collate utf8_danish_ci NOT NULL default '',
  `password` varchar(128) collate utf8_danish_ci NOT NULL default '',
  `password_hash_type` varchar(10) collate utf8_danish_ci NOT NULL default '',
  `password_salt` varchar(100) collate utf8_danish_ci NOT NULL default '1234512345',
  `state` int(10) unsigned NOT NULL default '1',
  `center_id` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_password_index` (`password`),
  KEY `users_center_id_index` (`center_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

INSERT INTO schema_info (version) VALUES (7)