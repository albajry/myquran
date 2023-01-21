// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/data/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:quran/constant/global.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quran/constant/widgets.dart';
import 'package:quran/pages/search_page.dart';
import 'package:quran/pages/prayer_times.dart';
import '../pages/book_pages.dart';


void main() async{
  runApp( const MyHomePage());
  WidgetsApp.debugAllowBannerOverride = false;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage>  with TickerProviderStateMixin{
  PermissionStatus _permissionStatus;
  double downloadPercentage = 0.0;
  List fileList;
  TabController _tabController;
  bool stillLoading = false;

  @override
  initState() {
    super.initState();
    () async {
      DBProvider.db.database;
      prefs = await SharedPreferences.getInstance();
      setState(() {
        pageNo = prefs.getInt('lastPage') ?? 0;
        sorahIndex = prefs.getInt('lastIndex') ?? 0;
        colorCode = prefs.getInt('lastColor') ?? 0;
        latitude = prefs.getDouble('latitude') ?? 15.3547;
        longitude = prefs.getDouble('longitude') ?? 44.2066;
        timeZone = prefs.getDouble('timeZone') ?? 3.0;
        calcWay = prefs.getInt('calcWay') ?? 0;
        myCountry = prefs.getString('country') ?? 'Yemen';
        myCity = prefs.getString('city') ?? 'Sana''a';
      });

      _tabController?.addListener((){
        // if(_scrollController.hasClients) {
        //   _scrollController.animateTo(58.0 * sorahIndex,
        //       duration: const Duration(milliseconds: 100),
        //       curve: Curves.easeIn);
        // }
      });
      _permissionStatus = await Permission.storage.status;
      if (_permissionStatus != PermissionStatus.granted) {
        await Permission.storage.request();
      }
      _permissionStatus = await Permission.accessMediaLocation.status;
      if (_permissionStatus != PermissionStatus.granted) {
        await Permission.accessMediaLocation.request();
      }
      _permissionStatus = await Permission.manageExternalStorage.status;
      if (_permissionStatus != PermissionStatus.granted) {
        await Permission.manageExternalStorage.request();
      }
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize(debug: false);
      String dbDirectory = await getDatabasesPath();//getExternalStorageDirectory();
      String path = p.join(dbDirectory, "quranInfo.db");
      try {
        final x = (await File(path).readAsBytes()).length;
        if (x < 100000) {
          ByteData data = await rootBundle.load(p.join("assets", "quranInfo.db"));
          List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          await File(path).writeAsBytes(bytes);
        }
      }catch(e){
        showToast(context, 'حدث خطأ ولم يتم تحميل ملف البيانات');
      }
      final folder = Directory(myDir);
      bool folderExist = await folder.exists();
      if (!folderExist) {
        Directory(myDir).create(recursive: true)
            .then((Directory directory) async{
          var connectivityResult = await (Connectivity().checkConnectivity());
          if(connectivityResult == ConnectivityResult.wifi
              || connectivityResult == ConnectivityResult.mobile) {
            setState(() {
              downloadPercentage = 0.0;
              stillLoading = true;
              downloadImageFiles(remoteUrl,myDir);
            });
          } else {
            showToast(context, 'لا يوجد اتصال بالانترنت');
          }
        });
      } else {
        getListOfFiles();
        final myFileList = fileList?.length;
        if ( myFileList < pagesCount ) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if(connectivityResult == ConnectivityResult.wifi
              || connectivityResult == ConnectivityResult.mobile) {
            setState(() {
              downloadPercentage = 0.0;
              stillLoading = true;
              downloadImageFiles(remoteUrl,myDir);
            });
          } else {
            showToast(context, 'لا يوجد اتصال بالانترنت');
          }
        }
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    return MaterialApp(       // نحتاج استخدام MaterialApp لأننا نريد تغيير الثيم
        theme: ThemeData(
          primarySwatch: color0[colorCode],
          brightness: Brightness.light,
          dividerTheme: const DividerThemeData(color: Colors.white)
        ),
      home: Builder(  // نستغمل Builder حتى نستطيع أن نستخدم ال Navigate في AppBar
        builder: (context) => DefaultTabController(
          length: 3,
          initialIndex: 2,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Scaffold(
                backgroundColor: color300[colorCode],
                appBar: AppBar(
                  leading: PopupMenuButton<int>(
                    color: color200[colorCode],
                    icon: Icon(Icons.menu,
                      color: colorCode == 1 ? Colors.black : Colors.white,),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("آخر صفحة مقروءة",
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 7,),
                              Icon(
                                Icons.history,
                                color: color0[colorCode],
                              ),
                            ],
                          )),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        child: PopupMenuButton(
                          color: color100[colorCode],
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.arrow_left),
                              const Spacer(),
                              const Text('تغيير الألوان'),
                              const SizedBox(width: 7,),
                              Icon(Icons.color_lens_rounded,color: color0[colorCode],),
                            ],
                          ),
                          onSelected: (item){
                            selectedItem(context, item);
                            Navigator.pop(context);
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                                value: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "حجر الفيروز",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 7,),
                                    Icon(
                                      Icons.color_lens,
                                      color: color0[0],
                                    ),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                value: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "العقيق البرتقالي",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 7,),
                                    Icon(
                                      Icons.color_lens,
                                      color: color0[1],
                                    ),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                value: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "حجر الزبرجد",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 7,),
                                    Icon(
                                      Icons.color_lens,
                                      color: color0[2],
                                    ),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                value: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "حجر الزمرد",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 7,),
                                    Icon(
                                      Icons.color_lens,
                                      color: color0[3],
                                    ),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                value: 6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "العقيق الرمادي",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 10,),
                                    Icon(
                                      Icons.color_lens,
                                      color: color0[4],
                                    ),
                                  ],
                                )),
                            PopupMenuItem<int>(
                                value: 7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "العقيق الأخضر",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 10,),
                                    Icon(
                                      Icons.color_lens,
                                      color: color0[5],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<int>(
                          value: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("أوقات الصلاة",
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 10,),
                              Icon(
                                Icons.add_alarm,
                                color: color0[colorCode],
                              ),
                            ],
                          )
                      ),
                    ],
                    onSelected: (item) => selectedItem(context, item),
                  ),
                  title: Text('القرآن الكريم',
                    style: TextStyle(
                        color: colorCode == 1 ? Colors.black : Colors.white),),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.history_outlined,
                          color: colorCode == 1 ? Colors.black : Colors.white,
                        ),
                        onPressed: () {
                          pageNo;//--;
                          setState(() {
                            for (int i = 0; i <= 14; i++) {
                              xStart[i] = 0;
                              xFinal[i] = 0;
                            }
                          });
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: colorCode == 1 ? Colors.black : Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
                          );
                        }
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(child: Text('السور',
                          style: TextStyle(fontSize: 16,
                              color: colorCode == 1
                                  ? Colors.black
                                  : Colors.white))),
                      Tab(child: Text('الأجزاء',
                          style: TextStyle(fontSize: 16,
                              color: colorCode == 1
                                  ? Colors.black
                                  : Colors.white))),
                      Tab(child: Text('الأحزاب',
                          style: TextStyle(fontSize: 16,
                              color: colorCode == 1
                                  ? Colors.black
                                  : Colors.white))),
                    ],
                  ),
                ),
                body: Stack(
                  children:[
                    TabBarView(
                      controller: _tabController,
                      children: [
                        sowerList(),
                        partsList(),
                        quartersList(),
                      ]),
                    stillLoading ? myProgressBar() : const Text(''),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        pageNo;//--;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        inverted = !inverted;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 2:
        setState((){
          colorCode = 0;
          prefs.setInt('lastColor', colorCode);
        });
        break;
      case 3:
        setState(() {
          colorCode = 1;
          prefs.setInt('lastColor', colorCode);
        });
        break;
      case 4:
        setState(() {
          colorCode = 2;
          prefs.setInt('lastColor', colorCode);
        });
        break;
      case 5:
        setState(() {
          colorCode = 3;
          prefs.setInt('lastColor', colorCode);
        });
        break;
      case 6:
        setState(() {
          colorCode = 4;
          prefs.setInt('lastColor', colorCode);
        });
        break;
      case 7:
        setState(() {
          colorCode = 5;
          prefs.setInt('lastColor', colorCode);
        });
        break;
      // case 8:
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) =>  const MyQibla()));
      //   break;
      case 8:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  const PrayerTime()));
        break;
    }
  }

  Future downloadImageFiles(String sourceUrl,String targetDirectory) async {
    HttpClient httpClient = HttpClient();
    String filePath = '';
    String myUrl = '';
    String fileName = '';

    for(int i = 1; i <= pagesCount; i++) {
      if(!stillLoading) break;
      fileName = 'page' + i.toString().padLeft(3, '0') + '.png';
      myUrl = sourceUrl + '/' + fileName;
      filePath = '$targetDirectory/$fileName';
      if( await File(filePath).exists()) {
        setState(() {
          downloadPercentage=i/pagesCount;
        });
        continue;
      }
      try {
        var request = await httpClient.getUrl(Uri.parse(myUrl));
        var response = await request.close();
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          File(filePath).create(recursive: true).then((File file) {
            file.writeAsBytes(bytes,);
            setState(() {
              downloadPercentage=i/pagesCount;
            });
          });
        } else {
          showToast(context, 'الملف غير موجود : ' + response.statusCode.toString());
          break;
        }
      } catch (ex) {
        showToast(context,'غير قادر على الوصول إلى الرابط');
        break;
      }
    }
    setState(() {
      stillLoading = false;
    });
  }

  Future downloadDatabase(String sourceUrl,String targetLocation) async {
    HttpClient httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(sourceUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        File(targetLocation).create(recursive: true).then((File file) {
          file.writeAsBytes(bytes);
        });
      } else {
        showToast(context, 'الملف غير موجود : ' + response.statusCode.toString());
      }
    } catch (ex) {
      showToast(context,ex.toString());//'غير قادر على الوصول إلى الرابط');
    }
  }

  Widget myProgressBar(){
    return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          backgroundColor: Colors.black87,
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  height: 16,
                  child: LinearProgressIndicator(
                    //strokeWidth: 3,
                    value:  downloadPercentage,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'تحميل صفحات القرآن ${replaceArabicNumber(((downloadPercentage*pagesCount).toInt()).toString())}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      stillLoading = false;
                    });
                  },
                  child: const Text('إلغاء',
                    style: TextStyle(fontSize: 18),),
                )
              ]),
        ));
  }

  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              backgroundColor: Colors.black87,
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        child: LinearProgressIndicator(
                          //strokeWidth: 3,
                          value:  downloadPercentage,  //controller.value,
                        ),
                        width: 100,
                        height: 16
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'تحميل صفحات القرآن...انتظر',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ]),
              //LoadingIndicator(text: text,dpv: dpv),
            ));
      },
    );
  }

  void showToast(BuildContext context, String myMsg) {
    Fluttertoast.showToast(
        msg: myMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 13,
        backgroundColor: const Color(0xFF770000),
        textColor: Colors.white,fontSize: 18.0);
  }

  void getListOfFiles() async {
    setState(() {
      fileList = Directory(myDir).listSync();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    //_scrollController.dispose();
    super.dispose();
  }

}




