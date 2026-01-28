// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan untuk komunikasi HTTP dengan API
import 'package:dio/dio.dart';

// Halaman untuk edit jadwal
import 'edit_jadwal_page.dart';

// HALAMAN KELOLA JADWAL (ADMIN)
// Digunakan oleh admin untuk menambah, melihat, mengedit, dan menghapus jadwal lapangan
class KelolaJadwalPage extends StatefulWidget {
  const KelolaJadwalPage({super.key});

  @override
  State<KelolaJadwalPage> createState() => _KelolaJadwalPageState();
}

class _KelolaJadwalPageState extends State<KelolaJadwalPage> {

  // Instance Dio sebagai HTTP client
  final Dio dio = Dio();

  // Menyimpan data jadwal dari API
  List jadwal = [];

  // Menyimpan data lapangan dari API
  List lapangan = [];

  // Penanda loading saat pertama kali halaman dibuka
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Ambil semua data saat halaman pertama kali dimuat
    fetchAll();
  }

  // Mengambil data jadwal dan lapangan secara bersamaan
  Future<void> fetchAll() async {
    await Future.wait([
      fetchJadwal(),
      fetchLapangan(),
    ]);

    // Setelah data selesai diambil, loading dimatikan
    setState(() => isLoading = false);
  }

  // Mengambil data jadwal dari API
  Future<void> fetchJadwal() async {
    try {
      final res = await dio.get(
        "https://app.padel.baru.larathing.my.id/jadwal/list.php",
      );

      // Simpan data jadwal, jika kosong maka gunakan list kosong
      jadwal = res.data['data'] ?? [];
    } catch (_) {
      // Tampilkan pesan jika gagal mengambil data jadwal
      _snack("Gagal mengambil data jadwal", Colors.red);
    }
  }

  // Mengambil data lapangan dari API
  Future<void> fetchLapangan() async {
    try {
      final res = await dio.get(
        "https://app.padel.baru.larathing.my.id/lapangan/list.php",
      );

      // Simpan data lapangan
      lapangan = res.data['data'] ?? [];
    } catch (_) {
      // Tampilkan pesan jika gagal mengambil data lapangan
      _snack("Gagal mengambil data lapangan", Colors.red);
    }
  }

  // Fungsi helper untuk menampilkan Snackbar
  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  // Mengecek apakah jadwal bentrok
  // Digunakan sebelum menambahkan jadwal baru
  bool isBentrok(
      String lapanganId,
      String tanggal,
      String mulai,
      String selesai,
      ) {
    for (final j in jadwal) {

      // Cek apakah lapangan dan tanggal sama
      if (j['lapangan_id'].toString() == lapanganId &&
          j['tanggal'] == tanggal) {

        // Cek bentrok jam
        if (!(selesai.compareTo(j['jam_mulai']) <= 0 ||
            mulai.compareTo(j['jam_selesai']) >= 0)) {
          return true;
        }
      }
    }
    return false;
  }

  // Menghapus jadwal berdasarkan ID
  Future<void> deleteJadwal(Map j) async {
    try {
      final res = await dio.post(
        "https://app.padel.baru.larathing.my.id/jadwal/delete.php",
        data: {
          "id": j['id'].toString(),
          "lapangan_id": j['lapangan_id'].toString(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // Jika berhasil, refresh data jadwal
      if (res.data['status'] == true) {
        _snack("Jadwal dihapus", Colors.green);
        await fetchJadwal();
        setState(() {});
      } else {
        _snack(res.data['message'], Colors.red);
      }
    } catch (_) {
      _snack("Gagal menghapus jadwal", Colors.red);
    }
  }

  // Menampilkan dialog untuk menambahkan jadwal baru
  Future<void> showTambahDialog() async {
    DateTime? tanggal;
    TimeOfDay? mulai;
    TimeOfDay? selesai;
    String? lapanganId;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Jadwal"),

        // StatefulBuilder agar state dialog bisa berubah
        content: StatefulBuilder(
          builder: (c, setLocal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Dropdown untuk memilih lapangan yang aktif
                DropdownButtonFormField<String>(
                  decoration:
                  const InputDecoration(labelText: "Lapangan"),
                  items: lapangan
                      .where((l) => l['status'] == 'aktif')
                      .map<DropdownMenuItem<String>>(
                        (l) => DropdownMenuItem(
                      value: l['id'].toString(),
                      child: Text(l['nama_lapangan']),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => lapanganId = v,
                ),

                // Pilih tanggal
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: Text(
                    tanggal == null
                        ? "Pilih tanggal"
                        : tanggal!.toString().substring(0, 10),
                  ),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate:
                      DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setLocal(() => tanggal = d);
                  },
                ),

                // Pilih jam mulai
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    mulai == null
                        ? "Jam mulai"
                        : mulai!.format(context),
                  ),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (t != null) setLocal(() => mulai = t);
                  },
                ),

                // Pilih jam selesai
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    selesai == null
                        ? "Jam selesai"
                        : selesai!.format(context),
                  ),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (t != null) setLocal(() => selesai = t);
                  },
                ),
              ],
            );
          },
        ),

        // Tombol aksi dialog
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            child: const Text("Simpan"),
            onPressed: () async {

              // Validasi input
              if (lapanganId == null ||
                  tanggal == null ||
                  mulai == null ||
                  selesai == null) {
                _snack("Data belum lengkap", Colors.orange);
                return;
              }

              // Format tanggal dan jam
              final tgl = tanggal!.toString().substring(0, 10);
              final jm =
                  "${mulai!.hour.toString().padLeft(2, '0')}:${mulai!.minute.toString().padLeft(2, '0')}";
              final js =
                  "${selesai!.hour.toString().padLeft(2, '0')}:${selesai!.minute.toString().padLeft(2, '0')}";

              // Cek bentrok jadwal
              if (isBentrok(lapanganId!, tgl, jm, js)) {
                _snack("Jadwal bentrok", Colors.red);
                return;
              }

              // Kirim data ke API
              final res = await dio.post(
                "https://app.padel.baru.larathing.my.id/jadwal/create.php",
                data: {
                  "lapangan_id": lapanganId,
                  "tanggal": tgl,
                  "jam_mulai": jm,
                  "jam_selesai": js,
                },
                options: Options(
                  contentType:
                  Headers.formUrlEncodedContentType,
                ),
              );

              // Jika berhasil, refresh data
              if (res.data['status'] == true) {
                Navigator.pop(context);
                _snack("Jadwal ditambahkan", Colors.green);
                await fetchJadwal();
                setState(() {});
              } else {
                _snack(res.data['message'], Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar halaman kelola jadwal
      appBar: AppBar(
        title: const Text("Kelola Jadwal"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Tombol tambah jadwal
      floatingActionButton: FloatingActionButton(
        onPressed: showTambahDialog,
        child: const Icon(Icons.add),
      ),

      // BODY HALAMAN
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jadwal.isEmpty
          ? const Center(child: Text("Belum ada jadwal"))
          : ListView.builder(
        itemCount: jadwal.length,
        itemBuilder: (_, i) {
          final j = jadwal[i];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(j['nama_lapangan']),
              subtitle: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    "${j['tanggal']} | ${j['jam_mulai']} - ${j['jam_selesai']}",
                  ),

                  // Menampilkan status jadwal (tersedia / dibooking)
                  if (j['status'] != null)
                    Text(
                      "Status: ${j['status']}",
                      style: TextStyle(
                        color: j['status'] ==
                            'dibooking'
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),

              // Masuk ke halaman edit jadwal
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditJadwalPage(data: j),
                  ),
                ).then((_) => fetchAll());
              },

              // Tombol hapus jadwal
              trailing: IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: () =>
                    deleteJadwal(j),
              ),
            ),
          );
        },
      ),
    );
  }
}
