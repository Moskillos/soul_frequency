
enum LucidDreamTechnique {
  mild,
  realityCheck,
  wbtb,
  dreamJournal,
}

class LucidDreamModel {
  LucidDreamTechnique technique;
  double binauralFrequency;
  double soundFrequency;

  bool useBinaural;
  bool useProceduralMusic;
  bool useNaturalSounds;

  Duration preparationDuration;

  LucidDreamModel({
    this.technique = LucidDreamTechnique.mild,
    this.binauralFrequency = 6.0,
    this.soundFrequency = 432.0,
    this.useBinaural = true,
    this.useProceduralMusic = true,
    this.useNaturalSounds = false,
    this.preparationDuration = const Duration(minutes: 15),
  });
}