import 'dart:convert';

import 'package:mangue_laps/repo/models/gasolinetime.dart';
import 'package:shared_preferences/shared_preferences.dart';

const gasolinetimeKey = 'gasolinelist';

class CarRepository {
  late SharedPreferences sharedPreferences;

  Future<List<GasolineTime>> getCarList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(gasolinetimeKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => GasolineTime.fromJson(e)).toList();
  }

  void saveCarList(List<GasolineTime> gasolinetimes) {
    final String jsonString = json.encode(gasolinetimes);
    sharedPreferences.setString(gasolinetimeKey, jsonString);
  }
}
