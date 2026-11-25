import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail.dart';
import 'package:myportofolio_mobile/screens/project_list.dart';

import 'test_helpers.dart';

const projectsJson = [
  {
    'id': 1,
    'title': 'MyPortfolio',
    'description': 'Website portofolio dengan Django.',
    'tech_stack': 'Django, HTMX',
    'year': 2026,
    'url': 'https://github.com/muhrayyan43/myportofolio',
    'star_count': 2,
    'is_starred': false,
    'starred_by_names': 'owner, member',
  },
  {
    'id': 2,
    'title': 'Bot Pengingat Deadline Tugas',
    'description': 'Bot Telegram.',
    'tech_stack': 'Python',
    'year': 2025,
    'url': null,
    'star_count': 0,
    'is_starred': false,
    'starred_by_names': '',
  },
];

http.Response jsonResponse(Object body) => http.Response(jsonEncode(body), 200);

void main() {
  testWidgets('kartu Lihat Proyek membuka daftar proyek dari API', (tester) async {
    final paths = <String>[];
    await pumpApp(
      tester,
      apiClient: fakeApiClient((request) async {
        paths.add(request.url.path);
        return jsonResponse(projectsJson);
      }),
    );
    await tapAction(tester, 'Lihat Proyek');

    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(paths, ['/api/v1/projects/']);
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Django, HTMX · 2026'), findsOneWidget);
    expect(find.text('Bot Pengingat Deadline Tugas'), findsOneWidget);
  });

  testWidgets('menampilkan loading selama request berjalan', (tester) async {
    final response = Completer<http.Response>();
    await pumpScreen(
      tester,
      const ProjectListScreen(),
      apiClient: fakeApiClient((_) => response.future),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    response.complete(jsonResponse(projectsJson));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('daftar kosong menampilkan pesan', (tester) async {
    await pumpScreen(tester, const ProjectListScreen());
    await tester.pumpAndSettle();

    expect(find.text('Belum ada proyek.'), findsOneWidget);
  });

  testWidgets('error menampilkan pesan umum dan tombol Coba lagi', (tester) async {
    var calls = 0;
    await pumpScreen(
      tester,
      const ProjectListScreen(),
      apiClient: fakeApiClient((_) async {
        calls++;
        return calls == 1
            ? http.Response('<h1>Server Error</h1>', 500)
            : jsonResponse(projectsJson);
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gagal memuat proyek.'), findsOneWidget);
    expect(find.textContaining('Server Error'), findsNothing);

    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();

    expect(calls, 2);
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('tarik ke bawah memuat ulang daftar', (tester) async {
    var calls = 0;
    await pumpScreen(
      tester,
      const ProjectListScreen(),
      apiClient: fakeApiClient((_) async {
        calls++;
        return jsonResponse(projectsJson);
      }),
    );
    await tester.pumpAndSettle();

    await tester.fling(find.text('MyPortfolio'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();

    expect(calls, 2);
  });

  testWidgets('menekan proyek membuka detail dengan semua field', (tester) async {
    await pumpScreen(
      tester,
      const ProjectListScreen(),
      apiClient: fakeApiClient((_) async => jsonResponse(projectsJson)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('MyPortfolio'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('Tahun 2026'), findsOneWidget);
    expect(find.text('Website portofolio dengan Django.'), findsOneWidget);
    expect(find.widgetWithText(Chip, 'Django'), findsOneWidget);
    expect(find.widgetWithText(Chip, 'HTMX'), findsOneWidget);
    expect(find.text('https://github.com/muhrayyan43/myportofolio'), findsOneWidget);
    expect(find.text('2 star · owner, member'), findsOneWidget);
  });

  testWidgets('detail proyek tanpa tautan dan star menampilkan keterangan', (tester) async {
    await pumpScreen(tester, ProjectDetailScreen(project: Project.fromJson(projectsJson[1])));

    expect(find.text('Tidak ada tautan.'), findsOneWidget);
    expect(find.text('Belum ada star.'), findsOneWidget);
  });

  testWidgets('menu Projects di drawer membuka daftar proyek', (tester) async {
    await pumpApp(tester);
    await openDrawer(tester);
    await tapDrawerItem(tester, 'Projects');

    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(find.text('Belum ada proyek.'), findsOneWidget);
  });
}
