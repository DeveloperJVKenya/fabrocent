import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

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

  // â”€â”€â”€ Light theme â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
          error: error,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F7F4),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F7F4),
          foregroundColor: Color(0xFF182319),
          elevation: 0,
          scrolledUnderElevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFF182319),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
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
              return const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: primary);
            }
            return const TextStyle(fontSize: 11, color: Color(0xFF8A9B8D));
          }),
          elevation: 4,
          surfaceTintColor: Colors.transparent,
          shadowColor: Color(0x14000000),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFEAF2ED),
          labelStyle: const TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFC5DAC9),
          thickness: 1,
          space: 1,
        ),
      );

  // â”€â”€â”€ Dark theme â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4DB872),
          primary: const Color(0xFF4DB872),
          secondary: const Color(0xFFE8A820),
          error: const Color(0xFFE06055),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0C1710),
        cardColor: const Color(0xFF142018),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0C1710),
          foregroundColor: Color(0xFFE3EDE6),
          elevation: 0,
          scrolledUnderElevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFFE3EDE6),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        textTheme: _textTheme(isDark: true),
        inputDecorationTheme: _inputDecoration(isDark: true),
        elevatedButtonTheme: _elevatedButton(isDark: true),
        outlinedButtonTheme: _outlinedButton(isDark: true),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF142018),
          indicatorColor: const Color(0xFF1B2D20),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF4DB872), size: 22);
            }
            return const IconThemeData(color: Color(0xFF87A98D), size: 22);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF4DB872));
            }
            return const TextStyle(fontSize: 11, color: Color(0xFF87A98D));
          }),
          elevation: 4,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black38,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF1B2D20),
          labelStyle: const TextStyle(
            color: Color(0xFF4DB872),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF263C2C),
          thickness: 1,
          space: 1,
        ),
      );

  static TextTheme _textTheme({required bool isDark}) {
    final base = isDark ? const Color(0xFFE3EDE6) : const Color(0xFF182319);
    final muted = isDark ? const Color(0xFF87A98D) : const Color(0xFF506655);
    return TextTheme(
      displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: base, letterSpacing: -1),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: base, letterSpacing: -0.5),
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: base),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: base),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: base),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: base),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: base),
      titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: muted),
      bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: base, height: 1.6),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: base, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: muted, height: 1.5),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: base),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: muted),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: muted, letterSpacing: 0.5),
    );
  }

  static InputDecorationTheme _inputDecoration({required bool isDark}) {
    final borderColor = isDark ? const Color(0xFF263C2C) : const Color(0xFFC5DAC9);
    final fillColor = isDark ? const Color(0xFF1B2D20) : const Color(0xFFEAF2ED);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: isDark ? const Color(0xFF4DB872) : primary),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      );
}
