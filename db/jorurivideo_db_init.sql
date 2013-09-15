--
-- Table structure for table `cms_concepts`
--

DROP TABLE IF EXISTS `cms_concepts`;
CREATE TABLE `cms_concepts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `level_no` int(11) NOT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`,`state`,`sort_no`)
) DEFAULT CHARSET=utf8;


--
-- Table structure for table `sys_tasks`
--

DROP TABLE IF EXISTS `sys_tasks`;
CREATE TABLE `sys_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `process_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


--
-- Table structure for table `sys_maintenances`
--

DROP TABLE IF EXISTS `sys_maintenances`;
CREATE TABLE `sys_maintenances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `title` text,
  `body` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_creators`
--

DROP TABLE IF EXISTS `sys_creators`;
CREATE TABLE `sys_creators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_creators` WRITE;
INSERT INTO `sys_creators` VALUES (1,NOW(),NOW(),1,3),(6,NOW(),NOW(),1,4),(4,NOW(),NOW(),1,4),(5,NOW(),NOW(),1,4);
UNLOCK TABLES;



--
-- Table structure for table `cms_nodes`
--

DROP TABLE IF EXISTS `cms_nodes`;
CREATE TABLE `cms_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `recognized_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `route_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `directory` int(11) DEFAULT NULL,
  `layout_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `body` longtext,
  `mobile_title` text,
  `mobile_body` longtext,
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`,`name`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `cms_nodes` WRITE;
INSERT INTO `cms_nodes` VALUES (1,5,NULL,1,'public',NOW(),NOW(),NULL,NOW(),0,0,NULL,'Cms::Directory',1,NULL,'/','動画管理システム',NULL,NULL,NULL);
UNLOCK TABLES;


--
-- Table structure for table `sys_recognitions`
--

DROP TABLE IF EXISTS `sys_recognitions`;
CREATE TABLE `sys_recognitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `recognizer_ids` varchar(255) DEFAULT NULL,
  `info_xml` text,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_users_groups`
--

DROP TABLE IF EXISTS `sys_users_groups`;
CREATE TABLE `sys_users_groups` (
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT '0',
  `group_id` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`,`group_id`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_users_groups` WRITE;
INSERT INTO `sys_users_groups` VALUES
(NOW(),NOW(),5194,698),
(NOW(),NOW(),5464,698),
(NOW(),NOW(),5465,698),
(NOW(),NOW(),5466,698),
(NOW(),NOW(),5467,699),
(NOW(),NOW(),5468,699),
(NOW(),NOW(),5469,699),
(NOW(),NOW(),5470,700),
(NOW(),NOW(),5471,700),
(NOW(),NOW(),5472,700);
UNLOCK TABLES;

--
-- Table structure for table `cms_layouts`
--

DROP TABLE IF EXISTS `cms_layouts`;
CREATE TABLE `cms_layouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `template_id` int(11) DEFAULT NULL,
  `site_id` int(11) NOT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `recognized_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `head` longtext,
  `body` longtext,
  `stylesheet` longtext,
  `mobile_head` text,
  `mobile_body` longtext,
  `mobile_stylesheet` longtext,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `video_temp_files`
--

DROP TABLE IF EXISTS `video_temp_files`;
CREATE TABLE `video_temp_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tmp_id` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `convert_state` varchar(255) DEFAULT NULL,
  `admin_is` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `mime_type` text,
  `extension` varchar(255) DEFAULT NULL,
  `image_is` int(11) DEFAULT NULL,
  `thumbnail_state` varchar(15) DEFAULT NULL,
  `thumbnail_point` double DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `duration` varchar(255) DEFAULT NULL,
  `bitrate` varchar(255) DEFAULT NULL,
  `audio_rate` varchar(255) DEFAULT NULL,
  `sampling_frequency` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_sequences`
--

DROP TABLE IF EXISTS `sys_sequences`;
CREATE TABLE `sys_sequences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`,`version`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_contents`
--

DROP TABLE IF EXISTS `cms_contents`;
CREATE TABLE `cms_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `site_id` int(11) NOT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `xml_properties` longtext,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_publishers`
--

DROP TABLE IF EXISTS `sys_publishers`;
CREATE TABLE `sys_publishers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `published_path` text,
  `content_type` text,
  `content_length` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_inquiries`
--

DROP TABLE IF EXISTS `cms_inquiries`;
CREATE TABLE `cms_inquiries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `charge` text,
  `tel` text,
  `fax` text,
  `email` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_users`
--

DROP TABLE IF EXISTS `sys_users`;
CREATE TABLE `sys_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `air_login_id` varchar(255) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ldap` int(11) NOT NULL,
  `ldap_version` varchar(255) DEFAULT NULL,
  `auth_no` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `name_en` text,
  `account` varchar(255) DEFAULT NULL,
  `password` text,
  `mobile_access` int(11) DEFAULT NULL,
  `mobile_password` varchar(255) DEFAULT NULL,
  `email` text,
  `remember_token` text,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `kana` varchar(255) DEFAULT NULL,
  `sort_no` varchar(255) DEFAULT NULL,
  `official_position` varchar(255) DEFAULT NULL,
  `assigned_job` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_users` WRITE;
