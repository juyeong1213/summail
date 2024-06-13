import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Mail_screens/main_mail/json_parse.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ku.png', // 로딩 이미지 파일 경로
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const JsonParse()); // JsonParse 페이지로 이동
              },
              child: const Text('Next Page'),
            ),
          ],
        ),
      ),
    );
  }
}