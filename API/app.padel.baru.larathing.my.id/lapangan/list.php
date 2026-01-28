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

$result = $conn->query(
    "SELECT id, nama_lapangan, gambar, deskripsi, harga, status
     FROM lapangan
     ORDER BY nama_lapangan ASC"
);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    "status" => true,
    "data" => $data
]);

$conn->close();
