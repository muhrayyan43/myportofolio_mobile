import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

import 'test_helpers.dart';

final drawerLogin = find.descendant(of: find.byType(Drawer), matching: find.text('Login'));
final drawerLogout = find.descendant(of: find.byType(Drawer), matching: find.text('Logout'));
final loginButton = find.widgetWithText(FilledButton, 'Login');

AuthState authState(WidgetTester tester) {
  return Provider.of<AuthState>(tester.element(find.byType(Navigator)), listen: false);
}

Future<void> fillLogin(WidgetTester tester, String username, String password) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Username'), username);
  await tester.enterText(find.widgetWithText(TextFormField, 'Password'), password);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('tanpa login, Tambah Proyek membuka layar login', (tester) async {
    await pumpApp(tester, token: null);
    await tapAction(tester, 'Tambah Proyek');

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
  });

  testWidgets('login berhasil langsung melanjutkan ke form proyek', (tester) async {
    Map<String, dynamic>? sentBody;
    await pumpApp(
      tester,
      token: null,
      apiClient: fakeApiClient((request) async {
        sentBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'token': 'abc123'}), 200);
      }),
    );
    await tapAction(tester, 'Tambah Proyek');
    await fillLogin(tester, 'owner', 'rahasia');

    expect(sentBody, {'username': 'owner', 'password': 'rahasia'});
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(authState(tester).token, 'abc123');
  });

  testWidgets('login gagal menampilkan pesan dan tetap di layar login', (tester) async {
    await pumpApp(
      tester,
      token: null,
      apiClient: fakeApiClient((_) async => http.Response('{"non_field_errors": ["x"]}', 400)),
    );
    await tapAction(tester, 'Tambah Proyek');
    await fillLogin(tester, 'owner', 'salah');

    expect(find.text('Username atau password salah.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(authState(tester).isLoggedIn, isFalse);
  });

  testWidgets('field login kosong ditolak validator', (tester) async {
    await pumpApp(tester, token: null);
    await tapAction(tester, 'Tambah Proyek');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Username tidak boleh kosong.'), findsOneWidget);
    expect(find.text('Password tidak boleh kosong.'), findsOneWidget);
  });

  testWidgets('drawer menampilkan Login saat belum login', (tester) async {
    await pumpApp(tester, token: null);
    await openDrawer(tester);

    expect(drawerLogin, findsOneWidget);
    expect(drawerLogout, findsNothing);
  });

  testWidgets('Logout di drawer menghapus token di server dan di aplikasi', (tester) async {
    final requests = <http.Request>[];
    await pumpApp(
      tester,
      apiClient: fakeApiClient((request) async {
        requests.add(request);
        return http.Response('', 204);
      }),
    );
    await openDrawer(tester);
    await tester.tap(drawerLogout);
    await tester.pumpAndSettle();

    expect(requests.single.url.path, '/api/v1/auth/logout/');
    expect(requests.single.headers['Authorization'], 'Token $testToken');
    expect(authState(tester).isLoggedIn, isFalse);
    expect(find.text('Kamu sudah logout.'), findsOneWidget);
  });

  testWidgets('kartu Logout juga mengakhiri sesi', (tester) async {
    final paths = <String>[];
    await pumpApp(
      tester,
      apiClient: fakeApiClient((request) async {
        paths.add(request.url.path);
        return http.Response('', 204);
      }),
    );
    await tapAction(tester, 'Logout');

    expect(paths, ['/api/v1/auth/logout/']);
    expect(authState(tester).isLoggedIn, isFalse);
  });

  testWidgets('Add Project di drawer tanpa login membuka layar login', (tester) async {
    await pumpApp(tester, token: null);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Add Project');

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
