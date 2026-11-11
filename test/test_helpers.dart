import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

/// Menjalankan aplikasi dari root-nya, sama seperti `main()`.
Future<void> pumpApp(WidgetTester tester) async {
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