import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/models/frequencies_model.dart';

import '../store/app_state.dart';

class BinauralCard extends StatefulWidget {
  TargetModel target;
  BinauralCard({super.key, required this.target});

  @override
  State<BinauralCard> createState() => _BinauralCardState();
}

class _BinauralCardState extends State<BinauralCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Provider.of<AppState>(context, listen: false).setTarget(widget.target);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            Text(widget.target.target, style: whiteText16,),
            Text("${widget.target.leftFrequency}Hz - ${widget.target.beatFrequency}Hz", style: whiteText16,)
          ],
        ),
      ),
    );
  }
}
