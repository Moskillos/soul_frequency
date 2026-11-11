import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supertonic_flutter/supertonic_flutter.dart';
import 'dart:ui' show FontFeature;
import '../models/lucid_dream_model.dart';
import '../services/procedural_music_service.dart';
import '../services/binaural_audio_service.dart';
import '../services/ambient_audio_service.dart';
import '../ui/voices_builder.dart';

class LucidDreamSessionScreen extends StatefulWidget {
  final LucidDreamModel model;

  /// Percorso del suono naturale selezionato, ad esempio:
  /// assets/audio/rain.mp3
  final String? ambientAssetPath;

  const LucidDreamSessionScreen({
    super.key,
    required this.model,
    this.ambientAssetPath,
  });

  @override
  State<LucidDreamSessionScreen> createState() =>
      _LucidDreamSessionScreenState();
}

class _LucidDreamSessionScreenState
    extends State<LucidDreamSessionScreen> {
  static const Color mainColor = Color(0xFFB4A3E7);
  static const Color backgroundColor = Color(0xFF171426);
  static const Color cardColor = Color(0xFF252136);
  static const Color secondaryTextColor = Color(0xFFB8B2C9);
  final SupertonicTTS _tts = SupertonicTTS();
  final TTSAudioPlayer _player = TTSAudioPlayer();
  bool ttsReady = false;
  bool ttsInitializing = true;
  Timer? timer;
  final FlutterTts tts = FlutterTts();
  late List<_ProgramStep> steps;

  int currentStep = 0;
  int remainingSeconds = 0;
  bool _isSpeaking = false;
  bool isPlaying = false;
  bool isCompleted = false;
  bool isChangingPlayback = false;
  String _selectedVoice = 'F5';
  String _selectedLang = 'en';
  double _speechSpeed = 0.7;
  double _silenceDuration = 0.3;
  String? _errorMessage;
  bool _isInitialized = false;
  final Set<int> completedSteps = {};
  bool _isInitializing = false;
  String _initializationStatus = 'Checking model files...';

  // Tracciamo separatamente i servizi effettivamente avviati.
  // In questo modo non proviamo a riprendere un audio mai iniziato.
  bool musicStarted = false;
  bool binauralStarted = false;
  bool ambientStarted = false;

  LucidDreamModel get model => widget.model;

  bool get isDailyPractice {
    return model.technique == LucidDreamTechnique.realityCheck ||
        model.technique == LucidDreamTechnique.dreamJournal;
  }

  _ProgramStep get currentProgramStep => steps[currentStep];

  @override
  void initState() {
    super.initState();

    _generateProgram();

    if (!isDailyPractice && steps.isNotEmpty) {
      remainingSeconds = steps.first.duration.inSeconds;
    }
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

  void _generateProgram() {
    switch (model.technique) {
      case LucidDreamTechnique.mild:
        _generateMild();
        break;

      case LucidDreamTechnique.wbtb:
        _generateWbtb();
        break;

      case LucidDreamTechnique.realityCheck:
        _generateRealityCheck();
        break;

      case LucidDreamTechnique.dreamJournal:
        _generateDreamJournal();
        break;
    }
  }

  void _generateMild() {
    final totalMinutes = model.preparationDuration.inMinutes;
    final relaxation =
    (totalMinutes * 0.20).round().clamp(1, totalMinutes).toInt();

    final recall =
    (totalMinutes * 0.20).round().clamp(1, totalMinutes).toInt();

    final signal =
    (totalMinutes * 0.20).round().clamp(1, totalMinutes).toInt();

    final visualization =
    (totalMinutes - relaxation - recall - signal)
        .clamp(1, totalMinutes)
        .toInt();

    steps = [
      _ProgramStep(
        title: 'Rilassamento',
        description:
        'Rilassa progressivamente il corpo. Lascia andare le tensioni e porta l’attenzione sul respiro. '
            'Non cercare di controllare i pensieri: osservali e lasciali passare.',
        duration: Duration(minutes: relaxation),
        audioEnabled: true,
      ),
      _ProgramStep(
        title: 'Ricordo del sogno',
        description:
        'Ripensa all’ultimo sogno che ricordi. Cerca di ricostruire immagini, luoghi, persone ed emozioni. '
            'Concentrati sui dettagli che potrebbero aiutarti a riconoscere un sogno in futuro.',
        duration: Duration(minutes: recall),
        audioEnabled: true,
      ),
      _ProgramStep(
        title: 'Segnale onirico',
        description:
        'Scegli un elemento che potrebbe comparire nei tuoi sogni: una porta, un animale, un luogo o una situazione. '
            'Immagina di riconoscerlo e di renderti conto che stai sognando.',
        duration: Duration(minutes: signal),
        audioEnabled: true,
      ),
      _ProgramStep(
        title: 'Visualizzazione',
        description:
        'Immagina di ritrovarti nel sogno che hai ricordato. Visualizza te stesso mentre riconosci che stai sognando. '
            'Ripeti mentalmente: “La prossima volta che sognerò, mi ricorderò che sto sognando”.',
        duration: Duration(minutes: visualization),
        audioEnabled: true,
      ),
    ];
  }

  void _generateWbtb() {
    steps = [
      _ProgramStep(
        title: 'Risveglio',
        description:
        'Al risveglio, cerca di mantenere la calma. Evita di accendere luci intense o di utilizzare dispositivi luminosi.',
        duration: const Duration(minutes: 3),
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Veglia consapevole',
        description:
        'Rimani sveglio per un breve periodo. Puoi leggere i tuoi appunti sui sogni o ripensare alle esperienze oniriche precedenti.',
        duration: const Duration(minutes: 20),
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Preparazione mentale',
        description:
        'Rilassa il corpo e porta l’attenzione sui sogni. Ripeti mentalmente la tua intenzione di riconoscere il prossimo sogno.',
        duration: const Duration(minutes: 5),
        audioEnabled: true,
      ),
      _ProgramStep(
        title: 'Visualizzazione MILD',
        description:
        'Immagina di tornare in un sogno precedente. Visualizza il momento in cui diventi consapevole di stare sognando. '
            'Lascia che questa intenzione accompagni il ritorno al sonno.',
        duration: model.preparationDuration,
        audioEnabled: true,
      ),
      _ProgramStep(
        title: 'Ritorno al sonno',
        description:
        'Lascia andare ogni sforzo. Mantieni un atteggiamento tranquillo e permetti al sonno di arrivare naturalmente.',
        duration: const Duration(minutes: 2),
        audioEnabled: false,
      ),
    ];
  }

  void _generateRealityCheck() {
    steps = [
      _ProgramStep(
        title: 'Osserva l’ambiente',
        description:
        'Fermati per qualche istante e osserva attentamente ciò che ti circonda. '
            'Nota i dettagli, i colori, le forme e le sensazioni.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Metti in dubbio la realtà',
        description:
        'Chiediti sinceramente: “Sto sognando oppure sono sveglio?”. '
            'Non rispondere automaticamente: cerca di valutare la situazione.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Esegui un test di realtà',
        description:
        'Prova a leggere una frase due volte oppure osserva le tue mani. '
            'Nei sogni alcuni dettagli possono cambiare o risultare instabili.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Rafforza la consapevolezza',
        description:
        'Concentrati sulla sensazione di essere presente. Cerca di trasformare il controllo di realtà in un’abitudine consapevole.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
    ];
  }

  void _generateDreamJournal() {
    steps = [
      _ProgramStep(
        title: 'Resta qualche istante in silenzio',
        description:
        'Al risveglio, evita di alzarti immediatamente. Rimani fermo e prova a recuperare le immagini del sogno.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Ricostruisci il sogno',
        description:
        'Ripercorri mentalmente ciò che è accaduto. Cerca di ricordare luoghi, persone, oggetti, colori ed emozioni.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Annota i dettagli',
        description:
        'Scrivi tutto ciò che ricordi, anche se sono soltanto frammenti o sensazioni. '
            'Non preoccuparti della forma del racconto.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
      _ProgramStep(
        title: 'Individua i segnali onirici',
        description:
        'Rileggi il sogno e cerca elementi insoliti o ricorrenti. '
            'Questi dettagli potranno diventare segnali da riconoscere nei sogni futuri.',
        duration: Duration.zero,
        audioEnabled: false,
      ),
    ];
  }

  // ------------------------------------------------------------
  // GESTIONE AUDIO
  // ------------------------------------------------------------

  Future<void> _startOrResumeAudio() async {
    if (!currentProgramStep.audioEnabled) return;

    // Musica procedurale
    if (model.useProceduralMusic) {
      if (musicStarted) {
        await ProceduralMusicService.instance.resume();
      } else {
        await ProceduralMusicService.instance.start(
          model.soundFrequency,
        );
        musicStarted = true;
      }
    }

    // Suono binaurale
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

    // Suono naturale
    if (model.useNaturalSounds && widget.ambientAssetPath != null) {
      if (ambientStarted) {
        await AmbientAudioService.instance.resume();
      } else {
        await AmbientAudioService.instance.play(
          widget.ambientAssetPath!,
        );
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
    // Fermiamo tutti i servizi indipendentemente da quale sia attivo.
    // Ogni chiamata è protetta per evitare che un errore in un servizio
    // impedisca di fermare gli altri.

    try {
      BinauralAudioService.instance.stopFrequencyOscillation();
    } catch (_) {}

    try {
      await ProceduralMusicService.instance.stop();
    } catch (e) {
      debugPrint('Errore arresto musica procedurale: $e');
    }

    try {
      await BinauralAudioService.instance.stop();
    } catch (e) {
      debugPrint('Errore arresto audio binaurale: $e');
    }

    try {
      await AmbientAudioService.instance.stop();
    } catch (e) {
      debugPrint('Errore arresto suono naturale: $e');
    }

    musicStarted = false;
    binauralStarted = false;
    ambientStarted = false;
  }

  Future<void> _stopVoice() async {
    try {
      await tts.stop();
      await _stop();
    } catch (e) {
      debugPrint('Errore arresto voce: $e');
    }
  }

  Future<void> _stop() async {
    await _player.stop();
    setState(() {
      _isSpeaking = false;
    });
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

  Future<void> _speakCurrentStep() async {
    print("model");
    print(model.useVoiceGuide);
    print(ttsReady);
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

  Future<void> _togglePlayback() async {
    if (isChangingPlayback || isCompleted || isDailyPractice) return;

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

    final finishedStep = currentStep;

    // Segniamo la fase corrente come completata.
    if (finishedStep == steps.length - 1) {
      setState(() {
        completedSteps.add(finishedStep);
        remainingSeconds = 0;
        isPlaying = false;
        isCompleted = true;
      });

      await _stopAudio();
      return;
    }

    final nextStep = finishedStep + 1;

    final previousAudioEnabled = steps[finishedStep].audioEnabled;
    final nextAudioEnabled = steps[nextStep].audioEnabled;

    // Aggiorniamo la schermata alla fase successiva.
    setState(() {
      completedSteps.add(finishedStep);
      currentStep = nextStep;
      remainingSeconds = steps[nextStep].duration.inSeconds;
    });

    try {
      if (!nextAudioEnabled) {
        // La fase successiva non prevede audio.
        await _stopAudio();
      } else if (!previousAudioEnabled) {
        // La fase precedente non aveva audio:
        // avviamo automaticamente quello della nuova fase.
        await _startOrResumeAudio();
      }

      // Se entrambe le fasi prevedono audio, non fermiamo nulla:
      // la musica e il binaurale continuano senza interruzioni.

    } catch (e) {
      debugPrint('Errore nel passaggio automatico: $e');

      await _stopAudio();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore durante il cambio della riproduzione audio.'),
          ),
        );
      }
    }

    if (!mounted) return;

    // Il timer riparte automaticamente per la nuova fase.
    setState(() {
      isPlaying = true;
    });

    _startTimer();
  }

  Future<void> _nextStep() async {
    if (currentStep >= steps.length - 1) {
      await _finishSession();
      return;
    }

    timer?.cancel();
    await _stopAudio();

    if (!mounted) return;

    setState(() {
      completedSteps.add(currentStep);
      currentStep++;
      remainingSeconds = currentProgramStep.duration.inSeconds;
      isPlaying = false;
    });
  }

  Future<void> _previousStep() async {
    if (currentStep <= 0) return;

    timer?.cancel();
    await _stopAudio();

    if (!mounted) return;

    setState(() {
      currentStep--;
      remainingSeconds = currentProgramStep.duration.inSeconds;
      isPlaying = false;
    });
  }

  Future<void> _finishSession() async {
    timer?.cancel();

    await _stopAudio();

    if (!mounted) return;

    setState(() {
      isPlaying = false;
      isCompleted = true;
      completedSteps.add(currentStep);
    });
  }

  void _completeDailyStep() {
    if (!isDailyPractice || isCompleted) return;

    setState(() {
      completedSteps.add(currentStep);

      if (currentStep < steps.length - 1) {
        currentStep++;
      } else {
        isCompleted = true;
      }
    });
  }

  void _finishAndClose() {
    unawaited(_stopAudio());

    if (mounted) {
      Navigator.of(context).pop();
    }
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

  String get _techniqueName {
    switch (model.technique) {
      case LucidDreamTechnique.mild:
        return 'MILD';
      case LucidDreamTechnique.wbtb:
        return 'WBTB';
      case LucidDreamTechnique.realityCheck:
        return 'Reality Check';
      case LucidDreamTechnique.dreamJournal:
        return 'Dream Journal';
    }
  }

  String get _techniqueDescription {
    switch (model.technique) {
      case LucidDreamTechnique.mild:
        return 'Mnemonic Induction of Lucid Dreams';
      case LucidDreamTechnique.wbtb:
        return 'Wake Back To Bed';
      case LucidDreamTechnique.realityCheck:
        return 'Allenamento della consapevolezza';
      case LucidDreamTechnique.dreamJournal:
        return 'Diario e memoria onirica';
    }
  }

  double get _progress {
    if (steps.isEmpty) return 0;

    return completedSteps.length / steps.length;
  }

  void setVoice(String voice){
    setState(() {
      _selectedVoice = voice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Sogni lucidi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: isCompleted
            ? _buildCompletedMessage()
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildIntroduction(),
              const SizedBox(height: 24),
              _buildProgress(),
              const SizedBox(height: 24),
              if (isDailyPractice)
                _buildDailyProgram()
              else
                _buildGuidedProgram(),
              if(!isDailyPractice)VoicesBuilder(selectedVoice: _selectedVoice, setVoice: setVoice,),
              const SizedBox(height: 20),
              _buildAudioInfo(),
              const SizedBox(height: 24),
              _buildControls(),
              const SizedBox(height: 16),
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
          colors: [
            Color(0xFF39304F),
            Color(0xFF252136),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: mainColor.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.nights_stay_rounded,
            color: mainColor,
            size: 34,
          ),
          const SizedBox(height: 16),
          Text(
            _techniqueName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _techniqueDescription,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Il tuo percorso',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isDailyPractice
              ? 'Segui ogni passaggio con calma e completa le attività per allenare la tua consapevolezza onirica.'
              : 'Segui le fasi della sessione senza fretta. Puoi mettere in pausa l’audio e riprendere quando vuoi.',
          style: const TextStyle(
            color: secondaryTextColor,
            height: 1.5,
            fontSize: 14,
          ),
        ),
      ],
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
                '${completedSteps.length}/${steps.length}',
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
              value: _progress,
              minHeight: 7,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidedProgram() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fase corrente',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        _buildProgramStep(),
      ],
    );
  }

  Widget _buildDailyProgram() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attività da completare',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(
          steps.length,
              (index) => _buildDailyStep(index),
        ),
      ],
    );
  }

  Widget _buildDailyStep(int index) {
    final step = steps[index];
    final isDone = completedSteps.contains(index);
    final isCurrent = currentStep == index;

    return GestureDetector(
      onTap: isDone
          ? null
          : () {
        setState(() {
          currentStep = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFF332D48) : cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrent
                ? mainColor.withValues(alpha: 0.65)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? Colors.green.withValues(alpha: 0.2)
                    : mainColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                isDone ? Icons.check : Icons.circle_outlined,
                color: isDone ? Colors.greenAccent : mainColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.description,
                    style: const TextStyle(
                      color: secondaryTextColor,
                      height: 1.45,
                      fontSize: 13,
                    ),
                  ),
                  if (isCurrent && !isDone) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _completeDailyStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: backgroundColor,
                          elevation: 0,
                        ),
                        child: const Text('Completa attività'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramStep() {
    final step = currentProgramStep;
    final duration = step.duration.inSeconds;

    final progress = duration > 0
        ? 1 - (remainingSeconds / duration)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: mainColor.withValues(alpha: 0.25),
        ),
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
                child: const Icon(
                  Icons.self_improvement_rounded,
                  color: mainColor,
                  size: 23,
                ),
              ),
              const Spacer(),
              Text(
                '${currentStep + 1} / ${steps.length}',
                style: const TextStyle(
                  color: secondaryTextColor,
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
              color: secondaryTextColor,
              height: 1.6,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          if (step.duration > Duration.zero) ...[
            Center(
              child: Text(
                _formatTime(remainingSeconds),
                style: const TextStyle(
                  color: mainColor,
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor:
                const AlwaysStoppedAnimation<Color>(mainColor),
              ),
            ),
          ],
          if (step.audioEnabled) ...[
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(
                  Icons.graphic_eq_rounded,
                  color: mainColor,
                  size: 19,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Audio disponibile durante questa fase',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioInfo() {
    final audioOptions = <Widget>[];

    if (model.useProceduralMusic) {
      audioOptions.add(
        _audioChip(
          Icons.music_note_rounded,
          'Musica procedurale',
        ),
      );
    }

    if (model.useBinaural) {
      audioOptions.add(
        _audioChip(
          Icons.headphones_rounded,
          'Binaurale ${model.binauralFrequency} Hz',
        ),
      );
    }

    if (model.useNaturalSounds) {
      audioOptions.add(
        _audioChip(
          Icons.water_drop_outlined,
          'Suoni naturali',
        ),
      );
    }

    if (audioOptions.isEmpty) {
      return const SizedBox.shrink();
    }

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
            'Impostazioni audio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: audioOptions,
          ),
          if (model.useNaturalSounds &&
              widget.ambientAssetPath == null) ...[
            const SizedBox(height: 10),
            const Text(
              'Nessun percorso audio naturale è stato specificato.',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _audioChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: mainColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: mainColor,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    if (isDailyPractice) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _finishAndClose,
          icon: const Icon(Icons.close_rounded),
          label: const Text('Chiudi sessione'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: currentStep > 0 && !isChangingPlayback
                    ? _previousStep
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Indietro'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: isChangingPlayback ? null : _togglePlayback,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  isPlaying ? 'Pausa' : 'Inizia',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: !isChangingPlayback ? _nextStep : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  currentStep == steps.length - 1 ? 'Fine' : 'Avanti',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: _finishAndClose,
          child: const Text(
            'Interrompi sessione',
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedMessage() {
    return Center(
      child: SingleChildScrollView(
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
              child: const Icon(
                Icons.check_rounded,
                color: mainColor,
                size: 55,
              ),
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
              'Hai completato il tuo percorso. Prenditi qualche istante per mantenere questa sensazione di calma e consapevolezza.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryTextColor,
                height: 1.6,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finishAndClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Torna indietro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// MODELLO INTERNO DELLE FASI
// ------------------------------------------------------------

class _ProgramStep {
  final String title;
  final String description;
  final Duration duration;
  final bool audioEnabled;

  const _ProgramStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.audioEnabled,
  });
}