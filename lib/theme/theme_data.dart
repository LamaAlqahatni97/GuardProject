import 'package:flutter/material.dart';
import 'package:guardproject/theme/colors.dart';

final ThemeData mainTheme = ThemeData(
    primaryColor: AppColors.primaryColor, //black
    accentColor: Color(0xffFFFFFF), //white
    errorColor: AppColors.errorColor, //red
    buttonColor: AppColors.primaryColor, //blue
    hintColor: Color(0xff858993), //darkgrey
    scaffoldBackgroundColor: AppColors.scaffoldColor1,
    fontFamily: 'poppins',
    appBarTheme: AppBarTheme(
        color: AppColors.scaffoldColor2, brightness: Brightness.light),


    textTheme: TextTheme(
      title: TextStyle(
        fontSize: 22,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w700,
      ),
      display3: TextStyle(
          fontSize: 22,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w400),
      display1: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      display2: TextStyle(
        color: Colors.white,
        fontSize: 28,
      ),
      body2: TextStyle(
        fontSize: 14,
        color: AppColors.primaryColor,
      ),
      button: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
    ) // headline: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
    );
