import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/home/view_model/local_provider/whisky_aligned_button_status.dart';

class WhiskeyAlignedButtonList extends StatefulWidget {
  const WhiskeyAlignedButtonList({super.key});

  @override
  State<WhiskeyAlignedButtonList> createState() =>
      _WhiskeyAlignedButtonListState();
}

class _WhiskeyAlignedButtonListState extends State<WhiskeyAlignedButtonList> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => whiskyAlignedButtonStatus(),
        ),
      ],
      child: Consumer<whiskyAlignedButtonStatus>(
        builder: (context, viewModel, _) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: viewModel.buttonStates.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                // _buttons[index],
                WhiskeyAlignedButton(
                    buttonText: viewModel.buttonStates[index].buttonText,
                    index: index,
                    isSelected: viewModel.isSelected(index)),
                SizedBox(width: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WhiskeyAlignedButton extends StatelessWidget {
  final String buttonText;
  final int index;
  final bool isSelected;

  WhiskeyAlignedButton({
    super.key, // 이유없능 오류가 있기에 사용
    required this.buttonText,
    required this.index,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final alignedButtonsProvider = context.watch<whiskyAlignedButtonStatus>();

    return ElevatedButton(
      onPressed: () {
        alignedButtonsProvider.makeAllButtonsUnSelectedExceptOne(index);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor:
            isSelected ? ColorsManager.black200 : ColorsManager.black300,
        backgroundColor:
            isSelected ? ColorsManager.black300 : ColorsManager.black200,

        padding: EdgeInsets.symmetric(horizontal: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isSelected
                ? BorderSide(color: Colors.transparent)
                : BorderSide(color: ColorsManager.black300)),
        // 나중에 함수로 다시 구성해야 할 부분입니다.
        // 버튼안에 글자수에 따라서 버튼의 width를 결정하는 코드입니다
      ),
      child: Text(buttonText,
          maxLines: 1,
          style: isSelected
              ? TextStylesManager()
                  .createHadColorTextStyle("M14", ColorsManager.gray300)
              : TextStylesManager()
                  .createHadColorTextStyle("M14", ColorsManager.black300)),
    );
  }
}
