// @dart=2.9

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../constant/global.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  initDB() async {
    var dbDirectory  = await getDatabasesPath();//getExternalStorageDirectory();
    String path = join(dbDirectory,"quranInfo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ayahPosition ("
          "id INTEGER PRIMARY KEY,soraNo INTEGER,pageNo INTEGER,ayahNo INTEGER,"
          "startLine INTEGER,startX,finalLine INTEGER,finalX INTEGER)");
    });
  }

  addAyahPos(int soraNo,int pageNo,int ayahNo,int startLine,int startX,int finalLine,int finalX) async {
    final db = await database;
    var table = await db.rawQuery(
        "SELECT IfNull(MAX(id),0)+1 as id FROM ayahPosition");
    int id = table.first["id"];
    await db.rawInsert(
        "INSERT Into ayahPosition (id,soraNo,pageNo,ayahNo,startLine,startX,finalLine,finalX) "
            "VALUES(?,?,?,?,?,?,?,?)",
        [id, soraNo, pageNo, ayahNo, startLine, startX, finalLine, finalX]
    );
  }

  getAyahPos(int soraNo,int pageNo,int ayahNo) async{
    final db = await database;
    List<Map> result = await db.rawQuery("SELECT startLine,startX,finalLine,finalX FROM ayahPosition "
        "WHERE soraNo=? AND pageNo=? AND ayahNo=?",
        [soraNo,pageNo,ayahNo]
    );
    for (var row in result) {
      lineStartPos = row["startLine"];
      xStartPos = row["startX"];
      lineFinalPos = row["finalLine"];
      xFinalPos = row["finalX"];
    }
  }

  Future<List<Map>> getPosOfAyah(int pageNo,double xPos,double yPos) async{
    final db = await database;
    if(yPos < 127) yPos = 127;
    if(yPos > 700) yPos = 700;
    int lineNo = ((yPos)~/39).round()-2;
    int xAxes = xPos.round();
    //print("Y: "+yPos.round().toString()+" Line: "+lineNo.toString()+"  X: "+xAxes.toString());
    List<Map> result = await db.query("ayahPosition",
        columns: ["soraNo","ayahNo","startLine","startX","finalLine","finalX"],
        where:"pageNo=? and "
            "((startLine =? and finalLine =? and startX >=? and finalX <=?) or "
            "(startLine =? and finalLine >? and startX >=?) or "
            "(startLine <? and finalLine =? and finalX <=?) or "
            "(startLine <? and finalLine >?))",
        whereArgs: [pageNo,lineNo,lineNo,xAxes,xAxes,lineNo,lineNo,xAxes,lineNo,
          lineNo,xAxes,lineNo,lineNo]
    );
    return result.isNotEmpty? result : null;
  }

  getLastEntry() async {
    final db = await database;
    List<Map> result = await db.rawQuery("SELECT soraNo,pageNo,finalLine,ayahNo "
        "FROM ayahPosition WHERE id = (SELECT MAX(id) FROM ayahPosition) "
        "ORDER BY id");
    for (var row in result) {
      curSoraNo = row["soraNo"];
      curPageNo = row["pageNo"];
      curAyahNo = row["ayahNo"];
      curLastLine = row["finalLine"];
    }
  }

  Future<int> getCountEntry() async {
    final db = await database;
    var table = await db.rawQuery("Select Count(*) as recCount From ayahPosition");
    return table.first["recCount"];
  }

  Future<int> getSoraAyahCount(int soraNo) async {
    final db = await database;
    var table = await db.rawQuery("Select count(*) as recCount From ayahPosition "
        "WHERE soraNo=?",
        [soraNo]
    );
    return table.first["recCount"];
  }

  deleteAyah(int soraNo,int pageNo,int ayahNo) async {
    final db = await database;
    await db.execute("DELETE FROM ayahPosition WHERE soraNo=? AND pageNo=? AND ayahNo=?",
        [soraNo,pageNo,ayahNo]
    );
  }
  deleteAyahRange(int soraNo,int pageNo,int firstAyah,int lastAyah) async{
    final db = await database;
    await db.execute("DELETE FROM ayahPosition WHERE soraNo=? AND pageNo=? AND ayahNo>=?"
        " AND ayahNo <=?",
        [soraNo,pageNo,firstAyah,lastAyah]
    );
  }
  deletePage(int pageNo) async{
    final db = await database;
    await db.execute("DELETE FROM ayahPosition WHERE pageNo=?",
        [pageNo]
    );
  }
  deletePageRange(int pageNo1,int pageNo2) async {
    final db = await database;
    await db.execute("DELETE FROM ayahPosition WHERE pageNo>=? AND pageNo<=",
        [pageNo1,pageNo2]
    );
  }
  clearData() async {
    final db = await database;
    await db.execute("Delete From ayahPosition");
  }

  updateEntry(int startLine,int startX,int finalLine,int finalX,int soraNo,int pageNo,int ayahNo) async {
    final db = await database;
    await db.rawUpdate("UPDATE ayahPosition SET startLine=?,startX=?,finalLine=?,finalX=?"
        "WHERE soraNo=? AND pageNo=? AND ayahNo=?",
        [startLine,startX,finalLine,finalX,soraNo,pageNo,ayahNo]);
  }
}

