import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/services/background_sms_service.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ProfileSetupScreen
// ─────────────────────────────────────────────────────────────────────────────

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController  = TextEditingController();
  final _phoneController = TextEditingController();
  UserSegment _segment   = UserSegment.employed;
  AppLanguage _language  = AppLanguage.english;
  bool _hasPochi = false;
  bool _hasTill  = false;
  bool _loading  = false;
  int  _page     = 0;

  int get _totalSteps => _segment.hasBusinessAccount ? 3 : 2;

  List<String> get _stepLabels => _segment.hasBusinessAccount
      ? ['Personal', 'Profile', 'Business']
      : ['Personal', 'Profile'];

  bool get _isLastPage => _page == _totalSteps - 1;

  @override
  void initState() {
    super.initState();
    final existing = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    if (existing.isNotEmpty) _phoneController.text = existing;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name before continuing.')),
      );
      if (_page != 0) setState(() => _page = 0);
      return;
    }

    setState(() => _loading = true);

    try {
      final user     = FirebaseAuth.instance.currentUser!;
      final rawPhone = _phoneController.text.trim();
      String phone   = rawPhone.isNotEmpty ? rawPhone : (user.phoneNumber ?? '');
      if (phone.startsWith('0')) phone = '+254${phone.substring(1)}';

      AppLogger.ui(
        'ProfileSetup: saving uid=${user.uid} '
        'name="$name" segment=${_segment.name} lang=${_language.name}',
      );

      final profile = UserProfile(
        uid:               user.uid,
        phoneNumber:       phone,
        displayName:       name.isEmpty ? null : name,
        segment:           _segment,
        language:          _language,
        hasPochi:          _hasPochi,
        hasTill:           _hasTill,
        hasPaybill:        false,
        periodStartDay:    1,
        onboardingComplete: true,
        biometricEnabled:  false,
        createdAt:         DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(profile.toFirestore(), SetOptions(merge: true));

      AppLogger.ui('✅ ProfileSetup: profile saved — navigating to home');

      // Navigate first; SMS scheduling is non-critical and native-only.
      if (mounted) context.go(AppRoutes.home);

      // Fire-and-forget background SMS sync (Android / iOS only).
      if (!kIsWeb) {
        unawaited(
          BackgroundSmsService.schedulePeriodicSync(user.uid).catchError(
            (Object e, StackTrace st) {
              AppLogger.error('🖼  UI', 'BackgroundSmsService scheduling failed', e, st);
            },
          ),
        );
      }
    } catch (e, st) {
      AppLogger.error('🖼  UI', 'ProfileSetup: failed to save profile', e, st);
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save your profile. Please try again.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size  = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin:  Alignment.topLeft,
            end:    Alignment.bottomRight,
            colors: [Color(0xFF0A2912), Color(0xFF1A5C31)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative orbs — same visual language as the welcome screen
            Positioned(
              top:   -size.width * 0.28,
              right: -size.width * 0.28,
              child: Container(
                width:  size.width * 0.85,
                height: size.width * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.3,
              left:   -size.width * 0.15,
              child: Container(
                width:  size.width * 0.45,
                height: size.width * 0.45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.025),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_page == 0) _buildNamePage(theme),
                          if (_page == 1) _buildSegmentPage(theme),
                          if (_page == 2) _buildBusinessPage(theme),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  _buildNavRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step header ──────────────────────────────────────────────────────────

  Widget _buildStepHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (int i = 0; i < _totalSteps; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: i <= _page
                            ? Colors.white.withValues(alpha: 0.65)
                            : Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                _StepCircle(index: i, currentPage: _page),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Step ${_page + 1} of $_totalSteps',
                style: TextStyle(
                  color:      Colors.white.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                  fontSize:   12,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '·',
                style: TextStyle(
                  color:    Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _stepLabels[_page],
                style: const TextStyle(
                  color:        Colors.white,
                  fontWeight:   FontWeight.w700,
                  fontSize:     12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Navigation row ───────────────────────────────────────────────────────

  Widget _buildNavRow() {
    final s = InheritedStrings.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_page > 0)
            _GhostButton(
              label:     s.back,
              onPressed: () => setState(() => _page--),
            )
          else
            const SizedBox.shrink(),
          _GradientButton(
            label:   !_isLastPage ? s.next : s.profileStartTracking,
            icon:    !_isLastPage ? Icons.arrow_forward_rounded : Icons.check_rounded,
            loading: _loading,
            onPressed: _loading
                ? null
                : () {
                    if (_page == 0) {
                      // Validate name before advancing
                      if (_nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter your name to continue.')),
                        );
                        return;
                      }
                      setState(() => _page++);
                    } else if (!_isLastPage) {
                      setState(() => _page++);
                    } else {
                      _save();
                    }
                  },
          ),
        ],
      ),
    );
  }

  // ─── Page 1: Personal ────────────────────────────────────────────────────

  Widget _buildNamePage(ThemeData theme) {
    final s = InheritedStrings.of(context);
    return _PageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.profileNameTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            s.profileNameSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            controller:          _nameController,
            decoration:          InputDecoration(hintText: s.profileNameHint),
            textCapitalization:  TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextField(
            controller:   _phoneController,
            keyboardType: TextInputType.phone,
            decoration:   const InputDecoration(
              hintText: '0712 345 678',
              prefixIcon: Padding(
                padding: EdgeInsets.all(14),
                child: Text('🇰🇪  +254', style: TextStyle(fontSize: 15)),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0),
              helperText: 'Optional — used to link your M-Pesa SMS',
            ),
          ),
          const SizedBox(height: 24),
          Text(s.profileLangLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: AppLanguage.values.map((lang) {
              final selected = _language == lang;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _language = lang),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color:  selected ? AppTheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? AppTheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          lang == AppLanguage.english ? '🇬🇧 English' : '🇰🇪 Kiswahili',
                          style: TextStyle(
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color:      selected ? AppTheme.primary : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Page 2: Segment ─────────────────────────────────────────────────────

  Widget _buildSegmentPage(ThemeData theme) {
    final s = InheritedStrings.of(context);
    return _PageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.profileSegTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            s.profileSegSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          ...UserSegment.values.map((seg) {
            final selected = _segment == seg;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(() => _segment = seg),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primary.withValues(alpha: 0.08) : theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppTheme.primary : theme.dividerColor,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              seg.displayName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: selected ? AppTheme.primary : null,
                              ),
                            ),
                            Text(seg.description, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (selected)
                        const Icon(Icons.check_circle, color: AppTheme.primary),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Page 3: Business ────────────────────────────────────────────────────

  Widget _buildBusinessPage(ThemeData theme) {
    final s = InheritedStrings.of(context);
    return _PageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.profileBizTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            s.profileBizSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          _ToggleCard(
            title:     'Pochi la Biashara',
            subtitle:  'A separate business wallet linked to your M-Pesa number for receiving customer payments.',
            value:     _hasPochi,
            onChanged: (v) => setState(() => _hasPochi = v),
          ),
          const SizedBox(height: 12),
          _ToggleCard(
            title:     'Till Number (Buy Goods)',
            subtitle:  'You receive payments from customers via a Lipa Na M-Pesa Till number.',
            value:     _hasTill,
            onChanged: (v) => setState(() => _hasTill = v),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:        AppTheme.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.profileBizInfo,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.warning),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps page content in an elevated surface card floating on the gradient bg.
class _PageCard extends StatelessWidget {
  final Widget child;
  const _PageCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:        theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.28),
            blurRadius: 28,
            offset:     const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Numbered step circle on the dark gradient header.
class _StepCircle extends StatelessWidget {
  final int index;
  final int currentPage;
  const _StepCircle({required this.index, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentPage;
    final isCurrent   = index == currentPage;
    return Container(
      width:  30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? Colors.white.withValues(alpha: 0.9)
            : (isCurrent ? Colors.white.withValues(alpha: 0.15) : Colors.transparent),
        border: Border.all(
          color: isCompleted || isCurrent
              ? Colors.white.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.22),
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check_rounded, size: 15, color: Color(0xFF1A5C31))
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color:      isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.38),
                  fontWeight: FontWeight.w700,
                  fontSize:   12,
                ),
              ),
      ),
    );
  }
}

/// Ghost pill button for "Back" — readable on the dark gradient.
class _GhostButton extends StatelessWidget {
  final String        label;
  final VoidCallback  onPressed;
  const _GhostButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color:        Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded,
                color: Colors.white.withValues(alpha: 0.8), size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color:      Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
                fontSize:   14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gradient pill button for "Next" / "Start Tracking" with press animation.
class _GradientButton extends StatefulWidget {
  final String        label;
  final IconData      icon;
  final bool          loading;
  final VoidCallback? onPressed;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.loading,
    this.onPressed,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _down(_)  { if (widget.onPressed != null) _ctrl.forward(); }
  void _up(_)    { _ctrl.reverse(); }
  void _cancel() { _ctrl.reverse(); }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    return GestureDetector(
      onTapDown:   _down,
      onTapUp:     _up,
      onTapCancel: _cancel,
      onTap:       widget.onPressed,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            gradient: disabled
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF4CAF72), Color(0xFF2E7D4F)],
                    begin:  Alignment.topLeft,
                    end:    Alignment.bottomRight,
                  ),
            color:        disabled ? Colors.white.withValues(alpha: 0.15) : null,
            borderRadius: BorderRadius.circular(100),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color:      const Color(0xFF2E7D4F).withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset:     const Offset(0, 6),
                    ),
                  ],
          ),
          child: widget.loading
              ? const SizedBox(
                  width:  22,
                  height: 22,
                  child:  CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color:        disabled ? Colors.white.withValues(alpha: 0.45) : Colors.white,
                        fontWeight:   FontWeight.w700,
                        fontSize:     15,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      widget.icon,
                      color: disabled ? Colors.white.withValues(alpha: 0.45) : Colors.white,
                      size:  18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _ToggleCard
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleCard extends StatelessWidget {
  final String             title;
  final String             subtitle;
  final bool               value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? AppTheme.primary.withValues(alpha: 0.08) : theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? AppTheme.primary : theme.dividerColor,
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: value ? AppTheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Switch(
              value:            value,
              onChanged:        onChanged,
              activeThumbColor: AppTheme.primary,
              activeTrackColor: AppTheme.primary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
