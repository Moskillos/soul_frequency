import '../models/lucid_dream_model.dart';

class LucidDreamStep {
  final String title;
  final String description;
  final Duration duration;
  final bool audioEnabled;
  final bool isOptional;

  const LucidDreamStep({
    required this.title,
    required this.description,
    required this.duration,
    this.audioEnabled = false,
    this.isOptional = false,
  });
}

class LucidDreamProgram {
  final String title;
  final String subtitle;
  final List<LucidDreamStep> steps;

  const LucidDreamProgram({
    required this.title,
    required this.subtitle,
    required this.steps,
  });

  Duration get totalDuration {
    return steps.fold(
      Duration.zero,
          (total, step) => total + step.duration,
    );
  }
}

class LucidDreamProgramGenerator {
  static LucidDreamProgram generate(LucidDreamModel model) {
    switch (model.technique) {
      case LucidDreamTechnique.mild:
        return _generateMild(model);

      case LucidDreamTechnique.wbtb:
        return _generateWbtb(model);

      case LucidDreamTechnique.realityCheck:
      case LucidDreamTechnique.dreamJournal:
        throw UnsupportedError(
          'Questa tecnica non utilizza una sessione audio guidata.',
        );
    }
  }

  // -------------------------
  // MILD
  // -------------------------

  static LucidDreamProgram _generateMild(
      LucidDreamModel model,
      ) {
    final totalMinutes =
        model.preparationDuration.inMinutes;

    final relaxation = (totalMinutes * 0.20).round();
    final recall = (totalMinutes * 0.20).round();
    final intention = (totalMinutes * 0.20).round();
    final visualization =
        totalMinutes - relaxation - recall - intention;

    return LucidDreamProgram(
      title: 'Tecnica MILD',
      subtitle: 'Mnemonic Induction of Lucid Dreams',
      steps: [
        LucidDreamStep(
          title: 'Rilassamento',
          description:
          'Sdraiati comodamente, chiudi gli occhi e rilassa '
              'progressivamente il corpo. Lascia andare i pensieri '
              'della giornata.',
          duration: Duration(minutes: relaxation),
          audioEnabled: true,
        ),

        LucidDreamStep(
          title: 'Ricorda un sogno',
          description:
          'Ripensa a un sogno recente. Cerca di ricordare '
              'luoghi, persone, sensazioni ed eventi.',
          duration: Duration(minutes: recall),
          audioEnabled: true,
        ),

        LucidDreamStep(
          title: 'Riconosci il segnale onirico',
          description:
          'Individua qualcosa di insolito nel sogno: un luogo '
              'impossibile, una situazione strana o un comportamento '
              'che avrebbe dovuto farti capire che stavi sognando.',
          duration: Duration(minutes: intention),
          audioEnabled: true,
        ),

        LucidDreamStep(
          title: 'Intenzione e visualizzazione',
          description:
          'Immagina di rivivere il sogno, ma questa volta '
              'riconoscendo di stare sognando. Ripeti mentalmente: '
              '"La prossima volta che sognerò, mi ricorderò '
              'di riconoscere che sto sognando".',
          duration: Duration(minutes: visualization),
          audioEnabled: true,
        ),
      ],
    );
  }

  // -------------------------
  // WBTB
  // -------------------------

  static LucidDreamProgram _generateWbtb(
      LucidDreamModel model,
      ) {
    return LucidDreamProgram(
      title: 'Tecnica WBTB',
      subtitle: 'Wake Back To Bed',
      steps: [
        LucidDreamStep(
          title: 'Risveglio consapevole',
          description:
          'Dopo circa 4-6 ore di sonno, svegliati con calma. '
              'Cerca di ricordare immediatamente ciò che stavi sognando.',
          duration: const Duration(minutes: 3),
        ),

        LucidDreamStep(
          title: 'Periodo di veglia',
          description:
          'Rimani sveglio per circa 15-25 minuti. '
              'Puoi leggere qualcosa sui sogni lucidi e annotare '
              'eventuali sogni ricordati.',
          duration: const Duration(minutes: 20),
        ),

        LucidDreamStep(
          title: 'Preparazione mentale',
          description:
          'Rilassati e concentrati sull\'intenzione di '
              'riconoscere il prossimo sogno. Ripeti mentalmente '
              'la tua intenzione di diventare consapevole durante '
              'il sogno.',
          duration: const Duration(minutes: 5),
          audioEnabled: true,
        ),

        LucidDreamStep(
          title: 'Visualizzazione MILD',
          description:
          'Visualizza un sogno recente. Immagina di riconoscere '
              'un segnale onirico e diventare consapevole di stare '
              'sognando. Mantieni questa intenzione mentre torni '
              'a dormire.',
          duration: Duration(
            minutes: model.preparationDuration.inMinutes,
          ),
          audioEnabled: true,
        ),

        LucidDreamStep(
          title: 'Ritorno al sonno',
          description:
          'Interrompi l\'audio, lascia andare le immagini '
              'mentali e torna a dormire mantenendo una leggera '
              'intenzione di riconoscere il sogno.',
          duration: const Duration(minutes: 2),
        ),
      ],
    );
  }
}