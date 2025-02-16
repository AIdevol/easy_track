import 'package:app_task/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsViewScreen extends StatefulWidget {
  const SettingsViewScreen({super.key});

  @override
  State<SettingsViewScreen> createState() => _SettingsViewScreenState();
}

class _SettingsViewScreenState extends State<SettingsViewScreen> {
  // State variables remain same as before
  bool analyticsEnabled = false;
  bool notificationsEnabled = false;
  bool locationEnabled = false;
  bool autoBackupEnabled = false;
  String selectedTheme = 'light';
  String selectedLanguage = 'English';
  String selectedDateFormat = 'DD/MM/YYYY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                // If we can't pop, navigate to your home route
                // Replace 'home' with your actual home route name
                context.go('/home');
                // Or if you're not using go_router:
                // Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('Settings',
            style: TextStyle(
                color: appColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white)),
        elevation: 0,
      ),
      body: _buildMainScreen(context),
    );
  }

  Widget _buildMainScreen(BuildContext context) {
    final cardColor = appColor.computeLuminance() > 0.5
        ? appColor.withOpacity(0.1)
        : appColor.withOpacity(0.3);
    final textColor =
        appColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsCard('Personalization',
                  _buildPersonalizationContent(), cardColor, textColor),
              const SizedBox(height: 16),
              _buildSettingsCard(
                  'Analytics', _buildAnalyticsContent(), cardColor, textColor),
              const SizedBox(height: 16),
              _buildSettingsCard(
                  'Appearance', _buildThemeContent(), cardColor, textColor),
              const SizedBox(height: 16),
              _buildSettingsCard('Notifications', _buildNotificationsContent(),
                  cardColor, textColor),
              const SizedBox(height: 16),
              _buildSettingsCard(
                  'Privacy', _buildPrivacyContent(), cardColor, textColor),
              const SizedBox(height: 16),
              _buildSettingsCard(
                  'Data Management', _buildDataContent(), cardColor, textColor),
              const SizedBox(height: 16),
              _buildSettingsCard(
                  'General', _buildGeneralContent(), cardColor, textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      String title, Widget content, Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  // Content building methods
  Widget _buildPersonalizationContent() {
    return Column(
      children: [
        _buildDropdown('Language', ['English', 'Spanish', 'French', 'German']),
        const SizedBox(height: 8),
        _buildDropdown(
            'Date Format', ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD']),
      ],
    );
  }

  Widget _buildAnalyticsContent() {
    return _buildSwitch('Usage Analytics', 'Help improve app experience',
        analyticsEnabled, (value) => setState(() => analyticsEnabled = value));
  }

  Widget _buildThemeContent() {
    return Column(
      children: ['Light', 'Dark', 'System']
          .map((theme) => _buildRadio(theme.toLowerCase(), theme, selectedTheme,
              (value) => setState(() => selectedTheme = value.toString())))
          .toList(),
    );
  }

  Widget _buildNotificationsContent() {
    return Column(
      children: [
        _buildSwitch('Push Notifications', '', notificationsEnabled,
            (value) => setState(() => notificationsEnabled = value)),
        _buildSettingsTile('Notification Categories', onTap: () {}),
      ],
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      children: [
        _buildSwitch('Location Services', '', locationEnabled,
            (value) => setState(() => locationEnabled = value)),
        _buildSettingsTile('Manage Permissions', onTap: () {}),
      ],
    );
  }

  Widget _buildDataContent() {
    return Column(
      children: [
        _buildSwitch('Auto Backup', '', autoBackupEnabled,
            (value) => setState(() => autoBackupEnabled = value)),
        _buildSettingsTile('Clear Cache', onTap: () {}),
        _buildSettingsTile('Export Data', onTap: () {}),
      ],
    );
  }

  Widget _buildGeneralContent() {
    return Column(
      children: [
        _buildSettingsTile('App Version', trailing: const Text('1.0.0')),
        _buildSettingsTile('Terms of Service', onTap: () {}),
        _buildSettingsTile('Privacy Policy', onTap: () {}),
        _buildSettingsTile('Help & Support', onTap: () {}),
      ],
    );
  }

  // Helper widgets
  Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: items[0],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {},
    );
  }

  Widget _buildSwitch(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildRadio(String value, String label, String groupValue,
      Function(dynamic) onChanged) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  Widget _buildSettingsTile(String title,
      {Widget? trailing, Function()? onTap}) {
    return ListTile(
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
