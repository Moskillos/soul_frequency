import 'package:flutter/material.dart';
import 'package:soul_frequency/models/centering_execise_model.dart';

List<CenteringExerciseModel> centeringExercises = [
  CenteringExerciseModel("Radicamento",
      Colors.red,
      "Esercizi per connettersi alla terra e stabilizzare l'energia",
      "Il radicamento (grounding) è la capacità di sentirsi stabilmente connessi al proprio corpo e alla terra, quì e ora. È il primo passo di ofgni percorso di consapevolezza: senza una base stabile, mente e sistema nervoso faticano a rilassarsi. Gli esercizi seguenti lavorano sul contatto fisico con il suolo, sul respiro e sull'immaginazione per ricreare questo senso di appoggio.",
      "assets/foot.svg",
      [
    ExerciseModel(
        "Visualizzazione delle radici",
        "Ristabilire il contatto con la terra, scaricare le tensioni in eccesso e ritrovare stabilità fisica ed emotiva",
        "5 - 10 minuti",
        "In piedimì, piedi paralleli alla larghezza del bacino, ginocchia leggermente morbide(in alternativa, seduti con i piedi ben appoggiati al pavimento)",
        "Riduce ansia e senso di dispersione mentale, aumenta la percezione di stabilità fisica e favorisce un rilascio naturale delle tensioni accumulate",
        [
          "Chiudi gli occhi e porta l'attenzione al peso del corpo che scarica verso il basso, attraverso le gambe fino alla pianta dei piedi.",
          "Immagina che dalla pianta di ciascun piede comincio a scendere dalle radici morbide e luminose, come quelle di un grande albero.",
          "Lascia che le radici scendano lentamente attraverso gli strati del terreno, la terra scura, la roccia, fino al centro della terra.",
          "Quando senti le radici ben ancorate, immagina che da esse risalga un flusso di energia nutriente e stabile, che sale lungo le gambe, il bacino e la colonna vertebrale.",
          "Resta alcuni minuti percependo questo doppio movimento: le radici che scendono e l'energia che sale, mentre il respiro rimane lento e naturale.",
          "Prima di riaprire gli occhi, muovi leggermente i piedi e senti il contatto pieno con il suolo."
        ])
  ]),
  CenteringExerciseModel("Respiro Consapevole",
      Colors.indigoAccent,
      "Tecniche di pranayama per centrare mente e corpo",
      "Il pranayama è l'arte yoica del controllo consapevole del respiro. Agendo direttamente sul sistema nervoso autonomo, queste tecniche permettono di calmare la mente, aumentare la concentrazione ed equilibrre l'energia vitale(prana) in tempi molto brevi. Vanno praticamente sempre con delicatezza, senza mai forzare il respiro.",
      "assets/lungs.svg",
      [
    ExerciseModel(
        "Respirazione diaframmatica",
        "Riattivare il respiro pieno e naturale, base indispensabile er qualunque tecnica di pranayama più avanzata.",
        "5 - 10 minuti",
        "Sdraiati sulla schiena con le ginocchia piegate, oppure seduti con la schiena dritta.",
        "Attiva il sistema nervoso parasimpatico (il freno naturale del corpo), riduce lo stress e prepara corpo e mente alle tecniche di pranayama successive.",
        [
          "Appoggia una mano sul petto e una sull'addome, appena sotto l'ombelico.",
          "Inspira lentamente dal naso, lasciando che l'addome si gonfi e sollevi la mano che è appoggiata, mentre la mano sul petto resta quasi immobile.",
          "Espira lentamente dal naso o dalla bocca, lasciando che l'addome si sgonfi e rientri dolcemente.",
          "Continua con un ritmo lento e regolare, respirando in modo silenzioso e senza sforzo per 10-15 cicli.",
          "Osserva come, respiro dopo respiro, il corpo si alleggerisce e la mente si acquieta."
        ])
  ]),
  CenteringExerciseModel("Visualizzazione",
      Colors.deepPurpleAccent,
      "Esercizi di immaginazione guidata per espandere la coscienza",
      "L'immaginazione guidata utilizza immagini mentali strutturate per accompagnare la mente oltre i confini abituali del pensiero razionale, favorendo stati di maggiore ampiezza, clma e consapevolezza di sé. Sono pratiche da svolgere in un logo tranquillo, senza fretta.",
      "assets/eye.svg",
      [
        ExerciseModel(
            "Sfera di luce",
            "Espandere gradualmente la consapevolezza attraverso un'immagine di luce che cresce e avvolge.",
            "8 - 12 minuti",
            "Seduti comodamente, schiena dritta, occhi chiusi.",
            "Favorisce il senso di protezione interiore, allena la mente a percepire stati di apertura e ampiezza e riduce la sensazione di costrizione o chiusura emotiva.",
            [
              "Immagina una piccola sfera di luce bianca o dorata al centro del petto, luminosa e calda.",
              "A ogni inspirazione, immagina che la sfera si carichi di energia e cresca leggermente di dimensione.",
              "Lascia che, respiro dopo respiro, la sfera si espanda fino ad avvolgere l'intero corpo, come un bozzolo di luce protettiva.",
              "Continua ad espanderla oltre il corpo: fino a riempire la stanza in cui ti trovi, poi oltre, sena sforzo, solo osservando l'espansione.",
              "Resta qualche intante in questo spazio ampio e luminoso, poi lascia che la sfera si ritragga dolcemente fino a tornare al centro del petto.",
              "Riporta l'attenzione al respiro e, quando sei pronto, riapri gli occhi."
            ])
      ]),
  CenteringExerciseModel("Centratura del cuore",
      Colors.red,
      "Pratiche per aprire e bilanciare il centro cardiaco",
      "Il centro cardiaco è considerato. in molte tradizioni contemplative, il punto di incontro tra corpo, emozioni e spirito. Le pratiche seguenti, ispirate anche agli studi sulla coerenza cardiaca, uniscono respiro, attenzione ed emozioni positive per favorire equilibrio interiore e apertura relazionale.",
      "assets/hearth.svg",
      [
        ExerciseModel(
            "Meditazione sul cuore",
            "Sincronizzare respiro e attenzione sul centro cardiaco per favorire uno stato di coerenza e calma.",
            "8 - 10 minuti",
            "Seduti comodamente, occhi chiusi, mano appoggiata sul petto.",
            "Favorisce uno stato di equilibrio tra sistema nervoso simpativo e parasimpatico, contribuisce a ridurre i livelli di stress percepito e migliora la stabilità emotiva.",
            [
              "Porta l'attenzione alla zona del cuore, immaginando di respirare direttamente attaverso quel punto.",
              "Inspira contando lentamente fino a cinque, poi espira contando lentamente fino a cinque, mantendendo un ritmo regolare e senza sforzo.",
              "Continua questo respiro lento e ritmico per alcuni minuti, lasciando che il corpo trovi progressivamente un ritmo più stabile.",
              "Se la mente si distrae, riporta gentilmente l'attenzione al cuore e al conteggio del respiro.",
              "Concludi restando in silenzio qualche istante, osservando la sensazione di calma raggiunta."
            ])
      ]),
  CenteringExerciseModel("Attivazione energetiva",
      Colors.yellow,
      "Movimenti e pratiche per risvegliare l'energia vitale",
      "Dopo il lavoro di radicamento, respio e apertura del cuore, questa ultima sezione utilizza il movimento fisico, ipirato al Qi Gong e allo stretching dei meridiani della medicina tradizionale cinese, per far circolare liberamente l'energia vitale di tutto il corpo.",
      "assets/thunder.svg",
      [
        ExerciseModel(
            "Scuotimento corporeo",
            "Sciogliere tensioni muscolari ed energetiche accumulate, riattivando la circolazione dell'energia.",
            "3 - 5 minuti",
            "In piedi, piedi alla larghezza delle spalle, ginocchia morbide.",
            "Scarica lo stress fisico e nervoso accumulato, riattiva la circolazione sanguigna ed energetica e lascia una sensazione di leggerezza e vitalità.",
            [
              "Comincia a scuotere dolcemente le ginocchia, lasciando che il movimento sia leggero e continuo.",
              "Estendi gradualemente lo scuotimento alle gambe, ai fianchi, poi al busto, alle braccia e infine alle spalle, fino a coinvolgere tutto il corpo.",
              "Lascia che le braccia e le mani si muovano libere e morbide, come se fossero prive di preso.",
              "Mantieni lo scuotimento per 1-3 minuti, respirando liberamente, eventualmente lasciando uscire anche suoni o sospiri.",
              "Fermati gradualmente, poi resta immobile qualche istante percependo il formicolio o il calore diffuso nel corpo."
            ])
      ]),
];