/*import 'dart:convert';

import 'package:mangue_laps/repo/models/car.dart';
import 'package:shared_preferences/shared_preferences.dart';

const carListKey = 'car_list';

class CarRepository{
 
 late SharedPreferences sharedPreferences;

 Future<List<Car>> getCarList() async {
  sharedPreferences = await SharedPreferences.getInstance();
  final String jsonString = sharedPreferences.getString(carListKey) ?? '[]';
  final List jsonDecoded = jsonDecode(jsonString) as List;
  return jsonDecoded.map((e) => Car.fromJson(e)).toList();
 }
 
 void saveCarList(List<Car> carros){
    final String jsonString = json.encode(carros);
    sharedPreferences.setString(carListKey, jsonString);
 }
}*/