import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/surah_model.dart';
import '../../../mushaf/presentation/screens/mushaf_page_screen.dart';
import '../../../mushaf/presentation/screens/mushaf_verse_screen.dart';

class SurahListView extends StatelessWidget {
  final List<SurahModel> surahs;
  final double bottomPadding;

  const SurahListView({
    super.key,
    required this.surahs,
    this.bottomPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    if (surahs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: p.textDim),
              const SizedBox(height: 12),
              Text(
                "Surah tidak ditemukan",
                style: AppTypography.body(color: p.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
      physics: const BouncingScrollPhysics(),
      itemCount: surahs.length,
      separatorBuilder: (_, __) => Divider(
        color: p.border.withValues(alpha: 0.6),
        height: 1,
        indent: 58,
      ),
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return _buildSurahItem(context, surah, p);
      },
    );
  }

  Widget _buildSurahItem(BuildContext context, SurahModel surah, AppPalette p) {
    return InkWell(
      onTap: () => _showReadingModeDialog(context, surah),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.isDark ? null : p.accent.withValues(alpha: 0.1),
                gradient: p.isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF2E3742), Color(0xFF1B222A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: Border.all(
                  color: p.accent.withValues(alpha: 0.55),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Text(
                  "${surah.number}",
                  style: TextStyle(
                    color: p.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameLatin,
                    style: AppTypography.title(color: p.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${surah.revelationType.toUpperCase()} • ${surah.totalAyah} AYAT • HAL. ${surah.startPage}",
                    style: AppTypography.caption(color: p.textDim).copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    surah.translationId,
                    style: AppTypography.caption(color: p.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              surah.nameArabic,
              style: AppTypography.arabicHeader(
                fontSize: 22,
                color: p.accentLight,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  void _showReadingModeDialog(BuildContext context, SurahModel surah) {
    final p = context.palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: p.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.textDim.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Pilih Mode Membaca",
                  style: AppTypography.headingMedium(color: p.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  "Surah ${surah.nameLatin} (${surah.nameArabic})",
                  style: AppTypography.body(color: p.accentSoft),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.format_list_bulleted_rounded,
                        color: p.accent),
                  ),
                  title: Text("Mode Ayat Per Ayat",
                      style: AppTypography.title(color: p.textPrimary)),
                  subtitle: Text(
                    "Teks Arab, terjemahan Kemenag, transliterasi & audio",
                    style: AppTypography.caption(color: p.textMuted),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: p.accent),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MushafVerseScreen(surahNumber: surah.number),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.menu_book_rounded, color: p.accent),
                  ),
                  title: Text("Mode Mushaf Digital (15 Baris)",
                      style: AppTypography.title(color: p.textPrimary)),
                  subtitle: Text(
                    "Tampilan halaman asli Madani dengan ornamen bingkai emas",
                    style: AppTypography.caption(color: p.textMuted),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: p.accent),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MushafPageScreen(initialPage: surah.startPage),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
