import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/presentation/colors.dart';

import '../../bloc/ContadorCubit/contador_cubit.dart';

class DetailsCar extends StatefulWidget {
  const DetailsCar({super.key});

  @override
  State<DetailsCar> createState() => _DetailsCarState();
}

class _DetailsCarState extends State<DetailsCar> {
  bool isStart = true;
  bool isBreak = false;
  bool isFull = true;

  String _stopWatchText = '00:00:00';

  int getLapsLenght() => laps.length;

  final stopWatch = Stopwatch();
  final timeout = const Duration(seconds: 1);

  List laps = [];

  void _startTimeout() {
    Timer(timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (!mounted) {
      stopWatch.stop();
    } else {
      if (stopWatch.isRunning) {
        _startTimeout();
      }
      setState(() {});
    }
  }

  void botaoStartStop() {
    setState(() {
      if (stopWatch.isRunning) {
        isStart = true;
        stopWatch.stop();
      } else {
        isStart = false;
        stopWatch.start();
        _startTimeout();
      }
    });
  }

  void botaoReset() {
    if (stopWatch.isRunning) {
      botaoStartStop();
    }
    setState(() {
      stopWatch.reset();
      _setstopwatchText();
    });
  }

  void _setstopwatchText() {
    _stopWatchText =
        '${stopWatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void addVoltas() {
    String lap =
        "${stopWatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}";
    laps.add(lap);
  }

  void carroQuebrou() {
    setState(() {
      if (isBreak == false) {
        isBreak = true;
      } else {
        isBreak = false;
      }
    });
  }

  void cabouGasolina() {
    setState(() {
      if (isFull == true) {
        isFull = false;
      } else {
        isFull = true;
      }
    });
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
      const SizedBox(height: 10.0),
      //Tabela de tempo
      Container(
        height: 200.0,
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
      const SizedBox(height: 50.0),

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

      //
      const SizedBox(height: 50),

      //Botão de Start/Stop
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: RawMaterialButton(
            onPressed: botaoStartStop,
            shape:
                const OutlineInputBorder(borderSide: BorderSide(color: green)),
            child: Icon(
              isStart ? Icons.play_arrow : Icons.stop,
              color: isStart ? green : Colors.red,
            ),
          )),
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
          Expanded(
              child: RawMaterialButton(
            onPressed: botaoReset,
            fillColor: green,
            shape:
                const OutlineInputBorder(borderSide: BorderSide(color: green)),
            child: const Text('Resetar', style: TextStyle(color: Colors.white)),
          ))
        ],
      )),
    ]);
  }
}
