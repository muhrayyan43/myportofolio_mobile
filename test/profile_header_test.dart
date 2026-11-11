import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/profile_header.dart';

import 'test_helpers.dart';

void main() {
  group('ProfileHeader.initialsOf', () {
    test('mengambil huruf pertama dari dua kata pertama', () {
      expect(ProfileHeader.initialsOf('Muhammad Rayyan Basalamah'), 'MR');
    });

    test('aman untuk nama satu kata, huruf kecil, dan spasi berlebih', () {
      expect(ProfileHeader.initialsOf('burhan'), 'B');
      expect(ProfileHeader.initialsOf('  ani   wijaya '), 'AW');
      expect(ProfileHeader.initialsOf('   '), '');
    });
  });

  testWidgets('header tampil di atas InfoCard dengan inisial dan sapaan', (tester) async {
    await pumpApp(tester);

    expect(find.byType(ProfileHeader), findsOneWidget);
    expect(find.text('MR'), findsOneWidget);
    expect(find.text(MyHomePage.sapaan), findsOneWidget);
    expect(find.text(MyHomePage.keterangan), findsOneWidget);

    final headerBottom = tester.getBottomLeft(find.byType(ProfileHeader)).dy;
    final firstInfoCardTop = tester.getTopLeft(find.byType(InfoCard).first).dy;
    expect(headerBottom, lessThanOrEqualTo(firstInfoCardTop));
  });
}