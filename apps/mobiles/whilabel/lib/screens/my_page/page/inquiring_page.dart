import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/_global/widgets/text_field_length_counter.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_view_model.dart';

class InquiringPage extends StatelessWidget {
  InquiringPage({
    Key? key,
  }) : super(key: key);

  final messageTextContoller = TextEditingController();
  final nameTextContoller = TextEditingController();
  final userEmailTextContoller = TextEditingController();
  final subjectTextContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyPageViewModel>();
    final AppUser appUser = context.watch<CurrentUserStatus>().state.appUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("1:1 문의하기"),
      ),
      body: SafeArea(
        child: Padding(
          padding: WhilabelPadding.basicPadding,
          child: Stack(
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: WhilabelSpacing.spac24),
                    Text(
                      "답변받으실 이메일",
                      style: TextStylesManager.createHadColorTextStyle(
                          "B16", ColorsManager.gray200),
                    ),
                    TextFormField(
                      style: TextStylesManager.regular16,
                      decoration: createLargeTextFieldStyle(""),
                      controller: userEmailTextContoller,
                      scrollPadding: EdgeInsets.symmetric(vertical: 20),
                      maxLines: 1,
                    ),
                    SizedBox(height: WhilabelSpacing.spac8),
                    Text(
                      "문의 제목",
                      style: TextStylesManager.createHadColorTextStyle(
                          "B16", ColorsManager.gray200),
                    ),
                    TextFormField(
                      style: TextStylesManager.regular16,
                      decoration: createLargeTextFieldStyle(""),
                      controller: subjectTextContoller,
                      scrollPadding: EdgeInsets.symmetric(vertical: 20),
                      maxLines: 1,
                    ),
                    SizedBox(height: WhilabelSpacing.spac8),
                    // Text("nickName"),
                    // TextFormField(
                    //   style: TextStylesManager().createHadColorTextStyle(
                    //       "R16", ColorsManager.gray500),
                    //   decoration: createLargeTextFieldStyle(""),
                    //   controller: nameTextContoller,
                    //   scrollPadding: EdgeInsets.symmetric(vertical: 20),
                    //   maxLines: 1,
                    // ),
                    SizedBox(height: WhilabelSpacing.spac8),
                    Text(
                      "문의 내용",
                      style: TextStylesManager.createHadColorTextStyle(
                          "B16", ColorsManager.gray200),
                    ),
                    TextFormField(
                      style: TextStylesManager.regular16,
                      decoration: createLargeTextFieldStyle(""),
                      controller: messageTextContoller,
                      scrollPadding: EdgeInsets.symmetric(vertical: 20),
                      maxLines: 7,
                      maxLength: 1000,
                      buildCounter: (
                        _, {
                        required currentLength,
                        maxLength,
                        required isFocused,
                      }) =>
                          TextFieldLengthCounter(
                        currentLength: currentLength,
                        maxLength: maxLength!,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    child: LongTextButton(
                        buttonText: "보내기",
                        onPressedFunc: () async {
                          EasyLoading.show(
                            maskType: EasyLoadingMaskType.black,
                          );

                          final value = await viewModel.sendEmail(
                              uid: appUser.uid,
                              userEmail: userEmailTextContoller.text,
                              subject: subjectTextContoller.text,
                              message: messageTextContoller.text);

                          if (EasyLoading.isShow) {
                            EasyLoading.dismiss();
                            if (value) {
                              showSimpleDialog(context, "email 등록 성공",
                                  "3~4안에 꼭 답변을 드리겠습니다. \n답변주셔서 감사합니다");
                            } else {
                              showSimpleDialog(context, "email 등록 실패",
                                  "죄송합니다. 원인 불명으로 이메밀을 등록이 실패하였습니다./n빠른 시일낼에 조치하겠습니다");
                            }
                            // Navigator.;
                          }
                        }),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> sendEmail({
    required String name,
    required String userEmail,
    required String subject,
    required String message,
  }) async {
    final serviceId = "service_3adi8hl";
    final templateId = "template_my18n2o";
    final publicKey = "_Qt-1oUmn42sVZh02";
    final privateKey = "x29hnJw91Yh5FnQi5EEyA";

    try {
      await EmailJS.send(
        serviceId,
        templateId,
        // templateParams,
        {
          'subject': subject,
          'name': name,
          'user_email': userEmail,
          'message': message,
        },
        Options(
          publicKey: publicKey,
          privateKey: privateKey,
        ),
      );
      debugPrint('SUCCESS!');
      return true;
    } catch (error) {
      debugPrint('fail!!!');

      debugPrint(error.toString());
      return false;
    }
  }
}
