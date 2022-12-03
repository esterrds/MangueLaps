import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:enduro_app/bloc/ContadorCubit/contador_cubit.dart';
import 'package:enduro_app/presentation/add_car.dart';
import 'package:enduro_app/repo/models/car.dart';
import 'package:enduro_app/repo/models/json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../config/const/connectivity.dart';

part 'connectivity_state.dart';

//início da comunicação com o MQTT

MqttClient client = MqttServerClient.withPort(mqttBroker, '', 1883);

class ConnectivityCubit extends Cubit<ConnectivityState> {
  JoaoManjador carRepo = JoaoManjador();
  ConnectivityCubit() : super(ConnectivityInitial()) {
    mqttConnect();
  }

  bool flag = true;

  void mqttConnect() async {
    //cadastro com o broker para a conexão iniciar
    client.logging(on: true);

    emit(ConnectivityLoading());

    client.setProtocolV311();
    client.keepAlivePeriod = 60;
    client.connectTimeoutPeriod = 2000;
    client.port = mqttPort;

    client.websocketProtocols = MqttClientConstants.protocolsMultipleDefault;

    try {
      await client.connect(mqttUsername, mqttPassword);
    } on NoConnectionException catch (_) {
      client.disconnect();
    } on SocketException catch (_) {
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
  }

//testes: mensagem enviada ao broker quando conectado
  void subTest() {
    client.subscribe(mqttPubTopic, MqttQos.atMostOnce);
    flag = !flag;
    emit(ConnectivityConnected());
  }

  void publishTest() {
    final builder = MqttClientPayloadBuilder();
    //builder.addString("${carros.numeroDoCarro},${carros.nomeDaEquipe}");
    ContadorCubit carro = ContadorCubit();
    int index = 0;
    if (index < carro.getListLenght()) {
      index++;
    }
    carro.getCars();
    print(CarAdder());
    builder.addString(
        "Equipes: {carro: ${carro.getCars()[index].numeroDoCarro.toString()}, equipe: ${carro.getCars()[index].nomeDaEquipe}}");
    client.publishMessage(mqttPubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

//desconectar
  void mqttDisconnect() {
    client.disconnect();
    emit(ConnectivityDisconnected());
  }
}

class Cadastros extends StatelessWidget {
  const Cadastros({super.key, required this.equipe});

  final Car equipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("info"),
      ),
      body: groupDetails(),
    );
  }

  groupDetails() {
    return {
      equipe.nomeDaEquipe,
      equipe.numeroDoCarro,
      equipe.getVoltas()
    };
  }
}
