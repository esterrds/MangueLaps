import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangue_laps/bloc/TimerCubit/timer_cubit.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/design/colors.dart';
import 'package:mangue_laps/repo/localSave/save_bt.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:mangue_laps/repo/localSave/save_geral_time.dart';
import 'package:mangue_laps/repo/localSave/save_gt.dart';
import 'package:mangue_laps/repo/models/breaktime.dart';
import 'package:mangue_laps/repo/models/gasolinetime.dart';
import 'package:mangue_laps/repo/models/lap_time.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../bloc/Connectivity/connectivity_cubit.dart';
import '../../bloc/ContadorCubit/contador_cubit.dart';
import '../../bloc/Provider/timer_provider.dart';
import '../../config/const/connectivity.dart';
import '../../repo/models/car.dart';
import '../alert/msg_alerta.dart';

class DetailsCar extends StatefulWidget {
  const DetailsCar({super.key});

  @override
  State<DetailsCar> createState() => _DetailsCarState();
}

class _DetailsCarState extends State<DetailsCar> {
  CarRepository carRepo = CarRepository();
  LapTimeRepo lapRepo = LapTimeRepo();
  GasolineTimeRepo gasRepo = GasolineTimeRepo();
  BreakTimeRepo breakRepo = BreakTimeRepo();

  var timer;
  var timenow = DateFormat('kk:mm:ss').format(DateTime.now());
  var lapResult;
  var gasResult;
  var breakResult;
  late int hourResult;
  late int minutesResult;
  late int secondsResult;

  //chamada de classes
  late LapTime geral = LapTime(tempo: _stopWatchText);
  late BreakTime quebrado = BreakTime(tempoBox: breakTimeText);
  late GasolineTime gasolina = GasolineTime(tempoGasolina: gasolineTimeText);

  //validação dos botões
  bool isMount = true;
  bool isStart = true;
  bool isBreak = false;
  bool isnotFull = false;

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
  List breaks = [];
  List gas = [];
  List hour = [];
  List minutes = [];
  List seconds = [];
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

  //lista de carros
  List<Carro> carros = [];

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
          //timer.stotTimer;
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
            isnotFull = false;

            GasolineTime newGT = GasolineTime(
              tempoGasolina: gasolineTimeText.toString(),
            );
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
            isnotFull = true;

            GasolineTime newGT = GasolineTime(
              tempoGasolina: gasolineTimeText.toString(),
            );
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

            BreakTime newBT = BreakTime(tempoBox: breakTimeText.toString());
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

            BreakTime newBT = BreakTime(tempoBox: breakTimeText.toString());
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
    int horas = stopWatch.elapsed.inHours;
    int minutos = stopWatch.elapsed.inMinutes % 60;
    int segundos = stopWatch.elapsed.inSeconds % 60;
    hour.add(horas);
    minutes.add(minutos);
    seconds.add(segundos);

    String lap =
        "${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}";
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

    //timer = Provider.of<TimerProvider>(context, listen: false);

    lapRepo.getLapTime().then((value1) {
      setState(() {
        tempoGeral = value1;
      });
    });

    gasRepo.getGasTime().then((value2) {
      setState(() {
        gasolinetimes = value2;
      });
    });

    breakRepo.getBreakTime().then((value3) {
      setState(() {
        breaktimes = value3;
      });
    });

    carRepo.getCarList().then((value) {
      carros = value;
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (!mounted) {
      stopWatch.stop();
      gasolineTime.stop();
      breakTime.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

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
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, viewPage);
                },
                icon: const Icon(Icons.monitor)),
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
                  if (index == 0) {
                    lapResult = laps[index];
                  } else if (index > 0) {
                    hourResult = hour[index] - hour[index - 1];
                    minutesResult = minutes[index] - minutes[index - 1];
                    secondsResult = seconds[index] - seconds[index - 1];

                    lapResult =
                        '${hourResult.toString().padLeft(2, '0')}:${minutesResult.toString().padLeft(2, '0')}:${secondsResult.toString().padLeft(2, '0')}';
                  }

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
                          "$lapResult",
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
                        // TextButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       if (stopWatch.isRunning &&
                        //           !gasolineTime.isRunning &&
                        //           !breakTime.isRunning) {
                        //         cubit.carList[cubit.pressedIndex!].increment();
                        //         carRepo.saveCarList(carros);
                        //         cubit.rebuild();

