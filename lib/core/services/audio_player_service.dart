import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/datasources/quran_dataset.dart';
import '../../data/models/ayah_model.dart';
import '../../data/models/qari_model.dart';
import '../../data/repositories/quran_repository.dart';

class AudioPlayerService extends ChangeNotifier {
  final bool _enablePlatformAudio;
  AudioPlayer? _audioPlayer;
  final QuranRepository _repository = QuranRepository();

  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<AudioInterruptionEvent>? _interruptionSub;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isDisposed = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _errorMessage;

  AyahModel? _currentAyah;
  List<AyahModel> _playlist = [];
  int _currentIndex = 0;

  QariModel _currentQari = QuranDataset.allQaris[0];
  double _speed = 1.0;
  bool _repeatAyah = false;

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  String? get errorMessage => _errorMessage;
  AyahModel? get currentAyah => _currentAyah;
  QariModel get currentQari => _currentQari;
  double get speed => _speed;
  bool get repeatAyah => _repeatAyah;
  bool get hasNext => _playlist.isNotEmpty && _currentIndex < _playlist.length - 1;
  bool get hasPrevious => _playlist.isNotEmpty && _currentIndex > 0;

  AudioPlayerService({bool enablePlatformAudio = true})
      : _enablePlatformAudio = enablePlatformAudio {
    if (_enablePlatformAudio) {
      _audioPlayer = AudioPlayer();
      _initAudioSession();
      _initAudioListeners();
    }
  }

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      _interruptionSub = session.interruptionEventStream.listen((event) {
        if (event.begin && _isPlaying) {
          _audioPlayer?.pause();
        }
      });
    } catch (e) {
      debugPrint("AudioSession init note: $e");
    }
  }

  void _initAudioListeners() {
    final player = _audioPlayer;
    if (player == null) return;

    _playerStateSub = player.playerStateStream.listen((playerState) {
      if (_isDisposed) return;
      _isPlaying = playerState.playing;
      _isLoading = playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering;

      if (playerState.processingState == ProcessingState.completed) {
        _onAudioCompleted();
      }
      notifyListeners();
    });

    _positionSub = player.positionStream.listen((pos) {
      if (_isDisposed) return;
      _position = pos;
      notifyListeners();
    });

    _durationSub = player.durationStream.listen((dur) {
      if (_isDisposed) return;
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setQari(QariModel qari) {
    _currentQari = qari;
    _errorMessage = null;
    notifyListeners();
    if (_currentAyah != null) {
      playAyah(_currentAyah!, playlist: _playlist.isNotEmpty ? _playlist : null);
    }
  }

  Future<void> setSpeed(double newSpeed) async {
    _speed = newSpeed;
    notifyListeners();
    try {
      await _audioPlayer?.setSpeed(newSpeed);
    } catch (e) {
      debugPrint("Audio setSpeed Error: $e");
    }
  }

  Future<void> cycleSpeed() async {
    const speeds = [1.0, 1.25, 1.5, 0.75];
    final currentIdx = speeds.indexWhere((s) => (s - _speed).abs() < 0.05);
    final next = speeds[(currentIdx + 1) % speeds.length];
    await setSpeed(next);
  }

  void toggleRepeatAyah() {
    _repeatAyah = !_repeatAyah;
    notifyListeners();
  }

  Future<void> playAyah(AyahModel ayah, {List<AyahModel>? playlist}) async {
    try {
      _currentAyah = ayah;
      _errorMessage = null;

      if (playlist != null && playlist.isNotEmpty) {
        _playlist = playlist;
      } else {
        _playlist = _repository.getAyahsForSurah(ayah.surahNumber);
      }

      _currentIndex = _playlist.indexWhere(
        (a) => a.surahNumber == ayah.surahNumber && a.ayahNumber == ayah.ayahNumber,
      );
      if (_currentIndex == -1) _currentIndex = 0;

      final surahStr = ayah.surahNumber.toString().padLeft(3, '0');
      final ayahStr = ayah.ayahNumber.toString().padLeft(3, '0');
      final audioUrl =
          "https://everyayah.com/data/${_currentQari.subfolder}/$surahStr$ayahStr.mp3";

      if (_audioPlayer == null) {
        _isLoading = false;
        _isPlaying = true;
        notifyListeners();
        return;
      }

      _isLoading = true;
      _position = Duration.zero;
      notifyListeners();

      await _audioPlayer!.setUrl(audioUrl);
      await _audioPlayer!.setSpeed(_speed);
      await _audioPlayer!.play();
    } catch (e) {
      debugPrint("Audio Play Error: $e");
      _isLoading = false;
      _isPlaying = false;
      _errorMessage = "Gagal memutar audio. Periksa koneksi internet Anda.";
      notifyListeners();
    }
  }

  Future<void> retryCurrent() async {
    if (_currentAyah != null) {
      await playAyah(_currentAyah!, playlist: _playlist.isNotEmpty ? _playlist : null);
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer?.pause();
        if (_audioPlayer == null) {
          _isPlaying = false;
          notifyListeners();
        }
      } else if (_currentAyah != null) {
        if (_errorMessage != null) {
          await retryCurrent();
        } else {
          await _audioPlayer?.play();
          if (_audioPlayer == null) {
            _isPlaying = true;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      _errorMessage = "Gagal memutar audio.";
      notifyListeners();
    }
  }

  Future<void> nextAyah() async {
    if (_playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
      _currentIndex++;
      await playAyah(_playlist[_currentIndex], playlist: _playlist);
    }
  }

  Future<void> previousAyah() async {
    if (_playlist.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      await playAyah(_playlist[_currentIndex], playlist: _playlist);
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer?.seek(position);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _audioPlayer?.stop();
    } catch (_) {}
    _isPlaying = false;
    _isLoading = false;
    _currentAyah = null;
    _errorMessage = null;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();
  }

  void _onAudioCompleted() {
    if (_repeatAyah && _currentAyah != null) {
      _audioPlayer?.seek(Duration.zero).then((_) => _audioPlayer?.play()).catchError((_) {
        if (_currentAyah != null) playAyah(_currentAyah!, playlist: _playlist);
      });
    } else if (_playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
      nextAyah();
    } else {
      _isPlaying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _interruptionSub?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }
}
