import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../colors.dart';

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
          RawMaterialButton(
            onPressed: refreshData,
            shape:
                const OutlineInputBorder(borderSide: BorderSide(color: green)),
            child: const Text("Atualizar"),
          ),

          //informações listadas
          Expanded(
            flex: 1000,
            child: Column(
              children: data
                  .map((item) =>
                      Text("${item.numero}#${item.equipe} - ${item.voltas}"))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
