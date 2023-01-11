// @dart=2.9

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

int pagesCount = 604;
int pageNo = 0;
int sorahIndex = 0;
String quranText = "";
String quranFull = "";
List<double> xStart = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
List<double> xFinal = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
List<List<String>> searchAyah = [];
double scrWidth = 0.0;
double scrHeight = 0.0;

int curSoraNo = 1;
int curPageNo = 1;
int curAyahNo = 0;
int curLastLine = 0;

int xStartPos =0;
int xFinalPos = 0;
int lineStartPos = 0;
int lineFinalPos = 0;

int maxNumOfShow = 52000;
List<int> myPos = List.filled(maxNumOfShow,0);
List<int> myPosLong= List.filled(maxNumOfShow,0);
List<int> myPosName= List.filled(maxNumOfShow,0);
List<String> myPosWord= List.filled(maxNumOfShow,"");
List<int> myPosAyah= List.filled(maxNumOfShow,0);
List<int> myPosCount= List.filled(114,0);
int myTimes,curPos;
// String soraNameBegin='‹ ';
// String soraNameEnd='›';
// String basmalahBegin='‹﴿';
// String basmalahEnd='›';
// String ayahNoBegin='﴿';
// String ayahNoEnd='﴾';
String soraNameBegin='{ ';
String soraNameEnd='}';
String basmalahBegin='( ';
String basmalahEnd=')';
String ayahNoBegin=')';
String ayahNoEnd='(';

SharedPreferences prefs;
int colorCode = 0;
bool inverted =  false;
bool isCurPrayer =  false;
bool nightReading = false;
double longitude = 0.0;
double latitude = 0.0;
double timeZone = 0.0;
int calcWay = 0;
String myCountry = 'Yemen';
String myCity = 'Sana''a';
bool azanDone = false;
bool azanStatus = false;
int alarmId = 0;
//String myUrl = '/storage/emulated/0/myquran/pages';
String remoteUrl = 'https://successive-butts.000webhostapp.com/quran_images';
String databaseUrl ='https://successive-butts.000webhostapp.com/database/quranInfo.db';
String myDir = '/storage/emulated/0/myquran/pages';
String myDbDir = '/storage/emulated/0/myquran/database';
List color300 = [Colors.teal[300],Colors.orange[300],Colors.lime[300],Colors.cyan[300],Colors.blueGrey[300],Colors.green[300]];
List color200 = [Colors.teal[200],Colors.orange[200],Colors.lime[200],Colors.cyan[200],Colors.blueGrey[200],Colors.green[200]];
List color100 = [Colors.teal[100],Colors.orange[100],Colors.lime[100],Colors.cyan[100],Colors.blueGrey[100],Colors.green[100]];
List color50  = [Colors.teal[50],Colors.orange[50],Colors.lime[50],Colors.cyan[50],Colors.blueGrey[50],Colors.green[50]];
List color25  = [Colors.teal[25],Colors.orange[25],Colors.lime[25],Colors.cyan[25],Colors.blueGrey[25],Colors.green[25]];
List color0   = [Colors.teal,Colors.orange,Colors.lime,Colors.cyan,Colors.blueGrey,Colors.green];
List islamicImages = ['assets/images/harvest.png','assets/images/sky.png',
  'assets/images/ocean.png','assets/images/night.png','assets/images/peace.png'];

String replaceArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9','AM','PM'];
  const arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩','ص','م'];
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}
bool fajr = false;
bool sunRise = false;
bool dohr = false;
bool asr = false;
bool sunSet = false;
bool isha = false;

fillColor() {
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
}

class AyahPosition {
  final int firstLine;
  final int firstPoint;
  final int lastLine;
  final int lastPoint;
  static final columns = ["firstLine", "firstPoint", "lastLine", "lastPoint"];
  AyahPosition(this.firstLine, this.firstPoint, this.lastLine, this.lastPoint);
  factory AyahPosition.fromMap(Map<String, dynamic> data) {
    return AyahPosition(
      data['firstLine'],
      data['firstPoint'],
      data['lastLine'],
      data['lastPoint'],
    );
  }
  Map<String, dynamic> toMap() => {
    "firstLine": firstLine,
    "firstPoint": firstPoint,
    "lastLine": lastLine,
    "lastPoint": lastPoint,
  };
}

