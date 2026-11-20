import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../mushaf/presentation/screens/mushaf_page_screen.dart';
import '../../../mushaf/presentation/screens/mushaf_verse_screen.dart';

class BookmarksScreen extends StatefulWidget {
  final bool embedded;
  final double bottomPadding;

  const BookmarksScreen({
    super.key,
    this.embedded = false,
    this.bottomPadding = 16,
  });

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final firebase = Provider.of<FirebaseService>(context);
    final p = context.palette;

    final tabBar = TabBar(
      controller: _tabController,
      indicatorColor: p.accent,
      indicatorWeight: 3,
      labelColor: p.accent,
      unselectedLabelColor: p.textDim,
      dividerColor: p.border.withValues(alpha: 0.5),
      tabs: const [
        Tab(text: "Terakhir Dibaca"),
        Tab(text: "Daftar Bookmark"),
      ],
    );

    final bodyContent = TabBarView(
      controller: _tabController,
      children: [
        _buildLastReadTab(storage, p),
        _buildBookmarksListTab(storage, firebase, p),
      ],
    );

    if (widget.embedded) {
      return Column(
        children: [
          Container(
            color: p.surface,
            child: tabBar,
          ),
          Expanded(child: bodyContent),
        ],
      );
    }

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        title: Text(
          "Penanda & Terakhir Baca",
          style: AppTypography.headingMedium(color: p.textPrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: _buildSyncBadge(firebase, p),
            ),
          ),
        ],
        bottom: tabBar,
      ),
      body: bodyContent,
    );
  }

  Widget _buildSyncBadge(FirebaseService firebase, AppPalette p) {
    final IconData icon;
    final Color color;
    final String label;

    if (firebase.isSyncing) {
      icon = Icons.sync_rounded;
      color = p.accent;
      label = "Sync...";
    } else if (firebase.isAuthenticated) {
      icon = Icons.cloud_done_rounded;
      color = AppColors.emeraldGreen;
      label = "Cloud Sync";
    } else {
      icon = Icons.smartphone_rounded;
      color = p.textMuted;
      label = "Mode Lokal";
    }

    return Row(
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption(color: color).copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildLastReadTab(StorageService storage, AppPalette p) {
    final lastRead = storage.lastRead;
    if (lastRead == null) {
      return Center(
        child: Text(
          "Belum ada riwayat bacaan",
          style: AppTypography.body(color: p.textMuted),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, widget.bottomPadding),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: p.bannerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: p.accent.withValues(alpha: 0.5),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "Posisi Terakhir",
                        style: AppTypography.caption(color: p.accentLight),
                      ),
                    ),
                    Text(
                      "Juz ${lastRead.juzNumber} • Hal. ${lastRead.pageNumber}",
                      style: AppTypography.caption(color: p.textDim),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  "Surah ${lastRead.surahName}",
                  style: AppTypography.headingLarge(color: p.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ayat ke-${lastRead.ayahNumber}",
                  style: AppTypography.title(color: p.accentSoft),
                ),
                if (lastRead.arabicSnippet != null &&
                    lastRead.arabicSnippet!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: p.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lastRead.arabicSnippet!,
                      style: AppTypography.arabicVerse(
                        fontSize: 16,
                        color: p.accentLight,
                        fontFamily: storage.arabicFontFamily,
                      ),
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MushafVerseScreen(
                                surahNumber: lastRead.surahNumber,
                                initialAyah: lastRead.ayahNumber,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.format_list_bulleted_rounded,
                            size: 16),
                        label: const Text("Mode Ayat"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.accent,
                          foregroundColor:
                              p.isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MushafPageScreen(
                                initialPage: lastRead.pageNumber,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.menu_book_rounded,
                            size: 16, color: p.accentLight),
                        label: Text("Mode Halaman",
                            style: TextStyle(color: p.accentLight)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: p.accent),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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

  Widget _buildBookmarksListTab(
    StorageService storage,
    FirebaseService firebase,
    AppPalette p,
  ) {
    final bookmarks = storage.bookmarks;

    if (bookmarks.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 32, 32, widget.bottomPadding + 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_border_rounded, size: 56, color: p.textDim),
              const SizedBox(height: 14),
              Text(
                "Belum ada penanda tersimpan",
                style: AppTypography.headingMedium(color: p.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                "Ketuk ikon bookmark pada ayat atau halaman mushaf untuk menyimpannya di sini.",
                style: AppTypography.body(color: p.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 16, 16, widget.bottomPadding),
      physics: const BouncingScrollPhysics(),
      itemCount: bookmarks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final b = bookmarks[index];
        final isPage = b.type == 'page';

        return Dismissible(
          key: Key(b.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.rubyRed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.delete_outline_rounded,
                color: Colors.white, size: 28),
          ),
          onDismissed: (_) async {
            final messenger = ScaffoldMessenger.of(context);
            await storage.removeBookmark(b.id);
            await firebase.deleteBookmarkFromCloud(b.id);
            if (mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(isPage
                      ? "Bookmark Halaman ${b.pageNumber} dihapus"
                      : "Bookmark QS. ${b.surahName}: ${b.ayahNumber} dihapus"),
                  backgroundColor: p.cardElevated,
                  action: SnackBarAction(
                    label: "Urungkan",
                    textColor: p.accent,
                    onPressed: () {
                      storage.addBookmark(b);
                      firebase.saveBookmarkToCloud(b);
                    },
                  ),
                ),
              );
            }
          },
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => isPage
                      ? MushafPageScreen(initialPage: b.pageNumber)
                      : MushafVerseScreen(
                          surahNumber: b.surahNumber,
                          initialAyah: b.ayahNumber,
                        ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: p.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPage
                          ? Icons.auto_stories_rounded
                          : Icons.bookmark_rounded,
                      color: p.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPage
                              ? "Halaman ${b.pageNumber} (${b.surahName})"
                              : "QS. ${b.surahName}: ${b.ayahNumber}",
                          style: AppTypography.title(color: p.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Halaman ${b.pageNumber} • Juz ${b.juzNumber}",
                          style: AppTypography.caption(color: p.textDim),
                        ),
                        if (b.arabicSnippet != null &&
                            b.arabicSnippet!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            b.arabicSnippet!,
                            style: AppTypography.arabicVerse(
                              fontSize: 15,
                              color: p.accentLight,
                              fontFamily: storage.arabicFontFamily,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded,
                        size: 19, color: p.textDim),
                    tooltip: "Hapus Bookmark",
                    onPressed: () async {
                      await storage.removeBookmark(b.id);
                      await firebase.deleteBookmarkFromCloud(b.id);
                    },
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 15, color: p.accent),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
