import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EditLapanganPage extends StatefulWidget {
  final Map<String, dynamic> lapangan;

  const EditLapanganPage({super.key, required this.lapangan});

  @override
  State<EditLapanganPage> createState() => _EditLapanganPageState();
}

class _EditLapanganPageState extends State<EditLapanganPage> {
  final dio = Dio();
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final hargaController = TextEditingController();
  final gambarController = TextEditingController();

  String status = 'aktif';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController.text = widget.lapangan['nama_lapangan'];
    deskripsiController.text = widget.lapangan['deskripsi'] ?? '';
    hargaController.text = widget.lapangan['harga']?.toString() ?? '';
    gambarController.text = widget.lapangan['gambar'] ?? '';
    status = widget.lapangan['status'] ?? 'aktif';
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final res = await dio.post(
        "https://app.padel.baru.larathing.my.id/lapangan/update.php",
        data: {
          "id": widget.lapangan['id'],
          "nama_lapangan": namaController.text,
          "deskripsi": deskripsiController.text,
          "harga": hargaController.text,
          "gambar": gambarController.text,
          "status": status,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (res.data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.data['message'] ?? "Lapangan berhasil diupdate"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.data['message'] ?? "Gagal update lapangan"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Terjadi kesalahan"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Lapangan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // PREVIEW GAMBAR
              if (gambarController.text.isNotEmpty)
                Image.network(
                  gambarController.text,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 80),
                ),

              const SizedBox(height: 12),

              TextFormField(
                controller: gambarController,
                decoration: const InputDecoration(
                  labelText: "URL Gambar",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.isEmpty ? "URL gambar wajib diisi" : null,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lapangan",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.isEmpty ? "Nama lapangan wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v!.isEmpty ? "Harga wajib diisi" : null,
              ),

              const SizedBox(height: 12),

              // DROPDOWN STATUS
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: "Status Lapangan",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'aktif',
                    child: Text("Aktif"),
                  ),
                  DropdownMenuItem(
                    value: 'nonaktif',
                    child: Text("Nonaktif / Maintenance"),
                  ),
                ],
                onChanged: (v) => setState(() => status = v!),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Lapangan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
