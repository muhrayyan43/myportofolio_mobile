import 'package:flutter/material.dart';

/// Kontras minimum WCAG 2.x level AA untuk teks berukuran normal.
const double kMinTextContrast = 4.5;

/// Rasio kontras WCAG 2.x antara [a] dan [b]: 1 (warna sama) sampai 21
/// (hitam di atas putih). Urutan argumen tidak berpengaruh.
double contrastRatio(Color a, Color b) {
  final luminanceA = a.computeLuminance();
  final luminanceB = b.computeLuminance();
  final lighter = luminanceA > luminanceB ? luminanceA : luminanceB;
  final darker = luminanceA > luminanceB ? luminanceB : luminanceA;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Putih atau hitam, mana yang lebih kontras di atas [background].
Color readableOn(Color background) {
  final onWhite = contrastRatio(Colors.white, background);
  final onBlack = contrastRatio(Colors.black, background);
  return onWhite >= onBlack ? Colors.white : Colors.black;
}