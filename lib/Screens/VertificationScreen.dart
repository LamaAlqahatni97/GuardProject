import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guardproject/Base/BaseWidget.dart';
import 'package:guardproject/Base/VertificationCode.dart';
import 'package:guardproject/Providers/VertificationCode.dart';
import 'package:guardproject/Screens/registeration/sign_button.dart';
import 'package:guardproject/Screens/registeration/sign_up_screen.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/miscell.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class VertificationScreen extends StatelessWidget {
  VertificationScreen({Key key}) : super(key: key);
  static const String routeName = "VertificationScreen";

  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              // exit(0);
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: AppColors.greyTextColor,
            ),
          ),
        ),
        body: Container(
          height: deviceSize.height,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: deviceSize.height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Enter Code"),
                      Text(
                        "******",
                        style: TextStyle(
                            color: AppColors.darkRed,
                            fontSize: 30,
                            letterSpacing: 5),
                      ),
                      Text("The bracelet has a 6 digits vertification code."),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: deviceSize.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.greyTextColor),
                      boxShadow: [vertificationBoxShadow],
                    ),
                    child: BaseWidget<VertificationSerive>(
                      provider: VertificationSerive(),
                      builder: (context, pr, child) => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          pr.error.isNotEmpty
                              ? Text(pr.error,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                  ))
                              : SizedBox.shrink(),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: PinInputTextField(
                              controller: _ctrl,
                              decoration: UnderlineDecoration(
                                  lineHeight: 1,
                                  gapSpace: 5,
                                  color: AppColors.greyTextColor),
                              pinLength: 6,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: SignButton(
                              onPressed: () async {
                                if (await _onSubmit(pr))
                                  Navigator.of(context)
                                      .popAndPushNamed(SignUpScreen.routeName);
                              },
                              text: "Submit",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onSubmit(VertificationSerive ser) async {
    final code = _ctrl.text;

    if (code.trim().isEmpty) {
      ser.setError("Serial number can\'t be empty");
      return false;
    }
    if (code.length < 6) {
      ser.setError("Serial number must be at least 6 digits");
      return false;
    }
    final isValid = await ser.checkVertification(code);
    if (!isValid) {
      _ctrl.text = "";
      return false;
    }
    VertificationProcess.vertificationCode = code;

    return true;
  }
}
