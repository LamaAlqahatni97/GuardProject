import 'package:cloud_firestore/cloud_firestore.dart';

class Information {
  int serialNumber;
  double latitude;
  double longitude;
  double heartBeat;
  String state;

  Information(
      {this.serialNumber,
      this.latitude,
      this.longitude,
      this.heartBeat,
      this.state});

  Information.fromJson(Map<String, dynamic> json) {
    var number = json['serialNumber'] is String
        ? int.tryParse(json['serialNumber'])
        : json['serialNumber'] ?? '';
    serialNumber = (number is String)? int.tryParse(number):number;
    latitude = (json['latitude']).toDouble() ?? 0;
    longitude = (json['longitude']).toDouble() ?? 0;
    heartBeat = (json['heartBeat']).toDouble() ?? 0;
    state = json['state'] ?? "";
  }

  Information.fromDataRef(DocumentSnapshot doc) {
    final json = doc.data;
    Information.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['heartBeat'] = this.heartBeat;
    return data;
  }
}
