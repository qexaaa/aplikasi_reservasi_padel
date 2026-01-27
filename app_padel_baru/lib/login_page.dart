// Digunakan untuk jsonDecode response dari API
import 'dart:convert'; // PENTING untuk jsonDecode

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

// HTTP client untuk komunikasi dengan API
import 'package:dio/dio.dart';

// Halaman utama setelah login berhasil
import 'home_page.dart';

// HALAMAN LOGIN
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Controller input TextField

  // Controller untuk input email
  final TextEditingController emailController = TextEditingController();

  // Controller untuk input password
  final TextEditingController passwordController = TextEditingController();

  // Dio HTTP Client
  // Digunakan untuk request API login
  final Dio _dio = Dio();

  // FUNGSI LOGIN (API)
  Future<void> _login(BuildContext context) async {

    // VALIDASI INPUT USER
    // Cek apakah email atau password kosong
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      // Tampilkan snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // REQUEST LOGIN KE API (POST)
      final response = await _dio.post(
        // Endpoint login di hosting
        "https://app.padel.baru.larathing.my.id/login.php",
        data: {
          // Kirim email dan password
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
        options: Options(
          // Kirim sebagai form-urlencoded agar cocok dengan PHP ($_POST)
          contentType: Headers.formUrlEncodedContentType,

          // Paksa response dalam bentuk plain text
          // Agar aman jika server tidak konsisten JSON header
          responseType: ResponseType.plain,
        ),
      );

      // PARSING RESPONSE DARI API
      dynamic rawData = response.data;

      // Jika response masih berupa String → decode ke JSON
      if (rawData is String) {
        rawData = jsonDecode(rawData);
      }

      // Pastikan hasil akhir berupa Map
      if (rawData is! Map<String, dynamic>) {
        throw Exception('Format response tidak valid');
      }

      // Cast ke Map agar mudah dipakai
      final Map<String, dynamic> result = rawData;

      // KONDISI LOGIN BERHASIL
      if (result['status'] == true) {
        // Ambil instance SharedPreferences
        final prefs = await SharedPreferences.getInstance();

        // Ambil data user dari response API
        final Map<String, dynamic> userData = result['data'];

        // SIMPAN SESSION LOGIN
        await prefs.setBool('isLogin', true);
        await prefs.setString('id', userData['id'].toString());
        await prefs.setString('nama', userData['nama']);
        await prefs.setString('email', userData['email']);
        await prefs.setString(
          'role',
          userData['role'].toString().toLowerCase().trim(),
        );

        // Snackbar login sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil'),
            backgroundColor: Colors.green,
          ),
        );

        // Delay singkat agar snackbar sempat terlihat
        await Future.delayed(const Duration(milliseconds: 800));

        // NAVIGASI KE HOMEPAGE
        // pushReplacement agar user tidak bisa kembali ke login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        // LOGIN GAGAL (DARI API)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message']?.toString() ?? 'Login gagal',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ERROR NETWORK / PARSING JSON
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // UI HALAMAN LOGIN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(
        title: const Text('Login'),
      ),

      // Padding utama halaman
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // INPUT EMAIL
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 16),

            // INPUT PASSWORD
            TextField(
              controller: passwordController,
              obscureText: true, // Sembunyikan password
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 24),

            // ================================
            // TOMBOL LOGIN
            // ================================
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
