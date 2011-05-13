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

 Date: 08/07/2010 12:56:54 PM
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
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

-- ----------------------------
--  Records of `tag`
-- ----------------------------
INSERT INTO `tag` VALUES ('1', '1', '1', '1', null, '028-e60b3d9f-5a10-44f6-8014-2d4771f22c82.jpg', '37.796848', '-122.402329', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:56:00'), ('2', '2', '1', '1', null, '012-8cc93d98-74f1-4e32-84a2-6adb5e6ebb58.jpg', '37.7940400166667', '-122.40033305', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:56:38'), ('3', '3', '1', '1', null, '045-3bf35d95-cd9f-4be2-a5da-07a4231ebdf7.jpg', '37.795932', '-122.392051', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:00'), ('4', '1', '1', '1', null, '047-88f7786b-f9bf-47eb-87f2-c375e881d4b8.jpg', '34.115784', '-118.328934', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:19'), ('5', '2', '1', '1', null, '038-5b45c538-74ee-4d92-b2d5-8cc533cf3700.jpg', '40.722531', '-73.987138', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:35'), ('6', '3', '1', '1', null, '047-3ac96451-ca4a-416b-9d6c-35904f0c1636.jpg', '45.523452', '-122.676207', '1', null, null, null, null, null, null, null, null, '2010-06-30 14:57:50'), ('7', '1', '1', '1', '045-99d026b6-1c0f-4fd4-937b-ffb5bb4a21f3.jpg', '037-e7f533f0-daf0-4b01-916a-697a26868dfc.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:23'), ('8', '1', '1', '1', '043-2885a17b-e81a-4cf9-ad57-401182299ff2.jpg', '012-a5fc0529-f268-461a-9f32-f15c2f0971da.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:26'), ('9', '1', '1', '1', '010-ae4b8cbf-6884-4a59-b949-47b5689dc12e.jpg', '032-b0301bf1-93ce-4604-a536-a0a8591f88e0.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:28'), ('10', '1', '1', '1', '048-da0f678c-5d6a-44da-bd83-ab768e226525.jpg', '032-189df7b0-8b40-4284-b8e6-e17f145ae01c.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:31'), ('11', '1', '1', '1', '028-ff683e97-8340-4f19-ad9f-16e3c1c336ed.jpg', '026-0676a183-c6af-4d9a-8278-076138a1cbd0.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:34'), ('12', '1', '1', '1', '047-0f7bde10-4696-40b0-9ab3-f05a024e2a15.jpg', '025-16d1bf40-cdb0-4a89-9d33-0990c2fead78.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:36'), ('13', '1', '1', '1', '004-1fa7f1ed-72f8-42e7-a322-121f0dee0379.jpg', '032-93a8b6ac-4e07-4c7d-a65c-d52e459f5160.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:38'), ('14', '1', '1', '1', '017-aa1e1c29-af66-4d0a-8fd8-a0b5e27b32c3.jpg', '046-d1b8307e-d65f-415b-a6f6-eba1a329244a.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:40'), ('15', '1', '1', '1', '036-4ed96e48-ae71-47e5-a366-5848650a6ec1.jpg', '043-9563f30b-7874-4e79-aab0-d647f91f4efc.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:41'), ('16', '1', '1', '1', '022-db471d42-8dae-4e92-823d-b92c06497d9a.jpg', '008-a60ba5b5-e3f8-4732-a6d3-163ad589d829.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:44'), ('17', '1', '1', '1', '029-8f8202f0-1c76-47b3-aeb4-c1d1869e7b41.jpg', '046-e9b5e8c4-83b5-453a-a42c-2798e24f8dc6.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:47'), ('18', '1', '1', '1', '011-c5dc8e15-316b-4541-9029-76acc3e0149f.jpg', '010-642e9ff8-d751-4a49-849c-bf0c7df72e1a.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:34:49'), ('19', '1', '1', '1', '017-850ff7ab-4d04-4d49-a26f-2b7dfbcecf01.jpg', '009-3996dac2-b5ce-4923-a102-a6f59dd4bf7d.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:41'), ('20', '1', '1', '1', '010-923bcc14-496d-41fb-be9f-37541b062f17.jpg', '045-b9867252-bf31-49c1-9d5e-19fd125a9d08.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:43'), ('21', '1', '1', '1', '014-fdbad8b4-0b5f-4710-bd44-b450ff233192.jpg', '037-c49197cd-0a8a-4642-af88-37bfa3a1ae15.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:45'), ('22', '1', '1', '1', '012-6fd58950-fb59-4252-bfc1-94ed0ceb4031.jpg', '035-a4cf6499-d7c3-4313-9787-13518c4c3eda.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:48'), ('23', '1', '1', '1', '043-3741391f-64f7-4924-8c8a-fed7ac224df5.jpg', '011-66b74e07-26de-43cf-8c5e-177d2ec718cd.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:50'), ('24', '1', '1', '1', '019-1928c292-0549-4dc9-a42f-14b8b7edf25e.jpg', '009-74ae139b-8ea9-4312-acd2-200ba0ece7b4.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:53'), ('25', '1', '1', '1', '018-a63496bd-8306-40ce-8cb9-96db17953cbc.jpg', '000-2ab4dac3-6efd-4de6-8790-51e759d9ae10.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:55'), ('26', '1', '1', '1', '025-c333bceb-45a2-42de-ab63-2f6551972c99.jpg', '013-abea5c06-5fdb-4e25-9507-d01aa05994a6.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:35:58'), ('27', '1', '1', '1', '040-54dbb5d8-9612-45c6-ab72-065b2801e8da.jpg', '022-d5f65a7f-b486-4df0-9757-8556e1fed8ad.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:02'), ('28', '1', '1', '1', '012-a106f500-ae6a-4485-ba76-13cc26c501b8.jpg', '020-621d0036-92cc-4917-9e8c-91b650feeaa6.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:04'), ('29', '1', '1', '1', '012-bcb9be33-b53a-4775-bd57-eb2045733cc3.jpg', '042-5c0e0ae0-78f5-45b0-a6cc-18012bd4d529.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:06'), ('30', '1', '1', '1', '040-c4e3ac9a-8235-4964-b6e7-9167a46d49b5.jpg', '009-1979e546-746f-4472-b731-94eb6010103b.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:09'), ('31', '1', '1', '1', '042-00f0e251-50a6-4b6f-a274-9674a3e39f47.jpg', '005-e39c9d98-a1b4-4f86-99d3-e934aff275cb.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:11'), ('32', '1', '1', '1', '007-d845ee0e-5a90-4b15-b673-4584e2bc4469.jpg', '011-ec24d438-f2e3-4268-a909-771ac9571d31.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:13'), ('33', '1', '1', '1', '041-56faf276-e878-4896-baee-2852dec1d207.jpg', '020-678dc0a4-a656-41db-b592-a321b7e7859c.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:15'), ('34', '1', '1', '1', '026-a91da8f3-c64c-4bc6-9600-9c2543d17041.jpg', '008-2989b8aa-1738-4fcf-b20f-1dd149babbe6.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:18'), ('35', '1', '1', '1', '030-4f7773ab-3a55-4bec-bef4-eb6fe3e76b67.jpg', '043-fe816904-2002-4432-8ed5-f6af5c131fce.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:19'), ('36', '1', '1', '1', '007-568754a1-3f82-413e-bfc3-a9fd118a638f.jpg', '030-33556a37-5e4a-44ed-a5d5-284af0b13f48.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:46'), ('37', '1', '1', '1', '019-651fc270-9ef2-449d-bbfe-bf4bf25cce54.jpg', '022-7efa4a71-154c-4787-9559-b44f33a51292.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:49'), ('38', '1', '1', '1', '010-d0e38863-35e3-4935-8d61-3b6d9d874fea.jpg', '026-83eb9493-07b3-444f-a52a-fd99e877d890.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:51'), ('39', '1', '1', '1', '026-4c0c203a-3a85-45c3-a1b6-a46ade66251d.jpg', '025-eb1cb78b-04d8-44d4-9e8f-a1c28f515b2b.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:54'), ('40', '1', '1', '1', '034-fc85a2e9-4ebc-443f-8811-711622c84d9a.jpg', '005-1d697755-85c9-42c4-8158-d0b6ab2acd45.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:56'), ('41', '1', '1', '1', '045-5ca2a580-0c82-466f-8c4c-961f583ed99d.jpg', '043-555e1e2d-2244-4321-b60b-dca120a47491.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:36:59'), ('42', '1', '1', '1', '005-af71029e-bb11-41e8-81b0-9ad908f1c76a.jpg', '035-359c1e7b-796b-4c42-852f-f077c8856703.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:02'), ('43', '1', '1', '1', '023-6f5b917a-94de-4f26-9c52-d987d453cca1.jpg', '025-1446612b-cf62-47f6-bbc7-ae652c6f8328.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:04'), ('44', '1', '1', '1', '020-41adf87f-daa1-4e00-99b9-0059722f7040.jpg', '009-3e7bacb1-0f83-4167-a0b1-f250f68c486f.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:07'), ('45', '1', '1', '1', '023-35907ecd-69cf-4b76-803e-cda8c91a4edd.jpg', '023-30effac2-67b5-46d7-a1f9-334baa43b424.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:09'), ('46', '1', '1', '1', '047-28fdc854-ad69-4221-b218-30ab20ebba08.jpg', '004-6509048b-5b5e-4b78-8276-6b3f79cc3969.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:12'), ('47', '1', '1', '1', '046-6dbdcc17-8c4b-4360-aea1-8a26265b4ee7.jpg', '037-49d176dd-0195-4931-8bd8-a0bb4a9a2497.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:15'), ('48', '1', '1', '1', '026-8430fe51-2bd9-4c60-a9a4-4b7dbf0e62ef.jpg', '045-6c5ca794-78cf-4b34-a2f8-b14496c8b47c.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:17'), ('49', '1', '1', '1', '007-54af87d7-fbc5-4e8e-a88c-21d0e88b5b9d.jpg', '025-9d860277-4920-4492-ba4a-8b6ecec1f0d9.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:20'), ('50', '1', '1', '1', '009-bb5b990e-652f-4c53-a5ff-3a49c0539453.jpg', '042-898a337c-d860-4127-9ea7-981329138cd7.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:22'), ('51', '1', '1', '1', '026-89664e8a-23fd-4376-8733-3de721ec7927.jpg', '035-7ee6a649-930b-4abb-818b-d03601f069a1.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:25'), ('52', '1', '1', '1', '007-2d6c3498-deef-4223-82f9-f263bae8e8ff.jpg', '038-d4c3eab0-0d38-4071-8a8a-ac28c3f85bc3.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:27'), ('53', '1', '1', '1', '020-13b92056-6818-43e0-8c61-fc1dc305ee97.jpg', '003-e82d59ba-1467-4769-a7fb-2cb1f07e067e.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:29'), ('54', '1', '1', '1', '020-2870774b-96c0-4049-9044-71f8778355a7.jpg', '012-f3da006c-64c4-4d93-904e-f12c3e06cc29.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:31'), ('55', '1', '1', '1', '048-bbff1462-42b2-4f7e-8b10-612cb16f0dc7.jpg', '037-7b27877c-d893-4674-930d-f35be1345ca3.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:33'), ('56', '1', '1', '1', '014-5bfcae28-cc77-4a9f-ac94-f97141440b2a.jpg', '035-a1e4c49b-631b-4d18-932e-d3902e79154d.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:35'), ('57', '1', '1', '1', '029-ee52621d-9379-4819-aec5-3faa51844c1e.jpg', '043-5ef01e82-a975-48ed-b307-a6a6549f84ed.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 11:37:37'), ('58', '1', '1', '1', '028-1115ea3f-c1f9-482c-a086-5759545d2926.jpg', '003-3693b4b2-112f-425a-be8c-f3bce0e88fcd.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 12:04:27'), ('59', '1', '1', '1', '049-e77a904d-6d08-4d95-b633-caeb3def4a69.jpg', '006-b878272e-c56d-4458-b3cf-6fc227234c52.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 12:04:29'), ('60', '1', '6', '2', '011-b0cd7f24-23cf-4b72-80cc-ad9816c2750a.jpg', '009-f2733d28-fed6-4dcd-83b2-a6dd9b604b10.jpg', '0', '0', '90', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', '2010-08-07 12:04:31');

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
INSERT INTO `user` VALUES ('1', 'aaron', 'aaron.smith@mccannsf.com', '66b37b3e454fa4f25e0b6488341e8f89', '5', '1', '56', '2010-06-30 14:49:19'), ('2', 'malcolm', 'malcolm.wilson@mccannsf.com', '7b8b08ba43f9784f370d8341ccc28b58', '0', '0', '2', '2010-06-30 14:49:49'), ('3', 'jonathan', 'jonathan.rose@mccannsf.com', '78842815248300fa6ae79f7776a5080a', '0', '0', '2', '2010-06-30 14:50:41');
