import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mangue_laps/config/navigator/routes.dart';

import '../design/colors.dart';

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
      if (mounted) {
        setState(() {
          data.clear();
          var jsonItems = jsonDecode(result.body);

          data = jsonItems;
          isLoading = false;
        });
      }
    } else {
      data = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Monitoramento")),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.swap_vert_circle_outlined))
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (data.contains(null) || isLoading) {
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
    var voltas = 'V: ${index['voltas']}, ${index['tempovolta']}';
    var quebrado = '${index['quebrado']}';
    var tempoquebra = '${index['tempoquebra']}';
    var voltoupista = '${index['tempovoltapista']}';
    var abastecendo = '${index['abastecendo']}';
    var tempogas = '${index['tempogas']}';
    var tempovoltagas = '${index['tempovoltagas']}';

    bool isbreak = false;
    bool isempty = false;
    bool validation = false;

    if (quebrado == 'false') {
      isbreak = false;
    } else if (quebrado == 'true') {
      isbreak = true;
    }

    if (abastecendo == 'false') {
      isempty = false;
    } else if (abastecendo == 'true') {
      isempty = true;
    }

    if (isbreak == true && isempty == false) {
      validation = true;
    } else if (isempty == true && isbreak == false) {
      validation = true;
    } else {
      validation = false;
    }

    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              validation
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: verdeClarinho,
                        borderRadius: BorderRadius.circular(60 / 2),
                      ),
                      child: Icon(Icons.car_crash_outlined,
                          color: isempty
                              ? const Color.fromARGB(255, 230, 207, 5)
                              : Colors.red))
                  : Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: verdeClarinho,
                        borderRadius: BorderRadius.circular(60 / 2),
                      ),
                      child: const Icon(Icons.no_crash_outlined, color: green)),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 140,
                      child: Text(
                        '$equipe  -  $voltas',
                        style: const TextStyle(fontSize: 15),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'E.Gas: $tempogas / Parou: $tempoquebra',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 116, 114, 114),
                        fontSize: 13),
                  ),
                  Text(
                    'S.Gas: $tempovoltagas / Voltou: $voltoupista',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 116, 114, 114),
                        fontSize: 13),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.info),
                  //   color: Colors.grey,
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, infoGroup);
                  //   },
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
