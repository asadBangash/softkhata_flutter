import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/purchases/create_purchase_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  int _dateFilter = 0;
  String _query = '';

  static const _dateLabels = ['All', 'Today', 'This month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const CreatePurchaseScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final purchases = _filter(state.purchasesForCurrent);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total purchases'),
                            Text(
                              CurrencyFormat.format(state.totalPurchases),
                              style: const TextStyle(fontFamily: 'SemiBold', fontSize: 20, color: AppTheme.primary),
                            ),
                          ],
                        ),
                      ),
                      Text('${purchases.length} records'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search purchase or supplier',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 8),
              FilterChipRow(
                labels: _dateLabels,
                selectedIndex: _dateFilter,
                onSelected: (i) => setState(() => _dateFilter = i),
              ),
              Expanded(
                child: purchases.isEmpty
                    ? EmptyState(
                        icon: Icons.shopping_cart_outlined,
                        title: 'No purchases',
                        subtitle: 'Record supplier bills to update stock and payables.',
                        actionLabel: 'New purchase',
                        onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const CreatePurchaseScreen()),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: purchases.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = purchases[i];
                          final due = p.grandTotal - p.paidAmount;
                          return AppCard(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(p.purchaseNo, style: const TextStyle(fontFamily: 'SemiBold')),
                                    ),
                                    StatusBadge(
                                      label: invoiceStatusLabel(p.status),
                                      color: _statusColor(p.status),
                                    ),
                                  ],
                                ),
                                Text('${p.supplierName} · ${DateFormat('d MMM yyyy').format(p.date)}'),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(CurrencyFormat.format(p.grandTotal), style: const TextStyle(fontFamily: 'SemiBold')),
                                    const Spacer(),
                                    if (due > 0)
                                      Text('Due ${CurrencyFormat.format(due)}', style: const TextStyle(color: AppTheme.warning, fontSize: 12)),
                                  ],
                                ),
                              ],
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const CreatePurchaseScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<PurchaseRecord> _filter(List<PurchaseRecord> all) {
    final now = DateTime.now();
    Iterable<PurchaseRecord> list = all;
    switch (_dateFilter) {
      case 1:
        list = list.where((p) => _sameDay(p.date, now));
        break;
      case 2:
        list = list.where((p) => p.date.year == now.year && p.date.month == now.month);
        break;
      default:
        break;
    }
    if (_query.isNotEmpty) {
      list = list.where((p) {
        return p.purchaseNo.toLowerCase().contains(_query) ||
            p.supplierName.toLowerCase().contains(_query);
      });
    }
    return list.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

Color _statusColor(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.paid:
      return AppTheme.success;
    case InvoiceStatus.partial:
      return AppTheme.warning;
    case InvoiceStatus.unpaid:
    case InvoiceStatus.overdue:
      return AppTheme.danger;
  }
}
