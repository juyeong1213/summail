/*
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/main_mail/json_parse.dart';
import 'package:http/http.dart' as http;

class Google_Login extends StatefulWidget {
  const Google_Login({super.key});

  @override
  State<Google_Login> createState() => _Google_LoginState();
}

class _Google_LoginState extends State<Google_Login> {
  @override
  void initState() {
    super.initState();
    _authenticateWithGoogle();
    print('Google 인증 시작');
  }

  Future<void> _authenticateWithGoogle() async {
    final callbackUrlScheme = 'summail'; // 앱의 URL 스키마

    try {
      print('Google 인증 URL 호출 시작');
      final url = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google';
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );
      print('Google 인증 URL 호출 완료');

      print('콜백 URL 수신 시작');
      final uri = Uri.parse(result);
      print('콜백 URL: $uri');

      print('토큰 및 이메일 추출 시작');
      final accessToken = uri.queryParameters['access_token'];
      final email = uri.queryParameters['email'];
      print('토큰 및 이메일 추출 완료');

      if (accessToken != null && email != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('email', email);
        print('액세스 토큰과 이메일을 SharedPreferences에 저장했습니다.');

        // 저장된 데이터 로깅
        final storedAccessToken = prefs.getString('access_token');
        final storedEmail = prefs.getString('email');
        print('저장된 액세스 토큰: $storedAccessToken');
        print('저장된 이메일: $storedEmail');

        // 서버로 액세스 토큰 및 메일 전송
        print('서버 데이터 전송 시작');
        await _sendDataToServer(accessToken, email);
        print('서버 데이터 전송 완료');

        Navigator.of(context).pop(); // 현재 WebView 또는 인증 화면을 닫습니다.
        print('인증 화면 종료 완료');

        // JsonParse 페이지로 이동
        print('JsonParse 페이지로 이동 시작');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JsonParse()),
        );

        print('JsonParse 페이지로 이동 완료');
      } else {
        print('액세스 토큰 또는 이메일을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('Google 인증 실패: $e');
    }
  }

  Future<void> _sendDataToServer(String accessToken, String email) async {
    final response = await http.post(
      Uri.parse('http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/mail/dbs'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'email': email,
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
      appBar: AppBar(
        title: Text('Google Login'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // 인증 중 로딩 표시
      ),
    );
  }
}



*/

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/main_mail/json_parse.dart';
import 'package:http/http.dart' as http;

class Google_Login extends StatefulWidget {
  const Google_Login({super.key});

  @override
  State<Google_Login> createState() => _Google_LoginState();
}

class _Google_LoginState extends State<Google_Login> {
  @override
  void initState() {
    super.initState();
    _authenticateWithGoogle();
    print('Google 인증 시작');
  }

  Future<void> _authenticateWithGoogle() async {
    const callbackUrlScheme = 'my-custom-app'; // 앱의 URL 스키마

    try {
      print('Google 인증 URL 호출 시작');
      const url =
          'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google';
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );
      print('Google 인증 URL 호출 완료');

      print('콜백 URL 수신 시작');
      final uri = Uri.parse(result);
      print('콜백 URL: $uri');

      print('토큰 및 이메일 추출 시작');
      final accessToken = uri.queryParameters['access_token'];
      final email = uri.queryParameters['email'];
      print('토큰 및 이메일 추출 완료');

      if (accessToken != null && email != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('email', email);
        print('액세스 토큰과 이메일을 SharedPreferences에 저장했습니다.');

        // 저장된 데이터 로깅
        final storedAccessToken = prefs.getString('access_token');
        final storedEmail = prefs.getString('email');
        print('저장된 액세스 토큰: $storedAccessToken');
        print('저장된 이메일: $storedEmail');

        // 서버로 액세스 토큰 및 메일 전송
        print('서버 데이터 전송 시작');
        await _sendDataToServer(accessToken, email);
        print('서버 데이터 전송 완료');

        if (!mounted) return;
        Navigator.of(context).pop(); // 현재 WebView 또는 인증 화면을 닫습니다.
        print('인증 화면 종료 완료');

        // JsonParse 페이지로 이동
        print('JsonParse 페이지로 이동 시작');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JsonParse()),
        );
        print('JsonParse 페이지로 이동 완료');
      } else {
        print('액세스 토큰 또는 이메일을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('Google 인증 실패: $e');
    }
  }

  Future<void> _sendDataToServer(String accessToken, String email) async {
    final response = await http.post(
      Uri.parse(
          'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/mail/dbs'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'email': email,
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
      appBar: AppBar(
        title: const Text('Google Login'),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // 인증 중 로딩 표시
      ),
    );
  }
}
