// @dart=2.9

import 'package:flutter/material.dart';
import '../constant/global.dart';

class LocationErrorWidget extends StatelessWidget {
  final String error;
  final Function callback;
  const LocationErrorWidget({Key key, this.error, this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xffb00020);
    return CircleAvatar(
      radius: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(
            Icons.location_off_outlined,
            size: 100,
            color: errorColor,
          ),
          Text(
            error,
            style: const TextStyle(color: errorColor,
              fontWeight: FontWeight.bold,fontSize: 18,
            ),
          ),
          ElevatedButton(
            child: const Text("حاول ثانية",style: TextStyle(fontSize: 18),),
            onPressed: () {
              if (callback != null) callback();
            },
          )
        ],
      ),
    );
    // return Material(
    //   shape: const CircleBorder(),
    //   clipBehavior: Clip.antiAlias,
    //   elevation: 20,
    //   child: Container(
    //     width: 300,
    //     height: 300,
    //     margin: const EdgeInsets.all(2.0),
    //     decoration: BoxDecoration(
    //       color: color200[colorCode],
    //       shape: BoxShape.circle,
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: <Widget>[
    //         const Icon(
    //           Icons.location_off_outlined,
    //           size: 100,
    //           color: errorColor,
    //         ),
    //         Text(
    //           error,
    //           style: const TextStyle(color: errorColor,
    //               fontWeight: FontWeight.bold,fontSize: 18,
    //           ),
    //         ),
    //         ElevatedButton(
    //           child: const Text("حاول ثانية",style: TextStyle(fontSize: 18),),
    //           onPressed: () {
    //             if (callback != null) callback();
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}