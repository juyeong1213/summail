import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mail_box/favoriteMail.dart';
import 'mail_box/receivedMail.dart';
import 'mail_box/sendMail.dart';
import 'mail_box/settings.dart';
import 'mail_box/spamMail.dart';
import 'mail_box/summarizationMail.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}


class _CustomDrawerState extends State<CustomDrawer> {
  // navigateToPage 메서드를 _drawerState 클래스 내부에 추가
  void navigateToPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                // SharedPreferences 데이터 로드 완료
                final prefs = snapshot.data!;
                final name = prefs.getString('name') ?? '이름 없음'; // 기본값 설정
                final email = prefs.getString('email') ?? '이메일 없음'; // 기본값 설정

                return UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/ku.png'),
                  ),
                  otherAccountsPictures: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/kun.png'),
                    )
                  ],
                  accountName: Text(name),
                  accountEmail: Text(email),
                );
              } else {
                // 데이터 로딩 중이거나 에러 발생 시
                return UserAccountsDrawerHeader(
                  accountName: Text('로딩 중...'),
                  accountEmail: Text(''),
                );
              }
            },
          ),
          /*children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/ku.png'),
            ),
            otherAccountsPictures: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/ku.png'),
              )
            ],
            accountName: Text('정주영'),
            accountEmail: Text('dkfl@naver.com'),
          ),*/
          ListTile(
            leading: Icon(Icons.send,
              color: Colors.grey[850],
            ),
            title: Text('보낸 메일함'),
            onTap: (){
              navigateToPage(context, SendMailPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.mail,
              color: Colors.grey[850],
            ),
            title: Text('받은 메일함'),
            onTap: (){
              navigateToPage(context, ReciveMailPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.star,
              color: Colors.grey[850],
            ),
            title: Text('중요 메일함'),
            onTap: (){
              navigateToPage(context, LikedMailPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.summarize,
              color: Colors.grey[850],
            ),
            title: Text('요약 메일함'),
            onTap: (){
              navigateToPage(context, SumMailPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.warning,
              color: Colors.grey[850],
            ),
            title: Text('스팸 메일함'),
            onTap: (){
              navigateToPage(context, SpamMailPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings,
              color: Colors.grey[850],
            ),
            title: Text('설정'),
            onTap: (){
              navigateToPage(context, SettingsPage());
            },
          ),
        ],
      ),
    );
  }
}
