<?php
header("Content-Type: application/json");

$connection = new mysqli(
    "localhost",
    "larh6135_saoki",
    "!Latihan.18",
    "larh6135_app_padel_baru"
);

// Ambil data POST
$email = trim($_POST['email'] ?? '');
$password = trim($_POST['password'] ?? '');

// Validasi input
if ($email === '' || $password === '') {
    echo json_encode([
        "status" => false,
        "message" => "Email dan password wajib diisi"
    ]);
    exit;
}

// Hash password input (MD5)
$password_md5 = md5($password);

// Cari user berdasarkan email
$query = "SELECT * FROM users WHERE email = ? AND status = 'aktif'";
$stmt = $connection->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        "status" => false,
        "message" => "Email tidak ditemukan"
    ]);
    exit;
}

$user = $result->fetch_assoc();

// Bandingkan password MD5
if ($password_md5 === $user['password']) {
    echo json_encode([
        "status" => true,
        "message" => "Login berhasil",
        "data" => [
            "id" => $user['id'],
            "nama" => $user['nama'],
            "email" => $user['email'],
            "status" => $user['status'],
            "role" => $user['role']
        ]
    ]);
} else {
    echo json_encode([
        "status" => false,
        "message" => "Password salah"
    ]);
}
