import 'dart:convert';

import 'package:mangue_laps/repo/models/car.dart';
import 'package:shared_preferences/shared_preferences.dart';

const carListKey = 'car_list';

class CarRepository {
  SharedPreferences? sharedPreferences;

  Future<List<Carro>> getCarList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences?.getString(carListKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Carro.fromJson(e)).toList();
  }

  void saveCarList(List<Carro> carros) {
    final String jsonString = json.encode(carros);
    sharedPreferences?.setString(carListKey, jsonString);
  }
}
