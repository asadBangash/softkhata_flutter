import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/staff/staff_detail_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class StaffBookScreen extends StatefulWidget {
  const StaffBookScreen({super.key});

  @override
  State<StaffBookScreen> createState() => _StaffBookScreenState();
}

class _StaffBookScreenState extends State<StaffBookScreen> {
  int _filter = 0;
  String _query = '';

  static const _filters = ['All', 'Present', 'Absent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final staff = _filterStaff(state.staffForCurrent);
          final present = state.staffForCurrent.where((s) => s.attendanceToday == AttendanceStatus.present).length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${state.staffForCurrent.length} team members'),
                            Text(
                              '$present present today',
                              style: TextStyle(color: AppTheme.success, fontFamily: 'SemiBold'),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.groups_outlined, size: 40, color: AppTheme.primary),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search staff',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 8),
              FilterChipRow(
                labels: _filters,
                selectedIndex: _filter,
                onSelected: (i) => setState(() => _filter = i),
              ),
              Expanded(
                child: staff.isEmpty
                    ? const EmptyState(
                        icon: Icons.badge_outlined,
                        title: 'No staff found',
                        subtitle: 'Demo seed includes staff for each business.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: staff.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final s = staff[i];
                          return AppCard(
                            padding: EdgeInsets.zero,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => StaffDetailScreen(staffId: s.id),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(s.name.isNotEmpty ? s.name[0].toUpperCase() : '?'),
                              ),
                              title: Text(s.name, style: const TextStyle(fontFamily: 'SemiBold')),
                              subtitle: Text('${staffRoleLabel(s.role)} · ${s.phone}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  StatusBadge(
                                    label: _attendanceLabel(s.attendanceToday),
                                    color: s.attendanceToday == AttendanceStatus.present
                                        ? AppTheme.success
                                        : AppTheme.danger,
                                  ),
                                  Text(
                                    CurrencyFormat.formatCompact(s.monthlySalary),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
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
    );
  }

  List<StaffMember> _filterStaff(List<StaffMember> all) {
    Iterable<StaffMember> list = all;
    switch (_filter) {
      case 1:
        list = list.where((s) => s.attendanceToday == AttendanceStatus.present);
        break;
      case 2:
        list = list.where((s) => s.attendanceToday == AttendanceStatus.absent);
        break;
      default:
        break;
    }
    if (_query.isNotEmpty) {
      list = list.where((s) => s.name.toLowerCase().contains(_query) || s.phone.contains(_query));
    }
    return list.toList()..sort((a, b) => a.name.compareTo(b.name));
  }
}

String staffRoleLabel(StaffRole role) {
  switch (role) {
    case StaffRole.owner:
      return 'Owner';
    case StaffRole.admin:
      return 'Admin';
    case StaffRole.accountant:
      return 'Accountant';
    case StaffRole.cashier:
      return 'Cashier';
    case StaffRole.salesman:
      return 'Salesman';
  }
}

String _attendanceLabel(AttendanceStatus s) {
  switch (s) {
    case AttendanceStatus.present:
      return 'Present';
    case AttendanceStatus.absent:
      return 'Absent';
    case AttendanceStatus.leave:
      return 'Leave';
  }
}
