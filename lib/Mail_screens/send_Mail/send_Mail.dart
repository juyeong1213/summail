import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:summail/Mail_screens/send_Mail/sendMailService.dart';

class SendMail extends StatefulWidget {
  const SendMail({super.key});

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  final String senderEmail = "myemail@example.com";
  final String user = "user123"; // 사용자 정보를 여기에 설정하세요

  @override
  void dispose() {
    _receiverController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }

  Future<void> _sendMail() async {
    bool success = await SendMailService.sendMail(
      user,
      senderEmail,
      _receiverController.text,
      _subjectController.text,
      _contentController.text,
      _attachmentController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메일이 성공적으로 전송되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메일 전송에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메일 작성'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMail, // 전송 버튼을 클릭했을 때 _sendMail 함수를 호출합니다.
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _receiverController,
                decoration: InputDecoration(
                  hintText: '받는 사람',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: '보낸 사람: $senderEmail'), // 보낸 사람의 이메일을 표시합니다.
                readOnly: true, // 이 필드는 읽기 전용입니다.
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: '제목',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '이메일 작성',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _attachmentController,
                decoration: InputDecoration(
                  hintText: '첨부 파일 경로',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*
class SendMail extends StatefulWidget {
  const SendMail({super.key});

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final String senderEmail = "myemail@example.com";

  @override
  void dispose() {
    _receiverController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _sendMail() async {
    bool success = await SendMailService.sendMail(
      _receiverController.text,
      senderEmail,
      _subjectController.text,
      _contentController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메일이 성공적으로 전송되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메일 전송에 실패했습니다.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메일 작성'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMail, // 전송 버튼을 클릭했을 때 _sendMail 함수를 호출합니다.
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _receiverController,
                decoration: InputDecoration(
                  hintText: '받는 사람',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: '보낸 사람: $senderEmail'), // 보낸 사람의 이메일을 표시합니다.
                readOnly: true, // 이 필드는 읽기 전용입니다.
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: '제목',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '이메일 작성',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
