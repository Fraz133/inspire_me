import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class TtsService extends GetxService {
  final FlutterTts _flutterTts = FlutterTts();
  final isSpeaking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        isSpeaking.value = true;
        debugPrint("TTS: Started speaking");
      });

      _flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
        debugPrint("TTS: Completed speaking");
      });

      _flutterTts.setCancelHandler(() {
        isSpeaking.value = false;
        debugPrint("TTS: Cancelled speaking");
      });

      _flutterTts.setErrorHandler((msg) {
        isSpeaking.value = false;
        debugPrint("TTS: Error - $msg");
      });
    } catch (e) {
      debugPrint("TTS: Init Error - $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      if (isSpeaking.value) {
        await stop();
      } else {
        if (text.isNotEmpty) {
          await _flutterTts.speak(text);
        }
      }
    } catch (e) {
      debugPrint("TTS: Speak Error - $e");
      isSpeaking.value = false;
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      isSpeaking.value = false;
      debugPrint("TTS: Stopped speaking manually");
    } catch (e) {
      debugPrint("TTS: Stop Error - $e");
    }
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
