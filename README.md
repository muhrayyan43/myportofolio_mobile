# MyPortfolio Mobile — Muhammad Rayyan Basalamah

[![CI](https://github.com/muhrayyan43/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/muhrayyan43/myportofolio_mobile/actions/workflows/main.yaml)

- Nama: Muhammad Rayyan Basalamah
- NPM: 2406496372
- Kelas: PBP B

Aplikasi Flutter untuk portofolio saya, pasangan dari situs Django
[muhrayyan43/myportofolio](https://github.com/muhrayyan43/myportofolio).

## Menjalankan dan menguji

Butuh Flutter 3.47.9 (cek dengan `flutter --version`).

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
flutter analyze
flutter test
```

Setiap push ke `main`, GitHub Actions (`.github/workflows/main.yaml`) menjalankan
very_good_workflows (`dart format`, `flutter analyze`, dan `flutter test`), lalu membangun
APK release yang bisa diunduh sebagai artefak `app-release-apk` di tab Actions.

## Progres mingguan

| Tanggal | Tugas | Hasil |
|---|---|---|
| 9–11 Nov 2026 | Tutorial 08 | Proyek Flutter, halaman utama dengan InfoCard dan ItemCard |
| 12–16 Nov 2026 | Tugas 7 | Identitas, tombol berwarna, layout responsif, test, dan CI |
| 18–19 Nov 2026 | Tutorial 09 | Drawer, form tambah proyek, navigasi, folder `screens/` |
| 23–24 Nov 2026 | Tugas 8 | Form tambah Experience, navigasi dari kartu dan drawer, fitur tambahan |

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

**Ringkasan implementasi:**
- `ExperienceFormPage` (`lib/screens/experience_form.dart`) berisi field model `Experience` Django: Judul / Posisi, Deskripsi, Kategori, Thumbnail URL, Tanggal Mulai, dan Tanggal Selesai. Validatornya ada di `lib/utils/experience_validators.dart`.
- Kartu Tambah Experience membuka form dengan `Navigator.push()`, dan drawer punya opsi Add Experience setelah Home dan Add Project. Halaman tujuan disimpan di `ItemHomepage.pageBuilder`, jadi tidak ada `if` per tombol.
- Warna AppBar diatur sekali lewat `AppBarTheme` di `main.dart`.
- Fitur tambahan: checkbox "Masih berlangsung", pratinjau thumbnail, penghitung karakter judul, dan dialog "Batal / Buang" saat meninggalkan form yang sudah diisi.
