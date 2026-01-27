// Package utama Flutter
import 'package:flutter/material.dart';

// SharedPreferences digunakan untuk mengelola session (logout)
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT HALAMAN TERKAIT
import 'artikel_page.dart';   // Halaman artikel
import 'profile_page.dart';   // Halaman profil user
import 'welcome_page.dart';   // Halaman awal setelah logout

// HALAMAN SETTINGS
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // FUNGSI LOGOUT
  Future<void> _logout(BuildContext context) async {
    // Ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Hapus seluruh data session (email, role, isLogin, dll)
    await prefs.clear();

    // SNACKBAR LOGOUT BERHASIL
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout berhasil'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 800),
      ),
    );

    // Delay singkat agar snackbar terlihat oleh user
    await Future.delayed(const Duration(milliseconds: 800));

    // NAVIGASI KE WELCOME PAGE

    // pushAndRemoveUntil digunakan untuk:
    // - Menghapus seluruh stack halaman sebelumnya
    // - Mencegah user kembali ke halaman setelah logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman settings
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      // BODY HALAMAN
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // MENU PROFIL
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              subtitle: const Text('Lihat informasi akun'),
              onTap: () {
                // Navigasi ke halaman profil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(),
                  ),
                );
              },
            ),

            const Divider(),

            // MENU ARTIKEL
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Artikel'),
              subtitle: const Text('Tentang aplikasi reservasi'),
              onTap: () {
                // Navigasi ke halaman artikel
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ArtikelPage(),
                  ),
                );
              },
            ),

            const Divider(),

            // MENU LOGOUT
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
