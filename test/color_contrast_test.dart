import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/utils/color_contrast.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

import 'test_helpers.dart';

void main() {
  group('contrastRatio', () {
    test('hitam di atas putih bernilai 21:1', () {
      expect(contrastRatio(Colors.black, Colors.white), closeTo(21, 0.01));
    });

    test('warna yang sama bernilai 1:1 dan urutan argumen tidak berpengaruh', () {
      expect(contrastRatio(Colors.indigo, Colors.indigo), closeTo(1, 0.0001));
      expect(
        contrastRatio(Colors.white, Colors.indigo),
        contrastRatio(Colors.indigo, Colors.white),
      );
    });
  });

  group('readableOn', () {
    test('memilih putih untuk warna gelap dan hitam untuk warna terang', () {
      expect(readableOn(Colors.blue.shade800), Colors.white);
      expect(readableOn(Colors.amber.shade700), Colors.black);
    });

    test('teks setiap tombol aksi kontras minimal 4,5:1 (WCAG AA)', () {
      for (final item in MyHomePage.items) {
        expect(
          contrastRatio(readableOn(item.color), item.color),
          greaterThanOrEqualTo(kMinTextContrast),
          reason: item.name,
        );
      }
    });
  });

  testWidgets('ikon dan teks kartu memakai warna dari readableOn', (tester) async {
    await pumpApp(tester);

    for (final item in MyHomePage.items) {
      final card = find.widgetWithText(ItemCard, item.name);
      final icon = tester.widget<Icon>(
        find.descendant(of: card, matching: find.byIcon(item.icon)),
      );
      final label = tester.widget<Text>(
        find.descendant(of: card, matching: find.text(item.name)),
      );
      expect(icon.color, readableOn(item.color));
      expect(label.style?.color, readableOn(item.color));
    }
  });
}