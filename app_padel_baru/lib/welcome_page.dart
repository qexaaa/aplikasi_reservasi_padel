// Package utama Flutter untuk membangun UI
import 'package:flutter/material.dart';

// Import halaman login & register
import 'login_page.dart';
import 'register_page.dart';

// HALAMAN WELCOME / LANDING PAGE
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        // BACKGROUND GRADIENT

        // Digunakan untuk memberikan tampilan visual
        // yang lebih menarik pada halaman awal aplikasi
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E7D32), // Hijau tua
              Color(0xFF66BB6A), // Hijau muda
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            // CARD UTAMA
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // GAMBAR (IMAGE.NETWORK)
                    // Menampilkan gambar lapangan padel
                    Image.network(
                      'https://asset.ayo.co.id/image/venue/175160421280492.image_cropper_1751604125603.jpg.jpeg',
                      height: 200,
                      fit: BoxFit.cover,

                      // Loading indicator saat gambar dimuat
                      loadingBuilder:
                          (context, child, loadingProgress) {
                        if (loadingProgress == null)
                          return child;
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                        );
                      },

                      // Fallback jika gambar gagal dimuat
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const SizedBox(
                          height: 200,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // JUDUL APLIKASI
                    const Text(
                      'Reservasi Padel',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // SUBTITLE / DESKRIPSI
                    const Text(
                      'Pesan lapangan padel dengan mudah dan cepat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // TOMBOL LOGIN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                12),
                          ),
                        ),
                        onPressed: () {
                          // Navigasi ke halaman login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style:
                          TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // TOMBOL REGISTER
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style:
                        OutlinedButton.styleFrom(
                          padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                          side: const BorderSide(
                              color: Colors.green),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                12),
                          ),
                        ),
                        onPressed: () {
                          // Navigasi ke halaman register
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style:
                          TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
