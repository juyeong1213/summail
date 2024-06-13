
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:summail/Mail_screens/main_mail/json_parse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/login/google_login/waitPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
    return Scaffold(
      body: isLogined
          ? const Text('Login OK!!')
          : WebViewWidget(
        controller: _controller,
      ),
    );
  }

  Future<void> _sendData(String url, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
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
      await prefs.setString('email', email);
      print('액세스 토큰과 이메일을 SharedPreferences에 저장했습니다.');

      // 저장된 데이터 로깅
      final storedAccessToken = prefs.getString('access_token');
      final storedEmail = prefs.getString('email');
      print('저장된 액세스 토큰: $storedAccessToken');
      print('저장된 이메일: $storedEmail');

      // 서버로 액세스 토큰 전송
      const dbUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/mail/db';
      const mailListUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/mail_list';

      print('db 서버로 액세스 토큰 전송 시작');
      await _sendData(dbUrl, accessToken);
      print('db 서버로 액세스 토큰 전송 완료');

      print('메일 리스트로 액세스 토큰 전송');
      await _sendData(mailListUrl, accessToken);
      print('메일 리스트로 액세스 토큰 전송 완료');
      if (!mounted) return;
      print('인증 화면 종료 완료');

      // JsonParse 페이지로 이동
      print('JsonParse 페이지로 이동 시작');

      Get.to(() => const WaitPage());
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WaitPage()),
      );*/
    }
  }
}




/*
class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
    return Scaffold(
      body: isLogined
          ? const Text('Login OK!!')
          : WebViewWidget(
        controller: _controller,
      ),
    );
  }

  Future<void> _sendDataToServer(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/mail/db'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        */
/*body: {
          'email': email,
        },*//*

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

  Future<void> _sendDataToMail(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/mail_list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        */
/*body: {
          'email': email,
        },*//*

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
      await prefs.setString('email', email);
      print('액세스 토큰과 이메일을 SharedPreferences에 저장했습니다.');

      // 저장된 데이터 로깅
      final storedAccessToken = prefs.getString('access_token');
      final storedEmail = prefs.getString('email');
      print('저장된 액세스 토큰: $storedAccessToken');
      print('저장된 이메일: $storedEmail');

      // 서버로 액세스 토큰 및 메일 전송
      print('db 서버로 액세스 토큰 전송 시작');
      await _sendDataToServer(accessToken);
      print('db 서버로 액세스 토큰 전송 완료');

      print('메일 리스트로 액세스 토큰 전송');
      await _sendDataToMail(accessToken);
      print('메일 리스트로 액세스 토큰 전송 완료');

      if (!mounted) return;
      print('인증 화면 종료 완료');

      // JsonParse 페이지로 이동
      print('JsonParse 페이지로 이동 시작');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WaitPage()),
      );
    }
  }
}
*/
