import 'package:flutter/material.dart';

/// Data satu tombol aksi di halaman utama.
///
/// Warna disimpan di model sehingga `ItemCard` cukup membaca [color],
/// tanpa percabangan `if-else` per nama tombol. [description] tampil sebagai
/// Tooltip dan ikut dibacakan oleh pembaca layar.
class ItemHomepage {
  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    required this.description,
  });

  final String name;
  final IconData icon;
  final Color color;
  final String description;
}