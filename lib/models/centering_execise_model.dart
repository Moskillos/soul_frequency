import 'dart:ui';

class ExerciseModel{
  String name;
  String description;
  String duration;
  String position;
  List<String> steps;
  String benefits;
  String? note;

  ExerciseModel(this.name, this.description, this.duration, this.position, this.benefits, this.steps, {
    this.note
  });
}

class CenteringExerciseModel {
  String title;
  Color color;
  String description;
  String details;
  String image;
  List<ExerciseModel> exercises;

  CenteringExerciseModel(this.title,this.color, this.description,this.details, this.image, this.exercises);
}