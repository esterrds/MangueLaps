import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mangue_laps/repo/groups.dart';

class GroupRepository extends ChangeNotifier {
  List<Group> groups = [];
  bool isSorted = false;

  GroupRepository() {
    refreshData();
  }

  sort() {
    if (!isSorted) {
      groups.sort((Group a, Group b) => a.voltas.compareTo(b.voltas));
      isSorted = true;
    } else {
      groups = groups.reversed.toList();
    }
    notifyListeners();
  }

  refreshData() async {
    var url = Uri.parse("http://64.227.19.172:2023/");
    var result = await http.get(url);

    final json = jsonDecode(result.body) as List;

    for (var grupo in json) {
      groups.add(Group(
          equipe: '${grupo['equipe']}',
          voltas: grupo['voltas'],
          abastecendo: grupo['abastecendo'],
          quebrado: grupo['quebrado']));
    }
  }
}
