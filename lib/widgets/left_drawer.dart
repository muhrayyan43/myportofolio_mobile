import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Menu navigasi dari sisi kiri layar, dipakai oleh semua halaman.
///
/// Memilih halaman yang sedang dibuka hanya menutup drawer, sehingga isian
/// form tidak hilang. Stack navigasi juga dijaga agar halaman utama tidak
/// pernah tertumpuk dua kali.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, this.confirmLeave});

  /// Dipanggil sebelum drawer membawa pengguna ke halaman lain. Jika hasilnya
  /// `false`, perpindahan dibatalkan. Form Experience memakainya untuk
  /// menanyakan apakah isian yang belum disimpan boleh dibuang.
  final Future<bool> Function()? confirmLeave;

  /// Apakah drawer ini sedang berada di dalam halaman bertipe [T].
  bool _isOnPage<T extends Widget>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>() != null;
  }

  /// Kembali ke halaman utama. Jika form dibuka dengan `push` dari halaman
  /// utama, halaman utama masih ada di bawahnya sehingga cukup kembali ke sana.
  Future<void> _openHome(BuildContext context) async {
    if (_isOnPage<MyHomePage>(context)) {
      Navigator.pop(context);
      return;
    }
    final confirm = confirmLeave;
    if (confirm != null && !await confirm()) return;
    if (!context.mounted) return;

    if (ModalRoute.of(context)?.isFirst ?? true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  /// Membuka halaman bertipe [T] dari [builder] menggantikan halaman yang
  /// sedang tampil. Jika halaman itu sedang terbuka, drawer cukup ditutup.
  Future<void> _openPage<T extends Widget>(BuildContext context, WidgetBuilder builder) async {
    if (_isOnPage<T>(context)) {
      Navigator.pop(context);
      return;
    }
    final confirm = confirmLeave;
    if (confirm != null && !await confirm()) return;
    if (!context.mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            // Tinggi header tetap, jadi teks yang diperbesar perlu bisa digulir.
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => _openHome(context),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () => _openPage<ProjectFormPage>(context, (_) => const ProjectFormPage()),
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Add Experience'),
            onTap: () => _openPage<ExperienceFormPage>(context, (_) => const ExperienceFormPage()),
          ),
        ],
      ),
    );
  }
}
