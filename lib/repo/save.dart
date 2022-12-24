/*import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:enduro_app/config/preferences_keys.dart';
import 'package:enduro_app/repo/models/car.dart';

//repositório (salvar os dados em formato json)

class CarRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Car>> getCarList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(PreferenceKeys.chave) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;

    print(jsonDecoded);

    return jsonDecoded.map((e) => Car.fromJson(e, jsonString)).toList();
  }

  void saveCarList(List<Car> carros) {
    final String jsonString = json.encode(carros);
    sharedPreferences.setString(PreferenceKeys.chave, jsonString);
  }
}*/