final List<String> chapterName =['الأول','الثاني','الثالث','الرايع','الخامس','السادس',
  'السابع','الثامن','التاسع','العاشر','الحادي عشر','الثاني عشر','الثالث عشر','الرابع عشر',
  'الخامس عشر','السادس عشر','السابع عشر','الثامن عشر','التاسع عشر','العشرون','الواحد والعشرون',
  'الثاني والعشرون','الثالث والعشرون','الرابع والعشرون','الخامس والعشرون','السادس والعشرون',
  'السابع والعشرون','الثامن والعشرون','التاسع والعشرون','الثلاثون'];
final List<List> sorah = [['الفاتحة', 1,'مكية',7],['البقرة',2,'مدنية',286],['آل عمران',50,'مدنية',200],
  ['النساء',77,'مدنية',176],['المائدة',106,'مدنية',120],['الأنعام',128,'مكية',165],['الأعراف',151,'مكية',206],['الأنفال',177,'مدنية',75],
  ['التوبة',187,'مدنية',129],['يونس',208,'مكية',109],['هود',221,'مكية',123],['يوسف',235,'مكية',111],['الرعد',249,'مدنية',43],
  ['إبراهيم',255,'مكية',52],['الحجر',262,'مكية',99],['النحل',267,'مكية',128],['الإسراء',282,'مكية',111],['الكهف',293,'مكية',110],
  ['مريم',305,'مكية',98],['طــه',312,'مكية',135],['الأنبياء',322,'مكية',112],['الحج',332,'مدنية',78],['المؤمنون',342,'مكية',118],
  ['النور',350,'مدنية',64],['الفرقان',359,'مكية',77],['الشعراء',367,'مكية',227],['النمل',377,'مكية',93],['القصص',385,'مكية',88],
  ['العنكبوت',396,'مكية',69],['الروم',404,'مكية',60],['لقمان',411,'مكية',34],['السجدة',415,'مكية',30],['الأحزاب',418,'مدنية',73],
  ['سبأ',428,'مكية',54],['فاطر',434,'مكية',45],['يس',440,'مكية',83],['الصافات',446,'مكية',182],['ص',453,'مكية',88],
  ['الزمر',458,'مكية',75],['غافر',467,'مكية',85],['فصلت',477,'مكية',54],['الشورى',483,'مكية',53],['الزخرف',489,'مكية',89],
  ['الدخان',496,'مكية',59],['الجاثية',499,'مكية',37],['الأحقاف',502,'مكية',35],['محمد',507,'مدنية',38],['الفتح',511,'مدنية',29],
  ['الحجرات',515,'مدنية',18],['ق',518,'مكية',45],['الذاريات',520,'مكية',60],['الطور',523,'مكية',49],['النجم',526,'مكية',62],
  ['القمر',528,'مكية',55],['الرحمن',531,'مدنية',78], ['الواقعة',534,'مكية',96], ['الحديد',537,'مدنية',29],['المجادلة',542,'مدنية',22],
  ['الحشر',545,'مدنية',24],['الممتحنة',549,'مدنية',13],['الصف',551,'مدنية',14],['الجمعة',553,'مدنية',11],['المنافقون',554,'مدنية',11],
  ['التغابن',556,'مدنية',18],['الطلاق',558,'مدنية',12],['التحريم',560,'مدنية',12],['الملك',562,'مكية',30],['ن',564,'مكية',52],
  ['الحاقة',566,'مكية',52],['المعارج',568,'مكية',44],['نوج',570,'مكية',28],['الجن',572,'مكية',28],['المزمل',574,'مكية',20],
  ['المدثر',575,'مكية',56],['القيامة',577,'مكية',40],['الإنسان',578,'مدنية',31],['المرسلات',580,'مكية',50],['النبأ',582,'مكية',40],
  ['النازعات',583,'مكية',46],['عبس',585,'مكية',42],['التكوير',586,'مكية',29],['الانفطار',587,'مكية',19],['المطففين',587,'مكية',36],
  ['الانشقاق',589,'مكية',25],['البروج',590,'مكية',22],['الطارق',591,'مكية',17],['الأعلى',591,'مكية',19],['الغاشية',592,'مكية',26],
  ['الفجر',593,'مكية',30],['البلد',594,'مكية',20],['الشمس',595,'مكية',15],['الليل',595,'مكية',21],['الضحى',596,'مكية',11],
  ['الشرح',596,'مكية',8],['التين',597,'مكية',8],['العلق',597,'مكية',19],['القدر',598,'مكية',5],['البينة',598,'مدنية',8],
  ['الزلزلة',599,'مدنية',8],['العاديات',599,'مكية',11],['القارعة',600,'مكية',11],['التكاثر',600,'مكية',8],['العصر',601,'مكية',3],
  ['الهمزة',601,'مكية',9],['الفيل',601,'مكية',5],['قريش',602,'مكية',4],['الماعون',602,'مكية',7],['الكوثر',602,'مكية',3],
  ['الكافرون',603,'مكية',6],['النصر',603,'مدنية',3],['المسد',603,'مكية',5],['الإخلاص',604,'مكية',4],['الفلق',604,'مكية',5],
  ['الناس',604,'مكية',6]];

