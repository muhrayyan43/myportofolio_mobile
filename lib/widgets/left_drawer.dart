import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

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

  bool _isOnPage<T extends Widget>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>() != null;
  }

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

  Future<void> _openProtected<T extends Widget>(BuildContext context, WidgetBuilder builder) async {
    if (!await ensureLoggedIn(context)) return;
    if (!context.mounted) return;
    await _openPage<T>(context, builder);
  }

  Future<void> _logout(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await context.read<AuthState>().logout();
    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Kamu sudah logout.')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
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
            onTap: () => _openProtected<ProjectFormPage>(context, (_) => const ProjectFormPage()),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            onTap: () => _openPage<ProjectListScreen>(context, (_) => const ProjectListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Add Experience'),
            onTap: () =>
                _openProtected<ExperienceFormPage>(context, (_) => const ExperienceFormPage()),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: isLoggedIn ? () => _logout(context) : () => ensureLoggedIn(context),
              icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
              label: Text(isLoggedIn ? 'Logout' : 'Login'),
            ),
          ),
        ],
      ),
    );
  }
}
