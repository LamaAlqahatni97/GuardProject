import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:guardproject/Base/BaseProvider.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/Providers/consts.dart';
import 'package:guardproject/models/Information.module.dart';

class InformationService extends BaseProvider {
  Firestore _db = Firestore.instance;
  AuthService _auth = GetIt.I<AuthService>();

  Stream<Information> dataStream() {
    final user = _auth.getCurrentUserFromFireStore();
    if (user.serialNumber == null && user.serialNumber.isEmpty)
      return Stream.empty();

    return _db
        .collection(DEVICE_COLLECTIONS)
        .document(user.serialNumber)
        .snapshots()
        .map((f) => Information.fromDataRef(f));
  }
}
