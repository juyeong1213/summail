import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.post(
      Uri.parse('서버 url'), // 서버의 URL을 입력합니다.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'emailLength': emailLength,
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

  @override
  Widget build(BuildContext context) {
    // Widget build 구현은 이전 설명과 동일하지만, DropdownButton을 emailLength를 위해 업데이트해야 합니다.
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
              items: <String>['공식적', '친근한']
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

