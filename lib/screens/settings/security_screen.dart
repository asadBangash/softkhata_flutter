import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _pinEnabled = true;
  bool _biometricEnabled = false;
  bool _autoLock = true;
  final _pin = TextEditingController();
  final _confirmPin = TextEditingController();

  @override
  void dispose() {
    _pin.dispose();
    _confirmPin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'App lock'),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('PIN lock'),
                  subtitle: const Text('Require PIN when opening the app'),
                  value: _pinEnabled,
                  onChanged: (v) => setState(() => _pinEnabled = v),
                ),
                SwitchListTile(
                  title: const Text('Biometric unlock'),
                  subtitle: const Text('Fingerprint / Face ID (demo)'),
                  value: _biometricEnabled,
                  onChanged: _pinEnabled
                      ? (v) => setState(() => _biometricEnabled = v)
                      : null,
                ),
                SwitchListTile(
                  title: const Text('Auto-lock after 5 min'),
                  value: _autoLock,
                  onChanged: (v) => setState(() => _autoLock = v),
                ),
              ],
            ),
          ),
          if (_pinEnabled) ...[
            const SectionHeader(title: 'Change PIN'),
            TextField(
              controller: _pin,
              decoration: const InputDecoration(labelText: 'New PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPin,
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
          ],
          const SectionHeader(title: 'Session'),
          AppCard(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out all devices'),
              subtitle: const Text('Demo — no remote sessions'),
              onTap: () => DemoSnack.show(context, 'All sessions cleared (demo)'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: const Text('Save security settings'),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_pinEnabled) {
      final a = _pin.text.trim();
      final b = _confirmPin.text.trim();
      if (a.length != 4 || a != b) {
        DemoSnack.show(context, 'PIN must be 4 digits and match', isError: true);
        return;
      }
    }
    DemoSnack.show(context, 'Security settings updated (demo)');
    Navigator.pop(context);
  }
}
