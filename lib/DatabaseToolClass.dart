import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'MemoInfo.dart';
import 'MemoMenu.dart';

class DBTool {
  static const String dbSelfName = "DB.db";

  static const String tableMemo = "TableMemo";
  static const int version = 1;
  static const String colomnTitle = "title";
  static const String colomnContext = "Context";
  static const String columnId = "_id";

  late Future<Database> database;

  DBTool(){
    database = getDB();
    //readMemo().
    print("constructor");
  }

  Future<Database> _initDB() async {
    var databaseDirPath = await getDatabasesPath();
    var databasePath = join(databaseDirPath, dbSelfName);
    final db = await openDatabase(databasePath,
      version: 1,
      onCreate: (db,ver)async{
        db.execute(createMemoTable);
      }
    );
    print("initDB");
    return db;
  }

  Future<Database> getDB() {
    database = _initDB();
    return database;
  }


  static const String createMemoTable = """
  CREATE TABLE $tableMemo (
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  $colomnTitle TEXT NOT NULL,
  $colomnContext TEXT NOT NULL)
  """;


  seeDB() async {
    (await database).transaction((txn) async {
      print(await txn.query(tableMemo));
    });
  }

  Future<MemoClass> insertMemo(MemoClass memo) async {
    memo.id = await(await database).insert(tableMemo, memo.toMap());
    return memo;
  }

  deleteMemo(int id) async {
    print("deleteMemo");
    (await database).transaction((txn) async {
      await txn.delete(tableMemo, where: '$columnId = ?', whereArgs: [id]);
    });
  }

  updateMemo(MemoClass memo) async {
    print("updateMemo");
    (await database).transaction((txn) async {
      await txn.update(tableMemo, memo.toMap(), where: '$columnId = ?',
          whereArgs: [memo.id]);
    });
  }



  Future<List<MemoInfo>> readAsColomn() async {
    return (await database).transaction((txn) async {
      List maps = [];
      maps = await txn.query(tableMemo);
      return maps;
    }).then((value) {
      print(value);
      List<MemoInfo>memoInfoNew = [];
      for (var minimap in value) {
        var memoclass = MemoClass.fromMap(minimap);
        var memoInfo = MemoInfo(
          key: ValueKey(minimap[columnId]),
          thisMemo: memoclass,
        );
        if(!memoInfoNew.any((element) => identical(element.thisMemo.id,memoInfo.thisMemo.id))){
          memoInfoNew.add(memoInfo);
        }
      }
      print("read as column");
      return memoInfoNew;
    });
  }

}


class MemoClass{
  late int id;
  late String title;
  late String context;

  MemoClass({this.title = "title",this.context = "context"});

  //insert
  Map<String,Object?> toMap(){
    var map = <String,Object?>{
      DBTool.colomnTitle : title,
      DBTool.colomnContext : context,
    };
    return map;
  }

  //read
  MemoClass.fromMap(Map<String,dynamic> map){
    title = map[DBTool.colomnTitle];
    context = map[DBTool.colomnContext];
    id = map[DBTool.columnId];
  }

}

