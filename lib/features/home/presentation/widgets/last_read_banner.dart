import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/bookmark_model.dart';
import '../../../mushaf/presentation/screens/mushaf_page_screen.dart';
import '../../../mushaf/presentation/screens/mushaf_verse_screen.dart';

class LastReadBanner extends StatelessWidget {
  final BookmarkModel? lastRead;

  const LastReadBanner({super.key, this.lastRead});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final lr = lastRead ??
        BookmarkModel(
          id: 'default',
          type: 'last_read',
          surahNumber: 18,
          surahName: 'Al-Kahf',
          ayahNumber: 10,
          pageNumber: 294,
          juzNumber: 15,
          createdAt: DateTime.now(),
        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: p.bannerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: p.accent.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: p.accent.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -15,
            child: Opacity(
              opacity: p.isDark ? 0.12 : 0.10,
              child: Text(
                "القرآن",
                style: AppTypography.arabicHeader(
                  fontSize: 100,
                  color: p.accent,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: p.accent.withValues(alpha: 0.6),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu_book_rounded,
                              size: 13, color: p.accentLight),
                          const SizedBox(width: 5),
                          Text(
                            "Terakhir Dibaca",
                            style: AppTypography.caption(color: p.accentLight),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Juz ${lr.juzNumber} • Hal. ${lr.pageNumber}",
                      style: AppTypography.caption(color: p.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lr.surahName,
                  style: AppTypography.headingLarge(color: p.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  lr.type == 'page'
                      ? "Halaman ${lr.pageNumber}"
                      : "Ayat No. ${lr.ayahNumber}",
                  style: AppTypography.body(
                    fontSize: 14,
                    color: p.accentSoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MushafVerseScreen(
                              surahNumber: lr.surahNumber,
                              initialAyah: lr.ayahNumber,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p.accent,
                        foregroundColor: p.isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text(
                        "Lanjutkan Membaca",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MushafPageScreen(initialPage: lr.pageNumber),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: p.accentLight,
                        side: BorderSide(color: p.accent.withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.auto_stories_rounded, size: 15),
                      label: const Text(
                        "Mushaf",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
