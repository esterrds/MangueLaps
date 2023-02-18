import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/alert/msg_alerta.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:mangue_laps/repo/models/car.dart';
import '../bloc/ContadorCubit/contador_cubit.dart';

//tela de cadastro
class CarAdder extends StatefulWidget {
  CarAdder({super.key});

  @override
  State<CarAdder> createState() => _CarAdderState();
}

class _CarAdderState extends State<CarAdder> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  CarRepository carRepo = CarRepository();
  List<Carro> carros = [];
  Carro? deletedCarro;
  int? deletedCarroPos;

  @override
  void initState() {
    super.initState();
    carRepo.getCarList().then((value) {
      setState(() {
        carros = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text(
      //   "Adicione um Carro",
      //   textAlign: TextAlign.center,
      // )),
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
                        hintText: "Ex.: Mangue Baja"),
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
                        hintText: "Ex.: 50"),
                  ),
                ),
              ],
            ),

            //botão de confirmar, manda os dados cadastrados para o contador
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.toString().isNotEmpty &&
                      numberController.toString().isNotEmpty) {
                    BlocProvider.of<ContadorCubit>(context).createCar(
                        int.parse(numberController.text),
                        nameController.text,
                        0);

                    Carro newCarro = Carro(
                        nome: nameController.text,
                        numero: int.parse(numberController.text),
                        voltas: 0);
                    carros.add(newCarro);
                    carRepo.saveCarList(carros);
                    nameController.clear();
                    numberController.clear();
                    /*print(
                          "carro: ${numberController.text}, equipe: ${nameController.text}");*/
                    Navigator.pushNamed(context, carList);
                  } else if (nameController.toString().isNotEmpty) {
                    nomeVazio(context);
                  } else if (numberController.toString().isNotEmpty) {
                    numeroVazio(context);
                  }
                },
                child: const Text('GO!'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, viewPage);
                },
                child: const Text('MONITORAMENTO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
