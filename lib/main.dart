import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:soul_frequency/screens/binaural_generator_screen.dart';
import 'package:soul_frequency/screens/centering_screen.dart';
import 'package:soul_frequency/screens/chakra_screens.dart';
import 'package:soul_frequency/screens/home.dart';
import 'package:soul_frequency/services/app_localization_service.dart';
import 'package:soul_frequency/services/binaural_audio_service.dart';
import 'package:soul_frequency/store/app_state.dart';

import 'costants/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Soul Frequency',
        supportedLocales: const [
          Locale('it'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SoulFrequencyMode(),
      ),
    );
  }
}



List<String> menuIcons = [
  'home.svg',
  'truck.svg',
  'earth.svg',
  'preferences.svg',
];

List<String> menuIconsTitle(BuildContext context) {
  return [
    "Home",
    "Chakra",
    "Binaurale",
    "Centratura",
  ];
}

List<String> menuIconsSelected = [
  'assets/home.svg',
  'assets/chakra.svg',
  'assets/head-phone.svg',
  'assets/center.svg',
];

class SoulFrequencyMode extends StatefulWidget {
  const SoulFrequencyMode({super.key});

  @override
  State<SoulFrequencyMode> createState() => _SoulFrequencyModeState();
}

class _SoulFrequencyModeState extends State<SoulFrequencyMode> {
  int itemSelected = 0;

  List<Widget> screens = [
    Home(),
    ChakraScreens(),
    BinauralGeneratorScreen(),
    CenteringScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: screens[itemSelected]),
      bottomNavigationBar: _BottomBar(
        item: itemSelected,
        selected: itemSelected,
        onTap: (i) => setState(() => itemSelected = i),
      ),
    );
  }
}


class _BottomBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final int item;

  const _BottomBar(
      {required this.selected, required this.onTap, required this.item});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: menuColor,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(menuIcons.length, (i) {
          final bool isSelected = selected == i;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  SvgPicture.asset(menuIconsSelected[i], width: 50, color: isSelected ? Colors.yellow : Colors.white,),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}