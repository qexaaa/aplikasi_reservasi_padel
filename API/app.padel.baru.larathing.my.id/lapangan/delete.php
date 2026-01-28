<?php
header("Content-Type: application/json");

// ================================
// KONEKSI DATABASE
// ================================
$conn = new mysqli(
    "localhost",
    "larh6135_saoki",
    "!Latihan.18",
    "larh6135_app_padel_baru"
);

if ($conn->connect_error) {
    echo json_encode([
        "status" => false,
        "message" => "Koneksi database gagal"
    ]);
    exit;
}

// ================================
// AMBIL PARAMETER ID
// ================================
$id = $_POST['id'] ?? '';

if ($id === '') {
    echo json_encode([
        "status" => false,
        "message" => "ID lapangan wajib diisi"
    ]);
    exit;
}

// ================================
// DELETE DATA LAPANGAN
// ================================
$stmt = $conn->prepare(
    "DELETE FROM lapangan WHERE id = ?"
);
$stmt->bind_param("i", $id);
$stmt->execute();

// ================================
// CEK HASIL DELETE
// ================================
if ($stmt->affected_rows > 0) {
    echo json_encode([
        "status" => true,
        "message" => "Lapangan berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Lapangan tidak ditemukan atau tidak dapat dihapus"
    ]);
}

$stmt->close();
$conn->close();
