import 'package:flutter/cupertino.dart';
import 'package:soul_frequency/costants/chakra_list.dart';
import 'package:soul_frequency/costants/frequencies.dart';
import 'package:soul_frequency/costants/natural_sounds.dart';
import 'package:soul_frequency/models/chakra_model.dart';
import 'package:soul_frequency/models/frequencies_model.dart';
import 'package:soul_frequency/models/generator_model.dart';

import '../models/natural_sound_model.dart';
import '../services/ambient_audio_service.dart';
import '../services/binaural_audio_service.dart';


class AppState extends ChangeNotifier {
  final audio = AmbientAudioService.instance;

  GeneratorModel generator = GeneratorModel(
      TargetModel(
        "Frequenza dell'Universo",
        432,
        4,
        1
      ),
      false,
      false,
      432,
      4
  );
  List<ChakraModel> chakraStore = chakraList;
  List<NaturalSoundModel> naturalSoundsList = naturalSounds;

  void setBinaural(bool value){
    generator.isBinaural = value;

    notifyListeners();
  }

  Future<void> play()async{
    if(!generator.isPlaying){
      await BinauralAudioService.instance.stop();
      await audio.stop();
    } else {
      if (generator.isBinaural) {
        await BinauralAudioService.instance.play(
            leftFrequency: generator.target.leftFrequency,
            beatFrequency: generator.target.beatFrequency,
            volume: 1
        );
        if (generator.naturalSound != null) {
          await audio.play(generator.naturalSound!.sound);
        } else {
          await audio.stop();
        }
      } else {
        await BinauralAudioService.instance.play(
            leftFrequency: generator.target.leftFrequency,
            beatFrequency: 0,
            volume: 1
        );
        if (generator.naturalSound != null) {
          await audio.play(generator.naturalSound!.sound);
        } else {
          await audio.stop();
        }
      }
    }
    notifyListeners();
  }

  Future<void> setPlay(bool value) async {
    generator.isPlaying = value;
    notifyListeners();
    play();
  }

  void setFrequency(double value){
    generator.frequency = value;
    generator.isPlaying = false;
    BinauralAudioService.instance.stop();
    audio.stop();
    for(var f in frequencies){
      for(var t in f.targets){
        print(t.leftFrequency.toStringAsFixed(0));
        print(value.toStringAsFixed(0));
        if(t.leftFrequency.toStringAsFixed(0) == value.toStringAsFixed(0)){
          print(t.target);
          generator.target = t;
          notifyListeners();
          return;
        } else {
          generator.target = TargetModel("Nessun target trovato", value, generator.beat, 1);
        }
      }
    }
    notifyListeners();
  }

  void setTarget(TargetModel target){
    generator.target = target;
    generator.frequency = target.leftFrequency;
    generator.beat = target.beatFrequency;
    generator.isPlaying = false;
    BinauralAudioService.instance.stop();
    audio.stop();
    notifyListeners();
  }

  Future<void> setNaturalSound(NaturalSoundModel naturalSound) async {

    // Aggiorna lo stato di tutti i suoni.
    for (final sound in naturalSounds) {
      sound.isSelected = false;
    }
    if(generator.naturalSound != null){
      if(generator.naturalSound == naturalSound){
        generator.naturalSound = null;
        naturalSound.isSelected = false;
      } else {
        generator.naturalSound = naturalSound;
        naturalSound.isSelected = true;
      }
    } else {
      generator.naturalSound = naturalSound;
      naturalSound.isSelected = true;
    }
    notifyListeners();
    play();
  }

  Future<void> playChakraSound(ChakraModel chakraSound) async {
    final audio = await BinauralAudioService.instance;

    final bool isAlreadyPlaying = chakraSound.isPlaying;

    // Aggiorna lo stato di tutti i suoni.
    for (final sound in chakraStore) {
      sound.isPlaying = false;
    }

    if (isAlreadyPlaying) {
      // Il suono cliccato era già attivo: lo fermiamo.
      await audio.stop();
    } else {
      // Attiva solo il suono selezionato.
      chakraSound.isPlaying = true;

      // Avvia il nuovo audio.
      await audio.play(
          leftFrequency: chakraSound.frequency, beatFrequency: chakraSound.hz, volume: 1
      );
    }
    notifyListeners();
  }

  void setBeats(double beats){
    generator.beat = beats;
    generator.isPlaying = false;
    BinauralAudioService.instance.stop();
    audio.stop();
    notifyListeners();
  }
}