import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:enduro_app/presentation/monit/mysql_connection.dart';

class ViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewPageState();
  }
}

class Item {
  String id;
  String numero;
  String equipe;
  String voltas;
  Item(this.id, this.numero, this.equipe, this.voltas);
}

class ViewPageState extends State<ViewPage> {
  //teste mysql
  List<Item> data = [];
  String response = "Atualize para mais informações.";

  refreshData() async {
    var url = Uri.parse("http://64.227.19.172:2023/");
    var result = await http.get(url);
    setState(() {
      print(result.body);
      response = result.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitoramento"),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: refreshData,
            child: Text("Atualizar"),
          ),
          Text(response)
        ],
      ),
    );
  }
}
