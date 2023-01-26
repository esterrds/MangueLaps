import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/main_list.dart';
import 'package:mangue_laps/presentation/nav_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        body: const MainList(),
        appBar: AppBar(
          title: const Center(child: Text("Contador de voltas")),

          //botão da página de monitoramento
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.monitor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, viewPage);
                // do something
              },
            )
          ],
        ),

        //botão para tela de cadastro (inferior central)
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, carAdder);
          },
          child: const Icon(Icons.directions_car_filled),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
