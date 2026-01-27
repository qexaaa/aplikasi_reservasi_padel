// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// SharedPreferences digunakan untuk mengambil data user
// yang disimpan saat login (session)
import 'package:shared_preferences/shared_preferences.dart';

// HALAMAN PROFIL USER
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  // DATA PROFIL USER
  String nama = '-';    // Nama user
  String email = '-';   // Email user
  bool isLogin = false; // Status login user

  // AMBIL DATA PROFIL DARI SESSION
  Future<void> _getProfile() async {
    final prefs =
    await SharedPreferences.getInstance();

    // Ambil data yang tersimpan di SharedPreferences
    setState(() {
      nama = prefs.getString('nama') ?? '-';
      email = prefs.getString('email') ?? '-';
      isLogin =
          prefs.getBool('isLogin') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();

    // Ambil data profil saat halaman dibuka
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar halaman profil
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context),
        ),
      ),

      // BODY HALAMAN
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // FOTO PROFIL (ICON DEFAULT)
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // INFORMASI USER
            Card(
              child: Column(
                children: [

                  // NAMA USER
                  ListTile(
                    leading:
                    const Icon(Icons.person),
                    title: const Text('Nama'),
                    subtitle: Text(nama),
                  ),

                  const Divider(height: 0),

                  // EMAIL USER
                  ListTile(
                    leading:
                    const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),

                  const Divider(height: 0),

                  // STATUS LOGIN
                  ListTile(
                    leading: const Icon(
                        Icons.verified_user),
                    title: const Text('Status'),
                    subtitle: Text(
                      isLogin
                          ? 'Aktif'
                          : 'Tidak Aktif',
                      style: TextStyle(
                        color: isLogin
                            ? Colors.green
                            : Colors.red,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
