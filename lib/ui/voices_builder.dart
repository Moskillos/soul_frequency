import 'package:flutter/material.dart';

import '../costants/colors.dart';
import '../costants/voices.dart';

class VoicesBuilder extends StatefulWidget {
  final String selectedVoice;
  final Function setVoice;
  const VoicesBuilder({super.key, required this.selectedVoice, required this.setVoice});

  @override
  State<VoicesBuilder> createState() => _VoicesBuilderState();
}

class _VoicesBuilderState extends State<VoicesBuilder> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Seleziona la voce che preferisci", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),),
          SizedBox(height: 10,),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: voices.map((voice) {
              final isSelected = voice.id == widget.selectedVoice;
              return InkWell(
                onTap: (){
                  widget.setVoice(voice.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : mainColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: mainColor.withValues(alpha: 0.2)),
                  ),
                  child: Text(voice.name, style: TextStyle(
                    color: isSelected ? mainColor : Colors.white,
                    fontSize: 15,
                  ),),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}