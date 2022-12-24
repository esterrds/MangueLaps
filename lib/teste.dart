import 'package:enduro_app/repo/models/car.dart';

void teste() {
  var networkData = {1: "String1", 2: "String2", 3: "String3"};

  myNewList() {
    return networkData.entries.map((e) {
      return e.value;
    }).toList();
  }

  print(myNewList());
}
