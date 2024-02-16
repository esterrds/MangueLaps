import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/repo/localSave/save_gt.dart';
import 'package:mangue_laps/repo/models/gasolinetime.dart';

import '../../bloc/TimerCubit/timer_cubit.dart';
import '../design/colors.dart';

class ListGasTime extends StatelessWidget {
  const ListGasTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tempo de abastecimento')),
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
  GasolineTimeRepo timeRepo = GasolineTimeRepo();
  List<GasolineTime> gasolinetimes = [];

  @override
  void initState() {
    super.initState();

    timeRepo.getGasTime().then((value) {
      setState(() {
        gasolinetimes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TimerCubit tCubit = BlocProvider.of<TimerCubit>(context);

    tCubit.setGasList(gasolinetimes);

    return BlocBuilder<TimerCubit, TimerState>(
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
                          var equipes = tCubit.gasolineList[index];
                          tCubit.gasolineList.removeAt(index);
                          tCubit.rebuild();
                          timeRepo.saveGTList(gasolinetimes);
                          final snackBar = SnackBar(
                            content:
                                const Text('Tempo de abastecimento removido.'),

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
                              '${index + 1}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              tCubit.gasolineList[index].tempoGasolina,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ));
                });
              },
              //adicionar equipe registrada na lista
              itemCount: tCubit.getGasListLenght(),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: green,
            child: const Icon(Icons.delete_forever_outlined),
            onPressed: () {
              tCubit.cleanListGT();
              timeRepo.saveGTList(tCubit.gasolineList);
              tCubit.rebuild();
            },
          ),
        );
      },
    );
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
    TimerCubit tcubit = BlocProvider.of<TimerCubit>(context);
    setState(() {
      tcubit.breakList.insert(index, equipes);
      timeRepo.saveGTList(gasolinetimes);
      tcubit.rebuild();
    });
  }

  // oneCar(index, TimerCubit tCubit) {
  //   final builder = MqttClientPayloadBuilder();

  //    builder.addString("${tCubit.breakList[index]}");
  //   client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  // }
}
