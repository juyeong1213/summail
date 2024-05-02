
import 'package:get/get.dart';

import '../mail.dart';

class FavoriteController extends GetxController {
  var favorites = <Mail>[].obs; // 즐겨찾기한 사용자 목록을 관리하는 Observable 리스트

  // 사용자의 즐겨찾기 상태를 토글합니다.
  void toggleFavorite(Mail mail) {
    if (mail.isFavorited) {
      mail.isFavorited = false;
      favorites.remove(mail);
    } else {
      mail.isFavorited = true;
      favorites.add(mail);
    }
    update(); // GetxController의 상태를 업데이트합니다.
  }
}
