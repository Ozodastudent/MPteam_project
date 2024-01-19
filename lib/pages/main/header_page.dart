import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinterestmobile/core/app_colors.dart';
import 'package:pinterestmobile/core/app_text_style.dart';
import 'package:pinterestmobile/pages/main/account_page.dart';
import 'package:pinterestmobile/pages/main/comment_page.dart';
import 'package:pinterestmobile/pages/main/home_page.dart';
import 'package:pinterestmobile/pages/main/search_page.dart';
import 'package:pinterestmobile/view_models/header_view_model.dart';
import 'package:pinterestmobile/widgets/custom_pictures.dart';
import 'package:provider/provider.dart';

class HeaderPage extends StatefulWidget {
  const HeaderPage({super.key});
  static const String id = 'header_page';

  @override
  State<HeaderPage> createState() => _HeaderPageState();
}

class _HeaderPageState extends State<HeaderPage> {
  final _viewModel = HeaderViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _viewModel,
        child: Consumer<HeaderViewModel>(
          builder: (ctx, model, index) => Scaffold(
            extendBody: true,
            body: PageView(
              controller: _viewModel.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomePage(),
                SearchPage(),
                CommentPage(),
                AccountPage(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              backgroundColor: AppColors.white,
              selectedLabelStyle: AppTextStyle.style400.copyWith(fontSize: 11),
              selectedItemColor: AppColors.primary,
              unselectedLabelStyle: AppTextStyle.style400.copyWith(fontSize: 11),
              unselectedItemColor: AppColors.black,
              items: [
                BottomNavigationBarItem(
                    icon: CustomPictures.icHome.copyWith(color: AppColors.black), label: "Dashboard",
                    activeIcon:  CustomPictures.icHome.copyWith(color: AppColors.primary)
                ),
                BottomNavigationBarItem(
                    icon: CustomPictures.icSearch.copyWith(color: AppColors.black), label: "Search",
                    activeIcon: CustomPictures.icSearch.copyWith(color: AppColors.primary)
                ),
                BottomNavigationBarItem(
                    icon: CustomPictures.icChatSmile.copyWith(color: AppColors.black), label: "Chat",
                    activeIcon: CustomPictures.icChatSmile.copyWith(color: AppColors.primary)
                ),
                BottomNavigationBarItem(
                    icon: CustomPictures.icProfile.copyWith(color: AppColors.black), label: "Profile",
                    activeIcon: CustomPictures.icProfile.copyWith(color: AppColors.primary)
                ),
              ],
              currentIndex: _viewModel.selectedIndex,
              onTap: (int index) => _viewModel.pageControl(index),
            ),
          ),
        )
    );
  }
}