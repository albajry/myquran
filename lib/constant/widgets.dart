// @dart=2.9

import 'package:flutter/material.dart';
import 'global.dart';
import '../pages/book_pages.dart';

Widget sowerList(){
  return Directionality(
    textDirection: TextDirection.rtl,
    child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: sorah.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(6.0),
                color: color200[colorCode],
                child: MaterialButton(
                    child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 140,
                              child: Text(replaceArabicNumber((index+1).toString())+
                                  ' سورة ${sorah[index][0]}',
                                style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                              )),
                          Text(
                            '(${replaceArabicNumber(sorah[index][3].toString())})' +
                                (sorah[index][3] <= 10 ? ' آيات' : ' آية'),
                            style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                          ),
                          Text(
                            '${sorah[index][2]}',
                            style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                          ),
                        ]),
                    onPressed: () {
                      pageNo = sorah[index][1] - 1;
                      sorahIndex = index;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage())
                      );
                    })),
          );
        }),
  );
}
Widget quartersList(){
  return Directionality(
    textDirection: TextDirection.rtl,
    child:ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(6.0),
              color: color200[colorCode],
              child: ExpansionTile(
                title: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('الجزء ${chapterName[index]}',
                              style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                            )
                        ),
                      )
                    ]
                ),
                children: [
                  Column(
                    children: expandableContent(context,index),
                  )
                ],
              ),
            ),
          );
        }),
  );
}
Widget partsList(){
  return Directionality(
    textDirection: TextDirection.rtl,
    child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(6.0),
                color: color200[colorCode],
                child: MaterialButton(
                    child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 80,
                              child: Text(
                                'الجزء ${replaceArabicNumber((index + 1)
                                    .toString())}',
                                style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                              )),
                          SizedBox(
                            width: 200,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(parts[index][0],
                                style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                              ),
                            ),
                          ),
                          Text((index == 6) || (index == 10)
                              ? replaceArabicNumber((index * 20 + 1)
                              .toString())
                              : replaceArabicNumber((index * 20 + 2)
                              .toString()),
                            style: const TextStyle(fontSize: 16.0, color: Colors.black,),
                          ),
                        ]),
                    onPressed: () {
                      pageNo = parts[index][1] - 1;
                      for (int i = 0; i <= 113; i++) {
                        if (pageNo >= sorah[i][1] &&
                            pageNo < sorah[i + 1][1]) {
                          sorahIndex = i;
                          break;
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }
                )
            ),
          );
        }),
  );
}
expandableContent(BuildContext context, int index) {
  List<Widget> colCont = [];
  for (int i = 0; i < 8; i++) {
    colCont.add(
      Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(6.0),
          color: color100[colorCode],
          child: MaterialButton(
              child: ListTile(
                tileColor: color100[colorCode],
                title: Text(quarters[index*8+i][2],
                  style: const TextStyle(fontSize: 16.0, color: Colors.black,
                  ),
                ),
                leading: quarters[index*8+i][1] == 1
                    ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/icon/full.png', width: 25, height: 25,),
                      Text(replaceArabicNumber((2 * quarters[index*8+i][0] - 1).toString()),
                        style: const TextStyle(fontSize: 16,
                            color: Colors.white70),
                      ),
                    ]
                )
                    : quarters[index*8+i][1] == 5
                    ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/icon/full.png', width: 25, height: 25,),
                      Text(replaceArabicNumber((2 * quarters[index*8+i][0]).toString()), style:
                      const TextStyle(fontSize: 16,
                          color: Colors.white70),),

                    ]
                )
                    : quarters[index*8+i][1] == 2 || quarters[index*8+i][1] == 6
                    ? Image.asset('assets/icon/quarter.png', width: 25, height: 25,)
                    : quarters[index*8+i][1] == 3 || quarters[index*8+i][1] == 7
                    ? Image.asset('assets/icon/half.png', width: 25, height: 25,)
                    : Image.asset('assets/icon/quarters.png', width: 25, height: 25,),
                trailing: Text(replaceArabicNumber(quarters[index*8+i][3].toString()),
                  style: const TextStyle(fontSize: 17.0,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () {
                pageNo = quarters[index*8+i][3]-1;
                for(int i=0; i<=113; i++){
                  if(pageNo >= sorah[i][1] && pageNo < sorah[i+1][1]){
                    sorahIndex=i;
                    break;
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              }
          ),
        ),
      ),
    );
  }
  return colCont;
}