import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterestmobile/models/utils.dart';
import 'package:pinterestmobile/pages/detail/detail_page.dart';
import 'package:pinterestmobile/view_models/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String id = "search_page";
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchViewModel viewModel = SearchViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.random();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<SearchViewModel>(
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
                  onEditingComplete: () => viewModel.searchImage(context),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height / (5/2),
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        aspectRatio: 9/14,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, int index, widget){
                        return  AspectRatio(
                          aspectRatio: 16/9,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: viewModel.pageViewRandom.isNotEmpty ? viewModel.pageViewRandom[index].urls!.regular! : "https://www.groupestate.gr/images/joomlart/demo/default.jpg",
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                color: viewModel.pageViewRandom.isNotEmpty ? UtilsColors(value: viewModel.pageViewRandom[index].color!).toColor() : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Ideas from creators", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),),
                const SizedBox(
                  height: 15,
                ),
                ideaFromCreators(viewModel),
                const SizedBox(
                  height: 20,
                ),
                const Text("Shopping spotlight", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                      return DetailPage(indexImage: viewModel.spotLightRandom[viewModel.spotLightRandom.length - 1].urls!.small!);
                      })
                    );
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                            image: NetworkImage(viewModel.spotLightRandom.isNotEmpty ? viewModel.spotLightRandom[viewModel.spotLightRandom.length - 1].urls!.small! : "https://chonjiacademy.com/wp-content/uploads/2017/04/default-image-620x600.jpg"),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(viewModel.spotLightRandom.isNotEmpty ? viewModel.spotLightRandom[viewModel.spotLightRandom.length - 1].user!.name! : "", style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Popular on Pinterest", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),),
                const SizedBox(
                  height: 15,
                ),
                popularOn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Idea from creators
  Widget ideaFromCreators(SearchViewModel viewModel){
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.listViewRandom.length + 1,
        itemBuilder: (context, index){
          if (viewModel.listViewRandom.length != index) {
            return Stack(
            children: [
              Container(
                margin: index != viewModel.listViewRandom.length - 1 ? const EdgeInsets.only(left: 7) : const EdgeInsets.only(left: 7, right: 7),
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 3 - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: viewModel.listViewRandom[index].urls!.regular!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: UtilsColors(value: viewModel.listViewRandom[index].color!).toColor(),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width / 6 - 10.5,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: viewModel.listViewRandom[index].user?.profileImage?.large != null ? CircleAvatar(
                    radius: 19,
                    foregroundImage: NetworkImage(viewModel.listViewRandom[index].user!.profileImage!.large!),
                  ) : const CircleAvatar(
                    radius: 19,
                    foregroundImage: NetworkImage("https://www.pngitem.com/pimgs/m/35-350426_profile-icon-png-default-profile-picture-png-transparent.png"),
                  ),
                ),
              )
            ],
          );
          } else {
            return Container(
            margin: const EdgeInsets.only(right: 7),
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
            child: Center(
              child: MaterialButton(
                elevation: 0,
                onPressed: (){},
                height: 60,
                minWidth: MediaQuery.of(context).size.width / 3 - 20,
                shape: const StadiumBorder(),
                color: Colors.grey.withOpacity(0.3),
                child: const Text("View all", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
              ),
            ),
          );
          }
        },
      ),
    );
  }

  // popular on pinterest
  Widget popularOn(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: MasonryGridView.builder(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          itemCount: viewModel.gridViewRandom.length,
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return DetailPage(indexImage: viewModel.gridViewRandom[index].urls!.small!);
                })
                );
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 7,
                child: Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2-10.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: viewModel.gridViewRandom[index].urls!.regular!,
                          placeholder:(context, url) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: UtilsColors(value: viewModel.gridViewRandom[index].color!).toColor(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width/2-10.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.5),
                          ]
                        )
                      ),
                      child: Text(viewModel.gridViewRandom[index].user?.lastName != null ? viewModel.gridViewRandom[index].user!.lastName : "Open image", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}