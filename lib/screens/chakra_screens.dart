import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/costants/colors.dart';
import 'package:soul_frequency/models/chakra_model.dart';
import 'package:soul_frequency/store/app_state.dart';
import 'package:soul_frequency/ui/chakra_card.dart';
import 'package:soul_frequency/ui/chakra_web_card.dart';
import 'package:soul_frequency/utils/device_check.dart';

import '../costants/text_style.dart';
import '../services/binaural_audio_service.dart';

class ChakraScreens extends StatefulWidget {
  const ChakraScreens({super.key});

  @override
  State<ChakraScreens> createState() => _ChakraScreensState();
}

class _ChakraScreensState extends State<ChakraScreens> {
  @override
  Widget build(BuildContext context) {
    List<ChakraModel> chakraList = Provider.of<AppState>(context).chakraStore;
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              Image.asset("assets/radicamento.jpg", height: kIsWeb ? 500 : null,),
              Text("Chakra", style: whiteText80Corinthia,),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                    children: List.generate(chakraList.length, (index) => isBigScreen(context) ? ChakraWebCard(chakra: chakraList[index]) : ChakraCard(chakra: chakraList[index]))
                ),
              ),
            ],
          ),
            ),
      ) );
  }
}
