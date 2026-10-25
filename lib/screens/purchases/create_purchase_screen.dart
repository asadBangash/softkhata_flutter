import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class CreatePurchaseScreen extends StatefulWidget {
  const CreatePurchaseScreen({super.key});

  @override
  State<CreatePurchaseScreen> createState() => _CreatePurchaseScreenState();
}

class _CreatePurchaseScreenState extends State<CreatePurchaseScreen> {
  String? _supplierId;
  Product? _product;
  final _qty = TextEditingController(text: '1');
  final _rate = TextEditingController();
  final _paid = TextEditingController(text: '0');
  final List<LineItem> _items = [];

  @override
  void dispose() {
    _qty.dispose();
    _rate.dispose();
    _paid.dispose();
    super.dispose();
  }

  double get _grand => _items.fold(0.0, (s, i) => s + i.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New purchase')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final suppliers = state.partiesForCurrent.where((p) => p.type == PartyType.supplier).toList();
          final products = state.productsForCurrent;
          _supplierId ??= suppliers.isNotEmpty ? suppliers.first.id : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                value: _supplierId,
                decoration: const InputDecoration(labelText: 'Supplier *'),
                items: suppliers
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                    .toList(),
                onChanged: suppliers.isEmpty ? null : (v) => setState(() => _supplierId = v),
              ),
              const SizedBox(height: 16),
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
                      onChanged: (v) {
                        setState(() {
                          _product = v;
                          if (v != null) _rate.text = v.purchasePrice.toStringAsFixed(0);
                        });
                      },
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
              TextField(
                controller: _rate,
                decoration: const InputDecoration(labelText: 'Rate'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _product == null ? null : _addLine,
                icon: const Icon(Icons.add),
                label: const Text('Add line'),
              ),
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
                controller: _paid,
                decoration: const InputDecoration(labelText: 'Paid amount'),
                keyboardType: TextInputType.number,
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
                onPressed: suppliers.isEmpty || _items.isEmpty ? null : () => _save(state, suppliers),
                child: const Text('Save purchase'),
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
    final rate = double.tryParse(_rate.text.trim()) ?? p.purchasePrice;
    if (q <= 0 || rate <= 0) {
      DemoSnack.show(context, 'Enter valid qty and rate', isError: true);
      return;
    }
    setState(() {
      _items.add(LineItem(productId: p.id, name: p.name, qty: q, rate: rate));
    });
  }

  Future<void> _save(AppState state, List<Party> suppliers) async {
    if (_supplierId == null) return;
    final supplier = suppliers.firstWhere((s) => s.id == _supplierId);
    final paid = double.tryParse(_paid.text.trim()) ?? 0;
    final purchaseNo = 'PUR-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final status = paid >= _grand
        ? InvoiceStatus.paid
        : (paid <= 0 ? InvoiceStatus.unpaid : InvoiceStatus.partial);

    try {
      await state.addPurchase(
        PurchaseRecord(
          id: 'pur-${DateTime.now().millisecondsSinceEpoch}',
          businessId: state.currentBusinessId,
          purchaseNo: purchaseNo,
          supplierId: supplier.id,
          supplierName: supplier.name,
          date: DateTime.now(),
          items: List.from(_items),
          grandTotal: _grand,
          paidAmount: paid,
          status: status,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
      return;
    }
    DemoSnack.show(context, 'Purchase $purchaseNo saved');
    Navigator.pop(context);
  }
}
