import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/astral_techniques.dart' hide rope;

import '../costants/voices.dart';
import '../models/astral_travel_model.dart';
import 'astral_travel_session_screen.dart';

class AstralAmbientOption {
  final String title;
  final String assetPath;
  final IconData icon;

  const AstralAmbientOption({
    required this.title,
    required this.assetPath,
    required this.icon,
  });
}

class AstralTravelScreen extends StatefulWidget {
  final List<AstralAmbientOption> ambientOptions;

  const AstralTravelScreen({
    super.key,
    this.ambientOptions = const [
      AstralAmbientOption(
        title: 'Pioggia',
        assetPath: 'assets/audio/rain.mp3',
        icon: Icons.water_drop_outlined,
      ),
      AstralAmbientOption(
        title: 'Onde del mare',
        assetPath: 'assets/audio/waves.mp3',
        icon: Icons.waves_rounded,
      ),
      AstralAmbientOption(
        title: 'Vento',
        assetPath: 'assets/audio/wind.mp3',
        icon: Icons.air_rounded,
      ),
      AstralAmbientOption(
        title: 'Fuoco',
        assetPath: 'assets/audio/fire.mp3',
        icon: Icons.local_fire_department_outlined,
      ),
      AstralAmbientOption(
        title: 'Mare profondo',
        assetPath: 'assets/audio/deep_sea.mp3',
        icon: Icons.water_outlined,
      ),
    ],
  });

  @override
  State<AstralTravelScreen> createState() => _AstralTravelScreenState();
}

class _AstralTravelScreenState extends State<AstralTravelScreen> {
  static const Color mainColor = Color(0xFFB4A3E7);
  static const Color backgroundColor = Color(0xFF171426);
  static const Color cardColor = Color(0xFF252136);
  static const Color secondaryText = Color(0xFFB8B2C9);

  AstralTravelTechnique selectedTechnique = rope;


  bool useProceduralMusic = true;
  bool useBinaural = false;
  bool useNaturalSounds = false;
  bool useVoiceGuide = true;

  double soundFrequency = 432;
  double binauralFrequency = 4;

  int preparationMinutes = 5;
  int explorationMinutes = 10;

  String? selectedAmbientPath;

  @override
  void initState() {
    super.initState();

    if (widget.ambientOptions.isNotEmpty) {
      selectedAmbientPath = widget.ambientOptions.first.assetPath;
    }
  }

  AstralTravelModel get _model {
    return AstralTravelModel(
      technique: selectedTechnique,
      soundFrequency: soundFrequency,
      binauralFrequency: binauralFrequency,
      useProceduralMusic: useProceduralMusic,
      useBinaural: useBinaural,
      useNaturalSounds: useNaturalSounds,
      useVoiceGuide: useVoiceGuide,
      preparationDuration: Duration(minutes: preparationMinutes),
      explorationDuration: Duration(minutes: explorationMinutes),
    );
  }

