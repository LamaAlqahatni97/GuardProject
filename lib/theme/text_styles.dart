import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardproject/theme/colors.dart';

class TextStyles {
  static TextStyle textInputStyle = TextStyle(
    color: AppColors.primaryColor,
    fontSize: 18,
  );

  static TextStyle textLogOutStyle = TextStyle(
    color: AppColors.darkRed,
    fontSize: 18,
  );

  static TextStyle landingSignButtonStyle = TextStyle(
      color: AppColors.primaryColor, fontSize: 18, fontWeight: FontWeight.w700);
  static TextStyle errorTextStyle = TextStyle(
      color: AppColors.errorColor, fontSize: 12, fontWeight: FontWeight.w700);
  static TextStyle signButtonStyle =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700);

  static TextStyle appBarTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22);

  static TextStyle settIngEmailTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12);

  static TextStyle textHintStyle = TextStyle(
      color: AppColors.primaryColor, fontWeight: FontWeight.w300, fontSize: 18);

  static TextStyle slimFadedTextStyle = TextStyle(
      color: AppColors.greyTextColor,
      fontWeight: FontWeight.w300,
      fontSize: 16);

  static TextStyle bottomNavItemClickedTextStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryColor);

  static TextStyle bottomNavItemnormalTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.greyTextColor);

  static TextStyle dialogContentTextStyle = TextStyle(
    color: AppColors.greyTextColor,
    fontSize: 20,
  );
}
