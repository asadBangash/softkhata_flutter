import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/transactions/transaction_form_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _filter = 0;
  static const _labels = ['All', 'Receive', 'Give', 'Cash'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final items = _buildFeed(state);
          return Column(
            children: [
              FilterChipRow(
                labels: _labels,
                selectedIndex: _filter,
                onSelected: (i) => setState(() => _filter = i),
              ),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(
                        icon: Icons.swap_horiz,
                        title: 'No transactions yet',
                        subtitle: 'Record receive or give payments to get started.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) => items[i],
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'txn_give',
            onPressed: () => _open(context, TransactionKind.give),
            child: const Icon(Icons.call_made),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'txn_recv',
            onPressed: () => _open(context, TransactionKind.receive),
            child: const Icon(Icons.call_received),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, TransactionKind kind) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => TransactionFormScreen(initialKind: kind)),
    );
  }

  List<Widget> _buildFeed(AppState state) {
    final widgets = <_TxnRow>[];

    if (_filter == 0 || _filter == 1 || _filter == 2) {
      for (final party in state.partiesForCurrent) {
        for (final e in state.ledgerForParty(party.id)) {
          if (e.kind != TransactionKind.receive && e.kind != TransactionKind.give) continue;
          if (_filter == 1 && e.kind != TransactionKind.receive) continue;
          if (_filter == 2 && e.kind != TransactionKind.give) continue;
          widgets.add(_TxnRow(
            date: e.date,
            title: e.description,
            subtitle: party.name,
            amount: e.kind == TransactionKind.receive ? e.credit : -e.debit,
            kind: e.kind,
          ));
        }
      }
    }

    if (_filter == 0 || _filter == 3) {
      for (final c in state.cashForCurrent) {
        widgets.add(_TxnRow(
          date: c.date,
          title: c.description,
          subtitle: 'Cash · ${c.category}',
          amount: c.isInflow ? c.amount : -c.amount,
          kind: c.isInflow ? TransactionKind.receive : TransactionKind.give,
        ));
      }
    }

    widgets.sort((a, b) => b.date.compareTo(a.date));
    return widgets.map((r) => r.build(context)).toList();
  }
}

class _TxnRow {
  _TxnRow({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.kind,
  });

  final DateTime date;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionKind kind;

  Widget build(BuildContext context) {
    final isRecv = amount >= 0;
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (isRecv ? AppTheme.success : AppTheme.danger).withValues(alpha: 0.12),
            child: Icon(
              isRecv ? Icons.call_received : Icons.call_made,
              color: isRecv ? AppTheme.success : AppTheme.danger,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'SemiBold')),
                Text(subtitle),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          AmountChip(amount: amount, compact: true),
        ],
      ),
    );
  }
}
