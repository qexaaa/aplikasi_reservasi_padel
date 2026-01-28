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
// AMBIL PARAMETER EMAIL
// ================================
$email = $_POST['email'] ?? $_GET['email'] ?? '';

if (empty($email)) {
    echo json_encode([
        "status" => false,
        "message" => "Email tidak boleh kosong"
    ]);
    exit;
}

// ================================
// QUERY RIWAYAT RESERVASI + PEMBAYARAN
// ================================
$query = "
SELECT
    r.id AS reservasi_id,
    r.tanggal,
    r.jam_mulai,
    r.jam_selesai,

    l.id AS lapangan_id,
    l.nama_lapangan,
    l.gambar,

    p.id AS pembayaran_id,
    p.metode,
    p.jumlah,
    p.status AS status_pembayaran

FROM reservasi r
JOIN lapangan l ON r.lapangan_id = l.id
LEFT JOIN pembayaran p ON p.reservasi_id = r.id

WHERE r.user_email = ?
ORDER BY r.tanggal DESC, r.jam_mulai DESC
";

$stmt = $connection->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();

$result = $stmt->get_result();
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = [
        "reservasi_id" => $row['reservasi_id'],
        "tanggal" => $row['tanggal'],
        "jam_mulai" => $row['jam_mulai'],
        "jam_selesai" => $row['jam_selesai'],

        "lapangan" => [
            "id" => $row['lapangan_id'],
            "nama" => $row['nama_lapangan'],
            "gambar" => $row['gambar']
        ],

        "pembayaran" => [
            "id" => $row['pembayaran_id'],
            "metode" => $row['metode'],
            "jumlah" => $row['jumlah'],
            "status" => $row['status_pembayaran'] ?? 'belum ada'
        ]
    ];
}

// ================================
// RESPONSE JSON
// ================================
echo json_encode([
    "status" => true,
    "message" => "Riwayat reservasi & pembayaran",
    "data" => $data
]);

$stmt->close();
$connection->close();
