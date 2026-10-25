import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_khata_flutter/screens/auth/demo_login_screen.dart';
import 'package:soft_khata_flutter/screens/auth/demo_register_screen.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';

class DemoWelcomeScreen extends StatelessWidget {
  const DemoWelcomeScreen({super.key, this.useLaravelBackend = false});

  final bool useLaravelBackend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset('assets/icons/logo.svg', height: 88),
              const SizedBox(height: 20),
              Text(
                'Soft Khata',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'SemiBold',
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Digital khata & business ledger for Pakistani shops',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DemoLoginScreen(useLaravelBackend: useLaravelBackend),
                      ),
                    );
                  },
                  child: const Text('Log in'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DemoRegisterScreen(useLaravelBackend: useLaravelBackend),
                      ),
                    );
                  },
                  child: const Text('Create account'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Demo mode — no server required',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
