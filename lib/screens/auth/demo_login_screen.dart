import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/screens/auth/demo_register_screen.dart';
import 'package:soft_khata_flutter/screens/shell/main_shell.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/demo_auth_service.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';
import 'package:dio/dio.dart';
import 'package:soft_khata_flutter/core/api/api_error_message.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class DemoLoginScreen extends StatefulWidget {
  const DemoLoginScreen({super.key, this.useLaravelBackend = false});

  final bool useLaravelBackend;

  @override
  State<DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends State<DemoLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.useLaravelBackend) {
      _email.text = 'demo@example.com';
      _password.text = 'password';
    } else {
      _email.text = 'demo@softkhata.app';
      _password.text = 'demo123';
    }
  }
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    if (widget.useLaravelBackend) {
      try {
        final api = context.read<LaravelApiHolder>();
        await api.auth.login(_email.text, _password.text);
        await context.read<AppState>().refreshFromApi();
      } on DioException catch (e) {
        if (!mounted) return;
        setState(() => _loading = false);
        DemoSnack.show(context, messageFromDio(e), isError: true);
        return;
      }
    } else {
      final auth = context.read<DemoAuthService>();
      final error = await auth.login(
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      if (error != null) {
        DemoSnack.show(context, error);
        return;
      }
      DemoSnack.show(context, 'Welcome back!');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const MainShell()),
        (_) => false,
      );
      return;
    }
    if (!mounted) return;
    setState(() => _loading = false);
    DemoSnack.show(context, 'Welcome back!');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign in to your business',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold'),
              ),
              const SizedBox(height: 8),
              Text(
                'Use your registered email or the demo account below.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              AppCard(
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primary.withValues(alpha: 0.9)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.useLaravelBackend
                            ? 'Demo: demo@example.com\nPassword: password'
                            : 'Demo: demo@softkhata.app\nPassword: demo123',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter your email';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter your password';
                  if (v.length < 6) return 'At least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Log in'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New to Soft Khata?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => DemoRegisterScreen(useLaravelBackend: widget.useLaravelBackend),
                        ),
                      );
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
