import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_vote.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_event.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/archiving_post_detail_footer.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/cancel_text_button.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/modify_text_button.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/user_critque_container.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/whilabel_divier.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:intl/intl.dart';

//-------- viwe 소개------------
// - 위스키 인식이 성공적일때 유저에게 보여줄 view.

// <안에 들어갈 내용>
// - 양조장 사진
// - 위스키 사진
// - 위스키 맛 특징
// - 바텀 버튼 2개(다시찍기, 등록하기)

// FirebaseStorage _storage = FirebaseStorage.instance;
// Reference _ref = _storage.ref("test/text");

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

   String firebaseImage =
      "https://firebasestorage.googleapis.com/v0/b/whilabel.appspot.com/o/SnsType.KAKAO%2Fkakao:2964055896%2FTimestamp(seconds=1694666852,%20nanoseconds=898934000).jpg?alt=media&token=e578991f-c092-465d-8201-e3df5085a36c";

  final tasteNoteController = TextEditingController();
  List<TasteVote>? tasteVotes; // dataBase의 정보 들어오면 실행 예정
  String? whiskyImageUrl;
  String? distilleryImage;
      // "https://ichibankobe.com/ko/wdps/wp-content/uploads/2016/05/01-6.jpg";
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


    // downloadURLExample("Aultmore");
    // TEstFirebaseStorage().getDistilleryImage(distilleryName);
  }

  Future<void> getWhiskData(ArchivingPostDetailViewModel viewModel)  async {

    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      // status: Text("123244"),
    );
    if (EasyLoading.isShow) {
      Timer(Duration(milliseconds: 1000), () {
        EasyLoading.dismiss();
      });
    }

    Whisky _whiskyData = await viewModel.getWhiskyData(
        widget.archivingPost.barcode, widget.archivingPost.postId);
    await viewModel.getWhiskyData(
        widget.archivingPost.barcode, widget.archivingPost.postId);
    List<String?> distilleryNames =  _whiskyData.wbWhisky?.distilleryName ?? [];

    if (distilleryNames.isNotEmpty){
      distilleryNames = distilleryNames.map((name) => name!.split(" ").join("_")).toList();
      getDistilleryImage(
          distilleryNames.first!);
    }

  setState(() {
    // tasteVotes =     _whiskyData.tasteVotes ?? _whiskyData.wbWhisky!.tasteVotes!;
    whiskyImageUrl =  _whiskyData.imageUrl ?? _whiskyData.wbWhisky!.image_url!;

  });

  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidthSize = MediaQuery.of(context).size.width;
    final viewModel = context.read<ArchivingPostDetailViewModel>();

    return Scaffold(
        body: SafeArea(
          child:
          Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              // 양조장 이미지
                              width: mediaQueryWidthSize,
                              height: 225,
                              child: Image.network(
                                distilleryImage ?? placeHolderDistilleryImageURL,
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 237,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              widget
                                                  .archivingPost.whiskyName,
                                              maxLines: 3,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style:
                                                  TextStylesManager.bold20),
                                          SizedBox(
                                            height:
                                                WhilabelSpacing.space12 / 2,
                                          ),
                                          Text(
                                            "${widget.archivingPost.strength}/\t${widget.archivingPost.location ?? ""}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStylesManager
                                                .createHadColorTextStyle(
                                                    "R14", Colors.grey),
                                          ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
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
                                        ? CancelTextButton(
                                            onClickButton:
                                                cancelModifyfeature)
                                        : ModifyTextButton(
                                            onClickButton: () async {
                                            print("cnamclel");

                                            await viewModel.onEvent(
                                                ArchivingPostDetailEvnet
                                                    .addTasteNoteOnProvider(
                                                        tasteNoteController
                                                            .text));

                                            await ArchivingPostDetailEvnet
                                                .addStarValueOnProvider(
                                                    widget.archivingPost
                                                        .starValue);

                                            await ArchivingPostDetailEvnet
                                                .addTasteFeatureOnProvider(
                                                    widget.archivingPost
                                                        .tasteFeature);

                                            useModifyfeature();
                                          })
                                  ],
                                ),
                                SizedBox(height: WhilabelSpacing.space4),
                                Text(
                                  creatDate + "\t작성",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStylesManager
                                      .createHadColorTextStyle(
                                          "R14", Colors.grey),
                                ),
                                SizedBox(height: WhilabelSpacing.space16),
                                UserCritiqueContainer(
                                    isModify: isModify,
                                    initalStarValue:
                                        widget.archivingPost.starValue,
                                    initalTasteFeature:
                                        widget.archivingPost.tasteFeature,
                                    tasteNoteController:
                                        tasteNoteController),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: mediaQueryWidthSize,
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
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
                                          .createHadColorTextStyle("R16",
                                              ColorsManager.black400),
                                    ),
                                    Text(
                                      "곧 등록될 예정이에요!",
                                      style: TextStylesManager
                                          .createHadColorTextStyle("R16",
                                              ColorsManager.black400),
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
                        padding: EdgeInsets.only(top: 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: whiskyImageUrl != null
                              ? Image.network(
                                  whiskyImageUrl!,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
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
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ArchivingPostDetailFooter(
                  isModify: isModify,
                  postImageUrl: widget.archivingPost.imageUrl,
                  whiskyName: widget.archivingPost.whiskyName,
                  strength: widget.archivingPost.strength.toString(),
                ),
              ),
            ],
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
  Future<void> getDistilleryImage(String distilleryName) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    String? downLoadUrl;
    if (distilleryName != "") {
      print("distilleryName ==> $distilleryName");
      try {
        final storageRef =
        _storage.ref().child("distillery_images/$distilleryName.jpeg");

        downLoadUrl = await storageRef.getDownloadURL();
        print("down load url $downLoadUrl");


          setState(() {
            distilleryImage = downLoadUrl;
          });
        

      }
      catch (e) {
        debugPrint("$e");
        throw Exception('cannot find $distilleryName.jpeg  ');

      }
    }  else {
      debugPrint("distillery 이름이 비어있습니다");
    }
    return;
  }
}
