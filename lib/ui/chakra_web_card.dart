import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../costants/text_style.dart';
import '../models/chakra_model.dart';
import '../store/app_state.dart';

class ChakraWebCard extends StatefulWidget {
  final ChakraModel chakra;
  const ChakraWebCard({super.key, required this.chakra});

  @override
  State<ChakraWebCard> createState() => _ChakraWebCardState();
}

class _ChakraWebCardState extends State<ChakraWebCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await Provider.of<AppState>(context, listen: false).playChakraSound(widget.chakra);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            child: SvgPicture.asset(widget.chakra.isPlaying ? "assets/stop.svg" : "assets/play.svg", color: Colors.red,),
                          ),
                        ),
                        Text("Frequenza: ${widget.chakra.frequency}", style: whiteText10,),
                        Text("Hz: ${widget.chakra.hz}", style: whiteText10,),
                      ],
                    ),
                    SizedBox(width: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.chakra.chakra, style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                color: widget.chakra.color
                            )),
                            SizedBox(width: 10,),
                            Text(widget.chakra.variantName, style: white54Text16,),
                          ],
                        ),
                        Text(widget.chakra.targets, style: whiteText10,),
                        Text("Posizione: ${widget.chakra.position}", style: whiteText10,),

                        Text("Elemento: ${widget.chakra.element}", style: whiteText10,),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/book.svg", width: 20, color: Colors.yellow,),
                          SizedBox(width: 5,),
                          Text(widget.chakra.mudra.name, style: white54Text16w700,),
                        ],
                      ),
                      Text(widget.chakra.mudra.title, style: whiteText16w700,),
                      Text(widget.chakra.mudra.description, style: whiteText16,),
                    ],
                  ),
                )
              ],
            ),
            Image.asset(widget.chakra.image, width: 150,),
          ],
        )
    );
  }
}
