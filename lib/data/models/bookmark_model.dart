class BookmarkModel {
  final String id;
  final String type; // 'ayah' | 'page' | 'last_read' | 'note'
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final String? arabicSnippet;
  final String? noteText;
  final DateTime createdAt;

  BookmarkModel({
    required this.id,
    required this.type,
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
    this.arabicSnippet,
    this.noteText,
    required this.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as String,
      type: json['type'] as String,
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      ayahNumber: json['ayahNumber'] as int,
      pageNumber: json['pageNumber'] as int,
      juzNumber: json['juzNumber'] as int,
      arabicSnippet: json['arabicSnippet'] as String?,
      noteText: json['noteText'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'pageNumber': pageNumber,
      'juzNumber': juzNumber,
      'arabicSnippet': arabicSnippet,
      'noteText': noteText,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
