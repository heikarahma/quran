import 'package:flutter/material.dart';
import 'app_colors.dart';

enum ThemeModeType { darkGold, lightMushaf, sepia }

class AppThemes {
  static ThemeData get darkTheme {
    const palette = AppPalette.darkGold;
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'PlusJakartaSans',
      scaffoldBackgroundColor: palette.bg,
      primaryColor: palette.accent,
      cardColor: palette.card,
      colorScheme: ColorScheme.dark(
        primary: palette.accent,
        secondary: palette.accentSoft,
        surface: palette.surface,
        onPrimary: Colors.black,
        onSurface: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.accent),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: palette.accent,
        unselectedItemColor: palette.textDim,
      ),
      dividerColor: palette.border,
      extensions: const [palette],
    );
  }

  static ThemeData get lightTheme {
    const palette = AppPalette.lightMushaf;
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'PlusJakartaSans',
      scaffoldBackgroundColor: palette.bg,
      primaryColor: palette.accent,
      cardColor: palette.card,
      colorScheme: ColorScheme.light(
        primary: palette.accent,
        secondary: AppColors.mushafBorderTeal,
        surface: palette.surface,
        onPrimary: Colors.white,
        onSurface: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.accent),
      ),
      dividerColor: palette.border,
      extensions: const [palette],
    );
  }

  static ThemeData get sepiaTheme {
    const palette = AppPalette.sepia;
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'PlusJakartaSans',
      scaffoldBackgroundColor: palette.bg,
      primaryColor: palette.accent,
      cardColor: palette.card,
      colorScheme: ColorScheme.light(
        primary: palette.accent,
        secondary: const Color(0xFF5C3A21),
        surface: palette.surface,
        onPrimary: Colors.white,
        onSurface: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.accent),
      ),
      dividerColor: palette.border,
      extensions: const [palette],
    );
  }
}
