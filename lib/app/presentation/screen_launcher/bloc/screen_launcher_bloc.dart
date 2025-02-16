import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';

part 'screen_launcher_event.dart';
part 'screen_launcher_state.dart';

class ScreenLauncherBloc
    extends Bloc<ScreenLauncherEvent, ScreenLauncherState> {
  final BuildContext context;
  ScreenLauncherBloc(this.context) : super(ScreenLauncherInitial()) {
    on<InitializeScreenLauncherEvent>((event, emit) async {
      try {
        emit(ScreenLauncherLoadingState());
        await Future.delayed(const Duration(seconds: 2));
        context.go('/login');
        emit(ScreenLauncherLoadedState());
      } catch (e) {
        emit(ScreenLauncherErrorState(e.toString()));
      }
    });
  }
}
