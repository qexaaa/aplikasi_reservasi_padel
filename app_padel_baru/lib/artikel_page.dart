// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// HALAMAN ARTIKEL
class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(
        title: const Text("Artikel"),
      ),

      // BODY HALAMAN
      body: SingleChildScrollView(
        // Padding agar konten tidak menempel ke tepi layar
        padding: const EdgeInsets.all(20),

        // Kolom untuk menyusun isi artikel secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            // JUDUL ARTIKEL
            Text(
              "Aplikasi Reservasi Lapangan Padel",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            // INFORMASI PENULIS
            Text(
              "Penulis: Saoki Ramada\nTahun: 2026",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 16),

            // ISI ARTIKEL
            Text(
              "Aplikasi Reservasi Lapangan Padel merupakan aplikasi berbasis mobile "
                  "yang dikembangkan menggunakan Flutter dan backend PHP-MySQL. "
                  "Aplikasi ini bertujuan untuk memudahkan pengguna dalam melakukan "
                  "reservasi lapangan olahraga padel secara online.\n\n"

                  "Pada aplikasi ini terdapat dua jenis pengguna, yaitu Admin dan User. "
                  "Admin memiliki hak akses untuk mengelola data lapangan, jadwal, dan "
                  "pembayaran. Sedangkan User dapat melihat jadwal lapangan, melakukan "
                  "reservasi, serta melihat riwayat reservasi dan status pembayaran.\n\n"

                  "Dengan adanya aplikasi ini, proses pemesanan lapangan menjadi lebih "
                  "efisien, terorganisir, dan transparan. Aplikasi ini juga menerapkan "
                  "konsep client-server, di mana aplikasi Flutter berperan sebagai client "
                  "dan PHP-MySQL sebagai server.",
              style: TextStyle(
                fontSize: 15,
                height: 1.5, // Jarak antar baris agar teks nyaman dibaca
              ),
            ),
          ],
        ),
      ),
    );
  }
}
