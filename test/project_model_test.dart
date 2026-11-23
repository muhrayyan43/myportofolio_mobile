import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';

void main() {
  group('Project', () {
    test('fromJson membaca field snake_case dari ProjectSerializer', () {
      final project = Project.fromJson(const {
        'id': 3,
        'title': 'MyPortfolio',
        'description': 'Website portofolio',
        'tech_stack': 'Django, DRF',
        'year': 2026,
        'url': 'https://github.com/muhrayyan43/myportofolio',
        'star_count': 2,
        'is_starred': true,
        'starred_by_names': 'owner, member',
      });

      expect(project.id, 3);
      expect(project.techStack, 'Django, DRF');
      expect(project.year, 2026);
      expect(project.url, 'https://github.com/muhrayyan43/myportofolio');
      expect(project.starCount, 2);
      expect(project.isStarred, isTrue);
      expect(project.starredByNames, 'owner, member');
    });

    test('url null dan field star yang hilang memakai nilai bawaan', () {
      final project = Project.fromJson(const {
        'id': 1,
        'title': 'PilihYuk',
        'description': 'Proyek kelompok',
        'tech_stack': 'Django, Flutter',
        'year': 2026,
        'url': null,
      });

      expect(project.url, isNull);
      expect(project.starCount, 0);
      expect(project.isStarred, isFalse);
      expect(project.starredByNames, isEmpty);
    });

    test('toJson hanya berisi field yang boleh dikirim ke API', () {
      const project = Project(
        id: 9,
        title: 'Bot Pengingat',
        description: 'Bot Telegram',
        techStack: 'Python',
        year: 2025,
        starCount: 4,
        isStarred: true,
      );

      expect(project.toJson(), {
        'title': 'Bot Pengingat',
        'description': 'Bot Telegram',
        'tech_stack': 'Python',
        'year': 2025,
        'url': null,
      });
    });
  });
}
