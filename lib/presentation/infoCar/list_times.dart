import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/repo/localSave/save_geral_time.dart';
import 'package:mangue_laps/repo/models/lap_time.dart';

import '../../bloc/TimerCubit/timer_cubit.dart';
import '../design/colors.dart';

class ListTimes extends StatelessWidget {
  const ListTimes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tempo de volta')),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, breakTimes);
            },
            icon: const Icon(Icons.warning),
            color: Colors.red,
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, gasolineTimes);
              },
              icon: const Icon(Icons.local_gas_station),
              color: Colors.yellow)
        ],
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
  LapTimeRepo timeRepo = LapTimeRepo();
  List<LapTime> laptimes = [];

  @override
  void initState() {
    super.initState();

    timeRepo.getLapTime().then((value) {
      setState(() {
        laptimes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TimerCubit tCubit = BlocProvider.of<TimerCubit>(context);

    tCubit.setLapList(laptimes);

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
                          var equipes = tCubit.lapList[index];
                          tCubit.lapList.removeAt(index);
                          tCubit.rebuild();
                          timeRepo.saveLapTimes(laptimes);
                          final snackBar = SnackBar(
                            content: const Text('Tempo de volta removido.'),

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
                              tCubit.lapList[index].tempo,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ));
                });
              },
              //adicionar equipe registrada na lista
              itemCount: tCubit.getLapListLenght(),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: green,
            child: const Icon(Icons.delete_forever_outlined),
            onPressed: () {
              tCubit.cleanListLap();
              timeRepo.saveLapTimes(tCubit.lapList);
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
      tcubit.lapList.insert(index, equipes);
      timeRepo.saveLapTimes(laptimes);
      tcubit.rebuild();
    });
  }

  // oneCar(index, TimerCubit tCubit) {
  //   final builder = MqttClientPayloadBuilder();

  //    builder.addString("${tCubit.lapList[index]}");
  //   client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  // }
}
