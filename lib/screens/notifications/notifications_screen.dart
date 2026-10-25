import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filter = 0;

  static const _filters = ['All', 'Unread', 'Read'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Consumer<AppState>(
            builder: (context, state, _) {
              if (state.unreadNotifications == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  for (final n in state.notifications.where((x) => !x.read)) {
                    state.markNotificationRead(n.id);
                  }
                  DemoSnack.show(context, 'All marked as read');
                },
                child: const Text('Mark all read', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final items = _filterList(state.notifications);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_outlined, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        '${state.unreadNotifications} unread',
                        style: const TextStyle(fontFamily: 'SemiBold'),
                      ),
                    ],
                  ),
                ),
              ),
              FilterChipRow(
                labels: _filters,
                selectedIndex: _filter,
                onSelected: (i) => setState(() => _filter = i),
              ),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(
                        icon: Icons.notifications_none,
                        title: 'No notifications',
                        subtitle: 'Payment reminders and alerts will appear here.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final n = items[i];
                          return AppCard(
                            padding: const EdgeInsets.all(12),
                            onTap: () {
                              if (!n.read) {
                                state.markNotificationRead(n.id);
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  n.read ? Icons.notifications_outlined : Icons.circle,
                                  size: n.read ? 24 : 12,
                                  color: n.read ? Theme.of(context).colorScheme.outline : AppTheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n.title,
                                        style: TextStyle(
                                          fontFamily: n.read ? 'Regular' : 'SemiBold',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        n.body,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('d MMM, h:mm a').format(n.time),
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
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
    );
  }

  List<AppNotificationItem> _filterList(List<AppNotificationItem> all) {
    Iterable<AppNotificationItem> list = all;
    switch (_filter) {
      case 1:
        list = list.where((n) => !n.read);
        break;
      case 2:
        list = list.where((n) => n.read);
        break;
      default:
        break;
    }
    return list.toList()..sort((a, b) => b.time.compareTo(a.time));
  }
}
