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

$nama_lapangan = $_POST['nama_lapangan'] ?? '';
$gambar        = $_POST['gambar'] ?? '';
$deskripsi     = $_POST['deskripsi'] ?? '';
$harga         = $_POST['harga'] ?? '';
$status        = $_POST['status'] ?? 'aktif';

if ($nama_lapangan === '' || $harga === '') {
    echo json_encode([
        "status" => false,
        "message" => "Data tidak lengkap",
        "debug" => $_POST
    ]);
    exit;
}

$stmt = $conn->prepare(
    "INSERT INTO lapangan (nama_lapangan, gambar, deskripsi, harga, status)
     VALUES (?, ?, ?, ?, ?)"
);

$stmt->bind_param(
    "sssis",
    $nama_lapangan,
    $gambar,
    $deskripsi,
    $harga,
    $status
);

$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(["status"=>true,"message"=>"Lapangan berhasil ditambahkan"]);
} else {
    echo json_encode(["status"=>false,"message"=>"Gagal menambahkan lapangan"]);
}

$stmt->close();
$conn->close();
