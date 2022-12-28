import 'package:flutter/material.dart';

const Color textColor = Color.fromRGBO(67, 247, 12, 97);
const Color deepestBlue = const Color.fromRGBO(0, 125, 83, 49);
const Color clearestBlue = Color.fromRGBO(0, 240, 92, 94);
const Color midBlue = Color.fromRGBO(11, 217, 142, 85);
const Color darkerBlue = Color.fromRGBO(12, 247, 236, 97);

Map<int, Color> color = const {
  50: Color.fromRGBO(0, 125, 83, .1),
  100: Color.fromRGBO(0, 125, 83, .2),
  200: Color.fromRGBO(0, 125, 83, .3),
  300: Color.fromRGBO(0, 125, 83, .4),
  400: Color.fromRGBO(0, 125, 83, .5),
  500: Color.fromRGBO(0, 125, 83, .6),
  600: Color.fromRGBO(0, 125, 83, .7),
  700: Color.fromRGBO(0, 125, 83, .8),
  800: Color.fromRGBO(0, 125, 83, .9),
  900: Color.fromRGBO(0, 125, 83, 1),
};

MaterialColor customMaterial = MaterialColor(0xFF0F380A, color);
