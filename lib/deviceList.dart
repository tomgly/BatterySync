import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // メソッドチャンネルを作成
  static const batteryChannel = MethodChannel('platform_method/battery');
  // バッテリーの残量
  String batteryLevel = 'Waiting...';

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.teal,
        //設定ページ移行
        actions: <Widget>[
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.settings, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //バッテリーの状態を表示
            Text('$batteryLevel%'),
          ]
        ),
      ),
      //デバイス追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.black),
        ),
        //backgroundColor: ,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}