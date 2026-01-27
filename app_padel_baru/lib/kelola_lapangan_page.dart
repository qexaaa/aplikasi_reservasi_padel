// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// Halaman tambah & edit lapangan
import 'tambah_lapangan_page.dart';
import 'edit_lapangan_page.dart';

// HALAMAN KELOLA LAPANGAN (ADMIN)
class KelolaLapanganPage extends StatefulWidget {
  const KelolaLapanganPage({super.key});

  @override
  State<KelolaLapanganPage> createState() => _KelolaLapanganPageState();
}

class _KelolaLapanganPageState extends State<KelolaLapanganPage> {
  // DIO HTTP CLIENT
  final Dio dio = Dio();

  // DATA LAPANGAN
  List lapangan = [];

  // STATUS LOADING
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLapangan();
  }

  // ======================
  // AMBIL DATA LAPANGAN
  // ======================
  Future<void> fetchLapangan() async {
    try {
      final response = await dio.get(
        'https://app.padel.baru.larathing.my.id/lapangan/list.php',
      );

      setState(() {
        lapangan = response.data['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil data lapangan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ======================
  // HAPUS LAPANGAN (API)
  // ======================
  Future<void> deleteLapangan(String id) async {
    try {
      final response = await dio.post(
        'https://app.padel.baru.larathing.my.id/lapangan/delete.php',
        data: {'id': id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // 🔴 WAJIB CEK RESPONSE
      if (response.data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lapangan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );

        fetchLapangan();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data['message'] ?? 'Gagal menghapus lapangan',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat menghapus lapangan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ======================
  // KONFIRMASI HAPUS
  // ======================
  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus lapangan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deleteLapangan(id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // ======================
  // CARD LAPANGAN
  // ======================
  Widget lapanganCard(dynamic item) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item['gambar'] != null && item['gambar'] != '')
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item['gambar'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 100),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama_lapangan'] ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('ID: ${item['id']}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item['status'] == 'aktif'
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(
                          color: item['status'] == 'aktif'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon:
                      const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditLapanganPage(lapangan: item),
                          ),
                        );
                        if (result == true) fetchLapangan();
                      },
                    ),
                    IconButton(
                      icon:
                      const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          confirmDelete(item['id'].toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Lapangan')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : lapangan.isEmpty
          ? const Center(child: Text('Belum ada data lapangan'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: lapangan.length,
          itemBuilder: (_, i) =>
              lapanganCard(lapangan[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahLapanganPage(),
            ),
          );
          if (result == true) fetchLapangan();
        },
      ),
    );
  }
}
