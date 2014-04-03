/* Voice Conversion Schema */


CREATE TABLE IF NOT EXISTS 
`users` (
	`id` int(11) AUTO_INCREMENT,
	`name` varchar(256) NOT NULL,
	`email` varchar(256) NOT NULL,
	`password` varchar(256) NOT NULL,
	`profile_pic` varchar(4096),
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 



CREATE TABLE IF NOT EXISTS 
`user_properties` (
	`id` int(11) AUTO_INCREMENT,
	`user_id` int(11),
	`completed_training` boolean,
	`paragraph_read_count` int(11),
	FOREIGN KEY (`user_id`) REFERENCES users(`id`),
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS 
`paragraphs` (
	`id` int(11) AUTO_INCREMENT,
	`text` varchar(8192),
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 



CREATE TABLE IF NOT EXISTS 
`user_paragraphs` (
	`id` int(11) AUTO_INCREMENT,
	`user_id` int(11),
	`paragraph_id` int(11),
	FOREIGN KEY (`user_id`) REFERENCES users(`id`),
	FOREIGN KEY (`paragraph_id`) REFERENCES paragraphs(`id`),
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS 
`trained_couple` (
	`id` int(11) AUTO_INCREMENT,
	`user1_id` int(11),
	`user2_id` int(11),
	FOREIGN KEY (`user1_id`) REFERENCES users(`id`),
	FOREIGN KEY (`user2_id`) REFERENCES users(`id`),
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 

