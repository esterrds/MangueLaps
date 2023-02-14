import 'package:flutter/material.dart';
import 'package:mangue_laps/config/navigator/routes.dart';

import '../colors.dart';

class ListBreakTime extends StatelessWidget {
  const ListBreakTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempo de abastecimento'),
      ),
      body: const LisTileExample(),
    );
  }
}

class LisTileExample extends StatefulWidget {
  const LisTileExample({super.key});

  @override
  State<LisTileExample> createState() => _LisTileExampleState();
}

class _LisTileExampleState extends State<LisTileExample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      //organização dos itens na lista
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Builder(builder: (context) {
            return Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              child: Row(
                //organização da lista
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const Text(
                    '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  //botão de enviar dados individuais
                  GestureDetector(
                    child: const Icon(
                      Icons.send,
                      color: textColor,
                    ),
                    onTap: () {},
                  )
                ],
              ),
            );
          });
        },
        //adicionar equipe registrada na lista
        itemCount: 5,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
