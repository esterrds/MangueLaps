import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/add_car.dart';
import 'package:mangue_laps/presentation/home_page.dart';
import 'package:mangue_laps/presentation/infoCar/list_break.dart';
import 'package:mangue_laps/presentation/infoCar/list_gasoline.dart';
import 'package:mangue_laps/presentation/infoCar/list_times.dart';
import 'package:mangue_laps/presentation/monit/infoGroup.dart';
import 'package:mangue_laps/presentation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:mangue_laps/presentation/monit/view_organizado.dart';

import '../../presentation/counter_list.dart';
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
        return MaterialPageRoute(builder: (_) => const ListViewCar());
      case carList:
        return MaterialPageRoute(builder: (_) => const CarPage());
      case detailsPage:
        return MaterialPageRoute(builder: (_) => DetailsCar());
      case listTimes:
        return MaterialPageRoute(builder: (_) => const ListTimes());
      case breakTimes:
        return MaterialPageRoute(builder: (_) => const ListBreakTime());
      case gasolineTimes:
        return MaterialPageRoute(builder: (_) => const ListGasTime());
      case infoGroup:
        return MaterialPageRoute(builder: (_) => const InfoGroup());
      default:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
    }
  }
}
