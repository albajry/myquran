// @dart=2.9
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran/data/database.dart';
import '../constant/global.dart';
import 'book_pages.dart';
//import 'procedures.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MySearch();
  }
}

class MySearch extends StatefulWidget {
  const MySearch({Key key}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<MySearch> {
  TextEditingController nameController = TextEditingController();

  String radioGroup = "allConnect";
  @override
  initState() {
    loadAsset();
    for (int i = 0; i <= 14; i++) {
      xStart[i] = 0;
      xFinal[i] = 0;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    return
      Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor: color200[colorCode],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        fillColor: color50[colorCode],
                        hintText: 'أدخل كلمة/كلمات البحث...',
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              nameController.clear();
                            });
                          },),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async{
                            startSearch();
                          },
                        ),
                      ),
                      onFieldSubmitted: (term) async {
                        startSearch();
                      },
                    ),
                    ),
                  ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("عدد ورود كلمة/كلمات البحث: "+replaceArabicNumber(searchAyah.length.toString()),
                          style: const TextStyle(fontSize: 18,color: Colors.indigo),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<String>(
                              groupValue: radioGroup,
                              value: "allConnect",
                              onChanged: (value) {
                                setState(() {
                                  radioGroup = value;
                                });},
                            ),
                            const Text("الكل",style: TextStyle(fontSize: 18),),
                            Radio<String>(
                              groupValue: radioGroup,
                              value: "preConnect",
                              onChanged: (value) {
                                setState(() {
                                  radioGroup = value;
                                });},
                            ),
                            const Text("بداية",style: TextStyle(fontSize: 18),),
                            Radio<String>(
                              groupValue: radioGroup,
                              value: "postConnect",
                              onChanged: (value) {
                                setState(() {
                                  radioGroup = value;
                                });},
                            ),
                            const Text("نهاية",style: TextStyle(fontSize: 18),),
                            Radio<String>(
                              groupValue: radioGroup,
                              value: "disConnect",
                              onChanged: (value) {
                                setState(() {
                                  radioGroup = value;
                                });},
                            ),
                            const Text("فقط",style: TextStyle(fontSize: 18),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: searchAyah.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(6.0),
                              color: color100[colorCode],
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: MaterialButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // child: Text(searchAyah[index][2],
                                    //   style: const TextStyle(fontSize: 18,color: Colors.black),
                                    // ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: searchAyah[index][2].substring(0,int.parse(searchAyah[index][5])),
                                        style: const TextStyle(fontSize: 18,color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: searchAyah[index][2].substring(int.parse(searchAyah[index][5]),int.parse(searchAyah[index][6])+1),
                                              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red)
                                          ),
                                          TextSpan(text: searchAyah[index][2].substring(int.parse(searchAyah[index][6])+1),
                                              style: const TextStyle(fontSize: 18,color: Colors.black)
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                  onPressed: () async{
                                    pageNo = int.parse(searchAyah[index][0]) - 1;
                                    await DBProvider.db.getAyahPos(
                                        int.parse(searchAyah[index][3]),
                                        pageNo + 1,
                                        int.parse(searchAyah[index][4]));
                                    setState(() {
                                      for (int i = 0; i <= 14; i++) {
                                        xStart[i] = 0;
                                        xFinal[i] = 0;
                                      }
                                      if (pageNo.isOdd) { //even
                                        if (lineStartPos == lineFinalPos) {
                                          xStart[lineStartPos - 1] = xStartPos.toDouble() - 10;
                                          xFinal[lineStartPos - 1] = xFinalPos.toDouble() - 10;
                                        } else {
                                          xStart[lineStartPos - 1] = xStartPos.toDouble() - 10;
                                          xFinal[lineStartPos - 1] = 15.0;
                                          for (int i = lineStartPos + 1; i < lineFinalPos; i++) {
                                            xStart[i - 1] = (scrWidth * 411.5 / scrWidth) - 27;
                                            xFinal[i - 1] = 15.0;
                                          }
                                          xStart[lineFinalPos - 1] = xFinalPos.toDouble() - 10;
                                          xFinal[lineFinalPos - 1] = (scrWidth * 411.5 / scrWidth) - 27;
                                        }
                                      } else {
                                        if (lineStartPos == lineFinalPos) {
                                          xStart[lineStartPos - 1] = xStartPos.toDouble();
                                          xFinal[lineStartPos - 1] = xFinalPos.toDouble();
                                        } else {
                                          xStart[lineStartPos - 1] = xStartPos.toDouble(); //-10;
                                          xFinal[lineStartPos - 1] = 15.0;
                                          for (int i = lineStartPos + 1; i < lineFinalPos; i++) {
                                            xStart[i - 1] = (scrWidth * 411.5 / scrWidth) - 27;
                                            xFinal[i - 1] = 15.0;
                                          }
                                          xStart[lineFinalPos - 1] = xFinalPos.toDouble();
                                          xFinal[lineFinalPos - 1] = (scrWidth * 411.5 / scrWidth) - 27;
                                        }
                                      }
                                      //fillColor();
                                    });
                                    Route route = MaterialPageRoute(
                                        builder: (context) => const HomePage());
                                    Navigator.push(context, route);
                                  }
                                ),
                              ),
                            )
                        );},
                    ),
                  ),
                ],
              ),
            ),
        ),
      );
  }
  loadAsset() async{
    quranText = await rootBundle.loadString("assets/quranText.txt");
  }
  void startSearch(){
    if (nameController.text.trim() == "") {
      showToast(context, "أدخل كلمة/كلمات البحث أولا");
      return;
    }
    if(radioGroup != "allConnect" && nameController.text.contains(" ")){
      showToast(context, "كلمة البحث يجب أن لا تحتوي على مسافة");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      searchAyah.clear();
      //SearchClass.rootSearch(searchWord)
      //String searchText = '';

      //searchText = nameController.text;
      simpleSearch(nameController.text);
      //SearchClass.rootSearch(nameController.text, false);
    });
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
  simpleSearch(String searchText){
    int soraNo = 0;
    int ayahOfSoraNo = 0;
    int ayahOfPageNo = 0;
    String ayahText = "";
    int ayahPageNo = 1;
    int beginOfAyah = 0;
    String curWord = "";
    int i = 0;
    String ch = '';
    while (i < quranText.length) {
      ch = quranText[i];
      if (ch == '{') {
        do {
          i++;
        } while (quranText[i] != '}');
        soraNo++;
        ayahOfSoraNo = 1;
      } else if (ch == '(') {
        if (quranText[i + 1] == ' ') {
          do {
            i++;
          } while (quranText[i] != ')');
          beginOfAyah = i + 3;
          if (quranText[beginOfAyah] == '۩') {
            beginOfAyah++;
          }
        } else {
          do {
            i++;
          } while (quranText[i] != ')');
          ayahOfPageNo++;
          ayahOfSoraNo++;
          beginOfAyah = i + 1;
          if (quranText[beginOfAyah] == '۩') {
            beginOfAyah++;
          }
        }
        ayahText = '';
      } else if (ch == String.fromCharCode(1769)) {
        ayahPageNo++;
        ayahOfPageNo = 1;
        curWord = '';
      } else {
        bool isCorrect = false;
        if ((quranText.length - i >= searchText.length)) {
          curWord = quranText.substring(i, i + searchText.length);
        }
        switch(radioGroup){
          case "allConnect":
            isCorrect = (curWord == searchText);
            break;
          case "preConnect":
            if((curWord == searchText) && (quranText[i+searchText.length]!=" ") && (quranText[i-1]==" ")){
              isCorrect=true;
            }
            break;
          case "postConnect":
            if((curWord == searchText) && (quranText[i+searchText.length]==" ") && (quranText[i-1]!=" ")){
              isCorrect=true;
            }
            break;
          case "disConnect":
            if((curWord == searchText) && (quranText[i+searchText.length]==" ") && (quranText[i-1]==" ")){
              isCorrect=true;
            }
            break;
        }
        if (isCorrect) {
          setState(() {
            int k = beginOfAyah;
            int j = 0;
            ayahText = '[';
            do{
              ayahText+=quranText[k];
              if(k <= i){
                j++;
              }
              k++;
            }while(quranText[k]!='(');
            ayahText+='] سورة ' + sorah[soraNo - 1][0] + ' ' +
                replaceArabicNumber(ayahOfSoraNo.toString());
            searchAyah.add([ayahPageNo.toString(),
              ayahOfPageNo.toString(),ayahText,
              soraNo.toString(), ayahOfSoraNo.toString(),
              j.toString(),(j+searchText.length).toString()
            ]);
          });
        }
        curWord = '';
      }
      i++;
    }
  }
}