import 'package:flutter/material.dart';

import 'package:guardproject/Screens/landing_screen/landing_screen_button.dart';
import 'package:guardproject/theme/colors.dart';

class SudoAppbar extends StatelessWidget {
  final String text1;
  final String text2;
  final Color color;
  final Function onPressed;
  SudoAppbar(
      {this.color = AppColors.heartRateSudoAppbarColor,
      this.text1,
      this.text2,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(20),
      height: deviceSize.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.heartRateSudoAppbarColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
                      child: Text(
              this.text1,
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .display2
                  .copyWith(color: Colors.white),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,child:
          Text(
            this.text2,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(color: Colors.white),
          ),),
          SizedBox(height: 10,),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,child:
          LandingScreenButton(
            onPressed: (){
              this.onPressed(1);
            },
            text: 'Track your child\'s location',
          ))
        ],
      ),
    );
  }
}
