import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardproject/Screens/registeration/sign_text_field.dart';
import 'package:guardproject/theme/text_styles.dart';

class TextDialog extends StatefulWidget {
  final String title;

  TextDialog({
    @required this.title,
  });

  @override
  _TextDialogState createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {
  TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
          width: deviceSize.width * 0.9,
          height: deviceSize.height * 0.45,
          padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title,
                style: Theme.of(context).textTheme.title,
              ),
              AutoSizeText(
                'Please enter you current password',
                textAlign: TextAlign.center,
                style: TextStyles.dialogContentTextStyle,
              ),
              SignTextField(
                controller: _ctrl,
                hintText: 'Current Password',
                obsectureText: true,
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
                  Navigator.of(context).pop(_ctrl.text);
                },
              )
            ],
          )),
    );
  }
}
