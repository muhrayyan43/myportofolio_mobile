/// Alamat dasar backend Django REST Framework.
///
/// Bawaannya `http://10.0.2.2:8000`, yaitu laptop dilihat dari emulator Android.
/// Untuk Chrome: `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000`.
/// APK rilis nanti diisi URL PWS lewat `--dart-define` yang sama.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
