import 'package:flutter/material.dart';

class SendMailPage extends StatefulWidget {
  const SendMailPage({super.key});

  @override
  State<SendMailPage> createState() => _SendMailPageState();

  static fromJson(Map<String, dynamic> jsonItem) {}
}

class _SendMailPageState extends State<SendMailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('보낸 메일함'),
      ),
      body: Center(
        child: Text('보낸 메일함 페이지'),
      ),
    );
  }
}
