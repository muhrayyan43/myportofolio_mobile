import 'package:flutter/material.dart';

/// Kartu kecil berisi satu informasi pemilik portofolio, misalnya NPM.
///
/// Lebarnya ditentukan oleh induk, sehingga kartu yang sama bisa berjajar
/// di layar lebar atau bertumpuk di HP.
class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}