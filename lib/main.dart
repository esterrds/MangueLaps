import 'package:appdowill/bloc/cubit/contador_cubit.dart';
import 'package:appdowill/config/navigator/routes.dart';
import 'package:appdowill/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/navigator/navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContadorCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: initRoute,
      ),
    );
  }
}
