
import 'package:flutter/material.dart';
import 'package:summail/Mail_screens/drawer/mail_box/spam/service.dart';
import 'package:summail/Mail_screens/drawer/mail_box/spam/spam.dart';
import 'package:summail/Mail_screens/drawer/mail_box/spam/spamMailDetailPage.dart';
import 'package:summail/Mail_screens/send_Mail/send_Mail.dart';

import '../../../model/mail.dart';



class SpamPage extends StatefulWidget {
  @override
  _SpamPageState createState() => _SpamPageState();
}

class _SpamPageState extends State<SpamPage> {
  late Future<List<Spam>> futureSpam;

  @override
  void initState() {
    super.initState();
    futureSpam = ServiceSpam().fetchSpam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스팸 메일함'),
      ),
      body: FutureBuilder<List<Spam>>(
        future: futureSpam,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('스팸 메일이 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final spam = snapshot.data![index];
                return ListTile(
                  title: Text(spam.subject),
                  subtitle: Text(spam.snippet),
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => SpamMailDetailPage(spam: spam,)));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}