// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:quran/data/database.dart';
import 'package:wakelock/wakelock.dart';
import '../constant/global.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show Clipboard, ClipboardData, rootBundle;
import 'package:toast/toast.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MyPages();
  }
}

class MyPages extends StatefulWidget {
  const MyPages({Key key}) : super(key: key);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MyPages> {
  List<int> pages = List<int>.generate(604, (int index) => index + 1);
  int currIndex = pageNo;
  Timer myTimer;
  int period = 7;
  int soraCount = 0;
  int ayahCount = 0;
  String ayahString = '';
  img.Image photo,photoOriginal;
  bool useSnapshot = true;
  GlobalKey currentKey;
  Uint8List imageBytes;
  bool showPopup = false;
  int clickNo = 0;

  @override
  void initState() {
    Wakelock.enable();
    prefs.setInt('lastIndex', sorahIndex);
    prefs.setInt('lastPage', pageNo);
    curSoraNo=1;
    curAyahNo = 0;
    super.initState();
  }
  Future<void> share(String myAyah) async {
    await FlutterShare.share(
        title: 'مشاركة الآية',
        text: myAyah,
        linkUrl: '',
        chooserTitle: 'Example Chooser Title'
    );
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double titConRate = height*0.09;
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: color50[colorCode],
        body: Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  initialPage: pageNo,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index,reason) {
                    setState(()  {
                      for(int i=0; i<=14; i++){
                        xStart[i]=0;
                        xFinal[i]=0;
                      }
                      imageBytes = null;
                      photoOriginal = null;
                      pageNo = index;//+1;
                      getQuarterNumber(pageNo);
                      prefs.setInt('lastPage', pageNo);
                      for(int i = 0; i <=113; i++){
                        if((pageNo+1 == sorah[i][1]) ||
                            ((pageNo+1 > sorah[i][1]) && (pageNo+1 < sorah[i+1][1]))){
                          sorahIndex = i;
                          break;
                        }
                      }
                      prefs.setInt('lastIndex', sorahIndex);
                    });
                  },
                ),
                items: pages.map((pageNo){
                  return Builder(
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          margin: pageNo.isEven ? const EdgeInsets.fromLTRB(3,0,0,0)
                            : const EdgeInsets.fromLTRB(0,0,3,0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: width,
                                height: titConRate,
                                child : Stack(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              GestureDetector(
                                                child: Text('سورة '+sorah[sorahIndex][0],
                                                  style: const TextStyle(fontSize: 16,
                                                      color: Colors.indigo),),
                                                onTap: () async {
                                                  // for(int i=0; i<114; i++){
                                                  //   int j = await DBProvider.db.getSoraAyahCount(i+1);
                                                  //   if(j != sorah[i][3]){
                                                  //     print("Sorah: "+sorah[i][0]+" Ayah: "+sorah[i][3].toString()+" Count: "+j.toString());
                                                  //   }
                                                  // }
                                                  // DBProvider.db.getCountEntry().then((int result){
                                                  //   print(result.toString());
                                                  // });
                                                  // await DBProvider.db.getLastEntry();
                                                  // print("Sora: "+curSoraNo.toString()+
                                                  //     "  Page: "+curPageNo.toString()+
                                                  //     "  Line: "+curLastLine.toString()+
                                                  //     "  Ayah: "+curAyahNo.toString()
                                                  // );

                                                },
                                              ),
                                              GestureDetector(
                                                child: Text('صفحة ${replaceArabicNumber(pageNo.toString())}',
                                                  style: const TextStyle(fontSize: 16,
                                                      color: Colors.indigo),),
                                                onTap: (){
                                                  //DBProvider.db.deleteAyah(108, 602, 3);
                                                  // DBProvider.db.deleteAyahRange(101, 600, 10, 10);
                                                  //print("Delete Ayah Done");
                                                  //DBProvider.db.clearData();
                                                },
                                              ),
                                              GestureDetector(
                                                child: Text('الجزء ${pageNo==121 || pageNo==201
                                                    ? replaceArabicNumber(((pageNo-2)~/20+2).toString())
                                                    : pageNo >= 582
                                                    ? replaceArabicNumber('30')
                                                    : replaceArabicNumber(((pageNo-2)~/20+1).toString())}',
                                                  style: const TextStyle(fontSize: 16,
                                                      color: Colors.indigo),),
                                                onTap:() {
                                                    // setState(() {
                                                    //   curAyahNo--;
                                                    // });
                                                   //DBProvider.db.getAyahPos(2, 4, 24);
                                                  // print(lineStartPos.toString()+" "+xStartPos.toString());
                                                  // print(lineFinalPos.toString()+" "+xFinalPos.toString());
                                                },
                                              ),
                                            ],
                                          ),
                                        ]
                                      ),
                                      Visibility(
                                        visible: showPopup,
                                        child: SizedBox(
                                          width: width,
                                          height: height,
                                          child: Align(
                                            alignment: const Alignment(-1, -1),
                                            child: Container(
                                              color: color300[colorCode],
                                              width: width-6,
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                      icon: const Icon(Icons.copy,color: Colors.white,),
                                                      onPressed: () async{
                                                        String data = await getFileData('assets/quranMark.txt');
                                                        ayahString = getAyahText(data,pageNo-1,soraCount,ayahCount);
                                                        Clipboard.setData(ClipboardData(text:ayahString));
                                                        Toast.show('تم النسخ إلى الحافظة', context,
                                                            duration: Toast.LENGTH_LONG,
                                                            gravity: Toast.CENTER,
                                                            backgroundColor: Colors.black,
                                                            textColor: Colors.white,
                                                            backgroundRadius: 32.0
                                                        );
                                                      },
                                                  ),
                                                  IconButton(
                                                      icon: const Icon(Icons.share,color: Colors.white,),
                                                      onPressed: () async {
                                                        String data = await getFileData('assets/quranMark.txt');
                                                        ayahString = getAyahText(data,pageNo-1,soraCount,ayahCount);
                                                        await FlutterShare.share(text: ayahString, title: 'مشاركة');
                                                      }),
                                                  IconButton(
                                                      icon: const Icon(Icons.bookmark_border,color: Colors.white,),
                                                      onPressed: (){

                                                      }),
                                                  IconButton(
                                                      icon: const Icon(Icons.close,color: Colors.white,),
                                                      onPressed: (){
                                                        setState(() {
                                                          showPopup = false;
                                                          photoOriginal = null;
                                                        });
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          color100[colorCode],
                                          color50[colorCode]
                                        ],
                                        begin: pageNo.isEven ? const FractionalOffset(1.0, 0.0) : const FractionalOffset(0.0, 0.0) ,
                                        end: pageNo.isEven ? const FractionalOffset(0.95, 0.0) : const FractionalOffset(0.05, 0.0),
                                        stops: const [0.0, 3.0],
                                        tileMode: TileMode.clamp,
                                      ),
                                      border: Border(
                                        top:  BorderSide(color: color100[colorCode], width: 3.0),
                                        bottom:  BorderSide(color: color100[colorCode], width: 3.0),
                                        left: pageNo.isOdd    //Colors.black26
                                            ? const BorderSide(color: Colors.black12 , width: 1.0,)
                                            : BorderSide(color: color100[colorCode] , width: 10.0,),
                                        right: pageNo.isOdd
                                            ? BorderSide(color: color100[colorCode] , width: 10.0,)
                                            : const BorderSide(color: Colors.black12 , width: 1.0,),
                                      ),
                                    ),
                                    alignment: Alignment.topCenter,
                                    width: width,
                                    height: (width/0.6332),

                                    child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      GestureDetector(
                                        child:Image.file(File(myDir+'/page'+pageNo.toString().padLeft(3, '0')+'.png',),),
                                          // onDoubleTap : () {
                                          //   curSoraNo = 52;
                                          //   curAyahNo=31;
                                          //   clickNo = 0;
                                          //   print("Sora No: "+curSoraNo.toString()+" Ayayh No: "+curAyahNo.toString());
                                          // },
                                          onLongPressStart: (detail) async{
                                            setState(()  {
                                              for (int i = 0; i <= 14; i++) {
                                                xStart[i] = 0;
                                                xFinal[i] = 0;
                                              }
                                              showPopup = false;
                                            });
                                            //List<Map> ayahPosition =
                                            await DBProvider.db.getPosOfAyah(pageNo,
                                                detail.globalPosition.dx,
                                                detail.globalPosition.dy).then((List<Map> myPosition){
                                                  if(myPosition != null) {
                                                    lineStartPos =
                                                    myPosition
                                                        .first['startLine'];
                                                    xStartPos =
                                                    myPosition.first['startX'];
                                                    lineFinalPos =
                                                    myPosition
                                                        .first['finalLine'];
                                                    xFinalPos =
                                                    myPosition.first['finalX'];
                                                    soraCount =
                                                    myPosition.first["soraNo"];
                                                    ayahCount =
                                                    myPosition.first["ayahNo"];
                                                    // print(lineStartPos.toString()+" "+
                                                    //     xStartPos.toString()+" "+
                                                    //     ayahCount.toString());
                                                    fillColor();
                                                  }
                                            });
                                          },
                                          onTapUp: (detail) async {
                                          //   if(clickNo==0){
                                          //     curAyahNo++;
                                          //     lineStartPos = ((detail.globalPosition.dy)~/42).round()-2;
                                          //     xStartPos = (detail.globalPosition.dx).round();
                                          //     clickNo++;
                                          //     print("Sora :"+curSoraNo.toString()+"Page :"+pageNo.toString()+" Line:"+lineStartPos.toString()+" Ayah:"+curAyahNo.toString());
                                          //   }else{
                                          //     lineFinalPos = ((detail.globalPosition.dy)~/42).round()-2;
                                          //     xFinalPos = (detail.globalPosition.dx).round();
                                          //     DBProvider.db.addAyahPos(curSoraNo, pageNo, curAyahNo, lineStartPos, xStartPos, lineFinalPos, xFinalPos);
                                          //     //DBProvider.db.updateEntry(lineStartPos, xStartPos, lineFinalPos, xFinalPos, curSoraNo, pageNo, curAyahNo);
                                          //     clickNo=0;
                                          //     print(lineFinalPos.toString());
                                          //   }
                                          }
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CustomPaint(painter: OpenPainter1(),),
                                          CustomPaint(painter: OpenPainter2(),),
                                          CustomPaint(painter: OpenPainter3(),),
                                          CustomPaint(painter: OpenPainter4(),),
                                          CustomPaint(painter: OpenPainter5(),),
                                          CustomPaint(painter: OpenPainter6(),),
                                          CustomPaint(painter: OpenPainter7(),),
                                          CustomPaint(painter: OpenPainter8(),),
                                          CustomPaint(painter: OpenPainter9(),),
                                          CustomPaint(painter: OpenPainter10(),),
                                          CustomPaint(painter: OpenPainter11(),),
                                          CustomPaint(painter: OpenPainter12(),),
                                          CustomPaint(painter: OpenPainter13(),),
                                          CustomPaint(painter: OpenPainter14(),),
                                          CustomPaint(painter: OpenPainter15(),),
                                        ],
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        );
                    },
                  );
                }).toList(),
              ),
            )
        ),
      ),
    );
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    myTimer = Timer.periodic(
      oneSec, (Timer timer) {
        setState(() {
          if (period == 0) {
            timer.cancel();
            nightReading = false;
          }else{
            period--;
          }
        });
      },
    );
  }
  @override
  void dispose() {
    Wakelock.disable();
    nightReading = false;
    super.dispose();
  }

  getQuarterNumber(int curPage){
    int j = -1;
    int k = 0;
    for(int i=0; i<30; i++){
      if(curPage >= parts[i][1]){
        k=i;
        break;
      }
    }
    for(int i=k*8; i < 240; i++) {
      j = quarters[i][3];
      if(j == curPage+1){
        Toast.show(quartName[(i%8)], context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: color100[colorCode],
            textColor: Colors.black,
            backgroundRadius: 20.0
        );
        break;
      }
    }
  }
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  String getAyahText(String quranText,int myPageNo,int mySoraNo, int ayahIndex){
    int i = 0;
    int curPage = 1;
    int curSora = 0;
    int curAyah = 1;
    String par1 = '﴿';
    String par2 = '﴾';
    String ayahText = '';
    //print("pag="+myPageNo.toString()+' Sor='+mySoraNo.toString()+" Aya="+ayahIndex.toString());
    do {
      if(quranText[i] == '۩'){
        curPage++;
      } else if((quranText[i] == '‹') && (quranText[i+1] != '﴿')){
        curSora++;
        curAyah=1;
      } else if(quranText[i] == '﴿'){
        curAyah++;
      }
      i++;
    } while(curPage < myPageNo || curSora < mySoraNo || curAyah < ayahIndex+1);
    //print("pag="+curPage.toString()+' Sor='+curSora.toString()+" Aya="+curAyah.toString());

    do{
      i++;
    }while(quranText[i] != '﴾');
    i++;
    do{
      ayahText += quranText[i];
      i++;
    }while(quranText[i] != '﴿');
    i++;
    return par1+ayahText+par2+' '+ sorah[curSora-1][0]+' '+
        replaceArabicNumber(ayahIndex.toString());
  }

  void showCustomDialog(BuildContext context,int mySoraNo,int myPageNo,
      int myLine,int myPos){
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Ayah Position Info",style: TextStyle(fontSize: 20),),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Sora: "+mySoraNo.toString(),style: const TextStyle(fontSize: 18),),
                      Text("Page: "+myPageNo.toString(),style: const TextStyle(fontSize: 18),),
                      // const TextField(
                      //   //controller: ayahTextController,
                      //   decoration: InputDecoration(
                      //     hintText: 'أدخل كلمة/كلمات البحث...',
                      //     border: InputBorder.none,
                      //   ),
                      //   style:  TextStyle(fontSize: 18),
                      //   autofocus: true,
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Start Line: "+myLine.toString(),style: const TextStyle(fontSize: 18),),
                      Text("Start Pos: "+myPos.toString(),style: const TextStyle(fontSize: 18),),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Save",style: TextStyle(fontSize: 18),),
                onPressed: (){

                },
              ),
              TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }
}
class OpenPainter1 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    double x1 = xStart[0]*(scrWidth/411.5);
    double x2 = xFinal[0]*(scrWidth/411.5);//scrWidth-27;
    double y2 = 1*((scrWidth/0.6332)-20)/15;
    double y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x2, y1, x1, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter2 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    double x1 = xStart[1]*(scrWidth/411.5);
    double x2 = xFinal[1]*(scrWidth/411.5);//scrWidth-27;
    double y2 = 2*((scrWidth/0.6332)-20)/15;
    double y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter3 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[2]*(scrWidth/411.5);
    var x2 = xFinal[2]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 3*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter4 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[3]*(scrWidth/411.5);
    var x2 = xFinal[3]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 4*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter5 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[4]*(scrWidth/411.5);
    var x2 = xFinal[4]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 5*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter6 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[5]*(scrWidth/411.5);
    var x2 = xFinal[5]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 6*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter7 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[6]*(scrWidth/411.5);
    var x2 = xFinal[6]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 7*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter8 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[7]*(scrWidth/411.5);
    var x2 = xFinal[7]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 8*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x2, y1, x1, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter9 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[8]*(scrWidth/411.5);
    var x2 = xFinal[8]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 9*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter10 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[9]*(scrWidth/411.5);
    var x2 = xFinal[9]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 10*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter11 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[10]*(scrWidth/411.5);
    var x2 = xFinal[10]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 11*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x2, y1, x1, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter12 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[11]*(scrWidth/411.5);
    var x2 = xFinal[11]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 12*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter13 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[12]*(scrWidth/411.5);
    var x2 = xFinal[12]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 13*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter14 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[13]*(scrWidth/411.5);
    var x2 = xFinal[13]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 14*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class OpenPainter15 extends CustomPainter {
  @override
  paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var x1 = xStart[14]*(scrWidth/411.5);
    var x2 = xFinal[14]*(scrWidth/411.5);//scrWidth-27;
    var y2 = 15*((scrWidth/0.6332)-20)/15;
    var y1 = y2-35;
    canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2),paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

