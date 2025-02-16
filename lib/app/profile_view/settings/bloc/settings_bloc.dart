import 'package:app_task/app/profile_view/settings/bloc/settings_event.dart';
import 'package:app_task/app/profile_view/settings/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<UpdateAnalyticsEvent>(_onUpdateAnalytics);
    on<UpdateNotificationsEvent>(_onUpdateNotifications);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<UpdateAutoBackupEvent>(_onUpdateAutoBackup);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateDateFormatEvent>(_onUpdateDateFormat);
  }

  void _onUpdateAnalytics(
      UpdateAnalyticsEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(analyticsEnabled: event.enabled));
  }

  void _onUpdateNotifications(
      UpdateNotificationsEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }

  void _onUpdateLocation(
      UpdateLocationEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(locationEnabled: event.enabled));
  }

  void _onUpdateAutoBackup(
      UpdateAutoBackupEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(autoBackupEnabled: event.enabled));
  }

  void _onUpdateTheme(UpdateThemeEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(selectedTheme: event.theme));
  }

  void _onUpdateLanguage(
      UpdateLanguageEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(selectedLanguage: event.language));
  }

  void _onUpdateDateFormat(
      UpdateDateFormatEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(selectedDateFormat: event.format));
  }
}
