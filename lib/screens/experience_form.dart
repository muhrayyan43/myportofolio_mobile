import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience_category.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/utils/date_format.dart';
import 'package:myportofolio_mobile/utils/experience_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Ruang di bawah tombol Simpan agar tombol itu tetap bisa digulir ke atas
/// SnackBar yang masih tampil setelah berpindah dari halaman utama.
const double _bottomClearance = 72;

/// Halaman form untuk menambahkan Experience baru.
///
/// Field dan aturan validasinya mengikuti model `Experience` dan
/// `ExperienceForm` di situs Django. Data belum dikirim ke server: setelah
/// semua isian lolos validasi, ringkasannya ditampilkan di [AlertDialog], lalu
/// form dikosongkan saat dialog ditutup dengan tombol OK.
class ExperienceFormPage extends StatefulWidget {
  /// [today] hanya perlu diisi oleh test, agar batas pemilih tanggal tidak
  /// bergantung pada tanggal saat test dijalankan.
  const ExperienceFormPage({super.key, this.today});

  /// Tanggal "hari ini" untuk batas akhir pemilih tanggal. Jika `null`,
  /// dipakai [DateTime.now].
  final DateTime? today;

  /// Tanggal paling awal yang bisa dipilih.
  static final DateTime firstSelectableDate = DateTime(2000);

  /// Key pembungkus setiap field, dipakai test untuk menemukan field-nya.
  static const Key titleKey = ValueKey<String>('experience-title');
  static const Key descriptionKey = ValueKey<String>('experience-description');
  static const Key categoryKey = ValueKey<String>('experience-category');
  static const Key thumbnailKey = ValueKey<String>('experience-thumbnail');
  static const Key startDateKey = ValueKey<String>('experience-start-date');
  static const Key endDateKey = ValueKey<String>('experience-end-date');

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  static final List<DropdownMenuItem<String>> _categoryItems = [
    for (final category in kExperienceCategories)
      DropdownMenuItem(value: category.value, child: Text(category.label)),
  ];

  final _formKey = GlobalKey<FormState>();
  final _startDateFieldKey = GlobalKey<FormFieldState<String>>();
  final _endDateFieldKey = GlobalKey<FormFieldState<String>>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String _title = '';
  String _description = '';
  String _category = kDefaultExperienceCategory;
  String _thumbnail = '';
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime get _today => dateOnly(widget.today ?? DateTime.now());

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// [date] yang dibatasi ke rentang [first] sampai [last], agar sah sebagai
  /// `initialDate` pemilih tanggal.
  DateTime _clampDate(DateTime date, DateTime first, DateTime last) {
    if (date.isBefore(first)) return first;
    if (date.isAfter(last)) return last;
    return date;
  }

  /// Memvalidasi ulang field ber-[key] jika sedang menampilkan error, atau
  /// selalu jika [force] bernilai `true`.
  void _revalidate(GlobalKey<FormFieldState<String>> key, {bool force = false}) {
    final field = key.currentState;
    if (field != null && (force || field.hasError)) field.validate();
  }

  /// Memilih tanggal mulai dari 1 Januari 2000 sampai hari ini.
  Future<void> _pickStartDate() async {
    final first = ExperienceFormPage.firstSelectableDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(_startDate ?? _today, first, _today),
      firstDate: first,
      lastDate: _today,
      currentDate: _today,
      helpText: 'Pilih tanggal mulai',
    );
    if (picked == null || !mounted) return;

