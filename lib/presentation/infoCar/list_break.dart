import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/repo/localSave/save_bt.dart';
import 'package:mangue_laps/repo/models/breaktime.dart';
import '../../bloc/TimerCubit/timer_cubit.dart';
import '../colors.dart';

class ListBreakTime extends StatelessWidget {
  const ListBreakTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tempo de box')),
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
  BreakTimeRepo timeRepo = BreakTimeRepo();
  List<BreakTime> breaktimes = [];

  @override
  void initState() {
    super.initState();

    timeRepo.getBreakTime().then((value) {
      setState(() {
        breaktimes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TimerCubit tCubit = BlocProvider.of<TimerCubit>(context);

    tCubit.setBreakList(breaktimes);

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
                          var equipes = tCubit.breakList[index];
                          tCubit.breakList.removeAt(index);
                          tCubit.rebuild();
                          timeRepo.saveBTList(breaktimes);
                          final snackBar = SnackBar(
                            content: const Text('Tempo de box removido.'),

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
                              tCubit.breakList[index].tempoBox,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ));
                });
              },
              //adicionar equipe registrada na lista
              itemCount: tCubit.getBreakListLenght(),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: green,
            child: const Icon(Icons.delete_forever_outlined),
            onPressed: () {
              tCubit.cleanListBT();
              timeRepo.saveBTList(tCubit.breakList);
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
      timeRepo.saveBTList(breaktimes);
      tcubit.rebuild();
    });
  }

  // oneCar(index, TimerCubit tCubit) {
  //   final builder = MqttClientPayloadBuilder();

  //    builder.addString("${tCubit.breakList[index]}");
  //   client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  // }
}
