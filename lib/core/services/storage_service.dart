import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/bookmark_model.dart';
import '../constants/app_themes.dart';

class StorageService extends ChangeNotifier {
  SharedPreferences? _prefs;

  // Settings State
  double _arabicFontSize = 26.0;
  double _translationFontSize = 14.0;
  String _arabicFontFamily = 'Amiri';
  ThemeModeType _themeMode = ThemeModeType.darkGold;
  bool _showTransliteration = true;
  bool _showTranslation = true;
  bool _keepScreenOn = true;

  // Local Data State
  BookmarkModel? _lastRead;
  List<BookmarkModel> _bookmarks = [];

  // Getters
  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;
  String get arabicFontFamily => _arabicFontFamily;
  ThemeModeType get themeMode => _themeMode;
  bool get showTransliteration => _showTransliteration;
  bool get showTranslation => _showTranslation;
  bool get keepScreenOn => _keepScreenOn;
  BookmarkModel? get lastRead => _lastRead;
  List<BookmarkModel> get bookmarks => List.unmodifiable(_bookmarks);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _loadLocalData();
  }

  void _loadSettings() {
    if (_prefs == null) return;
    _arabicFontSize = (_prefs!.getDouble('arabic_font_size') ?? 26.0).clamp(20.0, 42.0);
    _translationFontSize = (_prefs!.getDouble('translation_font_size') ?? 14.0).clamp(12.0, 22.0);
    final family = _prefs!.getString('arabic_font_family') ?? 'Amiri';
    _arabicFontFamily = (family == 'Scheherazade') ? 'Scheherazade' : 'Amiri';
    final themeIndex = _prefs!.getInt('theme_mode') ?? 0;
    _themeMode = ThemeModeType.values[themeIndex.clamp(0, ThemeModeType.values.length - 1)];
    _showTransliteration = _prefs!.getBool('show_transliteration') ?? true;
    _showTranslation = _prefs!.getBool('show_translation') ?? true;
    _keepScreenOn = _prefs!.getBool('keep_screen_on') ?? true;
    notifyListeners();
  }

  void _loadLocalData() {
    if (_prefs == null) return;
    final lastReadRaw = _prefs!.getString('last_read');
    if (lastReadRaw != null) {
      try {
        _lastRead = BookmarkModel.fromJson(jsonDecode(lastReadRaw));
      } catch (_) {}
    }

    _lastRead ??= BookmarkModel(
      id: 'init_last_read',
      type: 'last_read',
      surahNumber: 18,
      surahName: 'Al-Kahf',
      ayahNumber: 10,
      pageNumber: 294,
      juzNumber: 15,
      arabicSnippet: 'إِذْ أَوَى ٱلْفِتْيَةُ إِلَى ٱلْكَهْفِ فَقَالُوا۟ رَبَّنَآ ءَاتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
      createdAt: DateTime.now(),
    );

    final bookmarksRaw = _prefs!.getStringList('bookmarks') ?? [];
    final parsed = <BookmarkModel>[];
    for (final item in bookmarksRaw) {
      try {
        parsed.add(BookmarkModel.fromJson(jsonDecode(item)));
      } catch (_) {}
    }
    _bookmarks = parsed;
    notifyListeners();
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size.clamp(20.0, 42.0);
    await _prefs?.setDouble('arabic_font_size', _arabicFontSize);
    notifyListeners();
  }

  Future<void> setTranslationFontSize(double size) async {
    _translationFontSize = size.clamp(12.0, 22.0);
    await _prefs?.setDouble('translation_font_size', _translationFontSize);
    notifyListeners();
  }

  Future<void> setArabicFontFamily(String family) async {
    _arabicFontFamily = (family == 'Scheherazade') ? 'Scheherazade' : 'Amiri';
    await _prefs?.setString('arabic_font_family', _arabicFontFamily);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeType theme) async {
    _themeMode = theme;
    await _prefs?.setInt('theme_mode', theme.index);
    notifyListeners();
  }

  Future<void> toggleTransliteration() async {
    _showTransliteration = !_showTransliteration;
    await _prefs?.setBool('show_transliteration', _showTransliteration);
    notifyListeners();
  }

  Future<void> toggleTranslation() async {
    _showTranslation = !_showTranslation;
    await _prefs?.setBool('show_translation', _showTranslation);
    notifyListeners();
  }

  Future<void> setLastRead(BookmarkModel lastRead) async {
    _lastRead = lastRead;
    await _prefs?.setString('last_read', jsonEncode(lastRead.toJson()));
    notifyListeners();
  }

  Future<void> addBookmark(BookmarkModel bookmark) async {
    _bookmarks.removeWhere((b) => b.id == bookmark.id);
    _bookmarks.insert(0, bookmark);
    await _persistBookmarks();
    notifyListeners();
  }

  Future<void> removeBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((b) => b.id == bookmarkId);
    await _persistBookmarks();
    notifyListeners();
  }

  Future<void> _persistBookmarks() async {
    final rawList = _bookmarks.map((b) => jsonEncode(b.toJson())).toList();
    await _prefs?.setStringList('bookmarks', rawList);
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    return _bookmarks.any((b) =>
        b.surahNumber == surahNumber &&
        b.ayahNumber == ayahNumber &&
        b.type == 'ayah');
  }

  bool isPageBookmarked(int pageNumber) {
    return _bookmarks.any((b) => b.pageNumber == pageNumber && b.type == 'page');
  }

  Future<bool> togglePageBookmark({
    required int pageNumber,
    required int surahNumber,
    required String surahName,
    required int juzNumber,
  }) async {
    final id = 'page_$pageNumber';
    final exists = _bookmarks.any((b) => b.id == id);
    if (exists) {
      await removeBookmark(id);
      return false;
    } else {
      await addBookmark(
        BookmarkModel(
          id: id,
          type: 'page',
          surahNumber: surahNumber,
          surahName: surahName,
          ayahNumber: 1,
          pageNumber: pageNumber,
          juzNumber: juzNumber,
          createdAt: DateTime.now(),
        ),
      );
      return true;
    }
  }

  String? getCachedSurahTafsir(int surahNumber) {
    return _prefs?.getString('tafsir_surah_$surahNumber');
  }

  Future<void> cacheSurahTafsir(int surahNumber, String rawJson) async {
    await _prefs?.setString('tafsir_surah_$surahNumber', rawJson);
  }
}
