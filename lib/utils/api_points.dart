class ApiEndPoints {
  static const String baseUrl = 'http://ec2-13-125-246-135.ap-northeast-2.compute.amazonaws.com'; // 혹은 'https://'

  static final _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  String get listEmailUrl => '${ApiEndPoints.baseUrl}/api/box';  //메일 목록 받기
  String get contentsEmailUrl => '${ApiEndPoints.baseUrl}/api/box/{messageId}'; //메일 리스트 중 보고 싶은 컨텐???
  String get authUrl => '${ApiEndPoints.baseUrl}/login/google'; //소셜로그인
  String get registerUrl => '${ApiEndPoints.baseUrl}/sign-up';  //일반 회원가입
  String get loginUrl => '${ApiEndPoints.baseUrl}/login';
  String get clientIdUrl => '${ApiEndPoints.baseUrl}/api/mail_list';
  String get registerationUrl => '${ApiEndPoints.baseUrl}/add/google';

}
