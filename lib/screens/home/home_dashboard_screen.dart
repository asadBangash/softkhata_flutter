import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/routes/demo_navigation.dart';
import 'package:soft_khata_flutter/screens/invoices/invoice_preview_screen.dart';
import 'package:soft_khata_flutter/screens/parties/add_party_screen.dart';
import 'package:soft_khata_flutter/screens/parties/parties_screen.dart';
import 'package:soft_khata_flutter/screens/stock/stock_book_screen.dart';
import 'package:soft_khata_flutter/screens/reports/reports_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final biz = state.currentBusiness;
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(biz.name, style: const TextStyle(fontSize: 18, fontFamily: 'SemiBold')),
                Text(biz.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => DemoNavigation.openSearch(context),
              ),
              IconButton(
                icon: Badge(
                  isLabelVisible: state.unreadNotifications > 0,
                  label: Text('${state.unreadNotifications}'),
                  child: const Icon(Icons.notifications_outlined),
                ),
                onPressed: () => DemoNavigation.openNotifications(context),
              ),
              IconButton(
                icon: const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
                onPressed: () => DemoNavigation.openProfile(context),
              ),
              IconButton(
                icon: const Icon(Icons.store_outlined),
                onPressed: () => _showBusinessPicker(context, state),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 400));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _HeroBalanceCard(state: state),
                const SizedBox(height: 16),
                BalanceSummaryGrid(
                  youWillGet: state.youWillGet,
                  youWillGive: state.youWillGive,
                  cashInHand: state.cashInHand,
                  fourthLabel: 'Purchases',
                  fourthValue: state.totalPurchases,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatChip(label: 'Total sales', value: CurrencyFormat.formatCompact(state.totalSales)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatChip(label: 'Expenses', value: CurrencyFormat.formatCompact(state.totalExpenses)),
                    ),
                  ],
                ),
                const SectionHeader(title: 'Quick actions'),
                QuickActionGrid(
                  actions: [
                    QuickActionItem(icon: Icons.person_add_alt_1, label: 'Customer', onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const AddPartyScreen(initialType: PartyType.customer)))),
                    QuickActionItem(icon: Icons.local_shipping_outlined, label: 'Supplier', onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const AddPartyScreen(initialType: PartyType.supplier)))),
                    QuickActionItem(icon: Icons.call_received, label: 'Receive', onTap: () => DemoNavigation.openReceiveMoney(context)),
                    QuickActionItem(icon: Icons.call_made, label: 'Give', onTap: () => DemoNavigation.openGiveMoney(context)),
                    QuickActionItem(icon: Icons.point_of_sale, label: 'Sale', onTap: () => DemoNavigation.openSales(context)),
                    QuickActionItem(icon: Icons.shopping_bag_outlined, label: 'Purchase', onTap: () => DemoNavigation.openPurchases(context)),
                    QuickActionItem(icon: Icons.money_off, label: 'Expense', onTap: () => DemoNavigation.openExpenses(context)),
                    QuickActionItem(icon: Icons.receipt_long, label: 'Invoice', onTap: () => DemoNavigation.openInvoices(context)),
                  ],
                ),
                const SectionHeader(title: 'Business modules'),
                _ModuleGrid(onModule: (m) => _openModule(context, m)),
                SectionHeader(
                  title: 'Recent activity',
                  actionLabel: 'See all',
                  onAction: () => DemoSnack.show(context, 'Open full activity log (demo)'),
                ),
                if (state.activitiesForCurrent.isEmpty)
                  const EmptyState(icon: Icons.history, title: 'No activity yet')
                else
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: state.activitiesForCurrent.take(5).map((a) {
                        return ActivityListTile(
                          title: a.title,
                          subtitle: a.subtitle,
                          amount: a.amount,
                          date: a.date,
                          isCredit: a.isCredit,
                        );
                      }).toList(),
                    ),
                  ),
                SectionHeader(
                  title: 'Recent invoices',
                  actionLabel: 'All',
                  onAction: () => DemoNavigation.openInvoices(context),
                ),
                if (state.invoicesForCurrent.isEmpty)
                  EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No invoices yet',
                    actionLabel: 'Create invoice',
                    onAction: () => DemoNavigation.openInvoices(context),
                  )
                else
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: state.invoicesForCurrent.take(4).map((inv) {
                        return ListTile(
                          title: Text(inv.number),
                          subtitle: Text('${inv.customerName} · ${inv.date.day}/${inv.date.month}/${inv.date.year}'),
                          trailing: Text(CurrencyFormat.format(inv.grandTotal), style: const TextStyle(fontFamily: 'SemiBold')),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(builder: (_) => InvoicePreviewScreen(invoiceId: inv.id)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (state.lowStockCount > 0) ...[
                  const SectionHeader(title: 'Low stock alert'),
                  AppCard(
                    child: ListTile(
                      leading: const Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
                      title: Text('${state.lowStockCount} products need restock'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const StockBookScreen())),
                    ),
                  ),
                ],
                const SectionHeader(title: 'Insights'),
                _InsightRow(
                  icon: Icons.inventory_2_outlined,
                  label: 'Stock value',
                  value: CurrencyFormat.formatCompact(state.stockValue),
                ),
                _InsightRow(
                  icon: Icons.warning_amber_rounded,
                  label: 'Low stock items',
                  value: '${state.lowStockCount}',
                  valueColor: state.lowStockCount > 0 ? AppTheme.warning : null,
                ),
                _InsightRow(
                  icon: Icons.receipt_long_outlined,
                  label: 'Total expenses',
                  value: CurrencyFormat.formatCompact(state.totalExpenses),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openModule(BuildContext context, String module) {
    switch (module) {
      case 'Customer Ledger':
        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PartiesScreen()));
        break;
      case 'Cash Book':
        DemoNavigation.openCashBook(context);
        break;
      case 'Stock Book':
        DemoNavigation.openStockBook(context);
        break;
      case 'Bill Book':
        DemoNavigation.openInvoices(context);
        break;
      case 'Expense Book':
        DemoNavigation.openExpenses(context);
        break;
      case 'Staff Book':
        DemoNavigation.openStaff(context);
        break;
      case 'Reports':
        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ReportsScreen()));
        break;
      case 'Supplier Ledger':
        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PartiesScreen()));
        break;
      default:
        DemoNavigation.openSales(context);
    }
  }

  void _showBusinessPicker(BuildContext context, AppState state) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Switch business', style: TextStyle(fontFamily: 'SemiBold', fontSize: 18)),
              ),
              ...state.businesses.map((b) {
                final selected = b.id == state.currentBusinessId;
                return ListTile(
                  leading: Icon(selected ? Icons.check_circle : Icons.store_outlined, color: AppTheme.primary),
                  title: Text(b.name),
                  subtitle: Text(b.address),
                  onTap: () {
                    state.switchBusiness(b.id);
                    Navigator.pop(ctx);
                    DemoSnack.show(context, 'Switched to ${b.name}');
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _HeroBalanceCard extends StatelessWidget {
  const _HeroBalanceCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final net = state.netPartyBalance;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Net party balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            CurrencyFormat.format(net.abs()),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Bold'),
          ),
          Text(
            net >= 0 ? 'Overall receivable position' : 'Overall payable position',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _miniStat('Cash', CurrencyFormat.formatCompact(state.cashInHand)),
              const SizedBox(width: 24),
              _miniStat('Sales', CurrencyFormat.formatCompact(state.totalSales)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontFamily: 'SemiBold')),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(value, style: const TextStyle(fontFamily: 'SemiBold', fontSize: 15)),
        ],
      ),
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.onModule});

  final void Function(String) onModule;

  static const _modules = [
    ('Customer Ledger', Icons.menu_book_outlined),
    ('Supplier Ledger', Icons.local_shipping_outlined),
    ('Cash Book', Icons.account_balance_wallet_outlined),
    ('Stock Book', Icons.inventory_2_outlined),
    ('Bill Book', Icons.receipt_long_outlined),
    ('Expense Book', Icons.money_off_csred_outlined),
    ('Staff Book', Icons.groups_outlined),
    ('Reports', Icons.bar_chart_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: _modules.map((m) {
        return InkWell(
          onTap: () => onModule(m.$1),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(m.$2, color: AppTheme.primary, size: 22),
                const SizedBox(height: 6),
                Text(m.$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: TextStyle(fontFamily: 'SemiBold', color: valueColor)),
        ],
      ),
    );
  }
}
