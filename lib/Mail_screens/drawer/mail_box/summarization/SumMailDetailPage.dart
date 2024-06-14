
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/mail.dart';
import '../../../model/service.dart';
import 'mail.dart';


class SumMailDetailPage extends StatefulWidget {
  final Mail mail;

  const SumMailDetailPage({Key? key, required this.mail}) : super(key: key);

  @override
  _SumMailDetailPageState createState() => _SumMailDetailPageState();
}

class _SumMailDetailPageState extends State<SumMailDetailPage> {
  MailSum? _mailSum;
  bool loading = false;
  String? savedEmail;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail(); // 이메일 로드
    fetchMailSum();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmail = prefs.getString('addmail');
    });
  }

  Future<void> fetchMailSum() async {
    try {
      setState(() {
        loading = true;
      });
      final mailSums = await Services.getMailSumList(widget.mail.messageId.toString());
      setState(() {
        _mailSum = mailSums.isNotEmpty ? mailSums.first : null;
        loading = false;
      });
    } catch (e) {
      print('예외 발생: $e');
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("요약 된 메일"),

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.mail.subject, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                          title: Text(widget.mail.name),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("보낸 사람 : ${widget.mail.email}"),
                              Text("받는 사람 : ${savedEmail ?? '이메일을 찾을 수 없습니다.'}"),
                              Text("날짜 : ${widget.mail.receiveDate} ${widget.mail.receiveTime}"),
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
                        Text(widget.mail.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text(
                          "${widget.mail.receiveTime}",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text("받는 사람: ${savedEmail ?? '이메일을 찾을 수 없습니다.'}"),
                        SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "${_mailSum != null ? _mailSum!.contents : '요약할 수 없음'}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

