// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// SharedPreferences digunakan untuk mengambil email user (session)
import 'package:shared_preferences/shared_preferences.dart';

// HALAMAN PEMBAYARAN USER
class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {

  // DIO HTTP CLIENT
  final Dio dio = Dio();

  // DATA PEMBAYARAN
  // Menyimpan list data pembayaran milik user
  List data = [];

  // Penanda proses loading data
  bool isLoading = true;

  // AMBIL DATA PEMBAYARAN USER (API)
  Future<void> fetch() async {
    // Ambil email user dari session
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    // Jika email tidak ada, hentikan proses
    if (email == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      // Request GET ke API pembayaran dengan filter email user
      final res = await dio.get(
        "https://app.padel.baru.larathing.my.id/pembayaran/list.php",
        queryParameters: {
          "email": email,
        },
      );

      // Jika response sukses
      if (res.data['status'] == true) {
        // Simpan data pembayaran
        data = res.data['data'];
      } else {
        // Jika tidak ada data
        data = [];
      }
    } catch (_) {
      // Jika error network / server
      data = [];
    } finally {
      // Matikan loading
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    // Ambil data pembayaran saat halaman pertama kali dibuka
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman pembayaran
      appBar: AppBar(
        title: const Text("Pembayaran Saya"),
      ),

      // BODY HALAMAN

      body: isLoading

      // KONDISI LOADING

          ? const Center(
        child: CircularProgressIndicator(),
      )

      // KONDISI DATA KOSONG
          : data.isEmpty
          ? const Center(
        child: Text("Belum ada data pembayaran"),
      )

      // KONDISI DATA ADA
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(

            // NAMA LAPANGAN
            title: Text(
              data[i]['nama_lapangan'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            // DETAIL PEMBAYARAN
            subtitle: Text(
              "Tanggal : ${data[i]['tanggal']}\n"
                  "Jam     : ${data[i]['jam_mulai']} - ${data[i]['jam_selesai']}\n"
                  "Status  : ${data[i]['status']}",
            ),

            // STATUS PEMBAYARAN (CHIP)
            trailing: Chip(
              label: Text(
                data[i]['status']
                    .toString()
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor:
              data[i]['status'] == 'lunas'
                  ? Colors.green   // Sudah dibayar
                  : Colors.orange, // Menunggu verifikasi
            ),
          ),
        ),
      ),
    );
  }
}
