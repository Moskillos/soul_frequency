
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_soloud/flutter_soloud.dart';

class ProceduralMusicService {
  ProceduralMusicService._();

  static final ProceduralMusicService instance =
  ProceduralMusicService._();

  final SoLoud _soloud = SoLoud.instance;

  double _referenceFrequency = 432.0;

  bool _isPlaying = false;
  double _volume = 0.35;

  // Ogni sorgente ha una frequenza fissa.
  // In questo modo le note sovrapposte non si modificano a vicenda.
  final Map<String, AudioSource> _sources = {};

  // Conserviamo solo le voci appartenenti a questo motore musicale.
  final Set<SoundHandle> _handles = {};

  bool get isPlaying => _isPlaying;

  double get volume => _volume;

  double noteFrequency(int midiNote) {
    return _referenceFrequency *
        math.pow(2, (midiNote - 69) / 12).toDouble();
  }

  Future<AudioSource> _getSource({
    required WaveForm waveform,
    required double frequency,
  }) async {
    final key = '${waveform.name}_${frequency.toStringAsFixed(4)}';

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

  Future<void> _playNote({
    required int midiNote,
    required WaveForm waveform,
    required double level,
    required Duration duration,
    Duration attack = const Duration(milliseconds: 500),
    Duration release = const Duration(milliseconds: 1200),
  }) async {
    if (!_isPlaying) return;

    final source = await _getSource(
      waveform: waveform,
      frequency: noteFrequency(midiNote),
    );

    if (!_isPlaying) return;

    final handle = await Future.value(
      _soloud.play(source, volume: 0.0),
    );

    _handles.add(handle);

    // Entrata graduale della nota.
    _soloud.fadeVolume(
      handle,
      (_volume * level).clamp(0.0, 1.0),
      attack,
    );

    final safeRelease = release < duration ? release : duration;
    final waitBeforeRelease = duration - safeRelease;

    await Future.delayed(waitBeforeRelease);

    if (!_isPlaying || !_handles.contains(handle)) return;

    // Uscita graduale per evitare interruzioni brusche.
    _soloud.fadeVolume(
      handle,
      0.0,
      safeRelease,
    );

    await Future.delayed(safeRelease);

    if (_handles.remove(handle)) {
      await _soloud.stop(handle);
    }
  }

  Future<void> start(double frequency) async {
    if (_isPlaying) return;

    if (frequency < 100 || frequency > 1000) {
      throw ArgumentError('Frequenza non valida.');
    }

    _referenceFrequency = frequency;
    if (_isPlaying) return;

    if (!_soloud.isInitialized) {
      await _soloud.init(
        sampleRate: 44100,
        bufferSize: 2048,
        channels: Channels.stereo,
      );
    }

    _isPlaying = true;

    unawaited(_runHarmony());
    unawaited(_runMelody());
    unawaited(_runBells());
    // unawaited(_runTibetanBowls());
  }

  Future<void> _runHarmony() async {
    // Accordi: Do maggiore 7, La minore 7,
    // Fa maggiore 7, Sol sospeso.
    const chords = <List<int>>[
      [48, 55, 59, 64],
      [45, 52, 55, 60],
      [41, 48, 52, 57],
      [43, 50, 55, 57],
    ];

    var index = 0;

    while (_isPlaying) {
      final chord = chords[index % chords.length];

      for (final note in chord) {
        unawaited(
          _playNote(
            midiNote: note,
            waveform: WaveForm.sin,
            level: 0.16,
            duration: const Duration(seconds: 10),
            attack: const Duration(seconds: 3),
            release: const Duration(seconds: 3),
          ),
        );
      }

      index++;
      await Future.delayed(const Duration(seconds: 8));
    }
  }

  Future<void> _runMelody() async {
    // Frase in Do maggiore: lenta e con pause.
    const melody = <int?>[
      72, null, 76, 79, null, 76, 74, null,
      72, 67, null, 71, 72, null, 76, null,
    ];

    var index = 0;

    while (_isPlaying) {
      final note = melody[index % melody.length];

      if (note != null) {
        unawaited(
          _playNote(
            midiNote: note,
            waveform: WaveForm.triangle,
            level: 0.18,
            duration: const Duration(milliseconds: 2400),
            attack: const Duration(milliseconds: 350),
            release: const Duration(milliseconds: 1600),
          ),
        );
      }

      index++;
      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  Future<void> _runBells() async {
    // Arpeggi occasionali, più acuti e delicati.
    const pattern = <int>[84, 79, 76, 72, 76, 79, 86, 79];

    var index = 0;

    while (_isPlaying) {
      await Future.delayed(const Duration(seconds: 4));

      if (!_isPlaying) break;

      unawaited(
        _playNote(
          midiNote: pattern[index % pattern.length],
          waveform: WaveForm.sin,
          level: 0.12,
          duration: const Duration(seconds: 3),
          attack: const Duration(milliseconds: 40),
          release: const Duration(milliseconds: 2500),
        ),
      );

      index++;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> _playTibetanBowl({
    required int midiNote,
    double level = 0.20,
  }) async {
    if (!_isPlaying) return;

    final fundamental = noteFrequency(midiNote);

    // Le campane tibetane hanno armoniche non necessariamente
    // multiple esatte della fondamentale.
    final partials = [
      (frequency: fundamental, amplitude: 1.0),
      (frequency: fundamental * 2.71, amplitude: 0.35),
      (frequency: fundamental * 4.13, amplitude: 0.18),
      (frequency: fundamental * 5.43, amplitude: 0.10),
    ];

    // Qui riproduciamo le componenti armoniche.
    // Ogni componente avrà un proprio volume e decadimento.
    for (final partial in partials) {
      final source = await _getSource(
        waveform: WaveForm.sin,
        frequency: partial.frequency,
      );

      if (!_isPlaying) return;

      final handle = _soloud.play(source, volume: 0.0);
      _handles.add(handle);

      final targetVolume =
      (_volume * level * partial.amplitude).clamp(0.0, 1.0);

      _soloud.fadeVolume(
        handle,
        targetVolume,
        const Duration(milliseconds: 80),
      );

      unawaited(_releaseBowlPartial(
        handle,
        const Duration(seconds: 9),
      ));
    }
  }

  Future<void> _releaseBowlPartial(
      SoundHandle handle,
      Duration duration,
      ) async {
    await Future.delayed(duration);

    if (!_handles.contains(handle)) return;

    _soloud.fadeVolume(
      handle,
      0.0,
      const Duration(seconds: 8),
    );

    await Future.delayed(const Duration(seconds: 8));

    if (_handles.remove(handle)) {
      await _soloud.stop(handle);
    }
  }

  Future<void> _runTibetanBowls() async {
    final random = math.Random();

    const notes = [48, 55, 60, 64, 67, 72];

    while (_isPlaying) {
      await Future.delayed(
        Duration(seconds: 12 + random.nextInt(10)),
      );

      if (!_isPlaying) break;

      final note = notes[random.nextInt(notes.length)];

      unawaited(
        _playTibetanBowl(
          midiNote: note,
          level: 0.20,
        ),
      );
    }
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);

    // Aggiorna il volume delle voci attualmente attive.
    for (final handle in _handles.toList()) {
      if (_soloud.getIsValidVoiceHandle(handle)) {
        _soloud.setVolume(handle, _volume * 0.15);
      }
    }
  }

  Future<void> stop() async {
    _isPlaying = false;

    final activeHandles = _handles.toList();
    _handles.clear();

    for (final handle in activeHandles) {
      if (_soloud.getIsValidVoiceHandle(handle)) {
        await _soloud.stop(handle);
      }
    }
  }

  Future<void> dispose() async {
    await stop();

    for (final source in _sources.values) {
      await _soloud.disposeSource(source);
    }

    _sources.clear();
  }
}
