import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/theme/app_theme.dart';

enum _AuthMethod { email, phone }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthMethod _method = _AuthMethod.email;
  bool _isSignUp = false;

  // Email
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Phone
  final _phoneController = TextEditingController();
  final _otpController   = TextEditingController();
  bool _codeSent = false;
  String? _verificationId;         // native (Android/iOS)
  ConfirmationResult? _webConfirm; // web

  bool    _loading = false;
  String? _error;
  String? _infoMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // ─── Error helpers ──────────────────────────────────────────────────────────

  String _friendlyEmailError(dynamic e) {
    if (e is FirebaseAuthException) {
      AppLogger.error('🔐 AUTH', 'Email auth error: ${e.code}', e);
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again.';
        case 'user-not-found':
          return 'No account found with that email. Try signing up.';
        case 'email-already-in-use':
          return 'An account already exists with this email. Try signing in.';
        case 'weak-password':
          return 'Password is too short. Use at least 6 characters.';
        case 'invalid-email':
          return 'That email address doesn\'t look right.';
        case 'network-request-failed':
          return 'No internet connection. Please check and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    AppLogger.error('🔐 AUTH', 'Unexpected email auth error', e);
    return 'Something went wrong. Please try again.';
  }

  String _friendlyPhoneError(dynamic e) {
    if (e is FirebaseAuthException) {
      AppLogger.error('🔐 AUTH', 'Phone auth error: ${e.code}', e);
      switch (e.code) {
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'invalid-phone-number':
          return 'That phone number doesn\'t look right. Please check and try again.';
        case 'network-request-failed':
          return 'No internet connection. Please check and try again.';
        case 'invalid-verification-code':
          return 'That code is incorrect. Please check the SMS and try again.';
        case 'session-expired':
          return 'Your verification session expired. Please request a new code.';
        case 'quota-exceeded':
          return 'Service is busy right now. Please try again in a few minutes.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    AppLogger.error('🔐 AUTH', 'Unexpected phone auth error', e);
    return 'Something went wrong. Please try again.';
  }

  // ─── Email auth ─────────────────────────────────────────────────────────────

  Future<void> _emailSignIn() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please enter your email and password.');
      return;
    }
    AppLogger.auth('Email sign-in attempt for $email');
    setState(() { _loading = true; _error = null; _infoMessage = null; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password,
      );
      AppLogger.auth('✅ Email sign-in successful');
      // Router redirect handles navigation once authStateProvider emits.
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = _friendlyEmailError(e); });
    } catch (e) {
      setState(() { _loading = false; _error = _friendlyEmailError(e); });
    }
  }

  Future<void> _emailSignUp() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please enter your email and password.');
      return;
    }
    AppLogger.auth('Email sign-up attempt for $email');
    setState(() { _loading = true; _error = null; _infoMessage = null; });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      AppLogger.auth('✅ Email sign-up successful');
      // Router redirect handles navigation once authStateProvider emits.
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = _friendlyEmailError(e); });
    } catch (e) {
      setState(() { _loading = false; _error = _friendlyEmailError(e); });
    }
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Enter your email address first.');
      return;
    }
    AppLogger.auth('Password reset requested for $email');
    setState(() { _loading = true; _error = null; _infoMessage = null; });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AppLogger.auth('✅ Password reset email sent to $email');
      setState(() { _loading = false; _infoMessage = InheritedStrings.of(context).authResetSent; });
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = _friendlyEmailError(e); });
    }
  }

  // ─── Phone auth ─────────────────────────────────────────────────────────────

  Future<void> _sendCode() async {
    final raw = _phoneController.text.trim();
    if (raw.isEmpty) return;

    String phone = raw.replaceAll(RegExp(r'\s'), '');
    if (phone.startsWith('0')) phone = '+254${phone.substring(1)}';
    if (!phone.startsWith('+')) phone = '+$phone';

    AppLogger.auth('Sending OTP to $phone (${kIsWeb ? "web" : "native"})');
    setState(() { _loading = true; _error = null; _infoMessage = null; });

    if (kIsWeb) {
      try {
        _webConfirm = await FirebaseAuth.instance.signInWithPhoneNumber(phone);
        AppLogger.auth('OTP SMS sent (web) — awaiting code entry');
        setState(() { _loading = false; _codeSent = true; });
      } on FirebaseAuthException catch (e) {
        setState(() { _loading = false; _error = _friendlyPhoneError(e); });
      } catch (e) {
        setState(() { _loading = false; _error = _friendlyPhoneError(e); });
      }
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          AppLogger.auth('Auto-verification completed — signing in');
          await FirebaseAuth.instance.signInWithCredential(credential);
          AppLogger.auth('✅ Auto sign-in successful');
          if (mounted) context.go(AppRoutes.permissions);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() { _loading = false; _error = _friendlyPhoneError(e); });
        },
        codeSent: (String verificationId, int? resendToken) {
          AppLogger.auth('OTP SMS sent (native) — awaiting code entry');
          setState(() { _loading = false; _codeSent = true; _verificationId = verificationId; });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          AppLogger.auth('OTP auto-retrieval timed out');
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    }
  }

  Future<void> _verifyCode() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }
    AppLogger.auth('Verifying OTP (${kIsWeb ? "web" : "native"})');
    setState(() { _loading = true; _error = null; });
    try {
      if (kIsWeb) {
        if (_webConfirm == null) return;
        await _webConfirm!.confirm(code);
      } else {
        if (_verificationId == null) return;
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: code,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      AppLogger.auth('✅ OTP verified — sign-in successful');
      if (mounted && !kIsWeb) context.go(AppRoutes.permissions);
    } on FirebaseAuthException catch (e) {
      setState(() { _loading = false; _error = _friendlyPhoneError(e); });
    } catch (e) {
      setState(() { _loading = false; _error = _friendlyPhoneError(e); });
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s     = InheritedStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go(AppRoutes.welcome)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Method selector (native only — web uses email exclusively) ──
              if (!kIsWeb) ...[
                _MethodSelector(
                  selected: _method,
                  emailLabel: s.authTabEmail,
                  phoneLabel: s.authTabPhone,
                  onChanged: (m) => setState(() {
                    _method = m;
                    _error = null;
                    _infoMessage = null;
                    _codeSent = false;
                  }),
                ),
                const SizedBox(height: 28),
              ] else
                const SizedBox(height: 20),

              if (_method == _AuthMethod.email || kIsWeb) ...[
                _EmailSection(
                  isSignUp: _isSignUp,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  loading: _loading,
                  error: _error,
                  infoMessage: _infoMessage,
                  onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                  onSubmit: _isSignUp ? _emailSignUp : _emailSignIn,
                  onForgotPassword: _sendPasswordReset,
                  onToggleMode: () => setState(() {
                    _isSignUp = !_isSignUp;
                    _error = null;
                    _infoMessage = null;
                  }),
                  s: s,
                  theme: theme,
                ),
              ] else ...[
                _PhoneSection(
                  phoneController: _phoneController,
                  otpController: _otpController,
                  codeSent: _codeSent,
                  loading: _loading,
                  error: _error,
                  onSendCode: _sendCode,
                  onVerifyCode: _verifyCode,
                  onChangeNumber: () => setState(() { _codeSent = false; _error = null; }),
                  s: s,
                  theme: theme,
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Method selector ──────────────────────────────────────────────────────────

class _MethodSelector extends StatelessWidget {
  final _AuthMethod selected;
  final String emailLabel;
  final String phoneLabel;
  final ValueChanged<_AuthMethod> onChanged;

  const _MethodSelector({
    required this.selected,
    required this.emailLabel,
    required this.phoneLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _Tab(
            label: emailLabel,
            icon: Icons.email_outlined,
            selected: selected == _AuthMethod.email,
            onTap: () => onChanged(_AuthMethod.email),
          ),
          _Tab(
            label: phoneLabel,
            icon: Icons.phone_outlined,
            selected: selected == _AuthMethod.phone,
            onTap: () => onChanged(_AuthMethod.phone),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
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
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16,
                color: selected ? AppTheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppTheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Email section ────────────────────────────────────────────────────────────

class _EmailSection extends StatelessWidget {
  final bool isSignUp;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool loading;
  final String? error;
  final String? infoMessage;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onToggleMode;
  final AppStrings s;
  final ThemeData theme;

  const _EmailSection({
    required this.isSignUp,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.loading,
    required this.error,
    required this.infoMessage,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onToggleMode,
    required this.s,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSignUp ? s.authSignUpTitle : s.authSignInTitle,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          isSignUp ? s.authSignUpSubtitle : s.authSignInSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 28),

        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: s.authEmailHint,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 14),

        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            hintText: s.authPasswordHint,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
              ),
              onPressed: onToggleObscure,
            ),
          ),
          onFieldSubmitted: (_) => onSubmit(),
        ),

        if (error != null) ...[
          const SizedBox(height: 12),
          _ErrorBanner(message: error!),
        ],

        if (infoMessage != null) ...[
          const SizedBox(height: 12),
          _InfoBanner(message: infoMessage!),
        ],

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: loading ? null : onSubmit,
          child: loading
              ? const SizedBox(height: 22, width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Text(isSignUp ? s.authSignUpBtn : s.authSignInBtn),
        ),

        if (!isSignUp) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: loading ? null : onForgotPassword,
              child: Text(s.authForgotPassword,
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
            ),
          ),
        ],

        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: onToggleMode,
            child: Text(isSignUp ? s.authHaveAccount : s.authNoAccount,
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ),
      ],
    );
  }
}

