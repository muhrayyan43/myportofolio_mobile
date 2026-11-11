import 'package:flutter/material.dart';

/// Kartu kecil berisi satu informasi pemilik portofolio, misalnya NPM.
///
/// Dipakai tiga kali di halaman utama (NPM, Name, Class), jadi tampilannya
/// cukup ditulis sekali di sini.
class InfoCard extends StatelessWidget {
  /// Membuat kartu dengan judul [title] dan isi [content].
  const InfoCard({super.key, required this.title, required this.content});

  /// Label informasi, misalnya `NPM`.
  final String title;

  /// Nilai informasi, misalnya `2406496372`.
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Memberikan efek bayangan kartu elevasi 2 unit.
      elevation: 2.0,
      child: Container(
        // Menyesuaikan lebar kartu dengan proporsi layar (dibagi 3.5).
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        // Menyusun teks title dan content secara vertikal.
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}