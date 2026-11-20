class TafsirModel {
  final int surahNumber;
  final int ayahNumber;
  final String tafsirRingkas;
  final String tafsirKemenag;
  final String? tafsirJalalayn;
  final String? asbabunNuzul;

  const TafsirModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.tafsirRingkas,
    required this.tafsirKemenag,
    this.tafsirJalalayn,
    this.asbabunNuzul,
  });
}
