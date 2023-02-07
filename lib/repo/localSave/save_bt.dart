import 'dart:convert';

import 'package:mangue_laps/repo/models/breaktime.dart';
import 'package:shared_preferences/shared_preferences.dart';

const breaktimeKey = 'breaklist';

class CarRepository {
  late SharedPreferences sharedPreferences;

  Future<List<BreakTime>> getCarList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(breaktimeKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => BreakTime.fromJson(e)).toList();
  }

  void saveCarList(List<BreakTime> breaktimes) {
    final String jsonString = json.encode(breaktimes);
    sharedPreferences.setString(breaktimeKey, jsonString);
  }
}
