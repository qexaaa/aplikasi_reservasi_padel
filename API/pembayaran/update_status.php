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

$id     = $_POST['id'] ?? '';
$status = $_POST['status'] ?? '';

if ($id === '' || $status === '') {
    echo json_encode([
        "status" => false,
        "message" => "Data tidak lengkap",
        "debug" => $_POST
    ]);
    exit;
}

$stmt = $connection->prepare(
    "UPDATE pembayaran SET status=? WHERE id=?"
);
$stmt->bind_param("si", $status, $id);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode([
        "status" => true,
        "message" => "Status pembayaran diperbarui"
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Tidak ada perubahan"
    ]);
}
