-- phpMyAdmin SQL Dump
-- version 2.11.2.1
-- http://www.phpmyadmin.net
--
-- Host: mysql.dota-guild.com
-- Generation Time: Sep 15, 2008 at 02:40 PM
-- Server version: 4.1.16
-- PHP Version: 4.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `dotaraid`
--

--
-- Dumping data for table `cclasses`
--

INSERT INTO `cclasses` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES
(3, 'Priest', 'ffffff', NULL, NULL),
(5, 'Druid', 'FF7D0A', NULL, NULL),
(6, 'Shaman', '2459FF', NULL, NULL),
(7, 'Warrior', 'C79C6E', NULL, NULL),
(8, 'Rogue', 'FFF569', NULL, NULL),
(9, 'Warlock', '9482CA', NULL, NULL),
(10, 'Mage', '69CCF0', NULL, NULL),
(11, 'Paladin', 'F58CBA', NULL, NULL),
(12, 'Hunter', 'ABD473', NULL, NULL);

--
-- Dumping data for table `cclass_roles`
--

INSERT INTO `cclass_roles` (`id`, `cclass_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 3, 1, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(2, 3, 2, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(3, 5, 1, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(4, 5, 2, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(5, 5, 4, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(6, 6, 1, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(7, 6, 2, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(8, 6, 3, '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(9, 7, 1, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(10, 7, 4, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(11, 7, 3, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(12, 8, 1, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(13, 8, 3, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(14, 9, 1, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(15, 10, 1, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(16, 10, 4, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(17, 11, 1, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(18, 11, 2, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(19, 11, 4, '2008-04-07 18:23:08', '2008-04-07 18:23:08'),
(20, 12, 1, '2008-04-07 18:23:08', '2008-04-07 18:23:08');

--
-- Dumping data for table `instances`
--

INSERT INTO `instances` (`id`, `name`, `requires_key`, `max_number`, `min_level`, `max_level`, `created_at`, `updated_at`) VALUES
(1, 'Custom', 0, 40, 1, 70, NULL, NULL),
(2, 'Custom', 0, 25, 1, 70, NULL, NULL),
(3, 'Custom', 0, 15, 1, 70, NULL, NULL),
(4, 'Custom', 0, 10, 1, 70, NULL, NULL),
(5, 'Custom', 0, 5, 1, 70, NULL, NULL),
(6, 'Karazhan', 0, 10, 70, 70, NULL, '2008-07-07 08:53:58'),
(7, 'Gruul''s Lair', 0, 25, 70, 70, NULL, NULL),
(8, 'Tempest Keep: The Mechanar', 0, 5, 70, 70, NULL, NULL),
(9, 'Tempest Keep: The Mechanar (Heroic)', 0, 5, 70, 70, NULL, NULL),
(10, 'Tempest Keep: The Arcatraz', 0, 5, 70, 70, NULL, NULL),
(11, 'Tempest Keep: The Arcatraz (Heroic)', 0, 5, 70, 70, NULL, NULL),
(12, 'Tempest Keep: The Botanica', 0, 5, 70, 70, NULL, NULL),
(13, 'Tempest Keep: The Botanica (Heroic)', 0, 5, 70, 70, NULL, NULL),
(15, 'Hellfire Citadel: Hellfire Ramparts', 0, 5, 59, 70, NULL, NULL),
(16, 'Hellfire Citadel: Hellfire Ramparts (Heroic)', 0, 5, 70, 70, NULL, NULL),
(17, 'Hellfire Citadel: The Blood Furnace', 0, 5, NULL, NULL, NULL, NULL),
(18, 'Hellfire Citadel: The Blood Furnace (Heroic)', 0, 5, 70, 70, NULL, NULL),
(19, 'Hellfire Citadel: The Shattered Halls', 0, 5, 69, 70, NULL, NULL),
(20, 'Hellfire Citadel: The Shattered Halls (Heroic)', 0, 5, 70, 70, NULL, NULL),
(26, 'Auchindoun: Auchenai Crypts', 0, 5, 67, 70, NULL, NULL),
(27, 'Auchindoun: Auchenai Crypts (Heroic)', 0, 5, 70, 70, NULL, NULL),
(28, 'Auchindoun: Mana-Tombs', 0, 5, NULL, NULL, NULL, NULL),
(29, 'Auchindoun: Mana-Tombs (Heroic)', 0, 5, 70, 70, NULL, NULL),
(30, 'Auchindoun: Sethekk Halls', 0, 5, 67, 70, NULL, NULL),
(31, 'Auchindoun: Sethekk Halls (Heroic)', 0, 5, 70, 70, NULL, NULL),
(32, 'Auchindoun: Shadow Labyrinth', 0, 5, 69, 70, NULL, NULL),
(33, 'Auchindoun: Shadow Labyrinth (Heroic)', 0, 5, 70, 70, NULL, NULL),
(34, 'Blackfathom Deeps', 0, 5, NULL, NULL, NULL, NULL),
(35, 'Blackrock Depths', 0, 5, NULL, NULL, NULL, NULL),
(36, 'Blackrock Spire (Upper)', 0, 10, 57, 70, NULL, NULL),
(37, 'Caverns of Time: Old Hillsbrad Foothills', 0, 5, 68, 70, NULL, NULL),
(38, 'Caverns of Time: Old Hillsbrad Foothills (Heroic)', 0, 5, 70, 70, NULL, NULL),
(39, 'Caverns of Time: The Black Morass', 0, 5, 68, 70, NULL, NULL),
(40, 'Caverns of Time: The Black Morass (Heroic)', 0, 5, 70, 70, NULL, NULL),
(41, 'Coilfang Reservoir: The Slave Pens', 0, 5, 61, 70, NULL, NULL),
(42, 'Coilfang Reservoir: The Slave Pens (Heroic)', 0, 5, 70, 70, NULL, NULL),
(43, 'Coilfang Reservoir: The Steamvault', 0, 5, 68, 70, NULL, NULL),
(44, 'Coilfang Reservoir: The Steamvault (Heroic)', 0, 5, 70, 70, NULL, NULL),
(45, 'Coilfang Reservoir: The Underbog', 0, 5, 62, 70, NULL, NULL),
(46, 'Coilfang Reservoir: The Underbog (Heroic)', 0, 5, 70, 70, NULL, NULL),
(47, 'Dire Maul North', 0, 5, 58, 70, NULL, NULL),
(48, 'Dire Maul West', 0, 5, 58, 70, NULL, NULL),
(49, 'Dire Maul East', 0, 5, 55, 70, NULL, NULL),
(50, 'Blackrock Spire (Lower)', 0, 10, NULL, NULL, NULL, NULL),
(51, 'Gnomeregan', 0, 5, NULL, NULL, NULL, NULL),
(52, 'Maraudon', 0, 5, NULL, NULL, NULL, NULL),
(53, 'Ragefire Chasm', 0, 5, NULL, NULL, NULL, NULL),
(54, 'Razorfen Downs', 0, 5, NULL, NULL, NULL, NULL),
(55, 'Razorfen Kraul', 0, 5, NULL, NULL, NULL, NULL),
(56, 'Scarlet Monastery', 0, 5, NULL, NULL, NULL, NULL),
(57, 'Scholomance', 0, 5, NULL, NULL, NULL, NULL),
(58, 'Shadowfang Keep', 0, 5, NULL, NULL, NULL, NULL),
(59, 'Stratholme (West)', 0, 5, NULL, NULL, NULL, NULL),
(60, 'Stratholme (East)', 0, 5, NULL, NULL, NULL, NULL),
(61, 'Sunken Temple', 0, 5, NULL, NULL, NULL, NULL),
(62, 'The Deadmines', 0, 5, 16, 26, NULL, NULL),
(63, 'The Stockade', 0, 5, NULL, NULL, NULL, NULL),
(64, 'Uldaman', 0, 5, NULL, NULL, NULL, NULL),
(65, 'Wailing Caverns', 0, 5, NULL, NULL, NULL, NULL),
(66, 'Zul''Farrak', 0, 5, NULL, NULL, NULL, NULL),
(67, 'Black Temple', 1, 25, 70, 70, NULL, NULL),
(68, 'Blackwing Lair', 1, 40, 60, 70, NULL, NULL),
(69, 'Caverns of Time: Hyjal Summit', 1, 25, 70, 70, NULL, NULL),
(70, 'Coilfang Reservoir: Serpentshrine Cavern', 0, 25, 70, 70, NULL, NULL),
(71, 'Hellfire Citadel: Magtheridon''s Lair', 0, 25, 70, 70, NULL, NULL),
(72, 'Molten Core', 1, 40, 60, 70, NULL, NULL),
(73, 'Naxxramas', 1, 40, 60, 70, NULL, NULL),
(74, 'Onyxia''s Lair', 1, 40, 60, 70, NULL, NULL),
(75, 'Ruins of Ahn''Qiraj', 0, 20, 60, 70, NULL, NULL),
(76, 'Tempest Keep: The Eye', 0, 25, 70, 70, NULL, NULL),
(77, 'Temple of Ahn''Qiraj', 0, 40, 60, 70, NULL, NULL),
(78, 'Zul''Aman', 0, 10, 70, 70, NULL, NULL),
(79, 'Zul''Gurub', 0, 20, 55, 70, NULL, NULL);

--
-- Dumping data for table `races`
--

INSERT INTO `races` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Human', NULL, NULL),
(2, 'Gnome', NULL, NULL),
(3, 'Blood Elf', NULL, NULL),
(4, 'Orc', NULL, NULL),
(5, 'Troll', NULL, NULL),
(6, 'Tauren', NULL, NULL),
(7, 'Undead', NULL, NULL),
(8, 'Dwarf', NULL, NULL),
(9, 'Night Elf', NULL, NULL),
(10, 'Draenei', NULL, NULL);

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'DPS', '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(2, 'Healer', '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(3, 'Interrupt', '2008-04-07 18:23:07', '2008-04-07 18:23:07'),
(4, 'Tank', '2008-04-07 18:23:07', '2008-04-07 18:23:07');
