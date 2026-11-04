import 'dart:ui';

class MudraModel{
  String name;
  String title;
  String description;

  MudraModel(this.name, this.title, this.description);
}

class ChakraModel {
  String chakra;
  String variantName;
  String image;
  Color color;
  String targets;
  double frequency;
  double hz;
  String position;
  String element;
  bool isPlaying;
  MudraModel mudra;

  ChakraModel(this.chakra, this.variantName,this.image, this.color, this.targets, this.frequency, this.hz, this.position, this.element,this.isPlaying, this.mudra);
}