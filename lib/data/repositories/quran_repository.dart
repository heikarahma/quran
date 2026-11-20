import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../../core/services/storage_service.dart';
import '../datasources/quran_dataset.dart';
import '../models/ayah_model.dart';
import '../models/juz_model.dart';
import '../models/qari_model.dart';
import '../models/surah_model.dart';
import '../models/tafsir_model.dart';

class QuranRepository {
  static final QuranRepository _instance = QuranRepository._internal();
  factory QuranRepository() => _instance;
  QuranRepository._internal();

  bool _isLoaded = false;
  Future<void>? _loadingFuture;

  final Map<int, List<AyahModel>> _ayahsBySurah = {};
  final Map<int, List<AyahModel>> _ayahsByPage = {};
  final Map<int, Map<int, String>> _tafsirMemoryCache = {};

  bool get isLoaded => _isLoaded;

  Future<void> init() {
    if (_isLoaded) return Future.value();
    _loadingFuture ??= _loadFromBundle();
    return _loadingFuture!;
  }

  Future<void> _loadFromBundle() async {
    try {
      final raw = await rootBundle.loadString('assets/data/quran_full.json');
      initFromJsonString(raw);
    } catch (e) {
      debugPrint("Failed to load bundled Quran dataset: $e");
      _loadingFuture = null;
    }
  }

  @visibleForTesting
  void initFromJsonString(String rawJson) {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final list = decoded['ayahs'] as List<dynamic>;

    _ayahsBySurah.clear();
    _ayahsByPage.clear();

    for (final item in list) {
      final m = item as Map<String, dynamic>;
      final s = m['s'] as int;
      final a = m['a'] as int;
      final ayah = AyahModel(
        surahNumber: s,
        ayahNumber: a,
        textArabic: m['ar'] as String,
        transliteration: m['tr'] as String? ?? '',
        translationId: m['id'] as String? ?? '',
        pageNumber: m['p'] as int,
        juzNumber: m['j'] as int,
        audioUrl:
            "https://everyayah.com/data/Alafasy_128kbps/${s.toString().padLeft(3, '0')}${a.toString().padLeft(3, '0')}.mp3",
        sajda: m['sj'] as String?,
      );

      _ayahsBySurah.putIfAbsent(s, () => []).add(ayah);
      _ayahsByPage.putIfAbsent(ayah.pageNumber, () => []).add(ayah);
    }
    _isLoaded = true;
  }

  List<SurahModel> getAllSurahs() {
    return QuranDataset.allSurahs;
  }

  SurahModel? getSurahByNumber(int number) {
    for (final s in QuranDataset.allSurahs) {
      if (s.number == number) return s;
    }
    return null;
  }

  List<JuzModel> getAllJuz() {
    return QuranDataset.allJuz;
  }

  List<QariModel> getAllQaris() {
    return QuranDataset.allQaris;
  }

  List<AyahModel> getAyahsForSurah(int surahNumber) {
    final loaded = _ayahsBySurah[surahNumber];
    if (loaded != null && loaded.isNotEmpty) {
      return loaded;
    }

    if (QuranDataset.surahAyahs.containsKey(surahNumber)) {
      return QuranDataset.surahAyahs[surahNumber]!;
    }

    final surah = getSurahByNumber(surahNumber);
    if (surah == null) return [];

    return List.generate(surah.totalAyah, (index) {
      final ayahNum = index + 1;
      return AyahModel(
        surahNumber: surahNumber,
        ayahNumber: ayahNum,
        textArabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        transliteration: "Ayat ke-$ayahNum dari Surah ${surah.nameLatin}",
        translationId: "Memuat terjemahan ayat ke-$ayahNum dari Surah ${surah.nameLatin}.",
        pageNumber: surah.startPage,
        juzNumber: surah.startJuz,
        audioUrl:
            "https://everyayah.com/data/Alafasy_128kbps/${surahNumber.toString().padLeft(3, '0')}${ayahNum.toString().padLeft(3, '0')}.mp3",
      );
    });
  }

  List<AyahModel> getAyahsForPage(int pageNumber) {
    final clamped = pageNumber.clamp(1, 604);
    final loaded = _ayahsByPage[clamped];
    if (loaded != null && loaded.isNotEmpty) {
      return loaded;
    }

    // Fallback using pre-cached dataset filtered by page
    final preCached = <AyahModel>[];
    for (final list in QuranDataset.surahAyahs.values) {
      for (final a in list) {
        if (a.pageNumber == clamped) preCached.add(a);
      }
    }
    if (preCached.isNotEmpty) return preCached;

    final surah = getSurahForPage(clamped);
    return getAyahsForSurah(surah.number)
        .where((a) => a.pageNumber == clamped)
        .toList();
  }

  SurahModel getSurahForPage(int pageNumber) {
    final pageAyahs = _ayahsByPage[pageNumber];
    if (pageAyahs != null && pageAyahs.isNotEmpty) {
      return getSurahByNumber(pageAyahs.first.surahNumber) ?? QuranDataset.allSurahs[0];
    }
    SurahModel result = QuranDataset.allSurahs[0];
    for (final s in QuranDataset.allSurahs) {
      if (s.startPage <= pageNumber) {
        result = s;
      } else {
        break;
      }
    }
    return result;
  }

