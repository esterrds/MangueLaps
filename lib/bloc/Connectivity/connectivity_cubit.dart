import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mangue_laps/bloc/ContadorCubit/contador_cubit.dart';
import 'package:mangue_laps/repo/models/car.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/const/connectivity.dart';

part 'connectivity_state.dart';

//início da comunicação com o MQTT

MqttClient client = MqttServerClient.withPort(mqttBroker, '', 1883);

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial()) {
    mqttConnect();
  }
  bool flag = true;
  SharedPreferences? sharedPreferences;

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

  //manda lista completa para o broker
  void publishTest(ContadorCubit carCubit) {
    final builder = MqttClientPayloadBuilder();
    List<Carro> carList = carCubit.carList;

    builder.addString("$carList");
    client.publishMessage(mqttPubTopic2, MqttQos.atLeastOnce, builder.payload!);
  }

  //desconectar
  void mqttDisconnect() {
    client.disconnect();
    emit(ConnectivityDisconnected());
  }
}
