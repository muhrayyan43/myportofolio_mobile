import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/utils/color_contrast.dart';

/// Kartu tombol aksi di halaman utama.
///
/// Latar kartu memakai [ItemHomepage.color], sedangkan warna teks dan ikon
/// dipilih otomatis oleh [readableOn] agar tetap terbaca.
class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    final foreground = readableOn(item.color);

    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _showPressedMessage(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: foreground, size: 30.0),
              const SizedBox(height: 6),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menutup SnackBar sebelumnya, lalu menampilkan
  /// "Kamu telah menekan tombol X!" untuk tombol ini.
  void _showPressedMessage(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
      );
  }
}