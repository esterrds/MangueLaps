//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangue_laps/presentation/design/colors.dart';
//import 'package:mangue_laps/config/navigator/routes.dart';
//import 'package:mangue_laps/presentation/design/colors.dart';
import 'package:mangue_laps/presentation/main_list.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: defaultgreen,
          title: const Center(
              child: Text(
            "Lista de carros",
            style: TextStyle(color: Colors.white),
          )),
          iconTheme: const IconThemeData(color: Colors.white),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, carAdder);
          //       },
          //       icon: const Icon(Icons.add))
          // ],
        ),
        body: const MainList(),
      ),
    );
  }
}
