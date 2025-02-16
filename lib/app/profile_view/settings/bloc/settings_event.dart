import 'package:flutter/material.dart';

@immutable
sealed class SettingsEvent {}

class UpdateAnalyticsEvent extends SettingsEvent {
  final bool enabled;
  UpdateAnalyticsEvent(this.enabled);
}

class UpdateNotificationsEvent extends SettingsEvent {
  final bool enabled;
  UpdateNotificationsEvent(this.enabled);
}

class UpdateLocationEvent extends SettingsEvent {
  final bool enabled;
  UpdateLocationEvent(this.enabled);
}

class UpdateAutoBackupEvent extends SettingsEvent {
  final bool enabled;
  UpdateAutoBackupEvent(this.enabled);
}

class UpdateThemeEvent extends SettingsEvent {
  final String theme;
  UpdateThemeEvent(this.theme);
}

class UpdateLanguageEvent extends SettingsEvent {
  final String language;
  UpdateLanguageEvent(this.language);
}

class UpdateDateFormatEvent extends SettingsEvent {
  final String format;
  UpdateDateFormatEvent(this.format);
}
