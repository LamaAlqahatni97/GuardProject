import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:guardproject/Enums/StateEnums.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/Screens/home_screen/home_screen.dart';
import 'package:guardproject/Screens/registeration/sign_button.dart';
import 'package:guardproject/Screens/registeration/sign_text_field.dart';
import 'package:guardproject/Widgets/faded_appbar.dart';
import 'package:guardproject/theme/colors.dart';

import 'package:guardproject/theme/miscell.dart';
import 'package:guardproject/theme/text_styles.dart';
import 'package:guardproject/utils/helpers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  static const String routeName = "LoginScreen";
}

TextEditingController _mail;
final _auth = GetIt.I<AuthService>();

class _LoginScreenState extends State<LoginScreen> {
  Map<String, String> formData;
  var isResetPassword = false;

  GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _mail = TextEditingController();
    formData = {'email': '', 'password': ''};
    super.initState();
  }

  Future<void> validateFormAndSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      print(formData);
      final result = await _auth.login(formData['email'], formData['password']);
      if (!result.result)
        showCustomDialog(
            context: context,
            isPositive: false,
            title: 'Error',
            content: result.message);
      else
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
    }
  }

  Future<void> forgotPassword() async {
    if (_formKey.currentState.validate()) {
      var isPositive = false;
      var content = "WWWWWW";
      var title = "Error";
      final emailText = _mail.text;
      if (emailText.isEmpty ||
          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(emailText)) {
        content =
            "Email is Empty or isn't Valid, Please provide a valid email and try again";
      } else {
        var result = await _auth.sendForgotPasswordEmail(emailText);

        if (result) {
          content = "An email with instructions has been sent to $emailText";
          title = "Thank you";
          isPositive = true;
        } else {
          content = "A user with this email could not be found";
          title = "ERROR";
          isPositive = false;
        }
      }

      showCustomDialog(
          context: context,
          isPositive: isPositive,
          title: title,
          content: content);
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            child: Container(
              height: deviceSize.height * 0.35,
              width: deviceSize.width,
              child: buildFadedAppbar(context: context, title: 'Log In'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: 400,
                  width: deviceSize.width,
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [loginBoxShadow]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isResetPassword ? 'Forgot Password' : 'Log In',
                        style: Theme.of(context).textTheme.title,
                      ),
                      isResetPassword
                          ? Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Enter the Email associated with your account",
                                textAlign: TextAlign.center,
                                style: TextStyles.textHintStyle.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      Divider(),
                      Spacer(),
                      SignTextField(
                        hintText: 'Email',
                        onSaved: (val) => formData['email'] = val,
                        controller: _mail,
                        onValidated: (String val) {
                          if (val.trim().isEmpty)
                            return 'Fill all the required fields please';
                          else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val))
                            return 'Please provide a valid email';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      isResetPassword
                          ? Container()
                          : SignTextField(
                              hintText: 'Password',
                              onSaved: (val) => formData['password'] = val,
                              obsectureText: true,
                              onValidated: (String val) {
                                if (val.trim().length < 6)
                                  return 'Password is too short';
                                else
                                  return null;
                              },
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isResetPassword = !isResetPassword;
                          });
                        },
                        child: Text(
                          isResetPassword ? "Cancel" : 'FORGOT PASSWORD',
                          style: TextStyles.slimFadedTextStyle,
                        ),
                      ),
                      Spacer(),
                      Consumer<AuthService>(
                        builder: (ctx, model, child) {
                          if (model.state == PrState.Fetching)
                            return SpinKitFadingCircle(
                              color: AppColors.primaryColor,
                              size: 50,
                            );
                          else
                            return SignButton(
                              onPressed: () {
                                isResetPassword
                                    ? forgotPassword()
                                    : validateFormAndSubmit();
                              },
                              width: deviceSize.width * 0.7,
                              text: isResetPassword ? "Send" : 'Log In',
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
          )
        ],
      ),
    );
  }
}
