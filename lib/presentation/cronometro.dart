import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangue_laps/presentation/colors.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  bool isMount = true;
  bool isStart = true;

  String _stopWatchText = '00:00:00';
  int getLapsLenght() => laps.length;

  final stopWatch = Stopwatch();
  final timeout = const Duration(seconds: 1);

  List laps = [];

  void _startTimeout() {
    Timer(timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setstopwatchText();
    });
  }

  void _startStopButtonPressed() {
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

  void _resetButtonPressed() {
    if (stopWatch.isRunning) {
      _startStopButtonPressed();
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

  void _addLaps() {
    String lap =
        "${stopWatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}";
    laps.add(lap);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Cronômetro")),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(children: <Widget>[
      Expanded(
          child: FittedBox(
        fit: BoxFit.none,
        child: Text(
          _stopWatchText,
          style: const TextStyle(fontSize: 50),
        ),
      )),
      //
      const SizedBox(height: 10.0),
      //
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
                    "Volta nº${index + 1}",
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  Text(
                    "${laps[index]}",
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  )
                ],
              ),
            );
          },
        ),
      ),
      //
      const SizedBox(height: 100.0),
      //
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: RawMaterialButton(
            onPressed: _startStopButtonPressed,
            shape:
                const OutlineInputBorder(borderSide: BorderSide(color: green)),
            child: Icon(
              isStart ? Icons.play_arrow : Icons.stop,
              color: isStart ? green : Colors.red,
            ),
          )),
          //
          const SizedBox(height: 10.0),
          //
          IconButton(
            onPressed: _addLaps,
            icon: const Icon(Icons.flag),
            color: green,
            iconSize: 40,
          ),

          const SizedBox(height: 10.0),
          //
          Expanded(
              child: RawMaterialButton(
            onPressed: _resetButtonPressed,
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
