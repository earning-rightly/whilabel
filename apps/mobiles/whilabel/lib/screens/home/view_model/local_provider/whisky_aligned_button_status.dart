import 'package:flutter/material.dart';

class ButtonState {
  ButtonState({
    required this.isSelected,
    required this.buttonText,
  });
  final bool isSelected;
  final String buttonText;

  ButtonState copyWith({
    bool? isSelected,
    String? buttonText,
  }) {
    return ButtonState(
      isSelected: isSelected ?? this.isSelected,
      buttonText: buttonText ?? this.buttonText,
    );
  }
}

class whiskyAlignedButtonStatus extends ChangeNotifier {
  // view에 보여지는 버튼의 수가 달라지면 이 변수도 변경해야 함.
  final List<ButtonState> _buttonStates = [
    ButtonState(buttonText: "최신순", isSelected: true),
    ButtonState(buttonText: "오래된 순", isSelected: false),
    ButtonState(buttonText: "별점 높은 순", isSelected: false),
    ButtonState(buttonText: "별점 낮은 순", isSelected: false),
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
