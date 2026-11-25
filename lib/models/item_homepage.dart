import 'package:material_ui/material_ui.dart';

/// Data satu tombol aksi di halaman utama.
///
/// Warna dan halaman tujuan disimpan di model sehingga `ItemCard` cukup
/// membaca [color] dan [pageBuilder], tanpa percabangan `if-else` per nama
/// tombol. [description] tampil sebagai Tooltip dan ikut dibacakan oleh
/// pembaca layar.
class ItemHomepage {
  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    required this.description,
    this.pageBuilder,
    this.requiresLogin = false,
    this.onPressed,
  });

  final String name;
  final IconData icon;
  final Color color;
  final String description;

  /// Halaman yang dibuka dengan `Navigator.push` setelah SnackBar tampil.
  /// Jika `null`, kartu hanya menampilkan SnackBar.
  final WidgetBuilder? pageBuilder;
  final bool requiresLogin;
  final Future<void> Function(BuildContext context)? onPressed;
}
