import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

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
import '../services/app_logger.dart';
import '../services/background_sms_service.dart';
import '../services/period_service.dart';
import '../services/remote_config_service.dart';

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
      final authLoading    = authState.isLoading;
      final profileLoading = userProfile.isLoading;
      final isLoading      = authLoading || profileLoading;

      AppLogger.router(
        'redirect fired — location="${state.matchedLocation}" '
        'authLoading=$authLoading profileLoading=$profileLoading '
        'authUser=${authState.valueOrNull?.uid ?? "null"} '
        'profileExists=${userProfile.valueOrNull != null} '
        'onboarded=${userProfile.valueOrNull?.onboardingComplete}',
      );

      if (isLoading) {
        AppLogger.router('→ still loading — staying on splash');
        return null;
      }

      final user = authState.valueOrNull;
      final profile = userProfile.valueOrNull;
      final location = state.matchedLocation;

      if (user == null) {
        // Splash is a loading screen only — once loading is done, move on.
        if (location == AppRoutes.splash) {
          AppLogger.router('→ no user, loading done — redirecting splash to welcome');
          return AppRoutes.welcome;
        }
        if (location == AppRoutes.welcome || location == AppRoutes.auth) {
          AppLogger.router('→ no user, already on auth flow — no redirect');
          return null;
        }
        AppLogger.router('→ no user — redirecting to welcome');
        return AppRoutes.welcome;
      }

      if (profile == null || !profile.onboardingComplete) {
        // Web: skip SMS permissions screen — go straight to profile setup
        if (kIsWeb) {
          if (location == AppRoutes.profileSetup) {
            AppLogger.router('→ onboarding incomplete (web) — already on profile-setup');
            return null;
          }
          AppLogger.router('→ onboarding incomplete (web) — redirecting to profile-setup');
          return AppRoutes.profileSetup;
        }
        if (location == AppRoutes.permissions ||
            location == AppRoutes.profileSetup) {
          AppLogger.router('→ onboarding incomplete — already on onboarding screen');
          return null;
        }
        AppLogger.router('→ onboarding incomplete — redirecting to permissions');
        return AppRoutes.permissions;
      }

      if (location == AppRoutes.splash ||
          location == AppRoutes.welcome ||
          location == AppRoutes.auth ||
          location == AppRoutes.permissions ||
          location == AppRoutes.profileSetup) {
        AppLogger.router('→ fully authenticated & onboarded — redirecting to home');
        return AppRoutes.home;
      }

      AppLogger.router('→ no redirect needed');
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(path: AppRoutes.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: AppRoutes.permissions,
        builder: (_, _) => const PermissionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (_, _) => const ProfileSetupScreen(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeShell()),
    ],
  );
});

// ─── Home shell (bottom nav) ──────────────────────────────────────────────────

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startupServices());
  }

  Future<void> _startupServices() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    if (!kIsWeb) {
      // Ensure there's an active financial period for this month (Isar)
      await PeriodService.ensureCurrentPeriod(user.uid);
      // Schedule hourly background SMS catch-up
      await BackgroundSmsService.schedulePeriodicSync(user.uid);
    }

    // Remote Config works on all platforms
    await RemoteConfigService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
