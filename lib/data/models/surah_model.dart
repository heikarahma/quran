class SurahModel {
  final int number;
  final String nameLatin;
  final String nameArabic;
  final String translationId;
  final int totalAyah;
  final String revelationType; // Makkiyah / Madaniyah
  final int startPage; // 1 - 604
  final int startJuz;

  const SurahModel({
    required this.number,
    required this.nameLatin,
    required this.nameArabic,
    required this.translationId,
    required this.totalAyah,
    required this.revelationType,
    required this.startPage,
    required this.startJuz,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      nameLatin: json['nameLatin'] as String,
      nameArabic: json['nameArabic'] as String,
      translationId: json['translationId'] as String,
      totalAyah: json['totalAyah'] as int,
      revelationType: json['revelationType'] as String,
      startPage: json['startPage'] as int,
      startJuz: json['startJuz'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'nameLatin': nameLatin,
      'nameArabic': nameArabic,
      'translationId': translationId,
      'totalAyah': totalAyah,
      'revelationType': revelationType,
      'startPage': startPage,
      'startJuz': startJuz,
    };
  }
}
