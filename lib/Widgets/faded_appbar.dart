import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardproject/theme/text_styles.dart';

Widget buildFadedAppbar({@required BuildContext context, String title}) {
  var deviceSize = MediaQuery.of(context).size;
  return PreferredSize(
    preferredSize: Size.fromHeight(deviceSize.height * 0.35),
    child: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.transparent,
          size: 25,
        ),
      ),
      title: Text(
        title.toUpperCase(),
        style: TextStyles.appBarTextStyle,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
    ),
  );
}
