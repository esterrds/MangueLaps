import 'dart:convert';

import 'package:mangue_laps/repo/models/gasolinetime.dart';
import 'package:shared_preferences/shared_preferences.dart';

const gasolinetimeKey = 'gasolinelist';

class GasolineTimeRepo {
  SharedPreferences? prefs3;

  Future<List<GasolineTime>> getGasTime() async {
    prefs3 = await SharedPreferences.getInstance();
    final String jsonString = prefs3?.getString(gasolinetimeKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => GasolineTime.fromJson(e)).toList();
  }

  void saveGTList(List<GasolineTime> gasolinetimes) {
    String jsonString = json.encode(gasolinetimes);
    prefs3?.setString(gasolinetimeKey, jsonString);
  }
}
