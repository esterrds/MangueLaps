import 'dart:async';

import 'package:flutter/material.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  String buttonText = 'Começar';
  String stopWatchText = '00:00:00';
  final stopWatch = Stopwatch();
  final timeout = const Duration(seconds: 1);

  void _startTimeout() {
    Timer(timeout, _handleTimeout);
  }

  void _handleTimeout() {
    if (stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {});
  }

  void _startStopButtonPressed() {
    setState(() {
      if (stopWatch.isRunning) {
        buttonText = 'Começar';
        stopWatch.stop();
      } else {
        buttonText = 'Parar';
        stopWatch.start();
        _startTimeout();
      }
    });
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
      Center(
          child: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: _startStopButtonPressed, child: Text(buttonText)),
          ElevatedButton(onPressed: () {}, child: Text('Resetar'))
        ],
      )),
      //Expanded(
      //child:
      //)
    ]);
  }
}
