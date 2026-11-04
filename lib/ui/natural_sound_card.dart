import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/models/natural_sound_model.dart';
import 'package:soul_frequency/store/app_state.dart';

import '../services/ambient_audio_service.dart';

class NaturalSoundCard extends StatefulWidget {
  final int selectedIndex;
  final NaturalSoundModel nature;
  NaturalSoundCard({super.key, required this.nature, required this.selectedIndex});

  @override
  State<NaturalSoundCard> createState() => _NaturalSoundCardState();
}

class _NaturalSoundCardState extends State<NaturalSoundCard> {
  int? activeSoundIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()async{
        await Provider.of<AppState>(context, listen: false).setNaturalSound(widget.nature);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.nature.isSelected ? detailColor : menuColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Image.asset(
          widget.nature.image,
          width: 50,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
