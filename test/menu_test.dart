import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

import 'test_helpers.dart';

const expectedActions = ['Lihat Experience', 'Tambah Experience', 'Logout'];

void main() {
  testWidgets('InfoCard menampilkan NPM, nama, dan kelas saya', (tester) async {
    await pumpApp(tester);

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.byType(InfoCard), findsNWidgets(3));

    const identitas = {
      'NPM': '2406496372',
      'Name': 'Muhammad Rayyan Basalamah',
      'Class': 'PBP B',
    };
    for (final entry in identitas.entries) {
      final card = find.widgetWithText(InfoCard, entry.key);
      expect(card, findsOneWidget);
      expect(find.descendant(of: card, matching: find.text(entry.value)), findsOneWidget);
    }
  });

  testWidgets('tombol aksi sesuai bagian portofolio saya', (tester) async {
    await pumpApp(tester);

    expect(MyHomePage.items.map((item) => item.name).toList(), expectedActions);
    expect(find.byType(ItemCard), findsNWidgets(expectedActions.length));
  });

  for (final name in expectedActions) {
    testWidgets('menekan $name memunculkan SnackBar yang sesuai', (tester) async {
      await pumpApp(tester);
      await tapAction(tester, name);

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    });
  }

  testWidgets('setiap tombol memakai warna latar yang berbeda', (tester) async {
    await pumpApp(tester);

    final backgrounds = tester
        .widgetList<Material>(
          find.descendant(of: find.byType(ItemCard), matching: find.byType(Material)),
        )
        .map((material) => material.color)
        .toSet();
    expect(backgrounds, hasLength(MyHomePage.items.length));
  });
}