INSERT INTO `sys_users` VALUES 
(5194,NULL,'enabled',NOW(),NOW(),0,NULL,5,'システム管理者','admin_en','admin','admin',0,'','admin@192.168.0.2',NULL,NULL,'システムカンリシャ',NULL,NULL,NULL),
(5464,NULL,'enabled',NOW(),NOW(),0,NULL,2,'徳島　太郎','user1_en','user1','user1',0,'','user1@192.168.0.2',NULL,NULL,'トクシマ　タロウ',NULL,NULL,NULL),
(5465,NULL,'enabled',NOW(),NOW(),0,NULL,5,'阿波　花子','user2_en','user2','user2',0,'','user2@192.168.0.2',NULL,NULL,'アワ　ハナコ',NULL,NULL,NULL),
(5466,NULL,'enabled',NOW(),NOW(),0,NULL,2,'吉野　三郎','user3_en','user3','user3',0,'','user3@192.168.0.2',NULL,NULL,'ヨシノ　サブロウ',NULL,NULL,NULL),
(5467,NULL,'enabled',NOW(),NOW(),0,NULL,2,'佐藤　直一','user4_en','user4','user4',0,'','user4@192.168.0.2',NULL,NULL,'サトウ　ナオイチ',NULL,NULL,NULL),
(5468,NULL,'enabled',NOW(),NOW(),0,NULL,2,'鈴木　裕介','user5_en','user5','user5',0,'','user5@192.168.0.2',NULL,NULL,'スズキ　ユウスケ',NULL,NULL,NULL),
(5469,NULL,'enabled',NOW(),NOW(),0,NULL,2,'高橋　和寿','user6_en','user6','user6',0,'','user6@192.168.0.2',NULL,NULL,'タカハシ　カズトシ',NULL,NULL,NULL),
(5470,NULL,'enabled',NOW(),NOW(),0,NULL,2,'田中　彩子','user7_en','user7','user7',0,'','user7@192.168.0.2',NULL,NULL,'タナカ　アヤコ',NULL,NULL,NULL),
(5471,NULL,'enabled',NOW(),NOW(),0,NULL,2,'渡辺　真由子','user8_en','user8','user8',0,'','user8@192.168.0.2',NULL,NULL,'ワタナベ　マユコ',NULL,NULL,NULL),
(5472,NULL,'enabled',NOW(),NOW(),0,NULL,2,'伊藤　勝','user9_en','user9','user9',0,'','user9@192.168.0.2',NULL,NULL,'イトウ　マサル',NULL,NULL,NULL);
UNLOCK TABLES;


--
-- Table structure for table `cms_pieces`
--

