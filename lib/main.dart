import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'deviceList.dart';
import 'introduction.dart';
import 'settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  final prefs = await SharedPreferences.getInstance();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late List<String> deviceInfoList;

  // 初回起動の時でfirst_launchが存在しなければtrueになる
  bool firstLaunch = prefs.getBool('first_launch') ?? true;

  // デバイス情報を取得
  if (Platform.isAndroid) {
    AndroidDeviceInfo info = await deviceInfo.androidInfo;
    deviceInfoList = [
      info.brand, info.model, info.id
    ];
  } else if (Platform.isIOS) {
    IosDeviceInfo info = await deviceInfo.iosInfo;
    deviceInfoList = [
      info.model, info.name, info.identifierForVendor.toString()
    ];
  }
  await prefs.setStringList('deviceInfo', deviceInfoList);
  print(deviceInfoList);

  runApp(MyApp(firstLaunch: firstLaunch));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.firstLaunch});
  final bool firstLaunch;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BatterySync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 初回起動の場合はIntroductionPageになり、でなければListPageになる
      home: firstLaunch ? const IntroductionPage() : const ListPage(),
    );
  }
}