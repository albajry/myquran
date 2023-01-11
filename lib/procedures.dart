// @dart=2.9
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constant/global.dart';
class SearchClass{
  static rootSearch(String searchWord,bool included) {
    int myNum;
    String myWord; //[10];
    String curWord; //[15];
    int i, stPos;
    int j,  m, posLong;
    String ch;
    String tempWord;
    String tempWord2;
    String temp1, temp2, temp3, temp4;
    int myAyah;
    bool correct, related;
    //int noOfRound;

    String quranString;
    //int stPos,i,j,m,posLong;
    //String ch;
    // String tempWord;
    // String tempWord2;
    //String temp11, temp22, temp33;
    //List temp = List.filled(125, "fill");
    // int numOfTemp;
    // numOfTemp = 125;
    myWord = searchWord;
    myNum = 0;
    curWord = '';
    tempWord = '';


    myWord = searchWord;
    if (myWord.length <= 1) {
      showToast("أدخل الكلمة المراد البحث عنها','البحث عن كلمة");
      return;
    }
    quranString = quranText;
    //ShowSora=true;
    //Gag1.MaxValue=Length(quranString);
    //Gag1.Progress=0;
    myNum = 0;
    curWord = '';
    tempWord = '';
    for (int i = 0; i < 1000; i++) {
      myPos[i] = 0;
      myPosLong[i] = 0;
    }
    for (int i = 0; i <= 113; i++) {
      myPosCount[i] = 0;
    }
    myTimes = 0;
    stPos = 0;
    posLong = 0;
    curPos = 0;
    myAyah = 1;
    if (myWord[1] == 'و') {
      temp1 = "ن";
      temp2 = "أ";
      temp3 = "ي";
      temp4 = "ت";
      for (int j = 1; j < myWord.length; j++) {
        temp1 = temp1 + myWord[j];
        temp2 = temp2 + myWord[j];
        temp3 = temp3 + myWord[j];
        temp4 = temp4 + myWord[j];
      }
    }
    else if (myWord[1] == 'ا') {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
      replaceCharAt(temp1, 1, "ا");
      replaceCharAt(temp2, 1, "و");
      replaceCharAt(temp3, 1, "ي");
      // temp1[2]="ا";
      // temp2[2]="و";
      // temp3[2]="ي";
    }
    else if (myWord[1] == 'أ') {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
      replaceCharAt(temp1, 1, "أ");
      replaceCharAt(temp2, 1, "ؤ");
      replaceCharAt(temp3, 1, "ئ");
      // temp1[2]='أ';
      // temp2[2]='ؤ';
      // temp3[2]='ئ';
    }
    else if ((myWord[1] == 'أ') || (myWord[1] == 'ؤ') || (myWord[1] == 'ئ')) {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
      replaceCharAt(temp1, 1, "أ");
      replaceCharAt(temp2, 1, "ؤ");
      replaceCharAt(temp3, 1, "ئ");
      // temp1[2]='أ';
      // temp2[2]='ؤ';
      // temp3[2]='ئ';
    }
    else if ((myWord[1] == 'و') || (myWord[1] == 'ي') || (myWord[1] == 'ا')) {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
      replaceCharAt(temp1, 1, "ا");
      replaceCharAt(temp2, 1, "و");
      replaceCharAt(temp3, 1, "ي");
      // temp1[2]='ا';
      // temp2[2]='و';
      // temp3[2]='ي';
    }
    else if ((myWord[1] == 'ا') || (myWord[1] == 'ى') || (myWord[1] == 'و') ||
        (myWord[1] == 'ي')) {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
      replaceCharAt(temp1, 2, "ا");
      replaceCharAt(temp2, 2, "و");
      replaceCharAt(temp3, 2, "ي");
      replaceCharAt(temp4, 2, "ي");
      // temp1[3]='ا';
      // temp2[3]='و';
      // temp3[3]='ي';
      // temp4[3]='ى';
    }
    else if ((myWord[2] == 'أ') || (myWord[2] == 'ئ') || (myWord[2] == 'ء')) {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
      replaceCharAt(temp1, 2, "أ");
      replaceCharAt(temp2, 2, "إ");
      replaceCharAt(temp3, 2, "ي");
      replaceCharAt(temp4, 2, "ؤ");
      // temp1[3]='أ';
      // temp2[3]='إ';
      // temp3[3]='ئ';
      // temp4[3]='ؤ';
      // temp4[3]='ء';
    }
    else {
      temp1 = myWord;
      temp2 = myWord;
      temp3 = myWord;
      temp4 = myWord;
    }
    i = 0;
    do {
      ch = quranString[i];
      if (quranString[i] + quranString[i + 1] == soraNameBegin) {
        do {
          i++;
          //Gag1.Progress=Gag1.Progress+1;
        }
        while (quranString[i] != soraNameEnd);
        curPos++;
        myAyah = 1;
      }
      else if (quranString[i] + quranString[i + 1] == basmalahBegin) {
        do {
          i++;
          //Gag1.Progress=Gag1.Progress+1;
        }
        while (quranString[i] != basmalahEnd);
        i++;
        //Gag1.Progress=Gag1.Progress+1;
      }
      else if ((ch == 'ء') || (ch == 'أ') || (ch == 'إ') || (ch == 'آ') ||
          (ch == 'ى') ||
          (ch == 'و') || (ch == 'ؤ') || (ch == 'ه') || (ch == 'ة') ||
          (ch == 'ي') ||
          (ch == 'ب') || (ch == 'ت') || (ch == 'ث') || (ch == 'ج') ||
          (ch == 'ح') ||
          (ch == 'خ') || (ch == 'د') || (ch == 'ذ') || (ch == 'ر') ||
          (ch == 'ز') ||
          (ch == 'س') || (ch == 'ش') || (ch == 'ص') || (ch == 'ض') ||
          (ch == 'ط') ||
          (ch == 'ظ') || (ch == 'ع') || (ch == 'غ') || (ch == 'ف') ||
          (ch == 'ق') ||
          (ch == 'ك') || (ch == 'ل') || (ch == 'م') || (ch == 'ن') ||
          (ch == 'ا') ||
          (ch == 'ئ')) {
        curWord = curWord + ch;
        if (stPos == 0) {
          stPos = i;
        }
        posLong++;
      }
      else if ((ch == 'ّ') || (ch == 'َ') || (ch == 'ً') || (ch == 'ُ') ||
          (ch == 'ٌ') || (ch == 'ِ') || (ch == 'ٍ') || (ch == 'ْ') ||
          (ch == 'ـ')) {
        posLong++;
      }
      else if (ch == ayahNoEnd) {
        myAyah++;
      }
      else {
        m = 0;
        correct = true;
        related = true;
        if (curWord.length >= myWord.length) {
          for (int k = 0; k < (curWord.length - myWord.length) + 1; k++) {
            if (included) {
              for (int j = 0; j < (curWord.length); j++) {
                if (curWord[j] == myWord[m]) {
                  tempWord = tempWord + curWord[j];
                  m++;
                }
              }
            }
            else {
              j = 0;
              do {
                if ((m < myWord.length) && (m != 1)) {
                  if ((curWord[j] == myWord[m]) || (curWord[j] == 'س') ||
                      (curWord[j] == 'أ') ||
                      (curWord[j] == 'ل') || (curWord[j] == 'ت') ||
                      (curWord[j] == 'م') ||
                      (curWord[j] == 'و') || (curWord[j] == 'ن') ||
                      (curWord[j] == 'ي') ||
                      (curWord[j] == 'ه') || (curWord[j] == 'ا') ||
                      (curWord[j] == 'ف') ||
                      (curWord[j] == 'ك') || (curWord[j] == 'ب') ||
                      (curWord[j] == 'ئ') ||
                      (curWord[j] == 'ؤ') || (curWord[j] == 'ى')) {
                    tempWord = tempWord + curWord[j];
                    if ((curWord[j] == myWord[m]) ||
                        (tempWord[j] == temp1[m]) ||
                        (tempWord[j] == temp2[m]) ||
                        (tempWord[j] == temp3[m]) ||
                        (tempWord[j] == temp4[m])) {
                      m++;
                    }
                    j++;
                  }
                  else {
                    correct = false;
                    related = false;
                  }
                }
                else if ((m == 1)) {
                  if ((curWord[j] == 'ا') || (curWord[j] == 'و') ||
                      (curWord[j] == 'ي') || (curWord[j] == myWord[m]) ||
                      (curWord[j] == 'أ') || (curWord[j] == 'ؤ') ||
                      (curWord[j] == 'ئ')) {
                    tempWord = tempWord + curWord[j];
                    if ((curWord[j] == myWord[m]) ||
                        (tempWord[j] == temp1[m]) ||
                        (tempWord[j] == temp2[m]) ||
                        (tempWord[j] == temp3[m]) ||
                        (tempWord[j] == temp4[m])) {
                      m++;
                    }
                    j++;
                  }
                  else {
                    correct = false;
                    related = false;
                  }
                }
                else if ((m == 1)) {
                  if ((curWord[j] == myWord[m]) ||
                      (curWord[j] == 'أ') || (curWord[j] == 'ؤ') ||
                      (curWord[j] == 'ئ')) {
                    tempWord = tempWord + curWord[j];
                    if ((curWord[j] == myWord[m]) ||
                        (tempWord[j] == temp1[m]) ||
                        (tempWord[j] == temp2[m]) ||
                        (tempWord[j] == temp3[m]) ||
                        (tempWord[j] == temp4[m])) {
                      m++;
                    }
                    j++;
                  }
                  else {
                    correct = false;
                    related = false;
                  }
                }
                else {
                  if ((curWord[j] == 'ا') || (curWord[j] == 'ت') ||
                      (curWord[j] == 'م') || (curWord[j] == 'و') ||
                      (curWord[j] == 'ه') || (curWord[j] == 'ة') ||
                      (curWord[j] == 'ي') || (curWord[j] == 'ك') ||
                      (curWord[j] == 'ن') || (curWord[j] == 'ى')) {
                    j++;
                  }
                  else {
                    correct = false;
                  }
                }
              }
              while (!correct && (j < curWord.length));
              if (correct) {
                j = 1;
                m = 1;
                tempWord2 = tempWord;
                tempWord = '';
                if (tempWord2 != '') {
                  do {
                    try {
                      tempWord = tempWord + tempWord2[tempWord2.length - j];
                      if ((tempWord2[tempWord2.length - j] ==
                          myWord[myWord.length - m]) ||
                          (tempWord2[tempWord2.length - j] ==
                              temp1[myWord.length - m]) ||
                          (tempWord2[tempWord2.length - j] ==
                              temp2[myWord.length - m]) ||
                          (tempWord2[tempWord2.length - j] ==
                              temp3[myWord.length - m]) ||
                          (tempWord2[tempWord2.length - j] ==
                              temp4[myWord.length - m])) {
                        m++;
                      }
                    }
                    catch (ex) {
                      print(ex);
                    }
                    j++;
                  }
                  while ((j != tempWord2.length) || (m != myWord.length));
                }
                tempWord2 = '';
                if (m == myWord.length) {
                  j = 0;
                  do {
                    tempWord2 = tempWord2 + tempWord[tempWord.length - j];
                    j++;
                  }
                  while ((j < tempWord.length));
                  j = 0;
                  m = 0;
                  tempWord = tempWord2;
                  tempWord2 = '';
                  do {
                    if ((tempWord[j] == myWord[m]) ||
                        (tempWord[j] == temp1[m]) ||
                        (tempWord[j] == temp2[m]) ||
                        (tempWord[j] == temp3[m]) ||
                        (tempWord[j] == temp4[m])) {
                      tempWord2 = tempWord2 + tempWord[j];
                      m++;
                    }
                    else if ((tempWord[j] == 'ا') || (tempWord[j] == 'ت') ||
                        (tempWord[j] == 'و') ||
                        (tempWord[j] == 'ي') || (tempWord[j] == 'ئ') ||
                        (tempWord[j] == 'ؤ') ||
                        (tempWord[j] == 'ن') || (tempWord[j] == 'ى')) {
                      if ((tempWord[j] == 'ت') && (m == myWord.length) &&
                          (tempWord[j - 1] != 'ت')) {
                        correct = false;
                      }
                      if ((tempWord[j] == 'ي') && (m == myWord.length - 1)) {
                        correct = false;
                      }
                    }
                    else {
                      correct = false;
                    }
                    j++;
                  }
                  while (correct && (m < myWord.length));
                }
                else {
                  correct = false;
                }
              }
              tempWord = tempWord2;
            }
            if (correct && ((tempWord == myWord) || (tempWord == temp1) ||
                (tempWord == temp2) || (tempWord == temp3) ||
                (tempWord == temp4))) {
              myNum++;
              myPosWord[myNum] = curWord;
              myPosAyah[myNum] = myAyah;
              myPos[myNum] = stPos - 1; //+k-2;
              myPosLong[myNum] = posLong; //+myWord.length;//-1;
              myPosCount[curPos]++;
              //if(ShowSora
              //{
              //myPosName[myNum]=curPos;
              //}
            }
            tempWord = '';
            if (!related) {
              return;
            }
          }
        }
        curWord = '';
        stPos = 0;
        posLong = 0;
      }
      //Gag1.Progress=Gag1.Progress+1;
      i++;
    }
    while (i < quranString.length);
    print(i);
  }
  static String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }
  static showToast(String myMsg) {
    Fluttertoast.showToast(
        msg: myMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 13,
        backgroundColor: const Color(0xFF770000),
        textColor: Colors.white,fontSize: 18.0);
  }
}