import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/drawer/mail_box/sendMail/SendMail.dart';
import 'package:summail/Mail_screens/drawer/mail_box/sendMail/sendservice.dart';

import '../../../model/star/favoriteService.dart';




class SendMailPage extends StatefulWidget {
  const SendMailPage({super.key});

  @override
  State<SendMailPage> createState() => _SendMailPageState();
}

class _SendMailPageState extends State<SendMailPage> {
  List<SendMail> _mail = <SendMail>[];
  bool loading = false;
  String? savedEmail;

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  void initState() {
    super.initState();
    _loadSavedEmail(); // 이메일 로드
    SendServices.fetchSendMails().then((mail) {
      setState(() {
        print('메일 데이터 로드 완료');
        _mail = mail;
        loading = true;
      });
    });
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmail = prefs.getString('addmail');
      print('로드된 이메일: $savedEmail'); // 디버깅을 위한 로그 추가
    });
  }



  @override
  Widget build(BuildContext context) {
    print('build 호출됨');
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? '보낸 메일함' : 'Loading...'),
      ),
      body: loading
          ? _mail.isNotEmpty
          ? ListView.builder(
        itemCount: _mail.length,
        itemBuilder: (context, index) {
          SendMail mail = _mail[index];
          return ListTile(
            leading: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(mail.sender),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("보낸 사람 : ${mail.sender}"),
                          Text("받는 사람 : ${savedEmail ?? '이메일을 찾을 수 없습니다.'}"),
                          Text("제목 : ${mail.subject}"),
                          Text("내용 : ${mail.snippet}"),
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
                Icons.account_circle,
                size: 40.0,
              ),
            ),
            title: Text(mail.subject),
            subtitle: Text(mail.snippet),
            trailing: IconButton(
              icon: Icon(
                mail.isFavorited ? Icons.star : Icons.star_border,
              ), onPressed: () {  },

            ),
            onTap: () {
              // 메일 상세 페이지로 이동
              navigateToPage(context, SendMailDetailPage(mail: mail));
            },
          );
        },
      )
          : Center(child: Text('보낸 메일이 없습니다.'))
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class SendMailDetailPage extends StatelessWidget {
  final SendMail mail;

  const SendMailDetailPage({super.key, required this.mail});

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
            Text("보낸 사람: ${mail.sender}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("받는 사람: ${mail.receiver}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("제목: ${mail.subject}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("내용: ${mail.snippet}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
