/// Satu pilihan kategori Experience.
///
/// [value] sama dengan nilai yang disimpan model Django, sedangkan [label]
/// adalah teks yang ditampilkan kepada pengguna.
class ExperienceCategory {
  const ExperienceCategory(this.value, this.label);

  final String value;
  final String label;
}

/// Pilihan kategori, sama dengan `Experience.EXPERIENCE_CHOICES` di
/// `main/models.py` situs Django.
const List<ExperienceCategory> kExperienceCategories = [
  ExperienceCategory('internship', 'Internship'),
  ExperienceCategory('research', 'Research'),
  ExperienceCategory('volunteer', 'Volunteer'),
  ExperienceCategory('part-time', 'Part-Time'),
  ExperienceCategory('full-time', 'Full-Time'),
  ExperienceCategory('freelance', 'Freelance'),
];

/// Kategori bawaan, sama dengan `default='full-time'` di model Django.
const String kDefaultExperienceCategory = 'full-time';

/// Label kategori bernilai [value], atau [value] itu sendiri jika tidak ada
/// kategori dengan nilai tersebut.
String experienceCategoryLabel(String value) {
  for (final category in kExperienceCategories) {
    if (category.value == value) return category.label;
  }
  return value;
}
