import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/api/api_client.dart';
import 'package:soft_khata_flutter/data/repositories/laravel_auth_repository.dart';
import 'package:soft_khata_flutter/data/repositories/laravel_catalog_repository.dart';
import 'package:soft_khata_flutter/data/repositories/laravel_party_repository.dart';
import 'package:soft_khata_flutter/screens/shell/demo_splash_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/demo_auth_service.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';

/// Default entry: Laravel API. Local mock-only UI:
/// `flutter run -t lib/main_mock.dart`
///
/// Default API: live (https://softkhata.skylinedelivery.ae/api/v1/)
/// Local override: `--dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1/`
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final apiClient = ApiClient();
  final laravelApi = LaravelApiHolder(
    auth: LaravelAuthRepository(apiClient),
    parties: LaravelPartyRepository(apiClient),
    catalog: LaravelCatalogRepository(apiClient),
    client: apiClient,
  );

  final appState = AppState(skipSeed: true)..attachLaravel(laravelApi);

  final auth = DemoAuthService();
  await auth.ensureLoaded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<DemoAuthService>.value(value: auth),
        Provider<LaravelApiHolder>.value(value: laravelApi),
      ],
      child: const SoftKhataApp(),
    ),
  );
}

class SoftKhataApp extends StatelessWidget {
  const SoftKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soft Khata',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: const DemoSplashScreen(useLaravelBackend: true),
    );
  }
}
