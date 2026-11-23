# Log prompting AI

Log ini melengkapi bagian AI Disclosure di [README](../README.md). Semua sesi
memakai Claude (Anthropic) di claude.ai. Tautan share chat tidak disertakan.

## Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements

### Prompt utama (23 November 2026)

Prompt berikut saya kirim apa adanya, bersama PDF tugas dan zip repo.

````text
Kerjakan Individual Assignment 8 PBP "Flutter Navigation, Layouts, Forms, and Input Elements" (PDF
sudah ada di chat ini; https://pbp.cs.ui.ac.id/assignments/individual/tugas-8.html) di repo Flutter
saya https://github.com/muhrayyan43/myportofolio_mobile untuk mendapat nilai maksimal (skor 4) di
semua rubrik.

TENGGAT
Diperpanjang menjadi Selasa, 24 November 2026, pukul 23.59 WIB. Abaikan tenggat di PDF. Semua commit
harus sudah saya push sebelum itu.

SEMUA DI MAIN, TANPA BRANCH
- Semua commit langsung di atas main, dalam satu garis lurus tanpa branch baru dan tanpa merge
  commit.
- Saya tidak mau pindah-pindah branch. Perintah untuk saya tidak boleh memakai git switch atau
  checkout ke branch lain.

CARA KERJA DI CHAT INI
- Kamu bekerja di workspace cloud-mu sendiri: clone repo publik saya dan buat commit di sana.
- Kamu tidak punya akses push, jadi hasilnya dikirim sebagai file git bundle berisi main. Saya yang
  menerapkannya di laptop (Windows) lalu push.
- Kamu tidak bisa menjalankan `flutter test` karena engine Flutter tidak bisa diunduh. Verifikasimu:
  `dart format` dan `dart analyze` dengan source framework Flutter 3.47.9 (seperti saat Tutorial 09).
  `flutter analyze`, `flutter test`, dan uji di Chrome saya jalankan di laptop, lalu outputnya saya
  kirim ke sini. Jangan pernah menyatakan sesuatu lolos jika perintahnya belum benar-benar dijalankan.
- Semua perintah untuk saya harus berupa PowerShell, satu perintah per baris, tanpa `&&`, `sed`,
  heredoc, atau sintaks khusus bash. Tutorial 09 gagal karena skrip bash dijalankan di PowerShell.
- Selama belum saya push, kamu boleh menyusun ulang commit agar riwayatnya rapi. Setelah di-push,
  riwayat tidak boleh diubah.

LANGKAH 0: RENCANA DAN PERTANYAAN
Sebelum mengubah apa pun, kirim rencana singkat dan tanyakan sekaligus semua yang ambigu. Termasuk
tautan share chat claude.ai ini untuk AI Disclosure; jika saya tidak punya, jangan buat placeholder.
Lalu tunggu jawaban saya.

ATURAN KERAS
- Jangan mengubah commit yang sudah ada di GitHub, terutama 5d3252d dan 3538f78, karena tautannya
  sudah dikumpulkan ke SCELE. Semua commit baru ditambahkan di atas 5d3252d.
- Jangan mengubah branch Tugas 7 yang lama, identitas saya (NPM, nama, kelas), atau tombol yang ada.
- Jangan menambah package baru tanpa izin saya.
- Pesan commit dalam bahasa Inggris dengan conventional commits, seperti riwayat repo.
- Setiap commit harus lolos `dart format --set-exit-if-changed lib test` dan analyzer, dan test-nya
  harus ditulis supaya lolos `flutter test`. Jangan menghapus atau melemahkan test agar lolos.

BAGIAN A: 6 COMMIT PERBAIKAN TUTORIAL 09
origin/main masih di 5d3252d, yang gagal analyze (sekitar 38 error) dan belum berisi kode Tutorial
09. Perbaikannya berupa 6 commit di atas 5d3252d, ada di branch `fix/tutorial-9-polish` dalam bundle
terlampir. Pakai keenam commit itu apa adanya sebagai bagian awal main. Belum pernah diuji dengan
`flutter test`; jika saya melaporkan error, perbaiki di dalam commit yang bersangkutan.
- Setelah saya menjalankan test, perbarui commit "docs: describe tutorial 9 in the README": ganti
  kalimat "Verifikasi: sebelum di-merge, ..." dengan hasil nyata, dan rapikan tingkat heading
  (#### langsung di bawah ##).

BAGIAN B: TUGAS 8, TEPAT 4 COMMIT SETELAH BAGIAN A
Formulir yang dibuat: Tambah Experience, mengikuti model Django saya
(https://github.com/muhrayyan43/myportofolio, main/models.py dan main/forms.py):
- Judul / Posisi (title): TextFormField, wajib, tolak kosong atau hanya spasi (trim), maksimal 255
  karakter. Hint: "Software Engineer Intern @ Company".
- Deskripsi (description): multiline, wajib, tolak kosong atau hanya spasi, tanpa batas panjang.
- Kategori (category): DropdownButtonFormField berisi Internship, Research, Volunteer, Part-Time,
  Full-Time, dan Freelance, dengan nilai internship, research, volunteer, part-time, full-time, dan
  freelance. Default Full-Time.
- Thumbnail URL (thumbnail): opsional, keyboard URL. Jika diisi, harus URL absolut http/https dengan
  host, dan maksimal 200 karakter (batas default URLField Django).
- Tanggal Mulai (started_at): wajib, readOnly + showDatePicker() dengan rentang tanggal yang wajar.
- Tanggal Selesai (ended_at): opsional (kosong berarti masih berlangsung, seperti is_ongoing), dipilih
  lewat showDatePicker() yang mulai dari tanggal mulai. Error jika sebelum tanggal mulai: "Tanggal
  selesai tidak boleh sebelum tanggal mulai." Jika tanggal mulai diubah, field ini divalidasi ulang.
- Label dan pesan error dalam bahasa Indonesia, konsisten dengan forms.py Django.

Commit 1, `feat: add the experience form with model-based validation`
- `lib/screens/experience_form.dart` (StatefulWidget, Form, GlobalKey<FormState>, Scaffold +
  AppBar + LeftDrawer yang sama).
- Validator berupa fungsi murni di `lib/utils/` (misalnya `experience_validators.dart`) dengan doc
  comment. Opsi kategori dan helper format tanggal Indonesia (misalnya "5 Agustus 2026") dibuat tanpa
  package baru.
- Tata letak mengikuti project_form: SafeArea, SingleChildScrollView, lebar maksimal
  kMaxContentWidth, jarak antar-field yang rapi, dan ruang bawah agar tombol Simpan tetap terjangkau
  di layar sempit, saat keyboard tampil, atau saat SnackBar muncul.
- Tombol Simpan memanggil FormState.validate(). Jika lolos, showDialog() menampilkan AlertDialog
  berisi semua isian. Tanggal selesai yang kosong ditampilkan sebagai "Masih berlangsung" dan
  thumbnail kosong sebagai "-". Tombol OK menutup dialog, mengosongkan field dan nilai tersimpan,
  dan mengembalikan kategori ke default, sama seperti Tutorial 09.
- Test: unit test semua validator, serta widget test untuk field wajib kosong atau hanya spasi,
  title lebih dari 255 karakter, URL tidak valid, tanggal selesai sebelum tanggal mulai, field
  opsional boleh kosong, dialog berisi semua isian, dan reset setelah OK. Test tidak boleh
  bergantung pada tanggal hari ini; buat tanggal "hari ini" bisa disuntikkan bila perlu.

Commit 2, `feat: open the experience form from the action card and drawer`
- Kartu "Tambah Experience" yang sudah ada membuka form dengan Navigator.push() setelah SnackBar,
  dan tombol kembali perangkat membawa ke halaman utama.
- Ganti pengecekan `item.name == 'Tambah Proyek'` di project_card.dart dengan data di ItemHomepage
  (misalnya builder halaman tujuan), sehingga tidak ada if per tombol. Tambah Proyek harus tetap
  berjalan.
- Tambah opsi "Add Experience" di LeftDrawer setelah Home dan Add Project, dengan perilaku yang sama:
  pushReplacement, memilih halaman yang sedang dibuka hanya menutup drawer, dan Home dari form hasil
  push kembali dengan popUntil tanpa menumpuk halaman utama.
- Samakan warna tema: halaman utama memakai colorScheme.primary, sedangkan form proyek dan header
  drawer memakai Colors.indigo yang berbeda. Pakai warna dari tema (misalnya AppBarTheme di
  main.dart) di semua halaman dan drawer.
- Test: buka dari kartu lalu kembali, buka dari drawer di halaman utama dan form proyek, Home dari
  form Experience menuju halaman utama tanpa tumpukan, opsi halaman aktif tidak menghapus isian, dan
  warna AppBar sama di semua halaman.

Commit 3, `feat: add ongoing toggle, thumbnail preview, counter, and leave confirmation`
- Checkbox "Masih berlangsung": jika dicentang, tanggal selesai dikosongkan dan dinonaktifkan. Jika
  tidak dicentang dan tanggal selesai kosong, tampilkan error yang meminta mengisi tanggal selesai
  atau mencentang "Masih berlangsung".
- Pratinjau thumbnail: hanya tampil saat URL valid, berukuran tetap, dengan loadingBuilder dan
  errorBuilder (ikon dan teks "Gambar tidak bisa dimuat"), dan tidak boleh overflow.
- Penghitung karakter pada Judul / Posisi (maxLength 255). Validator panjang tetap ada untuk teks
  hasil paste.
- Konfirmasi keluar: jika form sudah diisi, tombol kembali perangkat, tombol kembali di AppBar, dan
  navigasi drawer menampilkan dialog "Batal / Buang". Form yang kosong atau baru di-reset tidak
  menampilkan dialog. Gunakan PopScope.
- Test untuk keempat fitur, serta tidak ada overflow di HP potret 360x640, HP landscape, layar lebar,
  keyboard tampil (tester.view.viewInsets), dan teks yang diperbesar.

Commit 4, `docs: answer Tugas 8 questions and document the experience form`
Perbarui README.md tanpa menghapus jawaban tugas sebelumnya:
- Fitur, struktur `lib/` dan `test/`, jumlah test, instruksi setup dan pengujian, dan baris Tugas 8
  di tabel Progres mingguan.
- Bagian "### Tugas 8" sesuai format PDF: jawaban 1–4 langsung di bawah heading, lalu
  "#### Ringkasan implementasi" dan "#### AI Disclosure". Gaya bahasa mengikuti jawaban Tugas 7.
  Setiap jawaban merujuk kode nyata (nama method, file, warna tema), termasuk contoh nilai yang
  ditolak validasi untuk nomor 4.
- AI Disclosure yang jujur dan kritis:
  - Tools: Claude di claude.ai menulis kode dan commit di workspace cloud-nya. Saya yang menerapkan
    bundle, menjalankan flutter analyze/test dan uji Chrome, lalu push.
  - Strategi prompting, bagian spesifik yang dibantu AI, dan keterbatasan AI: tidak bisa menjalankan
    flutter test, dan insiden Tutorial 09 ketika skrip bash dijalankan di PowerShell sehingga
    5d3252d tidak berisi kode tutorial.
  - Perbaikan atau pengecekan manual yang saya lakukan, hanya berdasarkan laporan saya.
- Simpan log prompting di `docs/ai-prompts.md` (prompt ini apa adanya beserta ringkasan prompt
  Tutorial 09) dan tautkan dari README.
- Bagian AI Disclosure Tugas 7 terpotong di tengah kalimat. Tunjukkan ke saya dan tanya dulu
  sebelum mengubahnya.

PENGIRIMAN DAN PUTARAN UJI
1. Buat bundle berisi main (5d3252d + 6 commit Bagian A + 4 commit Bagian B). Uji bundle di clone
   baru sebelum dikirim.
2. Kirim bundle dengan perintah PowerShell untuk saya:
   - Pastikan saya di folder proyek dan di main, lalu cek `flutter --version`, `git status`, dan
     `git log --oneline origin/main..main`. Jika ada commit lokal yang belum di-push atau ada
     perubahan yang belum di-commit, saya harus berhenti dan melapor dulu.
   - Ambil main dari bundle ke ref terpisah (misalnya
     `git fetch <bundle> +main:refs/remotes/claude/main`), lalu `git merge --ff-only claude/main`
     di main. Kemudian jalankan flutter pub get, flutter analyze, dan flutter test.
   - Checklist uji manual berdasarkan Petunjuk Pengujian di PDF untuk `flutter run -d chrome` dan
     layar selebar ponsel: buka form dari kartu dan drawer, Simpan dengan field wajib kosong,
     lengkapi lalu Simpan lagi, OK, Home dari drawer, serta fitur ekstra.
3. Jika saya melaporkan error, perbaiki dengan menyusun ulang commit yang belum di-push (Bagian A
   tetap 6 commit, Bagian B tetap 4), lalu kirim bundle baru. Karena commit lama di main lokal saya
   akan diganti, perintahnya:
   - `git status` harus bersih.
   - `git log --oneline origin/main..main` hanya boleh berisi commit dari bundle sebelumnya.
   - Fetch ulang, lalu `git reset --hard claude/main`.
   Ulangi sampai semuanya lolos.
4. Setelah lolos, perbarui README dengan hasil nyata dan laporan uji manual saya, kirim bundle final
   dengan cara pembaruan yang sama, lalu beri perintah `git push origin main`.
   Jangan lupa tampilkan tautan commit untuk SCELE:
   https://github.com/muhrayyan43/myportofolio_mobile/commit/<hash commit terakhir di main>
   Ingatkan saya untuk mengecek CI di GitHub Actions dan memastikan repo bersifat publik.

LAPORAN SETIAP PUTARAN (bahasa Indonesia, singkat)
Daftar commit, hasil verifikasi yang benar-benar dijalankan, penyimpangan dari PDF beserta
alasannya, dan hal yang belum terverifikasi.
````

### Jawaban saya atas pertanyaan Claude

Sebelum mengubah kode, Claude mengirim rencana dan tujuh pertanyaan. Saya
mengunggah bundle `tutorial-9-polish.bundle` (pertanyaan 1), lalu menjawab:

```text
2-5 pilih yang menurut anda paling baik
6 c
7 tidak perlu
```

Artinya:

- **Tautan share (2):** tidak ada, jadi README tidak memuat tautan atau
  placeholder.
- **Pesan error (3):** memakai usulan Claude, termasuk menolak isian yang
  hanya berisi tag HTML seperti `strip_tags` di Django. Claude kemudian
  memisahkan pesan untuk isian yang hanya berisi tag dari pesan untuk isian
  kosong agar tidak menyesatkan.
- **Rentang tanggal (4):** tanggal mulai dari 1 Januari 2000 sampai hari ini,
  dan tanggal selesai dari tanggal mulai sampai hari ini.
- **Checkbox "Masih berlangsung" (5):** dicentang secara default, sesuai
  `ended_at` kosong di Django.
- **AI Disclosure Tugas 7 yang terpotong (6):** dibiarkan apa adanya.
- **Keputusan asdos soal Tutorial 09 (7):** tidak perlu ditulis.

## Tutorial 09 (18 November 2026), ringkasan

1. **Prompt pertama.** Menjelang tenggat 23.59, saya meminta Claude membuat
   kode dua commit Tutorial 09 (drawer, form tambah proyek, navigasi, lalu
   refactor ke folder `screens/`) dalam bentuk skrip yang bisa saya salin ke
   Git Bash, karena Claude tidak terhubung ke laptop saya. Claude memberi dua
   skrip bash dengan heredoc. Skrip itu saya jalankan di PowerShell sehingga
   gagal, dan commit `5d3252d` yang saya kumpulkan hanya berisi perubahan
   `pubspec` dan pemindahan file. Claude sempat menyebut commit itu aman.
2. **Prompt audit.** Setelah itu saya meminta Claude mengaudit dan memperbaiki
   hasilnya dengan aturan berikut:
   - `5d3252d` dan riwayat sebelumnya tidak boleh di-amend, di-rebase,
     di-force-push, atau dihapus, karena tautannya sudah dikumpulkan ke SCELE.
   - Perbaikan dibuat di branch `fix/tutorial-9-polish` dengan commit kecil
     bergaya conventional commits, dan tidak di-merge sebelum saya setuju.
   - Tugas 8 dan identitas saya tidak boleh disentuh.
   - Claude harus menjalankan `flutter pub get`, `flutter analyze`, dan
     `flutter test`, memperbaiki akar masalahnya tanpa melemahkan test,
     mencocokkan kode dengan isi tutorial, serta memeriksa line ending, urutan
     import, kompatibilitas `material_ui`, stack navigasi, dan SnackBar.

   Claude menemukan bahwa `5d3252d` tidak berisi kode tutorial, lalu membuat
   enam commit perbaikan di atasnya dan mengirimnya sebagai
   `tutorial-9-polish.bundle`. Claude hanya bisa menjalankan `dart analyze`
   dengan source Flutter 3.47.9, sedangkan `flutter test` tidak bisa
   dijalankan. Keenam commit itu menjadi awal riwayat `main` untuk Tugas 8.
