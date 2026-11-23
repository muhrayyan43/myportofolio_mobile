import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'experience_helpers.dart';
import 'test_helpers.dart';

/// Semua halaman di stack navigasi, termasuk yang tertutup halaman lain.
final homePages = find.byType(MyHomePage, skipOffstage: false);
final projectPages = find.byType(ProjectFormPage, skipOffstage: false);
final experiencePages = find.byType(ExperienceFormPage, skipOffstage: false);

bool canGoBack(WidgetTester tester) {
  return tester.state<NavigatorState>(find.byType(Navigator)).canPop();
}

/// Membuka form Experience lewat kartu "Tambah Experience".
Future<void> openExperienceFromCard(WidgetTester tester) => tapAction(tester, 'Tambah Experience');

/// Warna latar AppBar yang benar-benar digambar pada halaman yang tampil.
Color? appBarColor(WidgetTester tester) {
  final material = find.descendant(of: find.byType(AppBar), matching: find.byType(Material));
  return tester.widget<Material>(material.first).color;
}

/// Warna `primary` dari tema aplikasi.
Color primaryColor(WidgetTester tester) {
  return Theme.of(tester.element(find.byType(Scaffold))).colorScheme.primary;
}

void main() {
  testWidgets('kartu Tambah Experience membuka form setelah SnackBar', (tester) async {
    await pumpApp(tester);
    await openExperienceFromCard(tester);

    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(find.text('Kamu telah menekan tombol Tambah Experience!'), findsOneWidget);
    expect(canGoBack(tester), isTrue);
  });

  testWidgets('tombol kembali perangkat dari form membawa ke halaman utama', (tester) async {
    await pumpApp(tester);
    await openExperienceFromCard(tester);
    await pressSystemBack(tester);

    expect(experiencePages, findsNothing);
    expect(homePages, findsOneWidget);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('kartu Tambah Proyek tetap membuka form proyek', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(experiencePages, findsNothing);
  });

  testWidgets('kartu tanpa halaman tujuan hanya menampilkan SnackBar', (tester) async {
    await pumpApp(tester);
    await tapAction(tester, 'Lihat Experience');

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('drawer berisi Home, Add Project, lalu Add Experience', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(titles, ['Home', 'Add Project', 'Add Experience']);
  });

  testWidgets('Add Experience dari halaman utama membuka form Experience', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Experience');

    expect(experiencePages, findsOneWidget);
    expect(homePages, findsNothing);
  });

  testWidgets('Add Experience dari form proyek mengganti form proyek', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Experience');

    expect(experiencePages, findsOneWidget);
    expect(projectPages, findsNothing);
    expect(homePages, findsOneWidget);

    await pressSystemBack(tester);
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('Add Project dari form Experience tetap berjalan', (tester) async {
    await pumpApp(tester);
    await openExperienceFromCard(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Project');

    expect(projectPages, findsOneWidget);
    expect(experiencePages, findsNothing);
  });

  testWidgets('Home dari form Experience hasil push tidak menumpuk halaman utama', (tester) async {
    await pumpApp(tester);
    await openExperienceFromCard(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Home');

    expect(homePages, findsOneWidget);
    expect(experiencePages, findsNothing);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('Home dari form Experience yang dibuka lewat drawer', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Experience');
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Home');

    expect(homePages, findsOneWidget);
    expect(experiencePages, findsNothing);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('Add Experience di form Experience hanya menutup drawer', (tester) async {
    await pumpApp(tester);
    await openExperienceFromCard(tester);
    await enterExperienceText(tester, titleKey, 'Asisten Dosen PBP');

    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Experience');

    expect(tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen, isFalse);
    expect(experiencePages, findsOneWidget);
    expect(experienceFieldText(tester, titleKey), 'Asisten Dosen PBP');
  });

  testWidgets('AppBar dan header drawer memakai warna primary dari tema', (tester) async {
    await pumpApp(tester);
    final primary = primaryColor(tester);
    expect(appBarColor(tester), primary);

    await openDrawer(tester);
    final header = tester.widget<DrawerHeader>(find.byType(DrawerHeader));
    expect((header.decoration! as BoxDecoration).color, primary);
    await tapDrawerItem(tester, 'Add Project');
    expect(appBarColor(tester), primary);

    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Experience');
    expect(appBarColor(tester), primary);
  });
}
