import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_detail.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/status_message.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    // Dibuat di sini, bukan di build, agar rebuild tidak memicu request baru.
    _projectsFuture = context.read<ApiClient>().getProjects();
  }

  void _retry() {
    setState(() {
      _projectsFuture = context.read<ApiClient>().getProjects();
    });
  }

  Future<void> _refresh() async {
    final future = context.read<ApiClient>().getProjects();
    setState(() {
      _projectsFuture = future;
    });
    await future.catchError((_) => const <Project>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proyek')),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Project>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return StatusMessage(
                      icon: Icons.cloud_off,
                      title: 'Gagal memuat proyek.',
                      subtitle: 'Periksa koneksi atau alamat API, lalu coba lagi.',
                      action: FilledButton(onPressed: _retry, child: const Text('Coba lagi')),
                    );
                  }
                  final projects = snapshot.data ?? const <Project>[];
                  if (projects.isEmpty) {
                    return const StatusMessage(
                      icon: Icons.folder_off_outlined,
                      title: 'Belum ada proyek.',
                      subtitle: 'Proyek yang ditambahkan akan muncul di sini.',
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: projects.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _ProjectTile(projects[index]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.folder),
        title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${project.techStack} · ${project.year}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => ProjectDetailScreen(project: project)),
        ),
      ),
    );
  }
}
