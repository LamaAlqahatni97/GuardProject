import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:guardproject/Enums/StateEnums.dart';
import 'package:guardproject/Providers/consts.dart';

class BaseProvider extends ChangeNotifier {
  PrState _state = PrState.Idle;
  String _err = "";
  PrState get state => _state;
  String get error => _err;
  void setError(String err) {
    _err = err;
    _state = PrState.Idle;
    if (err.isNotEmpty) {
      Timer.periodic(Duration(seconds: ERROR_WITING_SECONDS), (timer) {
        timer.cancel();
        if (err.isNotEmpty) setError("");
      });
    }
    notifyListeners();
  }

  void setState(value) {
    _state = value;
    _err = "";
    notifyListeners();
  }
}
