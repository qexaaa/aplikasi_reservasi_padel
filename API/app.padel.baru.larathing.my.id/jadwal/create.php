<?php
header("Content-Type: application/json");

$conn = new mysqli(
  "localhost",
  "larh6135_saoki",
  "!Latihan.18",
  "larh6135_app_padel_baru"
);

if ($conn->connect_error) {
  echo json_encode(["status"=>false,"message"=>"Koneksi gagal"]);
  exit;
}

$lapangan_id = $_POST['lapangan_id'] ?? '';
$tanggal     = $_POST['tanggal'] ?? '';
$jam_mulai   = $_POST['jam_mulai'] ?? '';
$jam_selesai = $_POST['jam_selesai'] ?? '';

if ($lapangan_id=='' || $tanggal=='' || $jam_mulai=='' || $jam_selesai=='') {
  echo json_encode(["status"=>false,"message"=>"Data tidak lengkap"]);
  exit;
}

//
// ==========================
// 1. CEK STATUS LAPANGAN
// ==========================
$cekLap = $conn->prepare(
  "SELECT status FROM lapangan WHERE id=?"
);
$cekLap->bind_param("i",$lapangan_id);
$cekLap->execute();
$lap = $cekLap->get_result()->fetch_assoc();

if (!$lap || $lap['status'] != 'aktif') {
  echo json_encode([
    "status"=>false,
    "message"=>"Lapangan sedang nonaktif"
  ]);
  exit;
}

//
// ==========================
// 2. CEK JADWAL BENTROK
// ==========================
$cekBentrok = $conn->prepare("
  SELECT COUNT(*) AS total
  FROM jadwal
  WHERE lapangan_id = ?
  AND tanggal = ?
  AND (
    jam_mulai < ?
    AND jam_selesai > ?
  )
");

$cekBentrok->bind_param(
  "isss",
  $lapangan_id,
  $tanggal,
  $jam_selesai,
  $jam_mulai
);

$cekBentrok->execute();
$bentrok = $cekBentrok->get_result()->fetch_assoc();

if ($bentrok['total'] > 0) {
  echo json_encode([
    "status"=>false,
    "message"=>"Jadwal bentrok dengan jadwal lain"
  ]);
  exit;
}

//
// ==========================
// 3. INSERT JADWAL
// ==========================
$stmt = $conn->prepare(
  "INSERT INTO jadwal (lapangan_id, tanggal, jam_mulai, jam_selesai)
   VALUES (?,?,?,?)"
);

$stmt->bind_param(
  "isss",
  $lapangan_id,
  $tanggal,
  $jam_mulai,
  $jam_selesai
);

$stmt->execute();

echo json_encode([
  "status"=>true,
  "message"=>"Jadwal berhasil ditambahkan"
]);
