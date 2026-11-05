import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/models/frequencies_model.dart';
import 'package:soul_frequency/models/generator_model.dart';
import 'package:soul_frequency/models/natural_sound_model.dart';
import 'package:soul_frequency/store/app_state.dart';
import 'package:soul_frequency/ui/beats_card.dart';
import 'package:soul_frequency/ui/beats_web_card.dart';
import 'package:soul_frequency/utils/device_check.dart';

import '../costants/beats_list.dart';
import '../services/ambient_audio_service.dart';
import '../services/app_localization_service.dart';
import '../services/binaural_audio_service.dart';

class BinauralGenerator extends StatefulWidget {
  String nature;
  BinauralGenerator({super.key,required this.nature});

  @override
  State<BinauralGenerator> createState() => _BinauralGeneratorState();
}

class _BinauralGeneratorState extends State<BinauralGenerator> {
  double natureVolume = 1;
  final audio = AmbientAudioService.instance;
  bool loader = false;

  void changeVolume(double value){
    setState(() {
      natureVolume = value;
    });
    AmbientAudioService.instance.setVolume(natureVolume);
  }

  void changeBeats (double value){
    Provider.of<AppState>(context, listen: false).setBeats(value * 100);
  }

  @override
  Widget build(BuildContext context) {
    GeneratorModel generator = Provider.of<AppState>(context).generator;
    double beat = Provider.of<AppState>(context).generator.beat;
    double frequency = Provider.of<AppState>(context).generator.frequency;

    Widget beatsBenefits(){
      for(var b in beats){
        if(beat >= b.min && beat <= b.max){
          return Column(
            children: List.generate(b.benefits.length, (index) => Text(AppLocalizations.of(context).translate(b.benefits[index]), style: whiteText14,)),
          );
        }
      }
      return const SizedBox.shrink();
    }

    void setFrequency(String value){
      Provider.of<AppState>(context, listen: false).setFrequency(double.parse(value));
    }


    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.white10,
            width: 1
          )
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context).translate("frequencySelected"), style: whiteText16,),
              SizedBox(width: 10,),
              Flexible(child: Text(generator.target.target, style: white54Text16w700,)),
            ],
          ),

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate("frequency"), style: whiteText10,),
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
              InkWell(
                onTap: () async {
                  setState(() {
                    loader = true;
                  });
                  await Provider.of<AppState>(context, listen: false).setPlay(!generator.isPlaying);
                  setState(() {
                    loader = false;
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: generator.isPlaying ? detailColor : menuColor,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: SvgPicture.asset(generator.isPlaying ? 'assets/stop.svg' : 'assets/play.svg', height: 70, color:generator.isPlaying ? Colors.red : Colors.yellow,)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context).translate(generator.isBinaural ? "offBinaural" : "onBinaural"), style: whiteText10,),
                  SizedBox(width: 10,),
                  Switch(value: generator.isBinaural, onChanged: (v) async {

                    if(generator.isPlaying){
                      await BinauralAudioService.instance.play(
                          leftFrequency: generator.frequency, beatFrequency:!generator.isBinaural ? generator.beat : 0, volume: 1
                      );
                    }
                    Provider.of<AppState>(context, listen: false).setBinaural(v);

                  }),
                ],
              ),
            ],
          ),

          SizedBox(height: 20,),
          if(generator.isBinaural)LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = 5;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  childAspectRatio: isBigScreen(context) ? 1 : 0.5,
                ),
                itemCount: beats.length,
                itemBuilder: (context, index) {
                  return isBigScreen(context) ? BeatsWebCard(beat: beats[index]) : Column(
                    children: [
                          Text(beats[index].name, style: whiteText14,),
                  SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: BeatsCard(beat: beats[index]),
                  ),
                      Text("${beats[index].min} - ${beats[index].max}", style: whiteText10,),
                    ],
                  );
                },
              );
            },
          ),
          if(!isBigScreen(context) && generator.isBinaural)beatsBenefits(),
          if(generator.isBinaural)SizedBox(height: 10,),

          if(generator.isBinaural)Row(
            children: [
              Text("Beat", style: whiteText10,),
              Slider(value: generator.beat / 100, onChanged: changeBeats),
              Text("${generator.beat.toStringAsFixed(1)} Hz", style: whiteText14,)
            ],
          ),
          if(generator.naturalSound != null)Row(
            children: [
              Column(
                children: [
                  Text(AppLocalizations.of(context).translate("environment"), style: whiteText10,),
                  Text(AppLocalizations.of(context).translate(generator.naturalSound!.name), style: redText10,),
                ],
              ),
              Slider(value: natureVolume, onChanged: changeVolume),
            ],
          )
        ],
      ),
    );
  }
}
