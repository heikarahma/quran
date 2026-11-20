class ArabicNumbers {
  static const List<String> _arabicDigits = [
    '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
  ];

  static String convert(dynamic number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      final digit = int.tryParse(char);
      if (digit != null && digit >= 0 && digit <= 9) {
        buffer.write(_arabicDigits[digit]);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// Returns the decorative end-of-ayah glyph with the number inside
  static String formatAyahEnd(int ayahNumber) {
    return ' ۝${convert(ayahNumber)} ';
  }
}
