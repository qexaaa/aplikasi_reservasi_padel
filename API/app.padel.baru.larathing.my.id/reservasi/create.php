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
$email       = $_POST['email'] ?? '';
$lapangan_id = $_POST['lapangan_id'] ?? '';
$jadwal_id   = $_POST['jadwal_id'] ?? '';
$tanggal     = $_POST['tanggal'] ?? '';
$jam_mulai   = $_POST['jam_mulai'] ?? '';
$jam_selesai = $_POST['jam_selesai'] ?? '';

// ================================
// VALIDASI
// ================================
if (
    empty($email) ||
    empty($lapangan_id) ||
    empty($jadwal_id) ||
    empty($tanggal) ||
    empty($jam_mulai) ||
    empty($jam_selesai)
) {
    echo json_encode([
        "status" => false,
        "message" => "Data reservasi belum lengkap"
    ]);
    exit;
}

// ================================
// CEK JADWAL
// ================================
$cek = $connection->prepare(
    "SELECT status, lapangan_id FROM jadwal WHERE id = ?"
);
$cek->bind_param("i", $jadwal_id);
$cek->execute();
$result = $cek->get_result()->fetch_assoc();

if (
    !$result ||
    $result['status'] != 'tersedia' ||
    $result['lapangan_id'] != $lapangan_id
) {
    echo json_encode([
        "status" => false,
        "message" => "Jadwal tidak valid untuk lapangan ini"
    ]);
    exit;
}


// ================================
// INSERT RESERVASI
// ================================
$insert = $connection->prepare(
    "INSERT INTO reservasi 
    (user_email, lapangan_id, jadwal_id, tanggal, jam_mulai, jam_selesai)
    VALUES (?, ?, ?, ?, ?, ?)"
);

$insert->bind_param(
    "siisss",
    $email,
    $lapangan_id,
    $jadwal_id,
    $tanggal,
    $jam_mulai,
    $jam_selesai
);

if (!$insert->execute()) {
    echo json_encode([
        "status" => false,
        "message" => "Gagal menyimpan reservasi"
    ]);
    exit;
}

// ================================
// AMBIL ID RESERVASI BARU
// ================================
$reservasi_id = $connection->insert_id;

// ================================
// AUTO CREATE PEMBAYARAN (PENDING)
// ================================
$createPembayaran = $connection->prepare(
    "INSERT INTO pembayaran
    (reservasi_id, metode, jumlah, status)
    VALUES (?, ?, ?, ?)"
);

$metode = 'transfer';
$jumlah = 100000; // contoh, bisa disesuaikan
$status = 'pending';

$createPembayaran->bind_param(
    "isis",
    $reservasi_id,
    $metode,
    $jumlah,
    $status
);

$createPembayaran->execute();

// ================================
// UPDATE STATUS JADWAL
// ================================
$update = $connection->prepare(
    "UPDATE jadwal SET status = 'dibooking' WHERE id = ?"
);
$update->bind_param("i", $jadwal_id);
$update->execute();

// ================================
// RESPONSE KE USER
// ================================
echo json_encode([
    "status" => true,
    "message" => "Reservasi berhasil, silakan lanjut ke pembayaran"
]);

$connection->close();
