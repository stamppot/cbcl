CREATE TABLE `answer_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `answer_id` int(11) NOT NULL DEFAULT '0',
  `col` int(11) NOT NULL DEFAULT '0',
  `row` int(11) NOT NULL DEFAULT '0',
  `item` varchar(5) DEFAULT NULL,
  `rating` tinyint(1) DEFAULT NULL,
  `value_text` varchar(255) DEFAULT NULL,
  `text` tinyint(1) DEFAULT NULL,
  `cell_type` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answer_cells_on_answer_id` (`answer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1232908 DEFAULT CHARSET=latin1;

CREATE TABLE `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_answer_id` int(11) NOT NULL DEFAULT '0',
  `number` int(11) NOT NULL DEFAULT '0',
  `question_id` int(11) NOT NULL DEFAULT '0',
  `ratings_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answers_on_survey_answer_id` (`survey_answer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=76810 DEFAULT CHARSET=latin1;

CREATE TABLE `center_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `center_id` int(11) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `zipcode` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `ean` varchar(255) DEFAULT NULL,
  `person` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;

CREATE TABLE `center_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `center_id` int(11) DEFAULT NULL,
  `settings` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=latin1;

CREATE TABLE `csv_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_answer_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `journal_entry_id` int(11) DEFAULT NULL,
  `journal_id` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL,
  `answer` text,
  `header` varchar(255) DEFAULT NULL,
  `journal_info` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_csv_answers_on_journal_id` (`journal_id`),
  KEY `index_csv_answers_on_survey_id` (`survey_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31021 DEFAULT CHARSET=latin1;

CREATE TABLE `engine_schema_info` (
  `engine_name` varchar(255) COLLATE utf8_danish_ci DEFAULT NULL,
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `export_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=latin1;

CREATE TABLE `faq_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `faqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faq_section_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `question` varchar(255) DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `permission_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(200) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `code` int(4) unsigned DEFAULT NULL,
  `type` varchar(16) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned DEFAULT NULL,
  `center_id` int(10) unsigned DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `groups_parent_id_index` (`parent_id`),
  KEY `groups_center_id_index` (`center_id`),
  KEY `index_groups_on_center_id` (`center_id`),
  KEY `index_groups_on_delta` (`delta`),
  KEY `index_groups_on_code` (`code`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `groups_ibfk_2` FOREIGN KEY (`center_id`) REFERENCES `groups` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4772 DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `groups_roles` (
  `group_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `groups_roles_all_index` (`group_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `groups_roles_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `groups_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `groups_users` (
  `group_id` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_id`,`user_id`),
  UNIQUE KEY `groups_users_all_index` (`group_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `groups_users_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `groups_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `journal_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL DEFAULT '0',
  `survey_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `survey_answer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `answered_at` datetime DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_journal_entries_on_journal_id` (`journal_id`),
  KEY `index_journal_entries_on_survey_id` (`survey_id`),
  KEY `index_journal_entries_on_survey_answer_id` (`survey_answer_id`),
  KEY `index_journal_entries_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8893 DEFAULT CHARSET=latin1;

CREATE TABLE `letters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `letter` text,
  `surveytype` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_letters_on_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

CREATE TABLE `nationalities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country` varchar(40) DEFAULT NULL,
  `country_code` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

CREATE TABLE `periods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) NOT NULL DEFAULT '0',
  `used` int(11) NOT NULL DEFAULT '0',
  `paid` tinyint(1) DEFAULT '0',
  `paid_on` date DEFAULT NULL,
  `created_on` date DEFAULT NULL,
  `updated_on` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_periods_on_subscription_id` (`subscription_id`)
) ENGINE=InnoDB AUTO_INCREMENT=314 DEFAULT CHARSET=latin1;

CREATE TABLE `person_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `sex` int(11) NOT NULL DEFAULT '0',
  `birthdate` date NOT NULL DEFAULT '0000-00-00',
  `nationality` varchar(255) NOT NULL DEFAULT '',
  `cpr` varchar(255) DEFAULT NULL,
  `delta` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_person_infos_on_cpr` (`cpr`),
  KEY `index_person_infos_on_delta` (`delta`),
  KEY `index_person_infos_on_journal_id` (`journal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4664 DEFAULT CHARSET=latin1;

CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `body` text,
  `published` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `question_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `type` varchar(20) COLLATE utf8_danish_ci DEFAULT NULL,
  `col` int(11) DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `answer_item` varchar(5) COLLATE utf8_danish_ci DEFAULT NULL,
  `items` text COLLATE utf8_danish_ci,
  `preferences` varchar(255) COLLATE utf8_danish_ci DEFAULT NULL,
  `var` varchar(255) COLLATE utf8_danish_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2040 DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `ratings_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(100) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `parent_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `roles_parent_id_index` (`parent_id`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `roles` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `roles_static_permissions` (
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `static_permission_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `roles_static_permissions_all_index` (`static_permission_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_static_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `roles_static_permissions_ibfk_2` FOREIGN KEY (`static_permission_id`) REFERENCES `static_permissions` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `roles_users_all_index` (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `schema_info` (
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL DEFAULT '',
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `score_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `score_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `items` tinytext,
  `range` varchar(255) DEFAULT NULL,
  `qualifier` int(11) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_score_items_on_score_id` (`score_id`)
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=latin1;

CREATE TABLE `score_rapports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `survey_name` varchar(255) DEFAULT NULL,
  `short_name` varchar(255) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `survey_answer_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `unanswered` int(11) DEFAULT NULL,
  `gender` int(11) NOT NULL,
  `age_group` varchar(5) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `center_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11951 DEFAULT CHARSET=latin1;

CREATE TABLE `score_refs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_id` int(11) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `age_group` varchar(255) DEFAULT NULL,
  `mean` float DEFAULT NULL,
  `percent95` int(11) DEFAULT NULL,
  `percent98` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_score_refs_on_score_id` (`score_id`)
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=latin1;

CREATE TABLE `score_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `score_rapport_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `score_id` int(11) DEFAULT NULL,
  `result` int(11) DEFAULT NULL,
  `scale` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `mean` float DEFAULT NULL,
  `deviation` tinyint(1) DEFAULT NULL,
  `percentile_98` tinyint(1) DEFAULT NULL,
  `percentile_95` tinyint(1) DEFAULT NULL,
  `score_scale_id` int(11) DEFAULT NULL,
  `missing` int(11) DEFAULT '0',
  `missing_percentage` float DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  `valid_percentage` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_score_results_on_score_rapport_id` (`score_rapport_id`),
  KEY `index_score_results_on_score_id` (`score_id`),
  KEY `index_score_results_on_score_id_and_score_rapport_id` (`score_id`,`score_rapport_id`)
) ENGINE=InnoDB AUTO_INCREMENT=123377 DEFAULT CHARSET=latin1;

CREATE TABLE `score_scales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=latin1;

CREATE TABLE `scores_surveys` (
  `score_id` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  KEY `index_scores_surveys_on_score_id` (`score_id`),
  KEY `index_scores_surveys_on_survey_id` (`survey_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sph_counter` (
  `last_id` int(11) NOT NULL,
  `table_name` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `static_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `title` varchar(200) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `static_permissions_title_index` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `center_id` int(11) NOT NULL DEFAULT '0',
  `survey_id` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `note` text,
  `total_used` int(11) DEFAULT NULL,
  `total_paid` int(11) DEFAULT NULL,
  `active_used` int(11) DEFAULT NULL,
  `most_recent_payment` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subscriptions_on_center_id` (`center_id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;

CREATE TABLE `survey_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL DEFAULT '0',
  `surveytype` varchar(15) DEFAULT NULL,
  `answered_by` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `age` int(11) NOT NULL DEFAULT '0',
  `sex` int(11) NOT NULL DEFAULT '0',
  `nationality` varchar(24) DEFAULT NULL,
  `journal_entry_id` int(11) NOT NULL DEFAULT '0',
  `done` tinyint(1) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  `journal_id` int(11) DEFAULT NULL,
  `center_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_survey_answers_on_survey_id` (`survey_id`),
  KEY `index_survey_answers_on_journal_entry_id` (`journal_entry_id`),
  KEY `index_survey_answers_on_journal_id` (`journal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8116 DEFAULT CHARSET=latin1;

CREATE TABLE `surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(40) COLLATE utf8_danish_ci DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_danish_ci DEFAULT NULL,
  `description` text COLLATE utf8_danish_ci,
  `age` varchar(255) COLLATE utf8_danish_ci DEFAULT NULL,
  `surveytype` varchar(15) COLLATE utf8_danish_ci DEFAULT NULL,
  `color` varchar(7) COLLATE utf8_danish_ci DEFAULT NULL,
  `position` int(11) DEFAULT '99',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) DEFAULT NULL,
  `export_file_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=latin1;

CREATE TABLE `user_registrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `token` text COLLATE utf8_danish_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `expires_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_registrations_user_id_index` (`user_id`),
  KEY `user_registrations_expires_at_index` (`expires_at`),
  CONSTRAINT `user_registrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_logged_in_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `login_failure_count` int(10) unsigned NOT NULL DEFAULT '0',
  `login` varchar(100) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `name` varchar(100) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `email` varchar(200) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `password` varchar(128) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `password_hash_type` varchar(10) COLLATE utf8_danish_ci NOT NULL DEFAULT '',
  `password_salt` varchar(100) COLLATE utf8_danish_ci NOT NULL DEFAULT '1234512345',
  `state` int(10) unsigned NOT NULL DEFAULT '1',
  `center_id` int(10) unsigned DEFAULT NULL,
  `login_user` tinyint(1) unsigned DEFAULT '0',
  `delta` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_login_index` (`login`),
  KEY `users_password_index` (`password`),
  KEY `users_center_id_index` (`center_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8835 DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci;

CREATE TABLE `variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var` varchar(255) DEFAULT NULL,
  `item` varchar(255) DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `col` int(11) DEFAULT NULL,
  `survey_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20090325163215');

INSERT INTO schema_migrations (version) VALUES ('20090812211935');

INSERT INTO schema_migrations (version) VALUES ('20090814161656');

INSERT INTO schema_migrations (version) VALUES ('20090819173518');

INSERT INTO schema_migrations (version) VALUES ('20090820095305');

INSERT INTO schema_migrations (version) VALUES ('20090820112201');

INSERT INTO schema_migrations (version) VALUES ('20091028223825');

INSERT INTO schema_migrations (version) VALUES ('20091108110127');

INSERT INTO schema_migrations (version) VALUES ('20091115221047');

INSERT INTO schema_migrations (version) VALUES ('20100110115623');

INSERT INTO schema_migrations (version) VALUES ('20100111213750');

INSERT INTO schema_migrations (version) VALUES ('20100204134122');

INSERT INTO schema_migrations (version) VALUES ('20100204153251');

INSERT INTO schema_migrations (version) VALUES ('20100216220433');

INSERT INTO schema_migrations (version) VALUES ('20100217173657');

INSERT INTO schema_migrations (version) VALUES ('20100220142911');

INSERT INTO schema_migrations (version) VALUES ('20100228120836');

INSERT INTO schema_migrations (version) VALUES ('20100315191248');

INSERT INTO schema_migrations (version) VALUES ('20100321105922');

INSERT INTO schema_migrations (version) VALUES ('20100321123311');

INSERT INTO schema_migrations (version) VALUES ('20100321125925');

INSERT INTO schema_migrations (version) VALUES ('20100321133318');

INSERT INTO schema_migrations (version) VALUES ('20100401203646');

INSERT INTO schema_migrations (version) VALUES ('20100411224114');

INSERT INTO schema_migrations (version) VALUES ('20100412152831');

INSERT INTO schema_migrations (version) VALUES ('20100413130022');

INSERT INTO schema_migrations (version) VALUES ('20100413133959');

INSERT INTO schema_migrations (version) VALUES ('20100413134335');

INSERT INTO schema_migrations (version) VALUES ('20100413140118');

INSERT INTO schema_migrations (version) VALUES ('20100414153320');

INSERT INTO schema_migrations (version) VALUES ('20100812163417');

INSERT INTO schema_migrations (version) VALUES ('20100815084726');

INSERT INTO schema_migrations (version) VALUES ('20101003153431');

INSERT INTO schema_migrations (version) VALUES ('20101009162824');

INSERT INTO schema_migrations (version) VALUES ('20101211173347');

INSERT INTO schema_migrations (version) VALUES ('20110105182159');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');