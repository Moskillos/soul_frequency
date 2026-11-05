import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isBigScreen(context){
  return kIsWeb && MediaQuery.widthOf(context) > 800;
}