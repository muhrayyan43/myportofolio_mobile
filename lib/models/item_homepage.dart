import 'package:flutter/material.dart';

/// Data satu tombol aksi di halaman utama.
///
/// Warna disimpan di model sehingga `ItemCard` cukup membaca [color],
/// tanpa percabangan `if-else` per nama tombol.
class ItemHomepage {
  const ItemHomepage(this.name, this.icon, this.color);

  final String name;
  final IconData icon;
  final Color color;
}