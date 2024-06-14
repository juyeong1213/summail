import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/drawer/mail_box/sendMail/sendservice.dart';

import '../../../send_Mail/send_Mail.dart';

class SendMailDetailPage extends StatelessWidget {
  final SendMail mail;

  const SendMailDetailPage({Key? key, required this.mail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mail.subject),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("보낸 사람: ${mail.sender}"),
            Text("받는 사람: ${mail.receiver}"),
            Text("제목: ${mail.subject}"),
            SizedBox(height: 20),
            Text(mail.snippet),
          ],
        ),
      ),
    );
  }
}
