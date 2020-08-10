import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardproject/Screens/home_screen/bottom_nav_item.dart';
import 'package:guardproject/Screens/home_screen/tabs/heart_rate_tab.dart';
import 'package:guardproject/Screens/home_screen/tabs/settings_tab.dart';
import 'package:guardproject/Screens/home_screen/tabs/track_tab.dart';
import 'package:guardproject/Widgets/empty_appbar.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/miscell.dart';
import 'package:guardproject/theme/text_styles.dart';
import 'package:guardproject/utils/available_images.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void animateToPage(int index) {

    _pageController.jumpToPage(index);
  }

  List<Widget> _pages;

  @override
  void initState() {
    _pages = [
      HeartRatePage(
        trackClickFunction: animateToPage,
      ),
      TrackPage(),
      SettingsPage()
    ];
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var totalHeight = deviceSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).viewInsets.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar:
          buildEmptyAppBar(context: context, color: AppColors.scaffoldColor2),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: totalHeight,
          child: Stack(
            children: <Widget>[
              Container(
                height: deviceSize.height * 0.875,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[..._pages],
                  controller: _pageController,
                  onPageChanged: (index) {
                    onTabTapped(index);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: deviceSize.height * 0.125,
                  width: deviceSize.width,
                  decoration: BoxDecoration(
                      boxShadow: [loginBoxShadow],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BottomNavItem(
                        icon: AvailableImages.heart,
                        text: 'Home',
                        style: _currentIndex == 0
                            ? TextStyles.bottomNavItemClickedTextStyle
                            : TextStyles.bottomNavItemnormalTextStyle,
                        onClick: () {
                          animateToPage(0);
                        },
                      ),
                      BottomNavItem(
                        icon: AvailableImages.track,
                        text: 'Track',
                        style: _currentIndex == 1
                            ? TextStyles.bottomNavItemClickedTextStyle
                            : TextStyles.bottomNavItemnormalTextStyle,
                        onClick: () {
                          animateToPage(1);
                        },
                      ),
                      BottomNavItem(
                        icon: AvailableImages.account,
                        text: 'Settings',
                        style: _currentIndex == 2
                            ? TextStyles.bottomNavItemClickedTextStyle
                            : TextStyles.bottomNavItemnormalTextStyle,
                        onClick: () {
                          animateToPage(2);
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
