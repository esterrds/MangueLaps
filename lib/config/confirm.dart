// import 'package:appdowill/repo/save.dart';
// import 'package:flutter/material.dart';

// void showConfirmationDialog() {
//   var context;
//   showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             title: const Text('Confirmação'),
//             content: Text(
//                 'Deseja enviar o registro dos ${car.length} competidores ?'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     'Cancelar',
//                     style: TextStyle(color: Colors.red),
//                   )),
//               TextButton(
//                   onPressed: () {
//                     print(
//                         CarRepository.sharedPreferences.getString(carListKey));

//                     //Enviar os dados(em Json??) pra algum lugar
//                     //Navigator.of(context).pop(

//                     // MqttServerClient client = MqttServerClient('150.161.60.103', 'demo');
//                     // get client => null;
//                     // client.Subscribe();
//                     // client.PublisheMessager();
//                     //    );
//                   },
//                   child: const Text('Confirmar'))
//             ],
//           ));
// }
