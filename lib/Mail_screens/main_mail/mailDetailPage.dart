
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/mail.dart';

class MailDetailPage extends StatelessWidget {
  final Mail mail;

  const MailDetailPage({Key? key, required this.mail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mail.mailFrom), // 일단 이름 불러옴
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 사용자의 이름을 큰 글씨로 표시 -> 메일의 제목으로 바꿔야함.
            Text(mail.mailFrom, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                          title: Text(mail.mailFrom),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("보낸 사람 : ${mail.mailFrom}"),
                              Text("받는 사람 : ${mail.mailFrom}"), // 실제로는 다른 데이터를 사용할 것
                              Text("날짜 : ${mail.mailFrom}"), // 날짜 형식으로 변경해야 할 수도 있음
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
                        Text(mail.mailFrom, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8), // 이름과 시간 사이의 간격 조정
                        Text(
                          '시간', // 실제 시간 데이터로 대체해야 합니다.
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text("받는 사람: 나 ${mail.mailFrom}"),
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
            Text("내용: ${mail.mailFrom}", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
