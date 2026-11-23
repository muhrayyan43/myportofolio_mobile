import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/thumbnail_preview.dart';

import 'experience_helpers.dart';
import 'test_helpers.dart';

const endRequiredError = 'Isi tanggal selesai atau centang "Masih berlangsung".';
const discardTitle = 'Buang isian?';

final preview = find.byType(ThumbnailPreview);
final experiencePages = find.byType(ExperienceFormPage, skipOffstage: false);
final homePages = find.byType(MyHomePage, skipOffstage: false);

/// Apakah field tanggal selesai bisa diisi.
bool endDateEnabled(WidgetTester tester) {
  final field = find.descendant(of: experienceField(endDateKey), matching: find.byType(TextField));
  return tester.widget<TextField>(field).enabled ?? true;
}

bool canGoBack(WidgetTester tester) {
  return tester.state<NavigatorState>(find.byType(Navigator)).canPop();
}

/// Menekan tombol pada dialog konfirmasi keluar.
Future<void> tapDialogButton(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(TextButton, label));
  await tester.pumpAndSettle();
}

void main() {
  group('Masih berlangsung', () {
    testWidgets('dicentang secara default dan menonaktifkan tanggal selesai', (tester) async {
      await pumpExperienceForm(tester);

      expect(tester.widget<Checkbox>(ongoingCheckbox).value, isTrue);
      expect(endDateEnabled(tester), isFalse);
    });

    testWidgets('tanpa centang, tanggal selesai wajib diisi', (tester) async {
      await pumpExperienceForm(tester);
      await fillRequiredExperience(tester);
      await tapOngoing(tester);

      expect(endDateEnabled(tester), isTrue);
      await tapSave(tester);
      expect(find.text(endRequiredError), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      await pickDate(tester, endDateKey, 15);
      expect(find.text(endRequiredError), findsNothing);

      await tapSave(tester);
      expect(find.text('Tanggal Selesai: 15 Agustus 2026'), findsOneWidget);
    });

    testWidgets('mencentang lagi mengosongkan tanggal selesai dan error-nya', (tester) async {
      await pumpExperienceForm(tester);
      await fillRequiredExperience(tester);
      await tapOngoing(tester);
      await tapSave(tester);
      expect(find.text(endRequiredError), findsOneWidget);

      await pickDate(tester, endDateKey, 15);
      await tapOngoing(tester);

      expect(experienceFieldText(tester, endDateKey), isEmpty);
      expect(endDateEnabled(tester), isFalse);
      expect(find.text(endRequiredError), findsNothing);

      await tapSave(tester);
      expect(find.text('Tanggal Selesai: Masih berlangsung'), findsOneWidget);
    });
  });

  group('Pratinjau thumbnail', () {
    testWidgets('tidak tampil saat URL kosong atau tidak valid', (tester) async {
      await pumpExperienceForm(tester);
      expect(preview, findsNothing);

      await enterExperienceText(tester, thumbnailKey, 'github.com/logo.png');
      expect(preview, findsNothing);

      await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
      expect(preview, findsOneWidget);

      await enterExperienceText(tester, thumbnailKey, '');
      expect(preview, findsNothing);
    });

    testWidgets('berukuran tetap dan menampilkan pesan saat gambar gagal dimuat', (tester) async {
      await pumpExperienceForm(tester);
      // Di flutter test, semua permintaan HTTP dijawab status 400.
      await enterExperienceText(tester, thumbnailKey, 'https://example.com/logo.png');
      await tester.pumpAndSettle();

      expect(tester.getSize(preview), const Size(120, 120));
      expect(find.text('Gambar tidak bisa dimuat'), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('pesan gagal dimuat tidak overflow saat teks diperbesar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(3)),
            child: Center(child: ThumbnailPreview(url: 'https://example.com/logo.png')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gambar tidak bisa dimuat'), findsOneWidget);
      expect(tester.getSize(preview), const Size(120, 120));
      expect(tester.takeException(), isNull);
    });
  });

  group('Penghitung karakter', () {
    testWidgets('Judul / Posisi menampilkan jumlah karakter', (tester) async {
      await pumpExperienceForm(tester);
      expect(find.text('0/255'), findsOneWidget);

      await enterExperienceText(tester, titleKey, 'Asisten Dosen');
      expect(find.text('13/255'), findsOneWidget);
    });

    testWidgets('teks hasil paste tidak dipotong dan tetap ditolak validator', (tester) async {
      await pumpExperienceForm(tester);
      await fillRequiredExperience(tester);
      await enterExperienceText(tester, titleKey, 'a' * 300);

      expect(experienceFieldText(tester, titleKey), hasLength(300));
      expect(find.text('300/255'), findsOneWidget);

      await tapSave(tester);
      expect(find.text('Judul / Posisi maksimal 255 karakter.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('Konfirmasi keluar', () {
    testWidgets('form kosong ditinggalkan tanpa dialog', (tester) async {
      await pushExperienceForm(tester);
      await pressSystemBack(tester);

      expect(find.text(discardTitle), findsNothing);
      expect(experiencePages, findsNothing);
      expect(homePages, findsOneWidget);
    });

    testWidgets('tombol kembali perangkat: Batal tetap di form beserta isiannya', (tester) async {
      await pushExperienceForm(tester);
      await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
      await pressSystemBack(tester);

      expect(find.text(discardTitle), findsOneWidget);
      await tapDialogButton(tester, 'Batal');

      expect(find.byType(ExperienceFormPage), findsOneWidget);
      expect(experienceFieldText(tester, titleKey), 'Asisten Dosen PBP');
    });

    testWidgets('tombol kembali perangkat: Buang kembali ke halaman utama', (tester) async {
      await pushExperienceForm(tester);
      await selectCategory(tester, 'Research');
      await pressSystemBack(tester);
      await tapDialogButton(tester, 'Buang');

      expect(experiencePages, findsNothing);
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(canGoBack(tester), isFalse);
    });

    testWidgets('tombol kembali di AppBar juga meminta konfirmasi', (tester) async {
      await pushExperienceForm(tester);
      expect(find.byType(BackButton), findsOneWidget);
      await pickDate(tester, startDateKey, 5);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text(discardTitle), findsOneWidget);

      await tapDialogButton(tester, 'Buang');
      expect(experiencePages, findsNothing);
    });

    testWidgets('tombol kembali perangkat menutup drawer tanpa dialog', (tester) async {
      await pushExperienceForm(tester);
      await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
      await openDrawer(tester);
      await pressSystemBack(tester);

      expect(tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen, isFalse);
      expect(find.text(discardTitle), findsNothing);
      expect(find.byType(ExperienceFormPage), findsOneWidget);
    });

    testWidgets('navigasi drawer dari form yang terisi meminta konfirmasi', (tester) async {
      await pushExperienceForm(tester);
      await enterExperienceText(tester, descriptionKey, 'Membantu tutorial Flutter');
      await openDrawer(tester);
      await tapDrawerItem(tester, 'Home');

      expect(find.text(discardTitle), findsOneWidget);
      await tapDialogButton(tester, 'Batal');
      expect(find.byType(ExperienceFormPage), findsOneWidget);
      expect(experienceFieldText(tester, descriptionKey), 'Membantu tutorial Flutter');

      await openDrawer(tester);
      await tapDrawerItem(tester, 'Add Project');
      expect(find.text(discardTitle), findsOneWidget);
      await tapDialogButton(tester, 'Buang');

      expect(experiencePages, findsNothing);
      expect(find.text('Add Project Form'), findsOneWidget);
    });

    testWidgets('Home dari drawer setelah Buang tidak menumpuk halaman utama', (tester) async {
      await pushExperienceForm(tester);
      await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
      await openDrawer(tester);
      await tapDrawerItem(tester, 'Home');
      await tapDialogButton(tester, 'Buang');

      expect(homePages, findsOneWidget);
      expect(experiencePages, findsNothing);
      expect(canGoBack(tester), isFalse);
    });

    testWidgets('Add Experience di form yang terisi tidak menampilkan dialog', (tester) async {
      await pushExperienceForm(tester);
      await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');
      await openDrawer(tester);
      await tapDrawerItem(tester, 'Add Experience');

      expect(find.text(discardTitle), findsNothing);
      expect(experienceFieldText(tester, titleKey), 'Asisten Dosen PBP');
    });

    testWidgets('form yang baru di-reset ditinggalkan tanpa dialog', (tester) async {
      await pushExperienceForm(tester);
      await fillRequiredExperience(tester);
      await tapSave(tester);
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      await pressSystemBack(tester);

      expect(find.text(discardTitle), findsNothing);
      expect(experiencePages, findsNothing);
    });
  });
}
