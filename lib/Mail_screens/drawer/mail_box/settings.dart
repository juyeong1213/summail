import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:summail/Mail_screens/drawer/mail_box/summarization/SumMailPage.dart';

import '../../../main.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../drawer.dart';



class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSummaryEnabled = false;
  String emailLength = '50 자 이내'; // 이메일 길이를 문자열로 변경
  String summaryTone = '공식적';
  bool isThemeDark = false;
  bool isVoiceEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSummaryEnabled = prefs.getBool('isSummaryEnabled') ?? false;
      emailLength = prefs.getString('emailLength') ?? '50 자 이내';
      summaryTone = prefs.getString('summaryTone') ?? '공식적';
      isThemeDark = prefs.getBool('isThemeDark') ?? false;
      isVoiceEnabled = prefs.getBool('isVoiceEnabled') ?? false;
    });
  }

  _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSummaryEnabled', isSummaryEnabled);
    prefs.setString('emailLength', emailLength);
    prefs.setString('summaryTone', summaryTone);
    prefs.setBool('isThemeDark', isThemeDark);
    prefs.setBool('isVoiceEnabled', isVoiceEnabled);
  }

  _saveSettingsToServer() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/setting'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'emailLength': _convertEmailLengthToNumber(emailLength),
        'summaryTone': summaryTone,
      }),
    );

    if (response.statusCode == 200) {
      // 서버로부터 정상적인 응답을 받았을 때 처리 로직
      print('서버에 설정 정보 업데이트 성공');
    } else {
      // 서버로부터 예상치 못한 응답을 받았을 때 처리 로직
      print('서버에 설정 정보 업데이트 실패: ${response.body}');
    }
  }

  int _convertEmailLengthToNumber(String length) {
    switch (length) {
      case '50 자 이내':
        return 50;
      case '100 자 이내':
        return 100;
      case '150 자 이내':
        return 150;
      default:
        return 50;
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CustomDrawer()), // CustomDrawer로 이동
    );
    return false; // true를 반환하면 현재 페이지가 닫히고, false를 반환하면 현재 페이지가 유지됩니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('이메일 요약 활성화'),
            value: isSummaryEnabled,
            onChanged: (bool value) {
              setState(() {
                isSummaryEnabled = value;
                _saveSettings();
              });
            },
          ),
          ListTile(
            title: Text('이메일 길이 설정'),
            trailing: DropdownButton<String>(
              value: emailLength,
              onChanged: (String? newValue) {
                setState(() {
                  emailLength = newValue!;
                  _saveSettings();
                  _saveSettingsToServer();
                });
              },
              items: <String>['50 자 이내', '100 자 이내', '150 자 이내']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('요약 말투 선택'),
            trailing: DropdownButton<String>(
              value: summaryTone,
              onChanged: (String? newValue) {
                setState(() {
                  summaryTone = newValue!;
                  _saveSettings();
                  _saveSettingsToServer();
                });
              },
              items: <String>['자연스러운', '친근한', '구어체']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SwitchListTile(
            title: Text('다크 테마 사용'),
            value: isThemeDark,
            onChanged: (bool value) {
              setState(() {
                isThemeDark = value;
                _saveSettings(); // 설정 저장
              });
            },
          ),
          SwitchListTile(
            title: Text('음성으로 듣기'),
            value: isVoiceEnabled,
            onChanged: (bool value) {
              setState(() {
                isVoiceEnabled = value;
                _saveSettings(); // 설정 저장
              });
            },
          ),
        ],
      ),
    );
  }
}



