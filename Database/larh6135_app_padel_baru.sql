-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 28, 2026 at 07:50 AM
-- Server version: 11.4.9-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `larh6135_app_padel_baru`
--

-- --------------------------------------------------------

--
-- Table structure for table `jadwal`
--

CREATE TABLE `jadwal` (
  `id` int(11) NOT NULL,
  `lapangan_id` int(11) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam_mulai` time DEFAULT NULL,
  `jam_selesai` time DEFAULT NULL,
  `status` enum('tersedia','dibooking') DEFAULT 'tersedia',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `jadwal`
--

INSERT INTO `jadwal` (`id`, `lapangan_id`, `tanggal`, `jam_mulai`, `jam_selesai`, `status`, `created_at`) VALUES
(1, 3, '2026-01-22', '09:00:00', '11:15:00', 'dibooking', '2026-01-21 07:47:29'),
(2, 7, '2026-01-23', '13:30:00', '15:30:00', 'dibooking', '2026-01-21 07:48:59'),
(4, 2, '2026-01-21', '08:15:00', '10:15:00', 'dibooking', '2026-01-21 08:07:07'),
(7, 1, '2026-01-24', '13:00:00', '15:00:00', 'dibooking', '2026-01-21 14:04:16'),
(9, 11, '2026-01-24', '10:00:00', '12:00:00', 'dibooking', '2026-01-21 14:21:33'),
(10, 10, '2026-01-24', '12:00:00', '15:00:00', 'dibooking', '2026-01-21 14:29:25'),
(11, 11, '2026-01-25', '08:00:00', '10:00:00', 'dibooking', '2026-01-21 16:11:03'),
(12, 12, '2026-01-22', '08:00:00', '10:00:00', 'dibooking', '2026-01-22 02:33:33'),
(13, 12, '2026-01-22', '10:05:00', '12:00:00', 'tersedia', '2026-01-22 02:34:21'),
(14, 12, '2026-01-22', '12:05:00', '14:00:00', 'dibooking', '2026-01-22 02:34:50'),
(15, 12, '2026-01-22', '16:00:00', '18:00:00', 'dibooking', '2026-01-22 02:35:23'),
(17, 12, '2026-01-22', '18:00:00', '20:00:00', 'dibooking', '2026-01-22 02:36:01'),
(18, 1, '2026-01-24', '08:00:00', '10:00:00', 'dibooking', '2026-01-22 02:58:12'),
(20, 2, '2026-01-25', '08:00:00', '10:00:00', 'dibooking', '2026-01-22 08:31:39'),
(21, 2, '2026-01-25', '10:05:00', '12:00:00', 'tersedia', '2026-01-22 08:33:49'),
(22, 2, '2026-01-25', '12:05:00', '14:00:00', 'dibooking', '2026-01-22 08:34:15'),
(24, 1, '2026-01-25', '08:16:00', '10:30:00', 'dibooking', '2026-01-22 13:16:49'),
(25, 1, '2026-01-25', '10:10:00', '12:00:00', 'dibooking', '2026-01-22 13:17:34'),
(26, 1, '2026-01-25', '10:10:00', '12:15:00', 'dibooking', '2026-01-22 13:18:35'),
(27, 17, '2026-01-25', '08:00:00', '10:00:00', 'dibooking', '2026-01-22 13:19:40'),
(28, 17, '2026-01-25', '10:05:00', '12:00:00', 'dibooking', '2026-01-22 13:19:58'),
(29, 17, '2026-01-25', '12:10:00', '14:10:00', 'dibooking', '2026-01-22 13:20:15'),
(31, 17, '2026-01-30', '08:00:00', '10:00:00', 'tersedia', '2026-01-27 08:23:37'),
(32, 17, '2026-01-30', '10:15:00', '12:00:00', 'tersedia', '2026-01-27 08:24:41'),
(33, 17, '2026-01-30', '12:15:00', '14:00:00', 'tersedia', '2026-01-27 08:25:05'),
(34, 17, '2026-01-30', '16:15:00', '18:25:00', 'tersedia', '2026-01-27 08:25:57'),
(35, 17, '2026-02-05', '08:00:00', '10:00:00', 'tersedia', '2026-01-27 08:27:17'),
(36, 17, '2026-02-05', '10:15:00', '12:15:00', 'tersedia', '2026-01-27 08:27:44'),
(37, 17, '2026-02-05', '13:00:00', '15:15:00', 'tersedia', '2026-01-27 08:28:10');

-- --------------------------------------------------------

--
-- Table structure for table `lapangan`
--

CREATE TABLE `lapangan` (
  `id` int(11) NOT NULL,
  `nama_lapangan` varchar(50) NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` int(11) DEFAULT NULL,
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `lapangan`
--

INSERT INTO `lapangan` (`id`, `nama_lapangan`, `gambar`, `deskripsi`, `harga`, `status`, `created_at`) VALUES
(1, 'Lapangan 1', 'https://g-sports.id/wp-content/uploads/2025/03/pade.jpg', 'Ukuran standar lapangan padel adalah 20 meter x 10 meter dengan dinding setinggi 3â€“4 meter dan net setinggi sekitar 0,88â€“0,92 meter.', 375000, 'aktif', '2026-01-09 03:14:19'),
(2, 'Lapangan 2', 'https://adcountryclub.com/media/jawduxrc/adcc-padel-gallery-11.jpg?anchor=center&mode=crop&width=1200&height=800', 'lapangan padel adalah 20 meter x 10 meter dengan dinding setinggi 3â€“4 meter dan net setinggi sekitar 0,88â€“0,92 meter. ', 445000, 'aktif', '2026-01-09 03:14:19'),
(3, 'Lapangan 3', 'https://d3lfgix2a8jnun.cloudfront.net/custom-assets/13/padel-di-jakbar_68be8e4a72374-0XgcoRfhEOVfylatg7OpmrB1G1CJArtYbqE4cECb.jpg', ' lapangan padel adalah 20 meter x 10 meter dengan dinding setinggi 3â€“4 meter dan net setinggi sekitar 0,88â€“0,92 meter.', 500000, 'aktif', '2026-01-09 03:14:19'),
(6, 'Lapangan 6', 'https://asset.ayo.co.id/image/venue/173373785049811.image_cropper_52CFBCC1-2891-4C79-BBE0-D912CDF3AD9B-3544-0000015E7559BAA5_large.jpg', 'lapangan padel adalah 20 meter x 10 meter dengan dinding setinggi 3â€“4 meter dan net setinggi sekitar 0,88â€“0,92 meter.', 325000, 'nonaktif', '2026-01-09 03:50:56'),
(7, 'lapangan 7', 'https://nocindonesia.or.id/wp-content/uploads/2025/08/Biaya-Bangun-Lapangan-Padel-Lengkap-dengan-Rumput-Sintetis.png', 'lapangan ini sedang maintanence', 300000, 'nonaktif', '2026-01-19 03:07:26'),
(10, 'Lapangan Update1', 'https://images.harpersbazaar.co.id/unsafe/0x0/smart/media/body_1959d9eddba742b4883502d6e243e78f.jpeg', 'Maintenance', 185000, 'aktif', '2026-01-21 12:55:01'),
(11, 'Lapangan Baru', 'https://asset.ayo.co.id/image/venue/174677552879630.image_cropper_BA508D08-6E08-4784-A881-214278E2E1BF-30658-000011160A127A34.jpg_large.jpeg', 'test di emulator', 255000, 'aktif', '2026-01-21 13:25:52'),
(12, 'Lapangan 12', 'https://lifetimedesign.co/wp-content/uploads/2025/07/Menampilkan-salah-satu-project-terbaru-kami-Padel-Court-ruang-olahraga-outdoor-yang-dirancang--1024x716.jpg', 'lapangan baru lagi (lagi)', 325000, 'aktif', '2026-01-21 15:10:07'),
(17, 'Lapangan 16', 'https://d3lfgix2a8jnun.cloudfront.net/custom-assets/13/lapangan-padel-bsd_68ad3f1e3eb86-jFt9Of6dfZDefyQ8DkHpF0qV2MyKQr5os5QN8Hln.jpg', 'lapangan padel adalah 20 meter x 10 meter dengan dinding setinggi 3â€“4 meter dan net setinggi sekitar 0,88â€“0,92 meter. ', 475000, 'aktif', '2026-01-22 13:16:01');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id` int(11) NOT NULL,
  `reservasi_id` int(11) DEFAULT NULL,
  `metode` varchar(50) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `status` enum('pending','lunas') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id`, `reservasi_id`, `metode`, `jumlah`, `status`, `created_at`) VALUES
