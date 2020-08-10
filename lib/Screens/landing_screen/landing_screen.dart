import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardproject/Screens/VertificationScreen.dart';

import 'package:guardproject/Screens/landing_screen/landing_screen_button.dart';
import 'package:guardproject/Screens/registeration/login_screen.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/utils/available_images.dart';

class LandingScreen extends StatelessWidget {
  static const String routeName = '/landing-screen';

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor2,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: <Widget>[
            Spacer(),
            Image.asset(
              AvailableImages.appLogo,
              fit: BoxFit.cover,
              width: deviceSize.width * 0.8,
              height: deviceSize.height * 0.5,
            ),
            Spacer(),
            LandingScreenButton(
              onPressed: () {
                Navigator.of(context).pushNamed(VertificationScreen.routeName);
              },
              text: 'Sign Up',
            ),
            SizedBox(
              height: 30,
            ),
            LandingScreenButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              text: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
