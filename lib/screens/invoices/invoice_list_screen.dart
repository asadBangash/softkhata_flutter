import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/invoices/create_invoice_screen.dart';
import 'package:soft_khata_flutter/screens/invoices/invoice_preview_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  int _statusFilter = 0;
  String _query = '';

  static const _statusLabels = ['All', 'Paid', 'Partial', 'Unpaid', 'Overdue'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const CreateInvoiceScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final invoices = _filter(state.invoicesForCurrent);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search invoice # or customer',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 8),
              FilterChipRow(
                labels: _statusLabels,
                selectedIndex: _statusFilter,
                onSelected: (i) => setState(() => _statusFilter = i),
              ),
              Expanded(
                child: invoices.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No invoices',
                        subtitle: 'Create professional invoices for your customers.',
                        actionLabel: 'Create invoice',
                        onAction: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const CreateInvoiceScreen()),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: invoices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final inv = invoices[i];
                          return AppCard(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => InvoicePreviewScreen(invoiceId: inv.id),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(inv.number, style: const TextStyle(fontFamily: 'SemiBold')),
                                      Text('${inv.customerName} · Due ${DateFormat('d MMM').format(inv.dueDate)}'),
                                      const SizedBox(height: 4),
                                      Text(CurrencyFormat.format(inv.grandTotal)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    StatusBadge(
                                      label: invoiceStatusLabel(inv.status),
                                      color: _statusColor(inv.status),
                                    ),
                                    if (inv.balance > 0) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Bal ${CurrencyFormat.format(inv.balance)}',
                                        style: const TextStyle(fontSize: 12, color: AppTheme.warning),
                                      ),
                                    ],
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
          MaterialPageRoute<void>(builder: (_) => const CreateInvoiceScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<InvoiceRecord> _filter(List<InvoiceRecord> all) {
    Iterable<InvoiceRecord> list = all;
    switch (_statusFilter) {
      case 1:
        list = list.where((i) => i.status == InvoiceStatus.paid);
        break;
      case 2:
        list = list.where((i) => i.status == InvoiceStatus.partial);
        break;
      case 3:
        list = list.where((i) => i.status == InvoiceStatus.unpaid);
        break;
      case 4:
        list = list.where((i) => i.status == InvoiceStatus.overdue);
        break;
      default:
        break;
    }
    if (_query.isNotEmpty) {
      list = list.where((i) {
        return i.number.toLowerCase().contains(_query) ||
            i.customerName.toLowerCase().contains(_query);
      });
    }
    return list.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
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
