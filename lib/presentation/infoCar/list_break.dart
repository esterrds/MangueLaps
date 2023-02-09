import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repo/localSave/save_bt.dart';
import '../colors.dart';

class ListBreakTime extends StatelessWidget {
  const ListBreakTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempo de box'),
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
  int _counter = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _prefs.getInt('counter') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
          _prefs.setInt('counter', _counter);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
