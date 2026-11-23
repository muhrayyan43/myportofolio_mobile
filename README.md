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
- **Lima tombol aksi** (`ItemCard`): Lihat Experience, Tambah Experience,
  Lihat Proyek, Tambah Proyek, dan Logout. Setiap tombol punya warna sendiri
  dan memunculkan SnackBar "Kamu telah menekan tombol [nama tombol]!". Tombol
  Tambah Experience dan Tambah Proyek juga membuka form masing-masing.
- **Drawer navigasi** (`LeftDrawer`) berisi Home, Add Project, dan Add
  Experience, dipakai oleh ketiga halaman.
- **Form tambah proyek** (`ProjectFormPage`) dengan validasi, dropdown kategori,
  dan pop-up berisi data yang dimasukkan. Data belum disimpan ke database.
- **Form tambah Experience** (`ExperienceFormPage`) dengan enam field yang
  mengikuti model `Experience` di situs Django: Judul / Posisi, Deskripsi,
  Kategori, Thumbnail URL, Tanggal Mulai, dan Tanggal Selesai. Validasinya
  sama dengan `ExperienceForm`, tanggal dipilih lewat `showDatePicker()`, dan
  ringkasan isian tampil di dialog setelah Simpan. Fitur tambahannya: checkbox
  "Masih berlangsung", pratinjau thumbnail, penghitung karakter judul, dan
  dialog "Batal / Buang" saat meninggalkan form yang sudah diisi.
- **Tema konsisten**: `AppBarTheme` di `main.dart` memakai `colorScheme.primary`
  untuk AppBar semua halaman, dan warna yang sama dipakai header drawer serta
  tombol simpan.
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
├── main.dart                        # MyApp dan buildAppTheme: tema indigo–amber, AppBarTheme
├── models/
│   ├── experience_category.dart     # pilihan kategori Experience dari model Django
│   └── item_homepage.dart           # data tombol aksi: nama, ikon, warna, deskripsi, halaman tujuan
├── screens/
│   ├── experience_form.dart         # ExperienceFormPage: form, dialog ringkasan, konfirmasi keluar
│   ├── menu.dart                    # MyHomePage: halaman utama dan tata letak responsif
│   └── project_form.dart            # ProjectFormPage: form tambah proyek dan pop-up
├── utils/
│   ├── color_contrast.dart          # rasio kontras WCAG dan pemilih warna teks
│   ├── date_format.dart             # format tanggal Indonesia tanpa package intl
│   └── experience_validators.dart   # validator form Experience (fungsi murni)
└── widgets/
    ├── info_card.dart               # kartu NPM / Name / Class
    ├── left_drawer.dart             # drawer navigasi antarhalaman
    ├── profile_header.dart          # avatar inisial dan sapaan
    ├── project_card.dart            # ItemCard: kartu tombol aksi, SnackBar, navigasi
    └── thumbnail_preview.dart       # pratinjau thumbnail dengan status muat dan gagal
