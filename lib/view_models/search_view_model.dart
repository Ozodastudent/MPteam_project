import 'package:flutter/material.dart';
import 'package:pinterestmobile/models/pinterest_model.dart';
import 'package:pinterestmobile/pages/search/search_photo_page.dart';
import 'package:pinterestmobile/services/http_service.dart';
import 'package:pinterestmobile/services/log_service.dart';

class SearchViewModel extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  List<Post> spotLightRandom = [];
  List<Post> pageViewRandom = [];
  List<Post> gridViewRandom = [];
  List<Post> listViewRandom = [];

  int count = 13;
  bool isLoading = true;
  bool isLoadMore = false;

  Future<void> random() async {
    String? response = await HttpService.getMethod(HttpService.apiTodoListRandom, HttpService.randomPage(count));
    List<Post> list = HttpService.parseResponse(response!);

      spotLightRandom.addAll(list.getRange(0, 1));
      pageViewRandom.addAll(list.getRange(1, 4));
      gridViewRandom.addAll(list.getRange(4, 10));
      listViewRandom.addAll(list.getRange(10, 13));
      notifyListeners();

      Log.i("Length => ${list.length}");
  }

  Future<void> searchImage(BuildContext context) async {
    String searchData = textEditingController.text.trim().toString();
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return SearchPhoto(search: searchData);
    }));
  }
}