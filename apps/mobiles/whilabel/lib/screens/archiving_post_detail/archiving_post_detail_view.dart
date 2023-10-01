import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_vote.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_event.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/archiving_post_detail_footer.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/cancel_text_button.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/modify_text_button.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/taste_feature_grid.dart';
import 'package:whilabel/screens/archiving_post_detail/widgets/user_critque_container.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/_global/widgets/whilabel_divier.dart';
import 'package:whilabel/screens/whisky_critique/widget/flavor_recorder.dart';
import 'package:intl/intl.dart';

const String distilleryImageURL =
    "https://ichibankobe.com/ko/wdps/wp-content/uploads/2016/05/01-6.jpg";
const String placeHolderWhiskyImageUrl =
    "gs://whilabel.appspot.com/whilabel/place_holder/whisky_place_holder.png";

const String firebaseImage =
    "https://firebasestorage.googleapis.com/v0/b/whilabel.appspot.com/o/SnsType.KAKAO%2Fkakao:2964055896%2FTimestamp(seconds=1694666852,%20nanoseconds=898934000).jpg?alt=media&token=e578991f-c092-465d-8201-e3df5085a36c";
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
  final tasteNoteController = TextEditingController();
  late List<TasteVote>? tasteVotes;
  String? whiskyImageUrl;
  String? distilleryImage = null;
  bool isloading = true;
  bool isModify = false;
  String creatDate = "";

  @override
  void initState() {
    super.initState();
    // EasyLoading.dismiss();
    final DateTime date1 = DateTime.fromMicrosecondsSinceEpoch(
        widget.archivingPost.createAt!.microsecondsSinceEpoch);

    creatDate = DateFormat("yyyy.MM.dd").format(date1);
    tasteNoteController.text = widget.archivingPost.note;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidthSize = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ChangeNotifierProvider<ArchivingPostDetailViewModel>(
        create: (BuildContext context) =>
            ProvidersManager.callArchivingPostDetailViewModel(),
        child: Builder(builder: (context) {
          final viewModel = context.watch<ArchivingPostDetailViewModel>();

          return SafeArea(
            child: FutureBuilder<Whisky?>(
              future: viewModel.getInitalData(
                  widget.archivingPost.barcode, widget.archivingPost.postId),
              builder: (context, snapshot) {
                if (snapshot.data == null || !snapshot.hasData) {
                  // 현재 유저 정보를 늦게 받아오면
                  return LodingProgressIndicator(
                    offstage: false,
                  );
                }

                final whiskyData = snapshot.data!;
                tasteVotes =
                    whiskyData.tasteVotes ?? whiskyData.wbWhisky?.tasteVotes;
                whiskyImageUrl =
                    whiskyData.imageUrl ?? whiskyData.wbWhisky!.image_url;
                return Stack(
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
                                      distilleryImageURL,
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
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: WhilabelSpacing.spac16 + 4),
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
                                                    widget.archivingPost
                                                        .whiskyName,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStylesManager
                                                        .bold20),
                                                SizedBox(
                                                  height:
                                                      WhilabelSpacing.spac12 /
                                                          2,
                                                ),
                                                Text(
                                                  "${widget.archivingPost.strength}/\t${widget.archivingPost.location ?? ""}",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStylesManager()
                                                      .createHadColorTextStyle(
                                                          "R14", Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(flex: 106, child: SizedBox())
                                        ],
                                      )),
                                  SizedBox(height: WhilabelSpacing.spac12),
                                  BasicDivider(),
                                ],
                              ),
                              SizedBox(height: WhilabelSpacing.spac12),
                              Padding(
                                padding: WhilabelPadding.onlyHoizBasicPadding,
                                child: SizedBox(
                                  width: mediaQueryWidthSize,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      SizedBox(height: WhilabelSpacing.spac4),
                                      Text(
                                        creatDate + "\t작성",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStylesManager()
                                            .createHadColorTextStyle(
                                                "R14", Colors.grey),
                                      ),
                                      SizedBox(height: WhilabelSpacing.spac16),
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
                                    //위스키에 상세에 들어갈 정보를 보여줄 곳입니다.

                                    SizedBox(height: WhilabelSpacing.spac24),

                                    BasicDivider(),
                                    SizedBox(height: WhilabelSpacing.spac24),
                                    Text("{위스키}특징",
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 80) // scroller 하단을 가리지 않기 위해서
                            ],
                          ),
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
                );
              },
            ),
          );
        }),
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
}
