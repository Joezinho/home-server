-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: main-db
-- ------------------------------------------------------
-- Server version	5.7.17

USE `main-db`;

--
-- Estrutura da tabela `players`
-- 
CREATE TABLE IF NOT EXISTS `players`(
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `a` float DEFAULT '0',
  `interior` int(11) DEFAULT '0',
  `virtual_world` int(11) DEFAULT '0',
  `spawn` int(11) DEFAULT '0',
  `health` float DEFAULT '100',
  `armour` float DEFAULT '0',
  `skin` float DEFAULT '188',
  `last_login` int(11) DEFAULT '0',
  `played_time` int(11) DEFAULT '0',
  `regdate` int(11) DEFAULT '0',
  `gender` tinyint NOT NULL DEFAULT '0',
  `money` int(11) NOT NULL DEFAULT '350',
  `level` int(10) NOT NULL DEFAULT '1',
  `isOnline` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);

-- 
-- Indíces para a tabela `players`
-- 
ALTER TABLE `players` ADD
  INDEX usr_ind (user_id), ADD
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;