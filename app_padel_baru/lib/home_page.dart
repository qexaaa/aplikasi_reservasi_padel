// Package utama Flutter
import 'package:flutter/material.dart';

// SharedPreferences digunakan untuk membaca session login
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT HALAMAN (USER)
import 'reservasi_page.dart';
import 'jadwal_lapangan_page.dart';
import 'riwayat_reservasi_page.dart';
import 'gallery_page.dart';
import 'settings_page.dart';
import 'pembayaran_page.dart'; // Menu pembayaran untuk user

// IMPORT HALAMAN (ADMIN)
import 'kelola_jadwal_page.dart';
import 'kelola_pembayaran_page.dart';
import 'kelola_lapangan_page.dart';

// HALAMAN HOME / BERANDA
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // DATA SESSION USER

  // Nama user yang sedang login
  String namaUser = '-';

  // Role user (admin / user)
  String roleUser = '-';

  // Status login user
  bool isLogin = false;

  // AMBIL DATA SESSION DARI LOCAL STORAGE
  Future<void> _getSession() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data session dan simpan ke state
    setState(() {
      namaUser = prefs.getString('nama') ?? '-';
      roleUser = prefs.getString('role') ?? '-'; // admin / user
      isLogin = prefs.getBool('isLogin') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();

    // Ambil session saat halaman pertama kali dibuka
    _getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman utama
      appBar: AppBar(
        title: const Text("Beranda"),
      ),

      // BODY HALAMAN

      body: ListView(
        children: [

          // HEADER IMAGE
          SizedBox(
            height: 200,
            child: Image.network(
              // Gambar header halaman
              "https://brickmortar.id/wp-content/uploads/2024/08/Apa-Itu-Padel-Olah-Raga-Seperti-Tennis.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          // INFO USER (CARD)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [

                    // Icon user
                    const Icon(Icons.person, size: 40),

                    const SizedBox(width: 12),

                    // NAMA & STATUS LOGIN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama user
                          Text(
                            namaUser,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Status login
                          Text(
                            isLogin ? 'Status: Aktif' : 'Status: Tidak Aktif',
                            style: TextStyle(
                              color: isLogin ? Colors.green : Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ROLE BADGE (ADMIN / USER)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: roleUser == 'admin'
                            ? Colors.blue.withOpacity(0.15)
                            : Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        roleUser.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: roleUser == 'admin'
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // MENU KHUSUS USER
          if (roleUser == 'user') ...[
            _menu(context, Icons.add_box, "Reservasi Lapangan", const ReservasiPage()),
            _menu(context, Icons.calendar_month, "Jadwal Lapangan", const JadwalLapanganPage()),
            _menu(context, Icons.history, "Riwayat Reservasi", const RiwayatReservasiPage()),
            _menu(context, Icons.payment, "Pembayaran", const PembayaranPage()),
          ],

          // MENU KHUSUS ADMIN
          if (roleUser == 'admin') ...[
            _menu(context, Icons.sports_soccer, "Kelola Lapangan", const KelolaLapanganPage()),
            _menu(context, Icons.calendar_month, "Kelola Jadwal", const KelolaJadwalPage()),
            _menu(context, Icons.payment, "Kelola Pembayaran", const KelolaPembayaranPage(),),
          ],

          // MENU UMUM (SEMUA ROLE)
          _menu(context, Icons.photo_library, "Gallery Lapangan", const GalleryPage()),
          _menu(context, Icons.settings, "Settings", const SettingsPage()),
        ],
      ),
    );
  }

  // WIDGET MENU (REUSABLE)
  Widget _menu(
      BuildContext context,
      IconData icon,
      String title,
      Widget page,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        // Navigasi ke halaman tujuan
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
