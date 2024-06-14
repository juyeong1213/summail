import 'dart:convert';

// JSON 문자열을 SendMail 객체 리스트로 디코딩하기 위한 함수
List<SendMail> sendMailFromJson(String str) => List<SendMail>.from(json.decode(str).map((x) => SendMail.fromJson(x)));

// SendMail 객체 리스트를 JSON 문자열로 인코딩하기 위한 함수
String sendMailToJson(List<SendMail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// SendMail 모델 클래스
class SendMail {
  final String messageId;
  final String sender;
  final String receiver;
  final String subject;
  final String snippet;
  bool isFavorited;

  SendMail({
    required this.messageId,
    required this.sender,
    required this.receiver,
    required this.subject,
    required this.snippet,
    this.isFavorited = false,
  });

  factory SendMail.fromJson(Map<String, dynamic> json) {
    return SendMail(
      messageId: json["messageId"].toString(),
      sender: json["sender"] ?? '',
      receiver: json["receiver"],
      subject: json["subject"],
      snippet: json["snippet"],
      isFavorited: json["isFavorited"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "messageId": messageId,
    "sender": sender,
    "receiver": receiver,
    "subject": subject,
    "snippet": snippet,
    "isFavorited": isFavorited,
  };
}