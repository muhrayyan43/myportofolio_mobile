import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/experience.dart';

const experienceJson = {
  'id': '3a441d74-f968-47fb-a645-2f854a1b2c3d',
  'title': 'Marketing @ PT. Graha Arcadia Raya',
  'description': 'Menangani strategi pemasaran.',
  'category': 'full-time',
  'category_display': 'Full-time',
  'thumbnail': null,
  'started_at': '2024-04-22',
  'ended_at': null,
  'is_ongoing': true,
  'created_at': '2026-09-21T05:51:55.702864Z',
  'updated_at': '2026-09-21T05:51:55.702864Z',
  'star_count': 3,
  'is_starred': true,
};

void main() {
  group('Experience', () {
    test('fromJson membaca semua field dari ExperienceSerializer', () {
      final experience = Experience.fromJson(experienceJson);

      expect(experience.id, '3a441d74-f968-47fb-a645-2f854a1b2c3d');
      expect(experience.category, 'full-time');
      expect(experience.categoryDisplay, 'Full-time');
      expect(experience.thumbnail, isNull);
      expect(experience.startedAt, DateTime(2024, 4, 22));
      expect(experience.endedAt, isNull);
      expect(experience.isOngoing, isTrue);
      expect(experience.createdAt, DateTime.utc(2026, 9, 21, 5, 51, 55, 702, 864));
      expect(experience.starCount, 3);
      expect(experience.isStarred, isTrue);
    });

    test('toJson mengirim tanggal YYYY-MM-DD tanpa field read-only', () {
      final experience = Experience(
        id: 'abc',
        title: 'Asisten Dosen PBP',
        description: 'Membantu tutorial Flutter.',
        category: 'part-time',
        startedAt: DateTime(2026, 8, 5),
        endedAt: DateTime(2026, 12, 19),
        starCount: 4,
      );

      expect(experience.toJson(), {
        'title': 'Asisten Dosen PBP',
        'description': 'Membantu tutorial Flutter.',
        'category': 'part-time',
        'thumbnail': null,
        'started_at': '2026-08-05',
        'ended_at': '2026-12-19',
      });
    });

    test('ended_at null tetap dikirim sehingga tercatat masih berlangsung', () {
      final json = Experience(
        title: 'Kepala Biro MDC',
        description: 'Memimpin biro.',
        category: 'volunteer',
        startedAt: DateTime(2026, 1, 5),
      ).toJson();

      expect(json.containsKey('ended_at'), isTrue);
      expect(json['ended_at'], isNull);
    });
  });
}
