
import 'dart:async';
import 'dart:math';

import 'package:flutter_soloud/flutter_soloud.dart';

class BinauralAudioService {
  BinauralAudioService._();

  static final BinauralAudioService instance =
  BinauralAudioService._();

  final SoLoud _soloud = SoLoud.instance;

  AudioSource? _leftSource;
  AudioSource? _rightSource;

  SoundHandle? _leftHandle;
  SoundHandle? _rightHandle;

  bool _initialized = false;
  bool _playing = false;

  bool get isPlaying => _playing;

  Timer? _oscillationTimer;
  double _oscillationPhase = 0;

  Future<void> initialize() async {
    if (_initialized) return;

    await _soloud.init(
      sampleRate: 44100,
      channels: Channels.stereo,
    );

    _leftSource = await _soloud.loadWaveform(
      WaveForm.sin,
      false,
      1,
      0,
    );

    _rightSource = await _soloud.loadWaveform(
      WaveForm.sin,
      false,
      1,
      0,
    );

    _soloud.setWaveformFreq(_leftSource!, 200);
    _soloud.setWaveformFreq(_rightSource!, 210);

    _initialized = true;
  }

  Future<void> play({
    double leftFrequency = 200,
    double beatFrequency = 10,
    double volume = 0.15,
  }) async {
    await initialize();

    await stop();

    _soloud.setWaveformFreq(
      _leftSource!,
      leftFrequency,
    );

    _soloud.setWaveformFreq(
      _rightSource!,
      leftFrequency + beatFrequency,
    );

    _leftHandle = _soloud.play(
      _leftSource!,
      volume: volume,
      pan: -1,
      looping: true,
    );

    _rightHandle = _soloud.play(
      _rightSource!,
      volume: volume,
      pan: 1,
      looping: true,
    );

    _playing = true;
  }

  void setFrequencies({
    required double leftFrequency,
    required double beatFrequency,
  }) {
    if (!_initialized) {
      throw StateError('Inizializza prima il motore audio.');
    }

    if (leftFrequency <= 0 ||
        beatFrequency <= 0 ||
        leftFrequency + beatFrequency >= 20000) {
      throw ArgumentError('Frequenze non valide.');
    }

    _soloud.setWaveformFreq(
      _leftSource!,
      leftFrequency,
    );

    _soloud.setWaveformFreq(
      _rightSource!,
      leftFrequency + beatFrequency,
    );
  }

  void setVolume(double volume) {
    final normalized = volume.clamp(0.0, 1.0);

    if (_leftHandle != null) {
      _soloud.setVolume(_leftHandle!, normalized);
    }

    if (_rightHandle != null) {
      _soloud.setVolume(_rightHandle!, normalized);
    }
  }

  void pause() {
    if (_leftHandle != null) {
      _soloud.setPause(_leftHandle!, true);
    }

    if (_rightHandle != null) {
      _soloud.setPause(_rightHandle!, true);
    }

    _playing = false;
  }

  void resume() {
    if (_leftHandle != null) {
      _soloud.setPause(_leftHandle!, false);
    }

    if (_rightHandle != null) {
      _soloud.setPause(_rightHandle!, false);
    }

    _playing = true;
  }

  Future<void> stop() async {
    final left = _leftHandle;
    final right = _rightHandle;

    _leftHandle = null;
    _rightHandle = null;
    _playing = false;

    if (left != null) {
      await _soloud.stop(left);
    }

    if (right != null) {
      await _soloud.stop(right);
    }
  }


  void startFrequencyOscillation({
    double centerFrequency = 320,
    double beatFrequency = 4,
    double speedHz = 0.1,
  }) {
    if (!_initialized || !_playing) {
      throw StateError('Avvia prima la riproduzione audio.');
    }

    if (centerFrequency <= 0 ||
        beatFrequency <= 0 ||
        speedHz <= 0 ||
        centerFrequency + 7 >= 20000) {
      throw ArgumentError('Parametri non validi.');
    }

    // Incremento massimo in base al battimento iniziale.
    final double maxIncrease = beatFrequency <= 2 ? 2 : 3;

    // Limita il battimento massimo a 7 Hz.
    final double maxBeatFrequency =
    min(beatFrequency + maxIncrease, 7);

    _oscillationTimer?.cancel();
    _oscillationPhase = 0;

    _oscillationTimer = Timer.periodic(
      const Duration(milliseconds: 50),
          (_) {
        _oscillationPhase +=
            2 * pi * speedHz * 0.05;

        // Oscillazione graduale tra il valore iniziale
        // e il valore massimo consentito.
        final double progress =
            (1 - cos(_oscillationPhase)) / 2;

        final double currentBeatFrequency =
            beatFrequency +
                (maxBeatFrequency - beatFrequency) * progress;

        setFrequencies(
          leftFrequency: centerFrequency,
          beatFrequency: currentBeatFrequency,
        );
      },
    );
  }

  void stopFrequencyOscillation() {
    _oscillationTimer?.cancel();
    _oscillationTimer = null;
  }


  Future<void> dispose() async {
    await stop();

    if (_initialized) {
      if (_leftSource != null) {
        await _soloud.disposeSource(_leftSource!);
      }

      if (_rightSource != null) {
        await _soloud.disposeSource(_rightSource!);
      }

      _leftSource = null;
      _rightSource = null;

      _initialized = false;
    }
  }
}
