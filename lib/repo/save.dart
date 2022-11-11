import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdowill/presentation/add_car.dart';

const carListKey = 'car_list';

class CarRepository {
  late SharedPreferences sharedPreferences;

  Future<List> getCarList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(carListKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => CarRepository.fromJson(e)).toList();
  }

  void saveCarList(List<CarAdder> name, number) {
    final String jsonString = json.encode(name);
    //final String jsonString = json.encode(number);

    sharedPreferences.setString(carListKey, jsonString);
  }

  static fromJson(e) {}
}
