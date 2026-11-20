import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/audio_player_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../data/models/ayah_model.dart';
import '../../../../data/models/bookmark_model.dart';
import '../../../../data/models/surah_model.dart';
import '../../../../data/repositories/quran_repository.dart';
import '../../../tafsir/presentation/screens/tafsir_screen.dart';

class AyahActionSheet extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;

  const AyahActionSheet({
    super.key,
    required this.ayah,
    required this.surah,
  });

  static void show(BuildContext context, AyahModel ayah, SurahModel surah) {
    final p = context.palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: p.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AyahActionSheet(ayah: ayah, surah: surah),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final firebase = Provider.of<FirebaseService>(context, listen: false);
    final p = context.palette;
    final isBookmarked = storage.isBookmarked(ayah.surahNumber, ayah.ayahNumber);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: p.accent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      "QS. ${surah.nameLatin}: ${ayah.ayahNumber}",
                      style: TextStyle(
                        color: p.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Hal. ${ayah.pageNumber} • Juz ${ayah.juzNumber}",
                    style: AppTypography.caption(color: p.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: p.border),
                ),
                child: Text(
                  ayah.textArabic,
                  style: AppTypography.arabicVerse(
                    fontSize: 18,
                    color: p.accentLight,
                    fontFamily: storage.arabicFontFamily,
                  ),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 14),
              _buildActionTile(
                p: p,
                icon: Icons.play_circle_filled_rounded,
                title: "Putar Audio Murottal",
                subtitle: "Dengarkan lantunan ayat dari Qari pilihan",
                color: p.accent,
                onTap: () {
                  final audio =
                      Provider.of<AudioPlayerService>(context, listen: false);
                  final playlist =
                      QuranRepository().getAyahsForSurah(ayah.surahNumber);
                  Navigator.pop(context);
                  audio.playAyah(ayah, playlist: playlist);
                },
              ),
              _buildActionTile(
                p: p,
                icon: Icons.menu_book_rounded,
                title: "Baca Tafsir",
                subtitle: "Penjelasan Tafsir Ringkas & Kemenag RI",
                color: AppColors.sapphireBlue,
                onTap: () {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => TafsirScreen(ayah: ayah, surah: surah),
                    ),
                  );
                },
              ),
              _buildActionTile(
                p: p,
                icon: isBookmarked
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_outlined,
                title:
                    isBookmarked ? "Hapus dari Bookmark" : "Simpan ke Bookmark",
                subtitle: "Akses cepat melalui tab Penanda",
                color: AppColors.emeraldGreen,
                onTap: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final bookmark = BookmarkModel(
                    id: "${ayah.surahNumber}_${ayah.ayahNumber}",
                    type: 'ayah',
                    surahNumber: ayah.surahNumber,
                    surahName: surah.nameLatin,
                    ayahNumber: ayah.ayahNumber,
                    pageNumber: ayah.pageNumber,
                    juzNumber: ayah.juzNumber,
                    arabicSnippet: ayah.textArabic,
                    createdAt: DateTime.now(),
                  );

                  if (isBookmarked) {
                    await storage.removeBookmark(bookmark.id);
                    await firebase.deleteBookmarkFromCloud(bookmark.id);
                  } else {
                    await storage.addBookmark(bookmark);
                    await firebase.saveBookmarkToCloud(bookmark);
                  }
                  if (navigator.canPop()) navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(isBookmarked
                          ? "Bookmark berhasil dihapus"
                          : "Berhasil disimpan ke Bookmark"),
                      backgroundColor: p.cardElevated,
                    ),
                  );
                },
              ),
              _buildActionTile(
                p: p,
                icon: Icons.history_rounded,
                title: "Tandai Terakhir Dibaca",
                subtitle: "Simpan sebagai posisi bacaan saat ini",
                color: p.accentSoft,
                onTap: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final lastRead = BookmarkModel(
                    id: "last_read",
                    type: "last_read",
                    surahNumber: ayah.surahNumber,
                    surahName: surah.nameLatin,
                    ayahNumber: ayah.ayahNumber,
                    pageNumber: ayah.pageNumber,
                    juzNumber: ayah.juzNumber,
                    arabicSnippet: ayah.textArabic,
                    createdAt: DateTime.now(),
                  );
                  await storage.setLastRead(lastRead);
                  await firebase.saveLastReadToCloud(lastRead);
                  if (navigator.canPop()) navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content:
                          const Text("Tersimpan sebagai Terakhir Dibaca"),
                      backgroundColor: p.cardElevated,
                    ),
                  );
                },
              ),
              _buildActionTile(
                p: p,
                icon: Icons.copy_rounded,
                title: "Salin Teks Ayat",
                subtitle: "Salin teks Arab dan terjemahan ke clipboard",
                color: p.textPrimary,
                onTap: () {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final text =
                      "${ayah.textArabic}\n\n\"${ayah.translationId}\"\n(QS. ${surah.nameLatin}: ${ayah.ayahNumber})";
                  Clipboard.setData(ClipboardData(text: text));
                  if (navigator.canPop()) navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text("Teks ayat disalin ke papan klip"),
                      backgroundColor: p.cardElevated,
                    ),
                  );
                },
              ),
              _buildActionTile(
                p: p,
                icon: Icons.share_rounded,
                title: "Bagikan Ayat",
                subtitle: "Bagikan ke WhatsApp, Telegram, atau media sosial",
                color: p.accentLight,
                onTap: () {
                  Navigator.pop(context);
                  final text =
                      "${ayah.textArabic}\n\n\"${ayah.translationId}\"\n(QS. ${surah.nameLatin}: ${ayah.ayahNumber})";
                  Share.share(text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required AppPalette p,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.title(color: p.textPrimary)),
                  Text(subtitle,
                      style: AppTypography.caption(color: p.textDim)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: p.textDim),
          ],
        ),
      ),
    );
  }
}
