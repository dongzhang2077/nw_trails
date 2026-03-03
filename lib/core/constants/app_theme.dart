import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const Color primaryTeal = Color(0xFF0D7377);
  const Color accentOrange = Color(0xFFFF6B35);
  const Color textColor = Color(0xFF1F2933);
  const Color mutedText = Color(0xFF5F6C7B);

  final ColorScheme colorScheme =
      ColorScheme.fromSeed(
        seedColor: primaryTeal,
        brightness: Brightness.light,
      ).copyWith(
        primary: primaryTeal,
        secondary: accentOrange,
        onSurface: textColor,
        surface: Colors.white,
        outline: const Color(0xFFD7DDE3),
        outlineVariant: const Color(0xFFE3E8EE),
        surfaceContainerHighest: const Color(0xFFE9EEF3),
      );

  final TextTheme textTheme = ThemeData.light().textTheme.copyWith(
    headlineSmall: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: textColor,
      letterSpacing: 0.2,
    ),
    titleMedium: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: textColor,
    ),
    bodyLarge: const TextStyle(fontSize: 15, height: 1.35, color: textColor),
    bodyMedium: const TextStyle(fontSize: 14, height: 1.35, color: textColor),
    bodySmall: const TextStyle(fontSize: 12, height: 1.3, color: mutedText),
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF152028),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 0.2,
      ),
    ),
    textTheme: textTheme,
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shadowColor: Color(0x15000000),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: Color(0xFFD7DDE3)),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: Colors.white,
      selectedColor: colorScheme.primary,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      secondaryLabelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: Colors.white,
      indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
        }
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      }),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: primaryTeal,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF0D7377),
        side: const BorderSide(color: Color(0xFF0D7377)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF1F2933),
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
    ),
  );
}
