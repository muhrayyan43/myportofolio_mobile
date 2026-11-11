import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

/// Halaman utama MyPortfolio Mobile.
///
/// Isinya tetap selama aplikasi berjalan, jadi cukup [StatelessWidget]. Data
/// disimpan di field `static` agar konstruktornya bisa `const` dan daftar
/// tombol tidak dibuat ulang setiap kali halaman di-build.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const String npm = '2406496372';
  static const String nama = 'Muhammad Rayyan Basalamah';
  static const String kelas = 'PBP B';

  static final List<ItemHomepage> items = [
    ItemHomepage('Lihat Experience', Icons.work, Colors.blue.shade800),
    ItemHomepage('Tambah Experience', Icons.add_circle, Colors.green.shade800),
    ItemHomepage('Logout', Icons.logout, Colors.red.shade700),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Selamat datang di MyPortfolio Mobile!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: [for (final item in items) ItemCard(item)],
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