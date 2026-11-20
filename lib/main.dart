import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_themes.dart';
import 'core/services/audio_player_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/storage_service.dart';
import 'data/repositories/quran_repository.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Preferred Orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Local Offline Storage & Full Offline Quran Dataset
  final storageService = StorageService();
  await Future.wait([
    storageService.init(),
    QuranRepository().init(),
  ]);

  // Initialize Firebase Service (no-op gracefully when Firebase isn't configured)
  final firebaseService = FirebaseService();
  firebaseService.signInAnonymously();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<AudioPlayerService>(
          create: (_) => AudioPlayerService(),
        ),
        ChangeNotifierProvider<FirebaseService>.value(value: firebaseService),
      ],
      child: const QuranLuxuryApp(),
    ),
  );
}

class QuranLuxuryApp extends StatelessWidget {
  const QuranLuxuryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storage, child) {
        final ThemeData selectedTheme;
        final SystemUiOverlayStyle overlayStyle;

        switch (storage.themeMode) {
          case ThemeModeType.lightMushaf:
            selectedTheme = AppThemes.lightTheme;
            overlayStyle = const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            );
            break;
          case ThemeModeType.sepia:
            selectedTheme = AppThemes.sepiaTheme;
            overlayStyle = const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Color(0xFFF7EFE0),
              systemNavigationBarIconBrightness: Brightness.dark,
            );
            break;
          case ThemeModeType.darkGold:
            selectedTheme = AppThemes.darkTheme;
            overlayStyle = const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: AppColors.darkSurface,
              systemNavigationBarIconBrightness: Brightness.light,
            );
            break;
        }

        SystemChrome.setSystemUIOverlayStyle(overlayStyle);

        return MaterialApp(
          title: "Al-Qur'an Al-Karim",
          debugShowCheckedModeBanner: false,
          theme: selectedTheme,
          home: const ResponsiveMobileWrapper(
            child: HomeScreen(),
          ),
        );
      },
    );
  }
}

/// Keeps desktop web preview framed like a mobile phone while letting native Android use full screen
class ResponsiveMobileWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveMobileWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 540) {
          return Scaffold(
            backgroundColor: const Color(0xFF0B0E11),
            body: Center(
              child: Container(
                width: 390,
                decoration: BoxDecoration(
                  color: AppColors.darkBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldPrimary.withValues(alpha: 0.18),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.goldPrimary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
