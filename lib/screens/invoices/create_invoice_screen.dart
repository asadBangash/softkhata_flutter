import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/invoices/invoice_preview_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  String? _customerId;
  Product? _product;
  final _qty = TextEditingController(text: '1');
  final _discount = TextEditingController(text: '0');
  final _tax = TextEditingController(text: '0');
  final _paid = TextEditingController(text: '0');
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  final List<LineItem> _items = [];

  @override
  void dispose() {
    _qty.dispose();
    _discount.dispose();
    _tax.dispose();
    _paid.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (s, i) => s + i.amount);
  double get _discountVal => double.tryParse(_discount.text.trim()) ?? 0;
  double get _taxVal => double.tryParse(_tax.text.trim()) ?? 0;
  double get _grand => (_subtotal - _discountVal + _taxVal).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create invoice')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final customers = state.partiesForCurrent.where((p) => p.type == PartyType.customer).toList();
          final products = state.productsForCurrent;
          _customerId ??= customers.isNotEmpty ? customers.first.id : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                value: _customerId,
                decoration: const InputDecoration(labelText: 'Customer *'),
                items: customers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: customers.isEmpty ? null : (v) => setState(() => _customerId = v),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due date'),
                subtitle: Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
                trailing: const Icon(Icons.event),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Product>(
                value: _product,
                decoration: const InputDecoration(labelText: 'Add product line'),
                items: products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                onChanged: products.isEmpty ? null : (v) => setState(() => _product = v),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qty,
                      decoration: const InputDecoration(labelText: 'Qty'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _product == null ? null : _addLine, child: const Text('Add')),
                ],
              ),
              ..._items.asMap().entries.map((e) {
                final i = e.key;
                final item = e.value;
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(CurrencyFormat.format(item.amount)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _items.removeAt(i))),
                    ],
                  ),
                );
              }),
              TextField(
                controller: _discount,
                decoration: const InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tax,
                decoration: const InputDecoration(labelText: 'Tax'),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _paid,
                decoration: const InputDecoration(labelText: 'Paid amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Text('Total: ${CurrencyFormat.format(_grand)}', style: const TextStyle(fontFamily: 'SemiBold', fontSize: 18)),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: customers.isEmpty || _items.isEmpty ? null : () => _save(state, customers),
                child: const Text('Save invoice'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addLine() {
    final p = _product!;
    final q = double.tryParse(_qty.text.trim()) ?? 0;
    if (q <= 0) {
      DemoSnack.show(context, 'Enter valid quantity', isError: true);
      return;
    }
    setState(() {
      _items.add(LineItem(productId: p.id, name: p.name, qty: q, rate: p.sellingPrice));
    });
  }

  void _save(AppState state, List<Party> customers) {
    if (_customerId == null) return;
    final customer = customers.firstWhere((c) => c.id == _customerId);
    final paid = double.tryParse(_paid.text.trim()) ?? 0;
    final number = 'INV-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final status = paid >= _grand
        ? InvoiceStatus.paid
        : (paid <= 0 ? InvoiceStatus.unpaid : InvoiceStatus.partial);
    final due = _dueDate.isBefore(DateTime.now()) && status != InvoiceStatus.paid
        ? InvoiceStatus.overdue
        : status;

    final id = 'inv-${DateTime.now().millisecondsSinceEpoch}';
    state.addInvoice(
      InvoiceRecord(
        id: id,
        businessId: state.currentBusinessId,
        number: number,
        customerId: customer.id,
        customerName: customer.name,
        date: DateTime.now(),
        dueDate: _dueDate,
        items: List.from(_items),
        subtotal: _subtotal,
        discount: _discountVal,
        tax: _taxVal,
        grandTotal: _grand,
        paid: paid,
        status: due,
      ),
    );
    DemoSnack.show(context, 'Invoice $number created');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => InvoicePreviewScreen(invoiceId: id)),
    );
  }
}
