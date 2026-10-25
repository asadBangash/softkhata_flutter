import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class AddPartyScreen extends StatefulWidget {
  const AddPartyScreen({super.key, this.initialType});

  final PartyType? initialType;

  @override
  State<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _opening = TextEditingController(text: '0');
  final _notes = TextEditingController();

  late PartyType _type;
  BalanceSide _side = BalanceSide.youWillGet;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? PartyType.customer;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _opening.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add party')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<PartyType>(
              segments: const [
                ButtonSegment(value: PartyType.customer, label: Text('Customer'), icon: Icon(Icons.person)),
                ButtonSegment(value: PartyType.supplier, label: Text('Supplier'), icon: Icon(Icons.local_shipping)),
                ButtonSegment(value: PartyType.bank, label: Text('Bank'), icon: Icon(Icons.account_balance)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone *'),
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
            ),
            if (_type != PartyType.bank) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _opening,
                decoration: const InputDecoration(labelText: 'Opening balance'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<BalanceSide>(
                key: ValueKey(_side),
                initialValue: _side,
                decoration: const InputDecoration(labelText: 'Balance side'),
                items: const [
                  DropdownMenuItem(value: BalanceSide.youWillGet, child: Text('You will get')),
                  DropdownMenuItem(value: BalanceSide.youWillGive, child: Text('You will give')),
                ],
                onChanged: (v) => setState(() => _side = v ?? BalanceSide.youWillGet),
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Save party'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    final opening = double.tryParse(_opening.text.trim()) ?? 0;
    final id = 'p-${DateTime.now().millisecondsSinceEpoch}';
    final party = Party(
      id: id,
      businessId: state.currentBusinessId,
      type: _type,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      address: _address.text.trim(),
      openingBalance: opening,
      balanceSide: _side,
      notes: _notes.text.trim(),
      currentBalance: _type == PartyType.bank
          ? opening
          : (_side == BalanceSide.youWillGive ? -opening.abs() : opening.abs()),
    );
    try {
      await state.addParty(party);
      if (!context.mounted) return;
      DemoSnack.show(context, '${party.name} added');
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
    }
  }
}
