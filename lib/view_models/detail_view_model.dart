import 'package:flutter/material.dart';
import 'package:pinterestmobile/models/pinterest_model.dart';
import 'package:pinterestmobile/services/http_service.dart';

class DetailViewModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  int seeMore = 3;
  List<Post> notes = [];
  bool isLoading = true;
  bool isLoadMore = false;

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

  void _showResponse(String response) {
    List<Post> list = HttpService.parseResponse(response);
      notes = list;
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

  Future<void> random() async {
    String? response = await HttpService.getMethod(HttpService.apiTodoListRandom, HttpService.randomPage(10));
    List<Post> list = HttpService.parseResponse(response!);
      notes.addAll(list);
      isLoadMore = false;
    notifyListeners();
  }

}