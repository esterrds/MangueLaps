import 'package:enduro_app/bloc/Connectivity/connectivity_cubit.dart';
import 'package:enduro_app/config/const/connectivity.dart';
import 'package:enduro_app/presentation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../bloc/ContadorCubit/contador_cubit.dart';
import 'alert/msg_alerta.dart';

//página do contador

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

    return BlocBuilder<ContadorCubit, ContadorState>(
      builder: (context, state) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(cubit.carList[index].numeroDoCarro.toString(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(cubit.carList[index].nomeDaEquipe,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Text(
                          cubit.carList[index].getVoltas().toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        //botão de incremento
                        GestureDetector(
                          child: const Icon(
                            Icons.arrow_drop_up_sharp,
                            color: deepestBlue,
                          ),
                          onTap: () {
                            cubit.carList[index].increment();
                            cubit.rebuild();
                          },
                        ),
                        //botão de decremento
                        GestureDetector(
                          child: const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: deepestBlue,
                          ),
                          onTap: () {
                            cubit.carList[index].decrement();
                            cubit.rebuild();
                          },
                        ),
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
                  ),
                );
              });
            },
            //adicionar equipe registrada na lista
            itemCount: cubit.getListLenght(),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        );
      },
    );
  }

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

  undoDelete(index, equipes) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);
    setState(() {
      cubit.carList.insert(index, equipes);
    });
  }

  oneCar(index, ContadorCubit carCubit) {
    final builder = MqttClientPayloadBuilder();

    builder.addString("${carCubit.carList[index]}");
    client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  }
}
