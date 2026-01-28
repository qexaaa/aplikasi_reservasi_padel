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

$query = "
SELECT 
    p.id,
    p.reservasi_id,
    p.jumlah,
    p.metode,
    p.status,
    p.created_at,
    r.tanggal,
    r.jam_mulai,
    r.jam_selesai,
    l.nama_lapangan
FROM pembayaran p
LEFT JOIN reservasi r ON p.reservasi_id = r.id
LEFT JOIN lapangan l ON r.lapangan_id = l.id
ORDER BY p.created_at DESC
";

$result = $connection->query($query);
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    "status" => true,
    "data" => $data
]);
