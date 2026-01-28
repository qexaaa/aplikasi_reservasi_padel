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
$nama     = $_POST['nama'] ?? '';
$email    = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$role     = $_POST['role'] ?? 'user';

// ================================
// VALIDASI DATA
// ================================
if ($nama == '' || $email == '' || $password == '') {
    echo json_encode([
        "status" => false,
        "message" => "Data registrasi belum lengkap"
    ]);
    exit;
}

// ================================
// CEK EMAIL SUDAH TERDAFTAR
// ================================
$check = $connection->prepare(
    "SELECT id FROM users WHERE email = ?"
);
$check->bind_param("s", $email);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    echo json_encode([
        "status" => false,
        "message" => "Email sudah terdaftar"
    ]);
    exit;
}

// ================================
// HASH PASSWORD (MD5)
// ================================
$password_md5 = md5($password);

// ================================
// INSERT USER BARU
// ================================
$query = $connection->prepare("
    INSERT INTO users (nama, email, password, role, status)
    VALUES (?, ?, ?, ?, 'aktif')
");

$query->bind_param(
    "ssss",
    $nama,
    $email,
    $password_md5,
    $role
);

if ($query->execute()) {
    echo json_encode([
        "status" => true,
        "message" => "Registrasi berhasil"
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Registrasi gagal"
    ]);
}
