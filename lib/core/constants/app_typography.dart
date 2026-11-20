import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Arabic Script Styles (uses bundled offline fonts registered in pubspec.yaml)
  static TextStyle arabicHeader({
    double fontSize = 28,
    Color color = AppColors.textWhite,
  }) {
    return TextStyle(
      fontFamily: 'Amiri',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      height: 2.0,
    );
  }

  static TextStyle arabicVerse({
    double fontSize = 24,
    Color color = AppColors.textWhite,
    String fontFamily = 'Amiri',
  }) {
    if (fontFamily == 'Scheherazade') {
      return TextStyle(
        fontFamily: 'ScheherazadeNew',
        fontSize: fontSize * 1.12,
        fontWeight: FontWeight.w600,
        color: color,
        height: 2.15,
      );
    }
    return TextStyle(
      fontFamily: 'Amiri',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
      height: 2.15,
    );
  }

  static TextStyle mushafPageArabic({
    double fontSize = 21,
    Color color = AppColors.mushafTextBlack,
    String fontFamily = 'Amiri',
  }) {
    if (fontFamily == 'Scheherazade') {
      return TextStyle(
        fontFamily: 'ScheherazadeNew',
        fontSize: fontSize * 1.08,
        fontWeight: FontWeight.w600,
        color: color,
        height: 2.0,
      );
    }
    return TextStyle(
      fontFamily: 'Amiri',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      height: 2.05,
    );
  }

  // Latin / UI Typography (PlusJakartaSans)
  static TextStyle headingLarge({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.4,
    );
  }

  static TextStyle headingMedium({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle title({Color color = AppColors.textWhite}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle body({
    double fontSize = 14,
    Color color = AppColors.textMuted,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.5,
    );
  }

  static TextStyle transliteration({
    double fontSize = 13,
    Color color = AppColors.textGold,
  }) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.45,
    );
  }

  static TextStyle translation({
    double fontSize = 14,
    Color color = AppColors.textWhite,
  }) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.6,
    );
  }

  static TextStyle caption({Color color = AppColors.textDim}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
