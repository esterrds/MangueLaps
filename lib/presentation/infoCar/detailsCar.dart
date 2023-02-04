import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/presentation/colors.dart';
import 'package:mangue_laps/repo/models/breakTime.dart';
import 'package:mangue_laps/repo/models/gasolineTime.dart';

import '../../bloc/ContadorCubit/contador_cubit.dart';

class DetailsCar extends StatefulWidget {
  const DetailsCar({super.key});

  @override
  State<DetailsCar> createState() => _DetailsCarState();
}

class _DetailsCarState extends State<DetailsCar> {
  //validação dos botões
  bool isMount = true;
  bool isStart = true;
  bool isBreak = false;
  bool isFull = true;

  //tempos
  String _stopWatchText = '00:00:00';
  String gasolineTimeText = '00:00:00';
  String breakTimeText = '00:00:00';

  //cronômetro geral
  final stopWatch = Stopwatch();
  final timeout = const Duration(seconds: 1);

  //cronômetro do abastecimento
  final gasolineTime = Stopwatch();
  final timeoutGT = const Duration(seconds: 1);

  //cronômetro do conserto/box
  final breakTime = Stopwatch();
  final timeoutBT = const Duration(seconds: 1);

  //lista de voltas
  List laps = [];
  int getLapsLenght() => laps.length;

  //lista GT
  List tempoG = [];
  int getGTLenght() => tempoG.length;

  //lista BT
  List tempoB = [];
  int getBTLenght() => tempoB.length;

