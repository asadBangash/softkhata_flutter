import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/staff/staff_book_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  StaffRole _selectedRole = StaffRole.cashier;

  static const _modules = [
    _PermModule('Parties & ledger', Icons.people_outline),
    _PermModule('Cash book', Icons.payments_outlined),
    _PermModule('Stock', Icons.inventory_2_outlined),
    _PermModule('Sales & purchases', Icons.point_of_sale),
    _PermModule('Invoices', Icons.receipt_long_outlined),
    _PermModule('Expenses', Icons.money_off_csred_outlined),
    _PermModule('Reports', Icons.bar_chart),
    _PermModule('Staff & users', Icons.admin_panel_settings_outlined),
  ];

  final Map<String, bool> _access = {};

  @override
  void initState() {
    super.initState();
    _applyRoleDefaults(_selectedRole);
  }

  void _applyRoleDefaults(StaffRole role) {
    _access.clear();
    for (final m in _modules) {
      switch (role) {
        case StaffRole.owner:
        case StaffRole.admin:
          _access[m.title] = true;
          break;
        case StaffRole.accountant:
          _access[m.title] = m.title != 'Staff & users';
          break;
        case StaffRole.cashier:
          _access[m.title] = {
            'Parties & ledger',
            'Cash book',
            'Sales & purchases',
          }.contains(m.title);
          break;
        case StaffRole.salesman:
          _access[m.title] = {
            'Parties & ledger',
            'Stock',
            'Sales & purchases',
            'Invoices',
          }.contains(m.title);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roles & permissions')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.currentBusiness.name, style: const TextStyle(fontFamily: 'SemiBold')),
                    Text(
                      'Demo permission matrix — changes are local only.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Role template'),
              DropdownButtonFormField<StaffRole>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: StaffRole.values
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(staffRoleLabel(r)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _selectedRole = v;
                    _applyRoleDefaults(v);
                  });
                },
              ),
              const SectionHeader(title: 'Module access'),
              ..._modules.map(
                (m) => AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SwitchListTile(
                    secondary: Icon(m.icon, color: AppTheme.primary),
                    title: Text(m.title),
                    value: _access[m.title] ?? false,
                    onChanged: (v) => setState(() => _access[m.title] = v),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => DemoSnack.show(context, 'Permissions saved (demo)'),
                child: const Text('Save permissions'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PermModule {
  const _PermModule(this.title, this.icon);

  final String title;
  final IconData icon;
}
