// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// Digunakan untuk jsonDecode jika response API berupa String
import 'dart:convert';

// SharedPreferences digunakan untuk mengambil email user (session)
import 'package:shared_preferences/shared_preferences.dart';

// HALAMAN RIWAYAT RESERVASI
class RiwayatReservasiPage extends StatefulWidget {
  const RiwayatReservasiPage({super.key});

  @override
  State<RiwayatReservasiPage> createState() =>
      _RiwayatReservasiPageState();
}

class _RiwayatReservasiPageState
    extends State<RiwayatReservasiPage> {

  // DIO HTTP CLIENT
  final Dio _dio = Dio();

  // DATA RIWAYAT RESERVASI
  // Menyimpan list riwayat reservasi user
  List _data = [];

  // Penanda proses loading data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Ambil data riwayat reservasi saat halaman dibuka
    _getData();
  }

  // AMBIL DATA RIWAYAT RESERVASI (API)
  Future<void> _getData() async {
    try {
      // Ambil email user dari session
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      // Jika email tidak ada, hentikan proses
      if (email == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Request POST ke API riwayat reservasi
      final response = await _dio.post(
        "https://app.padel.baru.larathing.my.id/reservasi/riwayat.php",
        data: {
          "email": email,
        },
        options: Options(
          // Kirim data sebagai form-urlencoded agar cocok dengan PHP
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Jika request sukses
      if (response.statusCode == 200) {
        var result = response.data;

        // Decode JSON jika response masih berupa String
        if (result is String) result = jsonDecode(result);

        // Validasi struktur response
        if (result is Map &&
            result['status'] == true &&
            result.containsKey('data')) {

          // Simpan data riwayat reservasi
          setState(() {
            _data = result['data'];
            _isLoading = false;
          });
        } else {
          // Jika tidak ada data
          setState(() {
            _data = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Jika terjadi error network / parsing
      debugPrint("Error ambil riwayat: $e");
      setState(() => _isLoading = false);
    }
  }

  // WARNA STATUS PEMBAYARAN
  Color _statusColor(String status) {
    switch (status) {
      case 'lunas':
        return Colors.green;   // Pembayaran selesai
      case 'pending':
        return Colors.orange;  // Menunggu verifikasi
      default:
        return Colors.grey;    // Belum ada pembayaran
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman riwayat reservasi
      appBar: AppBar(
        title: const Text("Riwayat Reservasi"),
      ),


      // BODY HALAMAN

      body: _isLoading

      // KONDISI LOADING
          ? const Center(
        child: CircularProgressIndicator(),
      )

      // KONDISI DATA KOSONG
          : _data.isEmpty
          ? const Center(
        child: Text(
          "Belum ada riwayat reservasi",
          style: TextStyle(fontSize: 16),
        ),
      )

      // KONDISI DATA ADA
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];

          // Data lapangan dari response API
          final lapangan = item['lapangan'];

          // Data pembayaran dari response API
          final pembayaran = item['pembayaran'];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                // GAMBAR LAPANGAN
                if (lapangan['gambar'] != null &&
                    lapangan['gambar'] != '')
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      lapangan['gambar'],
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                      const Icon(
                        Icons.broken_image,
                        size: 80,
                      ),
                    ),
                  ),

                // INFORMASI RESERVASI
                Padding(
                  padding:
                  const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      // Nama lapangan
                      Text(
                        lapangan['nama'] ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Tanggal & jam reservasi
                      Text(
                        "Tanggal : ${item['tanggal']}\n"
                            "Jam     : ${item['jam_mulai']} - ${item['jam_selesai']}",
                      ),

                      const SizedBox(height: 8),

                      // STATUS PEMBAYARAN
                      Row(
                        children: [
                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              _statusColor(
                                pembayaran[
                                'status'],
                              ).withOpacity(
                                  0.15),
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  8),
                            ),
                            child: Text(
                              "Pembayaran: ${pembayaran['status']}",
                              style: TextStyle(
                                color:
                                _statusColor(
                                  pembayaran[
                                  'status'],
                                ),
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
