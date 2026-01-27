// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// Digunakan untuk jsonDecode jika response API berupa String
import 'dart:convert';

// HALAMAN JADWAL LAPANGAN
class JadwalLapanganPage extends StatefulWidget {
  const JadwalLapanganPage({super.key});

  @override
  State<JadwalLapanganPage> createState() =>
      _JadwalLapanganPageState();
}

class _JadwalLapanganPageState
    extends State<JadwalLapanganPage> {

  // DIO HTTP CLIENT
  final Dio _dio = Dio();

  // DATA JADWAL
  // Menyimpan list jadwal lapangan
  List _jadwal = [];

  // Penanda proses loading data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Ambil data jadwal saat halaman dibuka
    _getJadwal();
  }

  // AMBIL DATA JADWAL (API)
  Future<void> _getJadwal() async {
    try {
      // Request GET ke API jadwal
      final response = await _dio.get(
        "https://app.padel.baru.larathing.my.id/jadwal/list.php",
      );

      // Jika request sukses
      if (response.statusCode == 200) {
        var result = response.data;

        // Decode JSON jika response masih berupa String
        if (result is String) {
          result = jsonDecode(result);
        }

        // Validasi struktur response
        if (result is Map &&
            result['status'] == true &&
            result.containsKey('data')) {

          // Simpan data jadwal ke state
          setState(() {
            _jadwal = List.from(result['data']);
            _isLoading = false;
          });
        } else {
          // Jika tidak ada data
          setState(() {
            _jadwal = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Jika terjadi error network / server
      debugPrint("Error ambil jadwal: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman jadwal lapangan
      appBar: AppBar(
        title: const Text("Jadwal Lapangan"),
      ),


      // BODY HALAMAN

      body: _isLoading

      // KONDISI LOADING

          ? const Center(
        child: CircularProgressIndicator(),
      )

      // KONDISI DATA KOSONG
          : _jadwal.isEmpty
          ? const Center(
        child: Text("Belum ada jadwal"),
      )

      // KONDISI DATA ADA
          : ListView.builder(
        itemCount: _jadwal.length,
        itemBuilder: (context, index) {
          final item = _jadwal[index];

          return Card(
            margin:
            const EdgeInsets.all(10),
            child: ListTile(

              // Ikon kalender sebagai penanda jadwal
              leading:
              const Icon(Icons.calendar_month),

              // Nama lapangan
              title: Text(
                item['nama_lapangan']
                    ?? 'Lapangan',
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              // Detail jadwal
              subtitle: Text(
                "Tanggal : ${item['tanggal']}\n"
                    "Jam     : ${item['jam_mulai']} - ${item['jam_selesai']}\n"
                    "Status  : ${item['status']}",
              ),
            ),
          );
        },
      ),
    );
  }
}
