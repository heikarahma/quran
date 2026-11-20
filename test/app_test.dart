import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_luxury_app/core/constants/app_themes.dart';
import 'package:quran_luxury_app/core/services/audio_player_service.dart';
import 'package:quran_luxury_app/core/services/firebase_service.dart';
import 'package:quran_luxury_app/core/services/storage_service.dart';
import 'package:quran_luxury_app/data/repositories/quran_repository.dart';
import 'package:quran_luxury_app/features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'package:quran_luxury_app/features/home/presentation/screens/home_screen.dart';
import 'package:quran_luxury_app/features/mushaf/presentation/screens/mushaf_page_screen.dart';
import 'package:quran_luxury_app/features/mushaf/presentation/screens/mushaf_verse_screen.dart';
import 'package:quran_luxury_app/features/mushaf/presentation/widgets/ayah_action_sheet.dart';
import 'package:quran_luxury_app/features/settings/presentation/widgets/font_settings_modal.dart';

Widget buildTestApp({
  required Widget home,
  required StorageService storage,
  required AudioPlayerService audio,
  required FirebaseService firebase,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<StorageService>.value(value: storage),
      ChangeNotifierProvider<AudioPlayerService>.value(value: audio),
      ChangeNotifierProvider<FirebaseService>.value(value: firebase),
    ],
    child: Consumer<StorageService>(
      builder: (context, s, _) {
        final ThemeData theme;
        switch (s.themeMode) {
          case ThemeModeType.lightMushaf:
            theme = AppThemes.lightTheme;
            break;
          case ThemeModeType.sepia:
            theme = AppThemes.sepiaTheme;
            break;
          case ThemeModeType.darkGold:
            theme = AppThemes.darkTheme;
            break;
        }
        return MaterialApp(
          theme: theme,
          home: home,
        );
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;
  late AudioPlayerService audio;
  late FirebaseService firebase;
  final repository = QuranRepository();

  setUpAll(() async {
    await repository.init();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService();
    await storage.init();
    audio = AudioPlayerService(enablePlatformAudio: false);
    firebase = FirebaseService();
  });

  tearDown(() {
    audio.dispose();
    firebase.dispose();
  });

  group('QuranRepository full dataset & API', () {
    test('loads all 114 surahs and 6236 ayahs offline', () {
      expect(repository.isLoaded, isTrue);
      final surahs = repository.getAllSurahs();
      expect(surahs.length, 114);

      int totalAyahs = 0;
      for (final s in surahs) {
        final ayahs = repository.getAyahsForSurah(s.number);
        expect(ayahs.length, s.totalAyah,
            reason: 'Surah ${s.number} (${s.nameLatin}) ayah count mismatch');
        totalAyahs += ayahs.length;
      }
      expect(totalAyahs, 6236);
    });

    test('covers all 604 Madani pages and multi-surah page 604', () {
      for (int p = 1; p <= 604; p++) {
        final ayahs = repository.getAyahsForPage(p);
        expect(ayahs, isNotEmpty, reason: 'Page $p should not be empty');
      }
      final page604 = repository.getAyahsForPage(604);
      final surahsOn604 = page604.map((a) => a.surahNumber).toSet();
      expect(surahsOn604, containsAll([112, 113, 114]));
    });

    test('searchSurahs normalizes hyphens and matches number and meaning', () {
      expect(repository.searchSurahs('kahf').any((s) => s.number == 18), isTrue);
      expect(repository.searchSurahs('alkahf').any((s) => s.number == 18), isTrue);
      expect(repository.searchSurahs('18').first.number, 18);
      expect(repository.searchSurahs('Gua').any((s) => s.number == 18), isTrue);
    });

    test('fetchTafsirForAyah caches response from equran.id API', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), 'https://equran.id/api/v2/tafsir/18');
        return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'tafsir': [
                {
                  'ayat': 10,
                  'teks': 'Paragraf pertama ringkas.\n\nParagraf kedua penjelasan lengkap.',
                }
              ],
            },
          }),
          200,
        );
      });

      final tafsir = await repository.fetchTafsirForAyah(
        18,
        10,
        storage: storage,
        client: mockClient,
      );
      expect(tafsir.tafsirRingkas, 'Paragraf pertama ringkas.');
      expect(tafsir.tafsirKemenag, contains('Paragraf kedua penjelasan lengkap.'));
      expect(storage.getCachedSurahTafsir(18), isNotNull);
    });
  });

  group('StorageService persistence', () {
    test('toggles ayah and page bookmarks and clamps font sizes', () async {
      await storage.setArabicFontSize(99);
      expect(storage.arabicFontSize, 42.0);
      await storage.setTranslationFontSize(4);
      expect(storage.translationFontSize, 12.0);

      final added = await storage.togglePageBookmark(
        pageNumber: 294,
        surahNumber: 18,
        surahName: 'Al-Kahf',
        juzNumber: 15,
      );
      expect(added, isTrue);
      expect(storage.isPageBookmarked(294), isTrue);

      final removed = await storage.togglePageBookmark(
        pageNumber: 294,
        surahNumber: 18,
        surahName: 'Al-Kahf',
        juzNumber: 15,
      );
      expect(removed, isFalse);
      expect(storage.isPageBookmarked(294), isFalse);
    });
  });

  group('UI Widget tests', () {
    testWidgets('HomeScreen Bookmark tab has no duplicate AppBar and search filters surahs',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          home: const HomeScreen(),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Al-Qur'an Al-Karim"), findsOneWidget);
      expect(find.text('Al-Fatihah'), findsOneWidget);

      // Search filters to Ya-Sin (title and subtitle both say Ya-Sin)
      await tester.enterText(find.byType(TextField), 'yasin');
      await tester.pumpAndSettle();
      expect(find.text('Ya-Sin'), findsWidgets);
      expect(find.text('Al-Fatihah'), findsNothing);

      // Switch to Bookmark tab -> must not render duplicate "Penanda & Terakhir Baca" AppBar
      await tester.tap(find.text('Bookmark'));
      await tester.pumpAndSettle();
      expect(find.text('Penanda & Terakhir Baca'), findsNothing);
      expect(find.text('Terakhir Dibaca'), findsWidgets);
    });

    testWidgets('Standalone BookmarksScreen shows Mode Lokal when Firebase not configured',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          home: const BookmarksScreen(),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mode Lokal'), findsOneWidget);
      expect(find.text('Cloud Sync'), findsNothing);
    });

    testWidgets('FontSettingsModal changes theme between Dark Gold, Light, and Sepia',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => FontSettingsModal.show(ctx),
                child: const Text('Open'),
              ),
            ),
          ),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mushaf Terang'));
      await tester.pumpAndSettle();
      expect(storage.themeMode, ThemeModeType.lightMushaf);

      await tester.tap(find.text('Sepia'));
      await tester.pumpAndSettle();
      expect(storage.themeMode, ThemeModeType.sepia);
    });

    testWidgets('MushafVerseScreen for Surah 1 does not duplicate Bismillah',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          home: const MushafVerseScreen(surahNumber: 1),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );
      await tester.pumpAndSettle();

      // Only Ayah 1 has Bismillah; header should not show a duplicate standalone Bismillah
      final bismillahMatches =
          find.textContaining('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ');
      expect(bismillahMatches, findsOneWidget);
    });

    testWidgets('MushafPageScreen page 604 renders Al-Ikhlas, Al-Falaq, and An-Nas',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          home: const MushafPageScreen(initialPage: 604),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mushaf Digital (Hal. 604)'), findsOneWidget);
      expect(find.textContaining('الإخلاص'), findsWidgets);
      expect(find.textContaining('الفلق'), findsOneWidget);
      expect(find.textContaining('الناس'), findsWidgets);

      // Bookmark page 604 via AppBar bookmark button
      await tester.tap(find.byTooltip('Tandai Halaman'));
      await tester.pumpAndSettle();
      expect(storage.isPageBookmarked(604), isTrue);
    });

    testWidgets('MushafVerseScreen scrolls to initialAyah 10 in Al-Kahf',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          home: const MushafVerseScreen(surahNumber: 18, initialAyah: 10),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );
      await tester.pumpAndSettle();

      final ayah10Finder = find.textContaining('إِذْ أَوَى');
      expect(ayah10Finder, findsOneWidget);
    });

    testWidgets('AyahActionSheet saves bookmark without deactivated context crash',
        (tester) async {
      final surah18 = repository.getSurahByNumber(18)!;
      final ayah10 = repository.getAyahsForSurah(18)[9];

      await tester.pumpWidget(
        buildTestApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => AyahActionSheet.show(ctx, ayah10, surah18),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
          storage: storage,
          audio: audio,
          firebase: firebase,
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simpan ke Bookmark'));
      await tester.pumpAndSettle();

      expect(storage.isBookmarked(18, 10), isTrue);
      expect(find.text('Berhasil disimpan ke Bookmark'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
