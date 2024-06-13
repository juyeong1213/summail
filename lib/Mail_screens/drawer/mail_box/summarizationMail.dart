/*
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/drawer/mail_box/settings.dart';

class SumMailPage extends StatefulWidget {
  const SumMailPage({super.key});

  @override
  State<SumMailPage> createState() => _SumMailPageState();
}

class _SumMailPageState extends State<SumMailPage> {
  bool? isSummaryEnabled;

  @override
  void initState() {
    super.initState();
    _loadSummaryPreference();
  }

  _loadSummaryPreference() async {
    final prefs = await SharedPreferences.getInstance();
    // '_isSummaryEnabled' 키를 통해 저장된 값을 불러온다. 기본값은 'false'로 설정한다.
    bool? loadedIsSummaryEnabled = prefs.getBool('isSummaryEnabled');
    print("Loaded isSummaryEnabled: $loadedIsSummaryEnabled");
    setState(() {
      isSummaryEnabled = loadedIsSummaryEnabled ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 요약 활성화 상태에 따라 조건부 위젯을 반환한다.
    return Scaffold(
      appBar: AppBar(
        title: Text('요약 메일함'),
      ),
      body: Center(
        child: isSummaryEnabled == true
            ? Text('여기에 요약 메일 내용을 표시합니다.')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('이메일 요약이 비활성화 되어 있습니다.'),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: Text('설정으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}

*/
