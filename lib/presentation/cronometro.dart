import 'dart:async';

import 'package:flutter/material.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  bool isStart = true;
  String _stopWatchText = '00:00:00';
  final stopWatch = Stopwatch();
  final timeout = const Duration(seconds: 1);

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
          style: const TextStyle(fontSize: 72),
        ),
      )),
      Center(
          child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _startStopButtonPressed,
            child: Icon(isStart ? Icons.play_arrow : Icons.stop),
          ),
          ElevatedButton(
            onPressed: _resetButtonPressed,
            child: const Text('Resetar'),
          )
        ],
      )),
    ]);
  }
}
