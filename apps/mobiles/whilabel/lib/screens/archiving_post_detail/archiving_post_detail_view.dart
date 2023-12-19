import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_vote.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/_global/whilabel_context_menu.dart';
import 'package:whilabel/screens/_global/widgets/back_listener.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_event.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/distillery_and_strength_text.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/save_text_button.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/modify_text_button.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/user_critque_container.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/whilabel_divier.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:intl/intl.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

//-------- viwe 소개------------
// - 위스키 인식이 성공적일때 유저에게 보여줄 view.

// <안에 들어갈 내용>
// - 양조장 사진
// - 위스키 사진
// - 위스키 맛 특징
// - 바텀 버튼 2개(다시찍기, 등록하기)

class ArchivingPostDetailView extends StatefulWidget {
  final ArchivingPost archivingPost;

  ArchivingPostDetailView({super.key, required this.archivingPost});

  @override
  State<ArchivingPostDetailView> createState() =>
      _ArchivingPostDetailViewState();
}

class _ArchivingPostDetailViewState extends State<ArchivingPostDetailView> {
  String placeHolderDistilleryImageURL =
      "https://ichibankobe.com/ko/wdps/wp-content/uploads/2016/05/01-6.jpg";
  String placeHolderWhiskyImageUrl =
      "gs://whilabel.appspot.com/whilabel/place_holder/whisky_place_holder.png";

  final tasteNoteController = TextEditingController();
  List<TasteVote>? tasteVotes; // dataBase의 정보 들어오면 실행 예정
  String? whiskyImageUrl;
  String? distilleryImage;
  String? distilleryName;
  late ArchivingPost _currentArchivingPost;

  bool isloading = true;
  bool isModify = false;
  String creatDate = "";

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ArchivingPostDetailViewModel>();
    getWhiskData(viewModel);
    // EasyLoading.dismiss();
    final DateTime date1 = DateTime.fromMicrosecondsSinceEpoch(
        widget.archivingPost.createAt!.microsecondsSinceEpoch);

    creatDate = DateFormat("yyyy.MM.dd").format(date1);
    tasteNoteController.text = widget.archivingPost.note;
    _currentArchivingPost = widget.archivingPost;

