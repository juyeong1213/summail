class Spam {
  final String id;
  final String subject;
  final String snippet;

  Spam({
    required this.id,
    required this.subject,
    required this.snippet,
  });

  factory Spam.fromJson(Map<String, dynamic> json) {
    return Spam(
      id: json['id'],
      subject: json['subject'],
      snippet: json['snippet'],
    );
  }
}
