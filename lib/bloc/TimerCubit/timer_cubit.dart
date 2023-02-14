import 'package:bloc/bloc.dart';
import 'package:mangue_laps/repo/localSave/save_bt.dart';
import 'package:mangue_laps/repo/localSave/save_geral_time.dart';
import 'package:mangue_laps/repo/localSave/save_gt.dart';
import 'package:mangue_laps/repo/models/breaktime.dart';
import 'package:mangue_laps/repo/models/gasolinetime.dart';
import 'package:mangue_laps/repo/models/lap_time.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInit());

  BreakTimeRepo breakRepo = BreakTimeRepo();
  GasolineTimeRepo gasRepo = GasolineTimeRepo();
  LapTimeRepo lapRepo = LapTimeRepo();

  List<LapTime> lapList = [];
  List<GasolineTime> gasolineList = [];
  List<BreakTime> breakList = [];

  int getLapListLenght() => lapList.length;
  int getGasListLenght() => gasolineList.length;
  int getBreakListLenght() => breakList.length;

  void setLapList(List<LapTime> futureLapList) {
    lapList = futureLapList;
  }

  void setGasList(List<GasolineTime> futureGasList) {
    gasolineList = futureGasList;
  }

  void setBreakList(List<BreakTime> futureBreakList) {
    breakList = futureBreakList;
  }

  void createLap(String tempo) {
    LapTime laptime = LapTime(tempo: '');
    lapList.add(laptime);
    lapRepo.saveLapTimes(lapList);
    emit(TimerReset());
  }

  void createGas(bool gasolina, String tempoGas) {
    GasolineTime gastime =
        GasolineTime(gasolina: gasolina, tempoGasolina: tempoGas);
    gasolineList.add(gastime);
    gasRepo.saveGTList(gasolineList);
    emit(TimerReset());
  }

  void createBreak(bool isbreak, String tempobox) {
    BreakTime boxtime = BreakTime(isbreak: isbreak, tempoBox: tempobox);
    breakList.add(boxtime);
    breakRepo.saveBTList(breakList);
    emit(TimerReset());
  }

  void removeLapTime(LapTime lap) {
    lapList.remove(lap);
    emit(TimerReset());
  }

  void removeBreakTime(BreakTime breaktime) {
    breakList.remove(breaktime);
    emit(TimerReset());
  }

  void removeGasolineTime(GasolineTime gasoline) {
    gasolineList.remove(gasoline);
    emit(TimerReset());
  }

  void rebuild() {
    emit(TimerReset());
  }

  void cleanListGT() {
    gasolineList = [];
  }

  void cleanListBT() {
    breakList = [];
  }

  void cleanListLap() {
    lapList = [];
  }

  @override
  String toString() {
    return "[LapTime: {$lapList}; GasolineTime: {$gasolineList}; BreakTime: {$breakList}]";
  }

  void publishGT(List<GasolineTime> selecionados) {}
  void publishBT(List<BreakTime> selecionados) {}
  void publishVoltas(List<LapTime> selecionados) {}
}

// void dwdwdq
// while (1) {
//   CONTADOR++
//   SLEEP(1)
// }