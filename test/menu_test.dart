import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('halaman utama menampilkan judul dan tiga InfoCard', (tester) async {
    await pumpApp(tester);

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.byType(InfoCard), findsNWidgets(3));
    for (final title in ['NPM', 'Name', 'Class']) {
      expect(find.widgetWithText(InfoCard, title), findsOneWidget);
    }
  });

  testWidgets('ada minimal tiga tombol aksi', (tester) async {
    await pumpApp(tester);

    expect(find.byType(ItemCard), findsAtLeastNWidgets(3));
  });

  for (final item in MyHomePage().items) {
    testWidgets('menekan ${item.name} memunculkan SnackBar yang sesuai', (tester) async {
      await pumpApp(tester);
      await tapAction(tester, item.name);

      expect(find.text('Kamu telah menekan tombol ${item.name}!'), findsOneWidget);
    });
  }
}