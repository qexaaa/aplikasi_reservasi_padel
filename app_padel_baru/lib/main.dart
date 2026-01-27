// Import package utama Flutter untuk UI
import 'package:flutter/material.dart';

// Import SharedPreferences untuk menyimpan & membaca session login
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT HALAMAN

import 'welcome_page.dart';
import 'home_page.dart';

// ENTRY POINT APLIKASI
void main() {
  // Menjalankan aplikasi Flutter
  runApp(const MyApp());
}

// ROOT APLIKASI
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // CEK SESSION LOGIN + ROLE
  /// return null  -> user belum login
  /// return role  -> admin / user
  ///
  /// Fungsi ini digunakan untuk:
  /// - Mengecek apakah user sudah login sebelumnya
  /// - Menentukan tampilan halaman awal(home) aplikasi sesuai dengan rolenya

  Future<String?> _checkSession() async {
    // Mengambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil email dari session
    final email = prefs.getString('email');

    // Ambil role user dari session (admin / user)
    final role = prefs.getString('role');

    // Jika email & role ada → user sudah login
    if (email != null && role != null) {
      return role;
    }

    // Jika tidak ada session → belum login
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner debug
      debugShowCheckedModeBanner: false,

      // Judul aplikasi
      title: 'Reservasi Padel',

      // Tema utama aplikasi
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),


      // PENENTUAN HALAMAN AWAL
      home: FutureBuilder<String?>(
        // Memanggil fungsi cek session
        future: _checkSession(),

        builder: (context, snapshot) {

          // KONDISI: LOADING
          // Saat SharedPreferences masih dibaca
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // KONDISI: SUDAH LOGIN
          // Jika snapshot.data tidak null → user sudah login
          // Arahkan ke HomePage (menu berdasarkan role)
          if (snapshot.data != null) {
            return const HomePage();
          }

          // KONDISI: BELUM LOGIN
          // Arahkan ke WelcomePage
          return const WelcomePage();
        },
      ),
    );
  }
}
