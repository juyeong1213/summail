
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summail/Mail_screens/send_Mail/send_Mail.dart';

import '../../../main_mail/mailDetailPage.dart';
import '../../../model/mail.dart';
import '../../../model/service.dart';
import '../../../model/star/favoriteService.dart';
import '../settings.dart';
import 'SumMailDetailPage.dart';
import 'mail.dart';

class SumMailPage extends StatefulWidget {
  @override
  _SumMailPageState createState() => _SumMailPageState();
}

class _SumMailPageState extends State<SumMailPage> {

  List<Mail> _mail = <Mail>[];
  List<MailSum> _mailSum = <MailSum>[];
  bool loading = false;
  String? savedEmail;
  bool isSummaryEnabled = false;

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }


  @override
  void initState() {
    super.initState();
    _loadSettings();
    fetchMailData();
  }

  _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSummaryEnabled = prefs.getBool('isSummaryEnabled') ?? false;
    });
  }
  Future<void> fetchMailData() async {
    try {
      final mails = await Services.getInfo();
      setState(() {
        print('메일 데이터 로드 완료');
        _mail = mails;
        loading = true;
      });

      // 모든 메일의 요약본을 가져오기 위해 각 메일의 messageId를 사용
      List<MailSum> allMailSums = [];
      for (final mail in mails) {
        final mailSums = await Services.getMailSumList(mail.messageId);
        allMailSums.addAll(mailSums);
      }

      setState(() {
        _mailSum = allMailSums;
      });
    } catch (e) {
      print('예외 발생: $e');
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> toggleFavoriteStatus(int mailId) async {
    bool currentStatus = await FavoriteService.getFavoriteStatus(mailId);
    bool newStatus = !currentStatus;
    await FavoriteService.toggleFavoriteStatus(mailId, newStatus);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이메일 요약'),
      ),
      body: Center(
        child: isSummaryEnabled
            ? _buildSummaryContent()
            : _buildDisabledMessage(context),
      ),
    );
  }

  Widget _buildSummaryContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _mail.length,
            itemBuilder: (context, index) {
              Mail mail = _mail[index];
              MailSum? mailSum = _mailSum.firstWhere(
                    (ms) => ms.messageId == mail.messageId, // messageId로 매칭
                orElse: () => MailSum(contents: '요약할 수 없음', messageId: mail.messageId),
              );
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
                              Text("받는 사람 : ${savedEmail ?? '이메일을 찾을 수 없습니다.'}"),
                              Text("날짜 : ${mail.receiveDate} ${mail.receiveTime}"),
                              if (mailSum != null && mailSum.contents.isNotEmpty) Text("요약 : ${mailSum.contents}"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
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
                  mail.email,
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
                    if (mailSum != null && mailSum.contents.isNotEmpty)
                      Text(
                        mailSum.contents,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                trailing: InkWell(
                  //onTap: () => toggleFavoriteStatus(mail.id),
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
                    MaterialPageRoute(builder: (context) => SumMailDetailPage(mail: mail)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledMessage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이메일 요약 기능이 비활성화되어 있습니다.',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          child: Text('설정 페이지로 이동'),
        ),
      ],
    );
  }
}

