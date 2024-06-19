import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String version;

  @override
  void initState() {
    super.initState();
    version = UserPreferences.getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.teal,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('バージョン'),
                  value: Text(version)
              ),
            ])
        ],
      ),
    );
  }
}

class UserPreferences {
  static late SharedPreferences _prefs;
  static late PackageInfo _packageInfo;

  static Future init() async => (
    _prefs = await SharedPreferences.getInstance(),
    _packageInfo = await PackageInfo.fromPlatform(),
  );

  static List<String> getDeviceInfo() =>
      _prefs.getStringList('deviceInfo') ?? ['unknown', 'unknown', 'unknown'];

  static String getVersion() =>
    _packageInfo.version;
}