import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

import 'experience_helpers.dart';
import 'test_helpers.dart';

/// HP potret yang pendek.
const shortPortraitPhone = Size(360, 640);

/// Menampilkan semua bagian form sekaligus: pesan error setelah Simpan,
/// field tanggal selesai yang aktif, dan pratinjau thumbnail.
Future<void> showEveryPart(WidgetTester tester) async {
  await tapSave(tester);
  await tapOngoing(tester);
  await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
  await tester.pumpAndSettle();
}

/// Memastikan tombol Simpan bisa digulir ke layar lalu ditekan.
Future<void> expectSaveReachable(WidgetTester tester) async {
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  expect(saveButton.hitTestable(), findsOneWidget);
}

void main() {
  final sizes = {
    'HP potret 360x640': shortPortraitPhone,
    'HP landscape': landscapePhone,
    'layar lebar': wideScreen,
  };

  for (final entry in sizes.entries) {
    testWidgets('${entry.key}: form tidak overflow dan Simpan terjangkau', (tester) async {
      await pumpExperienceForm(tester, size: entry.value);
      expect(tester.takeException(), isNull);

      await showEveryPart(tester);
      expect(tester.takeException(), isNull);
      await expectSaveReachable(tester);
    });
  }

  testWidgets('layar lebar: lebar form tidak melebihi kMaxContentWidth', (tester) async {
    await pumpExperienceForm(tester, size: wideScreen);

    expect(tester.getSize(saveButton).width, lessThanOrEqualTo(kMaxContentWidth));
  });

  testWidgets('keyboard tampil: form tetap bisa digulir sampai tombol Simpan', (tester) async {
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await pumpExperienceForm(tester, size: shortPortraitPhone);
    expect(tester.takeException(), isNull);

    await showEveryPart(tester);
    expect(tester.takeException(), isNull);
    await expectSaveReachable(tester);
  });

  testWidgets('teks diperbesar: form tidak overflow dan Simpan terjangkau', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpExperienceForm(tester, size: shortPortraitPhone);
    expect(tester.takeException(), isNull);

    await showEveryPart(tester);
    expect(tester.takeException(), isNull);
    await expectSaveReachable(tester);
  });

  testWidgets('dialog ringkasan yang panjang tidak overflow di HP landscape', (tester) async {
    // Tanggal dipilih di layar bawaan, lalu layar diubah ke HP landscape.
    await pumpExperienceForm(tester);
    await enterExperienceText(tester, titleKey, 'Software Engineer Intern @ Company');
    await enterExperienceText(tester, descriptionKey, 'Membuat fitur aplikasi. ' * 40);
    await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
    await pickDate(tester, startDateKey, 5);
    useScreenSize(tester, landscapePhone);
    await tester.pumpAndSettle();
    await tapSave(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
