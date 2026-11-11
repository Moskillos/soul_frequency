import 'package:flutter/material.dart';

import '../costants/astral_techniques.dart';

class AstralTravelTechnique {
  final String id;
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final List<AstralStep> steps;

  const AstralTravelTechnique({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.steps,
  });

  static AstralTravelTechnique? fromId(String id) {
    for (final technique in astralTechniques) {
      if (technique.id == id) {
        return technique;
      }
    }

    return null;
  }
}

const AstralTravelTechnique rope = AstralTravelTechnique(
  id: 'rope',
  name: 'Tecnica della corda',
  category: 'Movimento immaginativo',
  description:
  'Visualizza una corda sospesa sopra di te e immagina di salirvi lentamente.',
  icon: Icons.vertical_align_top_rounded,
  steps: const [
    AstralStep(
      title: 'Preparazione',
      description:
      'Sdraiati comodamente, rilassa il corpo e lascia che il respiro diventi naturale.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Visualizzazione della corda',
      description:
      'Immagina una corda luminosa sospesa sopra di te. Osservane la forma e la posizione.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Salita immaginativa',
      description:
      'Visualizza te stesso mentre sali lentamente lungo la corda, mantenendo il corpo fisico rilassato.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione',
      description:
      'Lascia evolvere liberamente le sensazioni e le immagini mentali, senza forzarle.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

class AstralTravelModel {
  final AstralTravelTechnique technique;

  // Frequenze audio
  final double soundFrequency;
  final double binauralFrequency;

  // Sorgenti sonore
  final bool useProceduralMusic;
  final bool useBinaural;
  final bool useNaturalSounds;

  // Guida vocale
  final bool useVoiceGuide;

  // Durata delle fasi
  final Duration preparationDuration;
  final Duration explorationDuration;

  const AstralTravelModel({
    this.technique = rope,
    this.soundFrequency = 432.0,
    this.binauralFrequency = 4.0,
    this.useProceduralMusic = true,
    this.useBinaural = false,
    this.useNaturalSounds = false,
    this.useVoiceGuide = true,
    this.preparationDuration = const Duration(minutes: 5),
    this.explorationDuration = const Duration(minutes: 10),
  });

  AstralTravelModel copyWith({
    AstralTravelTechnique? technique,
    double? soundFrequency,
    double? binauralFrequency,
    bool? useProceduralMusic,
    bool? useBinaural,
    bool? useNaturalSounds,
    bool? useVoiceGuide,
    Duration? preparationDuration,
    Duration? explorationDuration,
  }) {
    return AstralTravelModel(
      technique: technique ?? this.technique,
      soundFrequency: soundFrequency ?? this.soundFrequency,
      binauralFrequency: binauralFrequency ?? this.binauralFrequency,
      useProceduralMusic: useProceduralMusic ?? this.useProceduralMusic,
      useBinaural: useBinaural ?? this.useBinaural,
      useNaturalSounds: useNaturalSounds ?? this.useNaturalSounds,
      useVoiceGuide: useVoiceGuide ?? this.useVoiceGuide,
      preparationDuration:
      preparationDuration ?? this.preparationDuration,
      explorationDuration:
      explorationDuration ?? this.explorationDuration,
    );
  }
}

class AstralStep {
  final String title;
  final String description;
  final Duration duration;
  final bool audioEnabled;

  const AstralStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.audioEnabled,
  });
}