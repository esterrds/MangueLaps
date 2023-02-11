part of 'timer_cubit.dart';

abstract class TimerState {}

class TimerInit extends TimerState {}

class TimerReset extends TimerState {}

class TimerPause extends TimerState {}
