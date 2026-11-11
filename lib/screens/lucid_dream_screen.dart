import 'package:flutter/material.dart';

import '../models/lucid_dream_model.dart';
import 'lucid_dream_session_screen.dart';

class LucidDreamScreen extends StatefulWidget {
  const LucidDreamScreen({super.key});

  @override
  State<LucidDreamScreen> createState() => _LucidDreamScreenState();
}

class _LucidDreamScreenState extends State<LucidDreamScreen> {
  final Color mainColor = const Color(0xFFB4A3E7);
  final Color backgroundColor = const Color(0xFF171426);
  final Color cardColor = const Color(0xFF252136);

  final LucidDreamModel model = LucidDreamModel();

  // --------------------------------------------------
  // TECHNIQUE DATA
  // --------------------------------------------------

  final Map<LucidDreamTechnique, Map<String, dynamic>>
  techniques = {
    LucidDreamTechnique.mild: {
      'title': 'MILD',
      'subtitle': 'Mnemonic Induction of Lucid Dreams',
      'description':
      'Allena la tua mente a riconoscere quando '
          'stai sognando attraverso intenzione, memoria '
          'e visualizzazione.',
      'level': 'Principiante',
      'icon': Icons.nightlight_round,
      'duration': '10-15 minuti',
    },

    LucidDreamTechnique.realityCheck: {
      'title': 'Reality Check',
      'subtitle': 'Verifica della realtà',
      'description':
      'Impara a mettere in discussione il tuo '
          'stato di coscienza attraverso esercizi '
          'di osservazione durante la giornata.',
      'level': 'Principiante',
      'icon': Icons.visibility_outlined,
      'duration': 'Durante il giorno',
    },

    LucidDreamTechnique.wbtb: {
      'title': 'WBTB',
      'subtitle': 'Wake Back To Bed',
      'description':
      'Prevede un risveglio temporaneo dopo '
          'alcune ore di sonno, seguito da un ritorno '
          'a letto con una tecnica di induzione.',
      'level': 'Avanzato',
      'icon': Icons.alarm,
      'duration': 'Durante la notte',
    },

    LucidDreamTechnique.dreamJournal: {
      'title': 'Dream Journal',
      'subtitle': 'Diario dei sogni',
      'description':
      'Allena la memoria onirica registrando '
          'i sogni e i loro dettagli appena sveglio.',
      'level': 'Principiante',
      'icon': Icons.menu_book_outlined,
      'duration': 'Ogni mattina',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Sogni Lucidi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 28),

            _buildTechniqueSection(),

            const SizedBox(height: 25),

            _buildAudioSection(),

            const SizedBox(height: 25),

            _buildDurationSettings(),

            const SizedBox(height: 30),

            _buildContinueButton(),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.nightlight_round,
          color: mainColor,
          size: 48,
        ),

        const SizedBox(height: 15),

        const Text(
          'Esplora il mondo dei sogni',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Scegli il metodo che desideri utilizzare '
              'e personalizza la tua esperienza.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // TECHNIQUE SECTION
  // --------------------------------------------------

  Widget _buildTechniqueSection() {
    final selected = techniques[model.technique]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Metodo di allenamento',
          Icons.psychology_outlined,
        ),

        const SizedBox(height: 8),

        Text(
          'Seleziona la tecnica che vuoi seguire.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 15),

        ...LucidDreamTechnique.values.map((technique) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildTechniqueCard(technique),
          );
        }),

        const SizedBox(height: 8),

        // DYNAMIC SELECTED TECHNIQUE DESCRIPTION

        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: mainColor.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selected['icon'] as IconData,
                    color: mainColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selected['subtitle'] as String,
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                selected['description'] as String,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  _infoChip(selected['level'] as String),
                  _infoChip(selected['duration'] as String),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechniqueCard(
      LucidDreamTechnique technique,
      ) {
    final data = techniques[technique]!;
    final selected = model.technique == technique;

    return GestureDetector(
      onTap: () {
        setState(() {
          model.technique = technique;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected
              ? mainColor.withValues(alpha: 0.16)
              : cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected
                ? mainColor
                : Colors.white.withValues(alpha: 0.06),
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                data['icon'] as IconData,
                color: mainColor,
                size: 23,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    data['subtitle'] as String,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected
                  ? mainColor
                  : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // AUDIO SECTION
  // --------------------------------------------------

  Widget _buildAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Personalizza l\'audio',
          Icons.graphic_eq,
        ),

        const SizedBox(height: 15),

        _buildCard(
          child: Column(
            children: [
              _buildSwitch(
                title: 'Audio binaurale',
                subtitle: 'Due frequenze differenti tra le orecchie',
                value: model.useBinaural,
                onChanged: (value) {
                  setState(() {
                    model.useBinaural = value;
                  });
                },
              ),

              if (model.useBinaural) ...[
                const SizedBox(height: 12),
                _buildSlider(
                  title: 'Frequenza binaurale',
                  value: model.binauralFrequency,
                  min: 0.5,
                  max: 30,
                  divisions: 59,
                  unit: 'Hz',
                  onChanged: (value) {
                    setState(() {
                      model.binauralFrequency = value;
                    });
                  },
                ),
              ],

              const Divider(color: Colors.white12, height: 30),

              _buildSwitch(
                title: 'Musica generativa',
                subtitle: 'Suoni continui e melodie procedurali',
                value: model.useProceduralMusic,
                onChanged: (value) {
                  setState(() {
                    model.useProceduralMusic = value;
                  });
                },
              ),

              if (model.useProceduralMusic) ...[
                const SizedBox(height: 12),
                _buildSlider(
                  title: 'Frequenza sonora',
                  value: model.soundFrequency,
                  min: 220,
                  max: 880,
                  divisions: 660,
                  unit: 'Hz',
                  onChanged: (value) {
                    setState(() {
                      model.soundFrequency = value;
                    });
                  },
                ),
              ],

              const Divider(color: Colors.white12, height: 30),

              _buildSwitch(
                title: 'Suoni naturali',
                subtitle: 'Pioggia, vento, onde e altri ambienti',
                value: model.useNaturalSounds,
                onChanged: (value) {
                  setState(() {
                    model.useNaturalSounds = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // DURATION
  // --------------------------------------------------

  Widget _buildDurationSettings() {
    final minutes =
        model.preparationDuration.inMinutes;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Durata audio di preparazione',
            Icons.timer_outlined,
          ),

          const SizedBox(height: 15),

          Center(
            child: Text(
              '$minutes minuti',
              style: TextStyle(
                color: mainColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Slider(
            value: minutes.toDouble(),
            min: 5,
            max: 60,
            divisions: 11,
            activeColor: mainColor,
            inactiveColor: Colors.white24,
            onChanged: (value) {
              setState(() {
                model.preparationDuration =
                    Duration(minutes: value.round());
              });
            },
          ),

          const Text(
            'Tempo indicativo dedicato alla preparazione. '
                'Non rappresenta la durata del sonno.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // COMMON WIDGETS
  // --------------------------------------------------

  Widget _sectionTitle(
      String title,
      IconData icon,
      ) {
    return Row(
      children: [
        Icon(icon, color: mainColor, size: 21),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: child,
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: mainColor,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)} $unit',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: mainColor,
          inactiveColor: Colors.white24,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: mainColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CONTINUE
  // --------------------------------------------------

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Genera il programma',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  void _continue() {
    // Passiamo tutte le impostazioni alla pagina successiva.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LucidDreamSessionScreen(
          model: model,
        ),
      ),
    );
  }
}
