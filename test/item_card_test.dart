import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/utils/color_contrast.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

import 'test_helpers.dart';

/// Kartu aksi yang menampilkan teks [name].
Finder cardNamed(String name) => find.widgetWithText(ItemCard, name);

void main() {
  testWidgets('setiap tombol punya tooltip berisi penjelasan aksinya', (tester) async {
    await pumpApp(tester);

    for (final item in MyHomePage.items) {
      expect(find.byTooltip(item.description), findsOneWidget, reason: item.name);
    }
  });

  testWidgets('tooltip muncul saat kartu ditekan lama', (tester) async {
    await pumpApp(tester);
    final item = MyHomePage.items.first;

    await tester.longPress(cardNamed(item.name));
    await tester.pumpAndSettle();

    expect(find.text(item.description), findsOneWidget);
  });

  testWidgets('setiap kartu dibacakan sebagai satu tombol oleh pembaca layar', (tester) async {
    await pumpApp(tester);

    for (final item in MyHomePage.items) {
      final semantics = tester.widget<Semantics>(
        find.descendant(of: cardNamed(item.name), matching: find.byType(Semantics)).first,
      );
      expect(semantics.container, isTrue, reason: item.name);
      expect(semantics.properties.button, isTrue, reason: item.name);
    }
  });

  testWidgets('kartu memberi umpan balik hover, fokus, dan tekan', (tester) async {
    await pumpApp(tester);

    for (final item in MyHomePage.items) {
      final inkWell = tester.widget<InkWell>(
        find.descendant(of: cardNamed(item.name), matching: find.byType(InkWell)),
      );
      final foreground = readableOn(item.color);

      expect(inkWell.mouseCursor, SystemMouseCursors.click);
      expect(inkWell.hoverColor, foreground.withValues(alpha: 0.08));
      expect(inkWell.highlightColor, foreground.withValues(alpha: 0.12));
      expect(inkWell.focusColor, foreground.withValues(alpha: 0.16));
      expect(inkWell.splashColor, foreground.withValues(alpha: 0.24));
    }
  });
}