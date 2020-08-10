import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardproject/Widgets/custom_dialog.dart';
import 'package:guardproject/Widgets/text_dialog.dart';

Future showCustomDialog(
    {@required BuildContext context,
    @required bool isPositive,
    @required String title,
    @required String content}) async {
  return await showGeneralDialog(
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierLabel: '',
      context: context,
      pageBuilder: ((
        context,
        a1,
        a2,
      ) {}),
      transitionBuilder: (context, a1, a2, child) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: CustomDialog(
              positive: isPositive,
              content: content,
              title: title,
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300));
}


Future<String> showTextDialog(
    {@required BuildContext context,
  }) async {
  return await showGeneralDialog<String>(
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierLabel: '',
      context: context,
      pageBuilder: ((
        context,
        a1,
        a2,
      ) {}),
      transitionBuilder: (context, a1, a2, child) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: TextDialog(
              title: 'Current Password',
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300));
}