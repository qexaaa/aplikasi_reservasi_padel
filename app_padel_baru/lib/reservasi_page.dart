// Package utama Flutter untuk UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// SharedPreferences digunakan untuk mengambil email user (session)
import 'package:shared_preferences/shared_preferences.dart';

// Digunakan untuk jsonDecode jika response berupa String
import 'dart:convert';

// HALAMAN RESERVASI LAPANGAN
class ReservasiPage extends StatefulWidget {
  const ReservasiPage({super.key});

  @override
  State<ReservasiPage> createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiPage> {

  // DIO HTTP CLIENT
  final Dio dio = Dio();

  // DATA LAPANGAN & JADWAL
  List lapanganList = [];
  List jadwalList = [];

  // DATA TERPILIH
  int? lapanganId;
  int? jadwalId;
  Map? selectedJadwal;

  // STATE UI
  bool isLoading = false;
  bool isLapanganLoading = true;
  bool isJadwalLoading = false;
  bool lapanganError = false;

  @override
  void initState() {
    super.initState();
    getLapangan();
  }

  // ================================
  // AMBIL DATA LAPANGAN
  // ================================
  Future<void> getLapangan() async {
    try {
      final response = await dio.get(
        'https://app.padel.baru.larathing.my.id/lapangan/list.php?status=aktif',
      );

      if (response.data['status'] == true) {
        lapanganList = response.data['data'];

        lapanganId = int.parse(
          lapanganList.first['id'].toString(),
        );

        await getJadwal();
      } else {
        lapanganError = true;
      }
    } catch (_) {
      lapanganError = true;
    } finally {
      setState(() => isLapanganLoading = false);
    }
  }

  // ================================
  // AMBIL JADWAL BERDASARKAN LAPANGAN
  // ================================
  Future<void> getJadwal() async {
    setState(() {
      isJadwalLoading = true;
      jadwalList = [];
      jadwalId = null;
      selectedJadwal = null;
    });

    try {
      final response = await dio.get(
        "https://app.padel.baru.larathing.my.id/jadwal/list.php",
        queryParameters: {
          "lapangan_id": lapanganId,
          "status": "tersedia",
        },
      );

      var result = response.data;
      if (result is String) result = jsonDecode(result);

      if (result['status'] == true) {
        jadwalList = result['data'];

        if (jadwalList.isNotEmpty) {
          // DEFAULT PILIH JADWAL PERTAMA AGAR DROPDOWN TIDAK ERROR
          jadwalId = int.parse(jadwalList.first['id'].toString());
          selectedJadwal = jadwalList.first;
        }
      }
    } catch (_) {
      // abaikan error
    } finally {
      setState(() => isJadwalLoading = false);
    }
  }

  // ================================
  // SIMPAN RESERVASI
  // ================================
  Future<void> simpanReservasi() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null ||
        selectedJadwal == null ||
        lapanganId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data reservasi belum lengkap'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await dio.post(
        'https://app.padel.baru.larathing.my.id/reservasi/create.php',
        data: {
          "email": email,
          "lapangan_id": lapanganId.toString(),
          "jadwal_id": selectedJadwal!['id'].toString(),
          "tanggal": selectedJadwal!['tanggal'],
          "jam_mulai": selectedJadwal!['jam_mulai'],
          "jam_selesai": selectedJadwal!['jam_selesai'],
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data['message']),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan reservasi'),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservasi Lapangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLapanganLoading
            ? const Center(child: CircularProgressIndicator())
            : lapanganError
            ? const Center(
          child: Text(
            'Data lapangan tidak tersedia',
            style: TextStyle(color: Colors.red),
          ),
        )
            : Column(
          children: [

            // PILIH LAPANGAN
            DropdownButtonFormField<int>(
              value: lapanganId,
              items: lapanganList
                  .map<DropdownMenuItem<int>>((item) {
                return DropdownMenuItem<int>(
                  value: int.parse(item['id'].toString()),
                  child: Text(item['nama_lapangan']),
                );
              }).toList(),
              onChanged: (value) async {
                lapanganId = value;
                await getJadwal();
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Lapangan',
                prefixIcon: Icon(Icons.sports_tennis),
              ),
            ),

            const SizedBox(height: 12),

            // PILIH JADWAL
            isJadwalLoading
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
              value: jadwalId,
              items: jadwalList
                  .map<DropdownMenuItem<int>>((j) {
                return DropdownMenuItem<int>(
                  value: int.parse(j['id'].toString()),
                  child: Text(
                    "${j['tanggal']} | ${j['jam_mulai']} - ${j['jam_selesai']}",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  jadwalId = value;
                  selectedJadwal = jadwalList.firstWhere(
                        (e) =>
                    e['id'].toString() ==
                        value.toString(),
                  );
                });
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Jadwal',
                prefixIcon: Icon(Icons.schedule),
              ),
            ),

            const SizedBox(height: 24),

            // SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                isLoading ? null : simpanReservasi,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                    : const Text('Simpan Reservasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
