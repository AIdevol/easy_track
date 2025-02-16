import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final bool analyticsEnabled;
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool autoBackupEnabled;
  final String selectedTheme;
  final String selectedLanguage;
  final String selectedDateFormat;

  const SettingsState({
    this.analyticsEnabled = false,
    this.notificationsEnabled = false,
    this.locationEnabled = false,
    this.autoBackupEnabled = false,
    this.selectedTheme = 'light',
    this.selectedLanguage = 'English',
    this.selectedDateFormat = 'DD/MM/YYYY',
  });

  SettingsState copyWith({
    bool? analyticsEnabled,
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? autoBackupEnabled,
    String? selectedTheme,
    String? selectedLanguage,
    String? selectedDateFormat,
  }) {
    return SettingsState(
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedDateFormat: selectedDateFormat ?? this.selectedDateFormat,
    );
  }
}
