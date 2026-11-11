import 'dart:async';
import 'dart:ui' show FontFeature;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/ui/voices_builder.dart';
import 'package:supertonic_flutter/supertonic_flutter.dart';

import '../costants/colors.dart';
import '../costants/voices.dart';
import '../models/astral_travel_model.dart';
import '../services/procedural_music_service.dart';
import '../services/binaural_audio_service.dart';
import '../services/ambient_audio_service.dart';

class AstralTravelSessionScreen extends StatefulWidget {
  final AstralTravelModel model;
  final String? ambientAssetPath;

  const AstralTravelSessionScreen({
    super.key,
    required this.model,
    this.ambientAssetPath,
  });

  @override
  State<AstralTravelSessionScreen> createState() =>
      _AstralTravelSessionScreenState();
}

class _AstralTravelSessionScreenState extends State<AstralTravelSessionScreen> {


  final FlutterTts tts = FlutterTts();
  Timer? timer;

  int currentStep = 0;
  int remainingSeconds = 0;
  final SupertonicTTS _tts = SupertonicTTS();
  final TTSAudioPlayer _player = TTSAudioPlayer();

  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isSpeaking = false;
  String _initializationStatus = 'Checking model files...';
  String _selectedVoice = 'F5';
  String _selectedLang = 'en';
  double _speechSpeed = 0.7;
  double _silenceDuration = 0.3;
  String? _errorMessage;
  bool isPlaying = false;
  bool isCompleted = false;
  bool isChangingPlayback = false;
  bool ttsReady = false;
  bool ttsInitializing = true;
  bool musicStarted = false;
  bool binauralStarted = false;
  bool ambientStarted = false;

  final Set<int> completedSteps = {};

  AstralTravelModel get model => widget.model;

  AstralStep get currentProgramStep => widget.model.technique.steps[currentStep];

