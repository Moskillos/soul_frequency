import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/screens/akasha_screen.dart';
import 'package:soul_frequency/screens/astral_travel_screen.dart';
import 'package:soul_frequency/screens/centering_screen.dart';
import 'package:soul_frequency/screens/chakra_screens.dart';
import 'package:soul_frequency/screens/lucid_dream_screen.dart';
import 'package:soul_frequency/ui/home_card.dart';

import '../services/binaural_audio_service.dart';
import '../services/procedural_music_service.dart';


class HomeCardModel {
  String title;
  Widget screen;

  HomeCardModel(this.title, this.screen);
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final music = ProceduralMusicService.instance;

  List<HomeCardModel> services = [
    HomeCardModel("chakra", ChakraScreens()),
    HomeCardModel("astralTravel", AstralTravelScreen()),
    HomeCardModel("lucidDreams", LucidDreamScreen()),
    HomeCardModel("akashaRecords", AkashaScreen()),
    HomeCardModel("centering", CenteringScreen()),
  ];

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
          children: List.generate(services.length, (index) => HomeCard(model: services[index])),
        ),
      ),
    );
  }
}
