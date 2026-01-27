// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// ================================
// HALAMAN EDIT JADWAL (ADMIN)
// ================================
class EditJadwalPage extends StatefulWidget {
  // Data jadwal yang dipilih dari halaman sebelumnya
  final Map data;

  const EditJadwalPage({super.key, required this.data});

  @override
  State<EditJadwalPage> createState() => _EditJadwalPageState();
}

class _EditJadwalPageState extends State<EditJadwalPage> {
  // Instance Dio untuk request API
  final Dio dio = Dio();

  // Variabel untuk menyimpan tanggal & jam
  DateTime? selectedDate;
  TimeOfDay? jamMulai;
  TimeOfDay? jamSelesai;

  // List lapangan dari database
  List lapanganList = [];

  // ID lapangan yang dipilih
  String? selectedLapanganId;

  @override
  void initState() {
    super.initState();

    // Ambil data awal dari jadwal yang dipilih
    selectedDate = DateTime.parse(widget.data['tanggal']);
    jamMulai = _parseTime(widget.data['jam_mulai']);
    jamSelesai = _parseTime(widget.data['jam_selesai']);

    // Ambil data lapangan dari API
    fetchLapangan();
  }

  // ======================
  // PARSE JAM DARI STRING
  // ======================
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // ======================
  // AMBIL DATA LAPANGAN (API)
  // ======================
  Future<void> fetchLapangan() async {
    try {
      final res = await dio.get(
        "https://app.padel.baru.larathing.my.id/lapangan/list.php",
      );

      final list = res.data['data'] ?? [];

      setState(() {
        lapanganList = list;

        // Set lapangan terpilih
        // ⚠️ dilakukan SETELAH data lapangan tersedia
        selectedLapanganId =
            widget.data['lapangan_id'].toString();
      });
    } catch (e) {
      // Snackbar jika gagal mengambil data lapangan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengambil data lapangan"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ======================
  // UPDATE DATA JADWAL (API)
  // ======================
  Future<void> updateJadwal() async {
    // Format tanggal YYYY-MM-DD
    final tanggal =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    // Format jam mulai HH:mm
    final mulai =
        "${jamMulai!.hour.toString().padLeft(2, '0')}:${jamMulai!.minute.toString().padLeft(2, '0')}";

    // Format jam selesai HH:mm
    final selesai =
        "${jamSelesai!.hour.toString().padLeft(2, '0')}:${jamSelesai!.minute.toString().padLeft(2, '0')}";

    try {
      // Request POST ke API update jadwal
      final res = await dio.post(
        "https://app.padel.baru.larathing.my.id/jadwal/update.php",
        data: {
          "id": widget.data['id'],
          "lapangan_id": selectedLapanganId,
          "tanggal": tanggal,
          "jam_mulai": mulai,
          "jam_selesai": selesai,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Jika update berhasil
      if (res.data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res.data['message'] ??
                  "Berhasil update jadwal",
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman sebelumnya
        // dengan status true (untuk refresh)
        Navigator.pop(context, true);
      } else {
        // Jika update gagal dari API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res.data['message'] ??
                  "Gagal update jadwal",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Error jaringan / server
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Terjadi kesalahan"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ======================
  // UI HALAMAN
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Jadwal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ======================
            // DROPDOWN LAPANGAN
            // ======================
            DropdownButtonFormField<String>(
              // Pastikan value hanya di-set jika ada di items
              value: lapanganList.any(
                    (l) =>
                l['id'].toString() ==
                    selectedLapanganId,
              )
                  ? selectedLapanganId
                  : null,
              decoration: const InputDecoration(
                labelText: "Lapangan",
                border: OutlineInputBorder(),
              ),
              items: lapanganList
                  .map<DropdownMenuItem<String>>(
                      (item) {
                    return DropdownMenuItem<String>(
                      value: item['id'].toString(),
                      child: Text(item['nama_lapangan']),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() =>
                selectedLapanganId = value);
              },
            ),

            const SizedBox(height: 16),

            // ======================
            // PILIH TANGGAL
            // ======================
            ListTile(
              leading:
              const Icon(Icons.date_range),
              title: Text(
                "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
              ),
              onTap: () async {
                final date =
                await showDatePicker(
                  context: context,
                  initialDate: selectedDate!,
                  firstDate: DateTime.now(),
                  lastDate:
                  DateTime(DateTime.now().year + 1),
                );
                if (date != null) {
                  setState(() =>
                  selectedDate = date);
                }
              },
            ),

            // ======================
            // JAM MULAI
            // ======================
            ListTile(
              leading:
              const Icon(Icons.schedule),
              title: Text(
                "Jam Mulai: ${jamMulai!.format(context)}",
              ),
              onTap: () async {
                final time =
                await showTimePicker(
                  context: context,
                  initialTime: jamMulai!,
                );
                if (time != null) {
                  setState(() =>
                  jamMulai = time);
                }
              },
            ),

            // ======================
            // JAM SELESAI
            // ======================
            ListTile(
              leading:
              const Icon(Icons.schedule),
              title: Text(
                "Jam Selesai: ${jamSelesai!.format(context)}",
              ),
              onTap: () async {
                final time =
                await showTimePicker(
                  context: context,
                  initialTime: jamSelesai!,
                );
                if (time != null) {
                  setState(() =>
                  jamSelesai = time);
                }
              },
            ),

            const SizedBox(height: 24),

            // ======================
            // TOMBOL UPDATE
            // ======================
            ElevatedButton(
              onPressed: updateJadwal,
              child: const Text("Update Jadwal"),
            ),
          ],
        ),
      ),
    );
  }
}
