import 'package:soul_frequency/models/natural_sound_model.dart';

import 'frequencies_model.dart';

class GeneratorModel{
  TargetModel target;
  bool isPlaying;
  bool isBinaural;
  bool useProcedural;
  double frequency;
  double beat;

  NaturalSoundModel? naturalSound;

  GeneratorModel(this.target, this.isPlaying, this.isBinaural, this.useProcedural, this.frequency, this.beat,{
  this.naturalSound
  } );
}