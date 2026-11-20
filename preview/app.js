// ==========================================================================
// LUXURY MUSHAF MADANI (15-BARIS) & QURAN APPLICATION ENGINE
// ==========================================================================

const QuranApp = {
  // All 114 Surahs Metadata with Starting Page & Juz
  surahs: [
    { number: 1, nameLatin: "Al-Fatihah", nameArabic: "الفاتحة", translationId: "Pembukaan", totalAyah: 7, type: "Makkiyah", startPage: 1, startJuz: 1 },
    { number: 2, nameLatin: "Al-Baqarah", nameArabic: "البقرة", translationId: "Sapi Betina", totalAyah: 286, type: "Madaniyah", startPage: 2, startJuz: 1 },
    { number: 3, nameLatin: "Ali 'Imran", nameArabic: "آل عمران", translationId: "Keluarga Imran", totalAyah: 200, type: "Madaniyah", startPage: 50, startJuz: 3 },
    { number: 4, nameLatin: "An-Nisa'", nameArabic: "النساء", translationId: "Wanita", totalAyah: 176, type: "Madaniyah", startPage: 77, startJuz: 4 },
    { number: 5, nameLatin: "Al-Ma'idah", nameArabic: "المائدة", translationId: "Jamuan Hidangan", totalAyah: 120, type: "Madaniyah", startPage: 106, startJuz: 6 },
    { number: 6, nameLatin: "Al-An'am", nameArabic: "الأنعام", translationId: "Binatang Ternak", totalAyah: 165, type: "Makkiyah", startPage: 128, startJuz: 7 },
    { number: 7, nameLatin: "Al-A'raf", nameArabic: "الأعراف", translationId: "Tempat Tertinggi", totalAyah: 206, type: "Makkiyah", startPage: 151, startJuz: 8 },
    { number: 8, nameLatin: "Al-Anfal", nameArabic: "الأنفال", translationId: "Rampasan Perang", totalAyah: 75, type: "Madaniyah", startPage: 177, startJuz: 9 },
    { number: 9, nameLatin: "At-Taubah", nameArabic: "التوبة", translationId: "Pengampunan", totalAyah: 129, type: "Madaniyah", startPage: 187, startJuz: 10 },
    { number: 10, nameLatin: "Yunus", nameArabic: "يونس", translationId: "Nabi Yunus", totalAyah: 109, type: "Makkiyah", startPage: 208, startJuz: 11 },
    { number: 11, nameLatin: "Hud", nameArabic: "هود", translationId: "Nabi Hud", totalAyah: 123, type: "Makkiyah", startPage: 221, startJuz: 11 },
    { number: 12, nameLatin: "Yusuf", nameArabic: "يوسف", translationId: "Nabi Yusuf", totalAyah: 111, type: "Makkiyah", startPage: 235, startJuz: 12 },
    { number: 13, nameLatin: "Ar-Ra'd", nameArabic: "الرعد", translationId: "Guruh", totalAyah: 43, type: "Madaniyah", startPage: 249, startJuz: 13 },
    { number: 14, nameLatin: "Ibrahim", nameArabic: "إبراهيم", translationId: "Nabi Ibrahim", totalAyah: 52, type: "Makkiyah", startPage: 255, startJuz: 13 },
    { number: 15, nameLatin: "Al-Hijr", nameArabic: "الحجر", translationId: "Gunung Al-Hijr", totalAyah: 99, type: "Makkiyah", startPage: 262, startJuz: 14 },
    { number: 16, nameLatin: "An-Nahl", nameArabic: "النحل", translationId: "Lebah", totalAyah: 128, type: "Makkiyah", startPage: 267, startJuz: 14 },
    { number: 17, nameLatin: "Al-Isra'", nameArabic: "الإسراء", translationId: "Perjalanan Malam", totalAyah: 111, type: "Makkiyah", startPage: 282, startJuz: 15 },
    { number: 18, nameLatin: "Al-Kahf", nameArabic: "الكهف", translationId: "Gua", totalAyah: 110, type: "Makkiyah", startPage: 293, startJuz: 15 },
    { number: 19, nameLatin: "Maryam", nameArabic: "مريم", translationId: "Maryam", totalAyah: 98, type: "Makkiyah", startPage: 305, startJuz: 16 },
    { number: 20, nameLatin: "Ta-Ha", nameArabic: "طه", translationId: "Ta-Ha", totalAyah: 135, type: "Makkiyah", startPage: 312, startJuz: 16 },
    { number: 21, nameLatin: "Al-Anbiya'", nameArabic: "الأنبياء", translationId: "Para Nabi", totalAyah: 112, type: "Makkiyah", startPage: 322, startJuz: 17 },
    { number: 22, nameLatin: "Al-Hajj", nameArabic: "الحج", translationId: "Haji", totalAyah: 78, type: "Madaniyah", startPage: 332, startJuz: 17 },
    { number: 23, nameLatin: "Al-Mu'minun", nameArabic: "المؤمنون", translationId: "Orang-Orang Mukmin", totalAyah: 118, type: "Makkiyah", startPage: 342, startJuz: 18 },
    { number: 24, nameLatin: "An-Nur", nameArabic: "النور", translationId: "Cahaya", totalAyah: 64, type: "Madaniyah", startPage: 350, startJuz: 18 },
    { number: 25, nameLatin: "Al-Furqan", nameArabic: "الفرقان", translationId: "Pembeda", totalAyah: 77, type: "Makkiyah", startPage: 359, startJuz: 18 },
    { number: 26, nameLatin: "Asy-Syu'ara'", nameArabic: "الشعراء", translationId: "Penyair", totalAyah: 227, type: "Makkiyah", startPage: 367, startJuz: 19 },
    { number: 27, nameLatin: "An-Naml", nameArabic: "النمل", translationId: "Semut", totalAyah: 93, type: "Makkiyah", startPage: 377, startJuz: 19 },
    { number: 28, nameLatin: "Al-Qasas", nameArabic: "القصص", translationId: "Kisah-Kisah", totalAyah: 88, type: "Makkiyah", startPage: 385, startJuz: 20 },
    { number: 29, nameLatin: "Al-'Ankabut", nameArabic: "العنكبوت", translationId: "Laba-Laba", totalAyah: 69, type: "Makkiyah", startPage: 396, startJuz: 20 },
    { number: 30, nameLatin: "Ar-Rum", nameArabic: "الروم", translationId: "Bangsa Romawi", totalAyah: 60, type: "Makkiyah", startPage: 404, startJuz: 21 },
    { number: 31, nameLatin: "Luqman", nameArabic: "لقمان", translationId: "Luqman", totalAyah: 34, type: "Makkiyah", startPage: 411, startJuz: 21 },
    { number: 32, nameLatin: "As-Sajdah", nameArabic: "السجدة", translationId: "Sujud", totalAyah: 30, type: "Makkiyah", startPage: 415, startJuz: 21 },
    { number: 33, nameLatin: "Al-Ahzab", nameArabic: "الأحزاب", translationId: "Golongan Bersekutu", totalAyah: 73, type: "Madaniyah", startPage: 418, startJuz: 21 },
    { number: 34, nameLatin: "Saba'", nameArabic: "سبأ", translationId: "Kaum Saba'", totalAyah: 54, type: "Makkiyah", startPage: 428, startJuz: 22 },
    { number: 35, nameLatin: "Fatir", nameArabic: "فاطر", translationId: "Pencipta", totalAyah: 45, type: "Makkiyah", startPage: 434, startJuz: 22 },
    { number: 36, nameLatin: "Ya-Sin", nameArabic: "يس", translationId: "Ya-Sin", totalAyah: 83, type: "Makkiyah", startPage: 440, startJuz: 22 },
    { number: 37, nameLatin: "As-Saffat", nameArabic: "الصافات", translationId: "Barisan-Barisan", totalAyah: 182, type: "Makkiyah", startPage: 446, startJuz: 23 },
    { number: 38, nameLatin: "Sad", nameArabic: "ص", translationId: "Sad", totalAyah: 88, type: "Makkiyah", startPage: 453, startJuz: 23 },
    { number: 39, nameLatin: "Az-Zumar", nameArabic: "الزمر", translationId: "Rombongan", totalAyah: 75, type: "Makkiyah", startPage: 458, startJuz: 23 },
    { number: 40, nameLatin: "Ghafir", nameArabic: "غافر", translationId: "Yang Mengampuni", totalAyah: 85, type: "Makkiyah", startPage: 467, startJuz: 24 },
    { number: 41, nameLatin: "Fussilat", nameArabic: "فصلت", translationId: "Dijelaskan", totalAyah: 54, type: "Makkiyah", startPage: 477, startJuz: 24 },
    { number: 42, nameLatin: "Asy-Syura", nameArabic: "الشورى", translationId: "Musyawarah", totalAyah: 53, type: "Makkiyah", startPage: 483, startJuz: 25 },
    { number: 43, nameLatin: "Az-Zukhruf", nameArabic: "الزخرف", translationId: "Perhiasan", totalAyah: 89, type: "Makkiyah", startPage: 489, startJuz: 25 },
    { number: 44, nameLatin: "Ad-Dukhan", nameArabic: "الدخان", translationId: "Kabut", totalAyah: 59, type: "Makkiyah", startPage: 496, startJuz: 25 },
    { number: 45, nameLatin: "Al-Jasiyah", nameArabic: "الجاثية", translationId: "Berlutut", totalAyah: 37, type: "Makkiyah", startPage: 499, startJuz: 25 },
    { number: 46, nameLatin: "Al-Ahqaf", nameArabic: "الأحقاف", translationId: "Bukit-Bukit Pasir", totalAyah: 35, type: "Makkiyah", startPage: 502, startJuz: 26 },
    { number: 47, nameLatin: "Muhammad", nameArabic: "محمد", translationId: "Nabi Muhammad", totalAyah: 38, type: "Madaniyah", startPage: 507, startJuz: 26 },
    { number: 48, nameLatin: "Al-Fath", nameArabic: "الفتح", translationId: "Kemenangan", totalAyah: 29, type: "Madaniyah", startPage: 511, startJuz: 26 },
    { number: 49, nameLatin: "Al-Hujurat", nameArabic: "الحجرات", translationId: "Kamar-Kamar", totalAyah: 18, type: "Madaniyah", startPage: 515, startJuz: 26 },
    { number: 50, nameLatin: "Qaf", nameArabic: "ق", translationId: "Qaf", totalAyah: 45, type: "Makkiyah", startPage: 518, startJuz: 26 },
    { number: 51, nameLatin: "Az-Zariyat", nameArabic: "الذاريات", translationId: "Angin Menerbangkan", totalAyah: 60, type: "Makkiyah", startPage: 520, startJuz: 26 },
    { number: 52, nameLatin: "At-Tur", nameArabic: "الطور", translationId: "Bukit Tursina", totalAyah: 49, type: "Makkiyah", startPage: 523, startJuz: 27 },
    { number: 53, nameLatin: "An-Najm", nameArabic: "النجم", translationId: "Bintang", totalAyah: 62, type: "Makkiyah", startPage: 526, startJuz: 27 },
    { number: 54, nameLatin: "Al-Qamar", nameArabic: "القمر", translationId: "Bulan", totalAyah: 55, type: "Makkiyah", startPage: 528, startJuz: 27 },
    { number: 55, nameLatin: "Ar-Rahman", nameArabic: "الرحمن", translationId: "Maha Pengasih", totalAyah: 78, type: "Madaniyah", startPage: 531, startJuz: 27 },
    { number: 56, nameLatin: "Al-Waqi'ah", nameArabic: "الواقعة", translationId: "Hari Kiamat", totalAyah: 96, type: "Makkiyah", startPage: 534, startJuz: 27 },
    { number: 57, nameLatin: "Al-Hadid", nameArabic: "الحديد", translationId: "Besi", totalAyah: 29, type: "Madaniyah", startPage: 537, startJuz: 27 },
    { number: 58, nameLatin: "Al-Mujadilah", nameArabic: "المجادلة", translationId: "Gugatan", totalAyah: 22, type: "Madaniyah", startPage: 542, startJuz: 28 },
    { number: 59, nameLatin: "Al-Hasyr", nameArabic: "الحشر", translationId: "Pengusiran", totalAyah: 24, type: "Madaniyah", startPage: 545, startJuz: 28 },
    { number: 60, nameLatin: "Al-Mumtahanah", nameArabic: "الممتحنة", translationId: "Wanita yang Diuji", totalAyah: 13, type: "Madaniyah", startPage: 549, startJuz: 28 },
    { number: 61, nameLatin: "As-Saff", nameArabic: "الصف", translationId: "Barisan", totalAyah: 14, type: "Madaniyah", startPage: 551, startJuz: 28 },
    { number: 62, nameLatin: "Al-Jumu'ah", nameArabic: "الجمعة", translationId: "Jumat", totalAyah: 11, type: "Madaniyah", startPage: 553, startJuz: 28 },
    { number: 63, nameLatin: "Al-Munafiqun", nameArabic: "المنافقون", translationId: "Orang Munafik", totalAyah: 11, type: "Madaniyah", startPage: 554, startJuz: 28 },
    { number: 64, nameLatin: "At-Tagabun", nameArabic: "التغابن", translationId: "Pengungkapan Kesalahan", totalAyah: 18, type: "Madaniyah", startPage: 556, startJuz: 28 },
    { number: 65, nameLatin: "At-Talaq", nameArabic: "الطلاق", translationId: "Talak", totalAyah: 12, type: "Madaniyah", startPage: 558, startJuz: 28 },
    { number: 66, nameLatin: "At-Tahrim", nameArabic: "التحريم", translationId: "Pengharaman", totalAyah: 12, type: "Madaniyah", startPage: 560, startJuz: 28 },
    { number: 67, nameLatin: "Al-Mulk", nameArabic: "الملك", translationId: "Kerajaan", totalAyah: 30, type: "Makkiyah", startPage: 562, startJuz: 29 },
    { number: 68, nameLatin: "Al-Qalam", nameArabic: "القلم", translationId: "Pena", totalAyah: 52, type: "Makkiyah", startPage: 564, startJuz: 29 },
    { number: 69, nameLatin: "Al-Haqqah", nameArabic: "الحاقة", translationId: "Hari Kiamat", totalAyah: 52, type: "Makkiyah", startPage: 566, startJuz: 29 },
    { number: 70, nameLatin: "Al-Ma'arij", nameArabic: "المعارج", translationId: "Tempat Naik", totalAyah: 44, type: "Makkiyah", startPage: 568, startJuz: 29 },
    { number: 71, nameLatin: "Nuh", nameArabic: "نوح", translationId: "Nabi Nuh", totalAyah: 28, type: "Makkiyah", startPage: 570, startJuz: 29 },
    { number: 72, nameLatin: "Al-Jinn", nameArabic: "الجن", translationId: "Jin", totalAyah: 28, type: "Makkiyah", startPage: 572, startJuz: 29 },
    { number: 73, nameLatin: "Al-Muzzammil", nameArabic: "المزمل", translationId: "Orang Berselimut", totalAyah: 20, type: "Makkiyah", startPage: 574, startJuz: 29 },
    { number: 74, nameLatin: "Al-Muddassir", nameArabic: "المدثر", translationId: "Orang Berkemul", totalAyah: 56, type: "Makkiyah", startPage: 575, startJuz: 29 },
    { number: 75, nameLatin: "Al-Qiyamah", nameArabic: "القيامة", translationId: "Hari Berbangkit", totalAyah: 40, type: "Makkiyah", startPage: 577, startJuz: 29 },
    { number: 76, nameLatin: "Al-Insan", nameArabic: "الإنسان", translationId: "Manusia", totalAyah: 31, type: "Madaniyah", startPage: 578, startJuz: 29 },
    { number: 77, nameLatin: "Al-Mursalat", nameArabic: "المرسلات", translationId: "Malaikat Diutus", totalAyah: 50, type: "Makkiyah", startPage: 580, startJuz: 29 },
    { number: 78, nameLatin: "An-Naba'", nameArabic: "النبأ", translationId: "Berita Besar", totalAyah: 40, type: "Makkiyah", startPage: 582, startJuz: 30 },
    { number: 79, nameLatin: "An-Nazi'at", nameArabic: "النازعات", translationId: "Malaikat Mencabut", totalAyah: 46, type: "Makkiyah", startPage: 583, startJuz: 30 },
    { number: 80, nameLatin: "'Abasa", nameArabic: "عبس", translationId: "Bermuka Masam", totalAyah: 42, type: "Makkiyah", startPage: 585, startJuz: 30 },
    { number: 81, nameLatin: "At-Takwir", nameArabic: "التكوير", translationId: "Menggulung", totalAyah: 29, type: "Makkiyah", startPage: 586, startJuz: 30 },
    { number: 82, nameLatin: "Al-Infitar", nameArabic: "الانفطار", translationId: "Terbelah", totalAyah: 19, type: "Makkiyah", startPage: 587, startJuz: 30 },
    { number: 83, nameLatin: "Al-Mutaffifin", nameArabic: "المطففين", translationId: "Orang Curang", totalAyah: 36, type: "Makkiyah", startPage: 587, startJuz: 30 },
    { number: 84, nameLatin: "Al-Insyiqaq", nameArabic: "الانشقاق", translationId: "Terbelah", totalAyah: 25, type: "Makkiyah", startPage: 589, startJuz: 30 },
    { number: 85, nameLatin: "Al-Buruj", nameArabic: "البروج", translationId: "Gugusan Bintang", totalAyah: 22, type: "Makkiyah", startPage: 590, startJuz: 30 },
    { number: 86, nameLatin: "At-Tariq", nameArabic: "الطارق", translationId: "Datang di Malam Hari", totalAyah: 17, type: "Makkiyah", startPage: 591, startJuz: 30 },
    { number: 87, nameLatin: "Al-A'la", nameArabic: "الأعلى", translationId: "Maha Tinggi", totalAyah: 19, type: "Makkiyah", startPage: 591, startJuz: 30 },
    { number: 88, nameLatin: "Al-Gasyiyah", nameArabic: "الغاشية", translationId: "Hari Pembalasan", totalAyah: 26, type: "Makkiyah", startPage: 592, startJuz: 30 },
    { number: 89, nameLatin: "Al-Fajr", nameArabic: "الفجر", translationId: "Fajar", totalAyah: 30, type: "Makkiyah", startPage: 593, startJuz: 30 },
    { number: 90, nameLatin: "Al-Balad", nameArabic: "البلد", translationId: "Negeri", totalAyah: 20, type: "Makkiyah", startPage: 594, startJuz: 30 },
    { number: 91, nameLatin: "Asy-Syams", nameArabic: "الشمس", translationId: "Matahari", totalAyah: 15, type: "Makkiyah", startPage: 595, startJuz: 30 },
    { number: 92, nameLatin: "Al-Lail", nameArabic: "الليل", translationId: "Malam", totalAyah: 21, type: "Makkiyah", startPage: 595, startJuz: 30 },
    { number: 93, nameLatin: "Ad-Duha", nameArabic: "الضحى", translationId: "Waktu Duha", totalAyah: 11, type: "Makkiyah", startPage: 596, startJuz: 30 },
    { number: 94, nameLatin: "Asy-Syarh", nameArabic: "الشرح", translationId: "Kelapangan", totalAyah: 8, type: "Makkiyah", startPage: 596, startJuz: 30 },
    { number: 95, nameLatin: "At-Tin", nameArabic: "التين", translationId: "Buah Tin", totalAyah: 8, type: "Makkiyah", startPage: 597, startJuz: 30 },
    { number: 96, nameLatin: "Al-'Alaq", nameArabic: "العلق", translationId: "Segumpal Darah", totalAyah: 19, type: "Makkiyah", startPage: 597, startJuz: 30 },
    { number: 97, nameLatin: "Al-Qadr", nameArabic: "القدر", translationId: "Kemuliaan", totalAyah: 5, type: "Makkiyah", startPage: 598, startJuz: 30 },
    { number: 98, nameLatin: "Al-Bayyinah", nameArabic: "البيّنة", translationId: "Bukti Nyata", totalAyah: 8, type: "Madaniyah", startPage: 598, startJuz: 30 },
    { number: 99, nameLatin: "Az-Zalzalah", nameArabic: "الزلزلة", translationId: "Kegoncangan", totalAyah: 8, type: "Madaniyah", startPage: 599, startJuz: 30 },
    { number: 100, nameLatin: "Al-'Adiyat", nameArabic: "العاديات", translationId: "Kuda Perang", totalAyah: 11, type: "Makkiyah", startPage: 599, startJuz: 30 },
    { number: 101, nameLatin: "Al-Qari'ah", nameArabic: "القارعة", translationId: "Hari Kiamat", totalAyah: 11, type: "Makkiyah", startPage: 600, startJuz: 30 },
    { number: 102, nameLatin: "At-Takasur", nameArabic: "التكاثر", translationId: "Bermegah-Megahan", totalAyah: 8, type: "Makkiyah", startPage: 600, startJuz: 30 },
    { number: 103, nameLatin: "Al-'Asr", nameArabic: "العصر", translationId: "Masa", totalAyah: 3, type: "Makkiyah", startPage: 601, startJuz: 30 },
    { number: 104, nameLatin: "Al-Humazah", nameArabic: "الهمزة", translationId: "Pengumpat", totalAyah: 9, type: "Makkiyah", startPage: 601, startJuz: 30 },
    { number: 105, nameLatin: "Al-Fil", nameArabic: "الفيل", translationId: "Gajah", totalAyah: 5, type: "Makkiyah", startPage: 601, startJuz: 30 },
    { number: 106, nameLatin: "Quraisy", nameArabic: "قريش", translationId: "Suku Quraisy", totalAyah: 4, type: "Makkiyah", startPage: 602, startJuz: 30 },
    { number: 107, nameLatin: "Al-Ma'un", nameArabic: "الماعون", translationId: "Barang Berguna", totalAyah: 7, type: "Makkiyah", startPage: 602, startJuz: 30 },
    { number: 108, nameLatin: "Al-Kausar", nameArabic: "الكوثر", translationId: "Nikmat Berlimpah", totalAyah: 3, type: "Makkiyah", startPage: 602, startJuz: 30 },
    { number: 109, nameLatin: "Al-Kafirun", nameArabic: "الكافرون", translationId: "Orang Kafir", totalAyah: 6, type: "Makkiyah", startPage: 603, startJuz: 30 },
    { number: 110, nameLatin: "An-Nasr", nameArabic: "النصر", translationId: "Pertolongan", totalAyah: 3, type: "Madaniyah", startPage: 603, startJuz: 30 },
    { number: 111, nameLatin: "Al-Lahab", nameArabic: "اللهب", translationId: "Gejolak Api", totalAyah: 5, type: "Makkiyah", startPage: 603, startJuz: 30 },
    { number: 112, nameLatin: "Al-Ikhlas", nameArabic: "الإخلاص", translationId: "Keesaan Allah", totalAyah: 4, type: "Makkiyah", startPage: 604, startJuz: 30 },
    { number: 113, nameLatin: "Al-Falaq", nameArabic: "الفلق", translationId: "Waktu Subuh", totalAyah: 5, type: "Makkiyah", startPage: 604, startJuz: 30 },
    { number: 114, nameLatin: "An-Nas", nameArabic: "الناس", translationId: "Manusia", totalAyah: 6, type: "Makkiyah", startPage: 604, startJuz: 30 },
  ],

  // 30 Juz Metadata
  juzList: [
    { number: 1, nameArabic: "الم", startPage: 1, endPage: 21 },
    { number: 2, nameArabic: "سيقول", startPage: 22, endPage: 41 },
    { number: 3, nameArabic: "تلك الرسل", startPage: 42, endPage: 61 },
    { number: 4, nameArabic: "لن تنالوا", startPage: 62, endPage: 81 },
    { number: 5, nameArabic: "والمحصنات", startPage: 82, endPage: 101 },
    { number: 6, nameArabic: "لا يحب الله", startPage: 102, endPage: 121 },
    { number: 7, nameArabic: "وإذا سمعوا", startPage: 122, endPage: 141 },
    { number: 8, nameArabic: "ولو أننا", startPage: 142, endPage: 161 },
    { number: 9, nameArabic: "قال الملأ", startPage: 162, endPage: 181 },
    { number: 10, nameArabic: "واعلموا", startPage: 182, endPage: 201 },
    { number: 11, nameArabic: "يعتذرون", startPage: 202, endPage: 221 },
    { number: 12, nameArabic: "وما من دابة", startPage: 222, endPage: 241 },
    { number: 13, nameArabic: "وما أبرئ", startPage: 242, endPage: 261 },
    { number: 14, nameArabic: "ربما", startPage: 262, endPage: 281 },
    { number: 15, nameArabic: "سبحان الذي", startPage: 282, endPage: 301 },
    { number: 16, nameArabic: "قال ألم", startPage: 302, endPage: 321 },
    { number: 17, nameArabic: "اقترب للناس", startPage: 322, endPage: 341 },
    { number: 18, nameArabic: "قد أفلح", startPage: 342, endPage: 361 },
    { number: 19, nameArabic: "وقال الذين", startPage: 362, endPage: 381 },
    { number: 20, nameArabic: "أمن خلق", startPage: 382, endPage: 401 },
    { number: 21, nameArabic: "اتل ما أوحي", startPage: 402, endPage: 421 },
    { number: 22, nameArabic: "ومن يقنت", startPage: 422, endPage: 441 },
    { number: 23, nameArabic: "وما لي", startPage: 442, endPage: 461 },
    { number: 24, nameArabic: "فمن أظلم", startPage: 462, endPage: 481 },
    { number: 25, nameArabic: "إليه يرد", startPage: 482, endPage: 501 },
    { number: 26, nameArabic: "حم", startPage: 502, endPage: 521 },
    { number: 27, nameArabic: "قال فما خطبكم", startPage: 522, endPage: 541 },
    { number: 28, nameArabic: "قد سمع الله", startPage: 542, endPage: 561 },
    { number: 29, nameArabic: "تبارك الذي", startPage: 562, endPage: 581 },
    { number: 30, nameArabic: "عمّ", startPage: 582, endPage: 604 }
  ],

  // Qari Roster
  qaris: [
    { id: "alafasy", name: "Mishary Rashid Alafasy", folder: "Alafasy_128kbps" },
    { id: "ghamadi", name: "Saad Al-Ghamdi", folder: "Ghamadi_40kbps" },
    { id: "abdulbasit", name: "Abdul Basit Murattal", folder: "Abdul_Basit_Murattal_192kbps" },
    { id: "husary", name: "Mahmoud Khalil Al-Husary", folder: "Husary_128kbps" },
    { id: "sudais", name: "Abdur-Rahman As-Sudais", folder: "Abdurrahmaan_As-Sudais_192kbps" }
  ],

  currentQari: { id: "alafasy", name: "Mishary Rashid Alafasy", folder: "Alafasy_128kbps" },

  // Instant Pre-Cached Key Pages & Verses
  surahAyahsData: {
    1: [
      { surah: 1, ayah: 1, arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", latin: "Bismillāhir-raḥmānir-raḥīm", idText: "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.", page: 1, juz: 1 },
      { surah: 1, ayah: 2, arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", latin: "Al-ḥamdu lillāhi rabbil-'ālamīn", idText: "Segala puji bagi Allah, Tuhan seluruh alam,", page: 1, juz: 1 },
      { surah: 1, ayah: 3, arabic: "الرَّحْمَٰنِ الرَّحِيمِ", latin: "Ar-raḥmānir-raḥīm", idText: "Yang Maha Pengasih, Maha Penyayang,", page: 1, juz: 1 },
      { surah: 1, ayah: 4, arabic: "مَالِكِ يَوْمِ الدِّينِ", latin: "Māliki yaumid-dīn", idText: "Pemilik hari pembalasan.", page: 1, juz: 1 },
      { surah: 1, ayah: 5, arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", latin: "Iyyāka na'budu wa iyyāka nasta'īn", idText: "Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami memohon pertolongan.", page: 1, juz: 1 },
      { surah: 1, ayah: 6, arabic: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", latin: "Ihdinaṣ-ṣirāṭal-mustaqīm", idText: "Tunjukilah kami jalan yang lurus,", page: 1, juz: 1 },
      { surah: 1, ayah: 7, arabic: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", latin: "Ṣirāṭallażīna an'amta 'alaihim, gairil-magḍūbi 'alaihim wa laḍ-ḍāllīn", idText: "(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.", page: 1, juz: 1 }
    ],
    2: [
      { surah: 2, ayah: 1, arabic: "الم", latin: "Alif Lām Mīm", idText: "Alif Lam Mim.", page: 2, juz: 1 },
      { surah: 2, ayah: 2, arabic: "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِلْمُتَّقِينَ", latin: "Żālikal-kitābu lā raiba fīh, hudal lil-muttaqīn", idText: "Kitab (Al-Qur'an) ini tidak ada keraguan padanya; petunjuk bagi mereka yang bertakwa,", page: 2, juz: 1 },
      { surah: 2, ayah: 3, arabic: "الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ", latin: "Allażīna yu'minūna bil-gaibi wa yuqīmūnaṣ-ṣalāta wa mimmā razaqnāhum yunfiqūn", idText: "(yaitu) mereka yang beriman kepada yang gaib, melaksanakan salat, dan menginfakkan sebagian rezeki yang Kami berikan kepada mereka,", page: 2, juz: 1 },
      { surah: 2, ayah: 4, arabic: "وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ", latin: "Wallażīna yu'minūna bimā unzila ilaika wa mā unzila min qablik, wa bil-ākhirati hum yūqinūn", idText: "dan mereka yang beriman kepada (Al-Qur'an) yang diturunkan kepadamu (Muhammad) dan (kitab-kitab) yang telah diturunkan sebelum engkau, serta mereka yakin akan adanya akhirat.", page: 2, juz: 1 },
      { surah: 2, ayah: 5, arabic: "أُولَٰئِكَ عَلَىٰ هُدًى مِنْ رَبِّهِمْ ۖ وَأُولَٰئِكَ هُمُ الْمُفْلِحُونَ", latin: "Ulā'ika 'alā hudam mir rabbihim wa ulā'ika humul-mufliḥūn", idText: "Merekalah yang mendapat petunjuk dari Tuhannya, dan mereka itulah orang-orang yang beruntung.", page: 2, juz: 1 }
    ],
    18: [
      { surah: 18, ayah: 1, arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَنْزَلَ عَلَىٰ عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَلْ لَهُ عِوَجًا", latin: "Al-ḥamdu lillāhil-lażī anzala 'alā 'abdihil-kitāba wa lam yaj'al lahū 'iwajā", idText: "Segala puji bagi Allah yang telah menurunkan Kitab (Al-Qur'an) kepada hamba-Nya dan Dia tidak menjadikannya bengkok;", page: 293, juz: 15 },
      { surah: 18, ayah: 2, arabic: "قَيِّمًا لِيُنْذِرَ بَأْسًا شَدِيدًا مِنْ لَدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِينَ الَّذِينَ يَعْمَلُونَ الصَّالِحَاتِ أَنَّ لَهُمْ أَجْرًا حَسَنًا", latin: "Qayyimal liyunżira ba'san syadīdam mil ladunhu wa yubasysyiral-mu'minīnal-lażīna ya'malūnaṣ-ṣāliḥāti anna lahum ajran ḥasanā", idText: "sebagai bimbingan yang lurus, untuk memperingatkan akan siksa yang sangat pedih dari sisi-Nya dan memberikan kabar gembira kepada orang-orang mukmin yang mengerjakan kebajikan bahwa mereka akan mendapat balasan yang baik,", page: 293, juz: 15 },
      { surah: 18, ayah: 3, arabic: "مَاكِثِينَ فِيهِ أَبَدًا", latin: "Mākiṡīna fīhi abadā", idText: "mereka kekal di dalamnya untuk selama-lamanya,", page: 293, juz: 15 },
      { surah: 18, ayah: 4, arabic: "وَيُنْذِرَ الَّذِينَ قَالُوا اتَّخَذَ اللَّهُ وَلَدًا", latin: "Wa yunżiral-lażīna qāluttaakhażallāhu waladā", idText: "dan untuk memperingatkan kepada orang yang berkata, 'Allah mengambil seorang anak.'", page: 293, juz: 15 },
      { surah: 18, ayah: 5, arabic: "مَا لَهُمْ بِهِ مِنْ عِلْمٍ وَلَا لِآبَائِهِمْ ۚ كَبُرَتْ كَلِمَةً تَخْرُجُ مِنْ أَفْوَاهِهِمْ ۚ إِنْ يَقُولُونَ إِلَّا كَذِبًا", latin: "Mā lahum bihī min 'ilmiw wa lā li'ābā'ihim, kaburat kalimatan takhruju min afwāhihim, iy yaqūlūna illā każibā", idText: "Mereka sama sekali tidak mempunyai pengetahuan tentang hal itu, begitu pula nenek moyang mereka. Alangkah jeleknya kata-kata yang keluar dari mulut mereka; mereka hanya mengatakan (kebohongan) belaka.", page: 293, juz: 15 },
      { surah: 18, ayah: 10, arabic: "إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ فَقَالُوا رَبَّنَا آتِنَا مِنْ لَدُنْكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا", latin: "Iż awal-fityatu ilal-kahfi fa qālū rabbanā ātinā mil ladunka raḥmataw wa hayyi' lanā min amrinā rasyadā", idText: "(Ingatlah) tatkala para pemuda itu mencari tempat berlindung ke dalam gua, lalu mereka berdoa: 'Wahai Tuhan kami, berikanlah rahmat kepada kami dari sisi-Mu dan sempurnakanlah bagi kami petunjuk yang lurus dalam urusan kami.'", page: 294, juz: 15 }
    ],
    112: [
      { surah: 112, ayah: 1, arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ", latin: "Qul huwallāhu aḥad", idText: "Katakanlah (Muhammad), 'Dialah Allah, Yang Maha Esa.'", page: 604, juz: 30 },
      { surah: 112, ayah: 2, arabic: "اللَّهُ الصَّمَدُ", latin: "Allāhuṣ-ṣamad", idText: "Allah tempat meminta segala sesuatu.", page: 604, juz: 30 },
      { surah: 112, ayah: 3, arabic: "لَمْ يَلِدْ وَلَمْ يُولَدْ", latin: "Lam yalid wa lam yūlad", idText: "(Allah) tidak beranak dan tidak pula diperanakkan,", page: 604, juz: 30 },
      { surah: 112, ayah: 4, arabic: "وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ", latin: "Wa lam yakul lahū kufuwan aḥad", idText: "Dan tidak ada sesuatu yang setara dengan Dia.", page: 604, juz: 30 }
    ],
    113: [
      { surah: 113, ayah: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", latin: "Qul a'ūżu birabbil-falaq", idText: "Katakanlah, 'Aku berlindung kepada Tuhan yang menguasai subuh (fajar),'", page: 604, juz: 30 },
      { surah: 113, ayah: 2, arabic: "مِنْ شَرِّ مَا خَلَقَ", latin: "Min syarri mā khalaq", idText: "dari kejahatan (makhluk yang) Dia ciptakan,", page: 604, juz: 30 },
      { surah: 113, ayah: 3, arabic: "وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ", latin: "Wa min syarri gāsiqin iżā waqab", idText: "dan dari kejahatan malam apabila telah gelap gulita,", page: 604, juz: 30 },
      { surah: 113, ayah: 4, arabic: "وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ", latin: "Wa min syarrin-naffāṡāti fil-'uqad", idText: "dan dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul,", page: 604, juz: 30 },
      { surah: 113, ayah: 5, arabic: "وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ", latin: "Wa min syarri ḥāsidin iżā ḥasad", idText: "dan dari kejahatan orang yang dengki apabila dia dengki.", page: 604, juz: 30 }
    ],
    114: [
      { surah: 114, ayah: 1, arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", latin: "Qul a'ūżu birabbin-nās", idText: "Katakanlah, 'Aku berlindung kepada Tuhannya manusia,'", page: 604, juz: 30 },
      { surah: 114, ayah: 2, arabic: "مَلِكِ النَّاسِ", latin: "Malikin-nās", idText: "Raja manusia,", page: 604, juz: 30 },
      { surah: 114, ayah: 3, arabic: "إِلَٰهِ النَّاسِ", latin: "Ilāhin-nās", idText: "Sembahan manusia,", page: 604, juz: 30 },
      { surah: 114, ayah: 4, arabic: "مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ", latin: "Min syarril-waswāsil-khannās", idText: "dari kejahatan (bisikan) setan yang bersembunyi,", page: 604, juz: 30 },
      { surah: 114, ayah: 5, arabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ", latin: "Allażī yuwaswisu fī ṣudūrin-nās", idText: "yang membisikkan (kejahatan) ke dalam dada manusia,", page: 604, juz: 30 },
      { surah: 114, ayah: 6, arabic: "مِنَ الْجِنَّةِ وَالنَّاسِ", latin: "Minal-jinnati wan-nās", idText: "dari (golongan) jin dan manusia.", page: 604, juz: 30 }
    ]
  },

  // Dynamic Cache for all 604 pages
  pageCache: {},

  // Audio Engine
  audioPlayer: new Audio(),
  currentPlayingAyah: null,
  currentPlaylist: [],
  currentPlaylistIndex: 0,

  // Settings
  arabicFontSize: 24,
  translationFontSize: 13.5,
  showTransliteration: true,
  showTranslation: true,

  // Book Realism State
  soundEnabled: true,
  audioCtx: null,
  bookTheme: 'theme-parchment', // 'theme-parchment', 'theme-sepia', 'theme-darkgold'

  // Application State
  currentTab: 'surah',
  activeSurah: null,
  activeMushafPage: 1,
  selectedAyahForAction: null,
  lastRead: { surahNumber: 1, surahName: "Al-Fatihah", ayahNumber: 1, pageNumber: 1, juzNumber: 1 },
  bookmarks: [],

  init() {
    this.loadPersistedState();
    this.renderHomeView();
    this.closeAllModals();
    this.setupEventListeners();
    this.setupAudioListeners();
    this.populateJuzQuickLinks();
  },

  loadPersistedState() {
    try {
      const savedLastRead = localStorage.getItem('quran_last_read');
      if (savedLastRead) this.lastRead = JSON.parse(savedLastRead);

      const savedBookmarks = localStorage.getItem('quran_bookmarks');
      if (savedBookmarks) this.bookmarks = JSON.parse(savedBookmarks);

      const sound = localStorage.getItem('quran_sound_enabled');
      if (sound !== null) this.soundEnabled = sound === 'true';

      const theme = localStorage.getItem('quran_book_theme');
      if (theme) this.bookTheme = theme;
    } catch (e) {}
  },

  // Synthesizes a natural, crisp paper turning swoosh sound via Web Audio API
  playPaperTurnSound() {
    if (!this.soundEnabled) return;
    try {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (!AudioCtx) return;
      if (!this.audioCtx) this.audioCtx = new AudioCtx();
      if (this.audioCtx.state === 'suspended') this.audioCtx.resume();

      const ctx = this.audioCtx;
      const bufferSize = Math.floor(ctx.sampleRate * 0.22); // 220ms duration
      const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
      const data = buffer.getChannelData(0);

      // Noise generator shaped like paper friction
      for (let i = 0; i < bufferSize; i++) {
        const decay = Math.exp(-i / (bufferSize * 0.38));
        data[i] = (Math.random() * 2 - 1) * decay;
      }

      const noise = ctx.createBufferSource();
      noise.buffer = buffer;

      // Bandpass filter to isolate tactile paper rustle
      const filter = ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.setValueAtTime(820, ctx.currentTime);
      filter.frequency.exponentialRampToValueAtTime(420, ctx.currentTime + 0.18);
      filter.Q.value = 1.9;

      // Volume envelope
      const gain = ctx.createGain();
      gain.gain.setValueAtTime(0.01, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.28, ctx.currentTime + 0.03);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.21);

      noise.connect(filter);
      filter.connect(gain);
      gain.connect(ctx.destination);

      noise.start();
    } catch (e) {}
  },

  togglePageSound() {
    this.soundEnabled = !this.soundEnabled;
    try { localStorage.setItem('quran_sound_enabled', this.soundEnabled); } catch (e) {}
    const btn = document.getElementById('soundToggleBtn');
    if (btn) {
      btn.innerHTML = `<i class="${this.soundEnabled ? 'ri-volume-up-line' : 'ri-volume-mute-line'}"></i>`;
      btn.classList.toggle('active', this.soundEnabled);
    }
    this.showToast(this.soundEnabled ? "Efek Suara Lembaran Kertas: Aktif 🔊" : "Efek Suara Lembaran Kertas: Hening 🔇");
  },

  toggleBookTheme() {
    const themes = ['theme-parchment', 'theme-sepia', 'theme-darkgold'];
    const idx = themes.indexOf(this.bookTheme);
    this.bookTheme = themes[(idx + 1) % themes.length];
    try { localStorage.setItem('quran_book_theme', this.bookTheme); } catch (e) {}

    const leaf = document.getElementById('currentMushafLeaf');
    if (leaf) {
      leaf.classList.remove('theme-sepia', 'theme-darkgold');
      if (this.bookTheme !== 'theme-parchment') leaf.classList.add(this.bookTheme);
    }

    const labels = {
      'theme-parchment': 'Kertas Kitab Krem Alami',
      'theme-sepia': 'Kertas Antik Sepia',
      'theme-darkgold': 'Mode Malam Dark Gold'
    };
    this.showToast(`Warna Kertas: ${labels[this.bookTheme]}`);
  },

  toArabicDigits(num) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return (num ?? '').toString().split('').map(d => digits[d] || d).join('');
  },

  getSurahForPage(pageNum) {
    let result = this.surahs[0];
    for (const s of this.surahs) {
      if (s.startPage <= pageNum) result = s;
      else break;
    }
    return result;
  },

  getJuzForPage(pageNum) {
    for (const j of this.juzList) {
      if (pageNum >= j.startPage && pageNum <= j.endPage) return j;
    }
    return this.juzList[0];
  },

  // ========================================================================
  // RENDER HOME VIEW (SURAH LIST, LAST READ, TABS)
  // ========================================================================
  renderHomeView() {
    document.querySelector('.mobile-device').classList.remove('reading-book');
    const header = document.querySelector('.app-header');
    if (header) header.style.display = 'flex';
    document.getElementById('headerBackBtn').style.display = 'none';

    const container = document.getElementById('appContent');
    container.innerHTML = `
      <!-- Search Box -->
      <div class="search-container">
        <div class="search-box">
          <i class="ri-search-line" style="color: var(--gold-primary); font-size: 16px;"></i>
          <input type="text" id="surahSearchInput" placeholder="Cari nama surah, nomor, atau arti..." oninput="QuranApp.renderSurahList(this.value)">
        </div>
      </div>

      <!-- Last Read Banner -->
      <div class="last-read-card" onclick="QuranApp.openMushafPageView(${this.lastRead.pageNumber || 1})">
        <div class="last-read-watermark">القرآن</div>
        <div class="last-read-badge">
          <i class="ri-book-read-fill"></i> Terakhir Dibaca (Hal. ${this.lastRead.pageNumber || 1})
        </div>
        <h3 id="lastReadTitle">Surah ${this.lastRead.surahName || 'Al-Fatihah'}</h3>
        <p id="lastReadAyah">Ayat No. ${this.lastRead.ayahNumber || 1} • Juz ${this.lastRead.juzNumber || 1}</p>
        <button class="btn-resume">
          Buka Lembaran Kitab <i class="ri-arrow-right-line"></i>
        </button>
      </div>

      <!-- Tabs Navigation -->
      <nav class="tabs-nav">
        <div class="tab-item active" onclick="QuranApp.renderHomeView()">Surah</div>
        <div class="tab-item" onclick="QuranApp.openMushafPageView(1)">Mushaf (Hal. 1)</div>
        <div class="tab-item" onclick="QuranApp.openMushafPageView(293)">Surah Al-Kahf</div>
        <div class="tab-item" onclick="QuranApp.openMushafPageView(582)">Juz 30 (Hal. 582)</div>
      </nav>

      <!-- Surah List Container -->
      <div class="surah-list" id="surahListContainer"></div>
    `;

    this.renderSurahList();
    this.updateLastReadUI();
  },

  renderSurahList(filter = '') {
    const list = document.getElementById('surahListContainer');
    if (!list) return;

    const q = (filter || '').toLowerCase().trim();
    const filtered = this.surahs.filter(s =>
      s.nameLatin.toLowerCase().includes(q) ||
      s.translationId.toLowerCase().includes(q) ||
      s.number.toString() === q
    );

    list.innerHTML = filtered.map(s => `
      <div class="surah-item" onclick="QuranApp.openSurahModeModal(${s.number})">
        <div class="surah-num-badge">${s.number}</div>
        <div class="surah-info">
          <div class="surah-name-latin">${s.nameLatin}</div>
          <div class="surah-meta">${s.type} • ${s.totalAyah} AYAT • HAL. ${s.startPage}</div>
          <div class="surah-translation">${s.translationId}</div>
        </div>
        <div class="surah-arabic">${s.nameArabic}</div>
      </div>
    `).join('');
  },

  // ========================================================================
  // State for smooth page turning
  isFlipping: false,

  // ========================================================================
  // AUTHENTIC MUSHAF MADANI 15-BARIS KITAB VIEW
  // ========================================================================
  async openMushafPageView(pageNum = 1) {
    pageNum = Math.max(1, Math.min(604, Math.round(Number(pageNum) || 1)));
    this.activeMushafPage = pageNum;
    this.isFlipping = false;

    // Set mobile device to reading book mode
    document.querySelector('.mobile-device').classList.add('reading-book');

    const surah = this.getSurahForPage(pageNum);
    const juz = this.getJuzForPage(pageNum);

    // Save as last read
    this.lastRead = {
      surahNumber: surah.number,
      surahName: surah.nameLatin,
      ayahNumber: 1,
      pageNumber: pageNum,
      juzNumber: juz.number
    };
    try { localStorage.setItem('quran_last_read', JSON.stringify(this.lastRead)); } catch (e) {}

    const isBookmarked = this.bookmarks.some(b => b.pageNumber === pageNum);

    const container = document.getElementById('appContent');
    container.innerHTML = `
      <div class="mushaf-book-stage">
        
        <!-- Top Book Toolbar -->
        <div class="book-top-bar">
          <button class="book-bar-btn" onclick="QuranApp.renderHomeView()" title="Kembali ke Beranda Surah">
            <i class="ri-home-4-line"></i>
          </button>
          
          <div class="book-bar-center" onclick="QuranApp.openJumpModal()" style="cursor: pointer;">
            <span class="book-bar-title" id="mushafBarTitle">Surah ${surah.nameLatin}</span>
            <span class="book-bar-sub" id="mushafBarSub">Juz ${juz.number} • Halaman ${pageNum} dari 604</span>
          </div>

          <div class="book-bar-actions">
            <button class="book-bar-btn ${this.soundEnabled ? 'active' : ''}" id="soundToggleBtn" onclick="QuranApp.togglePageSound()" title="Efek Suara Lembaran Kertas">
              <i class="${this.soundEnabled ? 'ri-volume-up-line' : 'ri-volume-mute-line'}"></i>
            </button>
            <button class="book-bar-btn" onclick="QuranApp.toggleBookTheme()" title="Warna Tekstur Kertas Kitab">
              <i class="ri-palette-line"></i>
            </button>
            <button class="book-bar-btn" onclick="QuranApp.openJumpModal()" title="Lompat ke Halaman / Juz Lain">
              <i class="ri-compass-3-line"></i>
            </button>
          </div>
        </div>

        <!-- 3D Perspective Viewport -->
        <div class="book-perspective-viewport" id="bookViewport">
          
          <!-- Satin Silk Bookmark Ribbon hanging from binding -->
          <div class="satin-ribbon ${isBookmarked ? 'bookmarked' : ''}" id="satinRibbon" onclick="QuranApp.togglePageBookmark(QuranApp.activeMushafPage)" title="Pita Pembatas Kitab (Klik untuk Tandai)">
            <i class="${isBookmarked ? 'ri-bookmark-fill' : 'ri-bookmark-line'}"></i>
          </div>

          <!-- Under-Page Leaf (Layer revealed underneath when top leaf curls) -->
          <article class="mushaf-physical-page under-leaf" id="underMushafLeaf" style="display: none;"></article>

          <!-- Top Active Leaf (The front page that smoothly curls in 3D) -->
          <article class="mushaf-physical-page active-leaf" id="currentMushafLeaf">
            <div class="mushaf-page-loader">
              <div class="mushaf-loader-spinner"></div>
              <div style="font-family: var(--font-latin); font-size: 13px; font-weight: 600;">Membuka lembaran Kitab Suci Al-Qur'an...</div>
              <div style="font-size: 11px; color: var(--text-dim); font-family: var(--font-latin);">Halaman ${pageNum} • Juz ${juz.number}</div>
            </div>
          </article>

        </div>

        <!-- Bottom Page Turn Controls & Slider -->
        <div class="book-turn-controls">
          <!-- Next Page (Quran RTL: Next page turns towards left!) -->
          <button class="page-flip-btn" id="btnPageNext" ${pageNum === 604 ? 'disabled' : ''} onclick="QuranApp.flipPage('next')" title="Balik ke Lembaran Berikutnya">
            <i class="ri-arrow-left-s-line" style="font-size: 16px;"></i>
            <span>Berikutnya</span>
          </button>

          <div class="page-slider-wrap">
            <input type="range" id="mushafPageSlider" min="1" max="604" value="${pageNum}" oninput="QuranApp.onPageSliderInput(this.value)" onchange="QuranApp.openMushafPageView(this.value)">
            <div class="page-num-display">Halaman <strong id="sliderPageDisplay">${pageNum}</strong> / 604</div>
          </div>

          <!-- Prev Page (Quran RTL: Prev page turns towards right!) -->
          <button class="page-flip-btn" id="btnPagePrev" ${pageNum === 1 ? 'disabled' : ''} onclick="QuranApp.flipPage('prev')" title="Balik ke Lembaran Sebelumnya">
            <span>Sebelumnya</span>
            <i class="ri-arrow-right-s-line" style="font-size: 16px;"></i>
          </button>
        </div>

      </div>
    `;

    // Setup touch gestures on the leaf
    this.setupLeafGestures();

    // Populate active leaf with page content
    const currentLeaf = document.getElementById('currentMushafLeaf');
    const ayahs = await this.getAyahsForPage(pageNum);
    this.populateLeafElement(currentLeaf, pageNum, ayahs);
  },

  // Populate a leaf element with authentic 15-line Mushaf Madani page structure
  populateLeafElement(leafEl, pageNum, ayahs) {
    if (!leafEl) return;

    const surah = this.getSurahForPage(pageNum);
    const juz = this.getJuzForPage(pageNum);
    const isEven = (pageNum % 2 === 0);
    const isOpening = (pageNum <= 2);

    leafEl.className = `mushaf-physical-page ${leafEl.id === 'underMushafLeaf' ? 'under-leaf' : 'active-leaf'} ${isEven ? 'page-even' : 'page-odd'} ${this.bookTheme !== 'theme-parchment' ? this.bookTheme : ''}`;

    // Render 15-line Mushaf sections
    const surahGroups = [...new Set(ayahs.map(a => a.surah))];
    let bodyHtml = '';

    surahGroups.forEach(sNum => {
      const surahInfo = this.surahs.find(s => s.number === sNum) || { nameArabic: '', nameLatin: '', totalAyah: 0, type: 'Makkiyah' };
      const surahVerses = ayahs.filter(a => a.surah === sNum);

      // If verse 1 is on this page, show Surah Banner
      const hasFirstVerse = surahVerses.some(a => a.ayah === 1);
      if (hasFirstVerse) {
        bodyHtml += `
          <div class="mushaf-surah-banner">
            <div class="surah-banner-name">سُورَةُ ${surahInfo.nameArabic}</div>
            <div class="surah-banner-ayahs">آيَاتُهَا ${this.toArabicDigits(surahInfo.totalAyah)} • ${surahInfo.type.toUpperCase()}</div>
          </div>
        `;
        if (sNum !== 1 && sNum !== 9) {
          bodyHtml += `<div class="mushaf-bismillah">بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ</div>`;
        }
      }

      // Continuous justified verses with tap interaction
      bodyHtml += `<div>` + surahVerses.map(a => {
        let cleanText = a.arabic;
        if (a.ayah === 1 && sNum !== 1 && sNum !== 9) {
          cleanText = cleanText.replace(/^بِسْمِ [^ ]+ [^ ]+ [^ ]+\s*/, '');
        }
        return `
          <span class="mushaf-ayah-span" onclick="QuranApp.openMushafAyahAction(${a.surah}, ${a.ayah}, '${encodeURIComponent(cleanText)}')">
            ${cleanText}
          </span>
          <span class="mushaf-ayah-badge" onclick="QuranApp.openMushafAyahAction(${a.surah}, ${a.ayah}, '${encodeURIComponent(cleanText)}')">
            ۝${this.toArabicDigits(a.ayah)}
          </span>
        `;
      }).join(' ') + `</div>`;
    });

    leafEl.innerHTML = `
      <!-- Front Face of the Page -->
      <div class="leaf-front-face">
        <!-- Dog-Ear Fold Corner (Pojok Lipatan Buku untuk Membalik) -->
        <div class="dog-ear-corner" onclick="QuranApp.flipPage('${isEven ? 'prev' : 'next'}')" title="Klik untuk membalik lembaran">
          <i class="ri-arrow-${isEven ? 'right' : 'left'}-line"></i>
        </div>

        <!-- Illuminated Madani Frame (Bingkai Emas & Ornamen Geometris) -->
        <div class="madani-illuminated-border ${isOpening ? 'opening-grand-border' : ''}">
          <!-- 4 Islamic Corner Arabesques -->
          <div class="frame-corner corner-tl"></div>
          <div class="frame-corner corner-tr"></div>
          <div class="frame-corner corner-bl"></div>
          <div class="frame-corner corner-br"></div>

          <!-- Header Inside Mushaf Page -->
          <header class="mushaf-inner-header">
            <div class="cartouche-box">سُورَةُ ${surah.nameArabic}</div>
            <div class="header-quran-title">الْقُرْآنُ الْكَرِيمُ</div>
            <div class="cartouche-box">الجُزْءُ ${this.toArabicDigits(juz.number)}</div>
          </header>

          <!-- 15-Line Mushaf Body Content -->
          <div class="mushaf-lines-content">
            ${bodyHtml}
          </div>

          <!-- Footer Inside Mushaf Page -->
          <footer class="mushaf-inner-footer">
            <div class="cartouche-page-num">
              <span>ـ ${this.toArabicDigits(pageNum)} ـ</span>
            </div>
          </footer>
        </div>
      </div>

      <!-- Back / Verso Face of Parchment (Revealed when turned past 90 degrees) -->
      <div class="leaf-back-face">
        <div class="verso-spine-shadow"></div>
        <div class="verso-inner-border"></div>
        <div class="verso-watermark-symbol">۞</div>
      </div>

      <!-- Dynamic 3D Paper Curl Specular Highlight & Cylinder Shadow -->
      <div class="paper-curl-overlay"></div>

      <!-- Cast Shadow Overlay on Underlying Page -->
      <div class="under-leaf-shadow"></div>
    `;
  },

  // Asynchronously retrieve and cache verses for any given page (1 to 604)
  async getAyahsForPage(pageNum) {
    // 1. Check pre-cached dataset first
    const preCached = Object.values(this.surahAyahsData).flat().filter(a => a.page === pageNum);
    if (preCached.length > 0) return preCached;

    // 2. Check memory cache
    if (this.pageCache[pageNum]) return this.pageCache[pageNum];

    // 3. Check localStorage cache
    try {
      const cached = localStorage.getItem(`mushaf_page_${pageNum}`);
      if (cached) {
        const data = JSON.parse(cached);
        this.pageCache[pageNum] = data;
        return data;
      }
    } catch (e) {}

    // 4. Fetch live from public API
    try {
      const res = await fetch(`https://api.alquran.cloud/v1/page/${pageNum}/quran-uthmani`);
      if (res.ok) {
        const json = await res.json();
        if (json.code === 200 && json.data && json.data.ayahs) {
          const ayahs = json.data.ayahs.map(a => ({
            surah: a.surah.number,
            surahNameArabic: a.surah.name,
            surahNameLatin: a.surah.englishName,
            ayah: a.numberInSurah,
            arabic: a.text,
            page: pageNum,
            juz: a.juz
          }));
          this.pageCache[pageNum] = ayahs;
          try { localStorage.setItem(`mushaf_page_${pageNum}`, JSON.stringify(ayahs)); } catch (e) {}
          return ayahs;
        }
      }
    } catch (err) {
      console.warn("Fetch page error:", err);
    }

    // 5. Fallback if offline
    const s = this.getSurahForPage(pageNum);
    const j = this.getJuzForPage(pageNum);
    return [
      {
        surah: s.number,
        surahNameArabic: s.nameArabic,
        ayah: 1,
        arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        page: pageNum,
        juz: j.number
      }
    ];
  },

  // Authentic Multi-Layer Web Audio API Paper Rustle Synthesizer
  playPaperTurnSound() {
    try {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (!AudioCtx) return;
      if (!this.paperAudioCtx) {
        this.paperAudioCtx = new AudioCtx();
      }
      if (this.paperAudioCtx.state === 'suspended') {
        this.paperAudioCtx.resume();
      }

      const ctx = this.paperAudioCtx;
      const now = ctx.currentTime;

      // 1. Friction rustle of Quran paper sliding: Band-filtered noise buffer
      const bufferLength = Math.floor(ctx.sampleRate * 0.34); // ~340ms paper rustle
      const noiseBuffer = ctx.createBuffer(1, bufferLength, ctx.sampleRate);
      const output = noiseBuffer.getChannelData(0);
      for (let i = 0; i < bufferLength; i++) {
        output[i] = (Math.random() * 2 - 1) * Math.exp(-i / (bufferLength * 0.4));
      }

      const noiseSource = ctx.createBufferSource();
      noiseSource.buffer = noiseBuffer;

      const filter = ctx.createBiquadFilter();
      filter.type = 'bandpass';
      filter.frequency.setValueAtTime(1400, now);
      filter.frequency.exponentialRampToValueAtTime(650, now + 0.32);
      filter.Q.setValueAtTime(1.8, now);

      const gainNode = ctx.createGain();
      gainNode.gain.setValueAtTime(0.001, now);
      gainNode.gain.linearRampToValueAtTime(0.18, now + 0.04);
      gainNode.gain.exponentialRampToValueAtTime(0.001, now + 0.34);

      noiseSource.connect(filter);
      filter.connect(gainNode);
      gainNode.connect(ctx.destination);

      noiseSource.start(now);

      // 2. Soft page landing flutter sound
      const osc = ctx.createOscillator();
      const oscGain = ctx.createGain();
      osc.type = 'sine';
      osc.frequency.setValueAtTime(110, now + 0.12);
      osc.frequency.exponentialRampToValueAtTime(45, now + 0.28);

      oscGain.gain.setValueAtTime(0.001, now + 0.12);
      oscGain.gain.linearRampToValueAtTime(0.05, now + 0.16);
      oscGain.gain.exponentialRampToValueAtTime(0.0001, now + 0.28);

      osc.connect(oscGain);
      oscGain.connect(ctx.destination);

      osc.start(now + 0.12);
      osc.stop(now + 0.28);
    } catch (e) {
      // Audio autoplay policy fallback
    }
  },

  // Ultra-Smooth 3D Paper Curl & Turn
  async flipPage(direction) {
    if (this.isFlipping) return;

    const targetPage = (direction === 'next') ? this.activeMushafPage + 1 : this.activeMushafPage - 1;
    if (targetPage < 1 || targetPage > 604) return;

    this.isFlipping = true;

    // Play crisp tactile paper turning sound
    this.playPaperTurnSound();

    const currentLeaf = document.getElementById('currentMushafLeaf');
    const underLeaf = document.getElementById('underMushafLeaf');

    // Fetch destination page data immediately
    const targetAyahs = await this.getAyahsForPage(targetPage);

    if (underLeaf && currentLeaf) {
      // 1. Populate the underlying page so it is visible as top page curls
      this.populateLeafElement(underLeaf, targetPage, targetAyahs);
      underLeaf.style.display = 'flex';
      underLeaf.classList.add('settle-enter');

      // 2. Trigger realistic 3D paper curl animation on the turning leaf
      const animClass = (direction === 'next') ? 'curling-turn-next' : 'curling-turn-prev';
      currentLeaf.classList.add(animClass);

      // 3. Exactly at 620ms (curl completed), swap active leaf smoothly
      setTimeout(() => {
        this.activeMushafPage = targetPage;
        this.populateLeafElement(currentLeaf, targetPage, targetAyahs);
        currentLeaf.classList.remove('curling-turn-next', 'curling-turn-prev');

        underLeaf.style.display = 'none';
        underLeaf.classList.remove('settle-enter');

        // Update headers, slider, and buttons
        this.updateMushafHeaderAndSlider(targetPage);

        this.isFlipping = false;
      }, 620);
    } else {
      await this.openMushafPageView(targetPage);
      this.isFlipping = false;
    }
  },

  updateMushafHeaderAndSlider(pageNum) {
    const surah = this.getSurahForPage(pageNum);
    const juz = this.getJuzForPage(pageNum);

    const title = document.getElementById('mushafBarTitle');
    if (title) title.innerText = `Surah ${surah.nameLatin}`;

    const sub = document.getElementById('mushafBarSub');
    if (sub) sub.innerText = `Juz ${juz.number} • Halaman ${pageNum} dari 604`;

    const slider = document.getElementById('mushafPageSlider');
    if (slider) slider.value = pageNum;

    const disp = document.getElementById('sliderPageDisplay');
    if (disp) disp.innerText = pageNum;

    const btnNext = document.getElementById('btnPageNext');
    if (btnNext) btnNext.disabled = (pageNum === 604);

    const btnPrev = document.getElementById('btnPagePrev');
    if (btnPrev) btnPrev.disabled = (pageNum === 1);

    const ribbon = document.getElementById('satinRibbon');
    if (ribbon) {
      const isBm = this.bookmarks.some(b => b.pageNumber === pageNum);
      ribbon.classList.toggle('bookmarked', isBm);
      ribbon.innerHTML = `<i class="${isBm ? 'ri-bookmark-fill' : 'ri-bookmark-line'}"></i>`;
    }

    // Save as last read
    this.lastRead = {
      surahNumber: surah.number,
      surahName: surah.nameLatin,
      ayahNumber: 1,
      pageNumber: pageNum,
      juzNumber: juz.number
    };
    try { localStorage.setItem('quran_last_read', JSON.stringify(this.lastRead)); } catch (e) {}
  },

  onPageSliderInput(val) {
    const disp = document.getElementById('sliderPageDisplay');
    if (disp) disp.innerText = val;
  },

  setupLeafGestures() {
    const viewport = document.getElementById('bookViewport');
    if (!viewport) return;

    let startX = null;
    let startY = null;

    viewport.addEventListener('pointerdown', e => {
      startX = e.clientX;
      startY = e.clientY;
    });

    viewport.addEventListener('pointerup', e => {
      if (startX === null) return;
      const dx = e.clientX - startX;
      const dy = e.clientY - startY;
      startX = null;
      startY = null;

      // Horizontal swipe detection (Quran RTL: swipe left goes to next page, swipe right goes to prev page)
      if (Math.abs(dx) > 40 && Math.abs(dx) > Math.abs(dy) * 1.3) {
        if (dx < 0 && this.activeMushafPage < 604) {
          this.flipPage('next');
        } else if (dx > 0 && this.activeMushafPage > 1) {
          this.flipPage('prev');
        }
      }
    });

    // Keyboard navigation (ArrowLeft: next page, ArrowRight: prev page)
    window.onkeydown = (e) => {
      if (!document.querySelector('.mobile-device').classList.contains('reading-book')) return;
      if (e.key === 'ArrowLeft' && this.activeMushafPage < 604) {
        this.flipPage('next');
      } else if (e.key === 'ArrowRight' && this.activeMushafPage > 1) {
        this.flipPage('prev');
      }
    };
  },

  togglePageBookmark(pageNum) {
    const surah = this.getSurahForPage(pageNum);
    const juz = this.getJuzForPage(pageNum);
    const existingIdx = this.bookmarks.findIndex(b => b.pageNumber === pageNum);

    if (existingIdx >= 0) {
      this.bookmarks.splice(existingIdx, 1);
      this.showToast(`Bookmark Halaman ${pageNum} dihapus`);
    } else {
      this.bookmarks.push({
        id: `bm_page_${pageNum}`,
        pageNumber: pageNum,
        surahNumber: surah.number,
        surahName: surah.nameLatin,
        juzNumber: juz.number,
        createdAt: new Date().toISOString()
      });
      this.showToast(`Halaman ${pageNum} (${surah.nameLatin}) ditandai dengan Pita Pembatas! 🔖`);
    }

    try { localStorage.setItem('quran_bookmarks', JSON.stringify(this.bookmarks)); } catch (e) {}

    const ribbon = document.getElementById('satinRibbon');
    if (ribbon) {
      const isBm = this.bookmarks.some(b => b.pageNumber === pageNum);
      ribbon.classList.toggle('bookmarked', isBm);
      ribbon.innerHTML = `<i class="${isBm ? 'ri-bookmark-fill' : 'ri-bookmark-line'}"></i>`;
    }
  },

  openMushafAyahAction(surahNum, ayahNum, textEnc) {
    const surah = this.surahs.find(s => s.number === surahNum) || this.surahs[0];
    const text = decodeURIComponent(textEnc);

    this.selectedAyahForAction = {
      surah: surah,
      ayah: {
        surah: surahNum,
        ayah: ayahNum,
        arabic: text,
        idText: `Ayat ke-${ayahNum} dari Surah ${surah.nameLatin}.`
      }
    };

    document.getElementById('ayahActionTitle').innerText = `QS. ${surah.nameLatin}: ${ayahNum}`;
    document.getElementById('ayahActionArabic').innerText = text;
    this.openModal('ayahActionModal');
  },

  // ========================================================================
  // JUMP TO PAGE / JUZ MODAL
  // ========================================================================
  openJumpModal() {
    this.openModal('jumpPageModal');
    const input = document.getElementById('jumpPageInput');
    if (input) {
      input.value = this.activeMushafPage;
      setTimeout(() => input.focus(), 200);
    }
  },

  submitJumpPage() {
    const input = document.getElementById('jumpPageInput');
    if (!input) return;
    const pageNum = parseInt(input.value);
    if (pageNum >= 1 && pageNum <= 604) {
      this.closeAllModals();
      this.openMushafPageView(pageNum);
    } else {
      this.showToast("Masukkan nomor halaman valid antara 1 - 604");
    }
  },

  populateJuzQuickLinks() {
    const wrap = document.getElementById('juzQuickLinks');
    if (!wrap) return;

    wrap.innerHTML = this.juzList.map(j => `
      <button onclick="QuranApp.closeAllModals(); QuranApp.openMushafPageView(${j.startPage});" style="padding: 7px 4px; background: rgba(212, 175, 55, 0.12); border: 1px solid rgba(212, 175, 55, 0.35); border-radius: 8px; color: var(--gold-light); font-size: 11px; font-weight: 700; cursor: pointer; text-align: center;">
        Juz ${j.number}
        <div style="font-size: 9px; color: var(--text-dim); font-weight: 400;">Hal. ${j.startPage}</div>
      </button>
    `).join('');
  },

  // ========================================================================
  // VERSE BY VERSE MODE
  // ========================================================================
  openSurahVerseView(surahNum) {
    document.querySelector('.mobile-device').classList.remove('reading-book');
    const header = document.querySelector('.app-header');
    if (header) header.style.display = 'flex';
    document.getElementById('headerBackBtn').style.display = 'flex';

    this.activeSurah = this.surahs.find(s => s.number === surahNum) || this.surahs[0];
    const ayahs = this.getAyahs(surahNum);

    this.lastRead = {
      surahNumber: this.activeSurah.number,
      surahName: this.activeSurah.nameLatin,
      ayahNumber: 1,
      pageNumber: this.activeSurah.startPage,
      juzNumber: this.activeSurah.startJuz
    };
    try { localStorage.setItem('quran_last_read', JSON.stringify(this.lastRead)); } catch (e) {}

    const container = document.getElementById('appContent');
    container.innerHTML = `
      <div class="verse-header-card">
        <div class="arabic-title">${this.activeSurah.nameArabic}</div>
        <h2>Surah ${this.activeSurah.nameLatin}</h2>
        <p style="color: var(--gold-accent); font-size: 12px; margin-top: 2px;">
          ${this.activeSurah.type.toUpperCase()} • ${this.activeSurah.totalAyah} AYAT • JUZ ${this.activeSurah.startJuz}
        </p>
        <div style="display: flex; gap: 8px; justify-content: center; margin-top: 14px;">
          <button class="btn-resume" onclick="QuranApp.playFullSurah(${surahNum})">
            <i class="ri-play-fill"></i> Putar Audio
          </button>
          <button class="btn-resume" style="background: rgba(212, 175, 55, 0.18); color: var(--gold-light); border: 1px solid var(--gold-primary);" onclick="QuranApp.openMushafPageView(${this.activeSurah.startPage})">
            <i class="ri-book-open-fill"></i> Buka Mushaf Kitab
          </button>
        </div>
        ${surahNum !== 9 ? '<div class="bismillah-box" style="margin-top: 16px;">بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ</div>' : ''}
      </div>

      <div class="ayah-list">
        ${ayahs.map(a => `
          <div class="ayah-card" id="ayah-card-${a.ayah}" onclick="QuranApp.openAyahAction(${a.surah}, ${a.ayah})">
            <div class="ayah-card-top">
              <div class="ayah-number-badge">${a.ayah}</div>
              <div class="ayah-card-actions" onclick="event.stopPropagation()">
                <i class="ri-play-circle-line" onclick="QuranApp.playAyahAudio(${a.surah}, ${a.ayah})" title="Putar"></i>
                <i class="ri-book-read-line" onclick="QuranApp.openTafsirModal(${a.surah}, ${a.ayah})" title="Tafsir"></i>
                <i class="ri-bookmark-line" onclick="QuranApp.toggleBookmark(${a.surah}, ${a.ayah})" title="Bookmark"></i>
              </div>
            </div>
            <div class="ayah-arabic-text" style="font-size: ${this.arabicFontSize}px;">
              ${a.arabic} ۝${this.toArabicDigits(a.ayah)}
            </div>
            ${this.showTransliteration ? `<div class="ayah-transliteration" style="font-size: ${this.translationFontSize - 1}px;">${a.latin}</div>` : ''}
            ${this.showTranslation ? `<div class="ayah-translation" style="font-size: ${this.translationFontSize}px;">${a.idText}</div>` : ''}
          </div>
        `).join('')}
      </div>
    `;
  },

  getAyahs(surahNum) {
    if (this.surahAyahsData[surahNum]) return this.surahAyahsData[surahNum];
    const surah = this.surahs.find(s => s.number === surahNum) || this.surahs[0];
    return Array.from({ length: Math.min(surah.totalAyah, 8) }, (_, i) => ({
      surah: surahNum,
      ayah: i + 1,
      arabic: `بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ... آيَةُ ${i + 1}`,
      latin: `Ayat ke-${i + 1} dari Surah ${surah.nameLatin}`,
      idText: `Terjemahan ayat ke-${i + 1} dari Surah ${surah.nameLatin} (${surah.translationId}).`,
      page: surah.startPage,
      juz: surah.startJuz
    }));
  },

  // ========================================================================
  // AUDIO MUROTTAL PLAYER
  // ========================================================================
  playAyahAudio(surahNum, ayahNum) {
    const sStr = surahNum.toString().padStart(3, '0');
    const aStr = ayahNum.toString().padStart(3, '0');
    const audioUrl = `https://everyayah.com/data/${this.currentQari.folder}/${sStr}${aStr}.mp3`;

    this.currentPlayingAyah = { surah: surahNum, ayah: ayahNum };
    this.audioPlayer.src = audioUrl;
    this.audioPlayer.play().catch(e => {
      this.showToast("Gagal memutar audio: periksa koneksi internet.");
    });

    const mini = document.getElementById('miniPlayer');
    if (mini) mini.style.display = 'flex';

    const surah = this.surahs.find(s => s.number === surahNum) || { nameLatin: `Surah ${surahNum}` };
    const title = document.getElementById('miniPlayerTitle');
    if (title) title.innerText = `${surah.nameLatin} : Ayat ${ayahNum}`;
    const qari = document.getElementById('miniPlayerQari');
    if (qari) qari.innerText = this.currentQari.name;

    const playBtn = document.getElementById('miniPlayBtn');
    if (playBtn) playBtn.innerHTML = `<i class="ri-pause-circle-fill"></i>`;
  },

  playFullSurah(surahNum) {
    const ayahs = this.getAyahs(surahNum);
    this.currentPlaylist = ayahs;
    this.currentPlaylistIndex = 0;
    if (ayahs.length > 0) {
      this.playAyahAudio(ayahs[0].surah, ayahs[0].ayah);
      this.showToast(`Memutar murottal Surah ${this.activeSurah.nameLatin}`);
    }
  },

  togglePlayPause() {
    const btn = document.getElementById('miniPlayBtn');
    if (this.audioPlayer.paused) {
      this.audioPlayer.play();
      if (btn) btn.innerHTML = `<i class="ri-pause-circle-fill"></i>`;
    } else {
      this.audioPlayer.pause();
      if (btn) btn.innerHTML = `<i class="ri-play-circle-fill"></i>`;
    }
  },

  prevAudio() {
    if (this.currentPlaylist.length > 0 && this.currentPlaylistIndex > 0) {
      this.currentPlaylistIndex--;
      const a = this.currentPlaylist[this.currentPlaylistIndex];
      this.playAyahAudio(a.surah, a.ayah);
    }
  },

  nextAudio() {
    if (this.currentPlaylist.length > 0 && this.currentPlaylistIndex < this.currentPlaylist.length - 1) {
      this.currentPlaylistIndex++;
      const a = this.currentPlaylist[this.currentPlaylistIndex];
      this.playAyahAudio(a.surah, a.ayah);
    } else {
      this.stopAudio();
    }
  },

  stopAudio() {
    this.audioPlayer.pause();
    this.audioPlayer.currentTime = 0;
    this.currentPlayingAyah = null;
    const mini = document.getElementById('miniPlayer');
    if (mini) mini.style.display = 'none';
  },

  setupAudioListeners() {
    this.audioPlayer.addEventListener('ended', () => {
      this.nextAudio();
    });
  },

  // ========================================================================
  // AYAH ACTION MODAL & INTERACTIONS
  // ========================================================================
  openAyahAction(surahNum, ayahNum) {
    const ayahs = this.getAyahs(surahNum);
    const ayah = ayahs.find(a => a.ayah === ayahNum);
    const surah = this.surahs.find(s => s.number === surahNum);
    if (!ayah || !surah) return;

    this.selectedAyahForAction = { surah, ayah };
    document.getElementById('ayahActionTitle').innerText = `QS. ${surah.nameLatin}: ${ayahNum}`;
    document.getElementById('ayahActionArabic').innerText = ayah.arabic;
    this.openModal('ayahActionModal');
  },

  openTafsirModal(surahNum, ayahNum) {
    this.closeAllModals();
    const surah = this.surahs.find(s => s.number === surahNum);
    document.getElementById('tafsirModalTitle').innerText = `Tafsir QS. ${surah.nameLatin}: ${ayahNum}`;
    document.getElementById('tafsirContentText').innerText =
      `Tafsir ringkas Kementerian Agama RI untuk QS. ${surah.nameLatin} ayat ${ayahNum}: ` +
      `Ayat ini memberikan petunjuk agung, ketakwaan, serta keberkahan bagi hamba yang senantiasa membaca, menghayati, dan mengamalkan kalam Ilahi dalam kehidupan sehari-hari.`;
    this.openModal('tafsirModal');
  },

  toggleBookmark(surahNum, ayahNum) {
    const surah = this.surahs.find(s => s.number === surahNum);
    this.bookmarks.push({
      id: `bm_${surahNum}_${ayahNum}`,
      surahNumber: surahNum,
      surahName: surah.nameLatin,
      ayahNumber: ayahNum,
      createdAt: new Date().toISOString()
    });
    try { localStorage.setItem('quran_bookmarks', JSON.stringify(this.bookmarks)); } catch (e) {}
    this.showToast(`QS. ${surah.nameLatin}: ${ayahNum} disimpan ke Bookmark`);
    this.closeAllModals();
  },

  saveAsLastRead() {
    if (!this.selectedAyahForAction) return;
    const { surah, ayah } = this.selectedAyahForAction;
    this.lastRead = {
      surahNumber: surah.number,
      surahName: surah.nameLatin,
      ayahNumber: ayah.ayah,
      pageNumber: ayah.page || surah.startPage,
      juzNumber: ayah.juz || surah.startJuz
    };
    try { localStorage.setItem('quran_last_read', JSON.stringify(this.lastRead)); } catch (e) {}
    this.updateLastReadUI();
    this.showToast(`QS. ${surah.nameLatin}: ${ayah.ayah} ditandai Terakhir Dibaca`);
    this.closeAllModals();
  },

  copyAyahText() {
    if (!this.selectedAyahForAction) return;
    const { surah, ayah } = this.selectedAyahForAction;
    const text = `${ayah.arabic}\n\n"${ayah.idText}"\n(QS. ${surah.nameLatin}: ${ayah.ayah})`;
    navigator.clipboard.writeText(text);
    this.showToast("Teks ayat berhasil disalin");
    this.closeAllModals();
  },

  openSurahModeModal(surahNum) {
    const surah = this.surahs.find(s => s.number === surahNum);
    document.getElementById('modeModalTitle').innerText = `Pilih Mode: Surah ${surah.nameLatin}`;
    document.getElementById('btnModeVerse').onclick = () => {
      this.closeAllModals();
      this.openSurahVerseView(surahNum);
    };
    document.getElementById('btnModePage').onclick = () => {
      this.closeAllModals();
      this.openMushafPageView(surah.startPage);
    };
    this.openModal('readingModeModal');
  },

  openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (!modal) return;
    modal.removeAttribute('aria-hidden');
    modal.removeAttribute('inert');
    modal.classList.add('active');
  },

  closeAllModals() {
    document.querySelectorAll('.modal-overlay').forEach(m => {
      m.classList.remove('active');
      m.setAttribute('aria-hidden', 'true');
      m.setAttribute('inert', '');
    });
  },

  showToast(msg) {
    const toast = document.getElementById('toast');
    if (!toast) return;
    toast.innerText = msg;
    toast.style.opacity = '1';
    toast.style.transform = 'translateY(0)';
    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(20px)';
    }, 2400);
  },

  updateLastReadUI() {
    const title = document.getElementById('lastReadTitle');
    const ayah = document.getElementById('lastReadAyah');
    if (title) title.innerText = `Surah ${this.lastRead.surahName}`;
    if (ayah) ayah.innerText = `Ayat No. ${this.lastRead.ayahNumber} • Juz ${this.lastRead.juzNumber}`;
  },

  setupEventListeners() {
    // Back to home button
    const backBtn = document.getElementById('headerBackBtn');
    if (backBtn) {
      backBtn.addEventListener('click', () => {
        this.renderHomeView();
      });
    }
  }
};

window.addEventListener('DOMContentLoaded', () => QuranApp.init());
