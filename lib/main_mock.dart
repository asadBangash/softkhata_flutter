import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/screens/shell/demo_splash_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/demo_auth_service.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';

/// Offline demo with seeded mock data (no Laravel).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final auth = DemoAuthService();
  await auth.ensureLoaded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider<DemoAuthService>.value(value: auth),
      ],
      child: const SoftKhataMockApp(),
    ),
  );
}

class SoftKhataMockApp extends StatelessWidget {
  const SoftKhataMockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soft Khata (Mock)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const DemoSplashScreen(),
    );
  }
}
