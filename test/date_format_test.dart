import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/date_format.dart';

void main() {
  test('formatIndonesianDate memakai nama bulan bahasa Indonesia', () {
    expect(formatIndonesianDate(DateTime(2026, 8, 5)), '5 Agustus 2026');
    expect(formatIndonesianDate(DateTime(2000, 1, 1)), '1 Januari 2000');
    expect(formatIndonesianDate(DateTime(2026, 12, 31)), '31 Desember 2026');
  });

  test('ada dua belas nama bulan', () {
    expect(kIndonesianMonths, hasLength(12));
    expect(kIndonesianMonths[4], 'Mei');
  });

  test('dateOnly membuang jam, menit, dan detik', () {
    expect(dateOnly(DateTime(2026, 8, 5, 23, 59, 59)), DateTime(2026, 8, 5));
  });
}
