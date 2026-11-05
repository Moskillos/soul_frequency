import 'package:flutter/material.dart';
import 'package:soul_frequency/models/beat_model.dart';

List<BeatModel> beats = [
  BeatModel("Delta", 0.5, 4, Colors.deepPurple, "assets/delta.png", ["deepSleep", "regeneration", "healing"], "assets/1.png"),
  BeatModel("Theta", 4.1, 7, Colors.indigo, "assets/theta.png", ["deepMeditation", "creativity", "intuition"], "assets/2.png"),
  BeatModel("Alfa", 7.1, 12, Colors.green, "assets/alfa.png", ["relax", "balance", "health"], "assets/3.png"),
  BeatModel("Beta", 12.1, 30, Colors.yellow, "assets/beta.png", ["concentration", "mentalActivity", "diaryLife"], "assets/4.png"),
  BeatModel("Gamma", 30.1, 100, Colors.red, "assets/gamma.png", ["maxAttention", "learning", "highPerformance"], "assets/5.png"),
];