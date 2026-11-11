import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

/// Menjalankan aplikasi dari root-nya, sama seperti `main()`.
///
/// Jika [size] diisi, layar uji diatur ke ukuran itu (dalam piksel logis)
/// dan dikembalikan ke ukuran bawaan setelah test selesai.
Future<void> pumpApp(WidgetTester tester, {Size? size}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }
  await tester.pumpWidget(const MyApp());
}

/// Menggulir ke kartu aksi bernama [name] bila perlu, menekannya, lalu
/// menunggu animasi ripple dan SnackBar selesai.
Future<void> tapAction(WidgetTester tester, String name) async {
  final card = find.widgetWithText(ItemCard, name);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await tester.pumpAndSettle();
}