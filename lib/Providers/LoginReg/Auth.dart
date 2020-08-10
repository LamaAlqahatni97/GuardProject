import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:guardproject/Base/BaseProvider.dart';
import 'package:guardproject/Base/VertificationCode.dart';
import 'package:guardproject/Enums/StateEnums.dart';
import 'package:guardproject/Providers/consts.dart';
import 'package:guardproject/models/User.module.dart';
import 'package:guardproject/models/custom_auth_result.dart';
import 'package:rxdart/rxdart.dart';

class AuthService extends BaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  BehaviorSubject<User> profile = BehaviorSubject();
  User _profile;
  BehaviorSubject<bool> isLoggedS = BehaviorSubject<bool>();
  final fcm = FirebaseMessaging();
  AuthService() {
    fcm.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    fcm.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

      fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
       
      },
      onLaunch: (Map<String, dynamic> message) async {
        
      },
      onResume: (Map<String, dynamic> message) async {}
      
    );
    _auth.onAuthStateChanged.listen(_userEmitting);
  }
  _setIsLogged(bool val) {
    isLoggedS.add(val);
  }

  User get currentUser => _profile;
  Future _userEmitting(FirebaseUser user) async {
    _setIsLogged(user != null);
    if (user != null) {
      final dbUser =
          await _db.collection(USER_COLLECTION).document(user.uid).get();

      _profile = User.fromJson(dbUser.data);
      profile.add(_profile);
      updateMessagingToken(await fcm.getToken());
      return;
    } else {
      profile.add(null);
      return;
    }
  }

  Future<CustomAuthResult> createUser(
      String mail, String pass, String fullName) async {
    try {
      setState(PrState.Fetching);
      final authState = await _auth.createUserWithEmailAndPassword(
          email: mail.trim(), password: pass);
      final newUser = authState.user;
      await _upadateUser(newUser, name: fullName, isCreate: true);
      setState(PrState.Idle);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<CustomAuthResult> login(String mail, String pass) async {
    try {
      setState(PrState.Fetching);
      await _auth.signInWithEmailAndPassword(
          email: mail.trim(), password: pass);
      setState(PrState.Idle);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  connectDevice(String serialNumber) async {
    try {
      final user = await _auth.currentUser();
      final ref = _db.collection(USER_COLLECTION).document(user.uid);

      ref.setData({SERIAL_NUMBER: serialNumber}, merge: true);
      _userEmitting(user);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<CustomAuthResult> _upadateUser(FirebaseUser user,
      {String name, bool isCreate = false}) async {
    try {
      final ref = _db.collection(USER_COLLECTION).document(user.uid);

      final myUser = User(
        displayName: name ?? user.displayName,
        email: user.email,
        uid: user.uid,
      );
      if (isCreate) {
        myUser.serialNumber = VertificationProcess.vertificationCode;
        final token = await fcm.getToken();
        final deviceRef =
            _db.collection(DEVICE_COLLECTIONS).document(myUser.serialNumber);
        deviceRef.setData({"connected": true, "token": token}, merge: true);
      }
      ref.setData(myUser.toJson(), merge: true);
      setState(PrState.Idle);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  CustomAuthResult forgotPassword(String mail) {
    try {
      _auth.sendPasswordResetEmail(email: mail);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<CustomAuthResult> _changePasswordAndEmailWithAuth(
      newMail, oldPass, newpass) async {
    try {
      final currentUser = await _auth.currentUser();
      await currentUser.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(
              email: this.currentUser.email, password: oldPass));

      await currentUser.updatePassword(newpass);
      await currentUser.updateEmail(newMail);

      final ref = _db.collection(USER_COLLECTION).document(currentUser.uid);
      ref.setData({"email": newMail.trim()}, merge: true);

      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }


  Future<CustomAuthResult> _changePasswordWithAuth(
      mail, oldPass, newpass) async {
    try {
      final currentUser = await _auth.currentUser();
      await currentUser.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(
              email: this.currentUser.email, password: oldPass));

      await currentUser.updatePassword(newpass);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  void signOut() {
    _auth.signOut();
    _userEmitting(null);
  }

  Future<CustomAuthResult> updateUserInfo({
    String newName,
    String mail = "",
    String oldPassword = "",
    String newPass = "",
  }) async {
    try {
      setState(PrState.Fetching);
      final currentName = _profile.displayName;
      final currentEmail = _profile.email;
      CustomAuthResult result =
          CustomAuthResult(result: true, message: 'Success');

      if (newName.trim() != currentName) {
        result = await _updateName(newName.trim());
      }
      if (mail.trim() != '' && newPass.trim() != '') {

        result =
            await _changePasswordAndEmailWithAuth(mail, oldPassword, newPass);
      } else {
        if (mail.trim() != currentEmail && oldPassword.trim().isNotEmpty) {
          result = await _updateEmail(mail.trim(), oldPassword);
        }

        if (oldPassword.trim().isNotEmpty &&
            newPass.trim().isNotEmpty &&
            mail.trim().isNotEmpty) {
          result = await _changePasswordWithAuth(mail, oldPassword, newPass);
        }
      }
      final currentUser = await _auth.currentUser();
      await _userEmitting(currentUser);
      if (error.isEmpty) setState(PrState.Idle);
      return result;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<CustomAuthResult> _updateName(String newName) async {
    try {
      final user = await _auth.currentUser();
      final ref = _db.collection(USER_COLLECTION).document(user.uid);
      ref.setData({"displayName": newName.trim()}, merge: true);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<CustomAuthResult> _updateEmail(String newEmail, String oldPass) async {
    try {
      final user = await _auth.currentUser();

      await user.reauthenticateWithCredential(EmailAuthProvider.getCredential(
          email: this.currentUser.email, password: oldPass));

      await user.updateEmail(newEmail.trim());

      final ref = _db.collection(USER_COLLECTION).document(user.uid);
      ref.setData({"email": newEmail.trim()}, merge: true);
      return CustomAuthResult(result: true, message: 'Success');
    } catch (e) {
      return _handleError(e);
    }
  }

  updateMessagingToken(String newToken) async {
    if (currentUser != null && currentUser.serialNumber.isNotEmpty) {
      final deviceRef = _db
          .collection(DEVICE_COLLECTIONS)
          .document(currentUser.serialNumber.toString());
      deviceRef.setData({"token": newToken}, merge: true);
    }
  }

  User getCurrentUserFromFireStore() {
    return _profile;
  }


  Future<bool> sendForgotPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (er) {
      return false;
    }
  }

  Future<bool> isSignedEmail(String mail) async {
    try {
      await _auth.signInWithEmailAndPassword(email: mail, password: 'password');
      return true;
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_USER_NOT_FOUND') {
          return false;
        } else if (signUpError.code == "ERROR_WRONG_PASSWORD") {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }
  }

  CustomAuthResult _handleError(e) {
    setError(e.message);
    return CustomAuthResult.fromErrorCode(e.code);
  }
}




