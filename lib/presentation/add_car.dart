import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/alert/msg_alerta.dart';
import 'package:mangue_laps/presentation/design/colors.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:mangue_laps/repo/models/car.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../bloc/Connectivity/connectivity_cubit.dart';
import '../bloc/ContadorCubit/contador_cubit.dart';
import '../config/const/connectivity.dart';

//tela de cadastro
class CarAdder extends StatefulWidget {
  const CarAdder({super.key});

  @override
  State<CarAdder> createState() => _CarAdderState();
}

class _CarAdderState extends State<CarAdder> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool carController = false;
  bool typeCar = false;

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
                //validação 4x4
              ],
            ),

            //botão de confirmar, manda os dados cadastrados para o contador
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .01,
                ), //SizedBox
                const Text(
                  'Carro 4x4?',
                  style: TextStyle(fontSize: 17.0),
                ), //Text
                const SizedBox(width: 10), //SizedBox
                /** Checkbox Widget **/
                Checkbox(
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        typeCar = value;
                      });
                      carController = true;
                    } else {
                      setState(() {
                        typeCar = value!;
                      });
                      carController = false;
                    }
                  },
                  value: typeCar,
                  checkColor: darkerGreen,
                  activeColor: verdeClarinho,
                  hoverColor: Colors.black,
                  side: const BorderSide(
                    color: debugBlack, //your desire colour here
                    width: 3,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.toString().isNotEmpty &&
                          numberController.toString().isNotEmpty) {
                        BlocProvider.of<ContadorCubit>(context).createCar(
                            int.parse(numberController.text),
                            nameController.text,
                            0,
                            carController);

                        oneCar(int.parse(numberController.text), carController);

                        Carro newCarro = Carro(
                            nome: nameController.text,
                            numero: int.parse(numberController.text),
                            voltas: 0,
                            tipo: carController);
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
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 31, 180, 36)),
                      foregroundColor: MaterialStatePropertyAll(debugWhite),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, viewPage);
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 31, 180, 36)),
                  foregroundColor: MaterialStatePropertyAll(debugWhite),
                ),
                child: const Text('MONITORAMENTO'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //função de enviar dados individuais
  oneCar(numberController, tipo) {
    final builder = MqttClientPayloadBuilder();
    int? id;

    switch (numberController) {
      case 2:
        //tec ilha baja
        id = 18;
        break;

      case 3:
        //baja UEA
        id = 19;
        break;

      case 4:
        //sinuelo
        id = 20;
        break;

      case 5:
        //USTJ
        id = 21;
        break;

      case 6:
        //komiketo
        id = 22;
        break;

      case 7:
        //javalis
        id = 23;
        break;

      case 8:
        //SAE da frente
        id = 24;
        break;

      case 9:
        //carpoeira
        id = 25;
        break;

      case 10:
        //bumba meu baja
        id = 26;
        break;

      case 11:
        //rampage
        id = 27;
        break;

      case 12:
        //pato
        id = 28;
        break;

      case 13:
        //
        id = 29;
        break;

      case 14:
        //
        id = 30;
        break;

      case 15:
        //
        id = 31;
        break;

      case 16:
        //
        id = 32;
        break;

      case 17:
        //carkara
        id = 33;
        break;

      case 18:
        //
        id = 34;
        break;

      case 19:
        //
        id = 35;
        break;

      case 20:
        //
        id = 36;
        break;

      case 21:
        //
        id = 37;
        break;

      case 22:
        //
        id = 38;
        break;

      case 23:
        //
        id = 39;
        break;

      case 24:
        //
        id = 40;
        break;

      case 25:
        //
        id = 41;
        break;

      case 26:
        //
        id = 42;
        break;

      case 27:
        //
        id = 43;
        break;

      case 28:
        //
        id = 44;
        break;

      case 29:
        //
        id = 45;
        break;

      case 30:
        id = 46;
        break;

      case 31:
        id = 47;
        break;

      case 32:
        id = 48;
        break;

      case 33:
        id = 49;
        break;

      case 34:
        id = 50;
        break;

      case 35:
        id = 51;
        break;

      case 36:
        id = 52;
        break;

      case 37:
        id = 53;
        break;

      case 38:
        id = 54;
        break;

      case 39:
        id = 55;
        break;

      case 40:
        id = 56;
        break;

      case 41:
        id = 57;
        break;

      case 42:
        id = 58;
        break;

      case 43:
        id = 59;
        break;

      case 44:
        id = 60;
        break;

      case 45:
        id = 61;
        break;

      case 46:
        id = 62;
        break;

      case 47:
        id = 63;
        break;

      case 48:
        id = 64;
        break;

      case 49:
        id = 65;
        break;

      case 50:
        //mangue baja
        id = 66;
        break;

      case 51:
        id = 67;
        break;

      case 52:
        id = 68;
        break;

      case 53:
        id = 69;
        break;

      case 54:
        id = 70;
        break;

      case 55:
        id = 71;
        break;

      case 56:
        id = 72;
        break;

      case 57:
        id = 73;
        break;

      case 58:
        id = 74;
        break;

      case 59:
        id = 75;
        break;

      case 60:
        id = 76;
        break;

      case 61:
        id = 77;
        break;

      case 62:
        id = 78;
        break;

      case 63:
        id = 79;
        break;

      case 64:
        id = 80;
        break;

      case 65:
        id = 81;
        break;

      case 66:
        id = 82;
        break;

      case 67:
        id = 83;
        break;

      default:
        numeroErrado(context);
        break;
    }

    builder.addString("$id,$tipo");
    client.publishMessage(qporqTopic, MqttQos.atLeastOnce, builder.payload!);
  }
}
