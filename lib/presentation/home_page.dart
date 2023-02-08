import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/main_list.dart';
import 'package:mangue_laps/presentation/nav_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
    _wichScreen();
  }

  Widget _wichScreen() {
    Widget retVal;

    switch (_selectIndex) {
      case 0:
        Navigator.pushNamed(context, carAdder);
        retVal = const Center(child: Text("adicione um carro"));
        break;
      case 1:
        Navigator.pushNamed(context, timePage);
        retVal = const Center(child: Text("cronometro"));
        break;
      case 2:
        Navigator.pushNamed(context, viewPage);
        retVal = const Center(child: Text("monitoramento"));
        break;
      case 3:
        Navigator.pushNamed(context, detailsPage);
        retVal = const Center(child: Text("detalhes"));
        break;
      default:
        retVal = const Center(child: Text("bem vindo(a)"));
    }
    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        body: const MainList(),
        appBar: AppBar(
          title: const Center(child: Text("Contador de voltas")),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                activeIcon: Icon(Icons.add),
                label: "Adicionar carro"),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled),
                activeIcon: Icon(Icons.access_time_filled),
                label: "Cronômetro"),
            BottomNavigationBarItem(
                icon: Icon(Icons.monitor),
                activeIcon: Icon(Icons.monitor),
                label: "Monitoramento")
          ],
          currentIndex: _selectIndex,
          onTap: _onItemTapped,
          showUnselectedLabels: false,
          unselectedIconTheme: const IconThemeData(color: Colors.green),
          selectedIconTheme: const IconThemeData(color: Colors.yellow),
          selectedLabelStyle: const TextStyle(color: Colors.grey),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
