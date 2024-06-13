
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/mail.dart';
import 'mail.dart';
import 'package:summail/Mail_screens/drawer/mail_box/summarization/service.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SumMailDetailPage extends StatelessWidget {
  final Mail mail;

  const SumMailDetailPage({Key? key, required this.mail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(mail.email), // 일단 이름 불러옴
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 사용자의 이름을 큰 글씨로 표시 -> 메일의 제목으로 바꿔야함.
            Text(mail.subject, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            // 사용자의 프로필 아이콘과 이메일을 Row로 나란히 표시
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // 이름과 이메일을 위로 정렬
              children: [
                InkWell(
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
                              Text("받는 사람 : ${mail.email}"), // 실제로는 다른 데이터를 사용할 것
                              Text("날짜 : ${mail.email}"), // 날짜 형식으로 변경해야 할 수도 있음
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // 대화 상자를 닫습니다.
                                },
                                child: const Text('닫기'),
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
                    size: 60, // 아이콘 크기 조정
                  ),
                ),
                SizedBox(width: 16),
                // 이름과 이메일을 Column으로 세로 정렬
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                  children: [
                    // 이름과 시간을 Row로 나란히 배치
                    Row(
                      children: [
                        Text(mail.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8), // 이름과 시간 사이의 간격 조정
                        Text(
                          "${mail.receiveTime}", // 실제 시간 데이터로 대체해야 합니다.
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text("받는 사람: 나 ${mail.email}"),

                        //Text(mail.email, style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(width: 8,),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // 사용자의 주소를 표시
            Text("내용: ${mail.contents}", style: TextStyle(fontSize: 20), ),
          ],
        ),
      ),
    );
  }
}





/*class SumSumMailDetailPage extends StatelessWidget {
  final Mail mail;

  const SumSumMailDetailPage({Key? key, required this.mail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${mail.name}의 메일 요약",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<MailSum>>(
          future: Services.getMailsSummary([mail]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final summaries = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(mail.subject, style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
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
                                    Text("날짜 : ${mail.receiveDate} ${mail
                                        .receiveTime}"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('닫기'),
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
                          size: 60,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(mail.name, style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Text(
                                "${mail.receiveTime}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text("받는 사람: 나 ${mail.email}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  for (final summary in summaries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("내용: ${summary.summary}",
                            style: TextStyle(fontSize: 20)),
                        SizedBox(height: 8),
                      ],
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}*/


