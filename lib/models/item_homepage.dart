import 'package:flutter/material.dart';

/// Data untuk satu tombol aksi di halaman utama: nama dan ikonnya.
///
/// Model dipisah dari widget supaya daftar tombol bisa diubah tanpa
/// menyentuh kode tampilan `ItemCard`.
class ItemHomepage {
  /// Membuat data tombol dengan nama [name] dan ikon [icon].
  ItemHomepage(this.name, this.icon);

  /// Nama tombol. Tampil di kartu dan dipakai di pesan SnackBar.
  final String name;

  /// Ikon Material yang tampil di atas [name].
  final IconData icon;
}