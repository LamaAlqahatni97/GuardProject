import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:guardproject/Base/VertificationCode.dart';
import 'package:guardproject/Enums/StateEnums.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/Screens/home_screen/home_screen.dart';
import 'package:guardproject/Screens/registeration/sign_button.dart';
import 'package:guardproject/Screens/registeration/sign_text_field.dart';
import 'package:guardproject/Widgets/faded_appbar.dart';
import 'package:guardproject/theme/colors.dart';

import 'package:guardproject/theme/miscell.dart';
import 'package:guardproject/utils/helpers.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
  static const String routeName = "SignUpScreen";
}

class _SignUpScreenState extends State<SignUpScreen> {
  Map<String, String> formData;
  TextEditingController _confirmController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = GetIt.instance<AuthService>();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _confirmController = TextEditingController();
    formData = {'name': '', 'email': '', 'password': ''};
    super.initState();
  }

  void validateFormAndSubmit() async {
    print(VertificationProcess.vertificationCode);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();


      var result = await _auth.createUser(
          formData["email"], formData["password"], formData["name"]);
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
              child: buildFadedAppbar(context: context, title: 'Sign Up'),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    width: deviceSize.width * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [loginBoxShadow]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Create An Account',
                          style: Theme.of(context).textTheme.title,
                        ),
                        Divider(),
                        SizedBox(
                          height: 15,
                        ),
                        SignTextField(
                          hintText: 'Full Name',
                          onSaved: (val) => formData['name'] = val,
                          onValidated: (String val) {
                            if (val.trim().isEmpty)
                              return 'Name can\'t be empty';
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SignTextField(
                          hintText: 'Email',
                          onSaved: (val) => formData['email'] = val,
                          onValidated: (String val) {
                            if (val.trim().isEmpty)
                              return 'Email can\'t be Empty ';
                            else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val))
                              return 'Please provider a valid email';
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SignTextField(
                          hintText: 'Password',
                          controller: _confirmController,
                          onSaved: (val) => formData['password'] = val,
                          obsectureText: true,
                          onValidated: (String val) {
                            if (val.trim().isEmpty)
                              return 'Passowrd can\'t be Empty ';
                            else if (val.trim().length < 6)
                              return 'Password is shorter than 6 characters';
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SignTextField(
                          hintText: 'Confirm Password',
                          onSaved: null,
                          obsectureText: true,
                          onValidated: (String val) {
                            if (val.trim().isEmpty)
                              return 'Password confirmation can\'t be Empty ';
                            else if (val != _confirmController.text)
                              return 'Passwords do not match';
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'By creating this account you agree to our Terms of Services and Privacy Policy',
                          style: Theme.of(context).textTheme.body2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Consumer<AuthService>(
                          builder: (ctx, model, child) {
                            if (model.state == PrState.Fetching)
                              return SpinKitFadingCircle(
                                color: AppColors.primaryColor,
                                size: 50,
                              );
                            else
                              return SignButton(
                                onPressed: validateFormAndSubmit,
                                width: deviceSize.width * 0.7,
                                text: 'Sign Up',
                              );
                          },
                        )

                        // WaitingAndError()
                      ],
                    ),
                  ),
                ),
              )),
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
          // Align(
          //   child: ,
          //   alignment: Alignment.bottomCenter,
          // )
        ],
      ),
    );
  }
}
