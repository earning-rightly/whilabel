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

class WhiskyAlignedButtonStatus extends ChangeNotifier {
  final PostButtonOrder initPostButtonOrder;
  List<ButtonState> _buttonStates = [];

  WhiskyAlignedButtonStatus({required this.initPostButtonOrder}) {

    _buttonStates = PostButtonOrder.values
        .map((postButtonOrder) => ButtonState(
        postButtonOrder: postButtonOrder,
        isSelected: postButtonOrder == initPostButtonOrder ? true : false))
        .toList();
  }

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
