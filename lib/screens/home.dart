import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/colors.dart';

import '../services/binaural_audio_service.dart';
import '../services/procedural_music_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final music = ProceduralMusicService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kIsWeb ? "assets/home-web.jpg" : "assets/centratura-home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: Container(
                padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 1)
                  ),
                  child: Text("Percorso attivazione chakra")),
            )
          ],
        ),
      ),
    );
  }
}
