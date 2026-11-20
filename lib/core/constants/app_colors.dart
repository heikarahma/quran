import 'package:flutter/material.dart';

class AppColors {
  // Dark Gold Luxury Palette (Primary Theme)
  static const Color darkBg = Color(0xFF11161B);
  static const Color darkSurface = Color(0xFF192026);
  static const Color darkCard = Color(0xFF222B34);
  static const Color darkCardElevated = Color(0xFF2B3642);
  static const Color darkBorder = Color(0xFF2E3B47);

  // Gold Accents
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldDark = Color(0xFFA67C1E);
  static const Color goldAccent = Color(0xFFE5C378);
  static const Color goldGlow = Color(0x33D4AF37);

  // Mushaf Illuminated Page Palette
  static const Color mushafParchment = Color(0xFFFBF9F4);
  static const Color mushafParchmentDark = Color(0xFFF4ECD8);
  static const Color mushafBorderGold = Color(0xFFC59B27);
  static const Color mushafBorderTeal = Color(0xFF1A6B74);
  static const Color mushafBorderNavy = Color(0xFF0F3B56);
  static const Color mushafTextBlack = Color(0xFF141414);
  static const Color mushafSepiaBg = Color(0xFFF3EBD8);

  // Text Colors (Dark Mode)
  static const Color textWhite = Color(0xFFF8F9FA);
  static const Color textMuted = Color(0xFF8F9CA9);
  static const Color textGold = Color(0xFFE6CA65);
  static const Color textDim = Color(0xFF627180);

  // Semantic & Highlights
  static const Color ayahHighlight = Color(0x28D4AF37);
  static const Color ayahHighlightBorder = Color(0x80D4AF37);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color rubyRed = Color(0xFFEF4444);
  static const Color sapphireBlue = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE5C378), Color(0xFFD4AF37), Color(0xFFA67C1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardHeaderGradient = LinearGradient(
    colors: [Color(0xFF2A3440), Color(0xFF1C232B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surahBannerGradient = LinearGradient(
    colors: [Color(0xFF2C2415), Color(0xFF1A1813), Color(0xFF141A1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppPalette extends ThemeExtension<AppPalette> {
  final Color bg;
  final Color surface;
  final Color card;
  final Color cardElevated;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color textDim;
  final Color accent;
  final Color accentLight;
  final Color accentSoft;
  final Color mushafBg;
  final Color mushafText;
  final List<Color> bannerGradient;
  final bool isDark;

  const AppPalette({
    required this.bg,
    required this.surface,
    required this.card,
    required this.cardElevated,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.textDim,
    required this.accent,
    required this.accentLight,
    required this.accentSoft,
    required this.mushafBg,
    required this.mushafText,
    required this.bannerGradient,
    required this.isDark,
  });

  static const darkGold = AppPalette(
    bg: AppColors.darkBg,
    surface: AppColors.darkSurface,
    card: AppColors.darkCard,
    cardElevated: AppColors.darkCardElevated,
    border: AppColors.darkBorder,
    textPrimary: AppColors.textWhite,
    textMuted: Color(0xFF9AA7B4),
    textDim: Color(0xFF778796),
    accent: AppColors.goldPrimary,
    accentLight: AppColors.goldLight,
    accentSoft: AppColors.goldAccent,
    mushafBg: AppColors.mushafParchment,
    mushafText: AppColors.mushafTextBlack,
    bannerGradient: [Color(0xFF2E2619), Color(0xFF1E1A14), Color(0xFF15191E)],
    isDark: true,
  );

  static const lightMushaf = AppPalette(
    bg: Color(0xFFF6F2E8),
    surface: Colors.white,
    card: Colors.white,
    cardElevated: Color(0xFFFDFBF6),
    border: Color(0xFFE3DBC9),
    textPrimary: Color(0xFF1A1D21),
    textMuted: Color(0xFF5A626A),
    textDim: Color(0xFF7D858E),
    accent: Color(0xFFB58612),
    accentLight: Color(0xFF8A6205),
    accentSoft: Color(0xFF9E7410),
    mushafBg: AppColors.mushafParchment,
    mushafText: AppColors.mushafTextBlack,
    bannerGradient: [Color(0xFFFDF8EC), Color(0xFFF4E9CE), Color(0xFFEDE0BE)],
    isDark: false,
  );

  static const sepia = AppPalette(
    bg: Color(0xFFEFE5D0),
    surface: Color(0xFFF7EFE0),
    card: Color(0xFFFAF4E8),
    cardElevated: Color(0xFFFDF9F0),
    border: Color(0xFFDCCBA8),
    textPrimary: Color(0xFF332415),
    textMuted: Color(0xFF664F38),
    textDim: Color(0xFF8A7158),
    accent: Color(0xFF8B5A2B),
    accentLight: Color(0xFF6E441E),
    accentSoft: Color(0xFF9D6A37),
    mushafBg: AppColors.mushafSepiaBg,
    mushafText: Color(0xFF2B1D0E),
    bannerGradient: [Color(0xFFE9DAB9), Color(0xFFDFCCA6), Color(0xFFD6BF95)],
    isDark: false,
  );

  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ?? darkGold;
  }

  @override
  AppPalette copyWith({
    Color? bg,
    Color? surface,
    Color? card,
    Color? cardElevated,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? textDim,
    Color? accent,
    Color? accentLight,
    Color? accentSoft,
    Color? mushafBg,
    Color? mushafText,
    List<Color>? bannerGradient,
    bool? isDark,
  }) {
    return AppPalette(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      cardElevated: cardElevated ?? this.cardElevated,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      textDim: textDim ?? this.textDim,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentSoft: accentSoft ?? this.accentSoft,
      mushafBg: mushafBg ?? this.mushafBg,
      mushafText: mushafText ?? this.mushafText,
      bannerGradient: bannerGradient ?? this.bannerGradient,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      bg: Color.lerp(bg, other.bg, t) ?? bg,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      card: Color.lerp(card, other.card, t) ?? card,
      cardElevated: Color.lerp(cardElevated, other.cardElevated, t) ?? cardElevated,
      border: Color.lerp(border, other.border, t) ?? border,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      textDim: Color.lerp(textDim, other.textDim, t) ?? textDim,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentLight: Color.lerp(accentLight, other.accentLight, t) ?? accentLight,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t) ?? accentSoft,
      mushafBg: Color.lerp(mushafBg, other.mushafBg, t) ?? mushafBg,
      mushafText: Color.lerp(mushafText, other.mushafText, t) ?? mushafText,
      bannerGradient: t < 0.5 ? bannerGradient : other.bannerGradient,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => AppPalette.of(this);
}
