import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/drawer/mail_box/sendMail/sendservice.dart';

import '../../../model/star/favoriteService.dart';
import '../../../send_Mail/send_Mail.dart';



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

  Future<void> toggleFavoriteStatus(String messageId) async {
    bool currentStatus = await FavoriteService.getFavoriteStatus(messageId); // 비동기 호출에 await 추가
    bool newStatus = !currentStatus;
    await FavoriteService.toggleFavoriteStatus(messageId, newStatus); // 비동기 호출에 await 추가
    setState(() {
      // UI 갱신 로직이 필요한 경우 여기에 추가
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build 호출됨');
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? '보낸 메일함' : 'Loading...'),
      ),
      body: ListView.builder(
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
                          Text("날짜 : ${mail.sender} ${mail.sender}"),
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
            title: Text(
              mail.sender,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0, // 글자 크기를 18로 설정
                fontWeight: FontWeight.bold, // 굵은 글자로 설정
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mail.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold, // 굵은 글자로 설정
                  ),
                ),
                Text(
                  mail.snippet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () => toggleFavoriteStatus(mail.messageId),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<bool>(
                  future: FavoriteService.getFavoriteStatus(mail.messageId), // 비동기 메서드 호출
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    Color iconColor = Colors.grey; // 기본 색상은 회색
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        // Future에서 데이터를 성공적으로 받아왔다면, 해당 데이터에 따라 색상 결정
                        iconColor = snapshot.data! ? Colors.yellow : Colors.grey;
                      }
                    }
                    // Future의 상태와 관계없이 아이콘을 표시합니다.
                    // 데이터 로딩 중이거나 오류가 발생한 경우에도 기본값인 회색 아이콘을 표시합니다.
                    return Icon(
                      Icons.star,
                      color: iconColor,
                    );
                  },
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendMailDetailPage(mail: mail)),
              );
            },
          );
        },
      ),
    );
  }
}
