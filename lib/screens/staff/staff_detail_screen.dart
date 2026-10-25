import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/core/utils/currency_format.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/screens/staff/staff_book_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class StaffDetailScreen extends StatelessWidget {
  const StaffDetailScreen({super.key, required this.staffId});

  final String staffId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff detail')),
      body: Consumer<AppState>(
        builder: (context, state, _) {
          StaffMember? member;
          for (final s in state.staffForCurrent) {
            if (s.id == staffId) {
              member = s;
              break;
            }
          }
          if (member == null) {
            return const EmptyState(icon: Icons.person_off_outlined, title: 'Staff not found');
          }
          final s = member;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Row(
                  children: [
                    CircleAvatar(radius: 28, child: Text(s.name[0].toUpperCase(), style: const TextStyle(fontSize: 24))),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold')),
                          Text(staffRoleLabel(s.role)),
                          Text(s.phone),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Payroll'),
              AppCard(
                child: Column(
                  children: [
                    _InfoRow(label: 'Monthly salary', value: CurrencyFormat.format(s.monthlySalary)),
                    _InfoRow(label: 'Advance balance', value: CurrencyFormat.format(s.advanceBalance)),
                    _InfoRow(label: 'Bonus total', value: CurrencyFormat.format(s.bonusTotal)),
                    _InfoRow(label: 'Overtime hours', value: s.overtimeHours.toStringAsFixed(1)),
                  ],
                ),
              ),
              const SectionHeader(title: 'Attendance today'),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        state.markStaffPresent(s.id);
                        DemoSnack.show(context, '${s.name} marked present');
                      },
                      icon: const Icon(Icons.check_circle_outline, color: AppTheme.success),
                      label: const Text('Present'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        state.markStaffAbsent(s.id);
                        DemoSnack.show(context, '${s.name} marked absent');
                      },
                      icon: const Icon(Icons.cancel_outlined, color: AppTheme.danger),
                      label: const Text('Absent'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StatusBadge(
                label: 'Today: ${_attendanceLabel(s.attendanceToday)}',
                color: s.attendanceToday == AttendanceStatus.present ? AppTheme.success : AppTheme.danger,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontFamily: 'SemiBold'))],
      ),
    );
  }
}

String _attendanceLabel(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return 'Present';
    case AttendanceStatus.absent:
      return 'Absent';
    case AttendanceStatus.leave:
      return 'Leave';
  }
}
