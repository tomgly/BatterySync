import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  // バッテリーの残量
  String batteryLevel = 'Waiting...';
  // テーマカラー
  final Color themeColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    getBatteryInfo();
    Timer.periodic(
      const Duration(seconds: 10),
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
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    // 画面を再描画する
    setState(() {
      batteryLevel = level.toString();
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
        },
        child: SingleChildScrollView(
          child: Column(children: <Widget> [
            Container(
              height: 200,
              padding: const EdgeInsets.all(15),
              child: ListTile(
                title: Text('$batteryLevel%', style: const TextStyle(color: Colors.black)),
                tileColor: themeColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(color: Colors.black),
                ),
                onTap: () async {
                },
              ),
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
                    title: Text('$batteryLevel%', style: const TextStyle(color: Colors.black)),
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
}