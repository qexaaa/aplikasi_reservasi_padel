// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// HALAMAN TAMBAH LAPANGAN (ADMIN)
class TambahLapanganPage extends StatefulWidget {
  const TambahLapanganPage({super.key});

  @override
  State<TambahLapanganPage> createState() =>
      _TambahLapanganPageState();
}

class _TambahLapanganPageState
    extends State<TambahLapanganPage> {

  // DIO HTTP CLIENT
  final Dio dio = Dio();

  // CONTROLLER INPUT
  // Digunakan untuk mengambil nilai dari TextField
  final namaController = TextEditingController();
  final gambarController = TextEditingController();
  final deskripsiController = TextEditingController();
  final hargaController = TextEditingController();

  // STATUS & STATE UI
  String status = 'aktif'; // Status default lapangan
  bool isLoading = false;  // Penanda proses simpan data

  // SIMPAN DATA LAPANGAN (API)
  Future<void> simpanLapangan() async {

    // VALIDASI INPUT
    if (namaController.text.isEmpty ||
        hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('Nama dan harga wajib diisi'),
        ),
      );
      return;
    }

    // Aktifkan loading
    setState(() => isLoading = true);

    try {
      // Request POST ke API tambah lapangan
      final response = await dio.post(
        "https://app.padel.baru.larathing.my.id/lapangan/create.php",
        data: {
          "nama_lapangan": namaController.text,
          "gambar": gambarController.text,
          "deskripsi": deskripsiController.text,
          "harga": hargaController.text,
          "status": status,
        },
        options: Options(
          // Kirim data sebagai form-urlencoded
          contentType:
          Headers.formUrlEncodedContentType,
        ),
      );

      // RESPONSE BERHASIL
      if (response.data['status'] == true ||
          response.data['success'] == true) {

        // Snackbar sukses
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
            Text('Lapangan berhasil ditambahkan'),
          ),
        );

        // Kembali ke halaman sebelumnya
        // dengan nilai true sebagai penanda sukses
        Navigator.pop(context, true);
      } else {
        // RESPONSE GAGAL DARI API
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              response.data['message'] ??
                  'Gagal',
            ),
          ),
        );
      }
    } catch (e) {

      // ERROR NETWORK / SERVER
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }

    // Matikan loading
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman tambah lapangan
      appBar: AppBar(
        title: const Text('Tambah Lapangan'),
      ),

      // BODY HALAMAN
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // INPUT NAMA LAPANGAN
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lapangan',
              ),
            ),

            // INPUT URL GAMBAR
            TextField(
              controller: gambarController,
              decoration: const InputDecoration(
                labelText:
                'URL Gambar (Image.network)',
              ),
            ),

            // INPUT DESKRIPSI
            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
              ),
            ),

            // INPUT HARGA
            TextField(
              controller: hargaController,
              keyboardType:
              TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
              ),
            ),

            const SizedBox(height: 12),

            // DROPDOWN STATUS
            DropdownButtonFormField(
              value: status,
              items: const [
                DropdownMenuItem(
                  value: 'aktif',
                  child: Text('Aktif'),
                ),
                DropdownMenuItem(
                  value: 'nonaktif',
                  child: Text('Nonaktif'),
                ),
              ],
              onChanged: (v) => status = v!,
              decoration: const InputDecoration(
                labelText: 'Status',
              ),
            ),

            const SizedBox(height: 24),

            // TOMBOL SIMPAN
            ElevatedButton(
              onPressed:
              isLoading ? null : simpanLapangan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
