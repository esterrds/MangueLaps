import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ContadorCubit/contador_cubit.dart';

//tela de cadastro
class CarAdder extends StatelessWidget {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  CarAdder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Adicione um Carro",
        textAlign: TextAlign.center,
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Não use acentos ou caracteres especiais!"),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                //caixa para receber nome das equipes
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Equipe",
                    ),
                  ),
                ),

                //caixa para receber número do carro
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Número",
                    ),
                  ),
                ),
              ],
            ),

            //botão de confirmar, manda os dados cadastrados para o contador
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.toString().isNotEmpty &&
                      numberController.toString().isNotEmpty) {
                    BlocProvider.of<ContadorCubit>(context).createCar(
                      int.parse(numberController.text),
                      nameController.text,
                    );
                    /*print(
                          "carro: ${numberController.text}, equipe: ${nameController.text}");*/
                    Navigator.pop(context);
                  }
                },
                child: const Text("Confirmar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
