import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/audio_player_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../data/models/surah_model.dart';
import '../../../../data/repositories/quran_repository.dart';
import '../../../audio/presentation/widgets/mini_audio_player.dart';
import '../../../bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../settings/presentation/widgets/font_settings_modal.dart';
import '../widgets/juz_list_view.dart';
import '../widgets/last_read_banner.dart';
import '../widgets/mushaf_page_picker_view.dart';
import '../widgets/surah_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final QuranRepository _repository = QuranRepository();
  final TextEditingController _searchController = TextEditingController();

  List<SurahModel> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredSurahs = _repository.getAllSurahs();

    _searchController.addListener(() {
      final query = _searchController.text;
      setState(() {
        _filteredSurahs = _repository.searchSurahs(query);
      });
      if (query.isNotEmpty && _tabController.index != 0) {
        _tabController.animateTo(0);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final audio = Provider.of<AudioPlayerService>(context);
    final p = context.palette;
    final hasPlayer = audio.currentAyah != null;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final listBottomPad = (hasPlayer ? 104.0 : 16.0) + bottomInset;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: p.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: p.accent.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: p.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Al-Qur'an Al-Karim",
                    style: AppTypography.headingMedium(color: p.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Baca & Tadabbur Al-Qur'an",
                    style: AppTypography.caption(color: p.accentSoft),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmarks_rounded, color: p.accent),
            tooltip: "Penanda & Terakhir Baca",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded, color: p.accent),
            tooltip: "Pengaturan",
            onPressed: () => FontSettingsModal.show(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: p.textPrimary),
                          decoration: InputDecoration(
                            hintText:
                                "Cari nama surah, nomor, arti (misal: Al-Kahf)...",
                            hintStyle: AppTypography.body(
                                color: p.textDim, fontSize: 13),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: p.accent, size: 22),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear_rounded,
                                        color: p.textDim, size: 18),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : null,
                            filled: true,
                            fillColor: p.card,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: p.border.withValues(alpha: 0.8),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: p.border.withValues(alpha: 0.8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: p.accent,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_searchController.text.isEmpty)
                        LastReadBanner(lastRead: storage.lastRead),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    backgroundColor: p.bg,
                    tabBar: TabBar(
                      controller: _tabController,
                      indicatorColor: p.accent,
                      indicatorWeight: 3,
                      labelColor: p.accent,
                      unselectedLabelColor: p.textDim,
                      dividerColor: p.border.withValues(alpha: 0.5),
                      labelStyle: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      tabs: const [
                        Tab(text: "Surah"),
                        Tab(text: "Juz"),
                        Tab(text: "Halaman"),
                        Tab(text: "Bookmark"),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                SurahListView(
                  surahs: _filteredSurahs,
                  bottomPadding: listBottomPad,
                ),
                JuzListView(
                  juzList: _repository.getAllJuz(),
                  bottomPadding: listBottomPad,
                ),
                MushafPagePickerView(bottomPadding: listBottomPad),
                BookmarksScreen(
                  embedded: true,
                  bottomPadding: listBottomPad,
                ),
              ],
            ),
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
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _StickyTabBarDelegate({
    required this.tabBar,
    required this.backgroundColor,
  });

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.tabBar != tabBar;
  }
}
