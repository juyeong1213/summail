import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/drawer/mail_box/spam/spam.dart';

import '../../../model/mail.dart';


class ServiceSpam {
  static const String url = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/spam_mail'; // 실제 API URL로 변경

  Future<List<Spam>> fetchSpam() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <Spam>[];
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        final List<Spam> spamList = (json.decode(response.body) as List)
            .map((i) => Spam.fromJson(i))
            .toList();
        return spamList;
      } else {
        //print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        //Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <Spam>[];
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      //Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      return <Spam>[];
    }
  }
}