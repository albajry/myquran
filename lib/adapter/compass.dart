// @dart=2.9

import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import '../loading_indicator.dart';
import '../exceptions/location_error_widget.dart';
import 'package:geolocator/geolocator.dart';

class QiblahCompass extends StatefulWidget {
  const QiblahCompass({Key key}) : super(key: key);

  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController =
  StreamController<LocationStatus>.broadcast();
  get stream => _locationStreamController.stream;

  @override
  void initState() {
    _checkLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }
        if (snapshot.data.enabled == true) {
          switch (snapshot.data.status) {
            case LocationPermission.always:
              return QiblahCompassWidget();
            case LocationPermission.whileInUse:
              return QiblahCompassWidget();
            case LocationPermission.denied:
              return LocationErrorWidget(
                error: "صلاحية خدمة تحديد الموقع مرفوضة",
                callback: _checkLocationStatus,
              );
            case LocationPermission.deniedForever:
              return LocationErrorWidget(
                error: "خدمة تحديد الموقع غير مسموحة!",
                callback: _checkLocationStatus,
              );
            default:
              return Container();
          }
        } else {
          return LocationErrorWidget(
            error: "يرجى تشغيل خدمة تحديد الموقع",
            callback: _checkLocationStatus,
          );
        }
      },
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreamController.close();
    FlutterQiblah().dispose();
  }
}

class QiblahCompassWidget extends StatelessWidget {
  final _compassPng = Image.asset('assets/images/compass.png');
  final _needlePng = Image.asset('assets/images/needle.png',
    fit: BoxFit.contain,
    height: 250,
    alignment: Alignment.center,
  );

  QiblahCompassWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }
        final qiblahDirection = snapshot.data;
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: (qiblahDirection.direction * (pi / 180) * -1),
              child: _compassPng,
            ),
            Transform.rotate(
              angle: (qiblahDirection.qiblah * (pi / 180) * -1),
              alignment: Alignment.center,
              child: _needlePng,
            ),
            // Positioned(
            //   top: 15,
            //   child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
            // )
          ],
        );
      },
    );
  }
}