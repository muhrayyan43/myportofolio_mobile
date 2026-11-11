import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

import 'test_helpers.dart';

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

  testWidgets('ada minimal tiga tombol aksi', (tester) async {
    await pumpApp(tester);

    expect(find.byType(ItemCard), findsAtLeastNWidgets(3));
  });

  for (final item in MyHomePage.items) {
    testWidgets('menekan ${item.name} memunculkan SnackBar yang sesuai', (tester) async {
      await pumpApp(tester);
      await tapAction(tester, item.name);

      expect(find.text('Kamu telah menekan tombol ${item.name}!'), findsOneWidget);
    });
  }
}