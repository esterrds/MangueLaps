import 'dart:convert';
import 'package:mangue_laps/repo/models/lap_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

const lapTimeKey = 'breaklist';

class LapTimeRepo {
  SharedPreferences? prefs2;

  Future<List<LapTime>> getLapTime() async {
    prefs2 = await SharedPreferences.getInstance();
    final String jsonString = prefs2?.getString(lapTimeKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => LapTime.fromJson(e)).toList();
  }

  void saveLapTimes(List<LapTime> laptimes) {
    String jsonString = json.encode(laptimes);
    prefs2?.setString(lapTimeKey, jsonString);
  }
}
