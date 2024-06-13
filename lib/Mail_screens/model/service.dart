import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/api_points.dart';
import '../drawer/mail_box/summarization/mail.dart';
import 'mail.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Services {
  static const String url = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/mail_list';
  static const String summarizeUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/summarize';

  static Future<List<Mail>> getInfo() async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      //final String? token = prefs.getString('access_token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <Mail>[];
      }

      // HTTP GET 요청을 보내고 응답 받기
      final response = await http.get(
        Uri.parse(url),
        // 헤더에 토큰 추가
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        final List<Mail> mails = (json.decode(response.body) as List).map((i) => Mail.fromJson(i)).toList();
        final messageId = mails.first.id;
        return mails;
      } else {
        print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <Mail>[];
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      return <Mail>[];
    }

  }

static Future<List<MailSum>> getMailSumList(String messageId) async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      // 토큰이 없는 경우 오류 메시지 표시
      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <MailSum>[];
      }

      // HTTP GET 요청을 보내고 응답 받기
      final response = await http.post(
        Uri.parse(summarizeUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'messageId': messageId}),
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        final List<MailSum> mailsum = (json.decode(response.body) as List).map((i) => MailSum.fromJson(i)).toList();
        return mailsum;
      } else {
        print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <MailSum>[];
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      return <MailSum>[];
    }
  }

}






