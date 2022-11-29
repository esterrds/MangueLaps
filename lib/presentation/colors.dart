import 'package:flutter/material.dart';

const Color textColor = Color.fromRGBO(0, 125, 83, 49);
const Color deepestBlue = Color.fromRGBO(11, 222, 208, 87);
const Color clearestBlue = Color.fromRGBO(0, 195, 245, 96);
const Color midBlue = Color.fromRGBO(11, 124, 222, 87);
const Color darkerBlue = Color.fromRGBO(13, 78, 250, 98);

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
