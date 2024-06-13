import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:summail/login/google_login/google_login.dart';

import '../../utils/api_points.dart';
import '../google_login/addMail.dart';


class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();



  /*Future<void> callAnotherServer(String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/add/google'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("다른 서버 호출 성공: 상태 코드 ${response.statusCode}");
      } else {
        print("다른 서버 호출 실패: 상태 코드 ${response.statusCode}");
      }
    }
    catch (e) {
      print("다른 서버 호출 중 예외 발생: $e");
    }
  }*/


  Future<void> loginWithEmail() async {
    print("로그인 시작"); // 시작 로그
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(ApiEndPoints.authEndPoints.loginUrl);
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      print("HTTP 요청 전송: $body"); // HTTP 요청 전송 로그
      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      print("HTTP 응답 수신: 상태 코드 ${response.statusCode}"); // HTTP 응답 수신 로그
      print(response.headers);
      if (response.statusCode == 200) {
        // 서버로부터의 응답 헤더에서 토큰 추출
        String? token = response.headers['authorization'];
        print("응답에서 토큰 추출: $token"); // 토큰 추출 로그

        if (token != null) {
          print(token);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          // 토큰을 추출하여 SharedPreferences(로컬 저장소)에 저장
          await prefs.setString('token', token); // 기기 내부에 String 타입의 token이 'token'이라는 이름에 저장됨.
          print("토큰 저장 완료"); // 토큰 저장 로그


          Get.to(() => AddMail());

          // map 서버 호출해주기
          //await callAnotherServer(token);

          emailController.clear();
          passwordController.clear();
        } else {
          print("응답 헤더에서 토큰을 찾을 수 없음"); // 토큰 없음 로그
          throw "Token not found in response headers";
        }
      } else {
        print("로그인 실패: ${response.reasonPhrase}"); // 로그인 실패 로그. body가 없으므로 reasonPhrase 사용
        throw response.reasonPhrase ?? "Unknown Error occurred";
      }
    } catch (e) {
      print("로그인 중 예외 발생: $e"); // 예외 발생 로그
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



