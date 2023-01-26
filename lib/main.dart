//bibliotecas
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:mangue_laps/bloc/Connectivity/connectivity_cubit.dart';
import 'package:mangue_laps/config/navigator/routes.dart';
import 'package:mangue_laps/presentation/colors.dart';
import 'package:mangue_laps/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/ContadorCubit/contador_cubit.dart';
import 'config/navigator/navigator.dart';

//início
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //tela inicial e cor
    return MultiBlocProvider(
      providers: [
        //chamada da página do contador
        BlocProvider(
          create: (context) => ContadorCubit(),
        ),
        //conexão mqtt
        BlocProvider(
          create: (context) => ConnectivityCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mangue Laps',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 125, 83, 49),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(secondary: Colors.blueAccent[700]),
        ),
        //chamada da animação
        home: const SplashScreen(),
        //próxima página
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: initRoute,
      ),
    );
  }
}

//Animação inicial
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: const [
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
