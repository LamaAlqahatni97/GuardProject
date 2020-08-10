import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardproject/theme/colors.dart';

class BottomNavItem extends StatelessWidget {
  final Function onClick;
  final String text;
  final String icon;
  final TextStyle style;
  BottomNavItem({this.onClick, this.text, this.icon, this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onClick,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              this.icon,
              width: 30,
              height: 30,
              color: AppColors.greyTextColor,
            ),
            Text(
              this.text,
              style: this.style,
            )
          ],
        ),
      ),
    );
  }
}
