import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final technologies = project.techStack
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty);
    final url = project.url;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Proyek')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text('Tahun ${project.year}', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 16),
                    Text(project.description, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    _Section(
                      label: 'Tech stack',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [for (final tech in technologies) Chip(label: Text(tech))],
                      ),
                    ),
                    _Section(
                      label: 'Tautan',
                      child: url == null || url.isEmpty
                          ? const Text('Tidak ada tautan.')
                          : SelectableText(url),
                    ),
                    _Section(label: 'Star', child: Text(_starSummary())),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _starSummary() {
    if (project.starCount == 0) return 'Belum ada star.';
    final names = project.starredByNames.isEmpty ? '' : ' · ${project.starredByNames}';
    return '${project.starCount} star$names';
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
