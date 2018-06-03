-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: main-db
-- ------------------------------------------------------
-- Server version	5.7.17

USE `main-db`;

--
-- Estrutura da tabela `users`
-- 
CREATE TABLE IF NOT EXISTS `users`(
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`name` varchar(24) NOT NULL,
`username` varchar(24) NOT NULL,
`password` varchar(256) NOT NULL,
`email` varchar(50) NOT NULL,
`birthdate` varchar(32) NOT NULL,
`created_at` date DEFAULT CURRENT_TIMESTAMP
);

--
-- Indíces para tabela `users`
--
ALTER TABLE `users`
	ADD PRIMARY KEY(`id`);