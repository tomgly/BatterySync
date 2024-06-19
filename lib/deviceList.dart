import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'settings.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // メソッドチャンネルを作成
  static const batteryChannel = MethodChannel('platform_method/battery');
  // アップデート間隔(秒)
  int updateSeconds= 10;
  // バッテリーの残量
  int batteryLevel = 0;
  // テーマカラー
  final Color themeColor = Colors.teal;
  // このデバイス情報
  late List<String> thisDevice;

  @override
  void initState() {
    super.initState();
    getBatteryInfo();
    thisDevice = UserPreferences.getDeviceInfo();
    Timer.periodic(
      Duration(seconds: updateSeconds),
          (Timer timer) {
        setState(() {
          getBatteryInfo();
        });
      }
    );
  }

  Future<void> getBatteryInfo() async {
    String devName = "Not...";
    int level = 0;

    try {
      final res =
      await batteryChannel.invokeMethod('getBatteryInfo');

      // プラットフォームからの結果を解析取得
      devName = res["device"];
      level = res["level"];
    } on PlatformException catch (e) {
      batteryLevel = -1;
    }

    // 画面を再描画する
    setState(() {
      batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BatterySync', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
        //設定ページ移行
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.black),
          )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: themeColor,
        onRefresh: () async {
          getBatteryInfo();
        },
        child: SingleChildScrollView(
          child: Column(children: <Widget> [
            Container(
              height: 200,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              decoration: BoxDecoration(
                color: themeColor,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Row(children: [
                Column(children: [
                  Text(thisDevice[1], style: const TextStyle(color: Colors.black)),
                  const Text('このデバイス', style: TextStyle(color: Colors.black))
                ]),
                const SizedBox(width: 30),
                Column(children: [
                  Container(
                    width:50,
                    height: 50,
                    margin: const EdgeInsets.all(20),
                    child: pieChart(batteryLevel.toDouble(), 20),
                  ),
                  Text('$batteryLevel%', style: const TextStyle(color: Colors.black)),
                ])
              ]),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              padding: const EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: const Text('devices', style: TextStyle(color: Colors.black)),
                    tileColor: themeColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(color: Colors.black),
                    ),
                    onTap: () async {
                    }
                  )
                );
              }
            )
          ])
        )
      ),
      //デバイス追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.black),
        ),
        backgroundColor: themeColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Color color(int level) {
    if (level > 20) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  PieChart pieChart(double level, double radius) =>
    PieChart(
      PieChartData(
        startDegreeOffset: 270,
        sectionsSpace: 0,
        centerSpaceRadius: radius % 40,
        sections: [
          PieChartSectionData(
              color: color(level.toInt()),
              value: level,
              title: '',
              radius: radius
          ),
          PieChartSectionData(
              color: Colors.white,
              value: 100 - level,
              title: '',
              radius: radius
          ),
        ],
      ),
    );
}