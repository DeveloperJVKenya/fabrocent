import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/l10n/inherited_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _smsGranted = false;
  bool _notifGranted = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _checkExisting();
  }

  Future<void> _checkExisting() async {
    final sms = await Permission.sms.status;
    final notif = await Permission.notification.status;
    setState(() {
      _smsGranted = sms.isGranted;
      _notifGranted = notif.isGranted;
    });
  }

  Future<void> _requestSms() async {
    setState(() => _checking = true);
    final result = await Permission.sms.request();
    setState(() {
      _smsGranted = result.isGranted;
      _checking = false;
    });
  }

  Future<void> _requestNotifications() async {
    setState(() => _checking = true);
    final result = await Permission.notification.request();
    setState(() {
      _notifGranted = result.isGranted;
      _checking = false;
    });
  }

  void _proceed() {
    if (_smsGranted) {
      context.go(AppRoutes.profileSetup);
    } else {
      _showSmsRequired();
    }
  }

  void _showSmsRequired() {
    final s = InheritedStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s.permSmsRequired),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = InheritedStrings.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(s.permAllowAccess, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                s.permSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 40),

              _PermissionCard(
                icon: Icons.sms_outlined,
                title: s.permSmsTitle,
                subtitle: s.permSmsSubtitle,
                required_: s.required,
                allow_: s.allow,
                isRequired: true,
                isGranted: _smsGranted,
                onGrant: _requestSms,
                isLoading: _checking,
              ),

              const SizedBox(height: 16),

              _PermissionCard(
                icon: Icons.notifications_outlined,
                title: s.permNotifTitle,
                subtitle: s.permNotifSubtitle,
                required_: s.required,
                allow_: s.allow,
                isRequired: false,
                isGranted: _notifGranted,
                onGrant: _requestNotifications,
                isLoading: _checking,
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.permPrivacy,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: _checking ? null : _proceed,
                child: Text(
                  _smsGranted ? s.permContinue : s.permGrantAndContinue,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String required_;
  final String allow_;
  final bool isRequired;
  final bool isGranted;
  final VoidCallback onGrant;
  final bool isLoading;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.required_,
    required this.allow_,
    required this.isRequired,
    required this.isGranted,
    required this.onGrant,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGranted
              ? AppTheme.primary.withValues(alpha: 0.3)
              : theme.dividerColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isGranted ? Icons.check_circle_rounded : icon,
              color: isGranted
                  ? AppTheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(width: 6),
                    if (isRequired)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          required_,
                          style: const TextStyle(
                            color: AppTheme.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
                if (!isGranted) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: isLoading ? null : onGrant,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(allow_),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
