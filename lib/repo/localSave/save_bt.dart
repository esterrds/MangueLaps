import 'dart:convert';

import 'package:mangue_laps/repo/models/breaktime.dart';
import 'package:shared_preferences/shared_preferences.dart';

const breaktimeKey = 'breaklist';

class BreakTimeRepo {
  SharedPreferences? prefs1;

  Future<List<BreakTime>> getBreakTime() async {
    prefs1 = await SharedPreferences.getInstance();
    final String jsonString = prefs1?.getString(breaktimeKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => BreakTime.fromJson(e)).toList();
  }

  void saveBTList(List<BreakTime> breaktimes) {
    String jsonString = json.encode(breaktimes);
    prefs1?.setString(breaktimeKey, jsonString);
  }
}
