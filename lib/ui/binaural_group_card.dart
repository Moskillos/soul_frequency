import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/costants/frequencies.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/ui/binaural_card.dart';

import '../models/frequencies_model.dart';

class BinauralGroupCard extends StatefulWidget {
  FrequenciesModel frequency;
  BinauralGroupCard({super.key, required this.frequency} );

  @override
  State<BinauralGroupCard> createState() => _BinauralGroupCardState();
}

class _BinauralGroupCardState extends State<BinauralGroupCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: backGroundColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))
            ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.frequency.group, textAlign: TextAlign.start, style: whiteText16,),
                SizedBox(height: 15,),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final columns = 3;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 9,
                        childAspectRatio: 1,
                      ),
                      itemCount: widget.frequency.targets.length,
                      itemBuilder: (context, index) {
                        return BinauralCard(target:widget.frequency.targets[index]);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
