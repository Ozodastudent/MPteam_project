import 'package:flutter/material.dart';
import 'package:pinterestmobile/models/pinterest_model.dart';
import 'package:pinterestmobile/services/http_service.dart';

class CommentViewModel extends ChangeNotifier {
  List<Post> note = [];
  List<Post> imageList = [];
  bool isLoadMore = false;
  bool isLoading = true;
  int count = 10;
  late int pageIndex = 0;

  Future<void> random() async {
    String? response = await HttpService.getMethod(HttpService.apiTodoListRandom, HttpService.randomPage(count));
    List<Post> list = HttpService.parseResponse(response!);

    note.addAll(list);
    notifyListeners();
  }

  Future<void> randomBasicImage(int countImage) async {
    String? response = await HttpService.getMethod(HttpService.apiTodoListRandom, HttpService.randomPage(countImage));
    List<Post> list = HttpService.parseResponse(response!);

      imageList.clear();
      imageList.addAll(list);
  notifyListeners();
  }

  void tabControl(int index) {
    pageIndex = index;
    notifyListeners();
  }

}