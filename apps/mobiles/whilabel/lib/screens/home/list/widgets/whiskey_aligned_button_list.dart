import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';
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
    final homeViewModel = context.watch<HomeViewModel>();
    final homeState = homeViewModel.state;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WhiskyAlignedButtonStatus(initPostButtonOrder: homeState.listButtonOrder),
        ),
      ],
      child: Consumer<WhiskyAlignedButtonStatus>(
        builder: (context, viewModel, _) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: viewModel.buttonStates.length,
          itemBuilder: (context, index) {

            return Row(
              children: [
                // _buttons[index],
                WhiskeyAlignedButton(
                    postButtonOrder:
                        viewModel.buttonStates[index].postButtonOrder,
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
  final PostButtonOrder postButtonOrder;
  final int index;
  final bool isSelected;

  WhiskeyAlignedButton({
    super.key, // 이유없능 오류가 있기에 사용
    required this.postButtonOrder,
    required this.index,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final alignedButtonsProvider = context.watch<WhiskyAlignedButtonStatus>();
    final homeViewModel = context.watch<HomeViewModel>();

    return ElevatedButton(
      onPressed: () {
        alignedButtonsProvider.makeAllButtonsUnSelectedExceptOne(index);
        homeViewModel.onEvent(HomeEvent.changeButtonOrder(postButtonOrder));
      },
      style: ElevatedButton.styleFrom(
        foregroundColor:
            isSelected ? ColorsManager.black200 : Colors.transparent,
        backgroundColor:
            isSelected ? ColorsManager.black300 : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isSelected
                ? BorderSide(color: Colors.transparent)
                : BorderSide(color: ColorsManager.black300)),
      ),
      child: Text(postButtonOrder.displayName,
          maxLines: 1,
          style: isSelected
              ? TextStylesManager.createHadColorTextStyle(
                  "M14", ColorsManager.gray300)
              : TextStylesManager.createHadColorTextStyle(
                  "M14", ColorsManager.black300)),
    );
  }
}
