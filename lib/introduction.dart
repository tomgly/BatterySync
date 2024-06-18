import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'deviceList.dart';
import 'settings.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {

  _afterIntroduction() {
    UserPreferences.setFirstLaunch();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return const ListPage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チュートリアル', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: OverBoard(
          pages: pages,
          showBullets: true,
          skipCallback: () {
            // SKIPを押した時の動作
            _afterIntroduction();
          },
          finishCallback: () {
            // FINISHを押した時の動作
            _afterIntroduction();
          },
        ),
      )
    );
  }

  final pages = [
    PageModel(
      color: const Color(0xFF95cedd),
      imageAssetPath: '',
      title: '文字を表示できます',
      body: '細かい説明をbodyに指定して書くことが出来ます',
      doAnimateImage: true
    ),
    PageModel.withChild(
      child: const Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Text('さあ、始めましょう', style: TextStyle(color: Colors.white, fontSize: 32))),
      color: const Color(0xFF5886d6),
      doAnimateChild: true
    )
  ];
}