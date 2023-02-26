//Animação inicial
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import '../home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/garrinha.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Image.asset(
          //   "assets/garrinha.png",
          //   width: 200,
          //   height: 200,
          // ),
          Text(
            'Mangue Laps',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
      backgroundColor: darkerGreen,
      nextScreen: const MyHomePage(),
      //splashIconSize: 100,
    );
  }
}
