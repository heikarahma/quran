import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/juz_model.dart';
import '../../../mushaf/presentation/screens/mushaf_page_screen.dart';

class JuzListView extends StatelessWidget {
  final List<JuzModel> juzList;
  final double bottomPadding;

  const JuzListView({
    super.key,
    required this.juzList,
    this.bottomPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
      physics: const BouncingScrollPhysics(),
      itemCount: juzList.length,
      separatorBuilder: (_, __) => Divider(
        color: p.border.withValues(alpha: 0.6),
        height: 1,
        indent: 58,
      ),
      itemBuilder: (context, index) {
        final juz = juzList[index];
        return _buildJuzItem(context, juz, p);
      },
    );
  }

  Widget _buildJuzItem(BuildContext context, JuzModel juz, AppPalette p) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MushafPageScreen(initialPage: juz.startPage),
          ),
        );
      },
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
                  "${juz.number}",
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
                    "Juz ${juz.number}",
                    style: AppTypography.title(color: p.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Mulai: Surah ${juz.startSurahName} Ayat ${juz.startAyah}",
                    style: AppTypography.caption(color: p.accentSoft),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Halaman ${juz.startPage} - ${juz.endPage}",
                    style: AppTypography.caption(color: p.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              juz.nameArabic,
              style: AppTypography.arabicHeader(
                fontSize: 20,
                color: p.accentLight,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
