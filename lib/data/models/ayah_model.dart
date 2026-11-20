class AyahModel {
  final int surahNumber;
  final int ayahNumber;
  final String textArabic;
  final String transliteration;
  final String translationId;
  final int pageNumber;
  final int juzNumber;
  final String audioUrl;
  final String? sajda;

  const AyahModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.textArabic,
    required this.transliteration,
    required this.translationId,
    required this.pageNumber,
    required this.juzNumber,
    required this.audioUrl,
    this.sajda,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      textArabic: json['textArabic'] as String,
      transliteration: json['transliteration'] as String? ?? '',
      translationId: json['translationId'] as String,
      pageNumber: json['pageNumber'] as int,
      juzNumber: json['juzNumber'] as int,
      audioUrl: json['audioUrl'] as String? ?? '',
      sajda: json['sajda'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'textArabic': textArabic,
      'transliteration': transliteration,
      'translationId': translationId,
      'pageNumber': pageNumber,
      'juzNumber': juzNumber,
      'audioUrl': audioUrl,
      'sajda': sajda,
    };
  }
}
