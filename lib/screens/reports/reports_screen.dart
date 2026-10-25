import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _ReportCard(
                    icon: Icons.trending_up,
                    title: 'Sales',
                    value: CurrencyFormat.formatCompact(state.totalSales),
                    onTap: () => DemoSnack.show(context, 'Sales report (demo)'),
                  ),
                  _ReportCard(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Purchases',
                    value: CurrencyFormat.formatCompact(state.totalPurchases),
                    onTap: () => DemoSnack.show(context, 'Purchase report (demo)'),
                  ),
                  _ReportCard(
                    icon: Icons.money_off,
                    title: 'Expenses',
                    value: CurrencyFormat.formatCompact(state.totalExpenses),
                    onTap: () => DemoSnack.show(context, 'Expense report (demo)'),
                  ),
                  _ReportCard(
                    icon: Icons.account_balance_wallet,
                    title: 'Cash flow',
                    value: CurrencyFormat.formatCompact(state.cashInHand),
                    onTap: () => DemoSnack.show(context, 'Cash flow report (demo)'),
                  ),
                ],
              ),
              const SectionHeader(title: 'Weekly trend (demo)'),
              SizedBox(
                height: 220,
                child: AppCard(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (v, _) => Text(
                              '${(v / 1000).toStringAsFixed(0)}k',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              final i = v.toInt().clamp(0, 6);
                              return Text(days[i], style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 12000),
                            FlSpot(1, 18000),
                            FlSpot(2, 15000),
                            FlSpot(3, 22000),
                            FlSpot(4, 19000),
                            FlSpot(5, 28000),
                            FlSpot(6, 24000),
                          ],
                          isCurved: true,
                          color: AppTheme.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.primary.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SectionHeader(title: 'Party summary'),
              AppCard(
                child: Column(
                  children: [
                    _summaryLine('You will get', state.youWillGet, AppTheme.success),
                    const Divider(),
                    _summaryLine('You will give', state.youWillGive, AppTheme.danger),
                    const Divider(),
                    _summaryLine('Net', state.netPartyBalance, AppTheme.primary),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryLine(String label, double amount, Color color) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        CurrencyFormat.format(amount.abs()),
        style: TextStyle(fontFamily: 'SemiBold', color: color),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppTheme.primary),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: const TextStyle(fontFamily: 'SemiBold', fontSize: 16)),
        ],
      ),
    );
  }
}
