import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';

/// Kartu tombol aksi di halaman utama.
///
/// Saat ditekan, kartu menampilkan SnackBar
/// "Kamu telah menekan tombol X!" (X = nama tombol).
class ItemCard extends StatelessWidget {
  /// Membuat kartu untuk [item].
  const ItemCard(this.item, {super.key});

  /// Data tombol yang ditampilkan kartu ini.
  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () {
          // Menampilkan SnackBar dengan pesan interaktif.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}