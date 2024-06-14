import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/drawer/mail_box/sendMail/SendMail.dart';


class SendServices {
  static const String url = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/sent_mail';

  static Future<List<SendMail>> fetchSendMails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <SendMail>[];
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        final List<dynamic> jsonData = json.decode(response.body) as List<dynamic>;
        final List<SendMail> mails = jsonData.map((jsonItem) => SendMail.fromJson(jsonItem as Map<String, dynamic>)).toList();
        return mails;
      } else {
        print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <SendMail>[];
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      return <SendMail>[];
    }
  }
}