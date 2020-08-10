import 'package:guardproject/Base/BaseProvider.dart';
import 'package:guardproject/models/User.module.dart';
import 'package:rxdart/rxdart.dart';

class SettingProvider extends BaseProvider {
  BehaviorSubject<bool> isActive = BehaviorSubject();
  bool isTheSameEmail;
  User initalUser;

  SettingProvider({this.initalUser});

  onValueChanged({String userName, String email, String pass}) {
    isTheSameEmail =
        initalUser.email.toLowerCase().trim() == email.toLowerCase().trim();

    if (initalUser == null) return false;
    isActive.add(initalUser.displayName != userName.trim() ||
        initalUser.email != email.trim() ||
        pass.trim().isNotEmpty);
  }


}
