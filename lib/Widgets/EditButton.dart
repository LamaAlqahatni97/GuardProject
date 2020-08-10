import 'package:flutter/material.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/text_styles.dart';

class EditButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isActive;
  final double width;
  const EditButton(
      {Key key,
      this.text,
      this.onPressed,
      this.isActive = false,
      this.width = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      child: FlatButton(
        child: Text(
          text,
          style: isActive
              ? TextStyles.signButtonStyle
              : TextStyles.signButtonStyle
                  .copyWith(color: AppColors.greyTextColor),
        ),
        onPressed: isActive ? onPressed : null,
        disabledColor: AppColors.scaffoldColor1,
        color: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(5, 30)),
          side: BorderSide(width: 0.5, color: AppColors.lightBlue),
        ),
      ),
    );
  }
}
