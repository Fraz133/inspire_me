import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class SoundService extends GetxService {
  final AudioPlayer _player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  final isSoundEnabled = true.obs;

  void toggleSound() {
    isSoundEnabled.value = !isSoundEnabled.value;
  }

  Future<void> _init() async {
    // Sound initialization is completed on play to prevent early startup asset loading errors
  }

  Future<void> playChime() async {
    if (!isSoundEnabled.value) {
      debugPrint("SoundService: Sound is disabled by user setting.");
      return;
    }
    try {
      debugPrint("SoundService: Playing chime...");
      // Stop any current playback, reset and play fresh to avoid state conflicts
      await _player.stop();
      await _player.setVolume(1.0);
      await _player.play(AssetSource('sounds/mixkit-slide-click-1130.wav'));
      debugPrint("SoundService: Chime play command sent successfully.");
    } catch (e) {
      debugPrint("SoundService: Error playing chime: $e");
    }
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
