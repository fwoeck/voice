SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `secret` varchar(80) DEFAULT NULL,
  `md5secret` varchar(80) DEFAULT NULL,
  `fullcontact` varchar(80) DEFAULT NULL,
  `host` varchar(31) NOT NULL DEFAULT 'dynamic',
  `ipaddr` varchar(50) NOT NULL DEFAULT '',
  `port` varchar(5) NOT NULL DEFAULT '5060',
  `type` varchar(6) NOT NULL DEFAULT 'friend',
  `qualify` char(3) DEFAULT 'no',
  `regserver` varchar(255) DEFAULT NULL,
  `regseconds` int(11) NOT NULL DEFAULT '0',
  `defaultuser` varchar(10) DEFAULT NULL,
  `callbackextension` varchar(40) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `insecure` varchar(20) DEFAULT NULL,
  `lastms` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
