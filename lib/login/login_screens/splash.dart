import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/login/login_screens/auth/auth_screens.dart';

import '../../Mail_screens/main_mail/json_parse.dart';
import '../../ex/json_parse.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool islogin = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    //액세스 토큰 부분 추가하기
    if (token != null && token.isNotEmpty) {
      // 토큰이 존재하므로 사용자는 로그인한 상태
      setState(() {
        islogin = true;
      });
    } else {
      // 토큰이 존재하지 않으므로 사용자는 로그인하지 않은 상태
      setState(() {
        islogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: islogin ? JsonParse() : AuthScreen(),
      ),
    );
  }
}


