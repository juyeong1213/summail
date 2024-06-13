// Dart JSON 디코딩을 위한 import
import 'dart:convert';

// MailSum 객체 리스트를 JSON 문자열에서 디코딩하기 위한 함수
List<MailSum> mailFromJson(String str) => List<MailSum>.from(json.decode(str).map((x) => MailSum.fromJson(x)));

// MailSum 객체 리스트를 JSON 문자열로 인코딩하기 위한 함수
String mailToJson(List<MailSum> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// MailSum 모델 클래스
class MailSum {
  final String summary;

  bool isFavorited;

  MailSum({
    required this.summary,
    this.isFavorited = false,
  });

  factory MailSum.fromJson(Map<String, dynamic> json) {
    return MailSum(
      summary: json["summary"],
    );
  }

  Map<String, dynamic> toJson() => {
    "summary" : summary,
  };
}

