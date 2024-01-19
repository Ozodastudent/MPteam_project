import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinterestmobile/models/pinterest_model.dart';
import 'package:pinterestmobile/services/http_service.dart';
import 'package:pinterestmobile/services/log_service.dart';
import 'package:pinterestmobile/sql/app_database.dart';
import 'package:pinterestmobile/sql/entity/images_list_entity.dart';

class HomeViewModel extends ChangeNotifier {
  late TabController tabController;
  late final ScrollController scrollController = ScrollController();

  List<Post> note = [];
  bool isLoading = true;
  bool isLoadMore = false;
  bool isDownload = false;
  bool isSave = false;

  late final AppDatabase appDatabase;

  void setAppDatabase(AppDatabase value) {
    appDatabase = value;
    notifyListeners();
  }

  Future<void> initAppDatabase() async {
    debugPrint("\nhhhhhhhh\n");
    await $FloorAppDatabase.databaseBuilder("app_database.db").build().then((value) async {
      setAppDatabase(value);
    });
  }

  Future<void> saveImages(ImagesListEntity entity) async {
    isSave = true;
    notifyListeners();
    await appDatabase.imagesList.insertImagesList(entity);
    isSave = false;
    notifyListeners();
  }

  void _showResponse(String response) {
    List<Post> list = HttpService.parseResponse(response);
    note = list;
    isLoading = false;
    notifyListeners();
  }

  void apiGet() {
    HttpService.getMethod(HttpService.apiTodoList, HttpService.paramEmpty())
        .then((value) {
      if (value != null) {
        _showResponse(value);
      }
    });
  }
  Map <String, String> urlD= {};

  Future<void> random() async {
    String? response = await HttpService.getMethod(HttpService.apiTodoListRandom, HttpService.randomPage(10));
    List<Post> list = HttpService.parseResponse(response!);

    note.addAll(list);
    isLoadMore = false;

    notifyListeners();
  }

  scrollPosition() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {

          isLoadMore = true;
        notifyListeners();

        random();
      }
    });

  }
  List<Tab> tabs = [
    const Tab(
      height: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          'All',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  ];

  save(int index) async {
    var status = await Permission.storage.request();
    if(status.isGranted) {
      var response = await Dio().get(
          note[index].urls!.small!,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100,
          name: DateTime.now().toString());
        Log.i("Hello success => $result");
    }
  }

  late int colorIndex;


}