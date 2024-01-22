import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp_team_project/models/utils.dart';
import 'package:mp_team_project/services/log_service.dart';
import 'package:mp_team_project/view_models/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final String indexImage;
  const DetailPage({super.key, required this.indexImage});

  static const String id = "detail_page";
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailViewModel viewModel = DetailViewModel();
  late String imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageUrl = widget.indexImage;
    viewModel.scrollPosition();
    viewModel.apiGet();
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
      child: Consumer<DetailViewModel>(
        builder: (ctx, viewModel, widget) => SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              controller: viewModel.scrollController,
              child: Column(
                children: [
                  // user #info
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(23.0),
                          child: Column(
                            children: [
                              Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      placeholder: (context, index) => Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(23.0),
                                            color: Colors.grey
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                        child: IconButton(
                                          onPressed: (){},
                                          icon: const Icon(FontAwesomeIcons.ellipsisH, color: Colors.white,size: 30,),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.white.withOpacity(0.4),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon: const Icon(Icons.zoom_in, color: Colors.black, size: 30,),
                                            ),
                                          )
                                      ),
                                    ),
                                  ]
                              ),


                              const SizedBox(
                                height: 15,
                              ),

                              SizedBox(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        Log.i("comment");
                                      },
                                      icon: const Icon(FontAwesomeIcons.comment, color: Colors.black,),
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          elevation: 0,
                                          onPressed: (){},
                                          height: 60,
                                          shape: const StadiumBorder(),
                                          color: Colors.grey.withOpacity(0.3),
                                          child: const Text("View", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        MaterialButton(
                                          elevation: 0,
                                          height: 60,
                                          shape: const StadiumBorder(),
                                          onPressed: (){},
                                          color: Colors.red.shade800,
                                          child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        Log.i("comment");
                                      },
                                      icon: const Icon(Icons.share, color: Colors.black,),
                                    ),

                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      color: Colors.white,
                    ),
                    child: const Column(
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("More likes this", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ),

                  // Image builder
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: MasonryGridView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: viewModel.notes.length,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                return DetailPage(indexImage: viewModel.notes[index].urls!.small!);
                              })
                              );
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(23.0),
                                child: CachedNetworkImage(
                                  imageUrl: viewModel.notes[index].urls!.small!,
                                  placeholder: (context, widget) => AspectRatio(
                                    aspectRatio: viewModel.notes[index].width!/viewModel.notes[index].height!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: UtilsColors(value: viewModel.notes[index].color!).toColor(),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
