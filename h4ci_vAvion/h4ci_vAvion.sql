CREATE TABLE `avion` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `avion` (`name`, `model`, `price`, `category`) VALUES
('luxor', 'luxor', 900000, 'avion'),
('Buzzard', 'buzzard2', 7500, 'helico'),
;

CREATE TABLE `avion_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `avion_categories` (`name`, `label`) VALUES
('avion', 'Avion'),
('helico', 'Helico'),
;

ALTER TABLE `avion`
  ADD PRIMARY KEY (`model`);

ALTER TABLE `avion_categories`
  ADD PRIMARY KEY (`name`);
COMMIT;


CREATE TABLE IF NOT EXISTS `owned_plane` (
	`owner` varchar(40) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` varchar(20) NOT NULL DEFAULT 'car',
	`job` varchar(20) NOT NULL DEFAULT 'civ',
	`stored` tinyint(1) NOT NULL DEFAULT '0',
	
	PRIMARY KEY (`plate`)
);
