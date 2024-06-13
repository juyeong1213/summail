
import 'package:flutter/material.dart';
import 'package:summail/Mail_screens/drawer/mail_box/spam/spamMailDetailPage.dart';
import 'package:summail/Mail_screens/drawer/mail_box/summarization/service.dart';
import 'package:summail/Mail_screens/send_Mail/send_Mail.dart';

import '../../../model/mail.dart';



class SpamMailPage extends StatefulWidget {
  const SpamMailPage({super.key});

  @override
  State<SpamMailPage> createState() => _SpamMailPageState();
}

class _SpamMailPageState extends State<SpamMailPage> {
  List<Mail> _mail = <Mail>[];
  bool loading = false;

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services.getInfo().then((mail) {
      setState(() {
        _mail = mail;
        loading = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? '스펨 메일함' : 'Loading...'),
      ),
      body: ListView.builder(
        itemCount: _mail.length,
        itemBuilder: (context, index) {
          Mail mail = _mail[index];
          return ListTile(
            leading: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(mail.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("보낸 사람 : ${mail.email}"),
                          Text("받는 사람 : ${mail.email}"),
                          Text("날짜 : ${mail.receiveDate} ${mail.receiveTime}"),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 대화 상자를 닫습니다.
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.account_circle_rounded,
                color: Colors.blue,
              ),
            ),

            title: Text(mail.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0, // 글자 크기를 18로 설정
                fontWeight: FontWeight.bold, // 굵은 글자로 설정
              ),
            ),
            //subtitle: Text(mail.address.street),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(mail.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold, // 굵은 글자로 설정
                  ),
                ),
                Text(mail.contents,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpamMailDetailPage(mail: mail)),
              );
            },
          );
        },
      ),
    );
  }
}

