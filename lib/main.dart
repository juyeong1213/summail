import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:summail/login/google_login/webview.dart';

import 'Mail_screens/drawer/mail_box/settings.dart';
import 'Mail_screens/main_mail/json_parse.dart';
import 'login/google_login/google_login.dart';
import 'login/login_screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // MaterialApp을 GetMaterialApp으로 변경
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Splash(),
      //home: JsonParse(),
      //home: SettingsPage(),
    );
  }
}