import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _adjustQty = TextEditingController();
  final _reason = TextEditingController(text: 'Manual adjustment');

  @override
  void dispose() {
    _adjustQty.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product detail')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          Product? product;
          for (final p in state.productsForCurrent) {
            if (p.id == widget.productId) {
              product = p;
              break;
            }
          }
          if (product == null) {
            return const EmptyState(
              icon: Icons.error_outline,
              title: 'Product not found',
              subtitle: 'It may have been removed or belongs to another business.',
            );
          }
          final p = product;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold')),
                    const SizedBox(height: 8),
                    Text('${p.category} · SKU ${p.sku}'),
                    if (p.barcode.isNotEmpty) Text('Barcode: ${p.barcode}'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (p.isOutOfStock)
                          const StatusBadge(label: 'Out of stock', color: AppTheme.danger)
                        else if (p.isLowStock)
                          const StatusBadge(label: 'Low stock', color: AppTheme.warning)
                        else
                          const StatusBadge(label: 'In stock', color: AppTheme.success),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Pricing & stock'),
              AppCard(
                child: Column(
                  children: [
                    _Row(label: 'Quantity', value: p.quantity.toString()),
                    _Row(label: 'Min stock', value: p.minStock.toString()),
                    _Row(label: 'Purchase price', value: CurrencyFormat.format(p.purchasePrice)),
                    _Row(label: 'Selling price', value: CurrencyFormat.format(p.sellingPrice)),
                    _Row(label: 'Stock value', value: CurrencyFormat.format(p.stockValue)),
                  ],
                ),
              ),
              const SectionHeader(title: 'Adjust stock'),
              TextField(
                controller: _adjustQty,
                decoration: const InputDecoration(
                  labelText: 'Change (+/-) *',
                  hintText: 'e.g. 10 or -2',
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reason,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => _adjust(state, p.id), child: const Text('Apply adjustment')),
            ],
          );
        },
      ),
    );
  }

  void _adjust(AppState state, String productId) {
    final delta = double.tryParse(_adjustQty.text.trim());
    if (delta == null || delta == 0) {
      DemoSnack.show(context, 'Enter a non-zero adjustment', isError: true);
      return;
    }
    state.adjustStock(productId, delta, reason: _reason.text.trim());
    _adjustQty.clear();
    DemoSnack.show(context, 'Stock updated');
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: const TextStyle(fontFamily: 'SemiBold')),
        ],
      ),
    );
  }
}
