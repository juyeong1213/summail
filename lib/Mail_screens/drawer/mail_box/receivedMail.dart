import 'package:flutter/material.dart';

import '../../main_mail/mailDetailPage.dart';
import '../../model/mail.dart';
import '../../model/service.dart';
import '../../model/star/favoriteService.dart';


class ReciveMailPage extends StatefulWidget {
  const ReciveMailPage({super.key});

  @override
  State<ReciveMailPage> createState() => _ReciveMailPageState();
}

class _ReciveMailPageState extends State<ReciveMailPage> {
  List<Mail> _mail = <Mail>[];
  bool loading = false;
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services.getInfo().then((value) {
      setState(() {
        _mail = value;
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
        title: Text(loading ? '받은 메일함' : 'Loading...'),
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
                      title: Text(mail.mailFrom),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("보낸 사람 : ${mail.mailFrom}"),
                          Text("받는 사람 : ${mail.mailFrom}"),
                          Text("날짜 : ${mail.mailFrom}"),
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
                Text(mail.mailFrom),
                Text(mail.mailFrom),
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
    );
  }
}