    // downloadURLExample("Aultmore");
    // TEstFirebaseStorage().getDistilleryImage(distilleryName);
  }

  Future<void> getWhiskData(ArchivingPostDetailViewModel viewModel) async {
   await CustomLoadingIndicator.showLodingProgress(); // 로딩 생성

    CustomLoadingIndicator.dimissonProgress(milliseconds: 1800); //


   Whisky? _whiskyData = await viewModel.getWhiskyData(
        widget.archivingPost.barcode, widget.archivingPost.postId);
   if (_whiskyData != null) {
     await viewModel.getWhiskyData(
         widget.archivingPost.barcode, widget.archivingPost.postId);
     List<String?> distilleryNames = _whiskyData.wbWhisky?.distilleryName ?? [];

     if (distilleryNames.isNotEmpty) {
       distilleryNames =
           distilleryNames.map((name) => name!.split(" ").join("_")).toList();
       getDistilleryImage(distilleryNames.first!);
     }

     setState(() {
       whiskyImageUrl =
           _whiskyData.imageUrl ?? _whiskyData.wbWhisky!.image_url!;
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();

    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    Future.delayed(Duration(milliseconds: 1400), () {
      if (distilleryImage == null) {
        setState(() {
          distilleryImage = placeHolderDistilleryImageURL;
        });
      }
    });

    final mediaQueryWidthSize = MediaQuery.of(context).size.width;
    final viewModel = context.read<ArchivingPostDetailViewModel>();

    return BackListener(
      onBackButtonClick: (){
        bool isAblePop = Navigator.canPop(context);

        if (isAblePop)   Navigator.pop(context);
        else{
          Navigator.pushReplacementNamed(context, Routes.rootRoute);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              // 양조장 이미지
                              width: mediaQueryWidthSize,
                              height: 225,

                              color: ColorsManager.black200,
                              child: distilleryImage == null
                                  ? null
                                  : Image.network(
                                      distilleryImage!,
                                      fit: BoxFit.fill,
                                      frameBuilder: (BuildContext context,
                                          Widget child,
                                          int? frame,
                                          bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        }
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut,
                                          alwaysIncludeSemantics: true,
                                          child: child,
                                        );
                                      },
                                    ),
                            ),
                            SizedBox(height: WhilabelSpacing.space16 + 4),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 237,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_currentArchivingPost.whiskyName != ""
                                              ? _currentArchivingPost.whiskyName
                                              : "위스키를 등록 중입니다",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStylesManager.bold20),
                                          SizedBox(
                                            height: WhilabelSpacing.space12 / 2,
                                          ),
                                          DistilleryAndStrengthText(
                                            distilleryName: distilleryName,
                                            strength: _currentArchivingPost.strength,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(flex: 106, child: SizedBox())
                                  ],
                                )),
                            SizedBox(height: WhilabelSpacing.space12),
                            BasicDivider(),
                          ],
                        ),
                        SizedBox(height: WhilabelSpacing.space12),
                        Padding(
                          padding: WhilabelPadding.onlyHoizBasicPadding,
                          child: SizedBox(
                            width: mediaQueryWidthSize,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "나의 평가",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStylesManager.bold18,
                                    ),
                                    isModify
                                        ? SaveTextButton(onClickButton: () {
                                            showUpdatePostDialog(
                                              context,
                                              onClickedYesButton: () async {
                                                await viewModel.onEvent(
                                                  ArchivingPostDetailEvnet
                                                      .updateUserCritique(),
                                                  callback: () async{
                                                   await viewModel.cleanState();
                                                    Navigator.pushNamed(
                                                      context,
                                                      Routes.rootRoute,
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          })
                                        : ModifyTextButton(
                                            onClickButton: () async {
                                              // await ArchivingPostDetailEvnet
                                              //     .(
                                              //         .archivingPost.starValue);
                                              await viewModel.onEvent(
                                                  ArchivingPostDetailEvnet
                                                      .addTasteNoteOnProvider(
                                                          tasteNoteController
                                                              .text));

                                              await ArchivingPostDetailEvnet
                                                  .addStarValueOnProvider(
                                                      _currentArchivingPost.starValue);

                                              await ArchivingPostDetailEvnet
                                                  .addTasteFeatureOnProvider(
                                                    _currentArchivingPost.tasteFeature);

                                            useModifyfeature();
                                          })
                                  ],
                                ),
                                SizedBox(height: WhilabelSpacing.space4),
                                Text(
                                  creatDate + "\t작성",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStylesManager.createHadColorTextStyle(
                                          "R14", Colors.grey),
                                ),
                                SizedBox(height: WhilabelSpacing.space16),
                                UserCritiqueContainer(
                                    isModify: isModify,
                                    initalStarValue:                                     
                                    _currentArchivingPost.starValue,
                                    initalTasteFeature:
                                    _currentArchivingPost.tasteFeature,
                                    tasteNoteController: tasteNoteController),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: mediaQueryWidthSize,
                          padding:
                              const EdgeInsets.only(top: 10, right: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: WhilabelSpacing.space24),
                              BasicDivider(),
                              SizedBox(height: WhilabelSpacing.space24),

                              Container(
                                padding: EdgeInsets.all(16),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: ColorsManager.black200,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            WhilabelRadius.radius16))),
                                child: Column(
                                  children: [
                                    Text(
                                      "맛 특징과 브랜드 특징이",
                                      style: TextStylesManager
                                          .createHadColorTextStyle(
                                              "R16", ColorsManager.black400),
                                    ),
                                    Text(
                                      "곧 등록될 예정이에요!",
                                      style: TextStylesManager
                                          .createHadColorTextStyle(
                                              "R16", ColorsManager.black400),
                                    ),
                                  ],
                                ),
                              )
                              // DB에 브랜드 데이터가 들어오면 사용 할 코드
                              /* Text("{위스키}특징",
                                       style: TextStylesManager.bold18),
                                   TasteFeatureGrid(tastFeaturs: iconPath),
                                   SizedBox(height: WhilabelSpacing.spac32),
                                   Text("{위스키}특징",
                                       style: TextStylesManager.bold18),
                                   Container(
                                     decoration: BoxDecoration(
                                       color: ColorsManager.black100,
                                       borderRadius: BorderRadius.all(
                                         Radius.circular(14),
                                       ),
                                     ),
                                     padding: const EdgeInsets.all(16.0),
                                     child: FlavorRecorder(
                                       disable: true,
                                     ),
                                  ),*/
                            ],
                          ),
                        ),
                        SizedBox(height: 80)
                        // scroller 하단을 가리지 않기 위해서
                      ],
                    ),

                    // wb whiskyImage
                    Positioned(
                      top: 174,
                      right: 16,
                      child: Container(
                        height: 106,
                        width: 80,
                        // padding: EdgeInsets.only(top: 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: whiskyImageUrl != null
                              ? Image.network(
                                  whiskyImageUrl!,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.low,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress.expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  placeHolderImage,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(top: 6, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorsManager.black400,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                  onPressed: () {
                                    bool isAblePop = Navigator.canPop(context);

                                    if (isAblePop)   Navigator.pop(context);
                                    else{
                                      Navigator.pushReplacementNamed(context, Routes.rootRoute);                                    
                                    }
                                  },
                                  icon: SvgPicture.asset(SvgIconPath.backBold)),
                            ),
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ColorsManager.black400,
                                // color: Color(0x00000080),

                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(SvgIconPath.menu),
                                onPressed: () async {
                              await WhilabelContextMenu.showContextMenuSub(
                                          context,
                                          overlay!.paintBounds.size.width * 0.9,
                                          overlay.paintBounds.size.height * 0.1 + 10)
                                      .then((menuValue) {
                                    switch (menuValue) {
                                      case "share":
                                        WhilabelContextMenu
                                            .sharePostWhiskeyImage(
                                            _currentArchivingPost.imageUrl);
                                        break;

                                      case "delete":
                                        showDeletePostDialog(
                                          context,
                                          onClickedYesButton: () {
                                            homeViewModel.onEvent(
                                                HomeEvent.deleteArchivingPost(
                                                    archivingPostId:
                                                        _currentArchivingPost
                                                            .postId,
                                                    userid:
                                                        _currentArchivingPost
                                                            .userId,
                                                    whiskyName:
                                                        _currentArchivingPost
                                                            .whiskyName),
                                                callback: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                Routes.rootRoute,
                                              );
                                              homeViewModel
                                                  .state
                                                  .listTypeArchivingPosts
                                                  .length;
                                            });
                                          },
                                        );
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void useModifyfeature() {
    setState(() {
      isModify = true;
    });
  }

  void cancelModifyfeature() {
    showMoveHomeDialog(context);
  }

  //  distillery 사진을 받아올 함수
  Future<void> getDistilleryImage(String _distilleryName) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    String? downLoadUrl;
    if (_distilleryName != "") {
      print("distilleryName ==> $_distilleryName");
      try {
        final storageRef =
            _storage.ref().child("distillery_images/$_distilleryName.jpeg");

        downLoadUrl = await storageRef.getDownloadURL();
        print("down load url $downLoadUrl");

        setState(() {
          distilleryImage = downLoadUrl;
          distilleryName = _distilleryName;
        });
      } catch (e) {
        debugPrint("$e");
        throw Exception('cannot find $_distilleryName.jpeg  ');
      }
    } else {
      debugPrint("distillery 이름이 비어있습니다");
    }
    return;
  }
}
