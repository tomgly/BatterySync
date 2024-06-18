import 'package:flutter/material.dart';
import 'deviceList.dart';
import 'introduction.dart';
import 'settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  // 初回起動の時でfirst_launchが存在しなければtrueになる
  bool firstLaunch = UserPreferences.getFirstLaunch();
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