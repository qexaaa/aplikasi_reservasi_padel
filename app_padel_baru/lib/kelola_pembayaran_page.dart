// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// HALAMAN KELOLA PEMBAYARAN (ADMIN)
class KelolaPembayaranPage extends StatefulWidget {
  const KelolaPembayaranPage({super.key});

  @override
  State<KelolaPembayaranPage> createState() =>
      _KelolaPembayaranPageState();
}

class _KelolaPembayaranPageState
    extends State<KelolaPembayaranPage> {

  // DIO HTTP CLIENT
  final dio = Dio();

  // DATA PEMBAYARAN
  // Menyimpan list seluruh data pembayaran
  List data = [];

  // AMBIL DATA PEMBAYARAN (API)
  Future<void> fetch() async {
    final res = await dio.get(
      "https://app.padel.baru.larathing.my.id/pembayaran/list.php",
    );

    // Simpan data pembayaran ke state
    setState(() => data = res.data['data']);
  }

  @override
  void initState() {
    super.initState();

    // Ambil data pembayaran saat halaman dibuka
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman kelola pembayaran
      appBar: AppBar(
        title: const Text("Kelola Pembayaran"),
      ),

      // BODY HALAMAN
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) => ListTile(

          // NAMA LAPANGAN
          title: Text(
            data[i]['nama_lapangan'],
          ),

          // STATUS PEMBAYARAN
          subtitle: Text(
            "Status: ${data[i]['status']}",
          ),

          // TOMBOL VERIFIKASI
          trailing: ElevatedButton(
            child: const Text("LUNAS"),

            // Jika status sudah lunas, tombol dinonaktifkan
            onPressed: data[i]['status'] == 'lunas'
                ? null
                : () async {
              try {
                // Request POST untuk update status pembayaran
                final res = await dio.post(
                  "https://app.padel.baru.larathing.my.id/pembayaran/update_status.php",
                  data: {
                    "id": data[i]['id'],
                    "status": "lunas",
                  },
                  options: Options(
                    contentType:
                    Headers.formUrlEncodedContentType,
                  ),
                );

                // SNACKBAR SUKSES
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Pembayaran berhasil diverifikasi",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                // Refresh data pembayaran
                fetch();
              } catch (e) {
                // SNACKBAR ERROR
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Gagal memverifikasi pembayaran",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
