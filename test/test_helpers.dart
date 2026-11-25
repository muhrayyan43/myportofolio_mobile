import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:provider/provider.dart';

/// HP dalam posisi potret.
const portraitPhone = Size(360, 800);

/// HP dalam posisi landscape, layar yang paling pendek.
const landscapePhone = Size(640, 360);

/// Tablet atau jendela browser yang lebar.
const wideScreen = Size(1024, 768);

/// Urutan field teks pada halaman form proyek.
const nameField = 0;
const descriptionField = 1;
const technologiesField = 2;
const linkField = 3;

/// ApiClient palsu tanpa jaringan; bawaannya setiap request mendapat `[]`.
ApiClient fakeApiClient([MockClientHandler? handler]) {
  return ApiClient(
    baseUrl: 'http://api.test',
    client: MockClient(handler ?? (_) async => http.Response('[]', 200)),
  );
}

/// Menjalankan aplikasi dari root-nya, sama seperti `main()`.
///
/// Jika [size] diisi, layar uji diatur ke ukuran itu (dalam piksel logis)
/// dan dikembalikan ke ukuran bawaan setelah test selesai.
Future<void> pumpApp(WidgetTester tester, {Size? size, ApiClient? apiClient}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }
  await tester.pumpWidget(MyApp(apiClient: apiClient ?? fakeApiClient()));
}

Future<void> pumpScreen(WidgetTester tester, Widget home, {ApiClient? apiClient}) async {
  await tester.pumpWidget(
    Provider<ApiClient>.value(
      value: apiClient ?? fakeApiClient(),
      child: MaterialApp(theme: buildAppTheme(), home: home),
    ),
  );
}

/// Menggulir ke kartu aksi bernama [name] bila perlu, menekannya, lalu
/// menunggu animasi ripple dan SnackBar selesai.
Future<void> tapAction(WidgetTester tester, String name) async {
  final card = find.widgetWithText(ItemCard, name);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await tester.pumpAndSettle();
}

/// Posisi tepi kiri (dx) yang berbeda dari semua widget yang cocok dengan
/// [finder]. Untuk kartu dalam grid, jumlahnya sama dengan jumlah kolom.
Set<double> leftEdgesOf(WidgetTester tester, Finder finder) {
  return {for (var i = 0; i < finder.evaluate().length; i++) tester.getTopLeft(finder.at(i)).dx};
}

/// Membuka form proyek lewat tombol "Tambah Proyek" di halaman utama.
Future<void> openProjectForm(WidgetTester tester) => tapAction(tester, 'Tambah Proyek');

/// Membuka drawer pada halaman yang sedang tampil.
Future<void> openDrawer(WidgetTester tester) async {
  tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
  await tester.pumpAndSettle();
}

/// Menekan menu [title] di dalam drawer.
Future<void> tapDrawerItem(WidgetTester tester, String title) async {
  await tester.tap(find.widgetWithText(ListTile, title));
  await tester.pumpAndSettle();
}

/// Menirukan tombol Back sistem pada perangkat.
Future<void> pressSystemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

/// Field teks ke-[index] pada halaman form proyek.
Finder formField(int index) => find.byType(TextFormField).at(index);

/// Isi field teks ke-[index] pada halaman form proyek.
String formFieldText(WidgetTester tester, int index) {
  final editable = find.descendant(of: formField(index), matching: find.byType(EditableText));
  return tester.widget<EditableText>(editable).controller.text;
}
