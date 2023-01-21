//estados de funcionamento (dados contador)

part of 'contador_cubit.dart';

@immutable
abstract class ContadorState {}

class ContadorInitial extends ContadorState {}

class ContadorIdle extends ContadorState {} // Frequently reset