class TargetModel{
  String target;
  double leftFrequency;
  double beatFrequency;
  double volume;

  TargetModel(this.target, this.leftFrequency, this.beatFrequency, this.volume);
}

class FrequenciesModel {
  String group;
  List<TargetModel> targets;

  FrequenciesModel(this.group, this.targets);
}