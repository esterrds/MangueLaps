import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/add_car.dart';
import 'package:mangue_laps/presentation/cronometro.dart';
import 'package:mangue_laps/presentation/home_page.dart';
import 'package:mangue_laps/presentation/infoCar/list_break.dart';
import 'package:mangue_laps/presentation/infoCar/list_gasoline.dart';
import 'package:mangue_laps/presentation/infoCar/list_times.dart';
import 'package:mangue_laps/presentation/nav_bar.dart';
import 'package:mangue_laps/presentation/monit/view_page.dart';
import 'package:flutter/material.dart';

import '../../presentation/infoCar/details_car.dart';

//chamada das páginas

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case carAdder:
        return MaterialPageRoute(builder: (_) => CarAdder());
      case navBar:
        return MaterialPageRoute(builder: (_) => const NavBar());
      case viewPage:
        return MaterialPageRoute(builder: (_) => ViewPage());
      case timePage:
        return MaterialPageRoute(builder: (_) => const TimePage());
      case detailsPage:
        return MaterialPageRoute(builder: (_) => const DetailsCar());
      case listTimes:
        return MaterialPageRoute(builder: (_) => const ListTimes());
      case breakTimes:
        return MaterialPageRoute(builder: (_) => const ListBreakTime());
      case gasolineTimes:
        return MaterialPageRoute(builder: (_) => const ListGasTime());
      default:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
    }
  }
}
