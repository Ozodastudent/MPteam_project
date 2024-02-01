import 'package:flutter/cupertino.dart';
import 'package:mp_team_project/models/photoidea_model.dart';
import 'package:mp_team_project/services/http_service.dart';
import 'package:mp_team_project/services/log_service.dart';

class SearchPhotoViewModel extends ChangeNotifier {
  late final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  int pageNumber = 1;


  List<Post> note = [];
  bool isLoading = true;
  bool isLoadMore = false;

  scrollPosition() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {

          isLoadMore = true;
        notifyListeners();
        searchImage();
      }
    });
  }

  void searchPost(String widget) async {
    String image = widget;
    dynamic response = await HttpService.getMethod(HttpService.apiTodoSearch, HttpService.paramsSearch(pageNumber, image));
    List<Post> newPosts = HttpService.parseSearchParse(response);

      note.addAll(newPosts);
      textEditingController.text = widget;
      Log.i(textEditingController.text);
      isLoadMore = false;
      pageNumber += 1;
      isLoading = false;
      image = textEditingController.text.trim().toString();

  }

  void searchImage() async {
    String image = textEditingController.text.trim().toString();
    dynamic response = await HttpService.getMethod(HttpService.apiTodoSearch, HttpService.paramsSearch(pageNumber, image));
    List<Post> newPosts = HttpService.parseSearchParse(response);

      note.addAll(newPosts);
      isLoadMore = false;
      pageNumber += 1;
      isLoading = false;
    notifyListeners();
  }

}