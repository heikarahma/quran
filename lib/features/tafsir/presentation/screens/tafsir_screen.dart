import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../data/models/ayah_model.dart';
import '../../../../data/models/surah_model.dart';
import '../../../../data/models/tafsir_model.dart';
import '../../../../data/repositories/quran_repository.dart';

class TafsirScreen extends StatefulWidget {
  final AyahModel ayah;
  final SurahModel surah;

  const TafsirScreen({
    super.key,
    required this.ayah,
    required this.surah,
  });

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TafsirModel _tafsir;
  bool _isLoading = true;
  final QuranRepository _repository = QuranRepository();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tafsir = _repository.getTafsirForAyah(
      widget.ayah.surahNumber,
      widget.ayah.ayahNumber,
    );
    _loadTafsir();
  }

  Future<void> _loadTafsir() async {
    final storage = Provider.of<StorageService>(context, listen: false);
    final loaded = await _repository.fetchTafsirForAyah(
      widget.ayah.surahNumber,
      widget.ayah.ayahNumber,
      storage: storage,
    );
    if (!mounted) return;
    setState(() {
      _tafsir = loaded;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tafsir QS. ${widget.surah.nameLatin}: ${widget.ayah.ayahNumber}",
              style: AppTypography.headingMedium(color: p.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Surah ke-${widget.surah.number} • Halaman ${widget.ayah.pageNumber}",
              style: AppTypography.caption(color: p.accentSoft),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: p.accent,
          indicatorWeight: 3,
          labelColor: p.accent,
          unselectedLabelColor: p.textDim,
          dividerColor: p.border.withValues(alpha: 0.5),
          tabs: const [
            Tab(text: "Tafsir Ringkas"),
            Tab(text: "Tafsir Kemenag"),
            Tab(text: "Asbabun Nuzul"),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: p.accent.withValues(alpha: 0.35), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.ayah.textArabic,
                  style: AppTypography.arabicVerse(
                    fontSize: 20,
                    color: p.accentLight,
                    fontFamily: storage.arabicFontFamily,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.ayah.translationId,
                  style: AppTypography.translation(
                    fontSize: 13,
                    color: p.textPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: p.border,
              valueColor: AlwaysStoppedAnimation<Color>(p.accent),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTafsirContent(
                  p: p,
                  title: "Tafsir Ringkas Kemenag RI",
                  content: _tafsir.tafsirRingkas,
                  badge: "Kemenag RI",
                ),
                _buildTafsirContent(
                  p: p,
                  title: "Tafsir Tahlili Lengkap",
                  content: _tafsir.tafsirKemenag,
                  badge: "Tahlili",
                ),
                _buildTafsirContent(
                  p: p,
                  title: "Asbabun Nuzul (Sebab Turunnya Ayat)",
                  content: _tafsir.asbabunNuzul ??
                      "Tidak ada riwayat asbabun nuzul khusus yang tercatat untuk ayat ini.",
                  badge: "Riwayat",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTafsirContent({
    required AppPalette p,
    required String title,
    required String content,
    required String badge,
  }) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.title(color: p.accentLight),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: AppTypography.caption(color: p.accentSoft),
                    ),
                  ),
                ],
              ),
              Divider(color: p.border, height: 24),
              Text(
                content,
                style: AppTypography.body(
                  fontSize: 15,
                  color: p.textPrimary,
                ).copyWith(height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
