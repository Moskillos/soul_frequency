import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../costants/text_style.dart';
import '../models/beat_model.dart';
import '../services/app_localization_service.dart';
import '../store/app_state.dart';

class BeatsWebCard extends StatefulWidget {
  final BeatModel beat;
  const BeatsWebCard({super.key, required this.beat});

  @override
  State<BeatsWebCard> createState() => _BeatsWebCardState();
}

class _BeatsWebCardState extends State<BeatsWebCard> {
  @override
  Widget build(BuildContext context) {
    double beat = Provider.of<AppState>(context).generator.beat;

    bool isBeatSelected() {
      return beat >= widget.beat.min && beat <= widget.beat.max;
    }

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              opacity: isBeatSelected() ? 1 : 0.4,
              image: AssetImage(widget.beat.image),
              fit: BoxFit.cover,
            ),
            color: isBeatSelected() ? widget.beat.color : Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(widget.beat.name, style: whiteText16,),
                  Text("${widget.beat.min} - ${widget.beat.max} Hz", style: whiteText10,),
                ],
              ),
              Column(
                  children: List.generate(widget.beat.benefits.length, (index) => Text(AppLocalizations.of(context).translate(widget.beat.benefits[index], ), style: whiteText16,))
              )
            ],
          ),
        )
    );
  }
}
