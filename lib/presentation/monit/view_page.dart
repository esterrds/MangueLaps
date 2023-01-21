import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//página de monitoramento
class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

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
  List<Item> data = [];
  String response = "Atualize para mais informações.";

  //recebe os dados da API e converte em Json
  refreshData() async {
    var url = Uri.parse("http://64.227.19.172:2023/");
    var result = await http.get(url);
    setState(() {
      data.clear();
      var jsonItems = jsonDecode(result.body) as List<dynamic>;
      jsonItems.forEach((item) {
        data.add(Item(item['id'] as String, item['carro'] as String,
            item['equipe'] as String, item['voltas'] as String));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoramento"),
      ),
      body: Column(
        children: <Widget>[
          //botão de atualizar
          ElevatedButton(
            onPressed: refreshData,
            child: const Text("Atualizar"),
          ),

          //informações listadas
          Column(
            children: data
                .map((item) => Text(
                    "Carro: ${item.numero} | Equipe: ${item.equipe} | Voltas: ${item.voltas}"))
                .toList(),
          )
        ],
      ),
    );
  }
}
