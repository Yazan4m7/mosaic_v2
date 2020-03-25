import 'package:flutter/material.dart';
import 'package:mosaic/Utils/utils.dart';

class CustomTextStyle {
  static TextStyle previewCaseSmallFont(BuildContext context) {
    return Theme.of(context).textTheme.headline1.copyWith(
        fontFamily: "montserrat", fontSize: screenAwareSize(15.0, context), fontWeight: FontWeight.bold, color: Colors.grey);
  }
  static TextStyle previewCaseLargeFont(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .headline1
        .copyWith(
        fontFamily: "montserrat",
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white);
  }
  static TextStyle buttonsFont(BuildContext context) {
    return Theme.of(context).textTheme.headline1.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(58, 66, 86, 1.0),
        backgroundColor: Colors.white);
  }
}