  //tempo limite geral
  void _startTimeout() {
    Timer(timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (stopWatch.isRunning) {
      _startTimeout();
    }
    if (mounted) {
      setState(() {
        _setstopwatchText();
      });
    }
  }

  //tempo limite abastecimento
  void startGasolineTime() {
    Timer(timeoutGT, _handleTimeoutGT);
  }

  void _handleTimeoutGT() {
    if (gasolineTime.isRunning) {
      startGasolineTime();
    }
    setState(() {
      _setGasolineTimeText();
    });
  }

  //tempo limite conserto/box
  void startBreakTime() {
    Timer(timeoutBT, _handleTimeoutBT);
  }

  void _handleTimeoutBT() {
    if (breakTime.isRunning) {
      startBreakTime();
    }
    setState(() {
      _setBreakTimeText();
    });
  }

  void botaoStartStop() {
    setState(() {
      if (!breakTime.isRunning && !gasolineTime.isRunning) {
        if (stopWatch.isRunning) {
          isStart = true;
          stopWatch.stop();
        } else {
          isStart = false;
          stopWatch.start();
          _startTimeout();
        }
      }
    });
  }

  void cabouGasolina() {
    setState(() {
      if (_stopWatchText != '00:00:00' && !breakTime.isRunning) {
        if (gasolineTime.isRunning) {
          isFull = true;
          gasolineTime.stop();

          if (stopWatch.isRunning) {
            isStart = true;
            stopWatch.stop();
          } else if (stopWatch.isRunning && gasolineTime.isRunning) {
            stopWatch.stop();
          } else {
            isStart = false;
            stopWatch.start();
            _startTimeout();
          }
        } else {
          isFull = false;
          gasolineTime.start();
          startGasolineTime();

          if (stopWatch.isRunning) {
            isStart = true;
            stopWatch.stop();
          } else {
            isStart = false;
            stopWatch.start();
            _startTimeout();
          }
        }
      }
    });
  }

  void carroQuebrou() {
    setState(() {
      if (_stopWatchText != '00:00:00' && !gasolineTime.isRunning) {
        if (breakTime.isRunning) {
          isBreak = false;
          breakTime.stop();

          if (stopWatch.isRunning) {
            isStart = true;
            stopWatch.stop();
          } else if (stopWatch.isRunning && breakTime.isRunning) {
            stopWatch.stop();
          } else {
            isStart = false;
            stopWatch.start();
            _startTimeout();
          }
        } else {
          isBreak = true;
          breakTime.start();
          startBreakTime();

          if (stopWatch.isRunning) {
            isStart = true;
            stopWatch.stop();
          } else {
            isStart = false;
            stopWatch.start();
            _startTimeout();
          }
        }
      }
    });
  }

  //reset tempo geral
  void botaoReset() {
    if (stopWatch.isRunning) {
      botaoStartStop();
    }
    setState(() {
      stopWatch.reset();
      _setstopwatchText();
    });
  }

  //tempo geral
  void _setstopwatchText() {
    _stopWatchText =
        '${stopWatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  //tempo de abastecimento
  void _setGasolineTimeText() {
    gasolineTimeText =
        '${gasolineTime.elapsed.inHours.toString().padLeft(2, '0')}:${(gasolineTime.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(gasolineTime.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
    tempoG.add(gasolineTimeText);
  }

  //tempo de conserto/box
  void _setBreakTimeText() {
    breakTimeText =
        '${breakTime.elapsed.inHours.toString().padLeft(2, '0')}:${(breakTime.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(breakTime.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
    tempoB.add(breakTimeText);
  }

  //adicionar voltas
  void addVoltas() {
    String lap =
        "${stopWatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}";
    laps.add(lap);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Detalhes")),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

    return Column(children: <Widget>[
      //Nome da equipe e numero do carro
      Expanded(
          child: ListView.builder(
        itemCount: cubit.getListLenght(),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${cubit.carList[index].nomeDaEquipe}#${cubit.carList[index].numeroDoCarro}",
                        style: const TextStyle(fontSize: 25),
                      )
                    ])),
          );
        },
      )),

      //Cronômetro
      Expanded(
          child: FittedBox(
        fit: BoxFit.none,
        child: Text(
          _stopWatchText,
          style: const TextStyle(fontSize: 24),
        ),
      )),
      //
      const SizedBox(height: 3),
      //Tabela de tempo
      Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: verdeClarinho,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
          itemCount: getLapsLenght(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lap nº${index + 1}",
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  Text(
                    "${laps[index]}",
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      //
      const SizedBox(
        height: 10.0,
      ),
      const SizedBox(
        height: 20.0,
        child: Text('Voltas:'),
      ),

      //Contador
      Center(
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: verdeClarinho,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListView.builder(
            itemCount: cubit.getListLenght(),
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          cubit.carList[index].increment();
                          cubit.rebuild();
                        },
                        icon: const Icon(
                          Icons.arrow_drop_up_sharp,
                          color: darkerGreen,
                          size: 50,
                        ),
                      ),
                      Text(
                        cubit.carList[index].getVoltas().toString(),
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.carList[index].decrement();
                          cubit.rebuild();
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: darkerGreen,
                          size: 50,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),

      const SizedBox(height: 10),

      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Botão de gasolina
          Expanded(
              child: RawMaterialButton(
            onPressed: cabouGasolina,
            shape: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            child: Icon(
              isFull ? Icons.local_gas_station : Icons.local_gas_station,
              color: isFull ? green : const Color.fromARGB(255, 231, 209, 11),
            ),
          )),
          //
          const SizedBox(height: 10.0),

          //Botão de carro quebrado
          Expanded(
              child: RawMaterialButton(
            onPressed: carroQuebrou,
            shape: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            child: Icon(isBreak ? Icons.build : Icons.build,
                color: isBreak ? Colors.red : green),
          ))
        ],
      )),

      //tempos de gasolina e quebra
      Expanded(
          child: FittedBox(
        fit: BoxFit.none,
        //30 espaços entre eles
        child: Text(
          "$gasolineTimeText                              $breakTimeText",
          style: const TextStyle(fontSize: 22),
        ),
      )),

      const SizedBox(height: 10),

      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Botão de Start/Stop
          IconButton(
            iconSize: 60,
            onPressed: botaoStartStop,
            icon: Icon(
              isStart ? Icons.play_arrow : Icons.stop,
              color: isStart ? green : Colors.red,
            ),
          ),
          //
          const SizedBox(height: 10.0),

          //Botão de voltas
          IconButton(
            iconSize: 60,
            onPressed: addVoltas,
            icon: const Icon(Icons.flag),
            color: green,
          ),

          const SizedBox(height: 10.0),

          //Botão de reset
          IconButton(
              iconSize: 60,
              onPressed: botaoReset,
              icon: const Icon(Icons.replay, color: green)),
        ],
      )),
    ]);
  }
}
