import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/screens/auth/demo_login_screen.dart';
import 'package:soft_khata_flutter/screens/shell/main_shell.dart';
import 'package:dio/dio.dart';
import 'package:soft_khata_flutter/core/api/api_error_message.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/demo_auth_service.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class DemoRegisterScreen extends StatefulWidget {
  const DemoRegisterScreen({super.key, this.useLaravelBackend = false});

  final bool useLaravelBackend;

  @override
  State<DemoRegisterScreen> createState() => _DemoRegisterScreenState();
}

class _DemoRegisterScreenState extends State<DemoRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _businessName = TextEditingController();
  String _businessCategory = 'General Store';
  bool _obscure = true;
  bool _loading = false;

  static const _categories = [
    'General Store',
    'Wholesale',
    'Retail',
    'Pharmacy',
    'Restaurant',
    'Services',
    'Other',
  ];

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _businessName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    if (widget.useLaravelBackend) {
      try {
        final api = context.read<LaravelApiHolder>();
        await api.auth.register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          passwordConfirmation: _confirmPassword.text,
          businessName: _businessName.text.trim(),
          phone: _phone.text.trim(),
          businessCategory: _businessCategory,
        );
        await context.read<AppState>().refreshFromApi();
      } on DioException catch (e) {
        if (!mounted) return;
        setState(() => _loading = false);
        DemoSnack.show(context, messageFromDio(e), isError: true);
        return;
      }
    } else {
      final auth = context.read<DemoAuthService>();
      final error = await auth.register(
        name: _name.text,
        phone: _phone.text,
        email: _email.text,
        password: _password.text,
        businessName: _businessName.text,
        businessCategory: _businessCategory,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      if (error != null) {
        DemoSnack.show(context, error);
        return;
      }
    }
    if (!mounted) return;
    setState(() => _loading = false);
    DemoSnack.show(context, 'Account created successfully');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Register your business',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold'),
              ),
              const SizedBox(height: 8),
              Text(
                widget.useLaravelBackend
                    ? 'Your business will be created on the Soft Khata server.'
                    : 'All data stays on this device for the demo.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) =>
                    v == null || v.trim().length < 2 ? 'Enter your name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]'))],
                decoration: const InputDecoration(labelText: 'Mobile number'),
                validator: (v) =>
                    v == null || v.replaceAll(RegExp(r'\D'), '').length < 10
                        ? 'Enter a valid mobile number'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _businessName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Business name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter business name' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(_businessCategory),
                initialValue: _businessCategory,
                decoration: const InputDecoration(labelText: 'Business category'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _businessCategory = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password (min 8 characters)',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.length < 8) {
                    return 'At least 8 characters (server requirement)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPassword,
                obscureText: _obscure,
                decoration: const InputDecoration(labelText: 'Confirm password'),
                validator: (v) {
                  if (v != _password.text) return 'Passwords do not match';
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
                    : const Text('Create account'),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => DemoLoginScreen(useLaravelBackend: widget.useLaravelBackend),
                        ),
                      );
                    },
                    child: const Text('Log in'),
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
