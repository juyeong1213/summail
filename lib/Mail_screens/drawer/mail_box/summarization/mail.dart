// Dart JSON 디코딩을 위한 import
import 'dart:convert';

// MailSum 객체 리스트를 JSON 문자열에서 디코딩하기 위한 함수
List<MailSum> mailFromJson(String str) => List<MailSum>.from(json.decode(str).map((x) => MailSum.fromJson(x)));

// MailSum 객체 리스트를 JSON 문자열로 인코딩하기 위한 함수
String mailToJson(List<MailSum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MailSum {
  final String messageId;
  final String contents;

  bool isFavorited;

  MailSum({
    required this.messageId,
    required this.contents,
    this.isFavorited = false,
  });

  factory MailSum.fromJson(Map<String, dynamic> json) {
    return MailSum(
      messageId: json["messageId"],
      contents: json["contents"],  // 여기서 'summary'를 'contents'로 변경
    );
  }

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "contents" : contents,  // 여기서 'summary'를 'contents'로 변경
  };
}

