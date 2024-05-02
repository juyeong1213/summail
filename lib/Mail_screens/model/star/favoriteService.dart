import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static Future<void> toggleFavoriteStatus(int userId, bool isFavorite) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_$userId', isFavorite);
  }

  static Future<bool> getFavoriteStatus(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 수정된 부분: 직접 SharedPreferences 인스턴스에서 값을 조회합니다.
    return prefs.getBool('favorite_$userId') ?? false;
  }
}
