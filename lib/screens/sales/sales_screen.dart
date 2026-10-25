import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/sales/create_sale_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  int _dateFilter = 0;
  String _query = '';

  static const _dateLabels = ['All', 'Today', 'This month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const CreateSaleScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final sales = _filterSales(state.salesForCurrent);
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
                            const Text('Total sales'),
                            Text(
                              CurrencyFormat.format(state.totalSales),
                              style: const TextStyle(fontFamily: 'SemiBold', fontSize: 20, color: AppTheme.primary),
                            ),
                          ],
                        ),
                      ),
                      Text('${sales.length} records', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search invoice or customer',
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
                child: sales.isEmpty
                    ? EmptyState(
                        icon: Icons.point_of_sale,
                        title: 'No sales yet',
                        subtitle: 'Create a sale to update stock and customer balance.',
                        actionLabel: 'New sale',
                        onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const CreateSaleScreen()),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: sales.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final s = sales[i];
                          return AppCard(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        s.invoiceNo,
                                        style: const TextStyle(fontFamily: 'SemiBold'),
                                      ),
                                    ),
                                    StatusBadge(
                                      label: invoiceStatusLabel(s.status),
                                      color: _statusColor(s.status),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('${s.customerName} · ${DateFormat('d MMM yyyy').format(s.date)}'),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      CurrencyFormat.format(s.grandTotal),
                                      style: const TextStyle(fontFamily: 'SemiBold'),
                                    ),
                                    const Spacer(),
                                    if (s.remaining > 0)
                                      Text(
                                        'Due ${CurrencyFormat.format(s.remaining)}',
                                        style: TextStyle(color: AppTheme.warning, fontSize: 12),
                                      ),
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
          MaterialPageRoute<void>(builder: (_) => const CreateSaleScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<SaleRecord> _filterSales(List<SaleRecord> all) {
    final now = DateTime.now();
    Iterable<SaleRecord> list = all;
    switch (_dateFilter) {
      case 1:
        list = list.where((s) => _sameDay(s.date, now));
        break;
      case 2:
        list = list.where((s) => s.date.year == now.year && s.date.month == now.month);
        break;
      default:
        break;
    }
    if (_query.isNotEmpty) {
      list = list.where((s) {
        return s.invoiceNo.toLowerCase().contains(_query) ||
            s.customerName.toLowerCase().contains(_query);
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
