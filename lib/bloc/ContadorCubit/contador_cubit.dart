import 'package:bloc/bloc.dart';
import 'package:mangue_laps/repo/localSave/save_car.dart';
import 'package:mangue_laps/repo/models/car.dart';
import 'package:meta/meta.dart';

part 'contador_state.dart';

//trabalha com as listas registradas

class ContadorCubit extends Cubit<ContadorState> {
  CarRepository carRepo = CarRepository();
  ContadorCubit() : super(ContadorInitial());

  int? pressedIndex;
  List<Carro> carList = [];

  void setCarList(List<Carro> futureCarList) {
    carList = futureCarList;
  }

  int getListLenght() => carList.length;

  void createCar(int numero, String nome) {
    Carro carro = Carro(nome: nome, numero: numero);
    carList.add(carro);
    carRepo.saveCarList(carList);
    emit(ContadorIdle());
  }

  void retrieveCar() {}

  void removeCar(Carro carro) {
    carList.remove(carro);
    emit(ContadorIdle());
  }

  void rebuild() {
    emit(ContadorIdle());
  }

  void cleanList() {
    carList = [];
  }

  @override
  String toString() {
    return "Equipes: $carList";
  }

  void publishTest(List<Carro> selecionados) {}
}
