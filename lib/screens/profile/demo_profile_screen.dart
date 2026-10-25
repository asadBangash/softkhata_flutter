import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_khata_flutter/models/domain_models.dart';
import 'package:soft_khata_flutter/routes/demo_navigation.dart';
import 'package:soft_khata_flutter/screens/auth/demo_welcome_screen.dart';
import 'package:soft_khata_flutter/screens/staff/staff_book_screen.dart';
import 'package:soft_khata_flutter/services/app_state.dart';
import 'package:soft_khata_flutter/services/demo_auth_service.dart';
import 'package:soft_khata_flutter/services/laravel_api_holder.dart';
import 'package:soft_khata_flutter/theme/app_theme.dart';
import 'package:soft_khata_flutter/widgets/common_widgets.dart';

class DemoProfileScreen extends StatelessWidget {
  const DemoProfileScreen({super.key});

  static DemoUserProfile _profile(DemoAuthService auth) {
    return auth.sessionUser ??
        const DemoUserProfile(
          name: 'Guest',
          phone: '',
          email: '',
          role: StaffRole.owner,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer2<AppState, DemoAuthService>(
        builder: (context, state, auth, _) {
          final profile = _profile(auth);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                      child: const Icon(Icons.person, size: 36, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'SemiBold'),
                          ),
                          Text(staffRoleLabel(profile.role)),
                          if (profile.phone.isNotEmpty) Text(profile.phone),
                          if (profile.email.isNotEmpty) Text(profile.email),
                          if (profile.businessName != null && profile.businessName!.isNotEmpty)
                            Text(profile.businessName!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Business'),
              AppCard(
                onTap: () => DemoNavigation.openBusinessManagement(context),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.store, color: AppTheme.primary),
                  title: Text(state.currentBusiness.name, style: const TextStyle(fontFamily: 'SemiBold')),
                  subtitle: Text(state.currentBusiness.address),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              const SectionHeader(title: 'Account'),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.security),
                      title: const Text('Security'),
                      subtitle: Text(profile.pinEnabled ? 'PIN enabled' : 'PIN off'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => DemoNavigation.openSecurity(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings_outlined),
                      title: const Text('Permissions'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => DemoNavigation.openPermissions(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => DemoNavigation.openSettings(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Sign out?'),
                      content: const Text('You will return to the login screen.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sign out')),
                      ],
                    ),
                  );
                  if (confirm != true || !context.mounted) return;
                  if (state.usesLaravel) {
                    await context.read<LaravelApiHolder>().auth.logout();
                  } else {
                    await auth.logout();
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => DemoWelcomeScreen(useLaravelBackend: state.usesLaravel),
                    ),
                    (_) => false,
                  );
                },
                child: const Text('Sign out'),
              ),
            ],
          );
        },
      ),
    );
  }
}
