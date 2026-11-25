import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Ruang di bawah form agar tombol Save bisa digulir melewati SnackBar.
const double _snackBarClearance = 56;

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final String _defaultYear = '${DateTime.now().year}';

  String _title = '';
  String _description = '';
  String _techStack = '';
  late String _year = _defaultYear;
  String _url = '';
  bool _isSubmitting = false;

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _description = '';
      _techStack = '';
      _year = _defaultYear;
      _url = '';
    });
  }

  String? Function(String?) _required(String message) {
    return (value) => value == null || value.trim().isEmpty ? message : null;
  }

  String? _validateYear(String? value) {
    final year = int.tryParse(value?.trim() ?? '');
    if (year == null) return 'Tahun harus berupa angka!';
    if (year < 1900 || year > DateTime.now().year + 1) return 'Tahun tidak valid!';
    return null;
  }

  String? _validateUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
    return valid ? null : 'URL harus diawali http:// atau https://';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final api = context.read<ApiClient>();
    final auth = context.read<AuthState>();
    if (!await ensureLoggedIn(context)) return;
    final token = auth.token;
    if (!mounted || token == null) return;

    final url = _url.trim();
    final project = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      year: int.parse(_year.trim()),
      url: url.isEmpty ? null : url,
    );

    setState(() {
      _isSubmitting = true;
    });
    try {
      final saved = await api.createProject(project, token: token);
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      await _showSaved(saved);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.isUnauthorized) {
        auth.clearSession();
        _showMessage('Sesi login berakhir. Silakan login lagi.');
        await ensureLoggedIn(context);
      } else if (error.statusCode == 403) {
        _showMessage('Akun ini tidak punya izin menambah proyek.');
      } else {
        _showMessage('Gagal menyimpan proyek (status ${error.statusCode}).');
      }
    } on Exception {
      if (!mounted) return;
      _showMessage('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showSaved(Project project) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Proyek berhasil disimpan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Judul: ${project.title}'),
              Text('Tech stack: ${project.techStack}'),
              Text('Tahun: ${project.year}'),
              Text('URL: ${project.url ?? '-'}'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
    if (mounted) _resetForm();
  }

  Widget _field({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Add Project Form'))),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: _snackBarClearance),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field(
                      label: 'Judul Proyek',
                      onChanged: (value) => _title = value,
                      validator: _required('Judul proyek tidak boleh kosong!'),
                    ),
                    _field(
                      label: 'Deskripsi',
                      maxLines: 5,
                      onChanged: (value) => _description = value,
                      validator: _required('Deskripsi proyek tidak boleh kosong!'),
                    ),
                    _field(
                      label: 'Tech Stack',
                      onChanged: (value) => _techStack = value,
                      validator: _required('Tech stack tidak boleh kosong!'),
                    ),
                    _field(
                      label: 'Tahun',
                      initialValue: _defaultYear,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _year = value,
                      validator: _validateYear,
                    ),
                    _field(
                      label: 'URL Proyek (opsional)',
                      keyboardType: TextInputType.url,
                      onChanged: (value) => _url = value,
                      validator: _validateUrl,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(colorScheme.primary),
                          ),
                          onPressed: _isSubmitting ? null : _submit,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text('Save', style: TextStyle(color: colorScheme.onPrimary)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
