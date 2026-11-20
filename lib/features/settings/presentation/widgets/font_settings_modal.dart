import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_themes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/storage_service.dart';

class FontSettingsModal extends StatelessWidget {
  const FontSettingsModal({super.key});

  static void show(BuildContext context) {
    final p = context.palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: p.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const FontSettingsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final p = context.palette;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.textDim.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.tune_rounded, color: p.accent, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    "Pengaturan Tampilan",
                    style: AppTypography.headingMedium(color: p.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: p.accent.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                      style: AppTypography.arabicVerse(
                        fontSize: storage.arabicFontSize,
                        color: p.accentLight,
                        fontFamily: storage.arabicFontFamily,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    if (storage.showTransliteration) ...[
                      const SizedBox(height: 6),
                      Text(
                        "Bismillāhir-raḥmānir-raḥīm",
                        style: AppTypography.transliteration(
                          fontSize: storage.translationFontSize - 1,
                          color: p.accentSoft,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (storage.showTranslation) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
                        style: AppTypography.translation(
                          fontSize: storage.translationFontSize,
                          color: p.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text("Tema Aplikasi",
                  style: AppTypography.title(color: p.textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildThemeChip(
                    p: p,
                    label: "Dark Gold",
                    selected: storage.themeMode == ThemeModeType.darkGold,
                    previewColor: AppColors.darkBg,
                    onTap: () => storage.setThemeMode(ThemeModeType.darkGold),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    p: p,
                    label: "Mushaf Terang",
                    selected: storage.themeMode == ThemeModeType.lightMushaf,
                    previewColor: AppColors.mushafParchment,
                    onTap: () =>
                        storage.setThemeMode(ThemeModeType.lightMushaf),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeChip(
                    p: p,
                    label: "Sepia",
                    selected: storage.themeMode == ThemeModeType.sepia,
                    previewColor: AppColors.mushafSepiaBg,
                    onTap: () => storage.setThemeMode(ThemeModeType.sepia),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ukuran Font Arab",
                      style: AppTypography.title(color: p.textPrimary)),
                  Text(
                    "${storage.arabicFontSize.toInt()} px",
                    style: TextStyle(
                      color: p.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: p.accent,
                  inactiveTrackColor: p.border,
                  thumbColor: p.accentLight,
                  overlayColor: AppColors.goldGlow,
                ),
                child: Slider(
                  value: storage.arabicFontSize.clamp(20.0, 42.0),
                  min: 20.0,
                  max: 42.0,
                  divisions: 11,
                  onChanged: (val) => storage.setArabicFontSize(val),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ukuran Font Terjemahan",
                      style: AppTypography.title(color: p.textPrimary)),
                  Text(
                    "${storage.translationFontSize.toInt()} px",
                    style: TextStyle(
                      color: p.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: p.accent,
                  inactiveTrackColor: p.border,
                  thumbColor: p.accentLight,
                  overlayColor: AppColors.goldGlow,
                ),
                child: Slider(
                  value: storage.translationFontSize.clamp(12.0, 22.0),
                  min: 12.0,
                  max: 22.0,
                  divisions: 5,
                  onChanged: (val) => storage.setTranslationFontSize(val),
                ),
              ),
              const SizedBox(height: 12),
              Text("Jenis Font Arab",
                  style: AppTypography.title(color: p.textPrimary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildFontChoiceChip(
                    p: p,
                    label: "Amiri Uthmani",
                    value: "Amiri",
                    current: storage.arabicFontFamily,
                    onSelect: () => storage.setArabicFontFamily("Amiri"),
                  ),
                  const SizedBox(width: 8),
                  _buildFontChoiceChip(
                    p: p,
                    label: "Scheherazade",
                    value: "Scheherazade",
                    current: storage.arabicFontFamily,
                    onSelect: () => storage.setArabicFontFamily("Scheherazade"),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: p.accent,
                title: Text("Tampilkan Transliterasi (Latin)",
                    style: AppTypography.title(color: p.textPrimary)
                        .copyWith(fontSize: 14)),
                value: storage.showTransliteration,
                onChanged: (_) => storage.toggleTransliteration(),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: p.accent,
                title: Text("Tampilkan Terjemahan Kemenag",
                    style: AppTypography.title(color: p.textPrimary)
                        .copyWith(fontSize: 14)),
                value: storage.showTranslation,
                onChanged: (_) => storage.toggleTranslation(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChip({
    required AppPalette p,
    required String label,
    required bool selected,
    required Color previewColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color:
                selected ? p.accent.withValues(alpha: 0.16) : p.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? p.accent : p.border,
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: previewColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: p.accent, width: 1),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? p.accentLight : p.textPrimary,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontChoiceChip({
    required AppPalette p,
    required String label,
    required String value,
    required String current,
    required VoidCallback onSelect,
  }) {
    final isSelected = current == value;
    return Expanded(
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                isSelected ? p.accent.withValues(alpha: 0.18) : p.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? p.accent : p.border,
              width: isSelected ? 1.2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? p.accentLight : p.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
