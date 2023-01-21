//estados de funcionamento (conexão)

part of 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityDisconnected extends ConnectivityState {}

class ConnectivityLoading extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {}
