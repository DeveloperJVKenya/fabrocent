import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/inherited_strings.dart';
import 'core/models/user_profile.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class FabrocentApp extends ConsumerWidget {
  const FabrocentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final strings = ref.watch(appStringsProvider);
    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final fontScale = ref.watch(fontSizeProvider).valueOrNull?.scale ?? 1.0;
    final isBold    = ref.watch(boldTextProvider).valueOrNull ?? false;

    return InheritedStrings(
      strings: strings,
      child: MaterialApp.router(
        title: 'FabroCent',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScale),
            boldText: isBold,
          ),
          child: child!,
        ),
        routerConfig: router,
        locale: strings.language == AppLanguage.swahili
            ? const Locale('sw')
            : const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('sw')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
