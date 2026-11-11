import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/utils/color_contrast.dart';

/// Kartu tombol aksi di halaman utama.
///
/// Latar kartu memakai [ItemHomepage.color], sedangkan warna teks, ikon, dan
/// efek hover/fokus/tekan diturunkan dari [readableOn] agar tetap terbaca.
/// [Semantics] membuat pembaca layar membacakan kartu sebagai satu tombol,
/// dan [Tooltip] menjelaskan aksinya saat kartu di-hover atau ditekan lama.
class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    final foreground = readableOn(item.color);

    return Semantics(
      container: true,
      button: true,
      child: Tooltip(
        message: item.description,
        child: Material(
          color: item.color,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showPressedMessage(context),
            mouseCursor: SystemMouseCursors.click,
            hoverColor: foreground.withValues(alpha: 0.08),
            highlightColor: foreground.withValues(alpha: 0.12),
            focusColor: foreground.withValues(alpha: 0.16),
            splashColor: foreground.withValues(alpha: 0.24),
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
                    style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
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