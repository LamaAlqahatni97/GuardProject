import 'package:guardproject/Providers/consts.dart';

class User {
  String uid;
  String displayName;
  String email;

  String serialNumber;

  User({
    this.uid,
    this.displayName,
    this.email,
    this.serialNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? "";
    displayName = json['displayName'] ?? "";
    email = json['email'] ?? "";
    serialNumber = json[SERIAL_NUMBER] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();

    json['uid'] = uid;
    json[SERIAL_NUMBER] = serialNumber;
    json['displayName'] = displayName;
    json['email'] = email;

    return json;
  }
}
