DROP TABLE IF EXISTS `blacksmith_stock`;
CREATE TABLE IF NOT EXISTS `blacksmith_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blacksmith` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `item` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
