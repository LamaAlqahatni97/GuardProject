import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardproject/Base/BaseProvider.dart';
import 'package:guardproject/Enums/StateEnums.dart';
import 'package:guardproject/Providers/consts.dart';

class VertificationSerive extends BaseProvider {
  final _db = Firestore.instance;

  Future<bool> checkVertification(String code) async {
    setState(PrState.Fetching);
    try {
      final doc = await _db.collection(DEVICE_COLLECTIONS).document(code).get();

      if (!doc.exists) {
        setError("Serial number does not belong to any deivce");
        return false;
      }
      final isConnected = doc.data['connected'];
      if (isConnected != null && isConnected) {
        setError("This device already connected to another account");
        return false;
      }

      setState(PrState.Idle);

      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}
