// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Dio digunakan sebagai HTTP client untuk komunikasi dengan API
import 'package:dio/dio.dart';

// HALAMAN REGISTER
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // KEY FORM UNTUK VALIDASI
  // Digunakan untuk memvalidasi seluruh input dalam Form
  final _formKey = GlobalKey<FormState>();

  // CONTROLLER INPUT
  // Controller untuk input nama
  final TextEditingController namaController = TextEditingController();

  // Controller untuk input email
  final TextEditingController emailController = TextEditingController();

  // Controller untuk input password
  final TextEditingController passwordController = TextEditingController();

  // STATE LOADING
  // Digunakan untuk disable tombol & menampilkan loading
  bool isLoading = false;

  // DIO HTTP CLIENT
  // Digunakan untuk request ke API register
  final Dio dio = Dio();

  // FUNGSI REGISTER (API)
  Future<void> register() async {

    // Validasi seluruh field Form
    // Jika ada yang tidak valid, proses dihentikan
    if (!_formKey.currentState!.validate()) return;

    // Set loading = true (tombol disable)
    setState(() => isLoading = true);

    try {
      // REQUEST REGISTER KE API (POST)
      final response = await dio.post(
        // Endpoint API register di hosting
        'https://app.padel.baru.larathing.my.id/register.php',
        data: {
          // Data user yang dikirim ke backend
          "nama": namaController.text,
          "email": emailController.text,
          "password": passwordController.text,

          // Role default user
          "role": "user",
        },
        options: Options(
          // Kirim data sebagai form-urlencoded agar cocok dengan PHP ($_POST)
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // KONDISI REGISTER BERHASIL
      if (response.data['status'] == true) {

        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Registrasi berhasil, silakan login'),
            actions: [
              TextButton(
                onPressed: () {
                  // Tutup dialog
                  Navigator.pop(context);

                  // Kembali ke halaman login
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      } else {
        // REGISTER GAGAL DARI API
        showError(
          response.data['message'] ?? 'Registrasi gagal',
        );
      }
    } catch (e) {
      // ERROR NETWORK / SERVER
      showError('Terjadi kesalahan server');
    } finally {
      // Matikan loading
      setState(() => isLoading = false);
    }
  }

  // FUNGSI MENAMPILKAN ERROR (SNACKBAR)
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // UI HALAMAN REGISTER
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(title: const Text('Register')),

      // Padding utama halaman
      body: Padding(
        padding: const EdgeInsets.all(16),

        // Form untuk validasi input
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // INPUT NAMA
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) =>
                value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              // INPUT EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) =>
                value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              // INPUT PASSWORD
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true, // Sembunyikan password
                validator: (value) =>
                value!.length < 6 ? 'Minimal 6 karakter' : null,
              ),

              const SizedBox(height: 24),

              // TOMBOL DAFTAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text('Daftar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
