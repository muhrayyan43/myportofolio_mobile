import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';
import 'package:myportofolio_mobile/widgets/profile_header.dart';

/// Lebar maksimum konten agar kartu tidak melebar berlebihan di tablet dan web.
const double kMaxContentWidth = 720;

/// Lebar konten di bawah nilai ini dianggap layar sempit (HP posisi potret).
const double kCompactBreakpoint = 480;

/// Jumlah kolom grid tombol untuk lebar konten [width]: 2 kolom di layar
/// sempit, 4 kolom di layar lebar.
int actionColumnsFor(double width) => width < kCompactBreakpoint ? 2 : 4;

/// Halaman utama MyPortfolio Mobile.
///
/// Isinya tetap selama aplikasi berjalan, jadi cukup [StatelessWidget]. Data
/// disimpan di field `static` agar konstruktornya bisa `const`. Tata letak
/// mengikuti lebar layar lewat [LayoutBuilder], dan konten dibungkus
/// [SingleChildScrollView] agar tidak overflow di layar pendek.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const String npm = '2406496372';
  static const String nama = 'Muhammad Rayyan Basalamah';
  static const String kelas = 'PBP B';
  static const String sapaan = 'Halo, saya Rayyan';
  static const String keterangan = 'S1 Sistem Informasi · Universitas Indonesia';

  static final List<ItemHomepage> items = [
    ItemHomepage(
      'Lihat Experience',
      Icons.work,
      Colors.blue.shade800,
      description: 'Lihat daftar pengalaman magang, riset, volunteer, dan kerja',
    ),
    ItemHomepage(
      'Tambah Experience',
      Icons.add_circle,
      Colors.green.shade800,
      description: 'Tambah pengalaman baru ke portofolio',
    ),
    ItemHomepage(
      'Lihat Proyek',
      Icons.folder,
      Colors.amber.shade700,
      description: 'Lihat proyek yang pernah dikerjakan',
    ),
    ItemHomepage(
      'Logout',
      Icons.logout,
      Colors.red.shade700,
      description: 'Keluar dari akun',
    ),
  ];

  static const double _pagePadding = 16;
  static const double _gap = 12;

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(
              math.max(constraints.maxWidth - 2 * _pagePadding, 0.0),
              kMaxContentWidth,
            );
            final compact = contentWidth < kCompactBreakpoint;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(_pagePadding),
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ProfileHeader(
                        name: nama,
                        greeting: sapaan,
                        subtitle: keterangan,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCards(compact: compact),
                      const SizedBox(height: 24),
                      const Text(
                        'Selamat datang di MyPortfolio Mobile!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: actionColumnsFor(contentWidth),
                        crossAxisSpacing: _gap,
                        mainAxisSpacing: _gap,
                        children: [for (final item in items) ItemCard(item)],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Tiga InfoCard: bertumpuk di layar sempit, berjajar dengan tinggi sama
  /// di layar lebar.
  Widget _buildInfoCards({required bool compact}) {
    const cards = [
      InfoCard(title: 'NPM', content: npm),
      InfoCard(title: 'Name', content: nama),
      InfoCard(title: 'Class', content: kelas),
    ];

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          cards[0],
          const SizedBox(height: _gap),
          cards[1],
          const SizedBox(height: _gap),
          cards[2],
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: _gap),
          Expanded(child: cards[1]),
          const SizedBox(width: _gap),
          Expanded(child: cards[2]),
        ],
      ),
    );
  }
}