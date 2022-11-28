import 'package:enduro_app/bloc/Connectivity/connectivity_cubit.dart';
import 'package:enduro_app/config/navigator/routes.dart';
import 'package:enduro_app/repo/save.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enduro_app/config/preferences_keys.dart';

//3 tracinhos
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    //conexão mqtt
    ConnectivityCubit conCubit = BlocProvider.of<ConnectivityCubit>(context);
    return Drawer(
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          return ListView(
            children: [
              Container(
                color: Color.fromARGB(255, 80, 6, 150),
                height: 50,
                child: IconButton(
                  onPressed: () {
                    //liga e desliga conexão
                    if (state is ConnectivityDisconnected) {
                      conCubit.mqttConnect();
                    } else if (state is ConnectivityConnected) {
                      conCubit.mqttDisconnect();
                    } else {
                      conCubit.mqttConnect();
                    }
                  },
                  icon: state is ConnectivityDisconnected
                      ? const SizedBox(
                          //desconectado
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox(
                          //conectado
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.green,
                          ),
                        ),
                ),
              ),
              Container(
                //design do segundo container
                color: Color.fromARGB(255, 133, 99, 179),
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          //enviar mensagens
                          if (state is ConnectivityDisconnected) {
                            alertFailed(context);
                          } else if (state is ConnectivityConnected) {
                            conCubit.publishTest();
                            alertSucess(context);
                          } else {
                            wait(context);
                          }
                        },
                        icon: const Icon(Icons.airplane_ticket_outlined)),
                    IconButton(
                        onPressed: () {
                          print("buscando informações...");
                        },
                        icon: const Icon(Icons.cloud_download)),
                  ],
                ),
              ),
              Row(
                children: const [],
              ),
            ],
          );
        },
      ),
    );
  }
}

//alerta de mensagem não enviada
alertFailed(BuildContext context) {
  // configura o button
  Widget okButton = ElevatedButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pushNamed(context, initRoute);
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: const Text("Falha na conexão"),
    content: const Text("Sua mensagem não foi enviada."),
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
      Navigator.pushNamed(context, initRoute);
    },
  );
  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    title: const Text("Boa, Bajeiro(a)!"),
    content: const Text("Sua mensagem foi enviada com sucesso."),
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
      Navigator.pushNamed(context, initRoute);
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
