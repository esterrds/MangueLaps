import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/colors.dart';
import 'package:mangue_laps/repo/localSave/save_bt.dart';
import 'package:mangue_laps/repo/localSave/save_geral_time.dart';
import 'package:mangue_laps/repo/localSave/save_gt.dart';
import 'package:mangue_laps/repo/models/breaktime.dart';
import 'package:mangue_laps/repo/models/gasolinetime.dart';
import 'package:mangue_laps/repo/models/lap_time.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../bloc/Connectivity/connectivity_cubit.dart';
import '../../bloc/ContadorCubit/contador_cubit.dart';
import '../../config/const/connectivity.dart';
import '../alert/msg_alerta.dart';

class DetailsCar extends StatefulWidget {
  const DetailsCar({super.key});

  @override
  State<DetailsCar> createState() => _DetailsCarState();
}

class _DetailsCarState extends State<DetailsCar> {
  LapTimeRepo lapRepo = LapTimeRepo();
  GasolineTimeRepo gasRepo = GasolineTimeRepo();
  BreakTimeRepo breakRepo = BreakTimeRepo();

  //chamada de classes
  late LapTime geral = LapTime(tempo: _stopWatchText);
  late BreakTime quebrado =
      BreakTime(tempoBox: breakTimeText, isbreak: isBreak);
  late GasolineTime gasolina =
      GasolineTime(tempoGasolina: gasolineTimeText, gasolina: isFull);

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
  int getLapsLength() => laps.length;

  //lista cronômetro geral
  List<LapTime> tempoGeral = [];
  int getGeralLength() => tempoGeral.length;

  //lista GT
  List<GasolineTime> gasolinetimes = [];
  int getGTLength() => gasolinetimes.length;

  //lista BT
  List<BreakTime> breaktimes = [];
  int getBTLength() => breaktimes.length;

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
          gasolineTime.stop();

          setState(() {
            isFull = true;

            GasolineTime newGT = GasolineTime(
                tempoGasolina: gasolineTimeText.toString(), gasolina: isFull);
            gasolinetimes.add(newGT);
          });
          gasRepo.saveGTList(gasolinetimes);
          print(gasolinetimes);

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
          gasolineTime.start();
          startGasolineTime();

          setState(() {
            isFull = false;

            GasolineTime newGT = GasolineTime(
                tempoGasolina: gasolineTimeText.toString(), gasolina: isFull);
            gasolinetimes.add(newGT);
          });
          gasRepo.saveGTList(gasolinetimes);

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
          breakTime.stop();

          setState(() {
            isBreak = false;

            BreakTime newBT =
                BreakTime(tempoBox: breakTimeText.toString(), isbreak: false);
            breaktimes.add(newBT);
          });
          breakRepo.saveBTList(breaktimes);
          print(breaktimes);

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

          setState(() {
            isBreak = true;

            BreakTime newBT =
                BreakTime(tempoBox: breakTimeText.toString(), isbreak: true);
            breaktimes.add(newBT);
            breakRepo.saveBTList(breaktimes);
          });

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
  }

  //tempo de conserto/box
  void _setBreakTimeText() {
    breakTimeText =
        '${breakTime.elapsed.inHours.toString().padLeft(2, '0')}:${(breakTime.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(breakTime.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  //adicionar voltas
  void addVoltas() {
    String lap =
        "${stopWatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}";
    laps.add(lap);
    setState(() {
      LapTime geral = LapTime(tempo: lap.toString());
      tempoGeral.add(geral);
    });
    lapRepo.saveLapTimes(tempoGeral);
    print(tempoGeral);
  }

  @override
  void initState() {
    super.initState();

    lapRepo.getLapTime().then((value) {
      setState(() {
        tempoGeral = value;
      });
    });

    gasRepo.getGasTime().then((value) {
      setState(() {
        gasolinetimes = value;
      });
    });

    breakRepo.getBreakTime().then((value) {
      setState(() {
        breaktimes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Detalhes")),
          actions: <Widget>[
            //botão teste
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, listTimes);
                },
                icon: const Icon(Icons.library_add)),
            //botão enviar dados
            IconButton(onPressed: () {}, icon: const Icon(Icons.send))
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            //Nome da equipe e numero do carro
            Expanded(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${cubit.carList[cubit.pressedIndex!].nome}#${cubit.carList[cubit.pressedIndex!].numero}",
                            style: const TextStyle(fontSize: 23),
                          )
                        ])),
              ),
            ),

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
              height: 100.0,
              decoration: BoxDecoration(
                color: verdeClarinho,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.builder(
                itemCount: getLapsLength(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Volta nº${index + 1}",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          "${laps[index]}",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //
            const SizedBox(height: 20.0),

            //Contador
            Center(
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: verdeClarinho,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (stopWatch.isRunning &&
                                  !gasolineTime.isRunning &&
                                  !breakTime.isRunning) {
                                cubit.carList[cubit.pressedIndex!].increment();
                                cubit.rebuild();
                              } else {
                                contaVolta(context);
                              }
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                        Text(
                          cubit.carList[cubit.pressedIndex!]
                              .getVoltas()
                              .toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            cubit.carList[cubit.pressedIndex!].decrement();
                          },
                          child: const Text(
                            '-',
                            style: TextStyle(
                                fontSize: 100,
                                color: Colors.black,
                                backgroundColor: green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //reset gasolina
                IconButton(
                  onPressed: () {
                    gasolineTime.reset();
                  },
                  icon: const Icon(Icons.replay),
                  color: Colors.red,
                  iconSize: 20,
                ),
                //Botão de gasolina
                Expanded(
                    child: RawMaterialButton(
                  onLongPress: () {
                    gasolineTime.reset();
                  },
                  onPressed: cabouGasolina,
                  shape: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  child: Icon(
                    isFull ? Icons.local_gas_station : Icons.local_gas_station,
                    color: isFull
                        ? green
                        : const Color.fromARGB(255, 231, 209, 11),
                  ),
                )),
                //
                const SizedBox(height: 10.0),

                //Botão de carro quebrado
                Expanded(
                    child: RawMaterialButton(
                  onLongPress: () {
                    breakTime.reset();
                  },
                  onPressed: carroQuebrou,
                  shape: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  child: Icon(isBreak ? Icons.build : Icons.build,
                      color: isBreak ? Colors.red : green),
                )),
                IconButton(
                  onPressed: () {
                    breakTime.reset();
                  },
                  icon: const Icon(Icons.replay),
                  color: Colors.red,
                  iconSize: 20,
                )
              ],
            )),

            //tempos de gasolina e quebra
            Expanded(
                child: FittedBox(
              fit: BoxFit.none,
              //18 espaços entre eles
              child: Text(
                "$gasolineTimeText                  $breakTimeText",
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
                    iconSize: 45,
                    onPressed: botaoReset,
                    icon: const Icon(Icons.replay, color: Colors.red)),
              ],
            )),
          ]),
        ),
      ),
    );
  }

  oneCar(index, ContadorCubit carCubit) {
    final builder = MqttClientPayloadBuilder();

    builder.addString(
        "${carCubit.carList[carCubit.pressedIndex!]},$isFull,$isBreak");
    client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  }
}
