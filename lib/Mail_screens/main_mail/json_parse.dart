/*

import 'package:flutter/material.dart';
import 'package:summail/Mail_screens/send_Mail/send_Mail.dart';

import '../drawer/drawer.dart';
import '../model/mail.dart';
import '../model/service.dart';
import '../model/star/favoriteService.dart';
import 'mailDetailPage.dart';


class JsonParse extends StatefulWidget {
  const JsonParse({super.key});

  @override
  State<JsonParse> createState() => _JsonParseState();
}

class _JsonParseState extends State<JsonParse> {
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

  Future<void> toggleFavoriteStatus(int mailId) async {
    bool currentStatus = await FavoriteService.getFavoriteStatus(mailId); // 비동기 호출에 await 추가
    bool newStatus = !currentStatus;
    await FavoriteService.toggleFavoriteStatus(mailId, newStatus); // 비동기 호출에 await 추가
    setState(() {
      // UI 갱신 로직이 필요한 경우 여기에 추가
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? '썸메일' : 'Loading...'),
      ),
      drawer: const CustomDrawer(),
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
                      title: Text(mail.mailFrom),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("보낸 사람 : ${mail.mailFrom}"),
                          Text("받는 사람 : ${mail.mailFrom}"),
                          Text("날짜 : ${mail.receiveTime}"),
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

            title: Text(mail.mailFrom),
            //subtitle: Text(mail.address.street),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(mail.mailFrom),
                Text(mail.subject),
                Text(mail.contents),
              ],
            ),
            trailing: InkWell(
              onTap: () => toggleFavoriteStatus(mail.id),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<bool>(
                  future: FavoriteService.getFavoriteStatus(mail.id), // 비동기 메서드 호출
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
                MaterialPageRoute(builder: (context) => MailDetailPage(mail: mail)),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30, right: 30),
        child: FloatingActionButton(
          onPressed: () {
            // 메일 작성 페이지로 이동하는 로직
            navigateToPage(context, SendMail()); // 예시 페이지
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.white54,
        ),
      ),
    );
  }
}

*/
