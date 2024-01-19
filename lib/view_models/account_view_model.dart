import 'package:flutter/material.dart';
import 'package:pinterestmobile/models/user_model.dart';
import 'package:pinterestmobile/services/data_service.dart';
import 'package:pinterestmobile/sql/app_database.dart';
import 'package:pinterestmobile/sql/entity/images_list_entity.dart';

class AccountViewModel extends ChangeNotifier {
  Object object = Object();
  String name = "qwerty";
  String email = "qwerty@gmail.com";
  int followers = 12;
  int followings = 17;
  final defaultImage = [];
  bool loading = true;
  List<ImagesListEntity> images = [];

  late final AppDatabase appDatabase;

  void setAppDatabase(AppDatabase value) {
    appDatabase = value;
    notifyListeners();
  }

  Future<void> initAppDatabase() async {
    await $FloorAppDatabase.databaseBuilder("app_database.db").build().then((value) async {
      setAppDatabase(value);
    });
    await loadUsers();
  }

  Future<void> loadUsers() async {
    await getAllImages();
    Users users = await DataService.loadUser();
    name = users.fullName;
    email = users.email;
    loading = false;
    notifyListeners();
  }
  
  /// get all images SQL READ
  Future<void> getAllImages() async {
    images = await appDatabase.imagesList.allImagesList() ?? [];
    notifyListeners();
  }

  /// delete images SQL DELETE
  Future<void> deleteImage(String id) async {
    images.clear();
    await appDatabase.imagesList.deleteById(id);
    await getAllImages();
    notifyListeners();
  }

  /// update images SQL UPDATE
  Future<void> updateImagesIsSelected(ImagesListEntity entity) async {
    images.clear();
    await appDatabase.imagesList.updateImagesList(entity);
    await getAllImages();
    notifyListeners();
  }
}