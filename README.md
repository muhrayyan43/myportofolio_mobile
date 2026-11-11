# MyPortfolio Mobile

[![Flutter CI](https://github.com/muhrayyan43/myportofolio_mobile/actions/workflows/flutter.yml/badge.svg)](https://github.com/muhrayyan43/myportofolio_mobile/actions/workflows/flutter.yml)

Aplikasi mobile Flutter untuk portofolio pribadi saya, dibuat untuk mata kuliah
Pemrograman Berbasis Platform (PBP) Fasilkom UI, Semester Gasal 2026/2027.
Aplikasi ini adalah pasangan mobile dari situs portofolio Django saya
([muhrayyan43/myportofolio](https://github.com/muhrayyan43/myportofolio), live di
[PWS](https://muhammad-rayyan43-myportofolio.pws.cs.ui.ac.id)). Pada tutorial
berikutnya, aplikasi ini akan dihubungkan ke API DRF dari situs tersebut.

| | |
|---|---|
| Nama | Muhammad Rayyan Basalamah |
| NPM | 2406496372 |
| Kelas | PBP B |

## Fitur

- **Kartu identitas** (`InfoCard`) berisi NPM, nama, dan kelas.
- **Empat tombol aksi** (`ItemCard`): Lihat Experience, Tambah Experience,
  Lihat Proyek, dan Logout. Setiap tombol punya warna sendiri dan memunculkan
  SnackBar "Kamu telah menekan tombol [nama tombol]!".
- **Kontras otomatis**: warna teks dan ikon (hitam atau putih) dipilih dari
  warna kartu, dengan kontras minimal 4,5:1 sesuai WCAG AA.
- **Layout responsif**: grid 2 kolom di HP dan 4 kolom di layar lebar, InfoCard
  bertumpuk di HP dan berjajar di layar lebar, lebar konten maksimal 720 px,
  dan halaman bisa digulir sehingga tidak overflow di HP posisi landscape.
- **Aksesibilitas**: setiap kartu dibacakan sebagai tombol oleh pembaca layar,
  punya Tooltip, dan memberi efek hover, fokus keyboard, serta tekan.
- **Header profil** dengan avatar inisial dan sapaan.

## Struktur proyek

```text
lib/
├── main.dart                    # MyApp: MaterialApp dengan tema indigo dan amber
├── menu.dart                    # MyHomePage: halaman utama dan tata letak responsif
├── models/
│   └── item_homepage.dart       # data tombol aksi: nama, ikon, warna, deskripsi
├── utils/
│   └── color_contrast.dart      # rasio kontras WCAG dan pemilih warna teks
└── widgets/
    ├── info_card.dart           # kartu NPM / Name / Class
    ├── item_card.dart           # kartu tombol aksi dan SnackBar-nya
    └── profile_header.dart      # avatar inisial dan sapaan
test/
├── test_helpers.dart            # pumpApp, tapAction, leftEdgesOf
├── menu_test.dart               # identitas, daftar tombol, SnackBar, warna
├── color_contrast_test.dart     # perhitungan kontras dan warna teks kartu
├── responsive_test.dart         # kolom grid, InfoCard, lebar maksimum, landscape
├── item_card_test.dart          # tooltip, semantics, efek hover/fokus/tekan
└── profile_header_test.dart     # inisial dan posisi header
```

## Menjalankan proyek

Prasyarat: Flutter 3.47.9 (channel stable, Dart 3.13.7). Cek dengan
`flutter doctor`; untuk menjalankan di Chrome, tanda centang pada baris
Chrome sudah cukup.

```powershell
git clone https://github.com/muhrayyan43/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
```

Untuk emulator Android atau HP dengan USB debugging, jalankan `flutter run`
lalu pilih perangkatnya.

## Pengujian dan analisis kode

```powershell
flutter analyze   # harus "No issues found!"
flutter test      # harus "All tests passed!"
```

Kedua perintah ini juga dijalankan otomatis oleh GitHub Actions
(`.github/workflows/flutter.yml`) setiap kali ada push. Status terakhirnya
terlihat dari badge di atas.

## Progres mingguan

Riwayat Tugas 1 sampai 6 (situs web Django) ada di
[README repositori Django](https://github.com/muhrayyan43/myportofolio).

| Minggu | Materi | Hasil | Commit / branch |
|---|---|---|---|
| 9–11 Nov 2026 | Tutorial 08: Basic Flutter | Proyek dibuat, `menu.dart` dipisah dari `main.dart`, `MyHomePage` menjadi Stateless, InfoCard dan ItemCard contoh | `68e6307` |
| 12–16 Nov 2026 | Tugas 7: Basic Flutter | Identitas sendiri, empat tombol berwarna, struktur `models/`–`widgets/`–`utils/`, kontras otomatis, layout responsif, aksesibilitas, header profil, 30 test, CI | `chore/tugas-7-groundwork`, `refactor/tugas-7-structure`, `feat/tugas-7-core`, `feat/tugas-7-responsive`, `feat/tugas-7-ux`, `docs/tugas-7-readme` |

## Tugas

### Tugas 7

#### Ringkasan implementasi

- **Identitas.** NPM, nama, dan kelas disimpan sebagai konstanta di
  `MyHomePage` (`npm`, `nama`, `kelas`) lalu ditampilkan oleh tiga `InfoCard`.
- **Tombol dan warna.** Model `ItemHomepage` punya field `final Color color`.
  Daftar `MyHomePage.items` menentukan nama, ikon, warna, dan deskripsi
  keempat tombol, dan `ItemCard` cukup membaca `item.color`, jadi tidak ada
  `if-else` per tombol. Warnanya: biru `blue.shade800`, hijau `green.shade800`,
  kuning `amber.shade700`, dan merah `red.shade700`.
- **SnackBar.** `ItemCard` menutup SnackBar sebelumnya dengan
  `hideCurrentSnackBar()`, lalu menampilkan "Kamu telah menekan tombol X!".
- **Struktur kode.** Model ada di `lib/models/`, widget di `lib/widgets/`, dan
  logika kontras di `lib/utils/`. Setiap class dan fungsi punya doc comment
  (`///`) singkat, sedangkan komentar di dalam kode dibuat seminimal mungkin.
  Data `MyHomePage` disimpan di field `static`, sehingga konstruktornya bisa
  `const`.
- **Kontras.** `readableOn(color)` memilih teks hitam atau putih berdasarkan
  rasio kontras WCAG. Warna contoh di PDF (biru, hijau, dan merah standar
  dengan teks putih) hanya mencapai 2,8–3,7:1, jadi dipakai shade yang lebih
  gelap. Test memastikan semua tombol minimal 4,5:1.
- **Responsif.** `LayoutBuilder` membaca lebar layar: `actionColumnsFor()`
  memberi 2 kolom di bawah 480 px dan 4 kolom di atasnya, InfoCard bertumpuk
  di HP dan berjajar sama tinggi (`IntrinsicHeight`) di layar lebar, dan
  lebar konten dibatasi 720 px. `SingleChildScrollView` dan `SafeArea`
  mencegah overflow di HP posisi landscape.
- **Aksesibilitas.** `Semantics(container: true, button: true)` membuat
  pembaca layar membacakan setiap kartu sebagai satu tombol. Tooltip berisi
  deskripsi aksi, dan `InkWell` memberi efek hover, fokus, dan tekan yang
  warnanya mengikuti warna teks.
- **Kualitas.** Ada 30 test di lima file, `flutter analyze` bersih, dan
  GitHub Actions menjalankan keduanya setiap push.