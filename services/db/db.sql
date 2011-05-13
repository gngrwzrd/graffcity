/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50147
 Source Host           : localhost
 Source Database       : allcity

 Target Server Type    : MySQL
 Target Server Version : 50147
 File Encoding         : utf-8

 Date: 08/03/2010 12:11:34 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `tag`
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `userId` int(20) NOT NULL,
  `rating` bigint(20) NOT NULL DEFAULT '1',
  `rateCount` bigint(20) NOT NULL DEFAULT '1',
  `thumb` varchar(44) DEFAULT NULL,
  `large` varchar(44) DEFAULT NULL,
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `orientation` double(10,0) NOT NULL DEFAULT '0',
  `thoroughfare` varchar(512) DEFAULT NULL,
  `subThoroughfare` varchar(512) DEFAULT NULL,
  `locality` varchar(128) DEFAULT NULL,
  `subLocality` varchar(512) DEFAULT NULL,
  `administrativeArea` varchar(128) DEFAULT NULL,
  `subAdministrativeArea` varchar(128) DEFAULT NULL,
  `postalcode` varchar(11) DEFAULT NULL,
  `country` varchar(25) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `tag`
-- ----------------------------
INSERT INTO `tag` VALUES ('1', '1', '1', '1', null, '028-e60b3d9f-5a10-44f6-8014-2d4771f22c82.jpg', '37.796848', '-122.402329', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:56:00'), ('2', '2', '1', '1', null, '012-8cc93d98-74f1-4e32-84a2-6adb5e6ebb58.jpg', '37.7940400166667', '-122.40033305', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:56:38'), ('3', '3', '1', '1', null, '045-3bf35d95-cd9f-4be2-a5da-07a4231ebdf7.jpg', '37.795932', '-122.392051', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:00'), ('4', '1', '1', '1', null, '047-88f7786b-f9bf-47eb-87f2-c375e881d4b8.jpg', '34.115784', '-118.328934', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:19'), ('5', '2', '1', '1', null, '038-5b45c538-74ee-4d92-b2d5-8cc533cf3700.jpg', '40.722531', '-73.987138', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:35'), ('6', '3', '1', '1', null, '047-3ac96451-ca4a-416b-9d6c-35904f0c1636.jpg', '45.523452', '-122.676207', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:50');

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `rating` bigint(20) NOT NULL DEFAULT '0',
  `rateCount` bigint(20) NOT NULL DEFAULT '0',
  `totalTags` bigint(20) NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `user`
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'aaron', 'aaron.smith@mccannsf.com', '66b37b3e454fa4f25e0b6488341e8f89', '0', '0', '2', '2010-06-30 14:49:19'), ('2', 'malcolm', 'malcolm.wilson@mccannsf.com', '7b8b08ba43f9784f370d8341ccc28b58', '0', '0', '2', '2010-06-30 14:49:49'), ('3', 'jonathan', 'jonathan.rose@mccannsf.com', '78842815248300fa6ae79f7776a5080a', '0', '0', '2', '2010-06-30 14:50:41');

