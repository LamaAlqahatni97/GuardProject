import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardproject/theme/text_styles.dart';
import 'package:guardproject/utils/available_images.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final bool positive;
  CustomDialog(
      {@required this.title, @required this.content, @required this.positive});
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
          width: deviceSize.width * 0.9,
          height: deviceSize.height * 0.35,
          padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(30)),
          child: Stack(
            //C7F0CC
            children: <Widget>[
              Align(
                child: this.positive
                    ? SvgPicture.asset(
                        AvailableImages.dialogOk,
                        color: Color(0xffC7F0CC),
                        height: 100,
                        width: 100,
                      )
                    : SvgPicture.asset(
                        AvailableImages.dialogError,
                        color: Color(0xffF5E3E7),
                        height: 100,
                        width: 100,
                      ),
                alignment: Alignment.topCenter,
              ),
              Column(
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.title,
                  ),
                 
                  Expanded(
                                      child: AutoSizeText(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyles.dialogContentTextStyle,
                    ),
                  ),
                  
                  Divider(
                    height: 0,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      'OK',
                      style: Theme.of(context).textTheme.title,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
