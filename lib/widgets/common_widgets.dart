import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(padding: padding, child: child),
      ),
    );
    return card;
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'SemiBold',
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class AmountChip extends StatelessWidget {
  const AmountChip({
    super.key,
    required this.amount,
    this.positiveIsGreen = true,
    this.compact = false,
  });

  final double amount;
  final bool positiveIsGreen;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    Color color;
    if (amount == 0) {
      color = Theme.of(context).colorScheme.outline;
    } else if (positiveIsGreen) {
      color = isPositive ? AppTheme.success : AppTheme.danger;
    } else {
      color = isPositive ? AppTheme.danger : AppTheme.success;
    }
    final text = compact ? CurrencyFormat.formatCompact(amount.abs()) : CurrencyFormat.format(amount.abs());
    final prefix = amount < 0 ? '-' : (amount > 0 ? '+' : '');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$prefix$text',
        style: TextStyle(color: color, fontFamily: 'SemiBold', fontSize: 13),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontFamily: 'Medium')),
    );
  }
}

class DemoSnack {
  static void show(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.danger : AppTheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(labels[i]),
              selected: selected,
              onSelected: (_) => onSelected(i),
              showCheckmark: false,
            ),
          );
        }),
      ),
    );
  }
}

class BalanceSummaryGrid extends StatelessWidget {
  const BalanceSummaryGrid({
    super.key,
    required this.youWillGet,
    required this.youWillGive,
    required this.cashInHand,
    this.fourthLabel,
    this.fourthValue,
  });

  final double youWillGet;
  final double youWillGive;
  final double cashInHand;
  final String? fourthLabel;
  final double? fourthValue;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _SummaryTile(
          label: 'You will get',
          value: CurrencyFormat.formatCompact(youWillGet),
          color: AppTheme.success,
          icon: Icons.arrow_downward_rounded,
        ),
        _SummaryTile(
          label: 'You will give',
          value: CurrencyFormat.formatCompact(youWillGive),
          color: AppTheme.danger,
          icon: Icons.arrow_upward_rounded,
        ),
        _SummaryTile(
          label: 'Cash in hand',
          value: CurrencyFormat.formatCompact(cashInHand),
          color: AppTheme.primary,
          icon: Icons.payments_outlined,
        ),
        _SummaryTile(
          label: fourthLabel ?? 'Net balance',
          value: fourthValue != null
              ? CurrencyFormat.formatCompact(fourthValue!)
              : CurrencyFormat.formatCompact(youWillGet - youWillGive),
          color: AppTheme.warning,
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'SemiBold',
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key, required this.actions});

  final List<QuickActionItem> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: actions.length,
      itemBuilder: (context, i) {
        final a = actions[i];
        return InkWell(
          onTap: a.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                child: Icon(a.icon, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                a.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

class QuickActionItem {
  const QuickActionItem({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class PartyListTile extends StatelessWidget {
  const PartyListTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.balance,
    required this.onTap,
    this.leadingIcon,
  });

  final String name;
  final String subtitle;
  final double balance;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
        child: Icon(leadingIcon ?? Icons.person_outline, color: AppTheme.primary),
      ),
      title: Text(name, style: const TextStyle(fontFamily: 'SemiBold')),
      subtitle: Text(subtitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            CurrencyFormat.format(balance.abs()),
            style: TextStyle(
              fontFamily: 'SemiBold',
              color: balance >= 0 ? AppTheme.success : AppTheme.danger,
            ),
          ),
          Text(
            balance >= 0 ? 'Receivable' : 'Payable',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({super.key, required this.title, required this.subtitle, required this.amount, required this.date, required this.isCredit});

  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isCredit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (isCredit ? AppTheme.success : AppTheme.danger).withValues(alpha: 0.12),
        child: Icon(
          isCredit ? Icons.add : Icons.remove,
          color: isCredit ? AppTheme.success : AppTheme.danger,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AmountChip(amount: isCredit ? amount : -amount, compact: true),
          Text(
            '${date.day}/${date.month}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class BusinessSwitcherSheet extends StatelessWidget {
  const BusinessSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
