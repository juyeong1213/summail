import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/google_login/addMail.dart';
import '../../login/google_login/webview.dart';
import 'mail_box/favoriteMail.dart';
import 'mail_box/receivedMail.dart';
import 'mail_box/sendMail.dart';
import 'mail_box/settings.dart';
import 'mail_box/spam/spamMail.dart';
import 'mail_box/summarization/SumMailPage.dart';
import 'mail_box/summarizationMail.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
                final email = prefs.getString('addmail') ?? '이메일 없음'; // 기본값 설정

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
          ListTile(
            leading: Icon(
              Icons.send,
              color: Colors.grey[850],
            ),
            title: Text('보낸 메일함'),
            onTap: () {
              Get.to(() => SendMailPage());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mail,
              color: Colors.grey[850],
            ),
            title: Text('받은 메일함'),
            onTap: () {
              Get.to(() => ReceicedMailPage());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.grey[850],
            ),
            title: Text('중요 메일함'),
            onTap: () {
              Get.to(() => LikedMailPage());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.summarize,
              color: Colors.grey[850],
            ),
            title: Text('요약 메일함'),
            onTap: () {
              Get.to(() => SumMailPage());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.warning,
              color: Colors.grey[850],
            ),
            title: Text('스팸 메일함'),
            onTap: () {
              Get.to(() => SpamPage());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.grey[850],
            ),
            title: Text('설정'),
            onTap: () {
              Get.to(() => SettingsPage());
            },
          ),
          Divider(), // 구분선 추가
          ListTile(
            leading: Icon(
              Icons.add,
              color: Colors.grey[850],
            ),
            title: Text('메일 추가'),
            onTap: () async {
              await Get.to(() => AddMail());
              setState(() {}); // 페이지 돌아온 후 상태 갱신
            },
          ),
        ],
      ),
    );
  }
}


