import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/models/beat_model.dart';

import '../services/app_localization_service.dart';
import '../store/app_state.dart';

class BeatsCard extends StatefulWidget {
  final BeatModel beat;
  const BeatsCard({super.key, required this.beat});

  @override
  State<BeatsCard> createState() => _BeatsCardState();
}

class _BeatsCardState extends State<BeatsCard> {

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
      child: SizedBox()
    );
  }
}
