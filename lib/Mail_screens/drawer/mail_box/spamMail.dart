import 'package:flutter/material.dart';

class SpamMailPage extends StatefulWidget {
  const SpamMailPage({super.key});

  @override
  State<SpamMailPage> createState() => _SpamMailPageState();
}

class _SpamMailPageState extends State<SpamMailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스펨 메일함'),
      ),
      body: Center(
        child: Text('스펨 메일함 페이지'),
      ),
    );
  }
}
