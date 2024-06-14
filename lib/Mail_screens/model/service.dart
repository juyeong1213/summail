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
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <Mail>[];
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        final List<Mail> mails = (json.decode(response.body) as List).map((i) => Mail.fromJson(i)).toList();
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
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <MailSum>[];
      }

      print('Sending messageId: $messageId');
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
        final responseBody = json.decode(response.body);

        // 응답이 리스트인지 객체인지 확인
        if (responseBody is List) {
          final List<MailSum> mailsum = responseBody.map((i) => MailSum.fromJson(i as Map<String, dynamic>)).toList();
          return mailsum;
        } else if (responseBody is Map) {
          final List<MailSum> mailsum = [MailSum.fromJson(responseBody as Map<String, dynamic>)];
          return mailsum;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <MailSum>[];
      }
    } catch (e, stacktrace) {
      print('예외 발생: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      print('스택 트레이스: $stacktrace');
      return <MailSum>[];
    }
  }
}

/*
class Services {
  static const String url = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/api/mail_list';
  static const String summarizeUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com/summarize';

  static Future<List<Mail>> getInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <Mail>[];
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('HTTP 요청 성공');
        final List<Mail> mails = (json.decode(response.body) as List).map((i) => Mail.fromJson(i)).toList();
        final messageId = mails.first.messageId.toString();
        print('Stored messageId: $messageId');

        await getMailSumList(messageId);
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
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        Fluttertoast.showToast(msg: 'No token found. Please login again.');
        return <MailSum>[];
      }

      print('Sending messageId: $messageId');
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
        final responseBody = json.decode(response.body);

        // 응답이 리스트인지 객체인지 확인
        if (responseBody is List) {
          final List<MailSum> mailsum = responseBody.map((i) => MailSum.fromJson(i as Map<String, dynamic>)).toList();
          return mailsum;
        } else if (responseBody is Map) {
          final List<MailSum> mailsum = [MailSum.fromJson(responseBody as Map<String, dynamic>)];
          return mailsum;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        print('HTTP 요청 실패 - 상태 코드: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        return <MailSum>[];
      }
    } catch (e, stacktrace) {
      print('예외 발생: ${e.toString()}');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      print('스택 트레이스: $stacktrace');
      return <MailSum>[];
    }
  }
}
*/








