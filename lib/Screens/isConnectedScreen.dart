import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Providers/LoginReg/Auth.dart';
import '../models/User.module.dart';
import 'NotConnectedScreen.dart';
import 'VertificationScreen.dart';

class IsConnectedScreen extends StatefulWidget {
  final Function onReady;
  IsConnectedScreen({Key key, this.onReady}) : super(key: key);

  @override
  _IsConnectedScreenState createState() => _IsConnectedScreenState();
}

class _IsConnectedScreenState extends State<IsConnectedScreen> {
  final _auth = GetIt.I<AuthService>();
  bool isNotConnected = true;
  var isVerOpened = false;

  @override
  void initState() {
    super.initState();
    _auth.profile.listen(_doesHaveAConnectedDevice);
  }

  _doesHaveAConnectedDevice(User user) async {
    if (user == null) return;
    isNotConnected = user?.serialNumber == null || user.serialNumber.isEmpty;

    if (isNotConnected && !isVerOpened) {
      isVerOpened = true;
      await Navigator.of(context).pushNamed(VertificationScreen.routeName);
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return isNotConnected ? NotConnectedScreen() : widget.onReady();
  }
}