                        //         if (client.connectionStatus!.state ==
                        //             MqttConnectionState.connected) {
                        //           selectCar(context);
                        //           sendData(cubit.pressedIndex, cubit);
                        //         } else if (client.connectionStatus!.state ==
                        //             MqttConnectionState.disconnected) {
                        //           alertFailed(context);
                        //         }
                        //         cubit.rebuild();
                        //       } else {
                        //         contaVolta(context);
                        //       }
                        //     });
                        //   },
                        //   child: const Icon(Icons.add),
                        // ),
                        Text(
                          '                          Voltas: ${cubit.carList[cubit.pressedIndex!].getVoltas().toString()}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 17),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     cubit.carList[cubit.pressedIndex!].decrement();
                        //     carRepo.saveCarList(carros);
                        //     cubit.rebuild();

                        //     if (client.connectionStatus!.state ==
                        //         MqttConnectionState.connected) {
                        //       selectCar(context);
                        //       sendData(cubit.pressedIndex, cubit);
                        //     } else if (client.connectionStatus!.state ==
                        //         MqttConnectionState.disconnected) {
                        //       alertFailed(context);
                        //     }
                        //   },
                        //   child: const Text(
                        //     '-',
                        //     style: TextStyle(
                        //         fontSize: 100,
                        //         color: Colors.black,
                        //         backgroundColor: green),
                        //   ),
                        // ),
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
                  onPressed: () {
                    cabouGasolina();
                    if (client.connectionStatus!.state ==
                        MqttConnectionState.connected) {
                      selectCar(context);
                      sendData(cubit.pressedIndex, cubit);
                    } else if (client.connectionStatus!.state ==
                        MqttConnectionState.disconnected) {
                      alertFailed(context);
                    }
                  },
                  shape: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  child: Icon(
                    isnotFull
                        ? Icons.local_gas_station
                        : Icons.local_gas_station,
                    color: isnotFull
                        ? const Color.fromARGB(255, 231, 209, 11)
                        : green,
                  ),
                )),
                //
                const SizedBox(height: 10.0),

                //Botão de carro quebrado
                Expanded(
                    child: RawMaterialButton(
                  onPressed: () {
                    carroQuebrou();
                    if (client.connectionStatus!.state ==
                        MqttConnectionState.connected) {
                      selectCar(context);
                      sendData(cubit.pressedIndex, cubit);
                    } else if (client.connectionStatus!.state ==
                        MqttConnectionState.disconnected) {
                      alertFailed(context);
                    }
                  },
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
                  onPressed: () {
                    botaoStartStop();
                  },
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
                  onPressed: () {
                    addVoltas();
                    cubit.carList[cubit.pressedIndex!].increment();
                    carRepo.saveCarList(cubit.carList);
                    if (client.connectionStatus!.state ==
                        MqttConnectionState.connected) {
                      selectCar(context);
                      sendData(cubit.pressedIndex, cubit);
                    } else if (client.connectionStatus!.state ==
                        MqttConnectionState.disconnected) {
                      alertFailed(context);
                    }
                  },
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

  Widget buildTime() {
    return Consumer<TimerProvider>(builder: (context, timeprovider, widget) {
      return Center(
        child: Text(
          '${timer.hour.toString().padLeft(2, '0')} : ${timer.minute.toString().padLeft(2, '0')} : ${timer.seconds.toString().padLeft(2, '0')} ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 40,
          ),
        ),
      );
    });
  }

  sendData(index, ContadorCubit carCubit) {
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
    }

    if (isBreak == false &&
        isnotFull == false &&
        carCubit.carList[index].voltas > (0)) {
      builder.addString(
          "$id,${carCubit.carList[index].voltas},$lapResult, $isnotFull, cheio, $isBreak, nao");
    }

    if (isBreak == true) {
      builder.addString(
          "$id,${carCubit.carList[index].voltas}, parado, $isnotFull, cheio, $isBreak, ${DateFormat('kk:mm:ss').format(DateTime.now())}");
    }

    if (isnotFull == true) {
      builder.addString(
          "$id,${carCubit.carList[index].voltas}, parado, $isnotFull, ${DateFormat('kk:mm:ss').format(DateTime.now())}, $isBreak, nao");
    }
    client.publishMessage(mqttPubTopic3, MqttQos.atLeastOnce, builder.payload!);
  }
}
