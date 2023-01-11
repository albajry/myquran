// @dart=2.9

import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../loading_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' as tl;
import '../adapter/compass.dart';
import '../constant/global.dart';

bool permissionOk = false;

class PrayerTime extends StatefulWidget {
  const PrayerTime({Key key}) : super(key: key);
  @override
  _PrayerTime createState() => _PrayerTime();
}

class _PrayerTime extends State<PrayerTime> {
  Future<Position> curCoordinates;
  PrayerTimes prayerTimes;
  List<Placemark> myPlace;
  bool okToGo = false;
  int nextTime = 0;
  String nextPrayer = "";
  double mySize = 100;
  String data='';

  @override
  initState() {
    super.initState();
    () async {
      curCoordinates =  getCurPosition();
      fajr = false;
      sunRise = false;
      dohr = false;
      asr = false;
      sunSet = false;
      isha = false;
    }();
  }
  @override
  Widget build(BuildContext context) {
    var myFormat = tl.NumberFormat("00");
    curCoordinates =  getCurPosition();
    //print(myPlace);
    return
      Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: color200[colorCode],
          appBar: AppBar(
            title: const Text('اوقات الصلاة'),
            centerTitle: true,
          ),
            body: FutureBuilder<Position>(
                future: curCoordinates,
                builder: (context, snapshot) {
            return snapshot.hasData //&& (myPlace != null)
                ?
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Align(
                          //   child: Container(
                          //     height: 150,
                          //     width: 300,
                          //     //margin: const EdgeInsets.only(top: 40, left: 40, right: 40),
                          //     decoration: BoxDecoration(
                          //       color: color200[colorCode],
                          //       border: Border.all(color: Colors.white, width: 2.0),
                          //       borderRadius: const BorderRadius.all(Radius.elliptical(200, 200)),
                          //     ),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         (permissionOk) && (myPlace != null)
                          //             ?
                          //         Text(myPlace.first.country + '/' +
                          //             myPlace.first.locality + '/' +
                          //             myPlace.first.administrativeArea,
                          //           style: const TextStyle(fontSize: 20,
                          //               color: Colors.indigo),
                          //         )
                          //             :
                          //         const Center(
                          //           child: Text(
                          //             'مكان غير معروف لا يوجد اتصال',
                          //             style: TextStyle(fontSize: 20,
                          //                 color: Colors.red),),
                          //         ),
                          //         Text(replaceArabicNumber("المتبقي إلى " +
                          //             nextPrayer + ": " +
                          //             myFormat.format(nextTime ~/ 60) +
                          //             ":" +
                          //             myFormat.format(nextTime % 60)),
                          //           style: const TextStyle(
                          //               fontSize: 20, color: Colors.indigo),
                          //         ),
                          //         Text(replaceArabicNumber(
                          //             dayName[HijriCalendar
                          //                 .now()
                          //                 .wkDay - 1] + " " +
                          //                 HijriCalendar
                          //                     .now()
                          //                     .hDay
                          //                     .toString() + " " +
                          //                 monthName[HijriCalendar
                          //                     .now()
                          //                     .hMonth - 1] + " " +
                          //                 HijriCalendar
                          //                     .now()
                          //                     .hYear
                          //                     .toString()),
                          //           style: const TextStyle(
                          //               fontSize: 20, color: Colors.indigo),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Material(
                            shape: const BeveledRectangleBorder(),
                            clipBehavior: Clip.none,
                            elevation: 0,
                            color: color200[colorCode],
                            child: Container(
                              margin: const EdgeInsets.all(2.0),
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: color200[colorCode],
                                border: Border.all(color: Colors.white, width: 2.0),
                                borderRadius: const BorderRadius.all(Radius.elliptical(70, 70)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (permissionOk) && (myPlace != null)
                                      ?
                                  Text(
                                    myPlace.first.country + '/' +
                                      myPlace.first.locality + '/' +
                                      myPlace.first.administrativeArea,
                                    style: const TextStyle(fontSize: 16,
                                        color: Colors.indigo),
                                  )
                                      :
                                  const Center(
                                    child: Text(
                                      'مكان غير معروف لا يوجد اتصال',
                                      style: TextStyle(fontSize: 20,
                                          color: Colors.red),),
                                  ),
                                  Text(replaceArabicNumber("المتبقي إلى " +
                                      nextPrayer + ": " +
                                      myFormat.format(nextTime ~/ 60) +
                                      ":" +
                                      myFormat.format(nextTime % 60)),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.indigo),
                                  ),
                                  Text(replaceArabicNumber(
                                      dayName[HijriCalendar
                                          .now()
                                          .wkDay - 1] + " " +
                                          HijriCalendar
                                              .now()
                                              .hDay
                                              .toString() + " " +
                                          monthName[HijriCalendar
                                              .now()
                                              .hMonth - 1] + " " +
                                          HijriCalendar
                                              .now()
                                              .hYear
                                              .toString()),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.indigo),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Material(
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              elevation: 20,
                              child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    color: color200[colorCode],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const SizedBox(
                                      height: 250,
                                      child: QiblahCompass()
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 20,
                      child: Container(
                        width: mySize,
                        height: mySize,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: dohr
                              ? color100[colorCode]
                              : color200[colorCode],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'الظهر', style: TextStyle(fontSize: 20)),
                            Text(replaceArabicNumber(
                                tl.DateFormat.jm().format(prayerTimes.dhuhr)),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 20,
                      child: Container(
                        width: mySize,
                        height: mySize,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: sunRise
                              ? color100[colorCode]
                              : color200[colorCode],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('الشروق', style: TextStyle(fontSize: 20)),
                            Text(replaceArabicNumber(tl.DateFormat.jm().format(
                                prayerTimes.sunrise)),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 20,
                      child: Container(
                        width: mySize,
                        height: mySize,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: fajr
                              ? color100[colorCode]
                              : color200[colorCode],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('الفجر', style: TextStyle(fontSize: 20)),
                            Text(replaceArabicNumber(
                                tl.DateFormat.jm().format(prayerTimes.fajr)),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 20,
                      child: Container(
                        width: mySize,
                        height: mySize,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: isha
                              ? color100[colorCode]
                              : color200[colorCode],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'العشاء', style: TextStyle(fontSize: 20)),
                            Text(replaceArabicNumber(
                                tl.DateFormat.jm().format(prayerTimes.isha)),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 20,
                      child: Container(
                        width: mySize,
                        height: mySize,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: sunSet
                              ? color100[colorCode]
                              : color200[colorCode],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'المغرب', style: TextStyle(fontSize: 20)),
                            Text(replaceArabicNumber(tl.DateFormat.jm().format(
                                prayerTimes.maghrib)),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 20,
                      child: Container(
                        width: mySize,
                        height: mySize,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: asr
                              ? color100[colorCode]
                              : color200[colorCode],
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'العصر', style: TextStyle(fontSize: 20)),
                            Text(replaceArabicNumber(
                                tl.DateFormat.jm().format(prayerTimes.asr)),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
                :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  const [
                // Center(
                //   child: LocationErrorWidget(error: "خدمة تحديد الموقع غير مفعلة",
                //       callback: null),
                // ),
                Center(child: LoadingIndicator()),
                Center(child: Text("يجب تفعيل خدمة تحديد الموقع",
                    style: TextStyle(fontSize: 18,color: Colors.indigo)))
              ],
            );
          })
    ),
      );
  }

  void showToast(BuildContext context, String myMsg) {
    Fluttertoast.showToast(
        msg: myMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 13,
        backgroundColor: const Color(0xFF770000),
        textColor: Colors.white,fontSize: 18.0
    );
  }

  Future<Position> getCurPosition() async {
    //bool serviceEnabled=true;
    LocationPermission permission;
    await Geolocator.isLocationServiceEnabled().then((value) => okToGo = value);
    if(okToGo) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('تم رفض السماح باستخدام تحديد المواقع');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error('تم رفض السماح باستخدام تحديد المواقع بشكل نهائي');
      }
      permissionOk = true;
      Position myCurPos;
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((position) async {
        myCurPos = position;
        final myCoordinates = Coordinates(
            position.latitude, position.longitude);
        final params = CalculationMethod.umm_al_qura.getParameters();
        params.madhab = Madhab.shafi;
        prayerTimes = PrayerTimes.today(myCoordinates, params);
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.wifi
            || connectivityResult == ConnectivityResult.mobile) {
          await placemarkFromCoordinates(position
              .latitude, position.longitude, localeIdentifier: 'ara_YE')
              .then((placeMarks) {
            //setState(() {
              okToGo = true;
              myPlace = placeMarks;
            //});
          });
        }
        //setState(() {
        if ((DateTime.now().compareTo(prayerTimes.fajr) > 0) &&
            (DateTime.now().compareTo(prayerTimes.sunrise) <= 0)
        ) {
          sunRise = true;
          nextTime = prayerTimes.sunrise
              .difference(DateTime.now())
              .inMinutes+1;
          nextPrayer = "الشروق";
        } else if ((DateTime.now().compareTo(prayerTimes.sunrise) > 0) &&
            (DateTime.now().compareTo(prayerTimes.dhuhr) <= 0)
        ) {
          dohr = true;
          nextTime = prayerTimes.dhuhr
              .difference(DateTime.now())
              .inMinutes+1;
          nextPrayer = "الظهر";
        } else if ((DateTime.now().compareTo(prayerTimes.dhuhr) > 0) &&
            (DateTime.now().compareTo(prayerTimes.asr) <= 0)
        ) {
          asr = true;
          nextTime = prayerTimes.asr
              .difference(DateTime.now())
              .inMinutes+1;
          nextPrayer = "العصر";
        } else if ((DateTime.now().compareTo(prayerTimes.asr) > 0) &&
            (DateTime.now().compareTo(prayerTimes.maghrib) <= 0)
        ) {
          sunSet = true;
          nextTime = prayerTimes.maghrib
              .difference(DateTime.now())
              .inMinutes+1;
          nextPrayer = "المغرب";
        } else if ((DateTime.now().compareTo(prayerTimes.maghrib) > 0) &&
            (DateTime.now().compareTo(prayerTimes.isha) <= 0)
        ) {
          isha = true;
          nextTime = prayerTimes.isha
              .difference(DateTime.now())
              .inMinutes+1;
          nextPrayer = "العشاء";
        } else if ((DateTime.now().compareTo(prayerTimes.isha) > 0) &&
            ((tl.DateFormat('am').format(DateTime.now())).substring(0,2)=="PM")
        ) {
          fajr = true;
          nextTime = prayerTimes.fajr
              .difference(DateTime.now())
              .inMinutes + 24 * 60 + 1;
          nextPrayer = "الفجر";
        } else {
          fajr = true;
          nextTime = prayerTimes.fajr
              .difference(DateTime.now())
              .inMinutes + 1;
          nextPrayer = "الفجر";
        }
        //});
      });
      return myCurPos;
    }else{
      return null;
    }
  }

}



