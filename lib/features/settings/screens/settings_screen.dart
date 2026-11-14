import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/background_sms_service.dart';
import '../../../core/services/firestore_sync_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/sms/known_banks.dart';
import '../../../core/theme/app_theme.dart';

// ─── Section navigation enum ──────────────────────────────────────────────────

enum _S {
  account,
  appearance,
  accessibility,
  notifications,
  sms,
  language,
  data,
  about,
}

extension _SX on _S {
  String get label => switch (this) {
    _S.account       => 'Account',
    _S.appearance    => 'Appearance',
    _S.accessibility => 'Accessibility',
    _S.notifications => 'Notifications',
    _S.sms           => 'SMS',
    _S.language      => 'Language',
    _S.data          => 'Data',
    _S.about         => 'About',
  };

  IconData get icon => switch (this) {
    _S.account       => Icons.person_outline,
    _S.appearance    => Icons.palette_outlined,
    _S.accessibility => Icons.accessibility_new_outlined,
    _S.notifications => Icons.notifications_outlined,
    _S.sms           => Icons.sms_outlined,
    _S.language      => Icons.language_outlined,
    _S.data          => Icons.storage_outlined,
    _S.about         => Icons.info_outline,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
//  SettingsScreen
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _scrollCtrl = ScrollController();
  final _keys = <_S, GlobalKey>{
    for (final s in _S.values) s: GlobalKey(),
  };

  bool _syncLoading  = false;
  bool _clearLoading = false;
  bool _photoLoading = false;

  PermissionStatus? _smsStatus;
  PermissionStatus? _notifStatus;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _loadPermissions();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _jumpTo(_S section) {
    final ctx = _keys[section]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
  }

  // ─── Permissions ───────────────────────────────────────────────────────────

  Future<void> _loadPermissions() async {
    final sms   = await Permission.sms.status;
    final notif = await Permission.notification.status;
    if (mounted) setState(() { _smsStatus = sms; _notifStatus = notif; });
  }

  Future<void> _requestSms() async {
    final result = await Permission.sms.request();
    if (mounted) setState(() => _smsStatus = result);
    if (result.isGranted && mounted) {
      _snack('SMS access granted — M-Pesa transactions will sync automatically');
    }
  }

  Future<void> _requestNotification() async {
    final result = await Permission.notification.request();
    if (mounted) setState(() => _notifStatus = result);
  }

  // ─── Sync to Cloud ─────────────────────────────────────────────────────────

  Future<void> _syncToCloud() async {
    if (kIsWeb) {
      _snack(InheritedStrings.of(context).webSyncNotAvailable);
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _syncLoading = true);
    try {
      final service = FirestoreSyncService(ref.read(firestoreProvider));
      final count = await service.syncPendingTransactions(user.uid);
      if (mounted) {
        final s = InheritedStrings.of(context);
        _snack(count == 0 ? s.alreadyUpToDate : s.syncedCount(count));
      }
    } catch (e) {
      if (mounted) _snack('Sync failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _syncLoading = false);
    }
  }

  // ─── Clear Local Data ──────────────────────────────────────────────────────

  Future<void> _confirmClearData() async {
    if (kIsWeb) {
      _snack(InheritedStrings.of(context).webNoLocalData);
      return;
    }
    final s = InheritedStrings.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.clearConfirmTitle),
        content: Text(s.clearConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.expenseRed),
            child: Text(s.clear),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _clearLoading = true);
    try {
      await IsarService.clearUserData(user.uid);
      if (mounted) _snack(InheritedStrings.of(context).localDataCleared);
    } catch (e) {
      if (mounted) _snack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _clearLoading = false);
    }
  }

  // ─── Profile photo ─────────────────────────────────────────────────────────

  Future<void> _pickAndUploadPhoto() async {
    if (kIsWeb) { _snack(InheritedStrings.of(context).webPhotoNotSupported); return; }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 512);
    if (picked == null || !mounted) return;

    setState(() => _photoLoading = true);
    try {
      final file = File(picked.path);
      final url = await StorageService.uploadProfilePhoto(userId: user.uid, imageFile: file);
      final profile = ref.read(userProfileProvider).valueOrNull;
      if (profile != null) {
        await ref.read(userProfileRepositoryProvider).save(profile.copyWith(photoUrl: url));
      }
      if (mounted) _snack(InheritedStrings.of(context).photoUpdated);
    } catch (e) {
      if (mounted) _snack('Upload failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _photoLoading = false);
    }
  }

  // ─── Edit profile details ──────────────────────────────────────────────────

  Future<void> _editProfile(UserProfile profile) async {
    final nameCtrl  = TextEditingController(text: profile.displayName ?? '');
    final phoneCtrl = TextEditingController(text: profile.phoneNumber);
    final formKey   = GlobalKey<FormState>();
    bool saving = false;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.viewInsetsOf(ctx).bottom + 32,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.edit_outlined, color: AppTheme.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text('Edit Profile', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    hintText: 'Your name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '0712 345 678',
                    prefixIcon: Icon(Icons.phone_outlined),
                    helperText: 'Used to link your M-Pesa SMS',
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saving
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            setState(() => saving = true);
                            try {
                              var phone = phoneCtrl.text.trim();
                              if (phone.startsWith('0')) phone = '+254${phone.substring(1)}';
                              await ref.read(userProfileRepositoryProvider).save(
                                profile.copyWith(
                                  displayName: nameCtrl.text.trim(),
                                  phoneNumber: phone.isEmpty ? profile.phoneNumber : phone,
                                ),
                              );
                              if (ctx.mounted) Navigator.pop(ctx, true);
                            } catch (e) {
                              setState(() => saving = false);
                            }
                          },
                    child: saving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    nameCtrl.dispose();
    phoneCtrl.dispose();
    if (saved == true && mounted) _snack('Profile updated');
  }

  // ─── Sign out ──────────────────────────────────────────────────────────────

  Future<void> _signOut() async {
    final s = InheritedStrings.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.signOutConfirmTitle),
        content: Text(s.signOutConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(s.signOut)),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!kIsWeb) await BackgroundSmsService.cancel();
    await FirebaseAuth.instance.signOut();
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? AppTheme.error : null),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final s = InheritedStrings.of(context);

    final sections = kIsWeb
        ? _S.values.where((v) => v != _S.sms).toList()
        : _S.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: Column(
        children: [
          // ── Section navigation chips ────────────────────────────────────
          _SectionChipsBar(sections: sections, onJump: _jumpTo),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          // ── Main content ────────────────────────────────────────────────
          Expanded(
            child: profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Could not load settings')),
              data: (profile) => ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
                children: [

                  // ── Account ──────────────────────────────────────────
                  _SectionLabel(key: _keys[_S.account], label: 'Account'),
                  _AccountCard(
                    profile: profile,
                    photoLoading: _photoLoading,
                    onPhotoTap: _pickAndUploadPhoto,
                    onEdit: profile != null ? () => _editProfile(profile) : null,
                  ),
                  const SizedBox(height: 20),

                  // ── Appearance ───────────────────────────────────────
                  _SectionLabel(key: _keys[_S.appearance], label: 'Appearance'),
                  _AppearanceCard(),
                  const SizedBox(height: 20),

                  // ── Accessibility ────────────────────────────────────
                  _SectionLabel(key: _keys[_S.accessibility], label: 'Accessibility'),
                  _AccessibilityCard(),
                  const SizedBox(height: 20),

                  // ── Notifications ────────────────────────────────────
                  _SectionLabel(key: _keys[_S.notifications], label: 'Notifications'),
                  _NotificationsCard(
                    notifStatus: _notifStatus,
                    onRequest: _requestNotification,
                  ),
                  const SizedBox(height: 20),

                  // ── SMS / Bank (native only) ──────────────────────────
                  if (!kIsWeb) ...[
                    _SectionLabel(key: _keys[_S.sms], label: 'SMS Access'),
                    _SmsCard(smsStatus: _smsStatus, onRequest: _requestSms),
                    const SizedBox(height: 10),
                    _BankCard(),
                    const SizedBox(height: 20),
                  ],

                  // ── Language ─────────────────────────────────────────
                  _SectionLabel(key: _keys[_S.language], label: 'Language'),
                  _LanguageCard(profile: profile),
                  const SizedBox(height: 20),

                  // ── Business (if applicable) ──────────────────────────
                  if (profile?.segment.hasBusinessAccount == true) ...[
                    _SettingsCard(children: [
                      _CardHeader(
                        icon: Icons.store_outlined,
                        title: s.pochiSection,
                        hint: 'Your M-Pesa business accounts',
                      ),
                      const Divider(height: 1),
                      _InfoRow(icon: Icons.store_outlined,         label: 'Pochi la Biashara', value: profile?.hasPochi == true ? 'Enabled' : 'Disabled'),
                      _InfoRow(icon: Icons.point_of_sale_outlined, label: 'Till Number',        value: profile?.hasTill == true ? 'Enabled' : 'Disabled'),
                      _InfoRow(icon: Icons.business_outlined,      label: 'Paybill',            value: profile?.hasPaybill == true ? 'Enabled' : 'Disabled'),
                    ]),
                    const SizedBox(height: 20),
                  ],

                  // ── Data ─────────────────────────────────────────────
                  _SectionLabel(key: _keys[_S.data], label: 'Data'),
                  _DataCard(
                    syncLoading: _syncLoading,
                    clearLoading: _clearLoading,
                    onSync: _syncToCloud,
                    onClear: _confirmClearData,
                  ),
                  const SizedBox(height: 20),

                  // ── About ─────────────────────────────────────────────
                  _SectionLabel(key: _keys[_S.about], label: 'About'),
                  _AboutCard(),
                  const SizedBox(height: 28),

                  // ── Sign out ──────────────────────────────────────────
                  _SignOutButton(onTap: _signOut),
                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      'Settings saved automatically',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Section chips bar
// ─────────────────────────────────────────────────────────────────────────────

class _SectionChipsBar extends StatelessWidget {
  final List<_S> sections;
  final void Function(_S) onJump;

  const _SectionChipsBar({required this.sections, required this.onJump});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final sec = sections[i];
          return GestureDetector(
            onTap: () => onJump(sec),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(sec.icon, size: 14, color: AppTheme.primary),
                  const SizedBox(width: 5),
                  Text(
                    sec.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared layout primitives
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppTheme.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? hint;

  const _CardHeader({required this.icon, required this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          _IconBadge(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                if (hint != null)
                  Text(hint!, style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color? color;

  const _IconBadge({required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: c, size: 18),
    );
  }
}

class _SwitchRow extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _IconBadge(icon: icon, color: value ? AppTheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  )),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary.withValues(alpha: 0.7), size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value, style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Account card
// ─────────────────────────────────────────────────────────────────────────────

class _AccountCard extends StatelessWidget {
  final UserProfile? profile;
  final bool photoLoading;
  final VoidCallback onPhotoTap;
  final VoidCallback? onEdit;

  const _AccountCard({
    required this.profile,
    required this.photoLoading,
    required this.onPhotoTap,
    required this.onEdit,
  });

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    final phone = profile?.phoneNumber ?? FirebaseAuth.instance.currentUser?.phoneNumber ?? '';

    return _SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: photoLoading ? null : onPhotoTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                      backgroundImage: (profile?.photoUrl != null && !kIsWeb)
                          ? NetworkImage(profile!.photoUrl!)
                          : null,
                      child: (profile?.photoUrl == null || kIsWeb)
                          ? Text(
                              _initials(profile?.displayName),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary,
                              ),
                            )
                          : null,
                    ),
                    if (!kIsWeb)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.cardColor, width: 2),
                        ),
                        child: photoLoading
                            ? const SizedBox(width: 10, height: 10,
                                child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white))
                            : const Icon(Icons.camera_alt, size: 10, color: Colors.white),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.displayName ?? 'Your Account',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (email.isNotEmpty)
                      Text(email, style: theme.textTheme.bodySmall),
                    if (phone.isNotEmpty)
                      Text(phone, style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      )),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        profile?.segment.displayName ?? '—',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: AppTheme.primary,
                  tooltip: 'Edit profile',
                ),
            ],
          ),
        ),
        if (!kIsWeb && onEdit != null) ...[
          Divider(height: 1, color: theme.dividerColor),
          InkWell(
            onTap: onEdit,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text('Edit name & phone number',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, size: 16, color: AppTheme.primary),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Appearance card — theme choice cards with mini mockup
// ─────────────────────────────────────────────────────────────────────────────

class _AppearanceCard extends ConsumerWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;

    return _SettingsCard(
      children: [
        _CardHeader(
          icon: Icons.palette_outlined,
          title: 'Theme',
          hint: 'Choose how FabroCent looks',
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Row(
            children: [
              _ThemeChoiceCard(
                mode: ThemeMode.light,
                label: 'Light',
                selected: themeMode == ThemeMode.light,
                onTap: () => ref.read(themeModeProvider.notifier).setMode(ThemeMode.light),
              ),
              const SizedBox(width: 10),
              _ThemeChoiceCard(
                mode: ThemeMode.system,
                label: 'System',
                selected: themeMode == ThemeMode.system,
                onTap: () => ref.read(themeModeProvider.notifier).setMode(ThemeMode.system),
              ),
              const SizedBox(width: 10),
              _ThemeChoiceCard(
                mode: ThemeMode.dark,
                label: 'Dark',
                selected: themeMode == ThemeMode.dark,
                onTap: () => ref.read(themeModeProvider.notifier).setMode(ThemeMode.dark),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeChoiceCard extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeChoiceCard({
    required this.mode,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppTheme.primary : theme.dividerColor,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              _ThemeMockup(mode: mode),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selected)
                    const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 13),
                  if (selected) const SizedBox(width: 3),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: selected ? AppTheme.primary : theme.colorScheme.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeMockup extends StatelessWidget {
  final ThemeMode mode;
  const _ThemeMockup({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isDarkSystem = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark = mode == ThemeMode.dark || (mode == ThemeMode.system && isDarkSystem);

    final bg    = isDark ? const Color(0xFF0C1810) : const Color(0xFFF5F5F5);
    final appBr = isDark ? const Color(0xFF0F2518) : const Color(0xFF1A5C31);
    final card  = isDark ? const Color(0xFF142019) : Colors.white;
    final lineA = isDark ? const Color(0xFF5EC47E) : const Color(0xFF1A5C31);
    final lineB = isDark ? const Color(0xFF4A6450) : const Color(0xFFB8CCB8);
    final navBg = isDark ? const Color(0xFF101A13) : Colors.white;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Stack(
          children: [
            Container(color: bg),
            // App bar
            Container(height: 18, color: appBr,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 7),
              child: Container(width: 28, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Balance card
            Positioned(
              top: 22, left: 6, right: 6,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 18, height: 3, color: lineA),
                    const SizedBox(width: 4),
                    Container(width: 12, height: 3, color: lineB),
                  ],
                ),
              ),
            ),
            // List lines
            Positioned(
              top: 46, left: 6, right: 6,
              child: Column(
                children: List.generate(2, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(color: lineB.withValues(alpha: 0.6), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Expanded(child: Container(height: 3, color: lineB.withValues(alpha: 0.5))),
                  ]),
                )),
              ),
            ),
            // Nav bar
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(height: 11, color: navBg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (i) => Container(
                    width: i == 0 ? 6 : 5,
                    height: i == 0 ? 6 : 5,
                    decoration: BoxDecoration(
                      color: i == 0 ? lineA : lineB,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Accessibility card
// ─────────────────────────────────────────────────────────────────────────────

class _AccessibilityCard extends ConsumerWidget {
  const _AccessibilityCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize    = ref.watch(fontSizeProvider).valueOrNull ?? AppFontSize.normal;
    final isBold      = ref.watch(boldTextProvider).valueOrNull ?? false;
    final reduceMotion = ref.watch(reduceMotionProvider).valueOrNull ?? false;
    final theme       = Theme.of(context);

    return _SettingsCard(
      children: [
        _CardHeader(
          icon: Icons.accessibility_new_outlined,
          title: 'Accessibility',
          hint: 'Text size, weight and motion',
        ),
        const Divider(height: 1),

        // ── Text Scale Slider ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBadge(icon: Icons.text_fields_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Text Size', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(fontSize.scale * 100).round()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.primary,
                  thumbColor: AppTheme.primary,
                  overlayColor: AppTheme.primary.withValues(alpha: 0.1),
                  inactiveTrackColor: AppTheme.primary.withValues(alpha: 0.2),
                  trackHeight: 3,
                ),
                child: Slider(
                  min: 0,
                  max: 3,
                  divisions: 3,
                  value: AppFontSize.values.indexOf(fontSize).toDouble(),
                  onChanged: (v) =>
                      ref.read(fontSizeProvider.notifier).setSize(AppFontSize.values[v.round()]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: AppFontSize.values.map((s) {
                  final active = s == fontSize;
                  return GestureDetector(
                    onTap: () => ref.read(fontSizeProvider.notifier).setSize(s),
                    child: Text(
                      s.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: active ? AppTheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Preview: FabroCent — Ksh 12,500',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // ── Bold Text ──────────────────────────────────────────────────
        _SwitchRow(
          icon: Icons.format_bold_rounded,
          title: 'Bold Text',
          subtitle: 'Make all text heavier throughout the app',
          value: isBold,
          onChanged: (v) => ref.read(boldTextProvider.notifier).toggle(v),
        ),

        const Divider(height: 1),

        // ── Reduce Motion ──────────────────────────────────────────────
        _SwitchRow(
          icon: Icons.animation_outlined,
          title: 'Reduce Motion',
          subtitle: 'Minimize animations and transitions',
          value: reduceMotion,
          onChanged: (v) => ref.read(reduceMotionProvider.notifier).toggle(v),
        ),

        const Divider(height: 1),

        // ── Reset ──────────────────────────────────────────────────────
        InkWell(
          onTap: () {
            ref.read(fontSizeProvider.notifier).setSize(AppFontSize.normal);
            ref.read(boldTextProvider.notifier).toggle(false);
            ref.read(reduceMotionProvider.notifier).toggle(false);
          },
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _IconBadge(icon: Icons.restart_alt_rounded, color: AppTheme.warning),
                const SizedBox(width: 12),
                Text(
                  'Reset to defaults',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Notifications card
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsCard extends StatelessWidget {
  final PermissionStatus? notifStatus;
  final VoidCallback onRequest;

  const _NotificationsCard({
    required this.notifStatus,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final showBanner = !kIsWeb && notifStatus != null && !notifStatus!.isGranted;

    return _SettingsCard(
      children: [
        _CardHeader(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          hint: 'Configure your alert preferences',
        ),
        const Divider(height: 1),

        if (showBanner) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_off_outlined, color: AppTheme.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      notifStatus!.isPermanentlyDenied
                          ? 'Notifications blocked — open Settings to allow.'
                          : 'Allow notifications to get real-time alerts.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.warning),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: notifStatus!.isPermanentlyDenied ? openAppSettings : onRequest,
                    child: Text(
                      notifStatus!.isPermanentlyDenied ? 'Settings' : 'Allow',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        _NotifToggleRow(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Budget Alerts',
          subtitle: 'Warn when you approach a spending limit',
          getValue: (p) => p.budgetAlerts,
          setValue: (n, v) => n.setBudgetAlerts(v),
        ),
        const Divider(height: 1, indent: 16),
        _NotifToggleRow(
          icon: Icons.receipt_long_outlined,
          title: 'Transaction Alerts',
          subtitle: 'Notify on each new M-Pesa transaction',
          getValue: (p) => p.transactionAlerts,
          setValue: (n, v) => n.setTransactionAlerts(v),
        ),
        const Divider(height: 1, indent: 16),
        _NotifToggleRow(
          icon: Icons.bar_chart_rounded,
          title: 'Weekly Summary',
          subtitle: 'Sunday spending digest sent each week',
          getValue: (p) => p.weeklySummary,
          setValue: (n, v) => n.setWeeklySummary(v),
        ),
      ],
    );
  }
}

class _NotifToggleRow extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool Function(NotificationPrefs) getValue;
  final Future<void> Function(NotificationPrefsNotifier, bool) setValue;

  const _NotifToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.getValue,
    required this.setValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(notificationPrefsProvider);
    final prefs = prefsAsync.valueOrNull ?? const NotificationPrefs();
    final val = getValue(prefs);

    return _SwitchRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      value: val,
      onChanged: prefsAsync.isLoading
          ? (_) {}
          : (v) => setValue(ref.read(notificationPrefsProvider.notifier), v),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SMS card
// ─────────────────────────────────────────────────────────────────────────────

class _SmsCard extends StatelessWidget {
  final PermissionStatus? smsStatus;
  final VoidCallback onRequest;

  const _SmsCard({required this.smsStatus, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final granted   = smsStatus?.isGranted ?? false;
    final permanent = smsStatus?.isPermanentlyDenied ?? false;
    final loading   = smsStatus == null;

    final statusColor = granted ? AppTheme.incomeGreen : permanent ? AppTheme.expenseRed : AppTheme.warning;
    final statusLabel = granted ? 'Granted' : permanent ? 'Blocked' : 'Not granted';
    final statusIcon  = granted ? Icons.check_circle_rounded
        : permanent ? Icons.cancel_rounded
        : Icons.warning_amber_rounded;

    return _SettingsCard(
      children: [
        _CardHeader(
          icon: Icons.sms_outlined,
          title: 'SMS Access',
          hint: 'Required to read M-Pesa messages',
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'FabroCent reads only M-Pesa messages from your inbox to automatically '
                      'detect and log transactions. No other messages are accessed or stored.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (loading)
                    const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  else
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 4),
                      Text(statusLabel, style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor, fontWeight: FontWeight.w700,
                      )),
                    ]),
                ],
              ),
              if (!granted) ...[
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: permanent ? openAppSettings : onRequest,
                    icon: Icon(permanent ? Icons.settings_outlined : Icons.check_circle_outline, size: 17),
                    label: Text(permanent ? 'Open App Settings' : 'Grant SMS Permission'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.5)),
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bank card
// ─────────────────────────────────────────────────────────────────────────────

class _BankCard extends ConsumerWidget {
  const _BankCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankAsync = ref.watch(bankSmsProvider);
    final prefs = bankAsync.valueOrNull ?? const BankSmsPrefs();
    final theme = Theme.of(context);

    return _SettingsCard(
      children: [
        _SwitchRow(
          icon: Icons.account_balance_outlined,
          title: 'Bank Account SMS',
          subtitle: 'Track debit & credit from your bank accounts',
          value: prefs.enabled,
          onChanged: bankAsync.isLoading
              ? (_) {}
              : (v) => ref.read(bankSmsProvider.notifier).setEnabled(v),
        ),
        if (prefs.enabled) ...[
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Select banks to include. Only SMS from chosen banks will be read.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          ...knownKenyanBanks.map((bank) {
            final enabled = prefs.enabledPrefKeys.contains(bank.prefKey);
            return _BankToggleRow(bank: bank, enabled: enabled, prefs: prefs);
          }),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _BankToggleRow extends ConsumerWidget {
  final KenyanBank bank;
  final bool enabled;
  final BankSmsPrefs prefs;

  const _BankToggleRow({required this.bank, required this.enabled, required this.prefs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => ref.read(bankSmsProvider.notifier).toggleBank(bank.prefKey, !enabled),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
        child: Row(
          children: [
            Text(bank.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(child: Text(bank.name, style: theme.textTheme.bodyMedium)),
            Switch.adaptive(
              value: enabled,
              onChanged: (v) => ref.read(bankSmsProvider.notifier).toggleBank(bank.prefKey, v),
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Language card
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageCard extends ConsumerWidget {
  final UserProfile? profile;
  const _LanguageCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final current = profile?.language ?? AppLanguage.english;

    return _SettingsCard(
      children: [
        _CardHeader(
          icon: Icons.language_outlined,
          title: 'Language',
          hint: 'Choose your preferred language',
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Row(
            children: AppLanguage.values.map((lang) {
              final selected = current == lang;
              final isEnglish = lang == AppLanguage.english;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isEnglish ? 8 : 0),
                  child: GestureDetector(
                    onTap: profile == null
                        ? null
                        : () => ref.read(userProfileRepositoryProvider).save(
                              profile!.copyWith(language: lang),
                            ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary.withValues(alpha: 0.08)
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? AppTheme.primary : theme.dividerColor,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isEnglish ? '🇬🇧' : '🇰🇪',
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isEnglish ? 'English' : 'Kiswahili',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: selected ? AppTheme.primary : null,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEnglish ? 'English' : 'Kiswahili',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 10,
                            ),
                          ),
                          if (selected) ...[
                            const SizedBox(height: 4),
                            const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 14),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Data card
// ─────────────────────────────────────────────────────────────────────────────

class _DataCard extends StatelessWidget {
  final bool syncLoading;
  final bool clearLoading;
  final VoidCallback onSync;
  final VoidCallback onClear;

  const _DataCard({
    required this.syncLoading,
    required this.clearLoading,
    required this.onSync,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SettingsCard(
      children: [
        _CardHeader(
          icon: Icons.storage_outlined,
          title: 'Data',
          hint: 'Sync and manage local transaction data',
        ),
        const Divider(height: 1),
        // Sync row
        InkWell(
          onTap: syncLoading ? null : onSync,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _IconBadge(icon: Icons.sync_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sync to Cloud', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        kIsWeb ? 'Available on Android only' : 'Upload local transactions to Firebase',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                syncLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.chevron_right, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ),
        const Divider(height: 1, indent: 16),
        // Clear row
        InkWell(
          onTap: (clearLoading || kIsWeb) ? null : onClear,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _IconBadge(icon: Icons.delete_outline, color: kIsWeb ? Colors.grey : AppTheme.expenseRed),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clear Local Data',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: kIsWeb ? theme.colorScheme.onSurface.withValues(alpha: 0.4) : AppTheme.expenseRed,
                        ),
                      ),
                      Text(
                        kIsWeb ? 'No local data on web' : 'Delete all offline transaction data',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                clearLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.chevron_right, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  About card
// ─────────────────────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset('assets/images/logo.jpeg', width: 52, height: 52, fit: BoxFit.cover),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FabroCent', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text('v1.0.0', style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                  Text('M-Pesa Intelligence', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        InkWell(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _IconBadge(icon: Icons.shield_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Privacy Policy', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text('How your data is used and protected', style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sign-out button
// ─────────────────────────────────────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.expenseRed,
          side: const BorderSide(color: AppTheme.expenseRed),
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
