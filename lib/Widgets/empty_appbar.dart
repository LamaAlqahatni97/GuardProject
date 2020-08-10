import 'package:flutter/material.dart';
import 'package:guardproject/theme/colors.dart';

Widget buildEmptyAppBar(
    {@required BuildContext context, Color color = AppColors.primaryColor}) {
  return PreferredSize(
    child: AppBar(
      backgroundColor: color,
      elevation: 0.0,
    ),
    preferredSize: Size.fromHeight(0.0),
  );
}
