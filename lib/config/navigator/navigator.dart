import 'package:enduro_app/config/navigator/routes.dart';
import 'package:enduro_app/presentation/add_car.dart';
import 'package:enduro_app/presentation/home_page.dart';
import 'package:enduro_app/presentation/nav_bar.dart';
import 'package:enduro_app/presentation/view_page.dart';
import 'package:flutter/material.dart';

//chamada das páginas

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final Object? args = settings.arguments;

    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case carAdder:
        return MaterialPageRoute(builder: (_) => CarAdder());
      case navBar:
        return MaterialPageRoute(builder: (_) => const NavBar());
      case viewPage:
        return MaterialPageRoute(builder: (_) => ViewPage());
      default:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
    }
  }
}
