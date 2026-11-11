import 'package:flutter/material.dart';

import '../costants/colors.dart';
import '../models/lucid_dream_model.dart';
import 'lucid_dream_session_screen.dart';

class LucidDreamScreen extends StatefulWidget {
  const LucidDreamScreen({super.key});

  @override
  State<LucidDreamScreen> createState() => _LucidDreamScreenState();
}

class _LucidDreamScreenState extends State<LucidDreamScreen> {

  double soundFrequency = 432;
  double binauralFrequency = 4;
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

            _buildAudioSettings(),

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


  Widget _buildAudioSettings() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSwitch(
            icon: Icons.music_note_rounded,
            title: 'Musica procedurale',
            subtitle: 'Melodia e atmosfere generate in tempo reale.',
            value: model.useProceduralMusic,
            onChanged: (_) => {
              setState(() {
                model.useProceduralMusic = !model.useProceduralMusic;
              }),
            },
          ),
          if (model.useProceduralMusic) ...[
            const Divider(color: Colors.white12, height: 24),
            _buildFrequencySelector(),
          ],
          const Divider(color: Colors.white12, height: 24),
          _buildSwitch(
            icon: Icons.headphones_rounded,
            title: 'Suono binaurale',
            subtitle: 'Due frequenze differenti, una per ciascun orecchio.',
            value: model.useBinaural,
            onChanged: (_) => {
              setState(() {
                model.useBinaural = !model.useBinaural;
              }),
            },
          ),
          if (model.useBinaural) ...[
            const SizedBox(height: 16),
            _buildBinauralSelector(),
          ],
          const Divider(color: Colors.white12, height: 24),
          _buildSwitch(
            icon: Icons.water_drop_outlined,
            title: 'Suoni naturali',
            subtitle: 'Aggiungi un ambiente sonoro alla sessione.',
            value: model.useNaturalSounds,
            onChanged: (_) => {
              setState(() {
                model.useNaturalSounds = !model.useNaturalSounds;
              }),
            },
          ),
          // if (useNaturalSounds) ...[
          //   const SizedBox(height: 15),
          //   _buildAmbientSelector(),
          // ],
          const Divider(color: Colors.white12, height: 24),
          _buildSwitch(
              icon: Icons.record_voice_over_rounded,
              title: 'Guida vocale',
              subtitle: 'Ascolta le istruzioni durante le varie fasi.',
              value: model.useVoiceGuide,
              onChanged: (_) => {
                setState(() {
                  model.useVoiceGuide = !model.useVoiceGuide;
                }),
              }
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: backgroundColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeColor: mainColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFrequencySelector() {
    const frequencies = [396.0, 417.0, 432.0, 440.0, 528.0, 639.0, 741.0, 852.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequenza della musica',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        DropdownButtonFormField<double>(
          value: soundFrequency,
          dropdownColor: cardColor,
          decoration: _dropdownDecoration(),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: frequencies.map((frequency) {
            return DropdownMenuItem(
              value: frequency,
              child: Text('${frequency.toStringAsFixed(0)} Hz'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => soundFrequency = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildBinauralSelector() {
    const frequencies = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 10.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequenza binaurale',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        DropdownButtonFormField<double>(
          value: binauralFrequency,
          dropdownColor: cardColor,
          decoration: _dropdownDecoration(),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: frequencies.map((frequency) {
            return DropdownMenuItem(
              value: frequency,
              child: Text('${frequency.toStringAsFixed(0)} Hz'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => binauralFrequency = value);
            }
          },
        ),
        const SizedBox(height: 7),
        const Text(
          'La frequenza selezionata rappresenta la differenza tra i due toni.',
          style: TextStyle(color: secondaryText, fontSize: 10),
        ),
      ],
    );
  }

  // Widget _buildAmbientSelector() {
  //   if (widget.ambientOptions.isEmpty) {
  //     return const Text(
  //       'Non sono disponibili suoni naturali.',
  //       style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
  //     );
  //   }
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Scegli il suono ambientale',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 12,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       ...widget.ambientOptions.map((option) {
  //         final selected = selectedAmbientPath == option.assetPath;
  //
  //         return GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               selectedAmbientPath = option.assetPath;
  //             });
  //           },
  //           child: Container(
  //             margin: const EdgeInsets.only(bottom: 8),
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 12,
  //               vertical: 11,
  //             ),
  //             decoration: BoxDecoration(
  //               color: selected
  //                   ? mainColor.withValues(alpha: 0.13)
  //                   : Colors.white.withValues(alpha: 0.035),
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(
  //                 color: selected
  //                     ? mainColor.withValues(alpha: 0.6)
  //                     : Colors.white12,
  //               ),
  //             ),
  //             child: Row(
  //               children: [
  //                 Icon(option.icon, color: mainColor, size: 19),
  //                 const SizedBox(width: 10),
  //                 Expanded(
  //                   child: Text(
  //                     option.title,
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                 ),
  //                 Icon(
  //                   selected
  //                       ? Icons.check_circle
  //                       : Icons.circle_outlined,
  //                   color: selected ? mainColor : Colors.white38,
  //                   size: 19,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }),
  //     ],
  //   );
  // }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.045),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mainColor),
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
    print(model.useVoiceGuide);
    print(model.useNaturalSounds);
    print(model.useBinaural);
    print(model.useProceduralMusic);
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
