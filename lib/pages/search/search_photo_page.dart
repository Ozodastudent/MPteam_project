import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_team_project/models/utils.dart';
import 'package:mp_team_project/pages/detail/detail_page.dart';
import 'package:mp_team_project/services/log_service.dart';
import 'package:mp_team_project/view_models/search_photo_view_model.dart';
import 'package:provider/provider.dart';


class SearchPhoto extends StatefulWidget {
  final String search;

  const SearchPhoto({Key? key, required this.search}) : super(key: key);
  static const String id = 'home_page';

  @override
  _SearchPhotoState createState() => _SearchPhotoState();
}

class _SearchPhotoState extends State<SearchPhoto> with SingleTickerProviderStateMixin {
  SearchPhotoViewModel viewModel = SearchPhotoViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.searchPost(widget.search);
    viewModel.searchImage();
    viewModel.scrollPosition();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    viewModel.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<SearchPhotoViewModel>(
        builder: (ctx, viewModel, widget) => Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  controller: viewModel.textEditingController,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    viewModel.note.clear();
                    viewModel.searchImage();
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for ideas',
                      prefixIcon: Icon(Icons.search, color: Colors.black,),
                      suffixIcon: Icon(Icons.camera_alt, color: Colors.black,)
                  ),
                ),
              ),
            ),
          ),
          body: viewModel.isLoading
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
                  flex: viewModel.isLoadMore ? 12 : 1,
                  child: MasonryGridView.builder(
                    controller: viewModel.scrollController,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: viewModel.note.length,
                    itemBuilder: (context, index) {
                      return viewOfSearchPhoto(context, index);
                    },
                  ),
                ),
                viewModel.isLoadMore
                    ? Expanded(
                  flex: 1,
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
        ),
      ),
    );
  }

  GestureDetector viewOfSearchPhoto(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return DetailPage(indexImage: viewModel.note[index].urls!.small!);
          })
          );
        },
        child: Column(
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
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return buildBottomSheet(
                                  context);
                            });
                      },
                      child: const Icon(
                        FontAwesomeIcons.ellipsisH,
                        color: Colors.black,
                        size: 15,
                      ))
                ],
              ),
            )
          ],
        )
    );
  }

  SizedBox buildBottomSheet(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / (3 / 2) + 10,
      width: MediaQuery.of(context).size.width,
      child: Column(
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
                    onPressed: () {},
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
              children: const [
                SizedBox(
                  width: 20,
                ),

                // telegram #share
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        radius: 35,
                        foregroundImage: NetworkImage(
                            "https://www.vectorico.com/download/social_media/Telegram-Icon.png"),
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
                SizedBox(
                  width: 20,
                ),

                // whatsapp #share
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        radius: 35,
                        foregroundImage: NetworkImage(
                            "https://icon-library.com/images/whatsapp-png-icon/whatsapp-png-icon-9.jpg"),
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
                SizedBox(
                  width: 20,
                ),

                // gmail #share
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        radius: 35,
                        foregroundImage: NetworkImage(
                            "https://cdn.icon-icons.com/icons2/730/PNG/512/gmail_icon-icons.com_62758.png"),
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
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                  onTap: () {
                    Log.i("Download Image");
                  },
                  child: const Text(
                    "Download Image",
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
