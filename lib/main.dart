import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
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

class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, this.initialToken, super.key});

  final ApiClient apiClient;
  final String? initialToken;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider(create: (_) => AuthState(apiClient, initialToken: initialToken)),
      ],
      child: MaterialApp(title: 'MyPortfolio', theme: buildAppTheme(), home: const MyHomePage()),
    );
  }
}
