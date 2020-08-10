import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/Screens/NoDataScreen.dart';
import 'package:guardproject/Widgets/sudo_appbar.dart';
import 'package:guardproject/models/Information.module.dart';
import 'package:guardproject/models/User.module.dart';
import 'package:guardproject/theme/colors.dart';
import 'package:guardproject/theme/text_styles.dart';
import 'package:guardproject/utils/available_images.dart';

class HeartRatePage extends StatefulWidget {
  final Function trackClickFunction;
  HeartRatePage({this.trackClickFunction});
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation slideAnim;
  final _auth = GetIt.I<AuthService>();

  int lastHB = 0;
  bool showError = false;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 400,
        ));
    slideAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor2,
      body: StreamBuilder<User>(
        stream: _auth.profile,
        builder: (BuildContext context, AsyncSnapshot<User> userSnap) {
          if (!userSnap.hasData) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return NoDataScreen();
            }
          }
          final user = userSnap.data;
          final serial = user.serialNumber;

          final doc = _db.collection("devices").document(serial).snapshots();
          return Container(
            child: StreamBuilder(
              stream: doc,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> deviceSnap) {
                if (!deviceSnap.hasData) {
                  if (deviceSnap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return NoDataScreen();
                  }
                }
                final info = Information.fromJson(deviceSnap.data.data);
                final isDanger = info.state.toLowerCase() == "abnormal";

                lastHB = info.heartBeat.toInt();
                if (lastHB != 0) showError = false;
                animate(isDanger);
                if (lastHB == 0) {
                  Future.delayed(Duration(seconds: 4), () {
                    if (lastHB == 0) showError = true;
                    if (this.mounted) {
                      setState(() {});
                    }
                  });
                }
                if (showError ||
                    info.state.toLowerCase() == 'no heart beat information')
                  return Center(
                    child: Stack(
                      //C7F0CC
                      children: <Widget>[
                        Align(
                          child: SvgPicture.asset(
                            AvailableImages.dialogError,
                            color: Color(0xffF5E3E7),
                            height: 100,
                            width: 100,
                          ),
                          alignment: Alignment.center,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'ERROR',
                                style: Theme.of(context).textTheme.title,
                              ),
                              AutoSizeText(
                                'The bracelet is not connected, please check the service.',
                                textAlign: TextAlign.center,
                                style: TextStyles.dialogContentTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                else
                  return Container(
                    child: Column(
                      children: <Widget>[
                        if (isDanger)
                          SlideTransition(
                            position: Tween<Offset>(
                                    begin: Offset(0, -1), end: Offset(0, 0))
                                .animate(CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.elasticOut)),
                            child: SudoAppbar(
                              text1: user.displayName,
                              text2: 'Your child needs you',
                              onPressed: widget.trackClickFunction,
                            ),
                          ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: deviceSize.height * 0.40,
                                child: Stack(
                                  children: <Widget>[
                                    FlareActor(
                                      AvailableImages.heartRateAnimation,
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      animation: "Untitled",
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            info.heartBeat.toStringAsFixed(0),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 48,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'BPM',
                                            style: Theme.of(context)
                                                .textTheme
                                                .title,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  // onTap: animate,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Child State: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3),
                                      TextSpan(
                                          text: info.state,
                                          style:
                                              Theme.of(context).textTheme.title)
                                    ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void animate(bool isDanger) {
    if (isDanger)
      _controller.forward();
    else
      _controller.reverse();
  }
}
