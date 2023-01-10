import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repo/models/car.dart';

part 'contador_state.dart';

//parte do código que trabalha com as listas registradas

class ContadorCubit extends Cubit<ContadorState> {
  ContadorCubit() : super(ContadorInitial());

  List<Car> carList = [];

  int getListLenght() => carList.length;

  void createCar(int numero, String nome) {
    Car car = Car(nome, numero);
    carList.add(car);
    emit(ContadorIdle());
  }

  void removeCar(Car car) {
    carList.remove(car);
    emit(ContadorIdle());
  }

  void rebuild() {
    emit(ContadorIdle());
  }

  //testes

  // void cleanList(){
  //   carList = [];
  // }
  @override
  String toString() {
    return "Equipes: $carList";
  }

  void publishTest(List<Car> selecionados) {}
}
