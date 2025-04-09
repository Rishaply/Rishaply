-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql105.byetcluster.com
-- Generation Time: Apr 06, 2025 at 09:50 AM
-- Server version: 10.6.21-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_36918650_Test`
--

-- --------------------------------------------------------

--
-- Table structure for table `blocked_friends`
--

CREATE TABLE `blocked_friends` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `blocked_user_id` int(11) NOT NULL,
  `blocked_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blocked_users`
--

CREATE TABLE `blocked_users` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `friends`
--

INSERT INTO `friends` (`id`, `user_id`, `friend_id`) VALUES
(10, 37, 40),
(2, 35, 41),
(3, 35, 36),
(13, 36, 40),
(12, 36, 41),
(11, 36, 37),
(8, 42, 40),
(9, 37, 42);

-- --------------------------------------------------------

--
-- Table structure for table `friend_requests`
--

CREATE TABLE `friend_requests` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `friend_requests`
--

INSERT INTO `friend_requests` (`id`, `sender_id`, `receiver_id`) VALUES
(14, 37, 35);

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `privacy` enum('public','private') NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`, `description`, `privacy`, `icon`, `created_by`, `created_at`) VALUES
(27, 'Minecraft ', 'Minecraft world ', 'public', 'uploads/groups/1742094443_1000075783.png', 36, '2025-03-16 03:07:23'),
(22, 'Rishaply', 'Mun changa to kathauti me ganga, don\'t wear suit always wear kaccha ya stay nanga!!', 'public', 'uploads/groups/1737341995_1000078393.png', 35, '2025-01-20 02:59:55'),
(23, 'ChatWithUs ', 'Welcome ðŸ¤— to my group i m admin of the website ', 'public', 'uploads/groups/1738409075_1000079024.jpg', 36, '2025-02-01 11:24:35'),
(25, 'Limleki1828Y', 'Go away to the world', 'public', 'uploads/groups/1740217073_Limleki.png', 40, '2025-02-22 09:37:53'),
(29, 'RishaplyOp', 'My own group ', 'private', 'uploads/groups/1743861418_1000080668.png', 36, '2025-04-05 13:56:58'),
(30, 'Test', 'After dark', 'private', 'uploads/groups/1743861918_1000080532.png', 36, '2025-04-05 14:05:18');

-- --------------------------------------------------------

--
-- Table structure for table `group_invites`
--

CREATE TABLE `group_invites` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `inviter_id` int(11) NOT NULL,
  `invitee_id` int(11) NOT NULL,
  `invited_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `group_invites`
--

INSERT INTO `group_invites` (`id`, `group_id`, `inviter_id`, `invitee_id`, `invited_at`) VALUES
(23, 27, 36, 37, '2025-03-31 01:51:45');

-- --------------------------------------------------------

--
-- Table structure for table `group_likes`
--

CREATE TABLE `group_likes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `group_likes`
--

INSERT INTO `group_likes` (`id`, `user_id`, `group_id`) VALUES
(144, 40, 25),
(150, 40, 22),
(142, 35, 25),
(87, 35, 22),
(148, 40, 28),
(130, 41, 27),
(123, 36, 23),
(97, 36, 22),
(85, 35, 23),
(145, 40, 23),
(134, 36, 27),
(149, 40, 27),
(151, 36, 29),
(146, 37, 25);

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `group_members`
--

INSERT INTO `group_members` (`id`, `group_id`, `user_id`, `joined_at`) VALUES
(25, 22, 109, '2025-01-27 02:42:21'),
(54, 22, 36, '2025-03-16 02:54:49'),
(24, 22, 180, '2025-01-26 14:17:44'),
(47, 22, 35, '2025-03-13 15:52:43'),
(50, 23, 41, '2025-03-14 05:00:33'),
(26, 22, 37, '2025-01-31 01:55:24'),
(42, 25, 35, '2025-03-01 09:53:16'),
(33, 24, 37, '2025-02-14 02:46:23'),
(30, 22, 864, '2025-02-07 11:00:59'),
(31, 22, 39, '2025-02-11 02:54:46'),
(43, 23, 35, '2025-03-04 02:38:36'),
(49, 25, 41, '2025-03-14 05:00:31'),
(75, 25, 37, '2025-03-21 12:17:18'),
(90, 27, 41, '2025-03-30 05:51:07'),
(92, 23, 40, '2025-04-02 10:43:03'),
(51, 22, 41, '2025-03-14 05:00:35'),
(52, 23, 36, '2025-03-15 05:08:48'),
(63, 27, 35, '2025-03-20 13:24:40'),
(86, 22, 40, '2025-03-28 04:25:54'),
(91, 25, 40, '2025-04-02 10:42:59'),
(101, 30, 36, '2025-04-06 13:03:23'),
(82, 25, 42, '2025-03-23 13:30:16'),
(81, 27, 42, '2025-03-23 13:30:06'),
(83, 23, 42, '2025-03-23 13:30:19'),
(84, 22, 42, '2025-03-23 13:30:20'),
(85, 27, 36, '2025-03-26 11:24:46'),
(99, 29, 36, '2025-04-06 01:57:52');

