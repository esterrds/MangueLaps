import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repo/models/car.dart';

part 'contador_state.dart';

class ContadorCubit extends Cubit<ContadorState> {
  ContadorCubit() : super(ContadorInitial());

  List<Car> _carList = [];

  int getListLenght() => _carList.length;

  List<Car> getCars() => _carList;

  void createCar(int numero, String nome) {
    Car car = Car(numero, nome);
    _carList.add(car);
    emit(ContadorIdle());
  }

  void removeCar(Car car) {
    _carList.remove(car);
    emit(ContadorIdle());
  }

  // void cleanList(){
  //   _carList = [];
  // }

}
