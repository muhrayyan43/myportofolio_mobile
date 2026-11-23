import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

import 'experience_helpers.dart';
import 'test_helpers.dart';

const titleError = 'Posisi tidak boleh kosong atau hanya berisi spasi.';
const descriptionError = 'Deskripsi tidak boleh kosong atau hanya berisi spasi.';
const startDateError = 'Tanggal mulai wajib diisi.';
const urlError = 'Masukkan URL yang valid, diawali http:// atau https://.';
const endBeforeStartError = 'Tanggal selesai tidak boleh sebelum tanggal mulai.';

void main() {
  testWidgets('form berisi semua field model Experience', (tester) async {
    await pumpExperienceForm(tester);

    expect(find.text('Add Experience Form'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    for (final label in ['Judul / Posisi', 'Deskripsi', 'Kategori', 'Thumbnail URL']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(find.text('Tanggal Mulai'), findsOneWidget);
    expect(find.text('Tanggal Selesai'), findsOneWidget);
    expect(tester.state<FormFieldState<String>>(categoryDropdown).value, 'full-time');
    expect(find.text('Full-Time'), findsOneWidget);
  });

  testWidgets('dropdown berisi enam kategori dari model Django', (tester) async {
    await pumpExperienceForm(tester);
    await tester.tap(categoryDropdown);
    await tester.pumpAndSettle();

    for (final label in ['Internship', 'Research', 'Volunteer', 'Part-Time', 'Freelance']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // Full-Time tampil di field dan di menu.
    expect(find.text('Full-Time'), findsNWidgets(2));
  });

  testWidgets('field wajib yang kosong menampilkan pesan error', (tester) async {
    await pumpExperienceForm(tester);
    await tapSave(tester);

    expect(find.text(titleError), findsOneWidget);
    expect(find.text(descriptionError), findsOneWidget);
    expect(find.text(startDateError), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('field wajib yang hanya berisi spasi ditolak', (tester) async {
    await pumpExperienceForm(tester);
    await enterExperienceText(tester, titleKey, '   ');
    await enterExperienceText(tester, descriptionKey, ' \n ');
    await tapSave(tester);

    expect(find.text(titleError), findsOneWidget);
    expect(find.text(descriptionError), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('isian yang hanya berisi tag HTML ditolak seperti strip_tags', (tester) async {
    await pumpExperienceForm(tester);
    await enterExperienceText(tester, titleKey, '<b></b>');
    await tapSave(tester);

    expect(find.text('Posisi tidak boleh hanya berisi tag HTML.'), findsOneWidget);
  });

  testWidgets('pesan error hilang setelah field diperbaiki', (tester) async {
    await pumpExperienceForm(tester);
    await tapSave(tester);
    expect(find.text(titleError), findsOneWidget);
    expect(find.text(startDateError), findsOneWidget);

    await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
    await pickDate(tester, startDateKey, 5);

    expect(find.text(titleError), findsNothing);
    expect(find.text(startDateError), findsNothing);
  });

  testWidgets('judul lebih dari 255 karakter ditolak', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);
    await enterExperienceText(tester, titleKey, 'a' * 256);
    await tapSave(tester);

    expect(find.text('Judul / Posisi maksimal 255 karakter.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('URL thumbnail yang tidak valid ditolak', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);

    for (final url in ['github.com/logo.png', 'ftp://example.com/logo.png', 'https://']) {
      await enterExperienceText(tester, thumbnailKey, url);
      await tapSave(tester);

      expect(find.text(urlError), findsOneWidget, reason: url);
      expect(find.byType(AlertDialog), findsNothing, reason: url);
    }
  });

  testWidgets('tanggal selesai sebelum tanggal mulai ditolak dan divalidasi ulang', (tester) async {
    await pumpExperienceForm(tester);
    await tapOngoing(tester);
    await pickDate(tester, endDateKey, 10);
    await pickDate(tester, startDateKey, 15);

    // Mengubah tanggal mulai langsung memvalidasi ulang tanggal selesai.
    expect(find.text(endBeforeStartError), findsOneWidget);

    await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
    await enterExperienceText(tester, descriptionKey, 'Membantu tutorial Flutter');
    await tapSave(tester);
    expect(find.text(endBeforeStartError), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await pickDate(tester, startDateKey, 5);
    expect(find.text(endBeforeStartError), findsNothing);
  });

  testWidgets('thumbnail dan tanggal selesai boleh kosong', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);
    await tapSave(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Kategori: Full-Time'), findsOneWidget);
    expect(find.text('Thumbnail URL: -'), findsOneWidget);
    expect(find.text('Tanggal Selesai: Masih berlangsung'), findsOneWidget);
  });

  testWidgets('dialog menampilkan semua isian form', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);
    await selectCategory(tester, 'Research');
    await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
    await tapOngoing(tester);
    await pickDate(tester, endDateKey, 15);
    await tapSave(tester);

    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul / Posisi: Asisten Dosen PBP'), findsOneWidget);
    expect(find.text('Deskripsi: Membantu tutorial Flutter'), findsOneWidget);
    expect(find.text('Kategori: Research'), findsOneWidget);
    expect(find.text('Thumbnail URL: https://example.com/logo.png'), findsOneWidget);
    expect(find.text('Tanggal Mulai: 5 Agustus 2026'), findsOneWidget);
    expect(find.text('Tanggal Selesai: 15 Agustus 2026'), findsOneWidget);
  });

  testWidgets('dialog menampilkan isian yang sudah dibersihkan', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);
    await enterExperienceText(tester, titleKey, '  <b>Asisten Dosen</b>  ');
    await tapSave(tester);

    expect(find.text('Judul / Posisi: Asisten Dosen'), findsOneWidget);
  });

  testWidgets('OK menutup dialog, mengosongkan form, dan mengembalikan kategori', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);
    await selectCategory(tester, 'Volunteer');
    await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
    await tapOngoing(tester);
    await pickDate(tester, endDateKey, 15);
    await tapSave(tester);
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    for (final key in [titleKey, descriptionKey, thumbnailKey, startDateKey, endDateKey]) {
      expect(experienceFieldText(tester, key), isEmpty);
    }
    expect(tester.state<FormFieldState<String>>(categoryDropdown).value, 'full-time');
    expect(tester.widget<Checkbox>(ongoingCheckbox).value, isTrue);

    // Nilai tersimpan ikut dikosongkan, jadi field wajib kembali ditolak.
    await tapSave(tester);
    expect(find.text(titleError), findsOneWidget);
    expect(find.text(startDateError), findsOneWidget);
  });

  testWidgets('isian lama tidak muncul lagi pada dialog berikutnya', (tester) async {
    await pumpExperienceForm(tester);
    await fillRequiredExperience(tester);
    await selectCategory(tester, 'Freelance');
    await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
    await tapOngoing(tester);
    await pickDate(tester, endDateKey, 15);
    await tapSave(tester);
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    await fillRequiredExperience(tester);
    await tapSave(tester);

    expect(find.text('Kategori: Full-Time'), findsOneWidget);
    expect(find.text('Thumbnail URL: -'), findsOneWidget);
    expect(find.text('Tanggal Selesai: Masih berlangsung'), findsOneWidget);
  });

  testWidgets('HP potret: form tidak overflow dan tombol Simpan terjangkau', (tester) async {
    await pumpExperienceForm(tester, size: portraitPhone);
    await tapSave(tester);
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(saveButton.hitTestable(), findsOneWidget);
  });

  testWidgets('layar lebar: lebar form tidak melebihi kMaxContentWidth', (tester) async {
    await pumpExperienceForm(tester, size: wideScreen);

    expect(tester.getSize(experienceField(titleKey)).width, lessThanOrEqualTo(kMaxContentWidth));
    expect(tester.takeException(), isNull);
  });
}
