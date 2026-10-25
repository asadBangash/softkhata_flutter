import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class BusinessManagementScreen extends StatelessWidget {
  const BusinessManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Businesses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const _AddBusinessScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active business',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.currentBusiness.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold'),
                    ),
                    Text('${state.currentBusiness.category} · ${state.currentBusiness.owner}'),
                  ],
                ),
              ),
              const SectionHeader(title: 'Switch business'),
              ...state.businesses.map((b) {
                final selected = b.id == state.currentBusinessId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    onTap: () {
                      state.switchBusiness(b.id);
                      DemoSnack.show(context, 'Switched to ${b.name}');
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: selected
                            ? AppTheme.primary
                            : AppTheme.primary.withValues(alpha: 0.12),
                        child: Icon(
                          Icons.store,
                          color: selected ? Colors.white : AppTheme.primary,
                        ),
                      ),
                      title: Text(b.name, style: const TextStyle(fontFamily: 'SemiBold')),
                      subtitle: Text('${b.address}\n${b.phone}'),
                      isThreeLine: true,
                      trailing: selected
                          ? const Icon(Icons.check_circle, color: AppTheme.success)
                          : const Icon(Icons.chevron_right),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const _AddBusinessScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddBusinessScreen extends StatefulWidget {
  const _AddBusinessScreen();

  @override
  State<_AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<_AddBusinessScreen> {
  final _name = TextEditingController();
  final _owner = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _category = TextEditingController(text: 'General Store');

  @override
  void dispose() {
    _name.dispose();
    _owner.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _category.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add business')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Business name *')),
          const SizedBox(height: 12),
          TextField(controller: _owner, decoration: const InputDecoration(labelText: 'Owner *')),
          const SizedBox(height: 12),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone *')),
          const SizedBox(height: 12),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
          const SizedBox(height: 12),
          TextField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
          const SizedBox(height: 24),
          FilledButton(onPressed: _submit, child: const Text('Create business')),
        ],
      ),
    );
  }

  void _submit() {
    if (_name.text.trim().isEmpty || _owner.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      DemoSnack.show(context, 'Fill required fields', isError: true);
      return;
    }
    final id = 'biz-${DateTime.now().millisecondsSinceEpoch}';
    context.read<AppState>().addBusiness(
          BusinessProfile(
            id: id,
            name: _name.text.trim(),
            owner: _owner.text.trim(),
            phone: _phone.text.trim(),
            email: _email.text.trim(),
            address: _address.text.trim(),
            category: _category.text.trim(),
          ),
        );
    DemoSnack.show(context, 'Business created with demo seed data');
    Navigator.pop(context);
  }
}
