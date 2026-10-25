import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/routes/demo_navigation.dart';
import 'package:soft_khata_flutter/screens/parties/add_party_screen.dart';
import 'package:soft_khata_flutter/screens/parties/parties_screen.dart';
import 'package:soft_khata_flutter/screens/reports/reports_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => DemoNavigation.openSearch(context),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                onTap: () => DemoNavigation.openProfile(context),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                    child: const Icon(Icons.person, color: AppTheme.primary),
                  ),
                  title: Text(state.currentBusiness.owner, style: const TextStyle(fontFamily: 'SemiBold')),
                  subtitle: Text('${state.currentBusiness.name} · Demo mode'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              const SectionHeader(title: 'Books & modules'),
              _menuList(context, [
                _MoreItem('Cash Book', Icons.account_balance_wallet_outlined, DemoNavigation.openCashBook),
                _MoreItem('Stock Book', Icons.inventory_2_outlined, DemoNavigation.openStockBook),
                _MoreItem('Sales', Icons.point_of_sale_outlined, DemoNavigation.openSales),
                _MoreItem('Purchases', Icons.shopping_cart_outlined, DemoNavigation.openPurchases),
                _MoreItem('Invoices / Bill Book', Icons.receipt_long_outlined, DemoNavigation.openInvoices),
                _MoreItem('Expense Book', Icons.money_off_csred_outlined, DemoNavigation.openExpenses),
                _MoreItem('Staff Book', Icons.groups_outlined, DemoNavigation.openStaff),
                _MoreItem('Parties (Khata)', Icons.people_outline, (_) {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const PartiesScreen()));
                }),
                _MoreItem('Reports', Icons.bar_chart_outlined, (_) {
                  Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ReportsScreen()));
                }),
              ]),
              const SectionHeader(title: 'Business'),
              _menuList(context, [
                _MoreItem('Business management', Icons.store_mall_directory_outlined, DemoNavigation.openBusinessManagement),
                _MoreItem('Users & permissions', Icons.admin_panel_settings_outlined, DemoNavigation.openPermissions),
                _MoreItem('Notifications', Icons.notifications_outlined, DemoNavigation.openNotifications),
                _MoreItem('Payment reminders', Icons.alarm_outlined, (ctx) {
                  DemoSnack.show(ctx, 'Open a customer profile → Send Reminder');
                }),
              ]),
              const SectionHeader(title: 'Settings & help'),
              _menuList(context, [
                _MoreItem('Settings', Icons.settings_outlined, DemoNavigation.openSettings),
                _MoreItem('Security', Icons.lock_outline, DemoNavigation.openSecurity),
                _MoreItem('Help & support', Icons.help_outline, (ctx) => DemoSnack.show(ctx, 'Support: support@softkhata.app (demo)')),
              ]),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const AddPartyScreen()),
                ),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Add party'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _menuList(BuildContext context, List<_MoreItem> items) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: items.map((item) {
          return ListTile(
            leading: Icon(item.icon, color: AppTheme.primary),
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => item.onTap(context),
          );
        }).toList(),
      ),
    );
  }
}

class _MoreItem {
  _MoreItem(this.title, this.icon, this.onTap);
  final String title;
  final IconData icon;
  final void Function(BuildContext) onTap;
}
