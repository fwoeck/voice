SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(80) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `skype_name` varchar(32) DEFAULT NULL,
  `accountcode` varchar(20) DEFAULT NULL,
  `amaflags` varchar(7) DEFAULT NULL,
  `callgroup` varchar(10) DEFAULT NULL,
  `callerid` varchar(80) DEFAULT NULL,
  `dial` varchar(80) DEFAULT NULL,
  `callbackextension` varchar(40) DEFAULT NULL,
  `canreinvite` char(3) DEFAULT 'no',
  `context` varchar(80) DEFAULT 'adhearsion',
  `defaultip` varchar(15) DEFAULT NULL,
  `dtmfmode` varchar(7) DEFAULT 'rfc2833',
  `fromuser` varchar(80) DEFAULT NULL,
  `fromdomain` varchar(80) DEFAULT NULL,
  `fullcontact` varchar(80) DEFAULT NULL,
  `host` varchar(31) NOT NULL DEFAULT 'dynamic',
  `insecure` varchar(20) DEFAULT NULL,
  `language` char(2) DEFAULT NULL,
  `mailbox` varchar(50) DEFAULT NULL,
  `md5secret` varchar(80) DEFAULT NULL,
  `nat` varchar(30) NOT NULL DEFAULT 'force_rport,comedia',
  `deny` varchar(95) DEFAULT NULL,
  `permit` varchar(95) DEFAULT NULL,
  `mask` varchar(95) DEFAULT NULL,
  `pickupgroup` varchar(10) DEFAULT NULL,
  `port` varchar(5) NOT NULL DEFAULT '5060',
  `qualify` char(3) DEFAULT 'no',
  `restrictcid` char(1) DEFAULT NULL,
  `rtptimeout` char(3) DEFAULT NULL,
  `rtpholdtimeout` char(3) DEFAULT NULL,
  `secret` varchar(80) DEFAULT NULL,
  `type` varchar(6) NOT NULL DEFAULT 'friend',
  `disallow` varchar(100) DEFAULT 'all',
  `allow` varchar(100) DEFAULT 'opus,speex16,alaw,ulaw',
  `musiconhold` varchar(100) DEFAULT NULL,
  `regseconds` int(11) NOT NULL DEFAULT '0',
  `ipaddr` varchar(50) NOT NULL DEFAULT '',
  `regexten` varchar(80) NOT NULL DEFAULT '',
  `cancallforward` char(3) DEFAULT 'no',
  `transport` char(10) DEFAULT 'udp,tls',
  `encryption` char(3) DEFAULT 'no',
  `directmedia` char(3) DEFAULT 'yes',
  `defaultuser` varchar(10) DEFAULT NULL,
  `regserver` varchar(20) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `lastms` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
