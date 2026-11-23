import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Tinggi yang disisakan di bawah form agar tombol Save bisa digulir ke atas
/// SnackBar yang masih tampil setelah berpindah dari halaman utama.
const double _snackBarClearance = 56;

/// Halaman form untuk menambahkan proyek baru.
///
/// Data belum disimpan ke database. Setelah lolos validasi, isian ditampilkan
/// pada pop-up, lalu form dikosongkan saat pop-up ditutup dengan tombol OK.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const String _defaultCategory = 'Web Development';

  final _formKey = GlobalKey<FormState>();

  String _projectName = "";
  String _description = "";
  String _category = _defaultCategory;
  String _technologies = "";
  String _projectLink = "";

  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  /// Mengosongkan field sekaligus nilai yang tersimpan, supaya isian lama
  /// tidak muncul lagi pada pop-up berikutnya.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _projectName = "";
      _description = "";
      _category = _defaultCategory;
      _technologies = "";
      _projectLink = "";
    });
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
                    // === Project Name ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Nama Proyek",
                          labelText: "Nama Proyek",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _projectName = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Nama proyek tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),

                    // === Description ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Deskripsi Proyek",
                          labelText: "Deskripsi Proyek",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _description = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Deskripsi proyek tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),

                    // === Category ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Kategori Proyek",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        initialValue: _defaultCategory,
                        items: _categories
                            .map(
                              (category) =>
                                  DropdownMenuItem(value: category, child: Text(category)),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _category = newValue!;
                          });
                        },
                      ),
                    ),

                    // === Technologies ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Contoh: Flutter, Django, Figma",
                          labelText: "Teknologi yang Digunakan",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _technologies = value!;
                          });
                        },
                      ),
                    ),

                    // === Project Link ===
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "URL Proyek (opsional)",
                          labelText: "Tautan Proyek",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _projectLink = value!;
                          });
                        },
                      ),
                    ),

                    // === Tombol Simpan ===
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(colorScheme.primary),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Proyek berhasil ditambahkan!'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Nama Proyek: $_projectName'),
                                          Text('Deskripsi: $_description'),
                                          Text('Kategori: $_category'),
                                          Text('Teknologi: $_technologies'),
                                          Text('Tautan: $_projectLink'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _resetForm();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text("Save", style: TextStyle(color: colorScheme.onPrimary)),
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
