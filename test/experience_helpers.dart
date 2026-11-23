import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

/// Tanggal "hari ini" palsu, agar test tidak bergantung pada tanggal nyata.
final DateTime fakeToday = DateTime(2026, 8, 20);

const titleKey = ExperienceFormPage.titleKey;
const descriptionKey = ExperienceFormPage.descriptionKey;
const thumbnailKey = ExperienceFormPage.thumbnailKey;
const startDateKey = ExperienceFormPage.startDateKey;
const endDateKey = ExperienceFormPage.endDateKey;

/// Dropdown kategori pada form Experience.
final Finder categoryDropdown = find.byType(DropdownButtonFormField<String>);

/// Tombol Simpan pada form Experience.
final Finder saveButton = find.widgetWithText(FilledButton, 'Simpan');

/// Mengatur ukuran layar uji ke [size] piksel logis sampai test selesai.
void useScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Membuka form Experience sebagai halaman pertama dengan [fakeToday] dan
/// tema aplikasi.
Future<void> pumpExperienceForm(WidgetTester tester, {Size? size}) async {
  if (size != null) useScreenSize(tester, size);
  await tester.pumpWidget(
    MaterialApp(theme: buildAppTheme(), home: ExperienceFormPage(today: fakeToday)),
  );
}

/// Field teks di dalam pembungkus ber-[key] pada form Experience.
Finder experienceField(Key key) {
  return find.descendant(of: find.byKey(key), matching: find.byType(TextFormField));
}

/// Isi field teks ber-[key] pada form Experience.
String experienceFieldText(WidgetTester tester, Key key) {
  final editable = find.descendant(of: experienceField(key), matching: find.byType(EditableText));
  return tester.widget<EditableText>(editable).controller.text;
}

/// Mengetik [text] ke field ber-[key].
Future<void> enterExperienceText(WidgetTester tester, Key key, String text) async {
  await tester.ensureVisible(experienceField(key));
  await tester.enterText(experienceField(key), text);
  await tester.pump();
}

/// Membuka pemilih tanggal pada field ber-[key], lalu memilih tanggal [day]
/// pada bulan yang sedang ditampilkan dan menekan OK.
Future<void> pickDate(WidgetTester tester, Key key, int day) async {
  final field = experienceField(key);
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('$day'));
  await tester.pump();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

/// Memilih kategori berlabel [label] dari dropdown.
Future<void> selectCategory(WidgetTester tester, String label) async {
  await tester.ensureVisible(categoryDropdown);
  await tester.pumpAndSettle();
  await tester.tap(categoryDropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

/// Menekan tombol Simpan lalu menunggu validasi atau dialog selesai tampil.
Future<void> tapSave(WidgetTester tester) async {
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

/// Mengisi hanya field yang wajib: judul, deskripsi, dan tanggal mulai
/// 5 Agustus 2026.
Future<void> fillRequiredExperience(WidgetTester tester) async {
  await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
  await enterExperienceText(tester, descriptionKey, 'Membantu tutorial Flutter');
  await pickDate(tester, startDateKey, 5);
}
