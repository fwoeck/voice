SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `languages`
-- ----------------------------
DROP TABLE IF EXISTS `languages`;
CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_languages_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `languages`
-- ----------------------------
BEGIN;
INSERT INTO `languages` VALUES ('41', '132', 'en'), ('44', '132', 'it'), ('48', '132', 'es'), ('49', '132', 'fr'), ('64', '134', 'es'), ('66', '134', 'fr'), ('67', '134', 'it'), ('72', '135', 'de'), ('73', '134', 'de'), ('84', '133', 'de'), ('85', '133', 'it'), ('86', '133', 'fr'), ('97', '134', 'en'), ('109', '133', 'en'), ('110', '133', 'es');
COMMIT;

-- ----------------------------
--  Table structure for `roles`
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_roles_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `schema_migrations`
-- ----------------------------
DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `schema_migrations`
-- ----------------------------
BEGIN;
INSERT INTO `schema_migrations` VALUES ('20140628142144'), ('20140704034335'), ('20140704034340'), ('20140704034345'), ('20140707113744'), ('20140803051930');
COMMIT;

-- ----------------------------
--  Table structure for `skills`
-- ----------------------------
DROP TABLE IF EXISTS `skills`;
CREATE TABLE `skills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_skills_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `skills`
-- ----------------------------
BEGIN;
INSERT INTO `skills` VALUES ('28', '134', 'payment'), ('29', '134', 'ext_booking'), ('30', '134', 'new_booking'), ('31', '134', 'other'), ('38', '132', 'new_booking'), ('39', '132', 'ext_booking'), ('40', '132', 'payment'), ('41', '132', 'other'), ('46', '135', 'payment'), ('48', '135', 'ext_booking'), ('51', '135', 'new_booking'), ('52', '135', 'other'), ('62', '133', 'ext_booking'), ('63', '133', 'new_booking'), ('64', '133', 'other'), ('65', '133', 'payment');
COMMIT;

-- ----------------------------
--  Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `fullcontact` varchar(80) DEFAULT NULL,
  `host` varchar(31) NOT NULL DEFAULT 'dynamic',
  `md5secret` varchar(80) DEFAULT NULL,
  `port` varchar(5) NOT NULL DEFAULT '5060',
  `qualify` char(3) DEFAULT 'no',
  `secret` varchar(80) DEFAULT NULL,
  `type` varchar(6) NOT NULL DEFAULT 'friend',
  `regserver` varchar(255) DEFAULT NULL,
  `regseconds` int(11) NOT NULL DEFAULT '0',
  `ipaddr` varchar(50) NOT NULL DEFAULT '',
  `defaultuser` varchar(10) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `lastms` varchar(11) DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `fullname` varchar(255) DEFAULT '',
  `zendesk_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=MyISAM AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `users`
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('131', '100', 'sips:100@df7jal23ls0d.invalid^3Brtcweb-breaker=no^3Btransport=wss', 'dynamic', null, '56023', 'no', '0000', 'friend', null, '1407650410', '33.33.33.1', '23571869', 'IM-client/OMA1.0 sip', '0', '100@mail.com', '$2a$10$Y3HSCOjFAaGGuiTJibT6guLjp7TWhn1DZZXgXPHWeKzHva4DD79Vi', null, null, null, '36', '2014-08-03 16:52:49', '2014-07-28 09:59:26', '127.0.0.1', '127.0.0.1', null, '2014-08-03 16:52:49', 'Marisa Hartmann II', null), ('132', '101', 'sip:9eh9eppt@iq277jrlm1t3.invalid^3Btransport=ws', 'dynamic', null, '52056', 'no', '0000', 'friend', null, '1407601473', '33.33.33.1', '101', 'JsSIP 0.3.7', '0', '101@mail.com', '$2a$10$8XABaJ5jMSqJeHKp4WOTFOh4P3ePdbekSIcFRcy9Muu89gjUHtNi.', null, null, null, '37', '2014-08-01 19:08:41', '2014-07-28 07:49:40', '127.0.0.1', '127.0.0.1', null, '2014-08-01 19:08:41', 'Mackenzie Ondricka', null), ('133', '102', 'sip:58147032@33.33.33.1:55980^3Btransport=tls', 'dynamic', null, '56215', 'no', '0000', 'friend', '', '1407651158', '33.33.33.1', '04823719', 'Blink Pro 3.9.1 (Mac', '0', 'frank.woeckener@wimdu.com', '$2a$10$1TFk8R4gGgzBLw9fS5plVu8qJ4sHdffqzTcJ0Hahe/EK5AshSh7RW', null, null, null, '82', '2014-08-10 05:03:18', '2014-08-10 05:02:18', '127.0.0.1', '127.0.0.1', null, '2014-08-10 05:03:18', 'Frank Wöckener', '526586161'), ('134', '103', 'sip:103@127.0.1.1:30000', 'dynamic', null, '30000', 'no', '0000', 'friend', '', '1407652849', '127.0.1.1', '67143285', 'WebRTC', '0', '103@mail.com', '$2a$10$62pZRZ/byMemQvvi0.RpKOKLQlEoirsKzoUpEumQjNtnHZI.Yn9g2', null, null, null, '46', '2014-08-10 05:17:25', '2014-08-09 08:50:05', '127.0.0.1', '127.0.0.1', null, '2014-08-10 05:17:25', 'Neal Reichel Jr.', null), ('135', '104', 'sip:104@127.0.1.1:30003', 'dynamic', null, '30003', 'no', '0000', 'friend', null, '1405837964', '127.0.1.1', '104', 'WebRTC', '0', '104@mail.com', '$2a$10$IXlcVs4PsRfOP7zNee1TS.NCQLypHgfEhoPA67Jy2lWcew6wAsWg2', null, null, null, '9', '2014-07-20 05:15:03', '2014-07-19 15:48:42', '127.0.0.1', '127.0.0.1', null, '2014-07-20 05:15:03', 'Eusebio McClure', null), ('136', '105', 'sip:105@33.33.33.1:23288^3Brinstance=168977b55466c01d', 'dynamic', null, '23288', 'no', '0000', 'friend', null, '1404156022', '33.33.33.1', '105', 'Bria 3 release 3.5.5', '0', '105@mail.com', '$2a$10$YzlG45nokZGLwfCr6spS6uCUrP1VDyIK6HNCwlvozDxi/p7LvDPh6', null, null, null, '0', null, null, null, null, '2014-06-30 18:19:33', '2014-07-09 04:40:01', 'Ms. Athena Streich', null);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
