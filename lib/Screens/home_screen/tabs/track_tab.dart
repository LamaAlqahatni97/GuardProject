import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/models/Information.module.dart';
import 'package:guardproject/theme/miscell.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

const double CAMERA_ZOOM = 18;
const double CAMERA_TILT = 75;
const double CAMERA_BEARING = 90;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(41.108716, 29.029128);

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  LocationData currentLocation;

  LocationData destinationLocation;

  Location location;

  Future initialize() async {
    location = new Location();
    location.changeSettings(distanceFilter: 2, interval: 2000);
    polylinePoints = PolylinePoints();
    location.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });
    Firestore.instance
        .collection('devices')
        .document(Provider.of<AuthService>(context, listen: false)
            .currentUser
            .serialNumber)
        .snapshots()
        .map((f) => Information.fromJson(f.data))
        .listen((doc) {
      if (doc != null) {
        destinationLocation = LocationData.fromMap(
            {"latitude": doc.latitude, "longitude": doc.longitude});

        updateDestPin();
      }
    });

    await setSourceAndDestinationIcons();

    await setInitialLocation();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    //_controller = null;
    super.dispose();
  }

  void updateDestPin() async {
    if (destinationLocation.latitude != 0 &&
        destinationLocation.longitude != 0) {
      setState(() {
        var destPosition =
            LatLng(destinationLocation.latitude, destinationLocation.longitude);

        _markers.removeWhere((m) => m.markerId.value == 'destPin');

        _markers.add(Marker(
            markerId: MarkerId('destPin'),
            position: destPosition,
            icon: destinationIcon));
      });

      updatePolylines();
    }
  }

  void updatePinOnMap() {
    try {
      if (currentLocation == null) return;
      setState(() {
        var pinPosition =
            LatLng(currentLocation.latitude, currentLocation.longitude);

        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            position: pinPosition,
            icon: sourceIcon));
      });

      updatePolylines();
    } catch (er) {}
  }

  void updatePolylines() async {
    try {
      setState(() {
        _polylines = null;
      });
      if (destinationLocation == null ||
          currentLocation == null ||
          destinationLocation.latitude == 0 ||
          destinationLocation.longitude == 0) return;
      polylineCoordinates = [];
      List<PointLatLng> result =
          await polylinePoints.getRouteBetweenCoordinates(
              'AIzaSyDV-MCInoKVHPzbfKhzIqPl8mn04dLtCEc',
              currentLocation.latitude,
              currentLocation.longitude,
              destinationLocation.latitude,
              destinationLocation.longitude);

      if (result.isNotEmpty) {
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        var updatedLines = Set<Polyline>();

        updatedLines.add(Polyline(
            width: 5,
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
        setState(() {
          _polylines = updatedLines;
        });
      }
    } catch (er) {
      print(er);
    }
  }

  void setPolylines() async {
    try {
      if (destinationLocation == null ||
          currentLocation == null ||
          destinationLocation.latitude == 0 ||
          destinationLocation.longitude == 0) return;
      polylineCoordinates = [];
      List<PointLatLng> result =
          await polylinePoints.getRouteBetweenCoordinates(
              'AIzaSyDV-MCInoKVHPzbfKhzIqPl8mn04dLtCEc',
              currentLocation.latitude,
              currentLocation.longitude,
              destinationLocation.latitude,
              destinationLocation.longitude);

      if (result.isNotEmpty) {
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        _polylines = Set<Polyline>();
        setState(() {
          _polylines.add(Polyline(
              width: 5,
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(255, 40, 122, 198),
              points: polylineCoordinates));
        });
      }
    } catch (er) {
      print(er);
    }
  }

  Future setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/position.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/destination.png');
  }

  Future setInitialLocation() async {
    currentLocation = await location.getLocation();
    final doc = await Firestore.instance
        .collection('devices')
        .document(Provider.of<AuthService>(context, listen: false)
            .currentUser
            .serialNumber)
        .get();

    final info = Information.fromJson(doc.data);
    destinationLocation = LocationData.fromMap(
        {"latitude": info.latitude, "longitude": info.longitude});

    print('initial location : ' +
        currentLocation.latitude.toString() +
        ' ' +
        currentLocation.longitude.toString());
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void showPinsOnMap() {
    if (currentLocation != null) {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon));
    }

    if (destinationIcon != null) {
      var destPosition =
          LatLng(destinationLocation.latitude, destinationLocation.longitude);

      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: destPosition,
          icon: destinationIcon));
    }

    setPolylines();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              //   myLocationEnabled: true,

              tiltGesturesEnabled: false,
              markers: _markers,
              myLocationButtonEnabled: true,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                showPinsOnMap();
              }),
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () async {
                CameraPosition cPosition = CameraPosition(
                  zoom: CAMERA_ZOOM,
                  tilt: CAMERA_TILT,
                  bearing: CAMERA_BEARING,
                  target: LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                );

                final GoogleMapController controller = await _controller.future;
                controller
                    .animateCamera(CameraUpdate.newCameraPosition(cPosition));
              },
              child: Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/position.png',
                  fit: BoxFit.contain,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [loginBoxShadow]),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 90,
            child: GestureDetector(
              onTap: () async {
                CameraPosition cPosition = CameraPosition(
                  zoom: CAMERA_ZOOM,
                  tilt: CAMERA_TILT,
                  bearing: CAMERA_BEARING,
                  target: LatLng(destinationLocation.latitude,
                      destinationLocation.longitude),
                );

                final GoogleMapController controller = await _controller.future;
                controller
                    .animateCamera(CameraUpdate.newCameraPosition(cPosition));
              },
              child: Container(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/images/destination.png',
                  fit: BoxFit.contain,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [loginBoxShadow]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
