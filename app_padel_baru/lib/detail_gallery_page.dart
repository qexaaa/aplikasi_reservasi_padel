// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// HALAMAN DETAIL GALLERY LAPANGAN
// Menampilkan informasi lengkap lapangan yang dipilih dari gallery
class DetailGalleryPage extends StatelessWidget {

  // Data lapangan dikirim dari halaman gallery
  final Map lapangan;

  const DetailGalleryPage({
    super.key,
    required this.lapangan,
  });

  @override
  Widget build(BuildContext context) {

    // Ambil data lapangan dengan pengaman null
    final String nama =
        lapangan['nama_lapangan'] ?? 'Nama tidak tersedia';

    final String gambar =
        lapangan['gambar'] ??
            'https://via.placeholder.com/600x400?text=No+Image';

    final String harga =
        lapangan['harga']?.toString() ?? '-';

    final String status =
        lapangan['status'] ?? '-';

    final String deskripsi =
        lapangan['deskripsi'] ?? 'Tidak ada deskripsi';

    return Scaffold(

      // AppBar halaman detail
      appBar: AppBar(
        title: const Text('Detail Lapangan'),
      ),

      // BODY HALAMAN
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // GAMBAR LAPANGAN (HEADER)
            Stack(
              children: [
                Image.network(
                  gambar,
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 230,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 60),
                      ),
                    );
                  },
                ),

                // BADGE STATUS
                Positioned(
                  top: 16,
                  right: 16,
                  child: Chip(
                    label: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor:
                    status == 'aktif'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),

            // KONTEN DETAIL
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // NAMA LAPANGAN
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CARD INFO UTAMA
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [

                          // HARGA
                          Row(
                            children: [
                              const Icon(Icons.payments),
                              const SizedBox(width: 8),
                              Text(
                                "Harga : Rp $harga / jam",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // STATUS
                          Row(
                            children: [
                              const Icon(Icons.info_outline),
                              const SizedBox(width: 8),
                              Text(
                                "Status : $status",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: status == 'aktif'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // JUDUL DESKRIPSI
                  const Text(
                    "Deskripsi Lapangan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // DESKRIPSI
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      deskripsi,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
