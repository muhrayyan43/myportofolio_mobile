import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/experience_validators.dart';

void main() {
  group('cleanText', () {
    test('membuang tag HTML dan spasi di awal dan akhir', () {
      expect(cleanText('  <b>Asisten Dosen</b>  '), 'Asisten Dosen');
      expect(cleanText('<p></p>'), isEmpty);
      expect(cleanText(null), isEmpty);
    });

    test('tidak membuang tanda < yang bukan tag', () {
      expect(cleanText('nilai 3 < 5'), 'nilai 3 < 5');
    });
  });

  group('validateExperienceTitle', () {
    const emptyError = 'Posisi tidak boleh kosong atau hanya berisi spasi.';

    test('menolak judul kosong atau hanya berisi spasi', () {
      expect(validateExperienceTitle(null), emptyError);
      expect(validateExperienceTitle(''), emptyError);
      expect(validateExperienceTitle('   \n\t'), emptyError);
    });

    test('menolak judul yang hanya berisi tag HTML', () {
      expect(validateExperienceTitle('<b> </b>'), 'Posisi tidak boleh hanya berisi tag HTML.');
    });

    test('menerima judul sampai 255 karakter', () {
      expect(validateExperienceTitle('Software Engineer Intern @ Company'), isNull);
      expect(validateExperienceTitle('a' * kTitleMaxLength), isNull);
    });

    test('menolak judul lebih dari 255 karakter', () {
      expect(validateExperienceTitle('a' * 256), 'Judul / Posisi maksimal 255 karakter.');
    });

    test('spasi di awal dan akhir tidak ikut dihitung', () {
      expect(validateExperienceTitle('  ${'a' * kTitleMaxLength}  '), isNull);
    });
  });

  group('validateExperienceDescription', () {
    test('menolak deskripsi kosong, hanya spasi, atau hanya tag HTML', () {
      const emptyError = 'Deskripsi tidak boleh kosong atau hanya berisi spasi.';
      expect(validateExperienceDescription(null), emptyError);
      expect(validateExperienceDescription('  \n  '), emptyError);
      expect(
        validateExperienceDescription('<i></i>'),
        'Deskripsi tidak boleh hanya berisi tag HTML.',
      );
    });

    test('menerima deskripsi panjang karena tidak ada batas', () {
      expect(validateExperienceDescription('Membantu tutorial. ' * 500), isNull);
    });
  });

  group('validateThumbnailUrl', () {
    const invalidError = 'Masukkan URL yang valid, diawali http:// atau https://.';

    test('boleh kosong karena opsional', () {
      expect(validateThumbnailUrl(null), isNull);
      expect(validateThumbnailUrl(''), isNull);
      expect(validateThumbnailUrl('   '), isNull);
    });

    test('menerima URL http dan https yang punya host', () {
      const valid = [
        'https://avatars.githubusercontent.com/u/1?v=4',
        'http://example.com/logo.png',
        'HTTPS://Example.COM/logo.png',
        'http://localhost:8000/static/logo.png',
        'http://192.168.1.10/logo.png',
      ];
      for (final url in valid) {
        expect(validateThumbnailUrl(url), isNull, reason: url);
      }
    });

    test('menolak teks yang bukan URL absolut http/https', () {
      const invalid = [
        'github.com/logo.png',
        'logo.png',
        'ftp://example.com/logo.png',
        'javascript:alert(1)',
        'https://',
        'https:///logo.png',
        'https://example',
        'https://exa mple.com/logo.png',
        'https://-example.com/logo.png',
      ];
      for (final url in invalid) {
        expect(validateThumbnailUrl(url), invalidError, reason: url);
      }
    });

    test('menolak URL lebih dari 200 karakter', () {
      const prefix = 'https://example.com/';
      final atLimit = '$prefix${'a' * (kThumbnailMaxLength - prefix.length)}';
      expect(validateThumbnailUrl(atLimit), isNull);
      expect(validateThumbnailUrl('${atLimit}a'), 'Thumbnail URL maksimal 200 karakter.');
    });
  });

  group('validateStartDate', () {
    test('wajib diisi', () {
      expect(validateStartDate(null), 'Tanggal mulai wajib diisi.');
      expect(validateStartDate(DateTime(2026, 8, 5)), isNull);
    });
  });

  group('validateEndDate', () {
    final start = DateTime(2026, 8, 5);
    const beforeError = 'Tanggal selesai tidak boleh sebelum tanggal mulai.';

    test('boleh kosong karena berarti masih berlangsung', () {
      expect(validateEndDate(null, start: start), isNull);
    });

    test('menerima tanggal yang sama dengan atau setelah tanggal mulai', () {
      expect(validateEndDate(start, start: start), isNull);
      expect(validateEndDate(DateTime(2026, 8, 6), start: start), isNull);
    });

    test('menolak tanggal sebelum tanggal mulai', () {
      expect(validateEndDate(DateTime(2026, 8, 4), start: start), beforeError);
    });

    test('mengabaikan jam saat membandingkan', () {
      expect(validateEndDate(DateTime(2026, 8, 5, 1), start: DateTime(2026, 8, 5, 23)), isNull);
    });

    test('tidak bisa dibandingkan jika tanggal mulai belum diisi', () {
      expect(validateEndDate(DateTime(2026, 8, 4)), isNull);
    });

    test('wajib diisi jika "Masih berlangsung" tidak dicentang', () {
      expect(
        validateEndDate(null, start: start, requireEndDate: true),
        'Isi tanggal selesai atau centang "Masih berlangsung".',
      );
      expect(validateEndDate(DateTime(2026, 8, 6), start: start, requireEndDate: true), isNull);
      expect(
        validateEndDate(DateTime(2026, 8, 4), start: start, requireEndDate: true),
        beforeError,
      );
    });
  });
}
