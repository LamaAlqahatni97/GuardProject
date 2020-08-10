import 'package:flutter/material.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/text_styles.dart';

class SignButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double width;

  SignButton(
      {@required this.text,
      @required this.onPressed,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: Text(
          text,
          style: TextStyles.signButtonStyle,
        ),
      ),
    );
  }
}
