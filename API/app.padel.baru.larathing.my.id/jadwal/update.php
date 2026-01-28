<?php
header("Content-Type: application/json");

// ================================
// KONEKSI DATABASE
// ================================
$connection = new mysqli(
    "localhost",
    "larh6135_saoki",
    "!Latihan.18",
    "larh6135_app_padel_baru"
);

if ($connection->connect_error) {
    echo json_encode([
        "status" => false,
        "message" => "Koneksi database gagal"
    ]);
    exit;
}

// ================================
// AMBIL DATA POST
// ================================
$id          = $_POST['id'] ?? '';
$lapangan_id = $_POST['lapangan_id'] ?? '';
$tanggal     = $_POST['tanggal'] ?? '';
$jam_mulai   = $_POST['jam_mulai'] ?? '';
$jam_selesai = $_POST['jam_selesai'] ?? '';

// ================================
// VALIDASI INPUT
// ================================
if (
    empty($id) ||
    empty($lapangan_id) ||
    empty($tanggal) ||
    empty($jam_mulai) ||
    empty($jam_selesai)
) {
    echo json_encode([
        "status" => false,
        "message" => "Data update jadwal belum lengkap"
    ]);
    exit;
}

// ================================
// UPDATE DATA JADWAL
// ================================
$stmt = $connection->prepare(
    "UPDATE jadwal 
     SET lapangan_id = ?, 
         tanggal = ?, 
         jam_mulai = ?, 
         jam_selesai = ?
     WHERE id = ?"
);

$stmt->bind_param(
    "isssi",
    $lapangan_id,
    $tanggal,
    $jam_mulai,
    $jam_selesai,
    $id
);

$stmt->execute();

// ================================
// CEK HASIL UPDATE
// ================================
if ($stmt->affected_rows > 0) {
    echo json_encode([
        "status" => true,
        "message" => "Jadwal berhasil diperbarui"
    ]);
} else {
    echo json_encode([
        "status" => true,
        "message" => "Tidak ada perubahan data"
    ]);
}

$stmt->close();
$connection->close();
