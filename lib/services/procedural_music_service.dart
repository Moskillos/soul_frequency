
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_soloud/flutter_soloud.dart';

class ProceduralMusicService {
  ProceduralMusicService._();

  static final ProceduralMusicService instance =
  ProceduralMusicService._();

  final SoLoud _soloud = SoLoud.instance;

  double _referenceFrequency = 432.0;
  double _volume = 0.35;

  bool _isPlaying = false;
  bool _isPaused = false;
  bool _initialized = false;

  int _generation = 0;

  final Map<String, AudioSource> _sources = {};
  final Set<SoundHandle> _handles = {};
  final Map<SoundHandle, double> _voiceLevels = {};

  bool get isPlaying => _isPlaying && !_isPaused;
  bool get isPaused => _isPaused;
  double get volume => _volume;

  // --------------------------------------------------
  // FREQUENZE
  // --------------------------------------------------

  double noteFrequency(int midiNote) {
    return _referenceFrequency *
        math.pow(2, (midiNote - 69) / 12).toDouble();
  }

  // --------------------------------------------------
  // INIZIALIZZAZIONE
  // --------------------------------------------------

  Future<void> initialize() async {
    if (_initialized) return;

    // Il motore può essere già stato inizializzato
    // dal BinauralAudioService.
    if (!_soloud.isInitialized) {
      await _soloud.init(
        sampleRate: 44100,
        bufferSize: 2048,
        channels: Channels.stereo,
      );
    }

    _initialized = true;
  }

  // --------------------------------------------------
  // CARICAMENTO SORGENTI
  // --------------------------------------------------

  Future<AudioSource> _getSource({
    required WaveForm waveform,
    required double frequency,
  }) async {
    final key =
        '${waveform.name}_${frequency.toStringAsFixed(3)}';

    final cached = _sources[key];

    if (cached != null) return cached;

    final source = await _soloud.loadWaveform(
      waveform,
      false,
      1.0,
      0.0,
    );

    _soloud.setWaveformFreq(source, frequency);

    _sources[key] = source;

    return source;
  }

  // --------------------------------------------------
  // RIPRODUZIONE DI UNA NOTA
  // --------------------------------------------------

  Future<void> _playTone({
    required double frequency,
    required WaveForm waveform,
    required double level,
    required Duration duration,
    Duration attack = const Duration(milliseconds: 500),
    Duration release = const Duration(milliseconds: 1500),
    required int generation,
  }) async {
    if (!_isPlaying || generation != _generation) return;

    final source = await _getSource(
      waveform: waveform,
      frequency: frequency,
    );

    if (!_isPlaying || generation != _generation) return;

    final handle = _soloud.play(
      source,
      volume: 0.0,
      looping: true,
    );

    _handles.add(handle);
    _voiceLevels[handle] = level;

    final targetVolume = (_volume * level).clamp(0.0, 1.0);

    _soloud.fadeVolume(
      handle,
      targetVolume,
      attack,
    );

    final safeRelease =
    release < duration ? release : duration;

    final waitBeforeRelease = duration - safeRelease;

    await _wait(waitBeforeRelease, generation);

    if (!_isPlaying ||
        generation != _generation ||
        !_handles.contains(handle)) {
      return;
    }

    _soloud.fadeVolume(
      handle,
      0.0,
      safeRelease,
    );

    await _wait(safeRelease, generation);

    if (_handles.remove(handle)) {
      _voiceLevels.remove(handle);

      if (_soloud.getIsValidVoiceHandle(handle)) {
        await _soloud.stop(handle);
      }
    }
  }

  Future<void> _playNote({
    required int midiNote,
    required WaveForm waveform,
    required double level,
    required Duration duration,
    Duration attack = const Duration(milliseconds: 500),
    Duration release = const Duration(milliseconds: 1500),
    required int generation,
  }) async {
    await _playTone(
      frequency: noteFrequency(midiNote),
      waveform: waveform,
      level: level,
      duration: duration,
      attack: attack,
      release: release,
      generation: generation,
    );
  }

  // --------------------------------------------------
  // ATTESA CHE RISPETTA LA PAUSA
  // --------------------------------------------------

  Future<void> _wait(
      Duration duration,
      int generation,
      ) async {
    var remaining = duration;

    while (remaining > Duration.zero &&
        _isPlaying &&
        generation == _generation) {
      await Future.delayed(
        const Duration(milliseconds: 50),
      );

      if (!_isPaused) {
        remaining -= const Duration(milliseconds: 50);
      }
    }
  }

  // --------------------------------------------------
  // AVVIO MUSICA
  // --------------------------------------------------

  Future<void> start(double frequency) async {
    if (frequency < 100 || frequency > 1000) {
      throw ArgumentError('Frequenza non valida.');
    }

    if (_isPlaying) {
      if (_referenceFrequency != frequency) {
        await stop();
      } else {
        return;
      }
    }

    await initialize();

    _referenceFrequency = frequency;

    _isPlaying = true;
    _isPaused = false;

    final generation = ++_generation;

    unawaited(_runHarmony(generation));
    unawaited(_runMelody(generation));
    unawaited(_runBells(generation));
  }

