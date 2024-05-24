// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerController extends StateNotifier<bool> {
  TimerController() : super(false);

  void startStopTimer() {
    state = !state;
  }
}

final timerProvider =
    StateNotifierProvider<TimerController, bool>((ref) => TimerController());

class RunDetailsController extends StateNotifier<bool> {
  RunDetailsController() : super(false);

  void showHideRunDetails() {
    state = !state;
  }
}

final runDetailsProvider = StateNotifierProvider<RunDetailsController, bool>(
    (ref) => RunDetailsController());
