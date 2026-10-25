import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/routes/demo_navigation.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class DemoSettingsScreen extends StatefulWidget {
  const DemoSettingsScreen({super.key});

  @override
  State<DemoSettingsScreen> createState() => _DemoSettingsScreenState();
}

class _DemoSettingsScreenState extends State<DemoSettingsScreen> {
  bool _darkMode = false;
  bool _soundAlerts = true;
  bool _paymentReminders = true;
  bool _lowStockAlerts = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(title: 'Appearance'),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SwitchListTile(
                  title: const Text('Dark mode'),
                  subtitle: const Text('Demo toggle — does not change theme yet'),
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
              ),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  title: const Text('Language'),
                  subtitle: Text(_language),
                  trailing: DropdownButton<String>(
                    value: _language,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'English', child: Text('English')),
                      DropdownMenuItem(value: 'Urdu', child: Text('Urdu')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _language = v);
                    },
                  ),
                ),
              ),
              const SectionHeader(title: 'Notifications'),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Sound alerts'),
                      value: _soundAlerts,
                      onChanged: (v) => setState(() => _soundAlerts = v),
                    ),
                    SwitchListTile(
                      title: const Text('Payment reminders'),
                      value: _paymentReminders,
                      onChanged: (v) => setState(() => _paymentReminders = v),
                    ),
                    SwitchListTile(
                      title: const Text('Low stock alerts'),
                      value: _lowStockAlerts,
                      onChanged: (v) => setState(() => _lowStockAlerts = v),
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Business'),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Manage businesses'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => DemoNavigation.openBusinessManagement(context),
                    ),
                    ListTile(
                      title: const Text('Currency'),
                      subtitle: Text(state.currentBusiness.currency),
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Security'),
              AppCard(
                child: ListTile(
                  title: const Text('PIN & biometrics'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => DemoNavigation.openSecurity(context),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => DemoSnack.show(context, 'Settings saved (demo)'),
                child: const Text('Save settings'),
              ),
            ],
          );
        },
      ),
    );
  }
}
