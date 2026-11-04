import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/centering_exercises.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/ui/centering_exercise_card.dart';

import '../costants/text_style.dart';

class CenteringScreen extends StatefulWidget {
  const CenteringScreen({super.key});

  @override
  State<CenteringScreen> createState() => _CenteringScreenState();
}

class _CenteringScreenState extends State<CenteringScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Image.asset("assets/centratura.png"),
            Text("Centratura", style: whiteText50Corinthia),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: List.generate(centeringExercises.length, (index) => CenteringExerciseCard(centeringExercise: centeringExercises[index])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
