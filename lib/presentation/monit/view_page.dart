import 'dart:convert';

import 'package:enduro_app/bloc/ContadorCubit/contador_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:enduro_app/presentation/monit/mysql_connection.dart';

class ViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewPageState();
  }
}

class ViewPageState extends State<ViewPage> {
  //teste mysql
  var db = Mysql();
  var id;
  var carro;
  var equipe;
  var voltas;

  void _getCustomer() {
    db.getConnection().then((conn) {
      String sql = 'SELECT * FROM Equipes;';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            id = row[0];
            carro = row[0];
            equipe = row[0];
            voltas = row[0];
          });
        }
      });
      conn.close();
    });
  }

  refreshData() async {
    var dataStr = jsonEncode(
        {"id": 'id', "carro": 'carro', "equipe": "equipe", "voltas": 'voltas'});
    var url = Uri.parse(
        "http://64.227.19.172/phpmyadmin/index.php?route=/sql&db=EnduroApp&table=Equipes&pos=0" +
            dataStr);
    var result = await http.get(url);
    setState(() {
      var jsonItems = jsonDecode(result.body) as List<dynamic>;
      jsonItems.forEach((item) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ContadorCubit cubit = BlocProvider.of<ContadorCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Monitoramento")),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _getCustomer,
            child: const Text("Atualizar"),
          ),
          const Text(
            '\nRelatório das Equipes:',
          ),
          Text(
            '\nAtualizações ${cubit.carList}\n',
            style: Theme.of(context).textTheme.bodyText1,
          ),

          //

          Column(
              //children: data.map((item) => Text(item.name)).toList(),
              ),
        ],
      ),
    );
  }
}
