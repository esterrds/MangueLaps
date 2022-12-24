import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:enduro_app/presentation/monit/mysql_connection.dart';

/*class AddItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddItemPageState();
  }
}

class AddItemPageState extends State<AddItemPage> {
  TextEditingController nameController = TextEditingController();
  String response = "NULL";
  createItem() async {
    var dataStr = jsonEncode({
      "command": "add_item",
      "name": nameController.text,
    });
    var url = Uri.parse("http://64.227.19.172/flutter_php/index.php" + dataStr);
    var result = await http.get(url);
    setState(() {
      this.response = result.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Adicionar item")),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: this.nameController,
            decoration: InputDecoration(labelText: "Nome"),
          ),
          ElevatedButton(
            onPressed: createItem,
            child: Text("Criar"),
          ),
          Text(this.response),
        ],
      ),
    );
  }
}*/

class ViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewPageState();
  }
}

class Item {
  String id;
  String name;
  DateTime timestamp;
  Item(this.id, this.name, this.timestamp);
}

class ViewPageState extends State<ViewPage> {
  //teste mysql
  int _counter = 0;
  var db = new Mysql();
  var carro = 0;
  var equipe = '';
  var voltas = 0;

  void _getCustomer() {
    db.getConnection().then((conn) {
      String sql = 'select equipe from Equipes where id = 20;';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            carro = row[0];
            equipe = row[0];
            voltas = row[0];
          });
        }
      });
      conn.close();
    });
  }

  //

  /*List<Item> data = [];
  showAddItemPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddItemPage();
    }));
  }

  refreshData() async {
    var dataStr = jsonEncode({
      "command": "get_items",
    });
    var url = Uri.parse("http://12.0.0.1/phpconnection/index.php" + dataStr);
    var result = await http.get(url);
    setState(() {
      data.clear();
      var jsonItems = jsonDecode(result.body) as List<dynamic>;
      jsonItems.forEach((item) {
        this.data.add(Item(item['id'] as String, item['name'] as String,
            DateTime.parse(item['timestamp'] as String)));
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Monitoramento")),
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: showAddItemPage,
      ),*/
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _getCustomer,
            child: Text("Atualizar"),
          ),
          Text(
            'Relatório das Equipes:',
          ),
          Text(
            '$carro,$equipe,$voltas',
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
