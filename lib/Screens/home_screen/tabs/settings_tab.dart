import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';

import 'package:guardproject/Screens/landing_screen/landing_screen.dart';
import 'package:guardproject/Screens/registeration/sign_text_field.dart';
import 'package:guardproject/Widgets/EditButton.dart';
import 'package:guardproject/models/User.module.dart';
import 'package:guardproject/models/custom_auth_result.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/miscell.dart';
import 'package:guardproject/theme/text_styles.dart';
import 'package:guardproject/utils/helpers.dart';

const double hrPadding = 20;
const double vrPadding = 10;
const double edgeRadius = 20;
const PROVIDE_OLD_PASSWORD = "Please provide your old password";

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, String> initalData;
  Map<String, String> currentData = {'name': '', 'email': '', 'password': ''};
  final formData = {'name': '', 'email': '', 'password': ''};

  TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();
  bool _saveActive;
  final _authSer = GetIt.I<AuthService>();
  bool _isEnabledForEdit = false;
  bool _loading;
  // User initalUser;
  @override
  void initState() {
    _saveActive = false;

    _loading = false;
    _passwordController = TextEditingController(text: 'placeholder');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return StreamBuilder<User>(
      stream: _authSer.profile,
      initialData: _authSer.getCurrentUserFromFireStore(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        final user = snapshot.data;
        initalData = {
          'name': user?.displayName,
          'email': user?.email,
          'password': "placeholder"
        };

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // Navigator.of(context)
                  //     .pushNamed(VertificationScreen.routeName);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(edgeRadius),
                      boxShadow: [loginBoxShadow]),
                  height: deviceSize.height * 0.2,
                  width: double.infinity,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user?.displayName ?? "",
                          style: TextStyles.appBarTextStyle,
                        ),
                        Text(
                          user?.email ?? "",
                          style: TextStyles.settIngEmailTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Form(
                autovalidate: false,
                onChanged: formOnChanged,
                key: _formKey,
                child: Container(
                  // height: deviceSize.height * 0.5,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  // width: deviceSize.width * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: hrPadding, vertical: vrPadding),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(edgeRadius),
                      boxShadow: [loginBoxShadow]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Personal Data',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Divider(),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: <Widget>[
                          SignTextField(
                            onChanged: (val) => formData['name'] = val,
                            hintText: 'Full Name',
                            initialValue: initalData['name'],
                            enabled: _isEnabledForEdit,
                            onSaved: (val) => formData['name'] = val,
                            onValidated: (String val) {
                              if (val.trim().isEmpty)
                                return 'Fill the all required fields please';
                              else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SignTextField(
                            hintText: 'Email',
                            initialValue: initalData['email'],
                            enabled: _isEnabledForEdit,
                            onSaved: (val) => formData['email'] = val,
                            onChanged: (val) => formData['email'] = val,
                            onValidated: (String val) {
                              if (val.trim().isEmpty)
                                return 'Fill the all required fields please';
                              else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)) {
                                return "Invalid Email Format";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SignTextField(
                        enabled: _isEnabledForEdit,
                        hintText: 'New Password',
                        controller: _passwordController,
                        onSaved: (val) => formData['password'] = val,
                        onChanged: (val) => formData['password'] = val,
                        obsectureText: true,
                        onValidated: (String val) {
                          if (val.trim().isEmpty)
                            return 'Fill the all required fields please';
                          else if (val.trim().length < 6) {
                            return 'Password is too short';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SignTextField(
                        hintText: 'Confirm New Password',
                        onSaved: (val) {},
                        enabled: _isEnabledForEdit,
                        initialValue: initalData['password'],
                        obsectureText: true,
                        onValidated: (String val) {
                          if (val.trim() != _passwordController.text.trim()) {
                            print(val.trim());
                            print(_passwordController.text.trim());
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          _loading
                              ? SpinKitFadingCircle(
                                  size: 50,
                                  color: AppColors.primaryColor,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    EditButton(
                                      onPressed: openFieldsForEdit,
                                      isActive: true,
                                      width: deviceSize.width * 0.3,
                                      text: 'Edit',
                                    ),
                                    EditButton(
                                      onPressed: validateAndSubmit,
                                      width: deviceSize.width * 0.3,
                                      isActive: _saveActive,
                                      text: 'Save',
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 25,
                          ),
                          FlatButton(
                            onPressed: () {
                              _authSer.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LandingScreen.routeName,
                                  (Route<dynamic> route) => false);
                            },
                            child: Row(
                              children: <Widget>[
                                Transform.scale(
                                  scale: -1,
                                  origin: Offset(0, 0),
                                  child: Icon(
                                    Icons.exit_to_app,
                                    textDirection: TextDirection.rtl,
                                    color: AppColors.greyTextColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Log Out",
                                    style: TextStyles.textLogOutStyle)
                              ],
                            ),
                          ),
                        ],
                      ),
                      // WaitingAndError()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        );
      },
    );
  }

  void openFieldsForEdit() {
    setState(() {
      _isEnabledForEdit = !_isEnabledForEdit;
    });
  }

  _showDlg(CustomAuthResult result) {
    showCustomDialog(
        context: context,
        isPositive: result.result,
        title: result.result ? 'Success' : 'Error',
        content: result.result ? 'Information Updated' : result.message);
  }

  void formOnChanged() {
    if (_formKey.currentState.validate()) {
      bool changed = false;
      initalData.forEach((key, val) {
        if (formData[key].isNotEmpty && formData[key] != val) changed = true;
      });

      if (_saveActive != changed)
        setState(() {
          _saveActive = changed;
        });
    }
  }

  void validateAndSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print(formData);

      setState(() {
        _loading = true;
      });

      if (formData['email'] != initalData['email'] ||
          formData['password'] != initalData['password']) {

        var currentPassword = await showTextDialog(context: context);

        if (currentPassword != null && currentPassword.trim().isNotEmpty) {
          var newPassword =
              formData['password'] == 'placeholder' ? '' : formData['password'];
          setState(() {
            _loading = true;
          });

          var result = await _authSer.updateUserInfo(
              newName: formData['name'],
              mail: formData['email'],
              newPass: newPassword,
              oldPassword: currentPassword);
          setState(() {
            _loading = false;
          });
          _saveActive = false;
          openFieldsForEdit();
          _showDlg(result);
        } else {
          setState(() {
            _loading = false;
          });
          openFieldsForEdit();
        }
      } else {
        setState(() {
          _loading = true;
        });
        var result = await _authSer.updateUserInfo(newName: formData['name']);

        setState(() {
          _loading = false;
        });
        _saveActive = false;
        _showDlg(result);
        openFieldsForEdit();
      }
    }
  }
}
