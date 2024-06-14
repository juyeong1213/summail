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

  static _MyAppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MyAppInheritedWidget>()!.data;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MyAppInheritedWidget(
      data: this,
      child: GetMaterialApp(
        title: 'Login',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode, // 사용자 설정 모드 사용
        home: Splash(),
      ),
    );
  }
}

class _MyAppInheritedWidget extends InheritedWidget {
  final _MyAppState data;

  _MyAppInheritedWidget({required this.data, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_MyAppInheritedWidget oldWidget) {
    return true;
  }
}



/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _themeData = ThemeData.light();

  void setTheme(ThemeData theme) {
    setState(() {
      _themeData = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // MaterialApp을 GetMaterialApp으로 변경
      title: 'Login',
      */
/*theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),*//*

      theme: _themeData,
      home: Splash(),

    );
  }
}*/
