import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mangue_laps/repo/repo_group.dart';

import 'design/colors.dart';

class ListViewCar extends StatefulWidget {
  const ListViewCar({super.key});

  @override
  State<ListViewCar> createState() => _ListViewCarState();
}

class _ListViewCarState extends State<ListViewCar> {
  late GroupRepository groupRepo;

  @override
  void initState() {
    super.initState();
    groupRepo = GroupRepository();
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
              icon: const Icon(Icons.swap_vert_circle_outlined))
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
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                      leading: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: verdeClarinho,
                            borderRadius: BorderRadius.circular(60 / 2),
                          ),
                          child: const Icon(Icons.no_crash_outlined,
                              color: green)),
                      title: Text(
                          '${grupo[index].equipe}#${grupo[index].carro}  -  v: ${grupo[index].voltas.padLeft(2, '0')} / t.v: ${grupo[index].tempovolta}'),
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
                          // IconButton(
                          //   icon: const Icon(Icons.info),
                          //   color: Colors.grey,
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, infoGroup);
                          //   },
                          // )
                        ],
                      )),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: grupo.length);
        },
      ),
    );
  }
}
