import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/services/background_sms_service.dart';
import '../../../core/services/firestore_sync_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _syncLoading = false;
  bool _clearLoading = false;
  bool _photoLoading = false;

  // â”€â”€â”€ Sync to Cloud â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _syncToCloud() async {
    if (kIsWeb) {
      _snack(InheritedStrings.of(context).webSyncNotAvailable);
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    AppLogger.sync('User triggered manual cloud sync for uid=${user.uid}');
    setState(() => _syncLoading = true);
    try {
      final service = FirestoreSyncService(ref.read(firestoreProvider));
      final count = await service.syncPendingTransactions(user.uid);
      AppLogger.sync('✅ Manual sync complete — $count transaction(s) uploaded');
      if (mounted) {
        final s = InheritedStrings.of(context);
        _snack(count == 0 ? s.alreadyUpToDate : s.syncedCount(count));
      }
    } catch (e, st) {
      AppLogger.error('☁  SYNC', 'Manual sync failed', e, st);
      if (mounted) _snack('Could not sync right now. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _syncLoading = false);
    }
  }

  // â”€â”€â”€ Clear Local Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel)),
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

    AppLogger.db('User confirmed clear local data for uid=${user.uid}');
    setState(() => _clearLoading = true);
    try {
      await IsarService.clearUserData(user.uid);
      AppLogger.db('✅ Local data cleared for uid=${user.uid}');
      if (mounted) _snack(InheritedStrings.of(context).localDataCleared);
    } catch (e, st) {
      AppLogger.error('💾 DB', 'Failed to clear local data', e, st);
      if (mounted) _snack('Could not clear data. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _clearLoading = false);
    }
  }

  // â”€â”€â”€ Language â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _changeLanguage(BuildContext ctx, UserProfile? profile) async {
    final chosen = await showModalBottomSheet<AppLanguage>(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLanguage.values.map((lang) {
            final label = lang == AppLanguage.english ? '🇬🇧 English' : '🇰🇪 Kiswahili';
            final isSelected = profile?.language == lang;
            return ListTile(
              title: Text(label),
              trailing: isSelected ? const Icon(Icons.check, color: AppTheme.primary) : null,
              onTap: () => Navigator.pop(ctx, lang),
            );
          }).toList(),
        ),
      ),
    );

    if (chosen == null || chosen == profile?.language || profile == null) return;

    try {
      await ref.read(userProfileRepositoryProvider).save(
            profile.copyWith(language: chosen),
          );
    } catch (e) {
      if (mounted) {
        _snack('Could not save language: $e', isError: true);
      }
    }
  }

  // â”€â”€â”€ Profile photo â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _pickAndUploadPhoto() async {
    if (kIsWeb) {
      _snack(InheritedStrings.of(context).webPhotoNotSupported);
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null || !mounted) return;

    setState(() => _photoLoading = true);
    try {
      final file = File(picked.path);
      final url = await StorageService.uploadProfilePhoto(
        userId: user.uid,
        imageFile: file,
      );
      final profile = ref.read(userProfileProvider).valueOrNull;
      if (profile != null) {
        await ref
            .read(userProfileRepositoryProvider)
            .save(profile.copyWith(photoUrl: url));
      }
      if (mounted) _snack(InheritedStrings.of(context).photoUpdated);
    } catch (e) {
      if (mounted) _snack('Upload failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _photoLoading = false);
    }
  }

  // â”€â”€â”€ Sign out â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _signOut() async {
    final s = InheritedStrings.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.signOutConfirmTitle),
        content: Text(s.signOutConfirmBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.signOut)),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!kIsWeb) await BackgroundSmsService.cancel();
    await FirebaseAuth.instance.signOut();
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppTheme.error : null,
    ));
  }

  // â”€â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(InheritedStrings.of(context).settingsTitle)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          final s = InheritedStrings.of(context);
          return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // â”€â”€ Account â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _SectionHeader(s.accountSection),
            _buildAvatarTile(profile),
            _InfoTile(
              icon: Icons.person_outline,
              title: s.nameLabel,
              value: profile?.displayName ?? '—',
            ),
            _InfoTile(
              icon: Icons.phone_outlined,
              title: s.phoneLabel,
              value: FirebaseAuth.instance.currentUser?.phoneNumber ?? '—',
            ),
            _InfoTile(
              icon: Icons.work_outline,
              title: s.profileTypeLabel,
              value: profile?.segment.displayName ?? '—',
            ),

            const Divider(height: 24),

            // â”€â”€ Preferences â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _SectionHeader(s.preferencesSection),
            _SettingsTile(
              icon: Icons.language_outlined,
              title: s.languageLabel,
              subtitle: profile?.language == AppLanguage.swahili
                  ? s.swahili
                  : s.english,
              onTap: () => _changeLanguage(context, profile),
            ),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: s.budgetAlertsLabel,
              subtitle: s.budgetAlertsSubtitle,
              onTap: null,
              trailing: Switch.adaptive(
                value: true,
                onChanged: (_) {},
                activeThumbColor: AppTheme.primary,
                activeTrackColor: AppTheme.primaryContainer,
              ),
            ),

            const Divider(height: 24),

            // â”€â”€ Business section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (profile?.segment.hasBusinessAccount == true) ...[
              _SectionHeader(s.pochiSection),
              _InfoTile(
                icon: Icons.store_outlined,
                title: 'Pochi la Biashara',
                value: profile?.hasPochi == true ? 'Enabled' : 'Disabled',
              ),
              _InfoTile(
                icon: Icons.point_of_sale_outlined,
                title: 'Till Number',
                value: profile?.hasTill == true ? 'Enabled' : 'Disabled',
              ),
              _InfoTile(
                icon: Icons.business_outlined,
                title: 'Paybill',
                value: profile?.hasPaybill == true ? 'Enabled' : 'Disabled',
              ),
              const Divider(height: 24),
            ],

            // â”€â”€ Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _SectionHeader(s.dataSection),
            _SettingsTile(
              icon: Icons.sync_outlined,
              title: s.syncToCloud,
              subtitle: kIsWeb ? s.syncAndroidOnly : s.syncSubtitle,
              onTap: _syncLoading ? null : _syncToCloud,
              trailing: _syncLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: s.clearLocalData,
              subtitle: kIsWeb ? s.clearNoWeb : s.clearSubtitle,
              onTap: (_clearLoading || kIsWeb) ? null : _confirmClearData,
              textColor: kIsWeb ? null : AppTheme.expenseRed,
              trailing: _clearLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),

            const Divider(height: 24),

            // â”€â”€ About â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _SectionHeader(s.aboutSection),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FabroCent',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'M-Pesa Intelligence — v1.0.0',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _InfoTile(
              icon: Icons.shield_outlined,
              title: s.privacyLabel,
              value: s.privacyValue,
            ),

            const Divider(height: 24),

            // â”€â”€ Sign out â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: Text(InheritedStrings.of(context).signOut),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.expenseRed,
                  side: const BorderSide(color: AppTheme.expenseRed),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
        },
      ),
    );
  }

  Widget _buildAvatarTile(UserProfile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: _photoLoading ? null : _pickAndUploadPhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppTheme.primaryContainer,
                  backgroundImage: (profile?.photoUrl != null && !kIsWeb)
                      ? NetworkImage(profile!.photoUrl!)
                      : null,
                  child: (profile?.photoUrl == null || kIsWeb)
                      ? Text(
                          _initials(profile?.displayName),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary),
                        )
                      : null,
                ),
                if (!kIsWeb)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2),
                    ),
                    child: _photoLoading
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                                strokeWidth: 1.5, color: Colors.white),
                          )
                        : const Icon(Icons.camera_alt,
                            size: 10, color: Colors.white),
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
                  profile?.displayName ?? InheritedStrings.of(context).yourAccount,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (!kIsWeb)
                  GestureDetector(
                    onTap: _photoLoading ? null : _pickAndUploadPhoto,
                    child: Text(
                      profile?.photoUrl != null
                          ? InheritedStrings.of(context).changePhoto
                          : InheritedStrings.of(context).addPhoto,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppTheme.primary),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
}

// â”€â”€â”€ Shared widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.primary,
                letterSpacing: 1,
              ),
        ),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoTile(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 22),
      title: Text(title, style: theme.textTheme.titleSmall),
      subtitle: Text(value, style: theme.textTheme.bodySmall),
      dense: true,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppTheme.primary, size: 22),
      title: Text(title,
          style: theme.textTheme.titleSmall?.copyWith(color: textColor)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: trailing ??
          (onTap != null ? const Icon(Icons.chevron_right, size: 18) : null),
      onTap: onTap,
      dense: true,
    );
  }
}
