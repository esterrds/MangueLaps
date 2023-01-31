import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/preferences_keys.dart';

class Timer {
  String horas = "00";
  String minutos = "00";
  String segundos = "00";
  String relogio = "00:00:00";

  late SharedPreferences sharedPreferences;

  // Future<List<Timer>> getRelogio() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   final String jsonString =
  //       sharedPreferences.getString(PreferenceKeys.chave) ?? '[]';
  //   final List jsonDecoded = jsonDecode(jsonString) as List;

  //   print(jsonDecoded);

  //   return jsonDecoded.map((e) => Timer.fromJson(e)).toList();
  // }

  // void saveCarList(List<Timer> carros) {
  //   final String jsonString = json.encode(carros);
  //   sharedPreferences.setString(PreferenceKeys.chave, jsonString);
  // }
}