-- --------------------------------------------------------

--
-- Table structure for table `group_messages`
--

CREATE TABLE `group_messages` (
  `id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `group_messages`
--

INSERT INTO `group_messages` (`id`, `group_id`, `sender_id`, `message`, `created_at`) VALUES
(71, 25, 35, 'new latest update released 4.0 ', '2025-03-02 17:53:03'),
(74, 22, 37, 'Here', '2025-03-05 21:02:38'),
(75, 22, 35, 'Hello copy ', '2025-03-06 17:27:12'),
(86, 22, 40, 'Hello', '2025-03-23 05:55:03'),
(66, 23, 35, 'Hi', '2025-02-24 19:14:50'),
(65, 22, 37, 'Hgg', '2025-02-15 02:16:45'),
(64, 22, 39, 'Hi guys', '2025-02-10 18:54:57'),
(81, 25, 40, 'Ok sir ji', '2025-03-20 02:10:30'),
(82, 27, 36, 'Hi i m ChatWithUs also my minecraft username id Rishaply9959', '2025-03-20 06:33:51'),
(61, 22, 864, 'Cghvg', '2025-02-07 03:01:11'),
(60, 22, 864, 'Hj', '2025-02-07 03:01:04'),
(59, 22, 35, 'Hi bro welcome!!!!', '2025-02-06 19:05:57'),
(79, 22, 36, 'Hi', '2025-03-18 08:23:59'),
(49, 22, 35, 'Hi guys welcome to my group', '2025-01-26 00:27:52'),
(58, 23, 35, 'Hi', '2025-02-06 05:06:49'),
(87, 25, 40, 'Fuck you', '2025-03-27 21:24:11'),
(91, 23, 40, 'Hello', '2025-04-02 03:43:28'),
(89, 27, 35, 'Hi admin ChatWithUs', '2025-03-31 07:13:13'),
(90, 25, 37, 'Hello', '2025-04-01 01:37:47');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `attachment` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `timestamp`, `attachment`, `is_read`) VALUES
(515, 37, 35, 'Gandi', '2025-03-14 02:12:55', NULL, 0),
(455, 39, 35, 'Hi bro', '2025-02-10 18:55:38', NULL, 0),
(487, 37, 40, 'Hell', '2025-03-08 06:08:26', NULL, 0),
(451, 35, 37, 'Watch this', '2025-02-09 18:35:57', 'uploads/private/67a9660cf2401_Rishaply.mp4', 0),
(526, 41, 35, 'Hi', '2025-03-14 02:31:30', NULL, 0),
(572, 37, 35, 'https://www.amazon.in/apay/landing/mobile-prepaid', '2025-03-24 18:22:53', NULL, 0),
(498, 37, 35, 'Gg', '2025-03-11 09:52:03', NULL, 0),
(499, 37, 35, 'Gg', '2025-03-11 09:52:06', NULL, 0),
(448, 35, 36, 'Hi', '2025-01-28 18:53:43', NULL, 0),
(479, 35, 39, 'V', '2025-02-26 17:45:14', NULL, 0),
(491, 40, 36, 'Hello', '2025-03-08 21:08:25', NULL, 0),
(492, 37, 37, 'Hi', '2025-03-11 06:12:30', NULL, 0),
(445, 180, 35, 'Hi', '2025-01-26 06:17:24', NULL, 0),
(524, 35, 41, 'Hi', '2025-03-14 02:28:52', NULL, 0),
(495, 41, 41, 'Hello bro', '2025-03-11 06:32:58', NULL, 0),
(496, 41, 40, 'Hi babua new update released with great features enjoy ðŸ˜„!!!!!', '2025-03-11 06:57:31', NULL, 0),
(440, 35, 35, 'Hello', '2025-01-17 02:30:47', NULL, 0),
(570, 42, 40, 'Hi', '2025-03-21 05:21:27', NULL, 0),
(500, 37, 35, 'Gg', '2025-03-11 09:52:08', NULL, 0),
(458, 40, 35, 'Sab thik.', '2025-02-21 00:16:53', NULL, 0),
(475, 35, 40, 'Hi', '2025-02-26 05:46:11', NULL, 0),
(494, 41, 41, 'Hi', '2025-03-11 06:32:43', NULL, 0),
(477, 35, 36, 'Y', '2025-02-26 17:44:55', NULL, 0),
(478, 35, 39, 'V', '2025-02-26 17:45:05', NULL, 0),
(463, 37, 35, 'Hi', '2025-02-26 01:16:30', NULL, 0),
(486, 35, 40, 'Chodu', '2025-03-06 04:26:40', NULL, 0),
(484, 35, 35, 'Hi i m you and you is me what are you doing right now i m just fucking tired and border don\'t you tired and bored anymore bro', '2025-03-01 01:51:47', NULL, 0),
(485, 35, 40, 'Hi', '2025-03-06 04:26:19', NULL, 0),
(482, 35, 37, 'test for working or not', '2025-03-01 01:44:31', NULL, 0),
(517, 35, 40, 'Hi', '2025-03-14 02:14:26', NULL, 0),
(514, 41, 35, 'Hi', '2025-03-14 02:06:33', NULL, 0),
(529, 41, 35, 'Test', '2025-03-14 02:54:10', NULL, 0),
(530, 41, 35, 'H', '2025-03-14 02:54:28', NULL, 0),
(532, 35, 41, 'B', '2025-03-14 02:56:27', NULL, 0),
(533, 35, 41, 'P', '2025-03-14 02:56:43', NULL, 0),
(534, 35, 41, 'D', '2025-03-14 02:56:55', NULL, 0),
(535, 35, 41, 'V', '2025-03-14 02:57:18', NULL, 0),
(536, 41, 35, 'G', '2025-03-14 02:57:39', NULL, 0),
(538, 41, 41, 'G', '2025-03-14 02:57:57', NULL, 0),
(539, 41, 35, 'H', '2025-03-14 02:58:05', NULL, 0),
(540, 35, 41, 'H', '2025-03-14 03:00:38', NULL, 0),
(541, 35, 41, 'Ho', '2025-03-14 03:00:48', NULL, 0),
(542, 41, 41, 'G', '2025-03-14 03:00:55', NULL, 0),
(543, 35, 41, 'Bnn', '2025-03-14 03:02:57', NULL, 0),
(544, 41, 35, 'Hhhh', '2025-03-14 03:03:12', NULL, 0),
(545, 41, 35, 'Hhhh', '2025-03-14 03:03:12', NULL, 0),
(546, 41, 35, 'Hhhh', '2025-03-14 03:03:13', NULL, 0),
(547, 41, 35, 'H', '2025-03-14 03:03:29', NULL, 0),
(553, 36, 36, 'Hi', '2025-03-15 06:31:37', NULL, 0),
(554, 36, 36, 'Bi', '2025-03-15 19:24:28', NULL, 0),
(555, 36, 36, 'Hi', '2025-03-15 22:15:51', NULL, 0),
(557, 40, 36, 'Bhgg', '2025-03-21 04:35:51', NULL, 0),
(558, 37, 37, 'Hi', '2025-03-21 04:47:59', 'uploads/private/67dd51efe4474_Screenshot_2025-01-28-16-31-36-782_com.dts.freefiremax.jpg', 0),
(564, 37, 35, 'Hi', '2025-03-21 04:53:35', NULL, 0),
(560, 37, 35, 'Bhgg', '2025-03-21 04:48:18', NULL, 0),
(583, 40, 37, 'L', '2025-04-03 00:29:51', NULL, 0),
(584, 40, 37, 'Hi', '2025-04-03 00:39:18', NULL, 0),
(585, 36, 41, 'Bu', '2025-04-03 20:07:04', NULL, 0),
(562, 37, 35, 'Hi', '2025-03-21 04:49:01', 'uploads/private/67dd522d8ef61_Screenshot_2025-01-21-10-09-06-849_com.dts.freefiremax.jpg', 0),
(563, 37, 35, 'Hi', '2025-03-21 04:49:19', 'uploads/private/67dd523f22b15_Screenshot_2025-01-21-10-09-06-849_com.dts.freefiremax.jpg', 0),
(571, 36, 40, 'die with a smile song image i hope you laura it', '2025-03-22 04:23:56', 'uploads/private/67de9dccbe095_1000080603.png', 0),
(569, 35, 37, 'Bjjd @copy', '2025-03-21 05:03:46', NULL, 0),
(573, 37, 40, 'Fuck you', '2025-03-29 03:36:13', NULL, 0),
(586, 36, 36, 'V', '2025-04-03 20:07:12', NULL, 0),
(575, 40, 41, 'limleki', '2025-03-29 06:42:13', 'uploads/private/67e7f8b5a668a_Screenshot_2024-12-24-13-01-03-591_com.document.reader.pdfreader.pdf.jpg', 0),
(582, 40, 42, 'Hello', '2025-04-02 03:39:19', NULL, 0),
(578, 36, 40, 'Solve this question â‰ï¸', '2025-03-31 07:24:28', 'uploads/private/67eaa59be49d5_IMG_20250311_193346.jpg', 0),
(580, 37, 42, 'Hello', '2025-04-01 01:40:51', NULL, 0),
(581, 40, 41, 'Fucker', '2025-04-02 03:32:28', NULL, 0),
(587, 36, 35, 'Hg', '2025-04-03 20:08:26', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `sender_id`, `receiver_id`, `message`, `is_read`, `created_at`) VALUES
(417, 35, 35, 'Hello', 0, '2025-01-17 10:30:47'),
(418, 37, 35, 'Hello dide', 0, '2025-01-19 14:08:21'),
(419, 35, 37, 'Hi', 0, '2025-01-21 02:56:51'),
(420, 35, 37, 'Hj', 0, '2025-01-26 14:08:43'),
(421, 35, 37, 'Gg', 0, '2025-01-26 14:10:33'),
(422, 180, 35, 'Hi', 0, '2025-01-26 14:17:24'),
(423, 109, 35, 'Hi', 0, '2025-01-27 02:43:29'),
(424, 35, 36, 'Hello', 0, '2025-01-29 02:53:39'),
(425, 35, 36, 'Hi', 0, '2025-01-29 02:53:43'),
(426, 36, 35, 'Hi bro', 0, '2025-01-29 02:54:04'),
(427, 35, 37, 'Watch this', 0, '2025-02-10 02:34:36'),
(428, 35, 37, 'Watch this', 0, '2025-02-10 02:35:57'),
(429, 35, 37, 'Watch hi', 0, '2025-02-10 10:30:12'),
(430, 35, 37, 'Hi', 0, '2025-02-10 10:34:33'),
(431, 35, 37, 'Jn', 0, '2025-02-10 10:34:36'),
(432, 39, 35, 'Hi bro', 0, '2025-02-11 02:55:38'),
(433, 35, 39, 'Ka karat bare tu avi', 0, '2025-02-21 08:12:32'),
(434, 35, 40, 'Ka hal', 0, '2025-02-21 08:16:39'),
(435, 40, 35, 'Sab thik', 0, '2025-02-21 08:16:53'),
(436, 37, 35, 'Hi', 0, '2025-02-22 01:12:10'),
(437, 35, 40, 'Hi', 0, '2025-02-23 01:24:04'),
(438, 35, 35, 'Hi', 0, '2025-02-26 09:07:25'),
(439, 35, 37, 'Hi', 0, '2025-02-26 09:15:25'),
(440, 37, 35, 'Hi', 0, '2025-02-26 09:16:30'),
(441, 40, 37, 'Hello', 0, '2025-02-26 12:22:00'),
(442, 37, 40, 'H8', 0, '2025-02-26 12:22:33'),
(443, 40, 37, 'Hello copy', 0, '2025-02-26 12:22:56'),
(444, 40, 37, 'Thanks', 0, '2025-02-26 12:23:18'),
(445, 40, 37, 'Ok', 0, '2025-02-26 12:24:06'),
(446, 40, 37, 'Ok', 0, '2025-02-26 12:24:08'),
(447, 40, 35, 'Ok bro fuck you', 0, '2025-02-26 12:32:13'),
(448, 35, 37, 'Hi', 0, '2025-02-26 12:52:07'),
(449, 35, 37, 'Hi', 0, '2025-02-26 12:55:36'),
(450, 35, 37, 'Hi', 0, '2025-02-26 13:45:23'),
(451, 35, 37, 'L', 0, '2025-02-26 13:45:31'),
(452, 35, 40, 'Hi', 0, '2025-02-26 13:46:11'),
(453, 35, 37, 'Test', 0, '2025-02-27 01:44:23'),
(454, 35, 36, 'Y', 0, '2025-02-27 01:44:55'),
(455, 35, 39, 'V', 0, '2025-02-27 01:45:05'),
(456, 35, 39, 'V', 0, '2025-02-27 01:45:14'),
(457, 35, 37, 'Nh', 0, '2025-03-01 09:41:34'),
(458, 35, 37, 'Nk', 0, '2025-03-01 09:42:43'),
(459, 35, 37, 'Hi', 0, '2025-03-01 09:44:31'),
(460, 35, 37, 'Nfnf', 0, '2025-03-01 09:47:04'),
(461, 35, 35, 'Hi i m you and you is me what are you doing right now i m just fucking tired and border don\'t you tired and bored anymore bro', 0, '2025-03-01 09:51:47'),
(462, 35, 40, 'Hi', 0, '2025-03-06 12:26:19'),
(463, 35, 40, 'Chodu', 0, '2025-03-06 12:26:40'),
(464, 37, 40, 'Hell', 0, '2025-03-08 14:08:26'),
(465, 35, 35, 'T', 0, '2025-03-08 15:54:14'),
(466, 40, 36, 'Hello', 0, '2025-03-09 05:07:00'),
(467, 36, 40, 'Hello', 0, '2025-03-09 05:07:44'),
(468, 40, 36, 'Hello', 0, '2025-03-09 05:08:25'),
(469, 37, 37, 'Hi', 0, '2025-03-11 13:12:30'),
(470, 35, 35, 'Hi', 0, '2025-03-11 13:20:25'),
(471, 41, 41, 'Hi', 0, '2025-03-11 13:32:43'),
(472, 41, 41, 'Hello bro', 0, '2025-03-11 13:32:58'),
(473, 41, 40, 'Hi babua new update released with great features enjoy ðŸ˜„!!!!!', 0, '2025-03-11 13:57:31'),
(474, 40, 40, 'Hello', 0, '2025-03-11 15:29:12'),
(475, 37, 35, 'Gg', 0, '2025-03-11 16:52:03'),
(476, 37, 35, 'Gg', 0, '2025-03-11 16:52:06'),
(477, 37, 35, 'Gg', 0, '2025-03-11 16:52:08'),
(478, 41, 35, 'Hi', 0, '2025-03-12 11:29:05'),
(479, 35, 40, 'Hello', 0, '2025-03-13 15:56:50'),
(480, 35, 35, 'Hi', 0, '2025-03-14 08:43:13'),
(481, 35, 35, 'Hi', 0, '2025-03-14 08:45:05'),
(482, 35, 35, 'Hi', 0, '2025-03-14 08:55:22'),
(483, 35, 35, 'R', 0, '2025-03-14 08:55:41'),
(484, 35, 35, 'Y', 0, '2025-03-14 08:55:52'),
(485, 35, 35, 'T', 0, '2025-03-14 08:55:57'),
(486, 35, 35, 'G', 0, '2025-03-14 08:55:59'),
(487, 41, 35, 'Hi', 0, '2025-03-14 08:57:42'),
(488, 41, 35, 'Hi', 0, '2025-03-14 08:57:42'),
(489, 35, 41, 'J', 0, '2025-03-14 08:59:54'),
(490, 35, 41, 'Hi', 0, '2025-03-14 09:00:22'),
(491, 41, 35, 'Hi', 0, '2025-03-14 09:06:33'),
(492, 37, 35, 'Gandi', 0, '2025-03-14 09:12:55'),
(493, 35, 37, 'Hi', 0, '2025-03-14 09:13:33'),
(494, 35, 40, 'Hi', 0, '2025-03-14 09:14:26'),
(495, 35, 35, 'Hi', 0, '2025-03-14 09:16:56'),
(496, 41, 35, 'Hi', 0, '2025-03-14 09:17:26'),
(497, 41, 35, 'Fi', 0, '2025-03-14 09:17:44'),
(498, 35, 35, 'Hi', 0, '2025-03-14 09:26:54'),
(499, 41, 35, 'Gu', 0, '2025-03-14 09:28:22'),
(500, 41, 35, 'B', 0, '2025-03-14 09:28:43'),
(501, 35, 41, 'Hi', 0, '2025-03-14 09:28:52'),
(502, 35, 35, 'Hi', 0, '2025-03-14 09:31:00'),
(503, 41, 35, 'Hi', 0, '2025-03-14 09:31:30'),
(504, 35, 35, 'H', 0, '2025-03-14 09:33:22'),
(505, 35, 35, 'Hi', 0, '2025-03-14 09:51:24'),
(506, 41, 35, 'Test', 0, '2025-03-14 09:54:10'),
(507, 41, 35, 'H', 0, '2025-03-14 09:54:28'),
(508, 35, 35, 'Hi', 0, '2025-03-14 09:55:49'),
(509, 35, 41, 'B', 0, '2025-03-14 09:56:27'),
(510, 35, 41, 'P', 0, '2025-03-14 09:56:43'),
(511, 35, 41, 'D', 0, '2025-03-14 09:56:55'),
(512, 35, 41, 'V', 0, '2025-03-14 09:57:18'),
(513, 41, 35, 'G', 0, '2025-03-14 09:57:39'),
(514, 35, 35, 'V', 0, '2025-03-14 09:57:49'),
(515, 41, 41, 'G', 0, '2025-03-14 09:57:57'),
(516, 41, 35, 'H', 0, '2025-03-14 09:58:05'),
(517, 35, 41, 'H', 0, '2025-03-14 10:00:38'),
(518, 35, 41, 'Ho', 0, '2025-03-14 10:00:48'),
(519, 41, 41, 'G', 0, '2025-03-14 10:00:55'),
(520, 35, 41, 'Bnn', 0, '2025-03-14 10:02:57'),
(521, 41, 35, 'Hhhh', 0, '2025-03-14 10:03:12'),
(522, 41, 35, 'Hhhh', 0, '2025-03-14 10:03:12'),
(523, 41, 35, 'Hhhh', 0, '2025-03-14 10:03:13'),
(524, 41, 35, 'H', 0, '2025-03-14 10:03:29'),
(525, 35, 41, 'H', 0, '2025-03-14 10:03:42'),
(526, 35, 41, 'Bk', 0, '2025-03-14 10:05:41'),
(527, 35, 41, 'Fl', 0, '2025-03-14 10:08:37'),
(528, 35, 41, 'Hk', 0, '2025-03-14 10:10:38'),
(529, 35, 41, 'G', 0, '2025-03-14 10:10:52'),
(530, 36, 36, 'Hi', 0, '2025-03-15 13:31:37'),
(531, 36, 36, 'Bi', 0, '2025-03-16 02:24:28'),
(532, 36, 36, 'Hi', 0, '2025-03-16 05:15:51'),
(533, 40, 35, 'New update released watch it', 0, '2025-03-20 13:41:48'),
(534, 40, 36, 'Bhgg', 0, '2025-03-21 11:35:51'),
(535, 37, 37, 'Hi', 0, '2025-03-21 11:48:00'),
(536, 40, 37, 'Gg', 0, '2025-03-21 11:48:17'),
(537, 37, 35, 'Bhgg', 0, '2025-03-21 11:48:18'),
(538, 40, 37, 'Hi', 0, '2025-03-21 11:48:48'),
(539, 37, 35, 'Hi', 0, '2025-03-21 11:49:01'),
(540, 37, 35, 'Hi', 0, '2025-03-21 11:49:19'),
(541, 37, 35, 'Hi', 0, '2025-03-21 11:53:35'),
(542, 35, 37, 'https://positive.free.nf', 0, '2025-03-21 11:54:02'),
(543, 35, 37, '@copy', 0, '2025-03-21 12:03:09'),
(544, 35, 37, 'Bjkn', 0, '2025-03-21 12:03:16'),
(545, 35, 37, 'Nndk', 0, '2025-03-21 12:03:35'),
(546, 35, 37, 'Bjjd @copy', 0, '2025-03-21 12:03:46'),
(547, 42, 40, 'Hi', 0, '2025-03-21 12:21:27'),
(548, 36, 40, 'die with a smile', 0, '2025-03-22 11:23:56'),
(549, 37, 35, 'https://www.amazon.in/apay/landing/mobile-prepaid', 0, '2025-03-25 01:22:53'),
(550, 37, 40, 'Fuck you', 0, '2025-03-29 10:36:13'),
(551, 40, 40, 'Hello', 0, '2025-03-29 10:42:51'),
(552, 40, 41, 'Hi', 0, '2025-03-29 13:42:13'),
(553, 40, 35, 'Gandu', 0, '2025-03-29 13:43:32'),
(554, 40, 35, 'Fuck you', 0, '2025-03-29 13:43:47'),
(555, 36, 40, 'Solve this question â‰ï¸', 0, '2025-03-31 14:24:28'),
(556, 36, 40, 'Solve this question â‰ï¸', 0, '2025-03-31 14:24:45'),
(557, 37, 42, 'Hello', 0, '2025-04-01 08:40:51'),
(558, 40, 41, 'Fucker', 0, '2025-04-02 10:32:28'),
(559, 40, 42, 'Hello', 0, '2025-04-02 10:39:19'),
(560, 40, 37, 'L', 0, '2025-04-03 07:29:51'),
(561, 40, 37, 'Hi', 0, '2025-04-03 07:39:18'),
(562, 36, 41, 'Bu', 0, '2025-04-04 03:07:04'),
(563, 36, 36, 'V', 0, '2025-04-04 03:07:12'),
(564, 36, 35, 'Hg', 0, '2025-04-04 03:08:26');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `current_status` tinyint(1) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `typing_status`
--

CREATE TABLE `typing_status` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `is_typing` tinyint(1) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `typing_status`
--

INSERT INTO `typing_status` (`id`, `sender_id`, `receiver_id`, `is_typing`, `updated_at`) VALUES
(24, 109, 35, 0, '2025-01-27 02:43:26'),
(23, 180, 35, 0, '2025-01-26 14:17:24'),
(22, 35, 37, 0, '2025-03-21 12:03:44'),
(21, 37, 35, 0, '2025-03-25 01:22:52'),
(20, 35, 36, 0, '2025-01-29 02:53:43'),
(19, 36, 35, 0, '2025-04-04 03:08:26'),
(18, 35, 35, 0, '2025-03-14 09:57:48'),
(25, 39, 35, 0, '2025-02-11 02:55:38'),
(26, 35, 39, 0, '2025-02-27 01:45:08'),
(27, 35, 40, 0, '2025-03-14 09:14:27'),
(28, 40, 35, 0, '2025-03-29 13:43:48'),
(29, 40, 37, 0, '2025-04-03 07:39:19'),
(30, 37, 40, 0, '2025-03-29 10:36:13'),
(31, 40, 36, 0, '2025-04-03 07:37:51'),
(32, 36, 40, 0, '2025-04-04 03:08:19'),
(33, 37, 37, 0, '2025-03-21 11:47:32'),
(34, 41, 41, 0, '2025-03-14 10:00:56'),
(35, 41, 40, 0, '2025-03-11 13:57:30'),
(36, 40, 40, 0, '2025-03-29 10:42:48'),
(37, 41, 35, 0, '2025-03-14 10:03:26'),
(38, 35, 41, 0, '2025-03-14 10:10:50'),
(39, 36, 36, 0, '2025-04-04 03:07:24'),
(40, 42, 40, 0, '2025-03-21 12:21:28'),
(41, 40, 41, 0, '2025-04-02 10:32:28'),
(42, 37, 42, 0, '2025-04-01 08:40:52'),
(43, 40, 42, 0, '2025-04-02 10:39:20'),
(44, 36, 41, 0, '2025-04-04 03:07:04');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_icon` varchar(255) NOT NULL,
  `last_active` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_online` tinyint(1) DEFAULT 0,
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `profile_icon`, `last_active`, `is_online`, `last_seen`) VALUES
(40, 'LimLeki', '$2y$10$ERQEvgn1Mk.eEhxQelVksOy0oVitWqpL9xy8ElaQpGPzg6GWLyvay', 'uploads/Screenshot_2023-11-18-06-27-26-044_com.google.android.youtube.jpg', '2025-04-06 13:02:49', 0, '2025-04-06 13:02:49'),
(39, 'à¼ºðŸ…°ðŸ…³ðŸ…¼ðŸ…¸ðŸ…½à¼»', '$2y$10$ZmzBWTuCqoEJ1S9vHz5QD.8xAzqgJn1F5/OCD/wTKbOeskYEEYLfO', 'uploads/1000080171.webp', '2025-02-11 02:55:28', 0, '2025-03-11 10:06:07'),
(35, 'Rishaply ', '$2y$10$WdB31R9N7gE3HG4QnKJf/OJ7VJRMyDFQKbtwUzHQAaSofpVl6dJVe', 'uploads/1000075722.jpg', '2025-04-01 10:16:11', 0, '2025-04-01 10:16:11'),
(36, 'ChatWithUs', '$2y$10$YHPCvWW1Sbp9GlXnIAvdHOXOezVBY1yc3qbMjyOyUxCKm3v/9lV2q', 'uploads/1000078933.jpg', '2025-04-06 13:34:29', 1, '2025-04-06 13:34:29'),
(37, 'Copy', '$2y$10$SBMuuBymKeqaZCubIoZvgOb/H3egm.S.1CZkEyctZ8/5O8SKWCvRy', 'uploads/Screenshot_2025-01-18-21-10-46-657_com.facebook.lite.jpg', '2025-04-01 10:20:28', 0, '2025-04-01 10:20:28'),
(38, 'AIzaSyARmBOksc3C17PH7xoglsXMdASQEvw0yiI', '$2y$10$iylKX7nAYxQzLjv.COzR.efv/ejuf7H2KhPiUSOGzZsvDSUWvjDCq', 'uploads/Screenshot_2025-01-28-17-06-33-399_com.dts.freefiremax.jpg', '2025-03-16 11:36:58', 0, '2025-03-16 11:36:58'),
(41, 'Rishaply9959', '$2y$10$QGj30XYNgNVJjbkrVVyM.OlEVcfmlZD1DXdFk6pMhwnaJEBuuaQ7m', 'uploads/1000074194.jpg', '2025-03-30 05:51:51', 0, '2025-03-30 05:51:51'),
(42, 'Krrish', '$2y$10$vzvRMDKMkhXdHrzW2xoInuMiHuPUJoRI3DqL1sG0pAS2NrmEoatD.', 'uploads/Screenshot_2023-04-03-18-10-49-213_com.google.android.youtube.jpg', '2025-03-23 13:31:30', 0, '2025-03-23 13:31:30'),
(43, 'Bot_1234', '$2y$10$U70zNfBumeCH8Hcmlf5q0OQw3YPZXVDs8D6WEzM.nZoFdBQJ6swEm', 'uploads/Screenshot_20250401-201041.jpg', '2025-04-05 12:57:32', 0, '2025-04-05 12:57:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blocked_friends`
--
ALTER TABLE `blocked_friends`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `blocked_user_id` (`blocked_user_id`);

--
-- Indexes for table `blocked_users`
--
ALTER TABLE `blocked_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_block` (`group_id`,`user_id`);

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `friend_id` (`friend_id`);

--
-- Indexes for table `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `group_invites`
--
ALTER TABLE `group_invites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `inviter_id` (`inviter_id`),
  ADD KEY `invitee_id` (`invitee_id`);

--
-- Indexes for table `group_likes`
--
ALTER TABLE `group_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_like` (`user_id`,`group_id`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `group_id` (`group_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `group_messages`
--
ALTER TABLE `group_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `typing_status`
--
ALTER TABLE `typing_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blocked_friends`
--
ALTER TABLE `blocked_friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `blocked_users`
--
ALTER TABLE `blocked_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `friend_requests`
--
ALTER TABLE `friend_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `group_invites`
--
ALTER TABLE `group_invites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `group_likes`
--
ALTER TABLE `group_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT for table `group_members`
--
ALTER TABLE `group_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `group_messages`
--
ALTER TABLE `group_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=588;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=565;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `typing_status`
--
ALTER TABLE `typing_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
