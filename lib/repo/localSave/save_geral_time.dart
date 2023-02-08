import 'dart:convert';
import 'package:mangue_laps/repo/models/geral_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

const geralTimeKey = 'breaklist';

class GeralTimeRepo {
  SharedPreferences? prefs2;

  Future<List<GeralTime>> getGeralTime() async {
    prefs2 = await SharedPreferences.getInstance();
    final String jsonString = prefs2?.getString(geralTimeKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => GeralTime.fromJson(e)).toList();
  }

  void saveGeralTimes(List<GeralTime> geraltimes) {
    String jsonString = json.encode(geraltimes);
    prefs2?.setString(geralTimeKey, jsonString);
  }
}
