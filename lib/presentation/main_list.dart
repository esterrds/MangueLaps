import 'package:mangue_laps/bloc/Connectivity/connectivity_cubit.dart';
import 'package:mangue_laps/config/const/connectivity.dart';
import 'package:mangue_laps/presentation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../bloc/ContadorCubit/contador_cubit.dart';
import '../config/navigator/routes.dart';
import '../repo/models/car.dart';
import 'alert/msg_alerta.dart';

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

    cubit.setCarList(carros);
    carRepo.saveCarList(carros);

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
                            Text(
                              '${cubit.carList[index].numero}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),

                            TextButton(
                              onPressed: () {
                                setState(() {
                                  cubit.pressedIndex = index;

                                  Title(
                                      color: Colors.black,
                                      child: Text(cubit.carList[index].nome,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)));
                                });
                                Navigator.pushNamed(context, detailsPage);
                              },
                              child: Text(cubit.carList[index].nome,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Text(
                              cubit.carList[index].getVoltas().toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            //botão de incremento
                            GestureDetector(
                              child: const Icon(
                                Icons.arrow_drop_up_sharp,
                                color: darkerGreen,
                                size: 30,
                              ),
                              onTap: () {
                                setState(() {
                                  cubit.carList[index].increment();
                                  cubit.rebuild();
                                });
                              },
                            ),
                            //botão de decremento
                            GestureDetector(
                              child: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: darkerGreen,
                                size: 30,
                              ),
                              onTap: () {
                                setState(() {
                                  cubit.carList[index].decrement();
                                  cubit.rebuild();
                                });
                              },
                            ),
                            //botão de enviar dados individuais
                            GestureDetector(
                              child: const Icon(
                                Icons.send,
                                color: textColor,
                              ),
                              onTap: () {
                                if (client.connectionStatus!.state ==
                                    MqttConnectionState.connected) {
                                  selectCar(context);
                                  oneCar(index, cubit);
                                } else if (client.connectionStatus!.state ==
                                    MqttConnectionState.disconnected) {
                                  alertFailed(context);
                                }
                              },
                            )
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

  //desfazer item excluído
  undoDelete(index, equipes) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);
    setState(() {
      cubit.carList.insert(index, equipes);
    });
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

  //função de enviar dados individuais
  oneCar(index, ContadorCubit carCubit) {
    final builder = MqttClientPayloadBuilder();

    builder.addString("${carCubit.carList[index]}");
    client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  }
}