(2, 11, 'transfer', 100000, 'lunas', '2026-01-21 16:06:05'),
(3, 12, 'transfer', 100000, 'lunas', '2026-01-21 16:11:39'),
(4, 13, 'transfer', 100000, 'lunas', '2026-01-22 02:46:00'),
(5, 14, 'transfer', 100000, 'lunas', '2026-01-22 03:05:05'),
(6, 15, 'transfer', 100000, 'lunas', '2026-01-22 08:28:31'),
(9, 18, 'transfer', 100000, 'lunas', '2026-01-22 13:23:03'),
(10, 19, 'transfer', 100000, 'lunas', '2026-01-22 13:23:08'),
(11, 20, 'transfer', 100000, 'lunas', '2026-01-22 13:24:26'),
(12, 21, 'transfer', 100000, 'lunas', '2026-01-22 13:37:15'),
(14, 23, 'transfer', 100000, 'lunas', '2026-01-23 02:37:35'),
(15, 24, 'transfer', 100000, 'lunas', '2026-01-27 08:30:29'),
(16, 25, 'transfer', 100000, 'lunas', '2026-01-27 08:39:49'),
(17, 26, 'transfer', 100000, 'lunas', '2026-01-27 08:58:39'),
(18, 27, 'transfer', 100000, 'pending', '2026-01-27 15:33:03'),
(19, 28, 'transfer', 100000, 'pending', '2026-01-27 17:01:43');

