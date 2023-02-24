import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/add_car.dart';
import 'package:mangue_laps/presentation/cronometro.dart';
import 'package:mangue_laps/presentation/main_list.dart';
import 'package:mangue_laps/presentation/nav_bar.dart';
import 'package:flutter/material.dart';

import '../bloc/Connectivity/connectivity_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _selectIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectIndex = index;
  //   });
  //   _wichScreen();
  // }

  // Widget _wichScreen() {
  //   Widget retVal;

  //   switch (_selectIndex) {
  //     // case 0:
  //     //   Navigator.pushNamed(context, carAdder);
  //     //   retVal = const Center(child: Text("adicione um carro"));
  //     //   break;
  //     // case 0:
  //     //   Navigator.pushNamed(context, carList);
  //     //   retVal = const Center(child: Text("cronometro"));
  //     //   break;
  //     case 0:
  //       Navigator.pushNamed(context, viewPage);
  //       retVal = const Center(child: Text("monitoramento"));
  //       break;
  //     default:
  //       retVal = const Center(child: Text("bem vindo(a)"));
  //   }
  //   return retVal;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityCubit conCubit = BlocProvider.of<ConnectivityCubit>(context);
    conCubit.mqttConnect();

    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        body: CarAdder(),
        appBar: AppBar(
          title: const Center(child: Text("Adicione um carro")),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, carList);
                },
                icon: Icon(Icons.arrow_right))
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     // BottomNavigationBarItem(
        //     //     icon: Icon(Icons.add),
        //     //     activeIcon: Icon(Icons.add),
        //     //     label: "Adicionar carro"),
        //     // BottomNavigationBarItem(
        //     //     icon: Icon(Icons.format_list_bulleted_add),
        //     //     activeIcon: Icon(Icons.format_list_bulleted_add),
        //     //     label: "Contador de voltas"),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.monitor),
        //         activeIcon: Icon(Icons.monitor),
        //         label: "Monitoramento")
        //   ],
        //   currentIndex: _selectIndex,
        //   onTap: _onItemTapped,
        //   showUnselectedLabels: false,
        //   unselectedIconTheme: const IconThemeData(color: Colors.green),
        //   selectedIconTheme: const IconThemeData(color: Colors.yellow),
        //   selectedLabelStyle: const TextStyle(color: Colors.grey),
        //   backgroundColor: Colors.white,
      ),
    );
    //);
  }
}
