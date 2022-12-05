import 'package:enduro_app/config/navigator/routes.dart';
import 'package:enduro_app/presentation/main_list.dart';
import 'package:enduro_app/presentation/nav_bar.dart';
import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key});

//botão da tela principal para a tela de cadastro (+)
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Monitoramento")),
          /*actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            )
          ],*/
        ),
      ),
    );
  }
}