  int getJuzForPage(int pageNumber) {
    final pageAyahs = _ayahsByPage[pageNumber];
    if (pageAyahs != null && pageAyahs.isNotEmpty) {
      return pageAyahs.first.juzNumber;
    }
    for (final j in QuranDataset.allJuz) {
      if (pageNumber >= j.startPage && pageNumber <= j.endPage) {
        return j.number;
      }
    }
    return 1;
  }

  TafsirModel getTafsirForAyah(int surahNumber, int ayahNumber) {
    final memSurah = _tafsirMemoryCache[surahNumber];
    if (memSurah != null && memSurah.containsKey(ayahNumber)) {
      final fullText = memSurah[ayahNumber]!;
      return _buildTafsirFromFullText(surahNumber, ayahNumber, fullText);
    }

    final key = "$surahNumber:$ayahNumber";
    if (QuranDataset.sampleTafsir.containsKey(key)) {
      return QuranDataset.sampleTafsir[key]!;
    }

    final surah = getSurahByNumber(surahNumber);
    return TafsirModel(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      tafsirRingkas:
          "Tafsir ringkas untuk QS. ${surah?.nameLatin ?? 'Surah'} ayat $ayahNumber. Hubungkan ke internet sekali untuk mengunduh teks lengkap Tafsir Kemenag RI untuk surah ini dan menyimpannya secara offline.",
      tafsirKemenag:
          "Tafsir Tahlili Kementerian Agama RI untuk QS. ${surah?.nameLatin ?? 'Surah'} ayat $ayahNumber belum tersimpan di perangkat. Pastikan perangkat terhubung ke internet untuk memuat penjelasan lengkap.",
    );
  }

  Future<TafsirModel> fetchTafsirForAyah(
    int surahNumber,
    int ayahNumber, {
    StorageService? storage,
    http.Client? client,
  }) async {
    // 1. Check in-memory cache
    final memSurah = _tafsirMemoryCache[surahNumber];
    if (memSurah != null && memSurah.containsKey(ayahNumber)) {
      return _buildTafsirFromFullText(surahNumber, ayahNumber, memSurah[ayahNumber]!);
    }

    // 2. Check SharedPreferences local cache
    final cachedRaw = storage?.getCachedSurahTafsir(surahNumber);
    if (cachedRaw != null) {
      try {
        final parsed = _parseTafsirMap(cachedRaw);
        if (parsed.isNotEmpty) {
          _tafsirMemoryCache[surahNumber] = parsed;
          if (parsed.containsKey(ayahNumber)) {
            return _buildTafsirFromFullText(surahNumber, ayahNumber, parsed[ayahNumber]!);
          }
        }
      } catch (_) {}
    }

    // 3. Fetch from equran.id Tafsir Kemenag API
    final httpClient = client ?? http.Client();
    final shouldClose = client == null;
    try {
      final uri = Uri.parse("https://equran.id/api/v2/tafsir/$surahNumber");
      final res = await httpClient.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        final list = data?['tafsir'] as List<dynamic>?;
        if (list != null && list.isNotEmpty) {
          final map = <String, String>{};
          final intMap = <int, String>{};
          for (final item in list) {
            final m = item as Map<String, dynamic>;
            final a = m['ayat'] as int;
            final t = (m['teks'] as String? ?? '').trim();
            map['$a'] = t;
            intMap[a] = t;
          }
          _tafsirMemoryCache[surahNumber] = intMap;
          await storage?.cacheSurahTafsir(surahNumber, jsonEncode(map));
          if (intMap.containsKey(ayahNumber)) {
            return _buildTafsirFromFullText(surahNumber, ayahNumber, intMap[ayahNumber]!);
          }
        }
      }
    } catch (e) {
      debugPrint("Tafsir API fetch error: $e");
    } finally {
      if (shouldClose) httpClient.close();
    }

    return getTafsirForAyah(surahNumber, ayahNumber);
  }

  Map<int, String> _parseTafsirMap(String rawJson) {
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final result = <int, String>{};
    decoded.forEach((k, v) {
      final keyInt = int.tryParse(k);
      if (keyInt != null && v is String) {
        result[keyInt] = v;
      }
    });
    return result;
  }

  TafsirModel _buildTafsirFromFullText(int surahNumber, int ayahNumber, String fullText) {
    final paragraphs = fullText
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    final ringkas = paragraphs.isNotEmpty ? paragraphs.first : fullText;
    final sample = QuranDataset.sampleTafsir["$surahNumber:$ayahNumber"];
    return TafsirModel(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      tafsirRingkas: ringkas,
      tafsirKemenag: fullText,
      asbabunNuzul: sample?.asbabunNuzul,
    );
  }

  String _normalizeQuery(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r"[-'`’\s]+"), '')
        .trim();
  }

  List<SurahModel> searchSurahs(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return QuranDataset.allSurahs;
    final lower = trimmed.toLowerCase();
    final normalized = _normalizeQuery(trimmed);

    return QuranDataset.allSurahs.where((s) {
      return s.nameLatin.toLowerCase().contains(lower) ||
          _normalizeQuery(s.nameLatin).contains(normalized) ||
          s.translationId.toLowerCase().contains(lower) ||
          s.number.toString() == trimmed ||
          s.nameArabic.contains(trimmed);
    }).toList();
  }
}
