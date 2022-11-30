import 'package:enduro_app/config/navigator/routes.dart';
import 'package:enduro_app/presentation/main_list.dart';
import 'package:enduro_app/presentation/nav_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

//botão da tela principal para a tela de cadastro (+)
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavBar(),
        body: const MainList(),
        appBar: AppBar(
          title: const Center(child: Text("Contador de voltas")),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, carAdder);
          },
          child: const Icon(Icons.car_crash),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
