import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class ExpenseBookScreen extends StatefulWidget {
  const ExpenseBookScreen({super.key});

  @override
  State<ExpenseBookScreen> createState() => _ExpenseBookScreenState();
}

class _ExpenseBookScreenState extends State<ExpenseBookScreen> {
  int _dateFilter = 0;
  String _categoryFilter = 'All';

  static const _dateLabels = ['All', 'Today', 'This month'];
  static const _categories = ['All', 'Rent', 'Utilities', 'Salary', 'Transport', 'Misc'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final expenses = _filter(state.expensesForCurrent);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.trending_down, color: AppTheme.danger),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total expenses'),
                            Text(
                              CurrencyFormat.format(state.totalExpenses),
                              style: const TextStyle(fontFamily: 'SemiBold', fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FilterChipRow(
                labels: _dateLabels,
                selectedIndex: _dateFilter,
                onSelected: (i) => setState(() => _dateFilter = i),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: _categories.map((c) {
                    final selected = _categoryFilter == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(c),
                        selected: selected,
                        onSelected: (_) => setState(() => _categoryFilter = c),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: expenses.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_outlined,
                        title: 'No expenses',
                        subtitle: 'Track rent, bills, and daily spending.',
                        actionLabel: 'Add expense',
                        onAction: () => _openForm(context),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: expenses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final e = expenses[i];
                          return AppCard(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.danger.withValues(alpha: 0.12),
                                child: const Icon(Icons.money_off, color: AppTheme.danger, size: 20),
                              ),
                              title: Text(e.description, style: const TextStyle(fontFamily: 'SemiBold')),
                              subtitle: Text(
                                '${e.category} · ${paymentMethodLabel(e.paymentMethod)} · ${DateFormat('d MMM yyyy').format(e.date)}',
                              ),
                              trailing: Text(
                                CurrencyFormat.format(e.amount),
                                style: const TextStyle(fontFamily: 'SemiBold', color: AppTheme.danger),
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
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const _AddExpenseScreen()),
    );
  }

  List<ExpenseRecord> _filter(List<ExpenseRecord> all) {
    final now = DateTime.now();
    Iterable<ExpenseRecord> list = all;
    switch (_dateFilter) {
      case 1:
        list = list.where((e) => _sameDay(e.date, now));
        break;
      case 2:
        list = list.where((e) => e.date.year == now.year && e.date.month == now.month);
        break;
      default:
        break;
    }
    if (_categoryFilter != 'All') {
      list = list.where((e) => e.category.toLowerCase() == _categoryFilter.toLowerCase());
    }
    return list.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _AddExpenseScreen extends StatefulWidget {
  const _AddExpenseScreen();

  @override
  State<_AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<_AddExpenseScreen> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _reference = TextEditingController();
  String _category = 'Misc';
  PaymentMethod _method = PaymentMethod.cash;
  DateTime _date = DateTime.now();

  static const _categories = ['Rent', 'Utilities', 'Salary', 'Transport', 'Misc'];

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _reference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add expense')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _category = v ?? 'Misc'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            decoration: const InputDecoration(labelText: 'Amount *'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Description *'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reference,
            decoration: const InputDecoration(labelText: 'Reference'),
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
            subtitle: Text(DateFormat('d MMM yyyy').format(_date)),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _submit, child: const Text('Save expense')),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0 || _description.text.trim().isEmpty) {
      DemoSnack.show(context, 'Enter amount and description', isError: true);
      return;
    }
    final state = context.read<AppState>();
    try {
      await state.addExpense(
        ExpenseRecord(
          id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
          businessId: state.currentBusinessId,
          category: _category,
          amount: amount,
          date: _date,
          paymentMethod: _method,
          description: _description.text.trim(),
          reference: _reference.text.trim(),
        ),
      );
      if (!context.mounted) return;
      DemoSnack.show(context, 'Expense recorded');
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      DemoSnack.show(context, e.toString(), isError: true);
    }
  }
}
