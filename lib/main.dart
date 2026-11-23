import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

/// Tema aplikasi: warna indigo dan amber dari Tutorial 08.
///
/// [AppBarTheme] memakai `colorScheme.primary`, sehingga AppBar di semua
/// halaman berwarna sama tanpa perlu diatur ulang di setiap halaman.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo, secondary: Colors.amber[700]);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),
  );
}

/// Root aplikasi: MaterialApp dengan tema dari [buildAppTheme].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MyPortfolio', theme: buildAppTheme(), home: const MyHomePage());
  }
}