-- --------------------------------------------------------

--
-- Table structure for table `reservasi`
--

CREATE TABLE `reservasi` (
  `id` int(11) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `lapangan_id` int(11) NOT NULL,
  `jadwal_id` int(11) DEFAULT NULL,
  `tanggal` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `status` enum('booking','selesai','batal') DEFAULT 'booking',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `reservasi`
--

INSERT INTO `reservasi` (`id`, `user_email`, `lapangan_id`, `jadwal_id`, `tanggal`, `jam_mulai`, `jam_selesai`, `status`, `created_at`) VALUES
(7, 'user@gmail.com', 1, 1, '2026-01-22', '08:00:00', '10:00:00', 'booking', '2026-01-21 15:36:33'),
(8, 'user@gmail.com', 11, 9, '2026-01-24', '10:00:00', '12:00:00', 'booking', '2026-01-21 15:37:43'),
(9, 'user@gmail.com', 6, 4, '2026-01-21', '08:15:00', '10:15:00', 'booking', '2026-01-21 15:42:44'),
(10, 'user@gmail.com', 3, 7, '2026-01-24', '12:00:00', '14:00:00', 'booking', '2026-01-21 15:58:34'),
(11, 'user@gmail.com', 11, 2, '2026-01-23', '13:30:00', '15:30:00', 'booking', '2026-01-21 16:06:05'),
(12, 'user@gmail.com', 11, 11, '2026-01-25', '08:00:00', '10:00:00', 'booking', '2026-01-21 16:11:39'),
(13, 'kucing@test.com', 12, 12, '2026-01-22', '08:00:00', '10:00:00', 'booking', '2026-01-22 02:46:00'),
(14, 'kucing@test.com', 1, 18, '2026-01-24', '08:00:00', '10:00:00', 'booking', '2026-01-22 03:05:05'),
(15, 'kucing@test.com', 1, 10, '2026-01-24', '12:00:00', '15:00:00', 'booking', '2026-01-22 08:28:31'),
(18, 'cici@test.com', 1, 26, '2026-01-25', '10:10:00', '12:15:00', 'booking', '2026-01-22 13:23:03'),
(19, 'cici@test.com', 1, 25, '2026-01-25', '10:10:00', '12:00:00', 'booking', '2026-01-22 13:23:08'),
(20, 'kucing@test.com', 17, 27, '2026-01-25', '08:00:00', '10:00:00', 'booking', '2026-01-22 13:24:26'),
(21, 'kucing@test.com', 1, 24, '2026-01-25', '08:16:00', '10:30:00', 'booking', '2026-01-22 13:37:15'),
(23, 'kucing@test.com', 12, 17, '2026-01-22', '18:00:00', '20:00:00', 'booking', '2026-01-23 02:37:35'),
(24, 'user@gmail.com', 17, 28, '2026-01-25', '10:05:00', '12:00:00', 'booking', '2026-01-27 08:30:29'),
(25, 'user@gmail.com', 17, 29, '2026-01-25', '12:10:00', '14:10:00', 'booking', '2026-01-27 08:39:49'),
(26, 'user@gmail.com', 12, 15, '2026-01-22', '16:00:00', '18:00:00', 'booking', '2026-01-27 08:58:39'),
(27, 'joko@gmail.com', 2, 20, '2026-01-25', '08:00:00', '10:00:00', 'booking', '2026-01-27 15:33:03'),
(28, 'joko@gmail.com', 12, 14, '2026-01-22', '12:05:00', '14:00:00', 'booking', '2026-01-27 17:01:43');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` char(32) NOT NULL,
  `role` enum('admin','staff','user') DEFAULT 'user',
  `status` enum('aktif','nonaktif') DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`, `status`, `created_at`) VALUES
