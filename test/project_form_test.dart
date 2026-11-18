import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'test_helpers.dart';

const nameError = 'Nama proyek tidak boleh kosong!';
const descriptionError = 'Deskripsi proyek tidak boleh kosong!';

final categoryField = find.byType(DropdownButtonFormField<String>);

/// Menekan tombol Save lalu menunggu validasi atau pop-up selesai tampil.
Future<void> tapSave(WidgetTester tester) async {
  final save = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  await tester.tap(save);
  await tester.pumpAndSettle();
}

/// Mengisi hanya field yang wajib diisi.
Future<void> fillRequiredFields(WidgetTester tester) async {
  await tester.enterText(formField(nameField), 'Portofolio');
  await tester.enterText(formField(descriptionField), 'Aplikasi mobile');
  await tester.pump();
}

/// Membuka form dan menutup SnackBar agar tidak menghalangi tombol Save.
Future<void> openCleanForm(WidgetTester tester, {Size? size}) async {
  await pumpApp(tester, size: size);
  await openProjectForm(tester);
  ScaffoldMessenger.of(tester.element(find.byType(ProjectFormPage))).removeCurrentSnackBar();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Tambah Proyek membuka form, lalu Back kembali ke menu', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.text('Add Project Form'), findsOneWidget);
    expect(find.text('Kamu telah menekan tombol Tambah Proyek!'), findsOneWidget);

    await pressSystemBack(tester);

    expect(find.byType(ProjectFormPage), findsNothing);
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('form berisi empat field teks dan dropdown kategori', (tester) async {
    await openCleanForm(tester);

    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(categoryField, findsOneWidget);
    expect(find.text('Kategori Proyek'), findsOneWidget);
  });

  testWidgets('field wajib yang kosong menampilkan pesan error', (tester) async {
    await openCleanForm(tester);
    await tapSave(tester);

    expect(find.text(nameError), findsOneWidget);
    expect(find.text(descriptionError), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('field wajib yang hanya berisi spasi ditolak', (tester) async {
    await openCleanForm(tester);
    await tester.enterText(formField(nameField), '   ');
    await tester.enterText(formField(descriptionField), '   ');
    await tester.pump();
    await tapSave(tester);

    expect(find.text(nameError), findsOneWidget);
    expect(find.text(descriptionError), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('teknologi dan tautan boleh kosong', (tester) async {
    await openCleanForm(tester);
    await fillRequiredFields(tester);
    await tapSave(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
  });

  testWidgets('pop-up menampilkan semua isian form', (tester) async {
    await openCleanForm(tester);
    await fillRequiredFields(tester);
    await tester.enterText(formField(technologiesField), 'Flutter, Django');
    await tester.enterText(formField(linkField), 'https://example.com');
    await tester.pump();
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Data Science').last);
    await tester.pumpAndSettle();
    await tapSave(tester);

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Portofolio'), findsOneWidget);
    expect(find.text('Deskripsi: Aplikasi mobile'), findsOneWidget);
    expect(find.text('Kategori: Data Science'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Django'), findsOneWidget);
    expect(find.text('Tautan: https://example.com'), findsOneWidget);
  });

  testWidgets('OK menutup pop-up dan mengosongkan form', (tester) async {
    await openCleanForm(tester);
    await fillRequiredFields(tester);
    await tester.enterText(formField(technologiesField), 'Flutter');
    await tester.enterText(formField(linkField), 'https://example.com');
    await tester.pump();
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();
    await tapSave(tester);
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    for (final field in [nameField, descriptionField, technologiesField, linkField]) {
      expect(formFieldText(tester, field), isEmpty);
    }
    expect(tester.state<FormFieldState<String>>(categoryField).value, 'Web Development');
  });

  testWidgets('isian lama tidak muncul lagi pada pop-up berikutnya', (tester) async {
    await openCleanForm(tester);
    await fillRequiredFields(tester);
    await tester.enterText(formField(technologiesField), 'Flutter');
    await tester.enterText(formField(linkField), 'https://example.com');
    await tester.pump();
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other').last);
    await tester.pumpAndSettle();
    await tapSave(tester);
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    await fillRequiredFields(tester);
    await tapSave(tester);

    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
  });

  testWidgets('HP landscape: form dan pop-up tidak overflow', (tester) async {
    await openCleanForm(tester, size: landscapePhone);
    expect(tester.takeException(), isNull);

    await fillRequiredFields(tester);
    await tapSave(tester);

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('HP potret: form tidak overflow', (tester) async {
    await openCleanForm(tester, size: portraitPhone);

    expect(tester.takeException(), isNull);
  });

  testWidgets('layar lebar: lebar form tidak melebihi kMaxContentWidth', (tester) async {
    await openCleanForm(tester, size: wideScreen);

    expect(tester.getSize(formField(nameField)).width, lessThanOrEqualTo(kMaxContentWidth));
    expect(tester.takeException(), isNull);
  });
}
