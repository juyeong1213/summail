import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/star/favoriteController.dart';
import '../../model/star/favoriteService.dart';



class LikedMailPage extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기한 메일'),
      ),
      body: Obx(() => ListView.builder(
        itemCount: favoriteController.favorites.length,
        itemBuilder: (context, index) {
          final mail = favoriteController.favorites[index];
          return ListTile(
            leading: Icon(Icons.mail),
            title: Text(mail.mailFrom),
            trailing: IconButton(
              icon: Icon(
                mail.isFavorited ? Icons.star : Icons.star_border,
                color: mail.isFavorited ? Colors.yellow : Colors.grey,
              ),
              onPressed: () async {
                favoriteController.toggleFavorite(mail);
                // FavoriteService를 사용하여 즐겨찾기 상태를 SharedPreferences에 저장
                await FavoriteService.toggleFavoriteStatus(mail.id, mail.isFavorited);
              },
            ),
          );
        },
      )),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../others/favoriteController.dart';



class LikedMailPage extends StatelessWidget {
  LikedMailPage({Key? key}) : super(key: key);

  // FavoriteController 인스턴스를 Get을 통해 찾거나 없으면 생성합니다.
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기한 메일'),
      ),
      body: Obx(() => ListView.builder(
        itemCount: favoriteController.favorites.length,
        itemBuilder: (context, index) {
          final mail = favoriteController.favorites[index];
          return ListTile(
            title: Text(mail.mailFrom),
            subtitle: Text(mail.mailFrom),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () => favoriteController.toggleFavorite(mail),
            ),
          );
        },
      )),
    );
  }
}
*/