DROP TABLE IF EXISTS `cms_pieces`;
CREATE TABLE `cms_pieces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `site_id` int(11) NOT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `recognized_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `head` longtext,
  `body` longtext,
  `xml_properties` longtext,
  PRIMARY KEY (`id`),
  KEY `concept_id` (`concept_id`,`name`,`state`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `schema_migrations` WRITE;
UNLOCK TABLES;



--
-- Table structure for table `sys_object_privileges`
--

DROP TABLE IF EXISTS `sys_object_privileges`;
CREATE TABLE `sys_object_privileges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `item_unid` int(11) DEFAULT NULL,
  `action` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_unid` (`item_unid`,`action`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_ldap_synchros`
--

DROP TABLE IF EXISTS `sys_ldap_synchros`;
CREATE TABLE `sys_ldap_synchros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `version` varchar(10) DEFAULT NULL,
  `entry_type` varchar(15) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `kana` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `version` (`version`,`parent_id`,`entry_type`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `delayed_jobs`
--

DROP TABLE IF EXISTS `delayed_jobs`;
CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text,
  `last_error` text,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_groups`
--

DROP TABLE IF EXISTS `sys_groups`;
CREATE TABLE `sys_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(15) DEFAULT NULL,
  `web_state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `level_no` int(11) DEFAULT NULL,
  `code` varchar(255) NOT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `layout_id` int(11) DEFAULT NULL,
  `ldap` int(11) NOT NULL,
  `ldap_version` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `group_s_name` varchar(255) DEFAULT NULL,
  `tel` varchar(255) DEFAULT NULL,
  `outline_uri` varchar(255) DEFAULT NULL,
  `email` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_groups` WRITE;
INSERT INTO `sys_groups` VALUES
(1,'enabled',NULL,NOW(),NOW(),0,1,'1',0,NULL,0,NULL,'徳島県','',NULL,NULL,NULL,''),
(696,'enabled','public',NOW(),NOW(),1,2,'001',10,NULL,0,NULL,'企画部','kikakubu',NULL,'000-0000','http://joruri.org/','kikakubu@192.168.0.2'),
(698,'enabled','public',NOW(),NOW(),696,3,'001002',20,NULL,0,'','秘書広報課',NULL,NULL,NULL,NULL,NULL),
(699,'enabled','public',NOW(),NOW(),696,3,'001003',30,NULL,0,'','人事課',NULL,NULL,NULL,NULL,NULL),
(700,'enabled','public',NOW(),NOW(),696,3,'001004',40,NULL,0,'','企画政策課',NULL,NULL,NULL,NULL,NULL);
UNLOCK TABLES;


--
-- Table structure for table `video_clip_originals`
--

DROP TABLE IF EXISTS `video_clip_originals`;


CREATE TABLE `video_clip_originals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clip_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `mime_type` text,
  `duration` varchar(255) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `extension` varchar(255) DEFAULT NULL,
  `bitrate` varchar(255) DEFAULT NULL,
  `audio_rate` varchar(255) DEFAULT NULL,
  `sampling_frequency` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clip_id` (`clip_id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `article_areas`
--

DROP TABLE IF EXISTS `article_areas`;
CREATE TABLE `article_areas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `level_no` int(11) NOT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `layout_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `zip_code` text,
  `address` text,
  `tel` text,
  `site_uri` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_group_change_items`
--

DROP TABLE IF EXISTS `sys_group_change_items`;
CREATE TABLE `sys_group_change_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `item_unid` int(11) DEFAULT NULL,
  `parent_item_id` int(11) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `owner_model` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`,`model`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_group_change_items` WRITE;
INSERT INTO `sys_group_change_items` VALUES (1,235,-1,-1,'Video::Clip',NULL);
UNLOCK TABLES;



--
-- Table structure for table `sys_files`
--

DROP TABLE IF EXISTS `sys_files`;
CREATE TABLE `sys_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `tmp_id` varchar(255) DEFAULT NULL,
  `parent_unid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `mime_type` text,
  `size` int(11) DEFAULT NULL,
  `image_is` int(11) DEFAULT NULL,
  `image_width` int(11) DEFAULT NULL,
  `image_height` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parent_unid` (`parent_unid`,`name`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_sites`
--

DROP TABLE IF EXISTS `cms_sites`;
CREATE TABLE `cms_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `full_uri` varchar(255) DEFAULT NULL,
  `mobile_full_uri` varchar(255) DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `related_site` text,
  `map_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



LOCK TABLES `cms_sites` WRITE;
INSERT INTO `cms_sites` VALUES (1,1,'public',NOW(),NOW(),'動画管理システム','http://192.168.0.2/','',1,'','');
UNLOCK TABLES;

--
-- Table structure for table `sys_group_changes`
--

DROP TABLE IF EXISTS `sys_group_changes`;
CREATE TABLE `sys_group_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `level_no` int(11) DEFAULT NULL,
  `parent_code` varchar(255) DEFAULT NULL,
  `parent_name` varchar(255) DEFAULT NULL,
  `change_division` varchar(255) DEFAULT NULL,
  `ldap` int(11) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `old_division` varchar(255) DEFAULT NULL,
  `old_id` int(11) DEFAULT NULL,
  `old_code` varchar(255) DEFAULT NULL,
  `old_name` varchar(255) DEFAULT NULL,
  `commutation_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_user_logins`
--

DROP TABLE IF EXISTS `sys_user_logins`;
CREATE TABLE `sys_user_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `video_categories`
--

DROP TABLE IF EXISTS `video_categories`;
CREATE TABLE `video_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `level_no` int(11) NOT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `layout_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



LOCK TABLES `video_categories` WRITE;
INSERT INTO `video_categories` VALUES (1,NULL,0,NULL,'enabled',NOW(),NOW(),1,10,NULL,NULL,'お知らせ'),(2,NULL,0,NULL,'enabled',NOW(),NOW(),1,20,NULL,NULL,'全庁ビデオ放送'),(3,NULL,0,NULL,'enabled',NOW(),NOW(),1,30,NULL,NULL,'防災対策'),(4,NULL,0,NULL,'enabled',NOW(),NOW(),1,40,NULL,NULL,'コンプライアンス');
UNLOCK TABLES;

--
-- Table structure for table `sys_role_names`
--

DROP TABLE IF EXISTS `sys_role_names`;
CREATE TABLE `sys_role_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_data_file_nodes`
--

DROP TABLE IF EXISTS `cms_data_file_nodes`;
CREATE TABLE `cms_data_file_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  PRIMARY KEY (`id`),
  KEY `concept_id` (`concept_id`,`name`),
  KEY `concept_id_2` (`concept_id`,`name`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_languages`
--

DROP TABLE IF EXISTS `sys_languages`;
CREATE TABLE `sys_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_languages` WRITE;
INSERT INTO `sys_languages` VALUES (1,'enabled',NOW(),NOW(),1,'japanese','日本語');
UNLOCK TABLES;



--
-- Table structure for table `article_docs`
--

DROP TABLE IF EXISTS `article_docs`;
CREATE TABLE `article_docs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `agent_state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `recognized_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `category_ids` varchar(255) DEFAULT NULL,
  `attribute_ids` varchar(255) DEFAULT NULL,
  `area_ids` varchar(255) DEFAULT NULL,
  `rel_doc_ids` varchar(255) DEFAULT NULL,
  `notice_state` text,
  `recent_state` text,
  `list_state` text,
  `event_state` text,
  `event_date` date DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `head` longtext,
  `body` longtext,
  `mobile_title` text,
  `mobile_body` longtext,
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`,`published_at`,`event_date`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS `video_daily_accesses`;
CREATE TABLE `video_daily_accesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `accessed_at` date DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `video_skins`
--

DROP TABLE IF EXISTS `video_skins`;
CREATE TABLE `video_skins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `mime_type` text,
  `size` int(11) DEFAULT NULL,
  `sort_no` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

LOCK TABLES `video_skins` WRITE;
INSERT INTO `video_skins` VALUES (1,NULL,NULL,'enabled',NOW(),NOW(),NOW(),'snel.swf','デフォルトスキン','application/x-shockwave-flash',6569,1);
UNLOCK TABLES;



--
-- Table structure for table `sys_editable_groups`
--

DROP TABLE IF EXISTS `sys_editable_groups`;
CREATE TABLE `sys_editable_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `group_ids` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `article_attributes`
--

DROP TABLE IF EXISTS `article_attributes`;
CREATE TABLE `article_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `layout_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_kana_dictionaries`
--

DROP TABLE IF EXISTS `cms_kana_dictionaries`;
CREATE TABLE `cms_kana_dictionaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `body` longtext,
  `ipadic_body` longtext,
  `unidic_body` longtext,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_data_files`
--

DROP TABLE IF EXISTS `cms_data_files`;
CREATE TABLE `cms_data_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `mime_type` text,
  `size` int(11) DEFAULT NULL,
  `image_is` int(11) DEFAULT NULL,
  `image_width` int(11) DEFAULT NULL,
  `image_height` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `concept_id` (`concept_id`,`node_id`,`name`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `video_clips`
--

DROP TABLE IF EXISTS `video_clips`;
CREATE TABLE `video_clips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `agent_state` varchar(15) DEFAULT NULL,
  `convert_state` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `published_year` varchar(4) DEFAULT NULL,
  `published_month` varchar(2) DEFAULT NULL,
  `published_day` varchar(2) DEFAULT NULL,
  `negated_at` datetime DEFAULT NULL,
  `skin_id` int(11) DEFAULT NULL,
  `main_category_id` varchar(255) DEFAULT NULL,
  `category_ids` varchar(255) DEFAULT NULL,
  `rel_clip_ids` varchar(255) DEFAULT NULL,
  `keywords` longtext,
  `recent_state` text,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `body` longtext,
  `mime_type` text,
  `thumbnail_state` varchar(15) DEFAULT NULL,
  `thumbnail_point` double DEFAULT NULL,
  `duration` varchar(255) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `extension` varchar(255) DEFAULT NULL,
  `bitrate` varchar(255) DEFAULT NULL,
  `audio_rate` varchar(255) DEFAULT NULL,
  `sampling_frequency` varchar(255) DEFAULT NULL,
  `admin_is` int(11) DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `creator_group_id` int(11) DEFAULT NULL,
  `editting_state` text,
  `editting_group_ids` text,
  `negator_id` int(11) DEFAULT NULL,
  `view_count` int(11) DEFAULT NULL,
  `check_digit` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `published_year` (`published_year`,`published_month`,`published_day`),
  KEY `creator_group_id` (`creator_group_id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_users_roles`
--

DROP TABLE IF EXISTS `sys_users_roles`;
CREATE TABLE `sys_users_roles` (
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`,`role_id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `article_categories`
--

DROP TABLE IF EXISTS `article_categories`;
CREATE TABLE `article_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `parent_id` int(11) NOT NULL,
  `content_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `level_no` int(11) NOT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `layout_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_messages`
--

DROP TABLE IF EXISTS `sys_messages`;
CREATE TABLE `sys_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `title` text,
  `body` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



LOCK TABLES `sys_messages` WRITE;
INSERT INTO `sys_messages` VALUES (1,4,'public',NOW(),NOW(),NOW(),'管理画面からのお知らせ','<p>管理画面からのお知らせ</p>');
UNLOCK TABLES;

--
-- Table structure for table `article_sections`
--

DROP TABLE IF EXISTS `article_sections`;
CREATE TABLE `article_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `parent_code` varchar(255) DEFAULT NULL,
  `group_ids` text,
  `level_no` int(11) DEFAULT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `tel` text,
  `email` varchar(255) DEFAULT NULL,
  `outline_uri` text,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_maps`
--

DROP TABLE IF EXISTS `cms_maps`;
CREATE TABLE `cms_maps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `map_lat` text,
  `map_lng` text,
  `map_zoom` text,
  `point1_name` text,
  `point1_lat` text,
  `point1_lng` text,
  `point2_name` text,
  `point2_lat` text,
  `point2_lng` text,
  `point3_name` text,
  `point3_lat` text,
  `point3_lng` text,
  `point4_name` text,
  `point4_lat` text,
  `point4_lng` text,
  `point5_name` text,
  `point5_lat` text,
  `point5_lng` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `video_settings`
--

DROP TABLE IF EXISTS `video_settings`;
CREATE TABLE `video_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` text,
  `sort_no` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `video_admin_settings`
--

DROP TABLE IF EXISTS `video_admin_settings`;
CREATE TABLE `video_admin_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` text,
  `sort_no` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

LOCK TABLES `video_admin_settings` WRITE;
INSERT INTO `video_admin_settings` VALUES (1,NULL,NULL,NOW(),NOW(),'default_skin','1',NULL),(2,NULL,NULL,NOW(),NOW(),'maximum_file_size','500',NULL),(4,NULL,NULL,NOW(),NOW(),'maximum_duration','30',NULL),(5,NULL,NULL,NOW(),NOW(),'maximum_frame_size','640x480',NULL),(6,NULL,NULL,NOW(),NOW(),'upper_limit_file_size','1000',NULL),(7,NULL,NULL,NOW(),NOW(),'maximum_monthly_report_count','12',NULL);
UNLOCK TABLES;



--
-- Table structure for table `cms_data_texts`
--

DROP TABLE IF EXISTS `cms_data_texts`;
CREATE TABLE `cms_data_texts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `concept_id` int(11) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` text,
  `body` longtext,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_group_change_groups`
--

DROP TABLE IF EXISTS `sys_group_change_groups`;
CREATE TABLE `sys_group_change_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_change_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `old_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `sys_unids`
--

DROP TABLE IF EXISTS `sys_unids`;
CREATE TABLE `sys_unids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `model` varchar(255) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


LOCK TABLES `sys_unids` WRITE;
INSERT INTO `sys_unids` VALUES (1,NOW(),NOW(),'Cms::Site',1),(6,NOW(),NOW(),'Sys::Maintenance',3),(4,NOW(),NOW(),'Sys::Message',1),(5,NOW(),NOW(),'Cms::Node',1);
UNLOCK TABLES;


--
-- Table structure for table `sys_group_change_logs`
--

DROP TABLE IF EXISTS `sys_group_change_logs`;
CREATE TABLE `sys_group_change_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `state` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `level_no` int(11) NOT NULL,
  `sort_no` int(11) DEFAULT NULL,
  `execute_state` varchar(15) DEFAULT NULL,
  `executed_at` datetime DEFAULT NULL,
  `title` text,
  `body` longtext,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `cms_talk_tasks`
--

DROP TABLE IF EXISTS `cms_talk_tasks`;
CREATE TABLE `cms_talk_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL,
  `controller` text,
  `path` text,
  `uri` text,
  `regular` int(11) DEFAULT NULL,
  `result` varchar(255) DEFAULT NULL,
  `content` longtext,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;



--
-- Table structure for table `article_tags`
--

DROP TABLE IF EXISTS `article_tags`;
CREATE TABLE `article_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `word` text,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

