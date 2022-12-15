import 'dart:convert';

import 'package:enduro_app/config/navigator/routes.dart';
import 'package:enduro_app/presentation/main_list.dart';
import 'package:enduro_app/presentation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class ViewPage extends StatelessWidget {
//   const ViewPage({super.key});

// //botão da tela principal para a tela de monitoramento
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Center(child: Text("Monitoramento")),
//           /*actions: <Widget>[
//             IconButton(
//               icon: Icon(
//                 Icons.home,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 // do something
//               },
//             )
//           ],*/
//         ),
//       ),
//     );
//   }
// }

class AddItemPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return AddItemPageState();
  }
}
class AddItemPageState extends State<AddItemPage>
{
  TextEditingController nameController = TextEditingController();
  String response = "NULL";
  createItem() async {
    var dataStr = jsonEncode({
      "command": "add_item",
      "name": nameController.text,
    });
    var url = Uri.parse("http://12.0.0.1/phpconnection/index.php" + dataStr);
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
            decoration: InputDecoration(
              labelText: "Nome"
            ),
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
}

class ViewPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return ViewPageState();
  }
}
class Item
{
  String id;
  String name;
  DateTime timestamp;
  Item(this.id, this.name, this.timestamp);
}
class ViewPageState extends State<ViewPage>
{
  List<Item> data = [];
  showAddItemPage()
  {
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
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
      jsonItems.forEach((item){
        this.data.add(Item(
          item['id'] as String,
          item['name'] as String,
          DateTime.parse(item['timestamp'] as String)
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Monitoramento")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: showAddItemPage,
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: refreshData,
            child: Text("Atualizar"),
          ),
          Column(
            children: data.map((item) => Text(item.name)).toList(),
          ),
        ],
      ),
    );
  }
  
}

