import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/models/centering_execise_model.dart';
import 'package:soul_frequency/ui/exercise_details_card.dart';

class CenteringExerciseCard extends StatefulWidget {
  final CenteringExerciseModel centeringExercise;
  const CenteringExerciseCard({super.key, required this.centeringExercise});

  @override
  State<CenteringExerciseCard> createState() => _CenteringExerciseCardState();
}

class _CenteringExerciseCardState extends State<CenteringExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(widget.centeringExercise.image, width: 30, color: widget.centeringExercise.color,),
                SizedBox(width: 5,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.centeringExercise.title, style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: widget.centeringExercise.color
                      ),),
                      Text(widget.centeringExercise.description, style: white54Text16,)
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Text(widget.centeringExercise.details, style: whiteText14,),
          SizedBox(height: 10,),
          Column(
            children: List.generate(widget.centeringExercise.exercises.length, (index) => ExerciseDetailsCard(exerciseDetail: widget.centeringExercise.exercises[index])),
          )
        ],
      ),
    );
  }
}
