import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/screens/auth/demo_welcome_screen.dart';
import 'package:soft_khata_flutter/screens/shell/main_shell.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/demo_auth_service.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';

class DemoSplashScreen extends StatefulWidget {
  const DemoSplashScreen({super.key, this.useLaravelBackend = false});

  final bool useLaravelBackend;

  @override
  State<DemoSplashScreen> createState() => _DemoSplashScreenState();
}

class _DemoSplashScreenState extends State<DemoSplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_boot());
  }

  Future<void> _boot() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (widget.useLaravelBackend) {
      final api = context.read<LaravelApiHolder>();
      final state = context.read<AppState>();
      final token = await api.client.tokenStorage.readToken();
      if (token != null && token.isNotEmpty) {
        try {
          await state.refreshFromApi();
        } catch (_) {
          await api.client.tokenStorage.clearToken();
        }
      }
      if (!mounted) return;
      final stillLoggedIn = await api.client.tokenStorage.readToken();
      final next = stillLoggedIn != null && stillLoggedIn.isNotEmpty
          ? const MainShell()
          : DemoWelcomeScreen(useLaravelBackend: true);
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => next));
      return;
    }

    final auth = context.read<DemoAuthService>();
    await auth.ensureLoaded();
    if (!mounted) return;
    final next = auth.isLoggedIn
        ? const MainShell()
        : const DemoWelcomeScreen();
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/logo.svg', height: 96),
            const SizedBox(height: 24),
            Text(
              'Soft Khata',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: 'SemiBold'),
            ),
            const SizedBox(height: 8),
            Text(
              widget.useLaravelBackend
                  ? 'Live API · softkhata.skylinedelivery.ae/public'
                  : 'Demo mode · Local data',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
