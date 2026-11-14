import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class AppTheme {
  AppTheme._();

  // Brand colours
  static const Color primary = Color(0xFF1A5C31);
  static const Color primaryLight = Color(0xFF2E7D4F);
  static const Color primaryContainer = Color(0xFFDFF0E6);
  static const Color accent = Color(0xFFE09810);
  static const Color accentLight = Color(0xFFFFF5D9);
  static const Color error = Color(0xFFB53426);
  static const Color errorLight = Color(0xFFFDEAE8);
  static const Color warning = Color(0xFFA85E00);
  static const Color warningLight = Color(0xFFFFF1DB);

  // Income / expense semantic colors
  static const Color incomeGreen = Color(0xFF2E7D32);
  static const Color expenseRed = Color(0xFFC62828);

  // ─── Light theme ──────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      error: error,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      // Brand green bar — consistent identity across all app screens.
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: _textTheme(isDark: false),
    inputDecorationTheme: _inputDecoration(isDark: false),
    elevatedButtonTheme: _elevatedButton(),
    outlinedButtonTheme: _outlinedButton(),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 22);
        }
        return const IconThemeData(color: Color(0xFF8A9B8D), size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: primary,
          );
        }
        return const TextStyle(fontSize: 11, color: Color(0xFF8A9B8D));
      }),
      elevation: 4,
      surfaceTintColor: Colors.transparent,
      shadowColor: Color(0x14000000),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF0F0F0),
      labelStyle: const TextStyle(
        color: primary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 1,
    ),
  );

  // ─── Dark theme ───────────────────────────────────────────────────────────
  // Dark palette — deep forest green, not generic Material grey
  static const Color _darkScaffold      = Color(0xFF0C1810);  // near-black forest
  static const Color _darkCard          = Color(0xFF142019);  // elevated surface
  static const Color _darkAppBar        = Color(0xFF0F2518);  // deep brand green
  static const Color _darkNavBar        = Color(0xFF101A13);  // matches scaffold
  static const Color _darkDivider       = Color(0xFF1E2F22);  // subtle green line
  static const Color _darkPrimary       = Color(0xFF5EC47E);  // brighter on dark bg
  static const Color _darkSecondary     = Color(0xFFEAB020);
  static const Color _darkIndicator     = Color(0xFF1B3225);  // nav indicator
  static const Color _darkIconUnsel     = Color(0xFF6A9074);  // unselected icons

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkPrimary,
      primary: _darkPrimary,
      secondary: _darkSecondary,
      error: const Color(0xFFE06055),
      surface: _darkCard,
      onSurface: const Color(0xFFDFEDE4),
      surfaceContainerHighest: const Color(0xFF1C2E22),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: _darkScaffold,
    cardColor: _darkCard,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkAppBar,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: _textTheme(isDark: true),
    inputDecorationTheme: _inputDecoration(isDark: true),
    elevatedButtonTheme: _elevatedButton(isDark: true),
    outlinedButtonTheme: _outlinedButton(isDark: true),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkNavBar,
      indicatorColor: _darkIndicator,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _darkPrimary, size: 22);
        }
        return IconThemeData(color: _darkIconUnsel, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _darkPrimary,
          );
        }
        return TextStyle(fontSize: 11, color: _darkIconUnsel);
      }),
      elevation: 4,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black54,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1C2E22),
      labelStyle: const TextStyle(
        color: _darkPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: _darkDivider,
      thickness: 1,
      space: 1,
    ),
  );

  static TextTheme _textTheme({required bool isDark}) {
    final base = isDark ? const Color(0xFFE8E8E8) : const Color(0xFF1A1A1A);
    final muted = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF616161);
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: base,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: base,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: base,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: base,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: base,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: base,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: base,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: base,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: muted,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: base,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: muted,
        letterSpacing: 0.5,
      ),
    );
  }

  static InputDecorationTheme _inputDecoration({required bool isDark}) {
    final borderColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFDDDDDD);
    final fillColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF0F0F0);
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static ElevatedButtonThemeData _elevatedButton({bool isDark = false}) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF4DB872) : primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          elevation: 0,
        ),
      );

  static OutlinedButtonThemeData _outlinedButton({bool isDark = false}) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? const Color(0xFF4DB872) : primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: isDark ? const Color(0xFF4DB872) : primary),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      );
}
