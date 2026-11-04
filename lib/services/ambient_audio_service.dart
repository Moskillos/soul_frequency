import 'package:just_audio/just_audio.dart';

class AmbientAudioService {
  AmbientAudioService._();

  static final AmbientAudioService instance =
  AmbientAudioService._();

  final AudioPlayer _player = AudioPlayer();

  bool get isPlaying => _player.playing;

  Future<void> play(String assetPath) async {
    try {
      print('Caricamento audio: $assetPath');

      await _player.setAsset(assetPath);
      await _player.setLoopMode(LoopMode.one);
      await _player.play();
    } on PlayerException catch (e) {
      print('Errore del player: ${e.code}');
      print('Dettaglio: ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      print('Errore caricamento MP3: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> pause() async {
  await _player.pause();
  }

  Future<void> resume() async {
  await _player.play();
  }

  Future<void> stop() async {
  await _player.stop();
  }

  Future<void> setVolume(double volume) async {
  await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> dispose() async {
  await _player.dispose();
  }
}