/// Validator form Experience, mengikuti model `Experience` dan
/// `ExperienceForm` di situs Django (`main/models.py` dan `main/forms.py`).
///
/// Semua fungsi di sini murni: hasilnya hanya bergantung pada argumennya,
/// sehingga bisa diuji tanpa widget. Setiap validator mengembalikan `null`
/// jika nilainya valid, atau pesan error dalam bahasa Indonesia.
library;

import 'package:myportofolio_mobile/utils/date_format.dart';

/// Panjang maksimal Judul / Posisi, sama dengan `CharField(max_length=255)`.
const int kTitleMaxLength = 255;

/// Panjang maksimal Thumbnail URL, sama dengan batas bawaan `URLField` Django.
const int kThumbnailMaxLength = 200;

/// Tag HTML seperti `<b>`, `</p>`, atau `<!-- -->`.
final RegExp _htmlTag = RegExp(r'</?[a-zA-Z!][^>]*>');

/// Satu bagian nama host, misalnya `github` atau `com`.
final RegExp _hostLabel = RegExp(r'^[a-z0-9]([a-z0-9-]*[a-z0-9])?$');

/// Karakter spasi, tab, atau baris baru.
final RegExp _whitespace = RegExp(r'\s');

/// [value] tanpa tag HTML dan tanpa spasi di awal dan akhir, seperti
/// `strip_tags(value).strip()` di `ExperienceForm`.
String cleanText(String? value) => (value ?? '').replaceAll(_htmlTag, '').trim();

/// Menolak teks wajib bernama [label] yang kosong, hanya berisi spasi, atau
/// hanya berisi tag HTML.
String? _validateRequiredText(String? value, String label) {
  if (value == null || value.trim().isEmpty) {
    return '$label tidak boleh kosong atau hanya berisi spasi.';
  }
  if (cleanText(value).isEmpty) {
    return '$label tidak boleh hanya berisi tag HTML.';
  }
  return null;
}

/// Validator Judul / Posisi: wajib diisi dan maksimal [kTitleMaxLength]
/// karakter. Seperti `CharField` Django, panjangnya dihitung setelah spasi di
/// awal dan akhir dibuang.
String? validateExperienceTitle(String? value) {
  final error = _validateRequiredText(value, 'Posisi');
  if (error != null) return error;
  if (value!.trim().length > kTitleMaxLength) {
    return 'Judul / Posisi maksimal $kTitleMaxLength karakter.';
  }
  return null;
}

/// Validator Deskripsi: wajib diisi, tanpa batas panjang (`TextField`).
String? validateExperienceDescription(String? value) {
  return _validateRequiredText(value, 'Deskripsi');
}

/// Apakah [host] berupa `localhost` atau nama domain/IPv4 yang punya titik,
/// seperti yang diterima `URLValidator` Django.
bool _isValidHost(String host) {
  if (host == 'localhost') return true;
  final labels = host.split('.');
  return labels.length >= 2 && labels.every(_hostLabel.hasMatch);
}

/// Apakah [value] URL absolut berskema `http` atau `https` yang punya host.
///
/// `Uri.tryParse` saja belum cukup karena teks seperti `github.com/logo.png`
/// atau `logo` juga lolos sebagai URI relatif.
bool isValidHttpUrl(String value) {
  if (value.contains(_whitespace)) return false;
  final uri = Uri.tryParse(value);
  if (uri == null || !uri.hasAuthority) return false;
  return (uri.scheme == 'http' || uri.scheme == 'https') && _isValidHost(uri.host);
}

/// Validator Thumbnail URL: boleh kosong (`blank=True`). Jika diisi, harus
/// URL `http`/`https` yang valid dan maksimal [kThumbnailMaxLength] karakter.
String? validateThumbnailUrl(String? value) {
  final url = value?.trim() ?? '';
  if (url.isEmpty) return null;
  if (url.length > kThumbnailMaxLength) {
    return 'Thumbnail URL maksimal $kThumbnailMaxLength karakter.';
  }
  if (!isValidHttpUrl(url)) {
    return 'Masukkan URL yang valid, diawali http:// atau https://.';
  }
  return null;
}

/// Validator Tanggal Mulai: wajib diisi (`DateField()` tanpa `blank=True`).
String? validateStartDate(DateTime? value) {
  return value == null ? 'Tanggal mulai wajib diisi.' : null;
}

/// Validator Tanggal Selesai.
///
/// Tanggal kosong berarti Experience masih berlangsung (`is_ongoing` di
/// Django), jadi boleh kosong, kecuali [requireEndDate] bernilai `true`
/// karena pengguna menghapus centang "Masih berlangsung". Jika diisi,
/// tanggalnya tidak boleh sebelum [start], sama seperti
/// `ExperienceForm.clean()`. Jam diabaikan.
String? validateEndDate(DateTime? end, {DateTime? start, bool requireEndDate = false}) {
  if (end == null) {
    return requireEndDate ? 'Isi tanggal selesai atau centang "Masih berlangsung".' : null;
  }
  if (start != null && dateOnly(end).isBefore(dateOnly(start))) {
    return 'Tanggal selesai tidak boleh sebelum tanggal mulai.';
  }
  return null;
}
