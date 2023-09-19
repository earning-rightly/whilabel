import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';

class GalleryAlbumPicker extends StatefulWidget {
  final List<String> albumNameList;
  final Function(String albumTitle)? onChangeAlbum;
  // ignore: prefer_const_constructors_in_immutables
  GalleryAlbumPicker({
    Key? key,
    required this.albumNameList,
    this.onChangeAlbum,
  }) : super(key: key);

  @override
  State<GalleryAlbumPicker> createState() => _GalleryAlbumPickerState();
}

class _GalleryAlbumPickerState extends State<GalleryAlbumPicker> {
  List<String> valusList = [];
  String _dropDownText = "";
  @override
  void initState() {
    final viewModel = context.read<CarmeraViewModel>();

    valusList = widget.albumNameList;
    _dropDownText = viewModel.state.albumTitle;
    _dropDownText = valusList.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      alignment: Alignment.center,
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorsManager.gray500,
      ),
      dropdownColor: ColorsManager.black200,
      menuMaxHeight: 300,
      style: TextStyle(color: ColorsManager.gray500),
      value: _dropDownText,
      decoration: returnTextFieldDropDownStyle("", false),
      iconSize: 13,
      onChanged: (String? value) {
        setState(() {
          _dropDownText = value!;
        });
        widget.onChangeAlbum!(value!);
      },
      items: widget.albumNameList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
      isExpanded: false,
    );
  }
}

InputDecoration returnTextFieldDropDownStyle(
  String hintText,
  bool disable,
) {
  return InputDecoration(
    iconColor: ColorsManager.gray500,
    focusColor: ColorsManager.gray500,
    prefixIconColor: ColorsManager.gray500,
    focusedBorder: _outlineInputBorder(ColorsManager.black100),
    border: _outlineInputBorder(ColorsManager.gray500),
    errorBorder: _outlineInputBorder(Colors.red),
    contentPadding: EdgeInsets.only(left: 10, right: 10),
    hintText: hintText,
    fillColor: disable ? Colors.amber : null,
    filled: true,
    suffixIconConstraints: BoxConstraints(minHeight: 20, minWidth: 20),
  );
}

OutlineInputBorder _outlineInputBorder(Color _color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.zero),
    borderSide: BorderSide(color: _color),
  );
}
