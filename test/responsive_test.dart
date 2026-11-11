import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

import 'test_helpers.dart';

/// HP dalam posisi potret.
const portraitPhone = Size(360, 800);

/// HP dalam posisi landscape, layar yang paling pendek.
const landscapePhone = Size(640, 360);

/// Tablet atau jendela browser yang lebar.
const wideScreen = Size(1024, 768);

void main() {
  test('actionColumnsFor: 2 kolom di layar sempit, 4 kolom di layar lebar', () {
    expect(actionColumnsFor(kCompactBreakpoint - 1), 2);
    expect(actionColumnsFor(kCompactBreakpoint), 4);
  });

  testWidgets('HP potret: grid tombol 2 kolom', (tester) async {
    await pumpApp(tester, size: portraitPhone);

    expect(leftEdgesOf(tester, find.byType(ItemCard)), hasLength(2));
  });

  testWidgets('layar lebar: grid tombol 4 kolom', (tester) async {
    await pumpApp(tester, size: wideScreen);

    expect(leftEdgesOf(tester, find.byType(ItemCard)), hasLength(4));
  });

  testWidgets('HP potret: InfoCard bertumpuk selebar konten', (tester) async {
    await pumpApp(tester, size: portraitPhone);

    expect(leftEdgesOf(tester, find.byType(InfoCard)), hasLength(1));
  });

  testWidgets('layar lebar: InfoCard berjajar dengan tinggi yang sama', (tester) async {
    await pumpApp(tester, size: wideScreen);

    final cards = find.byType(InfoCard);
    expect(leftEdgesOf(tester, cards), hasLength(3));
    final heights = {for (var i = 0; i < 3; i++) tester.getSize(cards.at(i)).height};
    expect(heights, hasLength(1));
  });

  testWidgets('layar sangat lebar: konten tidak melebihi kMaxContentWidth', (tester) async {
    await pumpApp(tester, size: const Size(1600, 900));

    final cards = find.byType(ItemCard);
    final left = tester.getTopLeft(cards.first).dx;
    final right = tester.getTopRight(cards.last).dx;
    expect(right - left, lessThanOrEqualTo(kMaxContentWidth));
  });

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