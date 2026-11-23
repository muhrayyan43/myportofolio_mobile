import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/experience_category.dart';

void main() {
  test('pilihan kategori sama dengan EXPERIENCE_CHOICES di Django', () {
    expect(
      {for (final category in kExperienceCategories) category.value: category.label},
      {
        'internship': 'Internship',
        'research': 'Research',
        'volunteer': 'Volunteer',
        'part-time': 'Part-Time',
        'full-time': 'Full-Time',
        'freelance': 'Freelance',
      },
    );
  });

  test('kategori bawaan adalah Full-Time', () {
    expect(kDefaultExperienceCategory, 'full-time');
    expect(experienceCategoryLabel(kDefaultExperienceCategory), 'Full-Time');
  });

  test('nilai yang tidak dikenal ditampilkan apa adanya', () {
    expect(experienceCategoryLabel('lainnya'), 'lainnya');
  });
}
