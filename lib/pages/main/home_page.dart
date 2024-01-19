import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterestmobile/core/app_colors.dart';
import 'package:pinterestmobile/models/utils.dart';
import 'package:pinterestmobile/pages/detail/detail_page.dart';
import 'package:pinterestmobile/services/log_service.dart';
import 'package:pinterestmobile/sql/entity/images_list_entity.dart';
import 'package:pinterestmobile/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomeViewModel viewModel = HomeViewModel();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    viewModel.scrollController.removeListener(() {});
    viewModel.scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.initAppDatabase();
    viewModel.apiGet();
    viewModel.tabController = TabController(length: 1, vsync: this);
    viewModel.tabController.animateTo(0);
    viewModel.scrollPosition();
  }

  dynamic snackBar;

  void showSnackBar(){
    snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.grey.shade800
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Image downloaded!", style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.3)),),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                    onTap: (){
                        Log.i("Image download");
                    },
                    child: const Text("Show", style: TextStyle(fontSize: 15, color: Colors.blue),)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<HomeViewModel>(
        builder: (ctx, viewModel, widget) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 58,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: TabBar(
                    isScrollable: true,
                    // indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    tabs: viewModel.tabs,
                    controller: viewModel.tabController,
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: viewModel.tabController,
            children: [
              viewModel.isLoading
                  ? Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade800,
                              child: Lottie.asset("assets/anime/lf30_editor_naboxmse.json"))),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Expanded(
                            flex: viewModel.isLoadMore ? 15 : 1,
                            child: MasonryGridView.builder(
                              controller: viewModel.scrollController,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: viewModel.note.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                        return DetailPage(indexImage: viewModel.note[index].urls!.small!);
                                      }),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: viewModel.note[index].urls!.small!,
                                                    placeholder: (context, widget) => AspectRatio(
                                                      aspectRatio: viewModel.note[index].width!/viewModel.note[index].height!,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          color: UtilsColors(value: viewModel.note[index].color!).toColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: const Icon(Icons.save, color: AppColors.red),
                                                onPressed: () async {
                                                  await viewModel.saveImages(ImagesListEntity(
                                                      id: DateTime.now().toString(),
                                                      imageUrl: viewModel.note[index].urls!.small ?? "",
                                                      isSelected: true,
                                                    width: viewModel.note[index].width ?? 0,
                                                    height: viewModel.note[index].width ?? 1,
                                                  )).then((value) {
                                                    Utils.showToast(context, "Image added to favorite");
                                                  });
                                                },
                                                splashRadius: 25,
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [viewModel.note[index].altDescription == null
                                                  ? Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        const Icon(Icons.favorite_rounded, color: Colors.red,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(viewModel.note[index].likes.toString())
                                                      ],
                                                    )
                                                  : SizedBox(
                                                      width: MediaQuery.of(context).size.width / 2 - 60,
                                                      child: viewModel.note[index].altDescription!.length > 50
                                                          ? Text(
                                                              viewModel.note[index].altDescription!, overflow: TextOverflow.ellipsis,
                                                            )
                                                          : Text(viewModel.note[index].altDescription!)),

                                              IconButton(
                                                onPressed: (){
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return buildBottomSheet(context, index, viewModel);
                                                      });
                                                },
                                                icon: const Icon(
                                                  FontAwesomeIcons.ellipsisH,
                                                  color: Colors.black,
                                                  size: 15,
                                                ),
                                                splashRadius: 5,
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                );
                              },
                            ),
                          ),

                          viewModel.isLoadMore
                              ? Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    color: Colors.transparent,
                                    child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.grey.shade800,
                                            child: Lottie.asset("assets/anime/lf30_editor_naboxmse.json"))),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildBottomSheet(BuildContext context, int index, HomeViewModel viewModel) {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),

          // close #icon and text
          SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Share to',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),

          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 20,
                ),

                // telegram #share
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage("assets/images/img_3.png")
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Telegram",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),

                // whatsapp #share
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage:AssetImage("assets/images/img_4.png")
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "WhatsApp",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),

                // message
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage("assets/images/img_1.png")
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Message",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),

                // gmail
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                          radius: 35,
                          foregroundImage: AssetImage("assets/images/img_5.png")
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gmail",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade100,
                        child: const Icon(Icons.more_horiz_outlined, color: Colors.grey, size: 30,),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "More",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            height: 0.5,
            color: Colors.black.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
                viewModel.save(index);
                showSnackBar();
              },
              child: const Text(
                "Download Image",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    Log.i("Hide Pin");
                  },
                  child: const Text(
                    "Hide Pin",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20),
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    Log.i("Report Pin");
                  },
                  child: const Text(
                    "Report Pin",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20),
                  )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    Log.i("Report Pin");
                  },
                  child: Text(
                    "This goes against Pinterest's community guidelines",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 15),
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            height: 0.5,
            color: Colors.black.withOpacity(0.3),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "This Pin is inspired by your recent activity",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}