// ─── Phone section ────────────────────────────────────────────────────────────

class _PhoneSection extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController otpController;
  final bool codeSent;
  final bool loading;
  final String? error;
  final VoidCallback onSendCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onChangeNumber;
  final AppStrings s;
  final ThemeData theme;

  const _PhoneSection({
    required this.phoneController,
    required this.otpController,
    required this.codeSent,
    required this.loading,
    required this.error,
    required this.onSendCode,
    required this.onVerifyCode,
    required this.onChangeNumber,
    required this.s,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          codeSent ? s.authOtpTitle : s.authPhoneTitle,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          codeSent
              ? s.authOtpSubtitle(phoneController.text)
              : s.authPhoneSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 28),

        if (!codeSent) ...[
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: '0712 345 678',
              prefixIcon: Padding(
                padding: EdgeInsets.all(14),
                child: Text('🇰🇪  +254', style: TextStyle(fontSize: 15)),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0),
            ),
            style: theme.textTheme.headlineSmall,
          ),
        ] else ...[
          TextFormField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: '• • • • • •',
              counterText: '',
            ),
            style: theme.textTheme.headlineLarge?.copyWith(letterSpacing: 12),
          ),
        ],

        if (error != null) ...[
          const SizedBox(height: 12),
          _ErrorBanner(message: error!),
        ],

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: loading ? null : (codeSent ? onVerifyCode : onSendCode),
          child: loading
              ? const SizedBox(height: 22, width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Text(codeSent ? s.authVerifyCode : s.authSendCode),
        ),

        if (codeSent) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: loading ? null : onChangeNumber,
              child: Text(s.authChangeNumber),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Shared feedback banners ──────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message,
            style: const TextStyle(color: AppTheme.error, fontSize: 13))),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String message;
  const _InfoBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message,
            style: const TextStyle(color: AppTheme.primary, fontSize: 13))),
        ],
      ),
    );
  }
}
