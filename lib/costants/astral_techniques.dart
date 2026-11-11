import 'package:flutter/material.dart';
import 'package:soul_frequency/models/astral_travel_model.dart';

AstralTravelTechnique rope = AstralTravelTechnique(
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

// Tecnica delle vibrazioni
 const vibrations = AstralTravelTechnique(
  id: 'vibrations',
  name: 'Tecnica delle vibrazioni',
  category: 'Percezione corporea',
  description:
  'Osserva le sensazioni corporee e immagina un’onda delicata che attraversa il corpo.',
  icon: Icons.waves_rounded,
  steps: [
    AstralStep(
      title: 'Rilassamento',
      description:
      'Rilassa progressivamente il corpo, partendo dai piedi e arrivando alla testa.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Percezione delle sensazioni',
      description:
      'Osserva eventuali formicolii, pulsazioni o sensazioni spontanee senza cercare di provocarle.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Visualizzazione energetica',
      description:
      'Immagina un’onda luminosa che attraversa lentamente il corpo.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Osservazione',
      description:
      'Rimani rilassato e osserva le sensazioni senza giudicarle.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Corpo di luce
 const lightBody = AstralTravelTechnique(
  id: 'lightBody',
  name: 'Corpo di luce',
  category: 'Movimento immaginativo',
  description:
  'Visualizza una forma luminosa che rappresenta simbolicamente il tuo corpo.',
  icon: Icons.brightness_5_outlined,
  steps: [
    AstralStep(
      title: 'Rilassamento corporeo',
      description:
      'Rilassa il corpo e porta l’attenzione al respiro.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Visualizzazione luminosa',
      description:
      'Immagina una forma luminosa che riproduce simbolicamente la tua figura.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Espansione della luce',
      description:
      'Visualizza la luce che si espande delicatamente intorno alla figura.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione immaginativa',
      description:
      'Immagina di muoverti liberamente con questa forma luminosa.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Tecnica del galleggiamento
 const floating = AstralTravelTechnique(
  id: 'floating',
  name: 'Tecnica del galleggiamento',
  category: 'Movimento immaginativo',
  description:
  'Immagina il corpo leggero, mentre galleggia dolcemente nello spazio.',
  icon: Icons.cloud_outlined,
  steps: [
    AstralStep(
      title: 'Preparazione',
      description:
      'Trova una posizione comoda e rilassa ogni parte del corpo.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Sensazione di leggerezza',
      description:
      'Immagina che il corpo diventi leggero, come se fosse sostenuto dall’acqua.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Galleggiamento',
      description:
      'Visualizza te stesso mentre fluttui lentamente in un ambiente tranquillo.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione',
      description:
      'Lascia che il movimento immaginativo prosegua spontaneamente.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Tecnica della porta
 const doorway = AstralTravelTechnique(
  id: 'doorway',
  name: 'Tecnica della porta',
  category: 'Visualizzazione',
  description:
  'Visualizza una porta e immagina di attraversarla entrando in un nuovo ambiente.',
  icon: Icons.door_front_door_outlined,
  steps: [
    AstralStep(
      title: 'Rilassamento',
      description:
      'Rilassa il corpo e stabilizza il respiro.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Creazione della porta',
      description:
      'Immagina una porta davanti a te. Osservane i dettagli, il colore e la forma.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Attraversamento',
      description:
      'Visualizza la porta che si apre e immagina di attraversarla con calma.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione del nuovo ambiente',
      description:
      'Osserva mentalmente il luogo che si trova oltre la porta.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Tecnica dello specchio
 const mirror = AstralTravelTechnique(
  id: 'mirror',
  name: 'Tecnica dello specchio',
  category: 'Visualizzazione',
  description:
  'Immagina uno specchio luminoso e osserva la tua immagine trasformarsi.',
  icon: Icons.flip_outlined,
  steps: [
    AstralStep(
      title: 'Rilassamento',
      description:
      'Rilassa il corpo e porta l’attenzione al respiro.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Visualizzazione dello specchio',
      description:
      'Immagina uno specchio luminoso davanti a te.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Osservazione dell’immagine',
      description:
      'Visualizza la tua immagine riflessa e osserva eventuali cambiamenti immaginativi.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione',
      description:
      'Lascia evolvere liberamente la scena mentale.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Tecnica del rotolamento
 const rolling = AstralTravelTechnique(
  id: 'rolling',
  name: 'Tecnica del rotolamento',
  category: 'Movimento immaginativo',
  description:
  'Immagina di ruotare lentamente su un fianco senza muovere il corpo fisico.',
  icon: Icons.rotate_right_rounded,
  steps: [
    AstralStep(
      title: 'Preparazione',
      description:
      'Sdraiati comodamente e rilassa completamente il corpo.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Visualizzazione del movimento',
      description:
      'Immagina di ruotare lentamente su un fianco, mantenendo il corpo fisico immobile.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Rotazione immaginativa',
      description:
      'Lascia che il movimento mentale diventi fluido e naturale, senza sforzo.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione',
      description:
      'Osserva le sensazioni e le immagini che emergono.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Osservazione ipnagogica
 const hypnagogic = AstralTravelTechnique(
  id: 'hypnagogic',
  name: 'Osservazione ipnagogica',
  category: 'Transizione veglia-sonno',
  description:
  'Osserva immagini, colori e sensazioni spontanee durante il rilassamento.',
  icon: Icons.blur_on_rounded,
  steps: [
    AstralStep(
      title: 'Rilassamento progressivo',
      description:
      'Rilassa il corpo mantenendo una leggera attenzione al respiro.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Osservazione delle immagini',
      description:
      'Lascia emergere immagini, colori o forme spontanee senza cercare di controllarle.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Consapevolezza',
      description:
      'Mantieni un atteggiamento curioso e rilassato mentre osservi le immagini mentali.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Transizione',
      description:
      'Lascia che il rilassamento prosegua naturalmente, senza forzare il sonno o le immagini.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Body scan
 const bodyScan = AstralTravelTechnique(
  id: 'bodyScan',
  name: 'Body scan',
  category: 'Percezione corporea',
  description:
  'Rilassa progressivamente ogni parte del corpo mantenendo l’attenzione vigile.',
  icon: Icons.self_improvement_rounded,
  steps: [
    AstralStep(
      title: 'Piedi e gambe',
      description:
      'Porta l’attenzione ai piedi, alle caviglie e alle gambe. Rilassa ogni zona.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Bacino e addome',
      description:
      'Rilassa il bacino, l’addome e la parte bassa della schiena.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Torace e braccia',
      description:
      'Porta l’attenzione al torace, alle spalle, alle braccia e alle mani.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Viso e corpo completo',
      description:
      'Rilassa il viso e percepisci il corpo come un insieme armonioso.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
  ],
);

// Tecnica del paesaggio
 const landscape = AstralTravelTechnique(
  id: 'landscape',
  name: 'Tecnica del paesaggio',
  category: 'Visualizzazione',
  description:
  'Costruisci mentalmente un luogo e immergiti nei suoi dettagli sensoriali.',
  icon: Icons.landscape_outlined,
  steps: [
    AstralStep(
      title: 'Preparazione',
      description:
      'Rilassa il corpo e respira lentamente.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Creazione del paesaggio',
      description:
      'Immagina un luogo tranquillo, naturale o fantastico.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Immersione sensoriale',
      description:
      'Visualizza colori, forme, suoni e dettagli del paesaggio.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Esplorazione',
      description:
      'Immagina di esplorare lentamente il luogo, seguendo la tua curiosità.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Tecnica del punto luminoso
 const lightPoint = AstralTravelTechnique(
  id: 'lightPoint',
  name: 'Tecnica del punto luminoso',
  category: 'Visualizzazione',
  description:
  'Concentrati su un punto luminoso immaginario e lascialo espandere.',
  icon: Icons.flare_rounded,
  steps: [
    AstralStep(
      title: 'Rilassamento',
      description:
      'Rilassa il corpo e stabilizza il respiro.',
      duration: Duration(minutes: 3),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Concentrazione',
      description:
      'Immagina un piccolo punto luminoso davanti a te.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Espansione',
      description:
      'Visualizza il punto che si espande lentamente, diventando una sfera di luce.',
      duration: Duration(minutes: 4),
      audioEnabled: true,
    ),
    AstralStep(
      title: 'Immersione',
      description:
      'Immagina di entrare simbolicamente nella luce e osserva le sensazioni che emergono.',
      duration: Duration(minutes: 5),
      audioEnabled: true,
    ),
  ],
);

// Tutte le tecniche
List<AstralTravelTechnique> astralTechniques = [
  rope,
  vibrations,
  lightBody,
  floating,
  doorway,
  mirror,
  rolling,
  hypnagogic,
  bodyScan,
  landscape,
  lightPoint,
];