import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class CashBookScreen extends StatefulWidget {
  const CashBookScreen({super.key});

  @override
  State<CashBookScreen> createState() => _CashBookScreenState();
}

class _CashBookScreenState extends State<CashBookScreen> {
  int _dateFilter = 0;
  int _flowFilter = 0;

  static const _dateLabels = ['Today', 'This week', 'This month', 'All'];
  static const _flowLabels = ['All', 'Cash in', 'Cash out'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash book')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final entries = _filterEntries(state.cashForCurrent);
          final inTotal = entries.where((e) => e.isInflow).fold(0.0, (s, e) => s + e.amount);
          final outTotal = entries.where((e) => !e.isInflow).fold(0.0, (s, e) => s + e.amount);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cash in hand',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              CurrencyFormat.format(state.cashInHand),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontFamily: 'SemiBold',
                                    color: AppTheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _MiniStat(
                                    label: 'In (filtered)',
                                    amount: inTotal,
                                    color: AppTheme.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _MiniStat(
                                    label: 'Out (filtered)',
                                    amount: outTotal,
                                    color: AppTheme.danger,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilterChipRow(
                        labels: _dateLabels,
                        selectedIndex: _dateFilter,
                        onSelected: (i) => setState(() => _dateFilter = i),
                      ),
                      const SizedBox(height: 8),
                      FilterChipRow(
                        labels: _flowLabels,
                        selectedIndex: _flowFilter,
                        onSelected: (i) => setState(() => _flowFilter = i),
                      ),
                      const SectionHeader(title: 'Entries'),
                    ],
                  ),
                ),
              ),
              if (entries.isEmpty)
                const SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'No cash entries',
                    subtitle: 'Record cash in or cash out to track your drawer.',
                  ),
                )
              else
                SliverList.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: (e.isInflow ? AppTheme.success : AppTheme.danger)
                                .withValues(alpha: 0.12),
                            child: Icon(
                              e.isInflow ? Icons.arrow_downward : Icons.arrow_upward,
                              color: e.isInflow ? AppTheme.success : AppTheme.danger,
                              size: 20,
                            ),
                          ),
                          title: Text(e.description, style: const TextStyle(fontFamily: 'SemiBold')),
                          subtitle: Text(
                            '${e.category} · ${paymentMethodLabel(e.paymentMethod)} · ${_fmtDate(e.date)}',
                          ),
                          trailing: AmountChip(
                            amount: e.isInflow ? e.amount : -e.amount,
                            compact: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 88)),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'cash_in',
            onPressed: () => _openForm(context, isInflow: true),
            icon: const Icon(Icons.add),
            label: const Text('Cash in'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'cash_out',
            backgroundColor: AppTheme.danger,
            onPressed: () => _openForm(context, isInflow: false),
            icon: const Icon(Icons.remove),
            label: const Text('Cash out'),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, {required bool isInflow}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _CashEntryFormScreen(isInflow: isInflow),
      ),
    );
  }

  List<CashEntry> _filterEntries(List<CashEntry> all) {
    final now = DateTime.now();
    Iterable<CashEntry> list = all;

    switch (_dateFilter) {
      case 0:
        list = list.where((e) => _sameDay(e.date, now));
        break;
      case 1:
        final start = now.subtract(Duration(days: now.weekday - 1));
        list = list.where((e) => !e.date.isBefore(DateTime(start.year, start.month, start.day)));
        break;
      case 2:
        list = list.where((e) => e.date.year == now.year && e.date.month == now.month);
        break;
      default:
        break;
    }

    switch (_flowFilter) {
      case 1:
        list = list.where((e) => e.isInflow);
        break;
      case 2:
        list = list.where((e) => !e.isInflow);
        break;
      default:
        break;
    }

    final result = list.toList()..sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _fmtDate(DateTime d) => DateFormat('d MMM, h:mm a').format(d);
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.amount, required this.color});

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(
            CurrencyFormat.formatCompact(amount),
            style: TextStyle(fontFamily: 'SemiBold', color: color),
          ),
        ],
      ),
    );
  }
}

class _CashEntryFormScreen extends StatefulWidget {
  const _CashEntryFormScreen({required this.isInflow});

  final bool isInflow;

  @override
  State<_CashEntryFormScreen> createState() => _CashEntryFormScreenState();
}

class _CashEntryFormScreenState extends State<_CashEntryFormScreen> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  PaymentMethod _method = PaymentMethod.cash;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _category.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isInflow ? 'Cash in' : 'Cash out';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _amount,
            decoration: const InputDecoration(labelText: 'Amount *'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _category,
            decoration: InputDecoration(
              labelText: 'Category *',
              hintText: widget.isInflow ? 'Collection' : 'Expense',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Description *'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<PaymentMethod>(
            value: _method,
            decoration: const InputDecoration(labelText: 'Payment method'),
            items: PaymentMethod.values
                .map((m) => DropdownMenuItem(value: m, child: Text(paymentMethodLabel(m))))
                .toList(),
            onChanged: (v) => setState(() => _method = v ?? PaymentMethod.cash),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date'),
            subtitle: Text(DateFormat('d MMM yyyy, h:mm a').format(_date)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 1)),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _submit, child: Text('Save $title')),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim());
    final category = _category.text.trim();
    final description = _description.text.trim();
    if (amount == null || amount <= 0 || category.isEmpty || description.isEmpty) {
      DemoSnack.show(context, 'Fill amount, category, and description', isError: true);
      return;
    }
    try {
      await context.read<AppState>().addCashEntry(
            isInflow: widget.isInflow,
            amount: amount,
            category: category,
            description: description,
            paymentMethod: _method,
            date: _date,
          );
      if (!context.mounted) return;
      DemoSnack.show(context, widget.isInflow ? 'Cash in recorded' : 'Cash out recorded');
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
    }
  }
}
