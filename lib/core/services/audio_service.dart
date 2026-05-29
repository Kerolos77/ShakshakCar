import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playNotificationSound() async {
    try {
      await _player.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
