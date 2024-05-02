
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_points.dart';
import 'login_controller.dart';


class RegisterationController extends GetxController{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    print("회원가입 시작"); // 시작 로그
    try {
      var headers = {'Content-Type': 'application/json'};
      /*var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerUrl
      );*/
      var url = Uri.parse(
          ApiEndPoints.authEndPoints.registerUrl
      );
      Map body = {
        'nickname': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };
      print("HTTP 요청 전송: $body"); // HTTP 요청 전송 로그

      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      print("HTTP 응답 수신: 상태 코드 ${response.statusCode}"); // HTTP 응답 수신 로그

      if (response.statusCode == 200) {
        print("회원가입 성공");
        // 회원가입 성공 알림 및 로그인 화면으로 이동
        nameController.clear();
        emailController.clear();
        passwordController.clear();

        // SharedPreferences에 이름과 이메일 저장
        final SharedPreferences sharedPreferences = await prefs;
        await sharedPreferences.setString('name', nameController.text);
        await sharedPreferences.setString('email', emailController.text.trim());

        Get.snackbar("회원가입 성공", "이제 로그인 할 수 있습니다.");
      } else {
        print("회원가입 실패: ${jsonDecode(response.body)["message"]}"); // 회원가입 실패 로그
        throw jsonDecode(response.body)["message"] ?? "Unknown Error occurred";
      }
    } catch (e) {
      print("회원가입 중 예외 발생: $e"); // 예외 발생 로그
      Get.back(); // 현재 화면에서 이전 화면으로 돌아가기
      showDialog(context: Get.context!, builder: (context) {
        return SimpleDialog(
          title: Text('Error'),
          contentPadding: EdgeInsets.all(20),
          children: [Text(e.toString())],
        );
      });
    }
  }
}