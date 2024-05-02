import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Google_login extends StatefulWidget {
  const Google_login({super.key});

  @override
  State<Google_login> createState() => _Google_loginState();
}

class _Google_loginState extends State<Google_login> {
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
import 'package:flutter_web_auth/flutter_web_auth.dart';

Future<void> signInWithGoogle() async {
  // 서버 URL 및 리다이렉트 URL 정의
  const String serverUrl = "http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google";
  const String redirectUri = "http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google/success";

  // 서버에서 정의된 Google 로그인 페이지로 리다이렉트
  final url = Uri.parse('$serverUrl?redirect-uri=$redirectUri');

  // 사용자가 Google 로그인 페이지에서 인증을 완료한 후, callback 데이터 반환
  final result = await FlutterWebAuth.authenticate(
      url: url.toString(), callbackUrlScheme: redirectUri);

  // 리다이렉트 된 URL에서 액세스 토큰 및 이메일 파싱
  final parsedUrl = Uri.parse(result);
  final accessToken = parsedUrl.queryParameters['access-token'];
  final email = parsedUrl.queryParameters['email'];

  // 여기서부터는 액세스 토큰 및 이메일을 안전하게 저장하고 관리하는 코드를 추가하면 됩니다.
  // 예를 들어, FlutterSecureStorage 또는 SharedPreferences를 사용할 수 있습니다.

  // 예시: FlutterSecureStorage를 사용한 토큰 저장
  // final storage = FlutterSecureStorage();
  // await storage.write(key: "accessToken", value: accessToken);
  // await storage.write(key: "email", value: email);
}*/



/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/main_mail/json_parse.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../../ex/json_parse.dart';
import '../../utils/api_points.dart';
import 'myWebView.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class Google_login extends StatefulWidget {
  const Google_login({super.key});

  @override
  State<Google_login> createState() => _Google_loginState();
}

class _Google_loginState extends State<Google_login> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    _authenticateWithGoogle();
    print('Google 인증 시작');
  }

  Future<void> _authenticateWithGoogle() async {
    final callbackUrlScheme = 'http'; // 앱의 URL 스키마 설정. ->manifest파일

    try {
      print('Google 인증 URL 호출 시작');
      final url ='http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google';
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
      );
      print('Google 인증 URL 호출 완료');

      print('콜백 URL 수신 시작');
      final uri = Uri.parse(result);
      print('Google 인증 성공:');

      print('콜백 URL 수신 완료');

      print('토큰 및 이메일 추출 시작');
      // 구글 로그인 성공 시 반환되는 URL에서 토큰과 이메일 추출
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

        // 다시 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google/success'로 토큰과 이메일 전송
        print('서버 데이터 전송 시작');
        await _sendDataToServer(accessToken, email);
        print('서버 데이터 전송 완료');

        Navigator.of(context).pop();
        print('웹뷰 종료 완료');

        // JsonParse() 페이지로 이동
        print('JsonParse() 페이지로 이동 시작');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JsonParse()),
        );
        print('JsonParse() 페이지로 이동 완료');
      } else {
        print('액세스 토큰 또는 이메일을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('Google 인증 실패: $e');
    }
  }

  Future<void> _sendDataToServer(String accessToken, String email) async {
    final response = await http.post(
      Uri.parse('http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google/success'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'email': email,
        // 여기에 SharedPreferences에서 로드한 name도 포함할 수 있습니다.
        //'nickname key': 'name', // SharedPreferences에서 name 불러오기
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
    );
  }
}




*/
