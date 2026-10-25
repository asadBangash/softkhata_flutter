import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => DemoSnack.show(context, 'Share PDF (demo)'),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          InvoiceRecord? inv;
          for (final i in state.invoicesForCurrent) {
            if (i.id == invoiceId) {
              inv = i;
              break;
            }
          }
          if (inv == null) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Invoice not found',
            );
          }
          final business = state.currentBusiness;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(business.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold')),
                    Text(business.address),
                    Text(business.phone),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bill to'),
                            Text(inv.customerName, style: const TextStyle(fontFamily: 'SemiBold')),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Invoice ${inv.number}', style: const TextStyle(fontFamily: 'SemiBold')),
                            Text('Date: ${DateFormat('d MMM yyyy').format(inv.date)}'),
                            Text('Due: ${DateFormat('d MMM yyyy').format(inv.dueDate)}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StatusBadge(
                      label: invoiceStatusLabel(inv.status),
                      color: _statusColor(inv.status),
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Items'),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const ListTile(
                      title: Text('Item', style: TextStyle(fontFamily: 'SemiBold')),
                      trailing: Text('Amount', style: TextStyle(fontFamily: 'SemiBold')),
                    ),
                    ...inv.items.map(
                      (item) => ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.qty} × ${CurrencyFormat.format(item.rate)}'),
                        trailing: Text(CurrencyFormat.format(item.amount)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    _TotalRow(label: 'Subtotal', value: CurrencyFormat.format(inv.subtotal)),
                    _TotalRow(label: 'Discount', value: CurrencyFormat.format(inv.discount)),
                    _TotalRow(label: 'Tax', value: CurrencyFormat.format(inv.tax)),
                    const Divider(),
                    _TotalRow(
                      label: 'Grand total',
                      value: CurrencyFormat.format(inv.grandTotal),
                      bold: true,
                    ),
                    _TotalRow(label: 'Paid', value: CurrencyFormat.format(inv.paid)),
                    _TotalRow(
                      label: 'Balance',
                      value: CurrencyFormat.format(inv.balance),
                      bold: true,
                      color: inv.balance > 0 ? AppTheme.warning : AppTheme.success,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: bold ? 'SemiBold' : 'Regular',
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
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