test/
├── test_helpers.dart                # helper aplikasi, navigasi, form, dan ukuran layar
├── experience_helpers.dart          # helper form Experience: field, tanggal, tanggal palsu
├── menu_test.dart                   # identitas, daftar tombol, SnackBar, warna
├── color_contrast_test.dart         # perhitungan kontras dan warna teks kartu
├── responsive_test.dart             # kolom grid, InfoCard, lebar maksimum, landscape
├── project_card_test.dart           # tooltip, semantics, efek hover/fokus/tekan
├── profile_header_test.dart         # inisial dan posisi header
├── left_drawer_test.dart            # isi drawer dan stack navigasi
├── project_form_test.dart           # validasi, pop-up, reset, dan tata letak form
├── experience_validators_test.dart  # unit test semua validator Experience
├── date_format_test.dart            # format tanggal Indonesia
├── experience_category_test.dart    # pilihan dan label kategori
├── experience_form_test.dart        # field, validasi, dialog ringkasan, dan reset
├── experience_navigation_test.dart  # kartu, drawer, stack navigasi, warna tema
├── experience_extras_test.dart      # Masih berlangsung, pratinjau, penghitung, konfirmasi
└── experience_layout_test.dart      # overflow di berbagai layar, keyboard, teks besar
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
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```

Ketiganya harus bersih: `dart format` tidak mengubah file, `flutter analyze`
menampilkan "No issues found!", dan `flutter test` menampilkan "All tests
passed!". Ada 130 test di 14 file, 78 di antaranya untuk form Experience. Untuk
menjalankan satu file saja, misalnya `flutter test test/experience_form_test.dart`.

Test form Experience tidak bergantung pada tanggal hari ini, karena
`ExperienceFormPage` menerima parameter `today` yang diisi tanggal tetap
(20 Agustus 2026) di `test/experience_helpers.dart`.

### Uji manual di Chrome

Jalankan `flutter run -d chrome`, lalu buka DevTools (F12) dan pilih tampilan
ponsel (Ctrl+Shift+M) untuk layar selebar HP.

1. Tekan kartu **Tambah Experience**: SnackBar muncul dan form terbuka. Tombol
   kembali membawa ke halaman utama.
2. Buka drawer dan pilih **Add Experience** dari halaman utama dan dari form
   proyek.
3. Kosongkan Judul / Posisi atau Tanggal Mulai, lalu tekan **Simpan**. Pesan
   error muncul di field tersebut.
4. Lengkapi isian, tekan **Simpan**, cek dialog, lalu tekan **OK**. Form kembali
   kosong dan kategori kembali ke Full-Time.
5. Dari form, pilih **Home** di drawer. Halaman utama tampil dan tombol kembali
   tidak membuka halaman utama kedua.
6. Coba fitur tambahan: hapus centang "Masih berlangsung", isi Thumbnail URL
   (pratinjau muncul), lihat penghitung judul, lalu tinggalkan form yang sudah
   diisi untuk memunculkan dialog "Batal / Buang".

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
| 18–19 Nov 2026 | Tutorial 09: Navigation, Layouts, Forms | Drawer, form tambah proyek, pop-up data, navigasi tombol, folder `screens/`, migrasi ke `material_ui` | `5d3252d` (belum berisi kode tutorial), lalu 6 commit perbaikan di `main` |
| 16–24 Nov 2026 | Tugas 8: Navigation, Layouts, Forms | Form tambah Experience sesuai model Django, navigasi dari kartu dan drawer, tema AppBar terpusat, checkbox Masih berlangsung, pratinjau thumbnail, penghitung karakter, konfirmasi keluar, 78 test baru | 4 commit di `main` setelah perbaikan Tutorial 09 |

## Tutorial 09

- **Navigasi tombol.** Tambah Proyek memakai `Navigator.push`, jadi tombol Back
  kembali ke halaman utama.
- **Navigasi drawer.** Home dan Add Project memakai `Navigator.pushReplacement`.
  Ada dua pengecualian: memilih halaman yang sedang dibuka hanya menutup drawer
  agar isian form tidak hilang, dan Home dari form hasil `push` kembali dengan
  `popUntil` agar halaman utama tidak tertumpuk dua kali.
- **Form.** Nama dan deskripsi wajib diisi, sedangkan teknologi dan tautan
  opsional. Setelah OK ditekan, field dan nilai tersimpan dikosongkan.
- **Perbedaan dari tutorial.** `project_card.dart` tidak mengimpor `menu.dart`
  karena tidak dipakai, dan nama class tetap `ItemCard`.

#### AI Disclosure

- **Tools:** Claude (Anthropic). Claude menyiapkan kode di lingkungannya sendiri;
  penerapan patch dan push ke GitHub saya lakukan sendiri.
- **Bagian yang dibantu AI:** kode drawer dan form, perbaikan navigasi, test, dan
  pembaruan README ini.
- **Catatan commit:** `5d3252d` hanya berisi perubahan `pubspec` dan pemindahan
  file. Kode tutorial baru masuk pada commit sesudahnya.
- **Verifikasi:** sebelum di-merge, perubahan ini harus lolos `flutter analyze`
  dan `flutter test` di Flutter 3.47.9.

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

#### Pertanyaan reflektif

1. Widget tree itu susunan widget yang bentuknya seperti pohon. Setiap widget
   bisa punya anak lewat `child` atau `children`, dan widget yang membungkus
   disebut parent. Di aplikasi ini kira-kira seperti ini:

   ```text
   MyApp → MaterialApp → MyHomePage → Scaffold
     ├─ AppBar
     └─ SafeArea → LayoutBuilder → SingleChildScrollView → Column
          ├─ ProfileHeader
          ├─ InfoCard ×3
          └─ GridView → ItemCard ×4
   ```

   Parent yang ngatur batas ukuran dan posisi anaknya, lalu anak milih
   ukurannya sendiri di dalam batas itu. Contohnya `InfoCard` tidak
   menentukan lebarnya sendiri, tapi ngikut `Expanded` di layar lebar atau
   selebar layar di HP. Data juga turun dari parent ke anak lewat
   konstruktor, misalnya `MyHomePage` ngasih `ItemHomepage` ke `ItemCard`.

2. Widget yang saya pakai:
   - `MaterialApp`: root aplikasi, ngatur tema indigo–amber dan halaman awal.
   - `Scaffold` dan `AppBar`: kerangka halaman dan bar judul "MyPortfolio".
   - `SafeArea`, `LayoutBuilder`, `SingleChildScrollView`: supaya konten aman
     dari notch, bisa menyesuaikan lebar layar, dan bisa di-scroll.
   - `Center`, `SizedBox`, `Padding`: ngatur posisi, lebar maksimal, dan jarak.
   - `Column`, `Row`, `Expanded`, `IntrinsicHeight`: nyusun widget ke bawah
     atau ke samping, dan bikin tiga InfoCard sama lebar dan sama tinggi.
   - `GridView.count`: grid tombol 2 atau 4 kolom.
   - `Card`, `Material`, `InkWell`: kartu, warna latar tombol, dan efek waktu
     ditekan atau di-hover.
   - `Text`, `Icon`, `CircleAvatar`: teks, ikon, dan avatar inisial "MR".
   - `SnackBar`: pesan "Kamu telah menekan tombol X!".
   - `Tooltip`, `Semantics`, `ExcludeSemantics`: penjelasan tombol dan label
     untuk pembaca layar.
   - Widget buatan sendiri: `MyHomePage`, `ProfileHeader`, `InfoCard`, dan
     `ItemCard`.

3. `MaterialApp` itu pembungkus aplikasi yang pakai gaya Material Design. Dia
   yang ngasih tema, halaman awal, dan "fasilitas" yang dipakai widget lain,
   misalnya `ScaffoldMessenger` buat SnackBar, `Overlay` buat Tooltip, dan
   `Navigator` buat pindah halaman. Karena widget lain nyari fasilitas itu ke
   atas pohon, `MaterialApp` paling pas ditaruh paling atas. Kalau tidak ada,
   `ScaffoldMessenger.of(context)` di `ItemCard` bakal error.

4. `StatelessWidget` tidak nyimpan data yang bisa berubah, jadi tampilannya
   cuma tergantung data yang dikasih ke dia. `StatefulWidget` punya `State`
   yang bisa berubah, dan setiap `setState()` dipanggil tampilannya di-build
   ulang, contohnya counter bawaan Flutter. Di aplikasi ini semua widget saya
   Stateless karena datanya tetap. Efek hover dan tekan juga sudah diurus
   `InkWell`, jadi kartunya tidak perlu Stateful. Stateful baru perlu kalau
   widget itu sendiri harus ingat sesuatu yang berubah, misalnya isi form atau
   data yang lagi di-load dari API.

5. `BuildContext` itu semacam "alamat" widget di dalam widget tree. Lewat
   context, widget bisa nyari widget lain di atasnya. Di proyek ini context
   dipakai buat `Theme.of(context)` (warna AppBar dan teks header) dan
   `ScaffoldMessenger.of(context)` (nampilin SnackBar waktu kartu ditekan).
   Context-nya dikasih otomatis lewat parameter `build(BuildContext context)`.

6. Hot reload (`r`) cuma masukin kode yang berubah ke aplikasi yang lagi
   jalan, jadi cepat dan state-nya tidak hilang. Cocok buat ganti warna, teks,
   atau layout. Hot restart (`R`) menjalankan ulang aplikasi dari `main()`,
   jadi state-nya ke-reset. Hot reload tidak cukup kalau yang diubah itu
   nilai field `static` (misalnya nambah tombol di `MyHomePage.items`), kode
   di `main()` atau `initState()`, atau ganti widget dari Stateless ke
   Stateful. Kalau nambah package di `pubspec.yaml` atau ubah file native
   Android, aplikasinya harus di-stop dulu lalu `flutter run` lagi.

#### AI Disclosure

- **Tools:** Claude (Anthropic) di claude.ai, Claude tidak terhubung ke
  laptop saya, jadi semua code dan `git` saya jalankan sendiri.

- **Bagian yang dibantu AI:** rancangan urutan commit dan branch; kode Dart di
  `test/`; workflow `.github/workflows/flutter.yml`;

### Tugas 8

1. `Navigator.push()` naruh halaman baru di atas halaman yang sekarang, jadi
   halaman lama masih ada di bawahnya dan bisa dibalikin. `pushReplacement()`
   juga buka halaman baru, tapi halaman yang sekarang dibuang dari stack, jadi
   tidak bisa kembali ke situ. `pop()` kebalikannya `push()`: buang halaman
   paling atas lalu balik ke halaman di bawahnya, termasuk buat nutup drawer
   atau dialog. Kartu aksi pakai `push()`: di `ItemCard`
   (`lib/widgets/project_card.dart`), kalau `item.pageBuilder` diisi, kartu
   manggil `Navigator.push(context, MaterialPageRoute(builder: pageBuilder))`
   setelah SnackBar. Kartu Tambah Experience ngisi `pageBuilder` dengan
   `ExperienceFormPage`, jadi tombol kembali bawaan perangkat balik ke halaman
   utama. Opsi Home di drawer diurus `_openHome()` di `left_drawer.dart`. Kalau
   drawer lagi di halaman utama, cukup `pop()` buat nutup drawer. Kalau form
   dibuka dari drawer (`pushReplacement`), halaman utama sudah tidak ada di
   stack, jadi Home pakai `pushReplacement` lagi. Kalau form dibuka dari kartu
   (`push`), halaman utama masih ada di bawah, jadi Home pakai
   `popUntil((route) => route.isFirst)` supaya halaman utama tidak numpuk dua.

2. Semua halaman (`MyHomePage`, `ProjectFormPage`, dan `ExperienceFormPage`)
   pakai kerangka yang sama: `Scaffold` dengan `AppBar` di atas, isi halaman di
   `body`, dan `drawer: LeftDrawer(...)`. Karena drawernya satu widget yang
   sama, isi menunya pasti sama di semua halaman, dan kalau nambah menu cukup
   ubah satu file. Posisi judul, tombol drawer, dan area konten juga selalu di
   tempat yang sama, jadi pengguna tidak bingung. Contoh warna tema:
   `buildAppTheme()` di `main.dart` bikin `ColorScheme.fromSeed(seedColor:
   Colors.indigo)` dan ngatur `AppBarTheme(backgroundColor:
   colorScheme.primary)`. Hasilnya AppBar ketiga halaman otomatis berwarna
   `primary` yang sama, padahal tidak ada satu halaman pun yang ngatur warna
   AppBar sendiri. Warna `primary` itu juga dipakai header drawer, tombol Save
   di form proyek, tombol Simpan (`FilledButton`) di form Experience, dan avatar
   di header profil. Sebelumnya form proyek dan header drawer pakai
   `Colors.indigo` langsung, yang warnanya beda dari `primary` hasil
   `fromSeed`, jadi sekarang disamain lewat tema (dicek di `experience_navigation_test.dart`).

3. Form Experience disusun `SafeArea` → `Form` → `SingleChildScrollView` →
   `Center` → `ConstrainedBox(maxWidth: kMaxContentWidth)` → `Column`, sama
   seperti form proyek. `SafeArea` ngejauhin isi dari notch dan status bar.
   `ConstrainedBox` ngebatasin lebar form di 720 px biar field tidak melar
   kepanjangan di layar lebar atau Chrome, dan `Center` naruh form di tengah.
   Buat jarak, setiap field dibungkus `Padding(EdgeInsets.all(8))` lewat
   `_field()`, tombol Simpan dikasih jarak atas lebih besar
   (`EdgeInsets.fromLTRB(8, 16, 8, 8)`), dan `SizedBox` dipakai buat jarak
   kecil di pratinjau thumbnail. Widget penggulirnya `SingleChildScrollView`:
   kalau layar sempit (HP 360×640 atau landscape), keyboard muncul (`Scaffold`
   ngecilin `body` setinggi keyboard), atau teks diperbesar, form tinggal
   digulir sampai tombol Simpan, bukannya overflow. Di bawahnya juga ada
   padding 72 px (`_bottomClearance`) supaya tombol Simpan bisa digulir ke atas
   SnackBar dari halaman utama. Semua kondisi ini dicek di
   `experience_layout_test.dart`.

4. `GlobalKey<FormState>` (`_formKey`) itu "pegangan" ke state widget `Form`,
   jadi dari tombol Simpan kita bisa manggil `_formKey.currentState!.validate()`
   dan `reset()`. Setiap `TextFormField` punya `validator`, yaitu fungsi yang
   ngembaliin `null` kalau isiannya valid atau teks error kalau tidak. Di form
   ini validatornya fungsi murni di `lib/utils/experience_validators.dart`,
   misalnya `validateExperienceTitle` dan `validateThumbnailUrl`. Waktu Simpan
   ditekan, `_submit()` manggil `validate()`, lalu `Form` menjalankan semua
   validator sekaligus dan nampilin pesan error di bawah field yang salah.
   `validate()` baru ngembaliin `true` kalau semuanya `null`, dan cuma saat
   itu `showDialog()` dipanggil. Contoh nilai yang ditolak: Thumbnail URL
   `github.com/logo.png`. Field itu sudah pakai `keyboardType:
   TextInputType.url`, tapi itu cuma ganti tata letak keyboard (ada tombol `/`
   dan `.com`). Pengguna tetap bisa ngetik atau nge-paste teks apa saja, dan di
   Chrome keyboard fisik tidak terpengaruh sama sekali. Teks itu juga lolos
   `Uri.tryParse` sebagai URI relatif, makanya `isValidHttpUrl` ngecek skema
   `http`/`https` dan host, lalu nolak dengan pesan "Masukkan URL yang valid,
   diawali http:// atau https://.". Contoh lain: tanggal dipilih lewat
   `showDatePicker()` yang mulai dari tanggal mulai, tapi kalau tanggal mulai
   diubah ke setelah tanggal selesai, urutannya tetap salah. Karena itu
   `validateEndDate` tetap ngecek dan nampilin "Tanggal selesai tidak boleh
   sebelum tanggal mulai.".

#### Ringkasan implementasi

- **Form sesuai model.** `ExperienceFormPage` (`lib/screens/experience_form.dart`)
  punya field yang sama dengan model `Experience` dan `ExperienceForm` Django:
  `title` (wajib, maksimal 255 karakter), `description` (wajib, multiline),
  `category` (`DropdownButtonFormField` dengan enam pilihan dari
  `EXPERIENCE_CHOICES`, default Full-Time), `thumbnail` (opsional, keyboard
  URL, maksimal 200 karakter seperti `URLField`), `started_at` (wajib), dan
  `ended_at` (opsional). Label dan pesan error berbahasa Indonesia mengikuti
  `forms.py`, termasuk penolakan isian yang hanya berisi spasi atau tag HTML
  seperti `strip_tags(...).strip()`.
- **Validator terpisah.** Semua aturan ada di `lib/utils/experience_validators.dart`
  sebagai fungsi murni dengan doc comment, sehingga bisa diuji dengan unit test
  tanpa widget. Pilihan kategori ada di `lib/models/experience_category.dart`,
  dan format tanggal seperti "5 Agustus 2026" ada di `lib/utils/date_format.dart`
  tanpa package `intl`.
- **Tanggal.** Field tanggal `readOnly` dan diisi lewat `showDatePicker()`:
  tanggal mulai dari 1 Januari 2000 sampai hari ini, dan tanggal selesai mulai
  dari tanggal mulai. Mengubah tanggal mulai langsung memvalidasi ulang tanggal
  selesai.
- **Dialog dan reset.** Simpan memanggil `validate()`, lalu `AlertDialog`
  menampilkan semua isian yang sudah dibersihkan. Tanggal selesai kosong tampil
  "Masih berlangsung" dan thumbnail kosong tampil "-". OK mengosongkan field,
  nilai tersimpan, dan checkbox, serta mengembalikan kategori ke Full-Time.
- **Navigasi tanpa `if` per tombol.** `ItemHomepage` punya field `pageBuilder`,
  jadi `ItemCard` cukup `push` halaman dari data, dan pengecekan
  `item.name == 'Tambah Proyek'` dihapus. Drawer mendapat opsi Add Experience
  setelah Home dan Add Project, dengan helper `_openPage<T>()` yang sama untuk
  kedua form.
- **Tema.** Warna AppBar diatur sekali di `AppBarTheme` (`buildAppTheme()`),
  dan header drawer serta tombol simpan memakai `colorScheme.primary`.
- **Fitur tambahan.**
  - Checkbox "Masih berlangsung" (default dicentang, sesuai `ended_at` kosong
    di Django) mengosongkan dan menonaktifkan tanggal selesai. Jika centangnya
    dihapus, tanggal selesai wajib diisi.
  - `ThumbnailPreview` (`lib/widgets/thumbnail_preview.dart`) tampil hanya
    untuk URL valid, berukuran tetap 120×120, dengan `loadingBuilder` dan
    `errorBuilder` ("Gambar tidak bisa dimuat") yang diperkecil agar tidak
    overflow.
  - Penghitung karakter Judul / Posisi (`maxLength: 255`) tidak memotong teks
    hasil paste (`MaxLengthEnforcement.none`), jadi validator yang menolaknya.
  - Jika form sudah diisi, tombol kembali perangkat, tombol kembali di AppBar,
    dan navigasi drawer memunculkan dialog "Batal / Buang" lewat `PopScope`
    dan `LeftDrawer.confirmLeave`. Form kosong atau yang baru di-reset langsung
    ditinggalkan.
- **Test.** 78 test baru: unit test validator, kategori, dan format tanggal,
  serta widget test validasi, dialog, reset, navigasi dari kartu dan drawer,
  warna tema, keempat fitur tambahan, dan layout di HP 360×640, landscape,
  layar lebar, saat keyboard tampil, dan saat teks diperbesar.
- **Verifikasi.** `flutter analyze`, `flutter test`, dan uji manual di Chrome
  belum dijalankan untuk commit ini.

#### AI Disclosure

- **Tools:** Claude (Anthropic) di claude.ai. Claude meng-clone repo publik ini
  di workspace cloud-nya, menulis kode dan commit di sana, lalu mengirim
  hasilnya sebagai file git bundle karena tidak punya akses push. Saya yang
  menerapkan bundle di laptop Windows, menjalankan `flutter analyze`,
  `flutter test`, dan uji di Chrome, lalu melakukan push.
- **Strategi prompting:** saya menulis satu prompt panjang yang berisi
  spesifikasi field dari `models.py` dan `forms.py`, isi tiap commit, aturan
  keras (tidak mengubah commit yang sudah dikumpulkan, tidak menambah package,
  semua commit di `main` tanpa branch), dan aturan verifikasi (tidak boleh
  mengklaim lolos sebelum perintahnya benar-benar dijalankan). Claude wajib
  mengirim rencana dan semua pertanyaan dulu sebelum mengubah kode, lalu saya
  menjawabnya. Prompt lengkap dan ringkasan prompt Tutorial 09 ada di
  [`docs/ai-prompts.md`](docs/ai-prompts.md).
- **Bagian yang dibantu AI:** hampir semua kode Tugas 8, yaitu
  `experience_form.dart`, validator, model kategori, format tanggal,
  `ThumbnailPreview`, perubahan navigasi di `ItemHomepage`, `ItemCard`, dan
  `LeftDrawer`, `AppBarTheme`, semua test baru, serta draf jawaban README ini.
- **Keterbatasan AI:**
  - Claude tidak bisa menjalankan `flutter test` karena engine Flutter tidak
    bisa diunduh di workspace-nya. Di sesi Tugas 8, Dart SDK juga tidak boleh
    dijalankan di sana, jadi `dart format` dan `dart analyze` juga belum
    dijalankan oleh Claude. Format kode ditulis manual mengikuti gaya
    `dart format`. Akibatnya, semua test ditulis tanpa pernah dijalankan oleh
    AI, dan hanya hasil di laptop saya yang membuktikan test itu benar.
  - Pada Tutorial 09, Claude memberi skrip bash untuk Git Bash, tapi saya
    menjalankannya di PowerShell sehingga skripnya gagal tanpa terlihat jelas.
    Akibatnya `5d3252d` hanya berisi perubahan `pubspec` dan pemindahan file,
    tanpa kode tutorial, dan gagal dianalisis. Claude juga sempat menyebut
    commit itu aman padahal tanda gagalnya sudah terlihat. Karena itu, di Tugas
    8 semua perintah untuk saya harus PowerShell, satu perintah per baris, dan
    tidak boleh ada klaim lolos tanpa bukti.
- **Perbaikan dan pengecekan manual:** belum ada; bagian ini diperbarui setelah
  saya menjalankan `flutter analyze`, `flutter test`, dan uji manual di Chrome.
