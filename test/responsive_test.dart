import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';

import 'test_helpers.dart';

/// Ukuran HP dalam posisi landscape, layar yang paling pendek.
const landscapePhone = Size(640, 360);

void main() {
  testWidgets('HP landscape: halaman bisa di-scroll tanpa overflow', (tester) async {
    await pumpApp(tester, size: landscapePhone);

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  for (final item in MyHomePage.items) {
    testWidgets('HP landscape: ${item.name} tetap bisa dijangkau dan ditekan', (tester) async {
      await pumpApp(tester, size: landscapePhone);
      await tapAction(tester, item.name);

      expect(find.text('Kamu telah menekan tombol ${item.name}!'), findsOneWidget);
    });
  }
}