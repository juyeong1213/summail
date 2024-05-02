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
  final String mailFrom;
  final String subject;
  final String receiveTime;
  final String contents;
  bool isFavorited;

  Mail({
    required this.id,
    required this.messageId,
    required this.mailFrom,
    required this.subject,
    required this.receiveTime,
    required this.contents,
    this.isFavorited = false,
  });

  // JSON 맵에서 Mail 객체로 변환하기 위한 팩토리 생성자
  factory Mail.fromJson(Map<String, dynamic> json) => Mail(
    id: json["id"],
    messageId: json["messageId"],
    mailFrom: json["mailFrom"],
    subject: json["subject"],
    receiveTime: json["receiveTime"],
    contents: json["contents"],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Mail && runtimeType == other.runtimeType && id == other.id);


  // Mail 객체를 JSON 맵으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() => {
    "id": id,
    "messageId": messageId,
    "mailFrom": mailFrom,
    "subject": subject,
    "receiveTime": receiveTime,
    "contents": contents,
  };
}





/*
import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  int id;
  String name;
  String username;
  String email;
  Address address;
  String phone;
  String website;
  Company company;
  bool isFavorited;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
    this.isFavorited = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    address: Address.fromJson(json["address"]),
    phone: json["phone"],
    website: json["website"],
    company: Company.fromJson(json["company"]),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is User && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "address": address.toJson(),
    "phone": phone,
    "website": website,
    "company": company.toJson(),
  };
}

class Address {
  String street;
  String suite;
  String city;
  String zipcode;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    suite: json["suite"],
    city: json["city"],
    zipcode: json["zipcode"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "suite": suite,
    "city": city,
    "zipcode": zipcode,
  };
}


class Company {
  String name;
  String catchPhrase;
  String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    name: json["name"],
    catchPhrase: json["catchPhrase"],
    bs: json["bs"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "catchPhrase": catchPhrase,
    "bs": bs,
  };
}

class Mail {
  final String id;
  final String title;
  final String content;

  Mail({required this.id, required this.title, required this.content});

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}

*/
