import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

import 'test_helpers.dart';

final savedProjectJson = {
  'id': 5,
  'title': 'Portofolio',
  'description': 'Aplikasi mobile',
  'tech_stack': 'Flutter',
  'year': DateTime.now().year,
  'url': 'https://github.com/muhrayyan43/myportofolio',
  'star_count': 0,
  'is_starred': false,
  'starred_by_names': '',
};

Future<void> tapSave(WidgetTester tester) async {
  final save = find.byType(ElevatedButton);
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  await tester.tap(save);
  await tester.pumpAndSettle();
}

Future<void> fillRequiredFields(WidgetTester tester) async {
  await tester.enterText(formField(nameField), 'Portofolio');
  await tester.enterText(formField(descriptionField), 'Aplikasi mobile');
  await tester.enterText(formField(technologiesField), 'Flutter');
  await tester.pump();
}

Future<void> openCleanForm(WidgetTester tester, {Size? size, ApiClient? apiClient}) async {
  await pumpApp(tester, size: size, apiClient: apiClient);
  await openProjectForm(tester);
  ScaffoldMessenger.of(tester.element(find.byType(ProjectFormPage))).removeCurrentSnackBar();
  await tester.pumpAndSettle();
}

bool isLoggedIn(WidgetTester tester) {
  return Provider.of<AuthState>(tester.element(find.byType(Navigator)), listen: false).isLoggedIn;
}

void main() {
  testWidgets('Tambah Proyek membuka form, lalu Back kembali ke menu', (tester) async {
    await pumpApp(tester);
    await openProjectForm(tester);

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.text('Add Project Form'), findsOneWidget);

    await pressSystemBack(tester);

    expect(find.byType(ProjectFormPage), findsNothing);
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('form berisi lima field sesuai ProjectSerializer', (tester) async {
    await openCleanForm(tester);

    expect(find.byType(TextFormField), findsNWidgets(5));
    for (final label in ['Judul Proyek', 'Deskripsi', 'Tech Stack', 'Tahun']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('URL Proyek (opsional)'), findsOneWidget);
    expect(formFieldText(tester, yearField), '${DateTime.now().year}');
  });

  testWidgets('field wajib yang kosong menampilkan pesan error', (tester) async {
    await openCleanForm(tester);
    await tapSave(tester);

    expect(find.text('Judul proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tech stack tidak boleh kosong!'), findsOneWidget);
  });

  testWidgets('tahun dan URL yang tidak valid ditolak', (tester) async {
    await openCleanForm(tester);
    await fillRequiredFields(tester);
    await tester.enterText(formField(yearField), 'abc');
    await tester.enterText(formField(linkField), 'bukan-url');
    await tapSave(tester);

    expect(find.text('Tahun harus berupa angka!'), findsOneWidget);
    expect(find.text('URL harus diawali http:// atau https://'), findsOneWidget);
  });

  testWidgets('Save mengirim POST dengan token lalu menampilkan dialog', (tester) async {
    http.Request? sent;
    await openCleanForm(
      tester,
      apiClient: fakeApiClient((request) async {
        sent = request;
        return http.Response(jsonEncode(savedProjectJson), 201);
      }),
    );
    await fillRequiredFields(tester);
    await tester.enterText(formField(linkField), 'https://github.com/muhrayyan43/myportofolio');
    await tapSave(tester);

    expect(sent!.method, 'POST');
    expect(sent!.url.path, '/api/v1/projects/');
    expect(sent!.headers['Authorization'], 'Token $testToken');
    expect(jsonDecode(sent!.body), {
      'title': 'Portofolio',
      'description': 'Aplikasi mobile',
      'tech_stack': 'Flutter',
      'year': DateTime.now().year,
      'url': 'https://github.com/muhrayyan43/myportofolio',
    });
    expect(find.text('Proyek berhasil disimpan!'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(formFieldText(tester, nameField), isEmpty);
  });

  testWidgets('401 menghapus sesi dan membuka layar login', (tester) async {
    await openCleanForm(
      tester,
      apiClient: fakeApiClient((_) async => http.Response('{"detail": "Invalid token."}', 401)),
    );
    await fillRequiredFields(tester);
    await tapSave(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Sesi login berakhir. Silakan login lagi.'), findsOneWidget);
    expect(isLoggedIn(tester), isFalse);
  });

  testWidgets('403 menampilkan pesan izin', (tester) async {
    await openCleanForm(
      tester,
      apiClient: fakeApiClient((_) async => http.Response('{"detail": "x"}', 403)),
    );
    await fillRequiredFields(tester);
    await tapSave(tester);

    expect(find.text('Akun ini tidak punya izin menambah proyek.'), findsOneWidget);
    expect(isLoggedIn(tester), isTrue);
  });

  testWidgets('tanpa koneksi menampilkan pesan', (tester) async {
    await openCleanForm(
      tester,
      apiClient: fakeApiClient((_) async => throw http.ClientException('offline')),
    );
    await fillRequiredFields(tester);
    await tapSave(tester);

    expect(find.text('Tidak dapat terhubung ke server.'), findsOneWidget);
  });

  testWidgets('HP potret: form tidak overflow', (tester) async {
    await openCleanForm(tester, size: portraitPhone);

    expect(tester.takeException(), isNull);
  });
}
