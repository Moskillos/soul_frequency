import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/models/centering_execise_model.dart';

class ExerciseDetailsCard extends StatefulWidget {
  final ExerciseModel exerciseDetail;
  const ExerciseDetailsCard({super.key, required this.exerciseDetail});

  @override
  State<ExerciseDetailsCard> createState() => _ExerciseDetailsCardState();
}

class _ExerciseDetailsCardState extends State<ExerciseDetailsCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: detailColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedRotation(
                  // turns: 0.5 corrisponde a 180 gradi (mezza rotazione)
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
                Text(widget.exerciseDetail.name, style: whiteText16,),
              ],
            ),
          ),
          if(isExpanded)Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.exerciseDetail.description, style: white54Text16,),
              Text("Durata: ${widget.exerciseDetail.duration}", style: white54Text16),
              Text("Posizione: ${widget.exerciseDetail.position}", style: white54Text16),
              SizedBox(height: 10,),
              Text("COME SI PRATICA", style: whiteText16w700),
              SizedBox(height: 5,),
              Column(
                children: List.generate(widget.exerciseDetail.steps.length, (index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${index + 1}", style: redText16,),
                    SizedBox(width: 10,),
                    Flexible(child: Text(widget.exerciseDetail.steps[index], style: white54Text16))

                  ],
                )),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: benefitColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  children: [
                    Text("BENEFICI", style: yellowText16,),
                    Text(widget.exerciseDetail.benefits, style: whiteText14,)
                  ],
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
