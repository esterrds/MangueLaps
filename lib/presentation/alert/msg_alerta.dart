import 'package:flutter/material.dart';

//biblioteca de AlertDialogs

selectCar(BuildContext context) {
  // configura o button
  Widget okButton = ElevatedButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: const Text("Boa, Bajeiro(a)!"),
    content: const Text("Você enviou um carro."),
    actions: [
      okButton,
    ],
  );
  // exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

//alerta de mensagem não enviada
alertFailed(BuildContext context) {
  // configura o button
  Widget okButton = ElevatedButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: const Text("Falha na conexão"),
    content: const Text("Verifique se o broker está ligado."),
    actions: [
      okButton,
    ],
  );
  // exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

//alerta de mensagem enviada
alertSucess(BuildContext context) {
  // configura o button
  Widget okButton = ElevatedButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: const Text("Boa, Bajeiro(a)!"),
    content: const Text("Seus carros foram enviados."),
    actions: [
      okButton,
    ],
  );
  // exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

wait(BuildContext context) {
  // configura o button
  Widget okButton = ElevatedButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: const Text("Espere um pouco"),
    content: const Text("Tentando conectar..."),
    actions: [
      okButton,
    ],
  );
  // exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}
