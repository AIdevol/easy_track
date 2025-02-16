part of 'screen_launcher_bloc.dart';

sealed class ScreenLauncherState {}

class ScreenLauncherInitial extends ScreenLauncherState {}

class ScreenLauncherLoadingState extends ScreenLauncherState {}

class ScreenLauncherLoadedState extends ScreenLauncherState {}

class ScreenLauncherErrorState extends ScreenLauncherState {
  final String errorMessage;

  ScreenLauncherErrorState(this.errorMessage);
}
