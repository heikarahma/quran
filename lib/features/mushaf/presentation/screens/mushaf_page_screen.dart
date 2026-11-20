import 'package:flutter/gestures.dart';
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
import '../../../../data/repositories/quran_repository.dart';
import '../../../audio/presentation/widgets/mini_audio_player.dart';
import '../../../settings/presentation/widgets/font_settings_modal.dart';
import '../widgets/ayah_action_sheet.dart';
import '../widgets/illuminated_mushaf_frame.dart';
import 'mushaf_verse_screen.dart';

class MushafPageScreen extends StatefulWidget {
  final int initialPage;

  const MushafPageScreen({super.key, this.initialPage = 1});

  @override
  State<MushafPageScreen> createState() => _MushafPageScreenState();
}

class _MushafPageScreenState extends State<MushafPageScreen> {
  final QuranRepository _repository = QuranRepository();
  late PageController _pageController;
  late int _currentPage;
  double? _sliderDragValue;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _saveCurrentPageAsLastRead();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _saveCurrentPageAsLastRead() {
    final storage = Provider.of<StorageService>(context, listen: false);
    final firebase = Provider.of<FirebaseService>(context, listen: false);

    final surah = _repository.getSurahForPage(_currentPage);
    final juz = _repository.getJuzForPage(_currentPage);
    final pageAyahs = _repository.getAyahsForPage(_currentPage);
    final firstAyah = pageAyahs.isNotEmpty ? pageAyahs.first : null;

    final lastRead = BookmarkModel(
      id: "last_read",
      type: "last_read",
      surahNumber: surah.number,
      surahName: surah.nameLatin,
      ayahNumber: firstAyah?.ayahNumber ?? 1,
      pageNumber: _currentPage,
      juzNumber: juz,
      arabicSnippet: firstAyah?.textArabic,
      createdAt: DateTime.now(),
    );

    storage.setLastRead(lastRead);
    firebase.saveLastReadToCloud(lastRead);
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final p = context.palette;
    final currentSurah = _repository.getSurahForPage(_currentPage);
    final currentJuz = _repository.getJuzForPage(_currentPage);
    final isPageBookmarked = storage.isPageBookmarked(_currentPage);
    final displayedPage = (_sliderDragValue ?? _currentPage).round();

    return Scaffold(
      backgroundColor: p.bg,
      appBar: _showControls
          ? AppBar(
              backgroundColor: p.surface,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mushaf Digital (Hal. $_currentPage)",
                    style: AppTypography.headingMedium(color: p.textPrimary),
                  ),
                  Text(
                    "Surah ${currentSurah.nameLatin} • Juz $currentJuz",
                    style: AppTypography.caption(color: p.accentSoft),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isPageBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: p.accent,
                  ),
                  tooltip: "Tandai Halaman",
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final added = await storage.togglePageBookmark(
                      pageNumber: _currentPage,
                      surahNumber: currentSurah.number,
                      surahName: currentSurah.nameLatin,
                      juzNumber: currentJuz,
                    );
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(added
                              ? "Halaman $_currentPage ditandai ke Bookmark"
                              : "Bookmark halaman $_currentPage dihapus"),
                          backgroundColor: p.cardElevated,
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_list_bulleted_rounded,
                      color: p.accent),
                  tooltip: "Buka Mode Per Ayat",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MushafVerseScreen(surahNumber: currentSurah.number),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.find_in_page_rounded, color: p.accent),
                  tooltip: "Lompat ke Halaman",
                  onPressed: _showJumpToPageDialog,
                ),
                IconButton(
                  icon: Icon(Icons.tune_rounded, color: p.accent),
                  tooltip: "Pengaturan",
                  onPressed: () => FontSettingsModal.show(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        top: !_showControls,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 604,
                  reverse: true, // RTL swipe like authentic printed Mushaf
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index + 1;
                      _sliderDragValue = null;
                    });
                    _saveCurrentPageAsLastRead();
                  },
                  itemBuilder: (context, index) {
                    final pageNum = index + 1;
                    return _MushafPageLeaf(
                      pageNumber: pageNum,
                      repository: _repository,
                    );
                  },
                ),
              ),
            ),
            if (_showControls) ...[
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: p.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: p.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Hal. $displayedPage",
                      style: TextStyle(
                        color: p.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: p.accent,
                          inactiveTrackColor: p.border,
                          thumbColor: p.accentLight,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                        ),
                        child: Slider(
                          value: (_sliderDragValue ?? _currentPage.toDouble())
                              .clamp(1.0, 604.0),
                          min: 1,
                          max: 604,
                          onChanged: (val) {
                            setState(() {
                              _sliderDragValue = val;
                            });
                          },
                          onChangeEnd: (val) {
                            final newPage = val.round().clamp(1, 604);
                            setState(() {
                              _sliderDragValue = null;
                            });
                            _pageController.jumpToPage(newPage - 1);
                          },
                        ),
                      ),
                    ),
                    Text(
                      "604",
                      style: AppTypography.caption(color: p.textDim),
                    ),
                  ],
                ),
              ),
              const MiniAudioPlayer(),
            ],
          ],
        ),
      ),
    );
  }

  void _showJumpToPageDialog() {
    final p = context.palette;
    final textController = TextEditingController(text: "$_currentPage");
    String? errorMsg;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: p.card,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              title: Text("Lompat ke Halaman",
                  style: AppTypography.title(color: p.textPrimary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Masukkan nomor halaman mushaf (1 - 604):",
                    style: AppTypography.caption(color: p.textMuted),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: TextStyle(
                      color: p.accentLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: p.surface,
                      errorText: errorMsg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: p.accent),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text("Batal", style: TextStyle(color: p.textDim)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final page = int.tryParse(textController.text.trim());
                    if (page != null && page >= 1 && page <= 604) {
                      _pageController.jumpToPage(page - 1);
                      Navigator.pop(ctx);
                    } else {
                      setDialogState(() {
                        errorMsg = "Masukkan angka 1 - 604";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.accent,
                    foregroundColor: p.isDark ? Colors.black : Colors.white,
                  ),
                  child: const Text("Lompat",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    ).then((_) => textController.dispose());
  }
}

class _MushafPageLeaf extends StatefulWidget {
  final int pageNumber;
  final QuranRepository repository;

  const _MushafPageLeaf({
    required this.pageNumber,
    required this.repository,
  });

  @override
  State<_MushafPageLeaf> createState() => _MushafPageLeafState();
}

class _MushafPageLeafState extends State<_MushafPageLeaf> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  void _clearRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _clearRecognizers();

    final storage = Provider.of<StorageService>(context);
    final audio = Provider.of<AudioPlayerService>(context);
    final p = context.palette;

    final ayahs = widget.repository.getAyahsForPage(widget.pageNumber);
    final headerSurah = widget.repository.getSurahForPage(widget.pageNumber);
    final juz = widget.repository.getJuzForPage(widget.pageNumber);
    final isOpening = widget.pageNumber <= 2;

    // Group contiguous ayahs on this page by surahNumber
    final List<List<AyahModel>> surahGroups = [];
    for (final a in ayahs) {
      if (surahGroups.isEmpty || surahGroups.last.first.surahNumber != a.surahNumber) {
        surahGroups.add([a]);
      } else {
        surahGroups.last.add(a);
      }
    }

    return IlluminatedMushafFrame(
      surahName: headerSurah.nameArabic,
      juzNumber: juz,
      pageNumber: widget.pageNumber,
      isOpeningPage: isOpening,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: surahGroups.map((group) {
              final sNum = group.first.surahNumber;
              final surahInfo =
                  widget.repository.getSurahByNumber(sNum) ?? headerSurah;
              final startsSurahOnPage = group.any((a) => a.ayahNumber == 1);

              final spans = <InlineSpan>[];
              for (final ayah in group) {
                final isPlaying = audio.currentAyah != null &&
                    audio.currentAyah!.surahNumber == ayah.surahNumber &&
                    audio.currentAyah!.ayahNumber == ayah.ayahNumber;

                final recognizer = TapGestureRecognizer()
                  ..onTap = () {
                    AyahActionSheet.show(context, ayah, surahInfo);
                  };
                _recognizers.add(recognizer);

                spans.add(
                  TextSpan(
                    text:
                        "${ayah.textArabic}${ArabicNumbers.formatAyahEnd(ayah.ayahNumber)} ",
                    recognizer: recognizer,
                    style: AppTypography.mushafPageArabic(
                      fontSize: isOpening ? 20.5 : 18.5,
                      color: p.mushafText,
                      fontFamily: storage.arabicFontFamily,
                    ).copyWith(
                      backgroundColor: isPlaying
                          ? AppColors.goldPrimary.withValues(alpha: 0.28)
                          : null,
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    if (startsSurahOnPage) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.mushafBorderGold
                              .withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.mushafBorderGold,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "سُورَةُ ${surahInfo.nameArabic}",
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mushafBorderNavy,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (surahInfo.number != 1 && surahInfo.number != 9) ...[
                        Text(
                          "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            color: p.mushafText,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                    RichText(
                      textAlign: isOpening ? TextAlign.center : TextAlign.justify,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(children: spans),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
