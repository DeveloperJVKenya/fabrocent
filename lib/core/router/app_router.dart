import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../features/budget/screens/budget_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/onboarding/screens/auth_screen.dart';
import '../../features/onboarding/screens/permissions_screen.dart';
import '../../features/onboarding/screens/profile_setup_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/transactions/screens/transactions_screen.dart';
import '../l10n/inherited_strings.dart';
import '../providers/firebase_providers.dart';
import '../services/background_sms_service.dart';
import '../services/period_service.dart';
import '../services/remote_config_service.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

// Timestamp for auth-loading timeout — set once at module load (= app start).
// If auth/profile streams haven't resolved after 7 s, treat as unauthenticated
// rather than hanging on the splash screen indefinitely (critical on web).
final _routerLoadStart = DateTime.now();

class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const auth = '/auth';
  static const permissions = '/permissions';
  static const profileSetup = '/profile-setup';
  static const home = '/home';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(userProfileProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoading = authState.isLoading || userProfile.isLoading;
      final location = state.matchedLocation;

      _logger.d(
        '🔀 Router: redirect → "$location" | '
        'authLoading=${authState.isLoading} profileLoading=${userProfile.isLoading}',
      );

      if (isLoading) {
        final elapsed = DateTime.now().difference(_routerLoadStart);
        if (elapsed.inSeconds < 7) {
          _logger.d('🔀 Router: waiting for auth/profile (${elapsed.inMilliseconds}ms elapsed)...');
          return null;
        }
        // Safety valve: auth streams haven't resolved — stop waiting and go to welcome.
        _logger.w('🔀 Router: auth loading timed out after ${elapsed.inSeconds}s — routing as unauthenticated');
        return AppRoutes.welcome;
      }

      final user = authState.valueOrNull;
      final profile = userProfile.valueOrNull;

      if (user == null) {
        _logger.i('🔀 Router: no authenticated user at "$location"');
        if (location == AppRoutes.welcome ||
            location == AppRoutes.auth) { return null; }
        _logger.d('🔀 Router: redirecting to ${AppRoutes.welcome}');
        return AppRoutes.welcome;
      }

      _logger.d('🔀 Router: user=${user.uid} | profile=${profile == null ? "null" : "onboarded=${profile.onboardingComplete}"}');

      if (profile == null || !profile.onboardingComplete) {
        // Web: skip SMS permissions screen — go straight to profile setup
        if (kIsWeb) {
          if (location == AppRoutes.profileSetup) return null;
          _logger.d('🔀 Router: web — redirecting to ${AppRoutes.profileSetup}');
          return AppRoutes.profileSetup;
        }
        if (location == AppRoutes.permissions ||
            location == AppRoutes.profileSetup) { return null; }
        _logger.d('🔀 Router: redirecting to ${AppRoutes.permissions}');
        return AppRoutes.permissions;
      }

      if (location == AppRoutes.splash ||
          location == AppRoutes.welcome ||
          location == AppRoutes.auth ||
          location == AppRoutes.permissions ||
          location == AppRoutes.profileSetup) {
        _logger.i('✅ Router: onboarding complete — redirecting to ${AppRoutes.home}');
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(path: AppRoutes.permissions, builder: (_, _) => const PermissionsScreen()),
      GoRoute(path: AppRoutes.profileSetup, builder: (_, _) => const ProfileSetupScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeShell()),
    ],
  );
});

// â”€â”€â”€ Home shell (bottom nav) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _currentIndex = 0;

  static const _pages = [
    DashboardScreen(),
    TransactionsScreen(),
    BudgetScreen(),
    SettingsScreen(),
  ];

  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startupServices());
  }

  Future<void> _startupServices() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      _logger.d('🏠 HomeShell: no user — skipping startup services');
      return;
    }
    _logger.i('🏠 HomeShell: starting services for user ${user.uid}');

    if (!kIsWeb) {
      // Ensure there's an active financial period for this month (Isar)
      _logger.d('🏠 HomeShell: ensuring current financial period');
      try {
        await PeriodService.ensureCurrentPeriod(user.uid);
        _logger.i('✅ HomeShell: financial period ensured');
      } catch (e, st) {
        _logger.e('❌ HomeShell: period setup failed', error: e, stackTrace: st);
      }
      // Schedule hourly background SMS catch-up
      _logger.d('🏠 HomeShell: scheduling periodic SMS sync');
      try {
        await BackgroundSmsService.schedulePeriodicSync(user.uid);
        _logger.i('✅ HomeShell: SMS sync scheduled');
      } catch (e, st) {
        _logger.e('❌ HomeShell: SMS sync scheduling failed', error: e, stackTrace: st);
      }
    }

    // Remote Config works on all platforms
    _logger.d('🏠 HomeShell: initializing Remote Config');
    try {
      await RemoteConfigService.initialize();
      _logger.i('✅ HomeShell: Remote Config initialized');
    } catch (e, st) {
      _logger.w('⚠️ HomeShell: Remote Config init failed — using defaults', error: e, stackTrace: st);
    }

    _logger.i('✅ HomeShell: all startup services complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: InheritedStrings.of(context).navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: InheritedStrings.of(context).navTransactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: InheritedStrings.of(context).navBudget,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: InheritedStrings.of(context).navSettings,
          ),
        ],
      ),
    );
  }
}
