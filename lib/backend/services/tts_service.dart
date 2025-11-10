import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

/// Global TTS Service for managing Text-to-Speech functionality
/// Handles global voice speed settings across the app
class TtsService extends GetxController {
  static TtsService get to => Get.find();

  final FlutterTts _flutterTts = FlutterTts();
  
  // Global voice speed (0.5, 0.8, or 1.0)
  final RxDouble _globalSpeed = 1.0.obs;
  
  // Whether TTS is currently playing
  final RxBool _isPlaying = false.obs;
  
  // Current playing text
  final RxString? _currentPlayingText = RxString('');

  double get globalSpeed => _globalSpeed.value;
  bool get isPlaying => _isPlaying.value;
  String? get currentPlayingText => _currentPlayingText?.value;

  @override
  void onInit() {
    super.onInit();
    _initTTS();
  }

  /// Initialize TTS with default settings
  Future<void> _initTTS() async {
    await _flutterTts.setSpeechRate(_globalSpeed.value);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setLanguage('de-DE');

    _flutterTts.setCompletionHandler(() {
      _isPlaying.value = false;
      _currentPlayingText?.value = '';
    });

    _flutterTts.setErrorHandler((msg) {
      _isPlaying.value = false;
      _currentPlayingText?.value = '';
      print("TTS Error: $msg");
    });
  }

  /// Set global voice speed (0.5, 0.8, or 1.0)
  Future<void> setGlobalSpeed(double speed) async {
    if (speed != 0.5 && speed != 0.8 && speed != 1.0) {
      throw ArgumentError('Speed must be 0.5, 0.8, or 1.0');
    }
    _globalSpeed.value = speed;
    await _flutterTts.setSpeechRate(speed);
  }

  /// Speak text with current global speed
  /// [text] - The text to speak
  /// [languageCode] - Language code (default: 'de-DE')
  /// [useGlobalSpeed] - Whether to use global speed (default: true)
  ///                    Set to false for Learn section which has its own speed control
  Future<void> speak(
    String text, {
    String languageCode = 'de-DE',
    bool useGlobalSpeed = true,
  }) async {
    // If already playing the same text, stop it
    if (_isPlaying.value && _currentPlayingText?.value == text) {
      await stop();
      return;
    }

    _isPlaying.value = true;
    _currentPlayingText?.value = text;

    try {
      // Set speed based on useGlobalSpeed flag
      if (useGlobalSpeed) {
        await _flutterTts.setSpeechRate(_globalSpeed.value);
      }
      
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.speak(text);
    } catch (e) {
      _isPlaying.value = false;
      _currentPlayingText?.value = '';
      print("TTS Error: $e");
    }
  }

  /// Stop current TTS playback
  Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying.value = false;
    _currentPlayingText?.value = '';
  }

  /// Check if specific text is currently playing
  bool isTextPlaying(String text) {
    return _isPlaying.value && _currentPlayingText?.value == text;
  }
}



