import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../bloc/Provider/timer_provider.dart';
import 'design/colors.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  var timer;

  @override
  void initState() {
    super.initState();
    timer = Provider.of<TimerProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            processBar(),
            const SizedBox(
              height: 40,
            ),
            homeScreenBody()
          ],
        ),
      ),
    );
  }

  Widget processBar() {
    var seconds = timer.seconds;
    var finaltime = 1800;

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: seconds / finaltime,
                  valueColor: const AlwaysStoppedAnimation(darkerGreen),
                  strokeWidth: 12,
                  backgroundColor: verdeClarinho,
                ),
                Center(
                  child: buildTime(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget homeScreenBody() {
    return Consumer<TimerProvider>(
      builder: (context, timeprovider, widget) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (timer.startEnable)
                    ? ElevatedButton(
                        onPressed: timer.startTimer,
                        child: const Text('Começar'),
                      )
                    : const ElevatedButton(
                        onPressed: null,
                        child: Text('Começar'),
                      ),
                (timer.stopEnable)
                    ? ElevatedButton(
                        onPressed: timer.stopTimer,
                        child: const Text('Parar'),
                      )
                    : const ElevatedButton(
                        onPressed: null,
                        child: Text('Parar'),
                      ),
                (timer.continueEnable)
                    ? ElevatedButton(
                        onPressed: timer.continueTimer,
                        child: const Text('Continuar'),
                      )
                    : const ElevatedButton(
                        onPressed: null,
                        child: Text('Continuar'),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildTime() {
    return Consumer<TimerProvider>(builder: (context, timeprovider, widget) {
      return Center(
        child: Text(
          '${timer.hour.toString().padLeft(2, '0')} : ${timer.minute.toString().padLeft(2, '0')} : ${timer.seconds.toString().padLeft(2, '0')} ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      );
    });
  }
}