  @override
  void initState() {
    super.initState();

    remainingSeconds = widget.model.technique.steps.first.duration.inSeconds;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTTS();
    });
    _setupAudioPlayerListeners();
    unawaited(_initializeTts());
  }

  void _setupAudioPlayerListeners() {
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isSpeaking = state == PlayerState.playing;
      });
    });
  }

  Future<void> _initializeTTS() async {
    if (_isInitialized) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
      _initializationStatus = 'Checking model files...';
    });

    try {
      final modelsReady = await SupertonicTTS.modelsReady();
      if (!modelsReady) {
        setState(() {
          _initializationStatus = 'Downloading model files (0/16)...';
        });

        await SupertonicTTS.preDownloadModels(
          onProgress: (completed, total, file, fileProgress) {
            if (!mounted) return;
            final percent = (fileProgress * 100)
                .clamp(0, 100)
                .toStringAsFixed(0);
            setState(() {
              _initializationStatus =
              'Downloading model files (${completed.clamp(0, total)}/$total)\n'
                  '$file • $percent%';
            });
          },
        );
      }

      setState(() {
        _initializationStatus = 'Initializing speech engine...';
      });
      await _tts.initialize();
      setState(() {
        _isInitialized = true;
        _isInitializing = false;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Failed to initialize TTS: $e';
      });
    }
  }

  Future<void> _initializeTts() async {
    try {
      await tts.setLanguage('it-IT');
      await tts.setSpeechRate(0.5);
      await tts.setVolume(0.9);
      await tts.setPitch(0.3);
      await tts.awaitSpeakCompletion(true);

      if (!mounted) return;

      setState(() {
        ttsReady = true;
        ttsInitializing = false;
      });

      debugPrint('TTS inizializzato correttamente');
    } catch (e, stackTrace) {
      debugPrint('Errore inizializzazione TTS: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        ttsReady = false;
        ttsInitializing = false;
      });
    }
  }

  void setVoice(String voice){
    setState(() {
      _selectedVoice = voice;
    });
  }

  Future<void> _speakCurrentStep() async {
    if (!model.useVoiceGuide || !ttsReady) return;

    try {
      await tts.stop();

      // Non attendiamo la fine della lettura:
      // il timer e la musica devono proseguire in parallelo.
      unawaited(
        tts.speak(
          '${currentProgramStep.title}. ${currentProgramStep.description}',
        ),
      );
    } catch (e) {
      debugPrint('Errore sintesi vocale: $e');
    }
  }

  Future<void> _stopVoice() async {
    try {
      await tts.stop();
      await _stop();
    } catch (e) {
      debugPrint('Errore arresto voce: $e');
    }
  }

  // ------------------------------------------------------------
  // AUDIO
  // ------------------------------------------------------------

  Future<void> _startOrResumeAudio() async {
    if (!currentProgramStep.audioEnabled) return;

    if (model.useProceduralMusic) {
      if (musicStarted) {
        await ProceduralMusicService.instance.resume();
      } else {
        await ProceduralMusicService.instance.start(model.soundFrequency);
        musicStarted = true;
      }
    }

    if (model.useBinaural) {
      if (binauralStarted) {
        BinauralAudioService.instance.resume();
      } else {
        await BinauralAudioService.instance.play(
          leftFrequency: 200,
          beatFrequency: model.binauralFrequency,
          volume: 0.15,
        );
        binauralStarted = true;
      }
    }

    if (model.useNaturalSounds && widget.ambientAssetPath != null) {
      if (ambientStarted) {
        await AmbientAudioService.instance.resume();
      } else {
        await AmbientAudioService.instance.play(widget.ambientAssetPath!);
        ambientStarted = true;
      }
    }
  }

  Future<void> _pauseAudio() async {
    if (musicStarted) {
      await ProceduralMusicService.instance.pause();
    }

    if (binauralStarted) {
      BinauralAudioService.instance.pause();
    }

    if (ambientStarted) {
      await AmbientAudioService.instance.pause();
    }
  }

  Future<void> _stopAudio() async {
    try {
      BinauralAudioService.instance.stopFrequencyOscillation();
    } catch (_) {}

    try {
      await ProceduralMusicService.instance.stop();
    } catch (e) {
      debugPrint('Errore stop musica: $e');
    }

    try {
      await BinauralAudioService.instance.stop();
    } catch (e) {
      debugPrint('Errore stop binaurale: $e');
    }

    try {
      await AmbientAudioService.instance.stop();
    } catch (e) {
      debugPrint('Errore stop suono naturale: $e');
    }

    musicStarted = false;
    binauralStarted = false;
    ambientStarted = false;
  }

  // ------------------------------------------------------------
  // RIPRODUZIONE E TIMER
  // ------------------------------------------------------------

  Future<void> _togglePlayback() async {
    if (isChangingPlayback || isCompleted) return;

    isChangingPlayback = true;

    if (isPlaying) {
      timer?.cancel();

      await _stopVoice();
      await _pauseAudio();

      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      try {
        if (model.useVoiceGuide && !ttsReady) {
          await _initializeTts();
        }
        await _startOrResumeAudio();

        if (!mounted) return;

        setState(() {
          isPlaying = true;
        });

        if(_selectedVoice == "F5"){
          unawaited(_speakCurrentStep());
        } else {
          unawaited(_speak());
        }

        _startTimer();
      } catch (e) {
        debugPrint('Errore avvio sessione: $e');

        await _stopAudio();

        if (mounted) {
          setState(() {
            isPlaying = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossibile avviare la riproduzione audio.'),
            ),
          );
        }
      }
    }

    isChangingPlayback = false;
  }

  void _startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (remainingSeconds <= 1) {
        t.cancel();
        unawaited(_advanceAutomatically());
        return;
      }

      setState(() {
        remainingSeconds--;
      });
    });
  }

  Future<void> _advanceAutomatically() async {
    if (!mounted) return;

    final previousStep = currentStep;

    if (previousStep >= widget.model.technique.steps.length - 1) {
      await _completeSession();
      return;
    }

    final nextStep = previousStep + 1;

    final previousAudio = widget.model.technique.steps[previousStep].audioEnabled;
    final nextAudio = widget.model.technique.steps[nextStep].audioEnabled;

    await _stopVoice();

    setState(() {
      completedSteps.add(previousStep);
      currentStep = nextStep;
      remainingSeconds = widget.model.technique.steps[nextStep].duration.inSeconds;
    });

    try {
      if (!nextAudio) {
        await _stopAudio();
      } else if (!previousAudio) {
        await _startOrResumeAudio();
      }

      // Se entrambe le fasi hanno audio, non fermiamo i servizi.
      // La musica continua senza ripartire.

      if(_selectedVoice == "F5"){
        unawaited(_speakCurrentStep());
      } else {
        unawaited(_speak());
      }
    } catch (e) {
      debugPrint('Errore cambio fase: $e');
      await _stopAudio();
    }

    if (!mounted) return;

    setState(() {
      isPlaying = true;
    });

    _startTimer();
  }

  Future<void> _changeStep(int direction) async {
    if (isChangingPlayback) return;

    final next = currentStep + direction;

    if (next < 0) return;

    if (next >= widget.model.technique.steps.length) {
      await _completeSession();
      return;
    }

    isChangingPlayback = true;

    final wasPlaying = isPlaying;
    final previousAudio = currentProgramStep.audioEnabled;
    final nextAudio = widget.model.technique.steps[next].audioEnabled;

    timer?.cancel();
    await _stopVoice();

    setState(() {
      if (direction > 0) {
        completedSteps.add(currentStep);
      }

      currentStep = next;
      remainingSeconds = currentProgramStep.duration.inSeconds;
      isPlaying = false;
    });

    if (!nextAudio) {
      await _stopAudio();
    } else if (wasPlaying && !previousAudio) {
      try {
        await _startOrResumeAudio();
      } catch (e) {
        debugPrint('Errore avvio audio: $e');
      }
    } else if (!wasPlaying) {
      // Se la sessione era in pausa, non riavviamo l'audio.
      // Lo riprenderemo quando l'utente premerà Play.
    }

    if (wasPlaying && mounted) {
      if(_selectedVoice == "F5"){
        unawaited(_speakCurrentStep());
      } else {
        unawaited(_speak());
      }

      setState(() {
        isPlaying = true;
      });

      _startTimer();
    }

    isChangingPlayback = false;
  }

  Future<void> _completeSession() async {
    timer?.cancel();

    await _stopVoice();
    await _stopAudio();

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      isCompleted = true;
      completedSteps.add(currentStep);
    });
  }

  Future<void> _closeSession() async {
    timer?.cancel();

    await _stopVoice();
    await _stopAudio();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _speak() async {
    debugPrint('Speak button clicked');
    debugPrint(
      'Initialized: $_isInitialized',
    );

    if (!_isInitialized) {
      debugPrint('Speak returned early: not initialized or empty text');
      return;
    }

    debugPrint('Starting synthesis...');
    setState(() {
      _isSpeaking = true;
      _errorMessage = null;
    });

    try {
      final config = TTSConfig(
        denoisingSteps: 14,
        speechSpeed: _speechSpeed,
        silenceDuration: _silenceDuration,
      );

      debugPrint('Calling tts.synthesize...');
      final result = await _tts.synthesize(
        currentProgramStep.description,
        language: _selectedLang,
        voiceStyle: _selectedVoice,
        config: config,
      );

      debugPrint(
        'Synthesis complete, audio length: ${result.audioData.length}',
      );
      debugPrint('Playing audio...');
      await _player.play(result);
      debugPrint('Audio playback started');
    } catch (e, stackTrace) {
      debugPrint('Error during synthesis: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'TTS error: $e';
      });
    } finally {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  Future<void> _stop() async {
    await _player.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    unawaited(_stopAudio());
    unawaited(_stop());
    unawaited(tts.stop());

    super.dispose();
  }

  // ------------------------------------------------------------
  // FORMATTAZIONE
  // ------------------------------------------------------------

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (widget.model.technique.steps.isEmpty) return 0;

    return completedSteps.length / widget.model.technique.steps.length;
  }

  String get techniqueName => model.technique.name;

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Viaggi astrali',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: isCompleted
            ? _buildCompleted()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 22),
                    _buildProgress(),
                    const SizedBox(height: 24),
                    _buildCurrentStep(),
                    const SizedBox(height: 20),
                    VoicesBuilder(selectedVoice: _selectedVoice, setVoice: setVoice,),
                    const SizedBox(height: 20),
                    _buildAudioSettings(),
                    const SizedBox(height: 24),
                    _buildControls(),
                    const SizedBox(height: 16),
                    _buildStepList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF39304F), Color(0xFF252136)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: mainColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: mainColor, size: 34),
          const SizedBox(height: 16),
          const Text(
            'Esplorazione astrale',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            techniqueName,
            style: const TextStyle(color: secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }



  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Avanzamento',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${completedSteps.length}/${widget.model.technique.steps.length}',
                style: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    final step = currentProgramStep;

    final totalSeconds = step.duration.inSeconds;
    final elapsed = totalSeconds - remainingSeconds;

    final stepProgress = totalSeconds > 0
        ? (elapsed / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: mainColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.self_improvement, color: mainColor),
              ),
              const Spacer(),
              Text(
                '${currentStep + 1} / ${widget.model.technique.steps.length}',
                style: const TextStyle(
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            step.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            step.description,
            style: const TextStyle(
              color: secondaryText,
              height: 1.6,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              _formatTime(remainingSeconds),
              style: const TextStyle(
                color: mainColor,
                fontSize: 42,
                fontWeight: FontWeight.w300,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: stepProgress,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
          if (model.useVoiceGuide) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(
                  Icons.record_voice_over,
                  color: ttsInitializing
                      ? Colors.orangeAccent
                      : ttsReady
                      ? mainColor
                      : Colors.redAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ttsInitializing
                        ? 'Inizializzazione della voce...'
                        : ttsReady
                        ? 'Guida vocale attiva'
                        : 'Voce non disponibile: puoi seguire il testo',
                    style: const TextStyle(color: secondaryText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioSettings() {
    final options = <Widget>[];

    if (model.useProceduralMusic) {
      options.add(_audioChip(Icons.music_note, 'Musica procedurale'));
    }

    if (model.useBinaural) {
      options.add(
        _audioChip(Icons.headphones, '${model.binauralFrequency} Hz binaurali'),
      );
    }

    if (model.useNaturalSounds) {
      options.add(_audioChip(Icons.water_drop_outlined, 'Suoni naturali'));
    }

    if (model.useVoiceGuide) {
      options.add(_audioChip(Icons.record_voice_over, 'Guida vocale'));
    }

    if (options.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Esperienza audio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(spacing: 8, runSpacing: 8, children: options),
          if (model.useNaturalSounds && widget.ambientAssetPath == null) ...[
            const SizedBox(height: 10),
            const Text(
              'Non è stato selezionato un suono naturale.',
              style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _audioChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: mainColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: mainColor, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: currentStep > 0 && !isChangingPlayback
                ? () => _changeStep(-1)
                : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Indietro'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: isChangingPlayback ? null : _togglePlayback,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            label: Text(isPlaying ? 'Pausa' : 'Inizia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: !isChangingPlayback ? () => _changeStep(1) : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(currentStep == widget.model.technique.steps.length - 1 ? 'Fine' : 'Avanti'),
          ),
        ),
      ],
    );
  }

  Widget _buildStepList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Le fasi della sessione',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(widget.model.technique.steps.length, (index) {
          final step = widget.model.technique.steps[index];
          final done = completedSteps.contains(index);
          final current = currentStep == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: current ? const Color(0xFF332D48) : cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: current
                    ? mainColor.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  done
                      ? Icons.check_circle
                      : current
                      ? Icons.play_circle_fill
                      : Icons.circle_outlined,
                  color: done ? Colors.greenAccent : mainColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${step.duration.inMinutes} min',
                  style: const TextStyle(color: secondaryText, fontSize: 11),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _closeSession,
            child: const Text(
              'Interrompi sessione',
              style: TextStyle(color: secondaryText),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleted() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: mainColor, size: 50),
            ),
            const SizedBox(height: 28),
            const Text(
              'Sessione completata',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Prenditi qualche momento per tornare completamente presente. '
              'Muovi lentamente le mani e i piedi e annota eventuali sensazioni o immagini che desideri ricordare.',
              textAlign: TextAlign.center,
              style: TextStyle(color: secondaryText, height: 1.6, fontSize: 14),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _closeSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Termina'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


