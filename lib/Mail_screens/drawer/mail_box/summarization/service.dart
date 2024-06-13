import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/mail.dart';
import 'mail.dart';


class ServiceSum {
  static const String url = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com//summarize';

  static Future<List<MailSum>> getMailSumList() async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      // 토큰이 없는 경우 오류 메시지 표시
      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return [];
      }

      // HTTP GET 요청을 보내고 응답 받기
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        return mailFromJson(response.body);
      } else {
        print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return [];
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      return [];
    }
  }

  static String mailToJson(List<MailSum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  static List<MailSum> mailFromJson(String str) => List<MailSum>.from(json.decode(str).map((x) => MailSum.fromJson(x)));
}


