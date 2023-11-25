import 'package:flutter/material.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';

class ButtonState {
  ButtonState({
    required this.isSelected,
    required this.postButtonOrder,
  });
  final bool isSelected;
  final PostButtonOrder postButtonOrder;

  ButtonState copyWith({
    bool? isSelected,
    PostButtonOrder? postButtonOrder,
  }) {
    return ButtonState(
      isSelected: isSelected ?? this.isSelected,
      postButtonOrder: postButtonOrder ?? this.postButtonOrder,
    );
  }
}

class whiskyAlignedButtonStatus extends ChangeNotifier {
  // view에 보여지는 버튼의 수가 달라지면 이 변수도 변경해야 함.
  final List<ButtonState> _buttonStates = [
    ButtonState(postButtonOrder: PostButtonOrder.LATEST, isSelected: true),
    ButtonState(postButtonOrder: PostButtonOrder.OLDEST, isSelected: false),
    ButtonState(
        postButtonOrder: PostButtonOrder.HiGHEST_RATING, isSelected: false),
    ButtonState(
        postButtonOrder: PostButtonOrder.LOWEST_RATiNG, isSelected: false),
  ];

  List<ButtonState> get buttonStates => _buttonStates;

  void selectButton(int index) {
    ButtonState selectedButtonState = _buttonStates[index];
    _buttonStates[index] = _buttonStates[index]
        .copyWith(isSelected: !selectedButtonState.isSelected);

    notifyListeners();
  }

  bool isSelected(int index) {
    return _buttonStates[index].isSelected;
  }

  void makeAllButtonsUnSelectedExceptOne(int index) {
    for (int i = 0; i < _buttonStates.length; i++) {
      if (i == index) {
        _buttonStates[i] = _buttonStates[i].copyWith(isSelected: true);
      } else {
        _buttonStates[i] = _buttonStates[i].copyWith(isSelected: false);
      }
    }

    notifyListeners();
  }
}
