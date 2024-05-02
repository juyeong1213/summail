import 'package:http/http.dart' as http;
import 'dart:convert';

class SendMailService {
  static const String apiUrl = '서버 주소';

  static Future<bool> sendMail(String recipient, String sender, String subject, String content) async {
    var url = Uri.parse(apiUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'recipient': recipient,
        'sender': sender,
        'subject': subject,
        'content': content,
      }),
    );

    return response.statusCode == 200;
  }
}
