/// Nama bulan dalam bahasa Indonesia, dari Januari sampai Desember.
const List<String> kIndonesianMonths = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// [date] tanpa jam, menit, dan detik, sehingga dua tanggal bisa dibandingkan
/// per hari.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// [date] dalam format tanggal Indonesia, misalnya "5 Agustus 2026".
///
/// Dibuat tanpa package `intl` agar tidak menambah dependensi.
String formatIndonesianDate(DateTime date) {
  return '${date.day} ${kIndonesianMonths[date.month - 1]} ${date.year}';
}
