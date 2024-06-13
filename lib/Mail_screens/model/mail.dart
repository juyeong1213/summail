// Dart JSON 디코딩을 위한 import
import 'dart:convert';

// Mail 객체 리스트를 JSON 문자열에서 디코딩하기 위한 함수
List<Mail> mailFromJson(String str) => List<Mail>.from(json.decode(str).map((x) => Mail.fromJson(x)));

// Mail 객체 리스트를 JSON 문자열로 인코딩하기 위한 함수
String mailToJson(List<Mail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Mail 모델 클래스
class Mail {
  final int id;
  final String messageId;
  final String name;
  final String email;
  final String subject;
  final String receiveDate;
  final String receiveTime;
  final String contents;
  bool isFavorited;

  Mail({
    required this.id,
    required this.messageId,
    required this.name,
    required this.email,
    required this.subject,
    required this.receiveDate, // 생성자에서 날짜를 받음
    required this.receiveTime, // 생성자에서 시간을 받음
    required this.contents,
    this.isFavorited = false,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    // 'mailFrom'을 공백 기준으로 분리하여 'name'과 'email' 추출
    var parts = json["mailFrom"].split(RegExp(r"\s+"));
    String name = parts.length > 1 ? parts[0] : ""; // 첫 부분을 이름으로 설정
    String email = parts.length > 1 ? parts.sublist(1).join(" ") : parts.join(" "); // 나머지 부분을 이메일로 설정

    // "receiveTime": "Fri, 05 Apr 2024 10:10:01 GMT" 형식의 문자열을 처리
    var dateTimeParts = json["receiveTime"].split(" ");
    String date = dateTimeParts.sublist(0, 4).join(" "); // 날짜 부분
    String time = dateTimeParts[4]; // 시간 부분

    return Mail(
      id: json["id"],
      messageId: json["messageId"],
      name: name,
      email: email,
      subject: json["subject"],
      receiveDate: date,
      receiveTime: time,
      contents: json["contents"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "messageId": messageId,
    "mailFrom": "$name $email",
    "subject": subject,
    "receiveDate": receiveDate,
    "receiveTime": receiveTime,
    "contents": contents,
  };
}