    setState(() {
      _startDate = picked;
      _startDateController.text = formatIndonesianDate(picked);
    });
    _revalidate(_startDateFieldKey);
    // Tanggal selesai yang sudah diisi bisa menjadi tidak valid.
    _revalidate(_endDateFieldKey, force: _endDate != null);
  }

  /// Memilih tanggal selesai mulai dari tanggal mulai sampai hari ini.
  Future<void> _pickEndDate() async {
    final first = _startDate ?? ExperienceFormPage.firstSelectableDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(_endDate ?? _startDate ?? _today, first, _today),
      firstDate: first,
      lastDate: _today,
      currentDate: _today,
      helpText: 'Pilih tanggal selesai',
    );
    if (picked == null || !mounted) return;

    setState(() {
      _endDate = picked;
      _endDateController.text = formatIndonesianDate(picked);
    });
    _revalidate(_endDateFieldKey);
  }

  /// Mengosongkan field sekaligus nilai yang tersimpan dan mengembalikan
  /// kategori ke Full-Time, supaya isian lama tidak muncul lagi.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _description = '';
      _category = kDefaultExperienceCategory;
      _thumbnail = '';
      _startDate = null;
      _endDate = null;
    });
  }

  /// Isian yang sudah dibersihkan, sesuai urutan field di form.
  Map<String, String> _summary() {
    final thumbnail = _thumbnail.trim();
    final start = _startDate;
    final end = _endDate;
    return {
      'Judul / Posisi': cleanText(_title),
      'Deskripsi': cleanText(_description),
      'Kategori': experienceCategoryLabel(_category),
      'Thumbnail URL': thumbnail.isEmpty ? '-' : thumbnail,
      'Tanggal Mulai': start == null ? '-' : formatIndonesianDate(start),
      'Tanggal Selesai': end == null ? 'Masih berlangsung' : formatIndonesianDate(end),
    };
  }

  /// Menjalankan semua validator. Jika lolos, ringkasan isian ditampilkan.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in _summary().entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('${entry.key}: ${entry.value}'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Dekorasi field yang sama dengan form proyek.
  InputDecoration _decoration(String label, {String? hint, String? helper, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      suffixIcon: suffixIcon,
      errorMaxLines: 3,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  /// Membungkus [child] dengan jarak antar-field yang seragam.
  Widget _field(Key key, Widget child) {
    return Padding(key: key, padding: const EdgeInsets.all(8.0), child: child);
  }

  /// Field tanggal yang hanya bisa diisi lewat pemilih tanggal.
  Widget _dateField({
    required GlobalKey<FormFieldState<String>> fieldKey,
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      readOnly: true,
      showCursor: false,
      decoration: _decoration(
        label,
        hint: 'Pilih tanggal',
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: onTap,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience Form'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, _bottomClearance),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _field(
                      ExperienceFormPage.titleKey,
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          'Judul / Posisi',
                          hint: 'Software Engineer Intern @ Company',
                        ),
                        onChanged: (value) => setState(() => _title = value),
                        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                        validator: validateExperienceTitle,
                      ),
                    ),
                    _field(
                      ExperienceFormPage.descriptionKey,
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 6,
                        decoration: _decoration(
                          'Deskripsi',
                          hint: 'Ceritakan apa yang kamu kerjakan di sini',
                        ),
                        onChanged: (value) => setState(() => _description = value),
                        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                        validator: validateExperienceDescription,
                      ),
                    ),
                    _field(
                      ExperienceFormPage.categoryKey,
                      DropdownButtonFormField<String>(
                        initialValue: kDefaultExperienceCategory,
                        isExpanded: true,
                        decoration: _decoration('Kategori'),
                        items: _categoryItems,
                        onChanged: (value) {
                          setState(() => _category = value ?? kDefaultExperienceCategory);
                        },
                      ),
                    ),
                    _field(
                      ExperienceFormPage.thumbnailKey,
                      TextFormField(
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        decoration: _decoration(
                          'Thumbnail URL',
                          hint: 'https://.../logo.png',
                          helper: 'Opsional',
                        ),
                        onChanged: (value) => setState(() => _thumbnail = value),
                        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                        validator: validateThumbnailUrl,
                      ),
                    ),
                    _field(
                      ExperienceFormPage.startDateKey,
                      _dateField(
                        fieldKey: _startDateFieldKey,
                        controller: _startDateController,
                        label: 'Tanggal Mulai',
                        onTap: _pickStartDate,
                        validator: (_) => validateStartDate(_startDate),
                      ),
                    ),
                    _field(
                      ExperienceFormPage.endDateKey,
                      _dateField(
                        fieldKey: _endDateFieldKey,
                        controller: _endDateController,
                        label: 'Tanggal Selesai (kosongkan jika masih berjalan)',
                        onTap: _pickEndDate,
                        validator: (_) => validateEndDate(_endDate, start: _startDate),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      child: FilledButton(onPressed: _submit, child: const Text('Simpan')),
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
