import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class CreateSaleScreen extends StatefulWidget {
  const CreateSaleScreen({super.key});

  @override
  State<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen> {
  String? _customerId;
  Product? _product;
  final _qty = TextEditingController(text: '1');
  final _discount = TextEditingController(text: '0');
  final _tax = TextEditingController(text: '0');
  final _received = TextEditingController(text: '0');
  final _notes = TextEditingController();
  final List<LineItem> _items = [];

  @override
  void dispose() {
    _qty.dispose();
    _discount.dispose();
    _tax.dispose();
    _received.dispose();
    _notes.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (s, i) => s + i.amount);
  double get _discountVal => double.tryParse(_discount.text.trim()) ?? 0;
  double get _taxVal => double.tryParse(_tax.text.trim()) ?? 0;
  double get _grand => (_subtotal - _discountVal + _taxVal).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New sale')),
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
                items: customers
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: customers.isEmpty ? null : (v) => setState(() => _customerId = v),
              ),
              const SizedBox(height: 16),
              const Text('Line items', style: TextStyle(fontFamily: 'SemiBold')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<Product>(
                      value: _product,
                      decoration: const InputDecoration(labelText: 'Product'),
                      items: products
                          .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                          .toList(),
                      onChanged: products.isEmpty ? null : (v) => setState(() => _product = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _qty,
                      decoration: const InputDecoration(labelText: 'Qty'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _product == null ? null : _addLine,
                  icon: const Icon(Icons.add),
                  label: const Text('Add line'),
                ),
              ),
              if (_items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Add at least one product line.'),
                )
              else
                ..._items.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name),
                    subtitle: Text('${item.qty} × ${CurrencyFormat.format(item.rate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(CurrencyFormat.format(item.amount)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _items.removeAt(i)),
                        ),
                      ],
                    ),
                  );
                }),
              const Divider(height: 32),
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
                controller: _received,
                decoration: const InputDecoration(labelText: 'Amount received'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Grand total', style: TextStyle(fontFamily: 'SemiBold')),
                    Text(CurrencyFormat.format(_grand), style: const TextStyle(fontFamily: 'SemiBold', fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: customers.isEmpty || _items.isEmpty ? null : () => _save(state, customers),
                child: const Text('Save sale'),
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

  Future<void> _save(AppState state, List<Party> customers) async {
    if (_customerId == null) return;
    final customer = customers.firstWhere((c) => c.id == _customerId);
    final received = double.tryParse(_received.text.trim()) ?? 0;
    final invoiceNo = 'SAL-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final status = _invoiceStatus(_grand, received);

    try {
      await state.addSale(
        SaleRecord(
          id: 'sale-${DateTime.now().millisecondsSinceEpoch}',
          businessId: state.currentBusinessId,
          invoiceNo: invoiceNo,
          customerId: customer.id,
          customerName: customer.name,
          date: DateTime.now(),
          items: List.from(_items),
          subtotal: _subtotal,
          discount: _discountVal,
          tax: _taxVal,
          grandTotal: _grand,
          amountReceived: received,
          status: status,
          notes: _notes.text.trim(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
      return;
    }
    DemoSnack.show(context, 'Sale $invoiceNo saved');
    Navigator.pop(context);
  }

  InvoiceStatus _invoiceStatus(double grand, double paid) {
    if (paid >= grand) return InvoiceStatus.paid;
    if (paid <= 0) return InvoiceStatus.unpaid;
    return InvoiceStatus.partial;
  }
}
