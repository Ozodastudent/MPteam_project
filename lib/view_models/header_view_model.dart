import 'package:flutter/cupertino.dart';

class HeaderViewModel extends ChangeNotifier {
  late final PageController pageController = PageController();
  late int selectedIndex = 0;

  void indexManage(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void pageControl(int index) {
    selectedIndex = index;
    notifyListeners();
    pageController.jumpToPage(index);
  }

}