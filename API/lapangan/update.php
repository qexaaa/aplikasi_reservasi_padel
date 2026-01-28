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

$id            = $_POST['id'] ?? '';
$nama_lapangan = $_POST['nama_lapangan'] ?? '';
$gambar        = $_POST['gambar'] ?? '';
$deskripsi     = $_POST['deskripsi'] ?? '';
$harga         = $_POST['harga'] ?? '';
$status        = $_POST['status'] ?? 'aktif';

if ($id === '' || $nama_lapangan === '' || $harga === '') {
    echo json_encode([
        "status"=>false,
        "message"=>"Data tidak lengkap",
        "debug"=>$_POST
    ]);
    exit;
}

$stmt = $conn->prepare(
    "UPDATE lapangan
     SET nama_lapangan=?, gambar=?, deskripsi=?, harga=?, status=?
     WHERE id=?"
);

$stmt->bind_param(
    "sssisi",
    $nama_lapangan,
    $gambar,
    $deskripsi,
    $harga,
    $status,
    $id
);

$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(["status"=>true,"message"=>"Lapangan berhasil diupdate"]);
} else {
    echo json_encode(["status"=>false,"message"=>"Tidak ada perubahan data"]);
}

$stmt->close();
$conn->close();
