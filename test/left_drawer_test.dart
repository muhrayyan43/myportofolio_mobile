import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

import 'test_helpers.dart';

/// Semua halaman di stack navigasi, termasuk yang tertutup halaman lain.
final homePages = find.byType(MyHomePage, skipOffstage: false);
final formPages = find.byType(ProjectFormPage, skipOffstage: false);

bool isDrawerOpen(WidgetTester tester) {
  return tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen;
}

bool canGoBack(WidgetTester tester) {
  return tester.state<NavigatorState>(find.byType(Navigator)).canPop();
}

void main() {
  testWidgets('halaman utama punya tombol drawer dan isi drawer lengkap', (tester) async {
    await pumpApp(tester);
    expect(find.byType(DrawerButton), findsOneWidget);

    await openDrawer(tester);

    expect(find.text('My Portfolio'), findsOneWidget);
    expect(find.text('Explore personal projects and experiences!'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Home'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Add Project'), findsOneWidget);
  });

  testWidgets('halaman form juga punya drawer', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);
    expect(find.byType(DrawerButton), findsOneWidget);

    await openDrawer(tester);

    expect(find.byType(LeftDrawer), findsOneWidget);
  });

  testWidgets('Add Project mengganti halaman utama dengan form', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Project');

    expect(formPages, findsOneWidget);
    expect(homePages, findsNothing);
  });

  testWidgets('Home mengganti form yang dibuka lewat drawer', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Project');
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Home');

    expect(homePages, findsOneWidget);
    expect(formPages, findsNothing);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('Home dari form hasil push tidak menumpuk halaman utama', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Home');

    expect(homePages, findsOneWidget);
    expect(formPages, findsNothing);
    expect(canGoBack(tester), isFalse);
  });

  testWidgets('Home di halaman utama hanya menutup drawer', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Home');

    expect(isDrawerOpen(tester), isFalse);
    expect(homePages, findsOneWidget);
  });

  testWidgets('Add Project di halaman form tidak menghapus isian', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);
    await tester.enterText(formField(nameField), 'Portofolio');
    await tester.pump();

    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Project');

    expect(isDrawerOpen(tester), isFalse);
    expect(formFieldText(tester, nameField), 'Portofolio');
  });

  testWidgets('HP landscape: drawer tidak overflow', (tester) async {
    await pumpApp(tester, size: landscapePhone);
    await openDrawer(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('header drawer tidak overflow saat teks diperbesar', (tester) async {
    await tester.pumpWidget(
      withProviders(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Align(alignment: Alignment.centerLeft, child: LeftDrawer()),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
