import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prefs/prefs.dart';
import 'package:soft_khata_flutter/navigation/app_routes.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/ui/splash/splash_screen.dart';

/// Original Soft Khata entry (Node.js API + BLoC). Preserved for later integration.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Prefs.init();
  runApp(LegacyApp(router: AppRoutes()));
}

class LegacyApp extends StatelessWidget {
  const LegacyApp({Key? key, required this.router}) : super(key: key);

  final AppRoutes router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ThemeColors.COLOR_PRIMARY,
        scaffoldBackgroundColor: ThemeColors.COLOR_BACKGROUND,
      ),
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
