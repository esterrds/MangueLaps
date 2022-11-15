import 'dart:convert';

// import 'package:enduro_app/config/preferences_keys.dart';
import 'package:enduro_app/repo/save.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/ContadorCubit/contador_cubit.dart';

//tela de cadastro

class CarAdder extends StatelessWidget {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final CarRepository carRepository = CarRepository();

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
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  //caixa para receber nome das equipes
                  Expanded(
                    child: TextField(
                      controller: _nameController,
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
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Numero",
                      ),
                    ),
                  ),
                ],
              ),
              //botão de confirmar, que manda os dados cadastrados para o contador
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.toString().isNotEmpty &&
                        _numberController.toString().isNotEmpty) {
                      BlocProvider.of<ContadorCubit>(context).createCar(
                        int.parse(_numberController.text),
                        _nameController.text,
                      );
                      Navigator.pop(context);
                    }
                    //repository.Equipes(carros);
                  },
                  child: const Text("Confirmar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //testes para armazenamento usando sharedPreferences

  // void _doConfirm() {
  //   User newUser =
  //       User(nome: _nameController.text, numero: _numberController.text);
  //   print(newUser);
  //   _saveUser(newUser);
  // }

  // void _saveUser(User user) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(PreferenceKeys.chave, json.encode(user.toJson()));
  // }
}