  void _startSession() {
    final model = _model;

    final ambientPath = useNaturalSounds
        ? selectedAmbientPath
        : null;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AstralTravelSessionScreen(
          model: model,
          ambientAssetPath: ambientPath,
        ),
      ),
    );
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
          'Viaggi astrali',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 26),
              _buildSectionTitle(
                'Scegli la tua tecnica',
                'Seleziona il percorso che desideri sperimentare.',
              ),
              const SizedBox(height: 14),
              _buildTechniqueList(),
              const SizedBox(height: 26),
              _buildSectionTitle(
                'Esperienza audio',
                'Personalizza i suoni che accompagneranno la sessione.',
              ),
              const SizedBox(height: 14),
              _buildAudioSettings(),
              const SizedBox(height: 26),
              const SizedBox(height: 14),
              const SizedBox(height: 28),
              _buildStartButton(),
              const SizedBox(height: 18),
              const Text(
                'Queste tecniche sono esercizi di rilassamento, '
                    'visualizzazione e consapevolezza durante il passaggio '
                    'tra veglia e sonno.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(23),
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
            Icons.auto_awesome,
            color: mainColor,
            size: 36,
          ),
          const SizedBox(height: 17),
          const Text(
            'Esplorazione astrale',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scegli una tecnica, prepara il tuo ambiente '
                'e crea un’esperienza guidata secondo le tue preferenze.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: secondaryText,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TECNICHE
  // ------------------------------------------------------------

  Widget _buildTechniqueList() {
    return Column(
      children: astralTechniques.map((technique) {
        final selected = selectedTechnique == technique;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTechnique = technique;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF332D48)
                  : cardColor,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: selected
                    ? mainColor.withValues(alpha: 0.75)
                    : Colors.white.withValues(alpha: 0.06),
                width: selected ? 1.3 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _techniqueIcon(technique),
                    color: mainColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        technique.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        technique.description,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        technique.category,
                        style: const TextStyle(
                          color: mainColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? mainColor : Colors.white38,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _techniqueIcon(AstralTravelTechnique technique) {
    for(var t in astralTechniques){
      if(t.id == technique.id){
        return t.icon;
      }
    }
    return Icons.vertical_align_top_rounded;
  }

  // ------------------------------------------------------------
  // AUDIO
  // ------------------------------------------------------------

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
            value: useProceduralMusic,
            onChanged: (_) => {
              setState(() {
                useProceduralMusic = !useProceduralMusic;
              })
            },
          ),
          if (useProceduralMusic) ...[
            const Divider(color: Colors.white12, height: 24),
            _buildFrequencySelector(),
          ],
          const Divider(color: Colors.white12, height: 24),
          _buildSwitch(
            icon: Icons.headphones_rounded,
            title: 'Suono binaurale',
            subtitle: 'Due frequenze differenti, una per ciascun orecchio.',
            value: useBinaural,
            onChanged: (_) => {
              setState(() {
                useBinaural = !useBinaural;
              })
            },
          ),
          if (useBinaural) ...[
            const SizedBox(height: 16),
            _buildBinauralSelector(),
          ],
          const Divider(color: Colors.white12, height: 24),
          _buildSwitch(
            icon: Icons.water_drop_outlined,
            title: 'Suoni naturali',
            subtitle: 'Aggiungi un ambiente sonoro alla sessione.',
            value: useNaturalSounds,
            onChanged: (_) => {
              setState(() {
                useNaturalSounds = !useNaturalSounds;
              })
            },
          ),
          if (useNaturalSounds) ...[
            const SizedBox(height: 15),
            _buildAmbientSelector(),
          ],
          const Divider(color: Colors.white12, height: 24),
          _buildSwitch(
            icon: Icons.record_voice_over_rounded,
            title: 'Guida vocale',
            subtitle: 'Ascolta le istruzioni durante le varie fasi.',
            value: useVoiceGuide,
            onChanged: (_) => {
              setState(() {
                useVoiceGuide = !useVoiceGuide;
              })
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
          child: Icon(icon, color: mainColor, size: 20),
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

  Widget _buildAmbientSelector() {
    if (widget.ambientOptions.isEmpty) {
      return const Text(
        'Non sono disponibili suoni naturali.',
        style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scegli il suono ambientale',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...widget.ambientOptions.map((option) {
          final selected = selectedAmbientPath == option.assetPath;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAmbientPath = option.assetPath;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? mainColor.withValues(alpha: 0.13)
                    : Colors.white.withValues(alpha: 0.035),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? mainColor.withValues(alpha: 0.6)
                      : Colors.white12,
                ),
              ),
              child: Row(
                children: [
                  Icon(option.icon, color: mainColor, size: 19),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      option.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: selected ? mainColor : Colors.white38,
                    size: 19,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

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
        borderSide: const BorderSide(color: mainColor),
      ),
    );
  }

  // ------------------------------------------------------------
  // DURATE
  // ------------------------------------------------------------

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _startSession,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text(
          'Inizia il viaggio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          foregroundColor: backgroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}