  // --------------------------------------------------
  // ARMONIA / PAD
  // --------------------------------------------------

  Future<void> _runHarmony(int generation) async {
    const chords = <List<int>>[
      [48, 55, 59, 64],
      [45, 52, 55, 60],
      [41, 48, 52, 57],
      [43, 50, 55, 57],
    ];

    var index = 0;

    while (_isPlaying && generation == _generation) {
      final chord = chords[index % chords.length];

      for (final note in chord) {
        unawaited(
          _playNote(
            midiNote: note,
            waveform: WaveForm.sin,
            level: 0.18,
            duration: const Duration(seconds: 12),
            attack: const Duration(seconds: 4),
            release: const Duration(seconds: 4),
            generation: generation,
          ),
        );
      }

      index++;

      await _wait(
        const Duration(seconds: 8),
        generation,
      );
    }
  }

  // --------------------------------------------------
  // MELODIA PRINCIPALE
  // --------------------------------------------------

  Future<void> _runMelody(int generation) async {
    const melody = <int?>[
      72, null, 76, 79,
      null, 76, 74, null,
      72, 67, null, 71,
      72, null, 76, null,
    ];

    var index = 0;

    while (_isPlaying && generation == _generation) {
      final note = melody[index % melody.length];

      if (note != null) {
        unawaited(
          _playNote(
            midiNote: note,
            waveform: WaveForm.triangle,
            level: 0.20,
            duration: const Duration(milliseconds: 3000),
            attack: const Duration(milliseconds: 700),
            release: const Duration(milliseconds: 2000),
            generation: generation,
          ),
        );
      }

      index++;

      await _wait(
        const Duration(milliseconds: 1800),
        generation,
      );
    }
  }

  // --------------------------------------------------
  // CAMPANE ARMONICHE
  // --------------------------------------------------

  Future<void> _playBell(
      int midiNote,
      int generation,
      ) async {
    final fundamental = noteFrequency(midiNote);

    final partials = [
      (frequency: fundamental, amplitude: 1.0),
      (frequency: fundamental * 2.71, amplitude: 0.30),
      (frequency: fundamental * 4.13, amplitude: 0.12),
    ];

    for (final partial in partials) {
      unawaited(
        _playTone(
          frequency: partial.frequency,
          waveform: WaveForm.sin,
          level: 0.13 * partial.amplitude,
          duration: const Duration(seconds: 9),
          attack: const Duration(milliseconds: 80),
          release: const Duration(seconds: 7),
          generation: generation,
        ),
      );
    }
  }

  Future<void> _runBells(int generation) async {
    const pattern = [
      84, 79, 76, 72,
      76, 79, 86, 79,
    ];

    var index = 0;

    while (_isPlaying && generation == _generation) {
      await _wait(
        const Duration(seconds: 5),
        generation,
      );

      if (!_isPlaying || generation != _generation) break;

      unawaited(
        _playBell(
          pattern[index % pattern.length],
          generation,
        ),
      );

      index++;
    }
  }

  // --------------------------------------------------
  // VOLUME
  // --------------------------------------------------

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);

    for (final handle in _handles.toList()) {
      if (_soloud.getIsValidVoiceHandle(handle)) {
        final level = _voiceLevels[handle] ?? 0.15;

        _soloud.setVolume(
          handle,
          (_volume * level).clamp(0.0, 1.0),
        );
      }
    }
  }

  // --------------------------------------------------
  // PAUSA
  // --------------------------------------------------

  Future<void> pause() async {
    if (!_isPlaying || _isPaused) return;

    _isPaused = true;

    for (final handle in _handles.toList()) {
      if (_soloud.getIsValidVoiceHandle(handle)) {
        _soloud.setPause(handle, true);
      }
    }
  }

  // --------------------------------------------------
  // RIPRESA
  // --------------------------------------------------

  Future<void> resume() async {
    if (!_isPlaying || !_isPaused) return;

    _isPaused = false;

    for (final handle in _handles.toList()) {
      if (_soloud.getIsValidVoiceHandle(handle)) {
        _soloud.setPause(handle, false);
      }
    }
  }

  // --------------------------------------------------
  // STOP COMPLETO
  // --------------------------------------------------

  Future<void> stop() async {
    _isPlaying = false;
    _isPaused = false;

    // Invalida tutte le attività asincrone precedenti.
    _generation++;

    final activeHandles = _handles.toList();

    _handles.clear();
    _voiceLevels.clear();

    for (final handle in activeHandles) {
      if (_soloud.getIsValidVoiceHandle(handle)) {
        await _soloud.stop(handle);
      }
    }
  }

  // --------------------------------------------------
  // DISPOSE
  // --------------------------------------------------

  Future<void> dispose() async {
    await stop();

    for (final source in _sources.values) {
      await _soloud.disposeSource(source);
    }

    _sources.clear();

    // Non deinizializziamo SoLoud:
    // potrebbe essere ancora utilizzato dal servizio binaurale.
  }
}
