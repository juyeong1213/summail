import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/main_mail/json_parse.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_points.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:async';

class RegisterationMail extends StatefulWidget {
  const RegisterationMail({super.key});

  @override
  State<RegisterationMail> createState() => _RegisterationMailState();
}

class _RegisterationMailState extends State<RegisterationMail> {
  @override
  void initState() {
    super.initState();
    _authenticateWithGoogle();
    print('Google 인증 시작');
  }

  Future<void> _authenticateWithGoogle() async {
    // 서버 URL 및 리다이렉트 URL 정의
    const String serverUrl = "http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google";
    const String redirectUri = "http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google/success";

    try {
      print('Google 인증 URL 호출 시작');
      // 서버에서 정의된 Google 로그인 페이지로 리다이렉트
      final url = Uri.parse('$serverUrl?redirect-uri=$redirectUri');

      // 사용자가 Google 로그인 페이지에서 인증을 완료한 후, callback 데이터 반환
      final result = await FlutterWebAuth.authenticate(
          url: url.toString(), callbackUrlScheme: redirectUri);
      print('Google 인증 URL 호출 완료');

      print('콜백 URL 수신 시작');
      // 리다이렉트 된 URL에서 액세스 토큰 및 이메일 파싱
      final parsedUrl = Uri.parse(result);
      final accessToken = parsedUrl.queryParameters['access-token'];
      final email = parsedUrl.queryParameters['email'];
      print('콜백 URL 수신 완료');

      if (accessToken != null && email != null) {
        print('토큰 및 이메일 추출 완료');
        // SharedPreferences를 사용하여 액세스 토큰 및 이메일 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('email', email);
        print('액세스 토큰과 이메일을 SharedPreferences에 저장했습니다.');

        // 저장된 데이터 로깅
        final storedAccessToken = prefs.getString('access_token');
        final storedEmail = prefs.getString('email');
        print('저장된 액세스 토큰: $storedAccessToken');
        print('저장된 이메일: $storedEmail');

        // 서버로 데이터 전송
        await _sendDataToServer(accessToken, email);
      } else {
        print('액세스 토큰 또는 이메일을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('Google 인증 실패: $e');
    }
  }

  Future<void> _sendDataToServer(String accessToken, String email) async {
    // 이전과 동일한 서버 데이터 전송 로직
    final response = await http.post(
      Uri.parse('http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google/success'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      print('서버로 데이터 전송 성공');
      // 성공적으로 데이터를 전송한 후의 로직 추가 가능
    } else {
      print('서버로 데이터 전송 실패: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 웹뷰 등 구성 요소 추가 가능
    );
  }
}


/*
class RegisterationMail extends StatefulWidget {
  const RegisterationMail({super.key});

  @override
  State<RegisterationMail> createState() => _RegisterationMailState();
}

class _RegisterationMailState extends State<RegisterationMail> {
  late final WebViewController controller;
  String? _clientId;

  @override
  void initState() {
    super.initState();
    print('Google 인증 시작');
  }

  Future<void> _authenticateWithGoogle() async {
    final callbackUrlScheme = 'summail'; // 앱의 URL 스키마를 설정하세요.

    try {
      final url = 'http://ec2-43-200-104-174.ap-northeast-2.compute.amazonaws.com/add/google';

      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );

      final uri = Uri.parse(result);
      print('Google 인증 성공');

      // 서버로부터 응답을 받아옵니다.
      final response = await http.get(uri);

      // 헤더에서 토큰을 추출합니다.
      final accessToken = response.headers['Authorization'];


      if (accessToken != null) {
        // 액세스 토큰과 메일을 로컬에 저장합니다.
        await _saveTokenAndEmail(accessToken);
        print('액세스 토큰과 메일이 저장되었습니다.');

        // 서버로 데이터를 전송합니다.
        await _sendDataToServer();
      } else {
        print('액세스 토큰 또는 이메일을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('Google 인증 실패: $e');
    }
  }

  Future<void> _saveTokenAndEmail(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  Future<Map<String, String>> _loadTokenAndEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    final email = prefs.getString('email') ?? '';
    return {'accessToken': token, 'email': email};
  }

  Future<void> _sendDataToServer() async {
    final data = await _loadTokenAndEmail();

    final response = await http.post(
      Uri.parse(
          'http://ec2-43-200-104-174.ap-northeast-2.compute.amazonaws.com/add/google'),
      headers: {
        'Authorization': 'Bearer ${data['accessToken']}',
      },
      body: {
        'nickname key': 'name', // SharedPreferences에서 name 불러오기
      },
    );

    if (response.statusCode == 200) {
      print('서버로 데이터 전송 성공');
    } else {
      print('서버로 데이터 전송 실패: ${response.body}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authenticateWithGoogle();
          },
          child: Text('메일 추가 등록'),
        ),
      ),
    );
  }
}
*/
