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
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.target.image),
              fit: BoxFit.cover,
            ),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                ),
                child: Center(child: Text(widget.target.target, style: whiteText16,))),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                ),
                child: Center(child: Text("${widget.target.leftFrequency}Hz - ${widget.target.beatFrequency}bts", style: whiteText10,)))
          ],
        ),
      ),
    );
  }
}
