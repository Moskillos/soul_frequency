import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/costants/frequencies.dart';
import 'package:soul_frequency/costants/natural_sounds.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/store/app_state.dart';
import 'package:soul_frequency/ui/binaural_group_card.dart';
import 'package:soul_frequency/ui/natural_sound_card.dart';

import '../models/natural_sound_model.dart';
import '../services/ambient_audio_service.dart';
import '../services/app_localization_service.dart';
import '../ui/binaural_generator.dart';

class BinauralGeneratorScreen extends StatefulWidget {
  const BinauralGeneratorScreen({super.key});

  @override
  State<BinauralGeneratorScreen> createState() => _BinauralGeneratorScreenState();
}

class _BinauralGeneratorScreenState extends State<BinauralGeneratorScreen> {
  String nature = '';
  int? activeSoundIndex;
  bool _initialized = false;
  bool _isExpanded = false;
  bool _isPresetExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      nature = AppLocalizations.of(context).translate("none");
      _initialized = true;
    }
  }

  void setNature(String value){
    setState(() {
      nature = value;
    });
  }

  void setFrequency(String value){
    Provider.of<AppState>(context, listen: false).setFrequency(double.parse(value));
  }

  @override
  Widget build(BuildContext context) {
    List<NaturalSoundModel>? naturalSounds = Provider.of<AppState>(context).naturalSoundsList;
    double frequency = Provider.of<AppState>(context).generator.target.leftFrequency;

    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/binaural.jpg"),
                Text("Frequenze Binaurali", style: whiteText50Corinthia),
                SizedBox(height: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Frequenza", style: white54Text16,),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        color: Colors.white
                      ),
                      constraints: BoxConstraints(
                        maxWidth: 100,
                        maxHeight: 45
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: '',
                              border: InputBorder.none,
                              hintText: frequency.toString(),
                              hintStyle: blackText16,
                          ),
                          onChanged: (value) => setFrequency(value),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                BinauralGenerator(nature: nature, ),
                SizedBox(height: 30,),
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: detailColor,
                        ),
                        child: Row(
                          children: [
                            Text("Suoni ambientali", style: whiteText16,),
                            SizedBox(width: 5,),
                            AnimatedRotation(
                              // turns: 0.5 corrisponde a 180 gradi (mezza rotazione)
                              turns: _isExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(_isExpanded)DecoratedBox(
                      decoration: BoxDecoration(
                        color: backGroundColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = 3;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 9,
                                childAspectRatio: 1,
                              ),
                              itemCount: naturalSounds.length,
                              itemBuilder: (context, index) {
                                return NaturalSoundCard(
                                  selectedIndex: index,
                                  nature: naturalSounds[index],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: detailColor,
                  ),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _isPresetExpanded = !_isPresetExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text("Lista preset", style: whiteText16,),
                        SizedBox(width: 5,),
                        AnimatedRotation(
                          // turns: 0.5 corrisponde a 180 gradi (mezza rotazione)
                          turns: _isPresetExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    ),
                  ),
                ),
                if(_isPresetExpanded)Column(
                  children: List.generate(frequencies.length, (index) => BinauralGroupCard(frequency: frequencies[index])),
                )
              ]
          ),
        ),

      ),
    );
  }
}
