class TargetModel{
  String target;
  double leftFrequency;
  double beatFrequency;
  double volume;
  String image;

  TargetModel(this.target, this.leftFrequency, this.beatFrequency, this.volume, this.image);
}

class FrequenciesModel {
  String group;
  List<TargetModel> targets;

  FrequenciesModel(this.group, this.targets);
}