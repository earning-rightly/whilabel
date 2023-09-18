// ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_event.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_view_model.dart';

// ignore: must_be_immutable
class CritiqueViewWhiskyInfoFooter extends StatelessWidget {
  CritiqueViewWhiskyInfoFooter({
    Key? key,
  }) : super(key: key);

  bool isfilled = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WhiskyCritiqueViewModel>();
    final state = viewModel.state;
    final appUserViewModel = context.watch<CurrentUserStatus>();
    return FutureBuilder<bool>(
      future: viewModel.isChangeStareValue(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          isfilled = true;
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: ColorsManager.black100,
              border: Border(
                  top: BorderSide(width: 1, color: ColorsManager.black200))),
          height: 75,
          width: 340,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 40,
                child: Image.file(fit: BoxFit.cover, state.image!),
              ),
              SizedBox(width: WhilabelSpacing.spac12),
              Expanded(
                flex: 149,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        state.whiskyName,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    state.whiskyLocation != null
                        ? SizedBox(
                            child: Text(
                              "${state.whiskyLocation}\t${state.strength}%",
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        : SizedBox(
                            child: Text(
                              "\t${state.strength}%",
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(width: WhilabelSpacing.spac12),
              Expanded(
                flex: 96,
                child: ElevatedButton(
                  child: Text("저장하기"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.brown100,
                  ),
                  onPressed: isfilled == false
                      ? null
                      : () async {
                          final appUser = await appUserViewModel.getAppUser();
                          viewModel.onEvent(
                            SaveArchivingPostOnDb(
                              appUser!.uid,
                              viewModel.state.starValue,
                              viewModel.state.tasteNote.toString(),
                              viewModel.state.tasteFeature!,
                            ),
                            callback: () {},
                          );
                        },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
