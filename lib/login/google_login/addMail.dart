import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:webview_flutter/webview_flutter.dart';

import '../../Mail_screens/main_mail/json_parse.dart';


class AddMail extends StatefulWidget {
  const AddMail({super.key});

  @override
  State<AddMail> createState() => _AddMailState();
}

class _AddMailState extends State<AddMail> {
  late final WebViewController _controller;
  bool isLogined = false;

  @override
  void initState() {
    super.initState();
    // WebViewController 초기화
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            if (url.contains('summail://')) {
              saveToken(url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            debugPrint('url change to $request');
          },
        ),
      )
      ..setUserAgent('random');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final redirectUrl = await addmail();
      if (redirectUrl != null) {
        _controller.loadRequest(Uri.parse(redirectUrl));
      }
    });
  }

  Future<String?> addmail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      debugPrint('토큰 add/google로 전달 시도 중: $token');
      final response = await http.get(
        Uri.parse(
            'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/add/google'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var redirectUrl = response.headers['location']; // 리다이렉트 URL 추출
        debugPrint('리다이렉트 URL 추출 성공: $redirectUrl');

        // URL에 스킴이 누락된 경우 추가
        if (redirectUrl != null && !redirectUrl.startsWith('http')) {
          redirectUrl = 'http://$redirectUrl';
        }

        return redirectUrl;
      } else {
        debugPrint('Failed to get redirect URL: ${response.body}');
      }
    } else {
      debugPrint('No token found in SharedPreferences');
    }
    return null; // 실패한 경우 null을 반환합니다.
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLogined
          ? const Text('Login OK!!')
          : WebViewWidget(
        controller: _controller,
      ),
    );
  }


  Future<void> _sendData(String url, String token) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('서버로 데이터 전송 성공');
      } else {
        print('서버로 데이터 전송 실패: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void saveToken(String url) async {
    final uri = Uri.parse(url);
    debugPrint(uri.queryParameters.toString());
    final accessToken = uri.queryParameters['access_token'];
    final email = uri.queryParameters['email'];

    if (accessToken != null && email != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('addmail', email);
      debugPrint('저장된 이메일: $email');

      print('액세스 토큰과 추가된 이메일을 SharedPreferences에 저장했습니다.');

      final token = prefs.getString('token');


      if (token != null) {
        const dbUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/mail/db';
        const mailListUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/mail_list';


        print('db 서버로 액세스 토큰 전송 시작');
        await _sendData(dbUrl, token);
        print('db 서버로 액세스 토큰 전송 완료');

        print('메일 리스트로 액세스 토큰 전송');
      await _sendData(mailListUrl, token);
      print('메일 리스트로 액세스 토큰 전송 완료');

        if (!mounted) return;
        print('인증 화면 종료 완료');

        Get.to(() => const JsonParse());
      }
    }
  }
}




















/*
class AddMail extends StatefulWidget {
  const AddMail({super.key});

  @override
  State<AddMail> createState() => _AddMailState();
}

class _AddMailState extends State<AddMail> {
  late final WebViewController _controller;
  bool isLogined = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            if (url.contains('summail://')) {
              saveToken(url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            debugPrint('url change to $request');
          },
        ),
      )
      ..setUserAgent('random')
      ..loadRequest(Uri.parse(
          'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/login/google'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    */
/*return Scaffold(
      body: isLogined
          ? const Text('Login OK!!')
          : WebViewWidget(
        controller: _controller,
      ),
    );*//*

    return Scaffold(
      body: WebViewWidget(
        controller: _controller,
        initialChild: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Future<void> _sendDataToServer() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse(
              'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/mail/db'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          debugPrint('서버로 데이터 전송 성공');
        } else {
          debugPrint('서버로 데이터 전송 실패: ${response.body}');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void saveToken(String url) async {
    final uri = Uri.parse(url);
    debugPrint(uri.queryParameters.toString());
    final accessToken = uri.queryParameters['access_token'];
    final email = uri.queryParameters['email'];

    if (accessToken != null && email != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);

      // 저장된 이메일 리스트 불러오기
      List<String> emailList = prefs.getStringList('addmail') ?? [];
      // 새 이메일 리스트에 추가
      emailList.add(email);
      // 변경된 리스트를 SharedPreferences에 저장
      await prefs.setStringList('addmail', emailList);
      print('액세스 토큰과 추가된 이메일을 SharedPreferences에 저장했습니다.');

      if (!mounted) return;
      print('인증 화면 종료 완료');

      setState(() {
        isLogined = true;
      });
      Get.to(() => const JsonParse());
    }
  }
}
*/