final List<List> parts = [['الم ذلك الكتاب لا ريب',2],
  ['سيقول السفهاء',22],
  ['تلك الرسل فضلنا',42],
  ['كل الطعام كان حلا',62],
  ['والمحصنات من النساء',82],
  ['لا يحب الله الجهر',102],
  ['لتجدن أشد الناس',121],
  ['ولو أننا نزلنا',142],
  ['قال الملأ الذين',162],
  ['واعلموا أنما غنمتم',182],
  ['إنما السبيل على الذين',201],
  ['وما من دابة في الأرض',222],
  ['وما أبرئ نفسي',242],
  ['الر تلك آيات الكتاب',262],
  ['سبحان الذي أسرى بعبده',282],
  ['قال ألم أقل لك',302],
  ['اقترب للناس حسابهم',322],
  ['قد أقلح المؤمنون',342],
  ['وقال الذين لا يرجون',362],
  ['فما كان جواب قومه',382],
  ['ولا تجادلوا أهل الكتاب',402],
  ['ومن يقنت منكن لله',422],
  ['وما أنزلنا على قومه',442],
  ['فمن أظلم ممن كذب على',462],
  ['إليه يرد علم الساعة',482],
  ['حم تنزيل الكتاب من الله',502],
  ['قال فما خطبكم أيها',522],
  ['قد سمع الله قول التي',542],
  ['تبارك الذي بيده الملك',562],
  ['عم يتساءلون عن النبأ',582]];
final List quartName = ['بداية الحزب الأول','ربع الحزب الأول','نصف الحزب الأول',
  'نهاية الحزب الأول','بداية الحزب الثاني','ربع الحزب الثاني','نصف الحزب الثاني',
  'نهاية الحزب الثاني'];
