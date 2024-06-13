import 'package:http/http.dart' as http;
import 'dart:convert';

class SendMailService {
  static const String apiUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com:8080/api/send_mail';

  static Future<bool> sendMail(String user, String sender, String receiver, String subject, String contents, String attachment) async {
    var url = Uri.parse(apiUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user' : user,
        'sender' : sender,
        'receiver' : receiver,
        'subject': subject,
        'contents': contents,
        'attachment' : attachment,
      }),
    );

    return response.statusCode == 200;
  }
}
