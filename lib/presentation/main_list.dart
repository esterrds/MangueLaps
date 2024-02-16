import 'package:mangue_laps/bloc/Connectivity/connectivity_cubit.dart';
//import 'package:mangue_laps/bloc/TimerCubit/timer_cubit.dart';
import 'package:mangue_laps/config/const/connectivity.dart';
//import 'package:mangue_laps/presentation/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../bloc/ContadorCubit/contador_cubit.dart';
import '../config/navigator/routes.dart';
import '../repo/models/car.dart';

//página do contador

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  CarRepository carRepo = CarRepository();
  List<Carro> carros = [];

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
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);
    //TimerCubit tCubit = BlocProvider.of<TimerCubit>(context);

    cubit.setCarList(carros);

    return BlocBuilder<ContadorCubit, ContadorState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            //organização dos itens na lista
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Builder(builder: (context) {
                  return Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 100,
                      child: Dismissible(
                        //excluir itens da lista
                        background: deleteBgItem(),
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          var equipes = cubit.carList[index];
                          cubit.carList.removeAt(index);
                          cubit.rebuild();
                          carRepo.saveCarList(carros);
                          final snackBar = SnackBar(
                            content: const Text('Carro removido.'),

                            //desfazer ação
                            action: SnackBarAction(
                              label: 'Desfazer',
                              onPressed: () {
                                undoDelete(index, equipes);
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Row(
                          //organização da lista
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cubit.pressedIndex = index;
                                });
                                Navigator.pushNamed(context, detailsPage);
                              },
                              child: Text(
                                  '${cubit.carList[index].nome} #${cubit.carList[index].numero}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    //color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ));
                });
              },
              //adicionar equipe registrada na lista
              itemCount: cubit.getListLenght(),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        );
      },
    );
  }

  increment(ContadorCubit cubit, index) {
    cubit.carList[index].increment();
    carRepo.saveCarList(carros);
    cubit.rebuild();
  }

  decrement(ContadorCubit cubit, index) {
    cubit.carList[index].decrement();
    carRepo.saveCarList(carros);
    cubit.rebuild();
  }

  //ícone lixeira
  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  //desfazer item excluído
  undoDelete(index, equipes) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);
    setState(() {
      cubit.carList.insert(index, equipes);
      carRepo.saveCarList(carros);
      cubit.rebuild();
    });
  }

  //função de enviar dados individuais
  oneCar(index, ContadorCubit carCubit) {
    final builder = MqttClientPayloadBuilder();
    int? id;

    switch (carCubit.carList[index].numero) {
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
        //mangue baja
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

      //case 48:
      //  id = 64;
      //  break;

      //case 49:
      //  id = 65;
      //  break;

      //case 50:
      //  id = 66;
      //  break;

      //case 51:
      //  id = 67;
      //  break;

      //case 52:
      //  id = 68;
      //  break;

      //case 53:
      //  id = 69;
      //  break;

      //case 54:
      //  id = 70;
      //  break;

      //case 55:
      //  id = 71;
      //  break;

      //case 56:
      //  id = 72;
      //  break;

      //case 57:
      //  id = 73;
      //  break;

      //case 58:
      //  id = 74;
      //  break;

      //case 59:
      //  id = 75;
      //  break;

      //case 60:
      //  id = 76;
      //  break;

      //case 61:
      //  id = 77;
      //  break;

      //case 62:
      //  id = 78;
      //  break;

      //case 63:
      //  id = 79;
      //  break;

      //case 64:
      //  id = 80;
      //  break;

      //case 65:
      //  id = 81;
      //  break;

      //case 66:
      //  id = 82;
      //  break;

      //case 67:
      //  id = 83;
      //  break;

      //default:
    }

    builder.addString("$id,${carCubit.carList[index].voltas}");
    client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  }
}