(1, 'Admin Padel', 'admin@padel.com', '0192023a7bbd73250516f069df18b500', 'admin', 'aktif', '2026-01-09 02:08:52'),
(2, 'User Test', 'user@gmail.com', '6ad14ba9986e3615423dfca256d04e3f', 'user', 'aktif', '2026-01-09 02:11:15'),
(3, 'budi', 'budi@gmail.com', '9c5fa085ce256c7c598f6710584ab25d', 'user', 'aktif', '2026-01-10 04:48:03'),
(4, 'adi', 'adi@gmail.com', '7360409d967a24b667afc33a8384ec9e', 'user', 'aktif', '2026-01-10 04:51:37'),
(6, 'kucing', 'kucing@test.com', 'e10adc3949ba59abbe56e057f20f883e', 'user', 'aktif', '2026-01-22 02:45:29'),
(7, 'cici', 'cici@test.com', '3d0d80b5b6bc8478b62da19172ea1777', 'user', 'aktif', '2026-01-22 13:22:19'),
(8, 'Afri Yudha', 'test@gmail.com', 'e10adc3949ba59abbe56e057f20f883e', 'user', 'aktif', '2026-01-22 13:30:42'),
(9, 'joko', 'joko@gmail.com', '278ea841c0d133059032b8a75320c3e0', 'user', 'aktif', '2026-01-27 08:42:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_jadwal_lapangan` (`lapangan_id`);

--
-- Indexes for table `lapangan`
--
ALTER TABLE `lapangan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pembayaran_reservasi` (`reservasi_id`);

--
-- Indexes for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lapangan_id` (`lapangan_id`),
  ADD KEY `fk_reservasi_jadwal` (`jadwal_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jadwal`
--
ALTER TABLE `jadwal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `lapangan`
--
ALTER TABLE `lapangan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `reservasi`
--
ALTER TABLE `reservasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD CONSTRAINT `fk_jadwal_lapangan` FOREIGN KEY (`lapangan_id`) REFERENCES `lapangan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `fk_pembayaran_reservasi` FOREIGN KEY (`reservasi_id`) REFERENCES `reservasi` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD CONSTRAINT `fk_reservasi_jadwal` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reservasi_lapangan` FOREIGN KEY (`lapangan_id`) REFERENCES `lapangan` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