final List<List> quarters=[[1,1,'الم ذلك الكتاب لا ريب',2],[1,2,'إن الله لا يستحيي',5],
  [1,3,'أتامرون الناس بالبر',7],[1,4,'وإذ استسقى موسى',9],[1,5,'أفتطمعون أن يؤمنوا لكم',11],
  [1,6,'ولقد جاءكم موسى',14],[1,7,'ما ننسخ من آية',17],[1,8,'وإذ ابتلى إبراهيم',19],
  [2,1,'سيقول السفهاء',22],[2,2,'إن الصفاء والمروة',24],
  [2,3,'ليس البر أن تولوا',27],[1,4,'يسألونك عن الأهلة',29],[2,5,'واذكروا الله في أيام',32],
  [2,6,'يسألونك عن الخمر',34],[2,7,'والوالدات يرضعن أولادهن',37],[2,8,'ألم تر إلى الذين خرجوا',39],
  [3,1,'تلك الرسل فضلنا',42],[3,2,'قول مغروف ومغفرة',44],
  [3,3,'ليس عليك هداهم',46],[3,4,'وإن كنتم على سفر',49],[3,5,'قل أؤنبكم بخير من ذلكم',51],
  [3,6,'إن الله اصطفى آدم',54],[3,7,'فلما أحس عيسى منهم',56],[3,8,'ومن أهل الكتاب من',59],
  [4,1,'كل الطعام كان حلا',62],[4,2,'ليسوا سواءا من أهل',64],
  [4,3,'وسارعوا إلى مغفرة',67],[4,4,'إذ تصعدون ولا تلوون',69],[4,5,'يستبشرون بنعمة من الله',72],
  [4,6,'لتبلون في أموالكم',74],[4,7,'يا أيها الناس اتقوا ربكم',77],[4,8,'ولكم نصف ما ترك',79],
  [5,1,'والمحصنات من النساء',82],[5,2,'واعبدوا الله ولا تشركوا',84],
  [5,3,'إن الله يأمركم أن تؤدوا',87],[5,4,'فليقاتل في سبيل الله',89],[5,5,'فما لكم في المنافقين',92],
  [5,6,'ومن يهاجر في سبيل',94],[5,7,'لا خير في كثير',97],[5,8,'يا أيها الذين آمنوا',100],
  [6,1,'لا يحب الله الجهر',102],[6,2,'إنا أوحينا إليك',104],
  [6,3,'يا أيها الذين آمنوا',106],[6,4,'ولقد أخذ الله ميثاق',109],[6,5,'واتل عليهم نبأ',112],
  [6,6,'يا أيها الرسول لا يحزنك',114],[6,7,'يا أيها الذين آمنوا',117],[6,8,'يا أيها الرسول بلغ',119],
  [7,1,'لتجدن أشد الناس',121],[7,2,'جعل الله الكعبة',124],
  [7,3,'يوم يجمع الله الرسل',126],[7,4,'وله ما سكن في الليل',129],[7,5,'إنما يستجيب الذين',132],
  [7,6,'وعنده مفاتح الغيب',134],[7,7,'وإذ قال إبراهيم لأبيه',137],[7,8,'إن الله فالق الحب والنوى',140],
  [8,1,'ولو أننا نزلنا',142],[8,2,'لهم دار السلام',144],
  [8,3,'وهو الذي أنشاء جنات',146],[8,4,'قل تعالوا أتل ما حرم',148],[8,5,'المص كتاب أنزل إليك',151],
  [8,6,'يابني آدم خذوا زينتكم',154],[8,7,'وإذا صرفت أبصارهم',156],[8,8,'وإلى عاد أخاهم هودا',158],
  [9,1,'قال الملأ الذين',162],[9,2,'وأوحينا إلى موسى',164],
  [9,3,'وواعدنا موسى ثلاثين',167],[9,4,'واكتب لنا في هذه الدنيا',170],[9,5,'وإذ نتقنا الجبل فوقهم',173],
  [9,6,'هو الذي خلقكم',175],[9,7,'يسألونك عن الأنفال',177],[9,8,'إن شر الدواب عند الله',179],
  [10,1,'واعلموا أنما غنمتم',182],[10,2,'وإن جنحوا للسلم فاجنح',184],
  [10,3,'براءة من الله ورسوله',187],[10,4,'أجعلتم سقاية الحاج',189],[10,5,'يا أيها الذين آمنوا',192],
  [10,6,'ولو أرادوا الخروج',194],[10,7,'إنما الصدقات للفقراء',196],[10,8,'ومنهم من عاهد الله',199],
  [11,1,'إنما السبيل على الذين',201],[11,2,'إن الله اشترى من المؤمنين',204],
  [11,3,'وما كان المؤمنون لينفروا',206],[11,4,'ولو يعجل الله للناس',209],[11,5,'للذين أحسنوا الحسنى',212],
  [11,6,'ويستنبئؤنك أحق هو',214],[11,7,'واتل عليهم نبأ نوح',217],[11,8,'وجاوزنا ببني إسرائيل',219],
  [12,1,'وما من دابة في الأرض',222],[12,2,'مثل الفريقين كالأعمى',224],
  [12,3,'وقال اركبوا فيها',226],[12,4,'وإلى ثمود أخاهم صالحا',228],[12,5,'وإلى مدين أخاهم شعيبا',231],
  [12,6,'وأما الذين سعدوا',233],[12,7,'لقد كان في يوسف',236],[12,8,'وقال نسوة في المدينة',238],
  [13,1,'وما أبرئ نفسي إن',242],[13,2,'قالو إن يسرق فقد',244],
  [13,3,'رب قد آتيتني من الملك',247],[13,4,'وإن تعجب فعجب قولهم',249],[13,5,'أفمن يعلم أنما أنزل إليك',252],
  [13,6,'مثل الجنة التي وعد المتقون',254],[13,7,'قالت رسلهم أفي الله شك',256],[13,8,'ألم تر إلى الذين بدلوا',259],
  [14,1,'الر تلك آيات الكتاب',262],[14,2,'نبئ عبادي أني أنا الغفور',264],
  [14,3,'أتى أمر الله فلا تستعجلوه',267],[14,4,'وقيل للذين اتقوا',270],[14,5,'وقال الله لا تتخذوا',272],
  [14,6,'ضرب الله مثلا عبدا',275],[14,7,'إن الله يأمر بالعدل',277],[14,8,'يوم تأتي كل نفس',280],
  [15,1,'سبحان الذي أسرى بعبده',282],[15,2,'وقضى ربك أن لا تعبدوا',284],
  [15,3,'قل كونوا حجارة أو حديدا',287],[15,4,'ولقد كرمنا بني آدم',289],[15,5,'أو لم يروا أن الله',292],
  [15,6,'وترى الشمس إذا طلعت',295],[15,7,'واضرب لهم مثلا رجلين',297],[15,8,'ما أشهدتهم خلق السماوات',299],
  [16,1,'قال ألم أقل لك',302],[16,2,'وتركنا بعضهم يومئذ',304],
  [16,3,'فحملته فانتبذت به',306],[16,4,'فخلف من بعدهم خلف',309],[16,5,'طه ما أنزلنا عليك',312],
  [16,6,'منها خلقناكم وفيها نعيدكم',315],[16,7,'وما أعجلك عن قومك',317],[16,8,'وعنت الوجوه للحي القيوم',319],
  [17,1,'اقترب للناس حسابهم',322],[17,2,'ومن يقل منهم إني إله',324],
  [17,3,'ولقد آتينا إبراهيم رشده',326],[17,4,'وأيوب إذ نادى ربه',329],[17,5,'يا أيها الناس اتقوا ربكم',332],
  [17,6,'هذان خصمان اختصموا',334],[17,7,'إن الله يدافع عن الذين',336],[17,8,'ذلك ومن عاقب بمثل ما',339],
  [18,1,'قد أقلح المؤمنون',342],[18,2,'هيهات هيهات لما توعدون',344],
  [18,3,'ولو رحمناهم وكشفنا',347],[18,4,'سورة أنزلناها وفرضناها',350],[18,5,'يا أيها الذين آمنوا',352],
  [18,6,'الله نور السماوات والأرض',354],[18,7,'وأقسموا بالله جهد أيمانهم',356],[18,8,'تبارك الذي نزل الفرقان',359],
  [19,1,'وقال الذين لا يرجون',362],[19,2,'وهو الذي مرج البحرين',364],
  [19,3,'طسم تلك آيات الكتاب',367],[19,4,'وأوحيا إلى موسى',369],[18,5,'قالوا أنؤمن لك واتبعك',371],
  [19,6,'أوفوا الكيل ولا تكونوا',374],[19,7,'طس تلك أيات القرآن',377],[18,8,'قال سننظر أصدقت أم',379],
  [18,1,'فما كان جواب قومه',382],[20,2,'وإذا وقع القول عليهم',384],
  [20,3,'وحرمنا عليه المراضع',386],[20,4,'فلما قضى موسى الأجل',389],[20,5,'ولقد وصلنا لهم القول',392],
  [20,6,'إن قارون كان من قوم',394],[20,7,'ألم أحسب الناس أن',396],[20,8,'فآمن له لوط وقال',399],
  [18,1,'ولا تجادلوا أهل الكتاب',402],[21,2,'الم غلبت الروم',404],
  [21,3,'منيبين إليه واتقوه',407],[21,4,'الله الذي خلقكم من ضعف',410],[21,5,'ومن يسلم وجهه إلى الله',413],
  [21,6,'قل يتوفاكم ملك الموت',415],[21,7,'يا أيها النبي اتق الله',418],[21,8,'قد يعلم الله المعوقين',420],
  [22,1,'ومن يقنت منكن لله',422],[22,2,'ترجي من تشاء منهن',425],
  [22,3,'لئن لم ينته المنافقون',426],[22,4,'ولقد آتينا داود منا فضلا',429],[22,5,'قل من يرزقكم من',431],
  [22,6,'قل إنما أعظكم بواحدة',433],[22,7,'يا أيها الناس أنتم',436],[22,8,'إن الله يمسك السماوات',439],
  [18,1,'وما أنزلنا على قومه',442],[23,2,'ألم أعهد إليكم يابني',444],
  [23,3,'احشروا الذين ظلموا وأزواجهم',446],[23,4,'وإن من شيعته لإبراهيم',449],[23,5,'فنبذناه بالعراء وهو',451],
  [23,6,'وهل أتاك نبأ الخصم',454],[23,7,'وعندهم قاصرات الطرف',456],[23,8,'وإذا مس الإنسان ضر',459],
  [18,1,'فمن أظلم ممن كذب على',462],[24,2,'قل ياعبادي الذين أسرفوا',464],
  [24,3,'حم تنزيل الكتاب',467],[24,4,'أولم يسيروا في الأرض',469],[24,5,'وياقوم مالي أدعوكم إلى',472],
  [24,6,'قل إني نهيت أن أعبد',474],[24,7,'قل أئنكم لتكفرون بالذي',477],[24,8,'وقيضنا لهم قرناء فزينوا',479],
  [25,1,'إليه يرد علم الساعة',482],[25,2,'شرع لكم من الدين',484],
  [25,3,'ولو بسط الله الرزق',486],[25,4,'وما كان لبشر أن يكلمه',488],[25,5,'قال أولو جئتكم بأهدى',491],
  [25,6,'ولما ضرب ابن مريم مثلا',493],[25,7,'ولقد فتنا قبلهم قوم',496],[25,8,'الله الذي سخر لكم البحر',499],
  [26,1,'حم تنزيل الكتاب من الله',502],[26,2,'واذكر أخا عاد إذ أنذر',505],
  [26,3,'أفلم يسيروا في الأرض',507],[26,4,'يا أيها الذين آمنوا',510],[26,5,'لقد رضي الله عن المؤمنين',513],
  [26,6,'يا أيها الذين آمنوا',515],[26,7,'قالت الأعراب آمنا',517],[26,8,'قال قرينه ربنا ما',519],
  [18,1,'قال فما خطبكم أيها',522],[27,2,'ويطوف عليهم غلمان لهم',524],
  [27,3,'وكم من ملك في السماوات',526],[27,4,'كذبت قبلهم قوم نوح',529],[27,5,'الرحمن علم القرآن',531],
  [27,6,'إذا وقعت الواقعة',534],[27,7,'قلا أقسم بمواقع النجوم',536],[27,8,'ألم يأن للذين آمنوا',539],
  [28,1,'قد سمع الله قول التي',542],[28,2,'ألم تر إلى الذين تولوا',544],
  [28,3,'ألم تر إلى الذين نافقوا',547],[28,4,'عسى الله أن يجعل بينكم',550],[28,5,'يسبح لله ما في السماوات',553],
  [28,6,'وإذا رأيتهم تعجبك',554],[28,7,'يا أيها النبي إذا طلقتم',558],[28,8,'يا أيها النبي لم تحرم',560],
  [18,1,'تبارك الذي بيده الملك',562],[29,2,'ن والقلم وما يسطرون',564],
  [29,3,'الحاقة ما الحاقة',566],[29,4,'إن الإنسان خلق هلوما',569],[29,5,'قل أوحي إلي أن استمع',572],
  [29,6,'إن ربك يعلم أنك تقوم',575],[29,7,'لا أقسم بيوم القيامة',577],[29,8,'ويطوف عليهم ولدان',579],
  [30,1,'عم يتساءلون عن النبأ',582],[30,2,'عبس وتولى أن جاءه',585],
  [30,3,'إذا السماء انفطرت',587],[30,4,'إذا السماء انشقت',589],[30,5,'سبح اسم ربك الأعلى',591],
  [30,6,'لا أقسم بهذا البلد',594],[30,7,'ألم نشرح لك صدرك',596],[30,8,'أفلا يعلم إذا بعثر',599],];

final List<String> prayerNames = ['الفجر','الشروق','الظهر','العصر','المغرب','العشاء','منتصف الليل'];
final List<String> dayName=['الاثنين','الثلاثاء','الأربعاء','الخميس','الجمعة','السبت','الأحد'];
final List<String> monthName=['محرم','صفر','ربيع أول','ربيع ثاني','جماد أول',
  'جماد ثاني','رجب','شعبان','رمضان','شوال','ذوالقعدة','ذوالحجة'];






