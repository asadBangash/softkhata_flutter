import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({
    super.key,
    required this.initialKind,
    this.partyId,
  });

  final TransactionKind initialKind;
  final String? partyId;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _notes = TextEditingController();

  late TransactionKind _kind;
  String? _partyId;
  PaymentMethod _method = PaymentMethod.cash;
  bool _recordCash = true;

  @override
  void initState() {
    super.initState();
    _kind = widget.initialKind;
    _partyId = widget.partyId;
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _kind == TransactionKind.receive ? 'Receive payment' : 'Give payment';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final parties = state.partiesForCurrent
              .where((p) => p.type != PartyType.bank)
              .toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<TransactionKind>(
                segments: const [
                  ButtonSegment(
                    value: TransactionKind.receive,
                    label: Text('Receive'),
                    icon: Icon(Icons.call_received),
                  ),
                  ButtonSegment(
                    value: TransactionKind.give,
                    label: Text('Give'),
                    icon: Icon(Icons.call_made),
                  ),
                ],
                selected: {_kind},
                onSelectionChanged: (s) => setState(() => _kind = s.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(_partyId),
                initialValue: _partyId ?? (parties.isNotEmpty ? parties.first.id : null),
                decoration: const InputDecoration(labelText: 'Party *'),
                items: parties
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: parties.isEmpty ? null : (v) => setState(() => _partyId = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amount,
                decoration: const InputDecoration(labelText: 'Amount *'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: _kind == TransactionKind.receive ? 'Payment received' : 'Payment given',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PaymentMethod>(
                key: ValueKey(_method),
                initialValue: _method,
                decoration: const InputDecoration(labelText: 'Payment method'),
                items: PaymentMethod.values
                    .map((m) => DropdownMenuItem(value: m, child: Text(paymentMethodLabel(m))))
                    .toList(),
                onChanged: (v) => setState(() => _method = v ?? PaymentMethod.cash),
              ),
              SwitchListTile(
                title: const Text('Update cash in hand'),
                subtitle: const Text('Adds matching cash book entry'),
                value: _recordCash,
                onChanged: (v) => setState(() => _recordCash = v),
              ),
              TextField(
                controller: _notes,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: parties.isEmpty ? null : () => _submit(state),
                child: const Text('Save transaction'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit(AppState state) async {
    final amount = double.tryParse(_amount.text.trim());
    if (_partyId == null || amount == null || amount <= 0) {
      DemoSnack.show(context, 'Enter a valid party and amount', isError: true);
      return;
    }
    try {
      await state.addLedgerTransaction(
        partyId: _partyId!,
        kind: _kind,
        amount: amount,
        description: _description.text.trim().isEmpty
            ? (_kind == TransactionKind.receive ? 'Payment received' : 'Payment given')
            : _description.text.trim(),
        paymentMethod: _method,
        notes: _notes.text.trim(),
        recordCash: state.usesLaravel ? false : _recordCash,
      );
      if (!context.mounted) return;
      DemoSnack.show(context, 'Transaction saved');
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
      return;
    }
    Navigator.pop(context);
  }
}
