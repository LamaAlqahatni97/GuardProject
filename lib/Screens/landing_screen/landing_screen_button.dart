import 'package:flutter/material.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/text_styles.dart';

class LandingScreenButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  LandingScreenButton({@required this.onPressed, @required this.text});
  @override
  Widget build(BuildContext context) {
    var totalHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: totalHeight * 0.08,
      child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: Text(
          this.text,
          style: TextStyles.landingSignButtonStyle,
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
