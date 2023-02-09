import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../colors.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List data = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  refreshData() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("http://64.227.19.172:2023/");
    var result = await http.get(url);

    if (result.statusCode == 200) {
      setState(() {
        data.clear();
        var jsonItems = jsonDecode(result.body);

        data = jsonItems;
        isLoading = false;
      });
    } else {
      data = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoramento"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (data.contains(null) || data.length < 0 || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(green),
      ));
    }
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return getCard(data[index]);
        });
  }

  Widget getCard(index) {
    var equipe = '${index['equipe']}#${index['carro']}';
    var voltas = 'Voltas: ${index['voltas']}';
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                  //FAZER VALIDAÇÃO PARA CARRO QUEBRADO E ABASTECENDO!!!
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: verdeClarinho,
                    borderRadius: BorderRadius.circular(60 / 2),
                  ),
                  child: const Icon(Icons.no_crash)),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 140,
                      child: Text(
                        equipe,
                        style: const TextStyle(fontSize: 17),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    voltas,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 116, 114, 114)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info),
                    color: Colors.grey,
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
