import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int batteryLevel = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) {
        setState(() {
          _getBatteryInfo();
        });
      }
    );
  }

  Future<void> _getBatteryInfo() async {
    batteryLevel = await Battery().batteryLevel;
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
        onPressed: () {
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