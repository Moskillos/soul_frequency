import 'package:flutter/material.dart';
import 'package:soul_frequency/costants/text_style.dart';
import 'package:soul_frequency/screens/home.dart';

import '../services/app_localization_service.dart';

class HomeCard extends StatefulWidget {
  final HomeCardModel model;
  const HomeCard({super.key,required this.model});

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => widget.model.screen,
          ),
        );
      } ,
      child: Container(
        constraints: BoxConstraints(maxWidth: double.infinity, minWidth: 300),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white, width: 1),
          color: Colors.black.withOpacity(0.5),
          
        ),
          child: Text(AppLocalizations.of(context).translate(widget.model.title), style: whiteText16w700, textAlign: TextAlign.center,)),
    );
  }
}
