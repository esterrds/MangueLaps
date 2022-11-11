import 'package:appdowill/config/navigator/routes.dart';
import 'package:appdowill/presentation/add_car.dart';
import 'package:appdowill/presentation/home_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;

    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case carAdder:
        return MaterialPageRoute(builder: (_) => CarAdder());

      default:
        return MaterialPageRoute(builder: (_) => MyHomePage());
    }
  }
}
