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
// QUERY LIST JADWAL
// Urutan: paling baru → paling lama
// (tanggal DESC, jam_mulai DESC)
// ================================
$lapangan_id = $_GET['lapangan_id'] ?? null;
$status      = $_GET['status'] ?? null;

$where = [];

if ($lapangan_id) {
    $where[] = "j.lapangan_id = " . intval($lapangan_id);
}

if ($status) {
    $where[] = "j.status = '" . $connection->real_escape_string($status) . "'";
}

$whereSql = count($where) ? "WHERE " . implode(" AND ", $where) : "";

$query = "
SELECT 
    j.id,
    j.lapangan_id,
    j.tanggal,
    j.jam_mulai,
    j.jam_selesai,
    j.status,
    l.nama_lapangan
FROM jadwal j
JOIN lapangan l ON j.lapangan_id = l.id
$whereSql
ORDER BY j.tanggal DESC, j.jam_mulai DESC
";


$result = $connection->query($query);
$data = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

// ================================
// RESPONSE JSON
// ================================
echo json_encode([
    "status" => true,
    "message" => "List jadwal lapangan",
    "data" => $data
]);

$connection->close();
