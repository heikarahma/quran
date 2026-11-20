import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/audio_player_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../data/models/ayah_model.dart';
import '../../../../data/models/bookmark_model.dart';
import '../../../../data/models/surah_model.dart';
import '../../../../data/repositories/quran_repository.dart';
import '../../../audio/presentation/widgets/mini_audio_player.dart';
import '../../../settings/presentation/widgets/font_settings_modal.dart';
import '../../../tafsir/presentation/screens/tafsir_screen.dart';
import '../widgets/ayah_action_sheet.dart';
import 'mushaf_page_screen.dart';

class MushafVerseScreen extends StatefulWidget {
  final int surahNumber;
  final int? initialAyah;

  const MushafVerseScreen({
    super.key,
    required this.surahNumber,
    this.initialAyah,
  });

  @override
  State<MushafVerseScreen> createState() => _MushafVerseScreenState();
}

class _MushafVerseScreenState extends State<MushafVerseScreen> {
  final QuranRepository _repository = QuranRepository();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetAyahKey = GlobalKey();

  late SurahModel _surah;
  late List<AyahModel> _ayahs;
  int? _highlightedAyah;

  @override
  void initState() {
    super.initState();
    _surah = _repository.getSurahByNumber(widget.surahNumber) ??
        _repository.getAllSurahs()[0];
    _ayahs = _repository.getAyahsForSurah(_surah.number);
    _highlightedAyah = widget.initialAyah;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _saveInitialLastRead();
      if (widget.initialAyah != null && widget.initialAyah! > 1) {
        _scrollToInitialAyah(widget.initialAyah!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _saveInitialLastRead() {
    final storage = Provider.of<StorageService>(context, listen: false);
    final firebase = Provider.of<FirebaseService>(context, listen: false);

    final targetAyahNum = (widget.initialAyah ?? 1).clamp(1, _surah.totalAyah);
    final targetAyah = _ayahs.firstWhere(
      (a) => a.ayahNumber == targetAyahNum,
      orElse: () => _ayahs.isNotEmpty
          ? _ayahs.first
          : AyahModel(
              surahNumber: _surah.number,
              ayahNumber: 1,
              textArabic: '',
              transliteration: '',
              translationId: '',
              pageNumber: _surah.startPage,
              juzNumber: _surah.startJuz,
              audioUrl: '',
            ),
    );

    final lastRead = BookmarkModel(
      id: "last_read",
      type: "last_read",
      surahNumber: _surah.number,
      surahName: _surah.nameLatin,
      ayahNumber: targetAyah.ayahNumber,
      pageNumber: targetAyah.pageNumber,
      juzNumber: targetAyah.juzNumber,
      arabicSnippet: targetAyah.textArabic,
      createdAt: DateTime.now(),
    );

    storage.setLastRead(lastRead);
    firebase.saveLastReadToCloud(lastRead);
  }

  double _estimateOffsetForIndex(int targetIndex) {
    double offset = 280.0; // header card height
    for (int i = 0; i < targetIndex && i < _ayahs.length; i++) {
      final a = _ayahs[i];
      final linesAr = (a.textArabic.length / 26).ceil().clamp(1, 8);
      final linesTr = (a.transliteration.length / 42).ceil().clamp(1, 8);
      final linesId = (a.translationId.length / 42).ceil().clamp(1, 10);
      offset += 95.0 + linesAr * 38.0 + linesTr * 18.0 + linesId * 21.0;
    }
    return offset;
  }

  Future<void> _scrollToInitialAyah(int ayahNumber) async {
    final targetIdx = _ayahs.indexWhere((a) => a.ayahNumber == ayahNumber);
    if (targetIdx <= 0 || !_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    double guess = _estimateOffsetForIndex(targetIdx).clamp(0.0, maxExtent);
    _scrollController.jumpTo(guess);

    // Refine position up to 6 frames until target GlobalKey mounts
    for (int attempt = 0; attempt < 6; attempt++) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final ctx = _targetAyahKey.currentContext;
      if (ctx != null) {
        await Scrollable.ensureVisible(
          ctx,
          alignment: 0.08,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
        return;
      }
      if (!_scrollController.hasClients) return;
      final curMax = _scrollController.position.maxScrollExtent;
      final ratio = targetIdx / _ayahs.length;
      guess = (curMax * ratio).clamp(0.0, curMax);
      _scrollController.jumpTo(guess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final audio = Provider.of<AudioPlayerService>(context);
    final p = context.palette;
    final hasPlayer = audio.currentAyah != null;
    final bottomPad =
        MediaQuery.of(context).padding.bottom + (hasPlayer ? 116.0 : 28.0);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _surah.nameLatin,
              style: AppTypography.headingMedium(color: p.textPrimary),
            ),
            Text(
              "${_surah.revelationType} • ${_surah.totalAyah} Ayat • Juz ${_surah.startJuz}",
              style: AppTypography.caption(color: p.accentSoft),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_stories_rounded, color: p.accent),
            tooltip: "Buka Mode Halaman Mushaf",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MushafPageScreen(initialPage: _surah.startPage),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded, color: p.accent),
            tooltip: "Pengaturan Tampilan",
            onPressed: () => FontSettingsModal.show(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: bottomPad),
            itemCount: _ayahs.length + 2, // header + ayahs + surah nav footer
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSurahHeaderCard(audio, p);
              }
              if (index == _ayahs.length + 1) {
                return _buildSurahFooterNavigation(p);
              }

              final ayah = _ayahs[index - 1];
              final isTarget = widget.initialAyah == ayah.ayahNumber;
              final isCurrentPlaying = audio.currentAyah != null &&
                  audio.currentAyah!.surahNumber == ayah.surahNumber &&
                  audio.currentAyah!.ayahNumber == ayah.ayahNumber &&
                  audio.isPlaying;
              final isHighlighted = _highlightedAyah == ayah.ayahNumber;

              return KeyedSubtree(
                key: isTarget ? _targetAyahKey : ValueKey("ayah_${ayah.ayahNumber}"),
                child: _buildAyahCard(
                  ayah,
                  isCurrentPlaying,
                  isHighlighted,
                  storage,
                  audio,
                  p,
                ),
              );
            },
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniAudioPlayer(),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeaderCard(AudioPlayerService audio, AppPalette p) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        children: [
          Text(
            _surah.nameArabic,
            style: AppTypography.arabicHeader(
              fontSize: 32,
              color: p.accentLight,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          Text(
            _surah.nameLatin,
            style: AppTypography.headingMedium(color: p.textPrimary),
          ),
          Text(
            "\"${_surah.translationId}\"",
            style: AppTypography.body(color: p.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: p.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: p.accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              "${_surah.revelationType.toUpperCase()} • ${_surah.totalAyah} AYAT • HALAMAN ${_surah.startPage}",
              style: AppTypography.caption(color: p.accentSoft)
                  .copyWith(letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (_ayahs.isNotEmpty) {
                audio.playAyah(_ayahs[0], playlist: _ayahs);
              }
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(
              "Putar Seluruh Surah",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: p.isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          // Bismillah banner (skip Surah 1 Al-Fatihah where Ayah 1 IS Bismillah, and Surah 9 At-Taubah)
          if (_surah.number != 1 && _surah.number != 9) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: p.isDark
                    ? Colors.black.withValues(alpha: 0.22)
                    : p.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                style: AppTypography.arabicVerse(
                  fontSize: 22,
                  color: p.accentLight,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAyahCard(
    AyahModel ayah,
    bool isPlaying,
    bool isHighlighted,
    StorageService storage,
    AudioPlayerService audio,
    AppPalette p,
  ) {
    final isBookmarked = storage.isBookmarked(ayah.surahNumber, ayah.ayahNumber);
    final activeBorder = isPlaying || isHighlighted;

    return InkWell(
      onTap: () {
        setState(() => _highlightedAyah = null);
        AyahActionSheet.show(context, ayah, _surah);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: activeBorder
              ? p.accent.withValues(alpha: p.isDark ? 0.14 : 0.10)
              : p.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activeBorder ? p.accent : p.border.withValues(alpha: 0.8),
            width: activeBorder ? 1.5 : 1.0,
          ),
          boxShadow: activeBorder
              ? [
                  BoxShadow(
                    color: p.accent.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: p.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    "${ayah.ayahNumber}",
                    style: TextStyle(
                      color: p.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (ayah.sajda != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Sajdah",
                      style: TextStyle(
                        color: AppColors.emeraldGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_outline_rounded,
                    color: p.accent,
                    size: 22,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      audio.togglePlayPause();
                    } else {
                      audio.playAyah(ayah, playlist: _ayahs);
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 14),
                IconButton(
                  icon: Icon(
                    Icons.menu_book_outlined,
                    color: p.textDim,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TafsirScreen(ayah: ayah, surah: _surah),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 14),
                IconButton(
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isBookmarked ? p.accent : p.textDim,
                    size: 20,
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final bookmark = BookmarkModel(
                      id: "${ayah.surahNumber}_${ayah.ayahNumber}",
                      type: 'ayah',
                      surahNumber: ayah.surahNumber,
                      surahName: _surah.nameLatin,
                      ayahNumber: ayah.ayahNumber,
                      pageNumber: ayah.pageNumber,
                      juzNumber: ayah.juzNumber,
                      arabicSnippet: ayah.textArabic,
                      createdAt: DateTime.now(),
                    );
                    final firebase =
                        Provider.of<FirebaseService>(context, listen: false);
                    if (isBookmarked) {
                      await storage.removeBookmark(bookmark.id);
                      await firebase.deleteBookmarkFromCloud(bookmark.id);
                    } else {
                      await storage.addBookmark(bookmark);
                      await firebase.saveBookmarkToCloud(bookmark);
                    }
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(isBookmarked
                              ? "Bookmark dihapus"
                              : "QS. ${_surah.nameLatin}: ${ayah.ayahNumber} disimpan ke Bookmark"),
                          backgroundColor: p.cardElevated,
                        ),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              "${ayah.textArabic}${ArabicNumbers.formatAyahEnd(ayah.ayahNumber)}",
              style: AppTypography.arabicVerse(
                fontSize: storage.arabicFontSize,
                color: p.textPrimary,
                fontFamily: storage.arabicFontFamily,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            if (storage.showTransliteration &&
                ayah.transliteration.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                ayah.transliteration,
                style: AppTypography.transliteration(
                  fontSize: storage.translationFontSize - 1,
                  color: p.accentSoft,
                ),
              ),
            ],
            if (storage.showTranslation) ...[
              const SizedBox(height: 8),
              Text(
                ayah.translationId,
                style: AppTypography.translation(
                  fontSize: storage.translationFontSize,
                  color: p.textPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSurahFooterNavigation(AppPalette p) {
    final prevSurah =
        _surah.number > 1 ? _repository.getSurahByNumber(_surah.number - 1) : null;
    final nextSurah = _surah.number < 114
        ? _repository.getSurahByNumber(_surah.number + 1)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          if (prevSurah != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MushafVerseScreen(surahNumber: prevSurah.number),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_back_rounded, size: 16, color: p.accent),
                label: Text(
                  prevSurah.nameLatin,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: p.textPrimary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: p.border),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (prevSurah != null && nextSurah != null) const SizedBox(width: 10),
          if (nextSurah != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MushafVerseScreen(surahNumber: nextSurah.number),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  nextSurah.nameLatin,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.accent,
                  foregroundColor: p.isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
