import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mangue_laps/repo/repo_group.dart';
import 'package:http/http.dart' as http;

import '../design/colors.dart';

class ListViewCar extends StatefulWidget {
  const ListViewCar({super.key});

  @override
  State<ListViewCar> createState() => _ListViewCarState();
}

class _ListViewCarState extends State<ListViewCar> {
  late GroupRepository groupRepo;
  bool isLoading = false;
  bool tipo = false;
  final timeout = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    groupRepo = GroupRepository();
    refreshData();
  }

  update() {
    setState(() {
      groupRepo = GroupRepository();
    });
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
          isLoading = false;
        });
      }
    } else {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento'),
        actions: [
          IconButton(
              onPressed: () {
                groupRepo.sort();
              },
              icon: const Icon(Icons.swap_vert_circle_outlined)),
        ],
      ),
      body: AnimatedBuilder(
        animation: groupRepo,
        builder: (BuildContext context, Widget? child) {
          final grupo = groupRepo.groups;

          return (grupo.isEmpty)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async => await update(),
                  child: ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                          leading: (grupo[index].abastecendo == 'false')
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 207, 253, 207),
                                    borderRadius: BorderRadius.circular(60 / 2),
                                  ),
                                  child: Icon(
                                      grupo[index].quebrado == 'true'
                                          ? Icons.car_crash_outlined
                                          : Icons.no_crash_outlined,
                                      color: (grupo[index].quebrado == 'true'
                                          ? Colors.red
                                          : green)))
                              : Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 207, 253, 207),
                                    borderRadius: BorderRadius.circular(60 / 2),
                                  ),
                                  child: const Icon(Icons.car_crash_outlined,
                                      color: Color.fromARGB(255, 230, 207, 5))),
                          title: Text(
                              '${grupo[index].equipe}#${grupo[index].carro}  -  v: ${grupo[index].voltas.padLeft(2, '0')} / t.v: ${grupo[index].tempovolta}'),
                          textColor: (grupo[index].tipo == 'true')
                              ? Colors.purple
                              : Colors.black,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'E.Box: ${grupo[index].tempogas} / Parou: ${grupo[index].tempoquebra}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 116, 114, 114),
                                    fontSize: 13),
                              ),
                              Text(
                                'S.Box: ${grupo[index].tempovoltagas} / Voltou: ${grupo[index].voltoupista}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 116, 114, 114),
                                    fontSize: 13),
                              ),
                            ],
                          )),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: grupo.length),
                );
        },
      ),
    );
  }
}
