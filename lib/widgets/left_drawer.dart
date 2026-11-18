import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Menu navigasi dari sisi kiri layar, dipakai oleh semua halaman.
///
/// Memilih halaman yang sedang dibuka hanya menutup drawer, sehingga isian
/// form tidak hilang. Stack navigasi juga dijaga agar halaman utama tidak
/// pernah tertumpuk dua kali.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  /// Apakah drawer ini sedang berada di dalam halaman bertipe [T].
  bool _isOnPage<T extends Widget>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>() != null;
  }

  /// Kembali ke halaman utama. Jika form dibuka dengan `push` dari halaman
  /// utama, halaman utama masih ada di bawahnya sehingga cukup kembali ke sana.
  void _openHome(BuildContext context) {
    if (_isOnPage<MyHomePage>(context)) {
      Navigator.pop(context);
    } else if (ModalRoute.of(context)?.isFirst ?? true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  /// Membuka form tambah proyek menggantikan halaman yang sedang tampil.
  void _openProjectForm(BuildContext context) {
    if (_isOnPage<ProjectFormPage>(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProjectFormPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
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
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: TextStyle(fontSize: 15, color: Colors.white),
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
            onTap: () => _openProjectForm(context),
          ),
        ],
      ),
    );
  }
}
