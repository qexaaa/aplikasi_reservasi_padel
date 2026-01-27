// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk mengambil data gallery dari API
import 'package:dio/dio.dart';

// HALAMAN DETAIL gallery
import 'detail_gallery_page.dart';

// HALAMAN GALLERY LAPANGAN
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  // STATE DATA & LOADING
  // Menyimpan list data lapangan dari API
  List lapangan = [];

  // Penanda proses loading data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Ambil data lapangan saat halaman pertama kali dibuka
    fetchLapangan();
  }

  // AMBIL DATA LAPANGAN DARI API
  Future<void> fetchLapangan() async {
    try {
      // Request GET ke API lapangan
      final response = await Dio().get(
        'https://app.padel.baru.larathing.my.id/lapangan/list.php',
      );

      // Jika response sukses
      if (response.data['status'] == true) {
        setState(() {
          // Simpan data lapangan
          lapangan = response.data['data'];

          // Matikan loading
          isLoading = false;
        });
      } else {
        // Jika status false, tetap matikan loading
        setState(() => isLoading = false);
      }
    } catch (e) {
      // Jika error network / server
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(
        title: const Text('Gallery Lapangan'),
      ),

      // BODY HALAMAN
      body: isLoading
      // KONDISI LOADING
          ? const Center(
        child: CircularProgressIndicator(),
      )

      // KONDISI DATA SIAP
          : GridView.builder(
        padding: const EdgeInsets.all(16),

        // Pengaturan layout grid
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,        // 2 kolom
          crossAxisSpacing: 12,     // jarak horizontal
          mainAxisSpacing: 12,      // jarak vertical
          childAspectRatio: 0.8,    // rasio item
        ),

        // Jumlah item sesuai data lapangan
        itemCount: lapangan.length,

        itemBuilder: (context, index) {
          // Ambil data lapangan per index
          final item = lapangan[index];

          // DATA LAPANGAN
          final gambar = item['gambar'] ??
              'https://via.placeholder.com/300x200?text=No+Image';

          final nama = item['nama_lapangan'] ?? '-';

          final status = item['status'] ?? 'nonaktif';

          // PEMBUNGKUS KLIK (AMAN, TIDAK UBAH CARD)
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DetailGalleryPage(lapangan: item),
                ),
              );
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // GAMBAR LAPANGAN
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            gambar,
                            width: double.infinity,
                            fit: BoxFit.cover,

                            // Loading indicator saat gambar di-load
                            loadingBuilder:
                                (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },

                            // Jika gambar error
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image),
                              );
                            },

                            // Jika lapangan nonaktif → grayscale
                            color: status == 'nonaktif'
                                ? Colors.grey
                                : null,
                            colorBlendMode:
                            status == 'nonaktif'
                                ? BlendMode.saturation
                                : null,
                          ),
                        ),

                        // BADGE STATUS LAPANGAN
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'aktif'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // NAMA LAPANGAN
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
