import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/stock/product_detail_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class StockBookScreen extends StatefulWidget {
  const StockBookScreen({super.key});

  @override
  State<StockBookScreen> createState() => _StockBookScreenState();
}

class _StockBookScreenState extends State<StockBookScreen> {
  int _filter = 0;
  String _query = '';

  static const _filters = ['All', 'Low stock', 'Out of stock'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => _openAddProduct(context),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final products = _filterProducts(state.productsForCurrent);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Stock value', style: Theme.of(context).textTheme.labelMedium),
                            Text(
                              CurrencyFormat.format(state.stockValue),
                              style: const TextStyle(fontFamily: 'SemiBold', fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      if (state.lowStockCount > 0)
                        StatusBadge(
                          label: '${state.lowStockCount} low',
                          color: AppTheme.warning,
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search product, SKU, category',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 8),
              FilterChipRow(
                labels: _filters,
                selectedIndex: _filter,
                onSelected: (i) => setState(() => _filter = i),
              ),
              Expanded(
                child: products.isEmpty
                    ? EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No products',
                        subtitle: 'Add products to track stock and sales.',
                        actionLabel: 'Add product',
                        onAction: () => _openAddProduct(context),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = products[i];
                          return AppCard(
                            padding: EdgeInsets.zero,
                            onTap: () => _openDetail(context, p.id),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                                child: const Icon(Icons.inventory_2_outlined, color: AppTheme.primary),
                              ),
                              title: Text(p.name, style: const TextStyle(fontFamily: 'SemiBold')),
                              subtitle: Text('${p.category} · SKU ${p.sku} · ${_unitLabel(p.unit)}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    p.quantity.toStringAsFixed(p.quantity.truncateToDouble() == p.quantity ? 0 : 1),
                                    style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      color: p.isOutOfStock
                                          ? AppTheme.danger
                                          : (p.isLowStock ? AppTheme.warning : AppTheme.success),
                                    ),
                                  ),
                                  Text(CurrencyFormat.format(p.sellingPrice)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddProduct(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openDetail(BuildContext context, String productId) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => ProductDetailScreen(productId: productId)),
    );
  }

  void _openAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const AddProductScreen()),
    );
  }

  List<Product> _filterProducts(List<Product> all) {
    Iterable<Product> list = all;
    switch (_filter) {
      case 1:
        list = list.where((p) => p.isLowStock);
        break;
      case 2:
        list = list.where((p) => p.isOutOfStock);
        break;
      default:
        break;
    }
    if (_query.isNotEmpty) {
      list = list.where((p) {
        return p.name.toLowerCase().contains(_query) ||
            p.sku.toLowerCase().contains(_query) ||
            p.category.toLowerCase().contains(_query);
      });
    }
    return list.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}

String _unitLabel(ProductUnit u) {
  switch (u) {
    case ProductUnit.pieces:
      return 'Pcs';
    case ProductUnit.kg:
      return 'Kg';
    case ProductUnit.gram:
      return 'g';
    case ProductUnit.liter:
      return 'L';
    case ProductUnit.meter:
      return 'm';
    case ProductUnit.box:
      return 'Box';
    case ProductUnit.pack:
      return 'Pack';
  }
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _name = TextEditingController();
  final _category = TextEditingController();
  final _sku = TextEditingController();
  final _purchase = TextEditingController();
  final _selling = TextEditingController();
  final _qty = TextEditingController(text: '0');
  final _minStock = TextEditingController(text: '5');
  ProductUnit _unit = ProductUnit.pieces;

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _sku.dispose();
    _purchase.dispose();
    _selling.dispose();
    _qty.dispose();
    _minStock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add product')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name *')),
          const SizedBox(height: 12),
          TextField(controller: _category, decoration: const InputDecoration(labelText: 'Category *')),
          const SizedBox(height: 12),
          TextField(controller: _sku, decoration: const InputDecoration(labelText: 'SKU *')),
          const SizedBox(height: 12),
          DropdownButtonFormField<ProductUnit>(
            value: _unit,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: ProductUnit.values
                .map((u) => DropdownMenuItem(value: u, child: Text(_unitLabel(u))))
                .toList(),
            onChanged: (v) => setState(() => _unit = v ?? ProductUnit.pieces),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _purchase,
            decoration: const InputDecoration(labelText: 'Purchase price *'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _selling,
            decoration: const InputDecoration(labelText: 'Selling price *'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _qty,
            decoration: const InputDecoration(labelText: 'Opening quantity'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _minStock,
            decoration: const InputDecoration(labelText: 'Minimum stock alert'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _submit, child: const Text('Save product')),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final purchase = double.tryParse(_purchase.text.trim());
    final selling = double.tryParse(_selling.text.trim());
    final qty = double.tryParse(_qty.text.trim()) ?? 0;
    final minStock = double.tryParse(_minStock.text.trim()) ?? 5;
    if (_name.text.trim().isEmpty ||
        _category.text.trim().isEmpty ||
        _sku.text.trim().isEmpty ||
        purchase == null ||
        selling == null) {
      DemoSnack.show(context, 'Fill required fields with valid numbers', isError: true);
      return;
    }
    final state = context.read<AppState>();
    final id = 'prod-${DateTime.now().millisecondsSinceEpoch}';
    try {
      await state.addProduct(
        Product(
          id: id,
          businessId: state.currentBusinessId,
          name: _name.text.trim(),
          category: _category.text.trim(),
          sku: _sku.text.trim(),
          purchasePrice: purchase,
          sellingPrice: selling,
          quantity: qty,
          minStock: minStock,
          unit: _unit,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
      return;
    }
    DemoSnack.show(context, 'Product added');
    Navigator.pop(context);
  }
}
