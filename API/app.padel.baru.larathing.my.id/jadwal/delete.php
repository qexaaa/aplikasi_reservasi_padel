<?php
header("Content-Type: application/json");

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

// ID JADWAL
$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode([
        "status" => false,
        "message" => "ID jadwal wajib diisi"
    ]);
    exit;
}

// HAPUS JADWAL
// RESERVASI → PEMBAYARAN AKAN TERHAPUS OTOMATIS (CASCADE)
$stmt = $connection->prepare(
    "DELETE FROM jadwal WHERE id = ?"
);
$stmt->bind_param("i", $id);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode([
        "status" => true,
        "message" => "Jadwal dan seluruh data terkait berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Jadwal tidak ditemukan"
    ]);
}

$stmt->close();
$connection->close();
