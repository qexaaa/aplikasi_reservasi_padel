<?php
header("Content-Type: application/json");

$connection = new mysqli(
    "localhost",
    "larh6135_saoki",
    "!Latihan.18",
    "larh6135_app_padel_baru"
);

if ($connection->connect_error) {
    echo json_encode(["status"=>false,"message"=>"Koneksi gagal"]);
    exit;
}

$reservasi_id = $_POST['reservasi_id'] ?? '';
$jumlah       = $_POST['jumlah'] ?? '';
$metode       = $_POST['metode'] ?? '';

if ($reservasi_id === '' || $jumlah === '') {
    echo json_encode([
        "status" => false,
        "message" => "Data tidak lengkap",
        "debug" => $_POST
    ]);
    exit;
}

$stmt = $connection->prepare(
    "INSERT INTO pembayaran (reservasi_id, jumlah, metode, status)
     VALUES (?, ?, ?, 'belum lunas')"
);

$stmt->bind_param("iis", $reservasi_id, $jumlah, $metode);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode([
        "status" => true,
        "message" => "Pembayaran berhasil dibuat"
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Gagal menyimpan pembayaran"
    ]);
}
