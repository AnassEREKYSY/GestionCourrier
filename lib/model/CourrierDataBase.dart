import 'package:collapsible_navigation_drawer_example/model/courrier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Listview.dart';

class CourrierDataBase{
  CourrierDataBase._();
  static final CourrierDataBase  instance=CourrierDataBase._();
  static Database ?_database;

  Future<Database?> get database async{
    if(_database!=null) return _database;
    _database= await initDb();
    return _database;
  }
  initDb() async{
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
        join(await getDatabasesPath(),'courrier_database.db'),
      onCreate: (db, version){
          return db.execute(
              "CREATE TABLE courrier(id INTEGER PRIMARY KEY,objet TEXT,expiditeur TEXT,destinataire TEXT,date TEXT,tags TEXT,urgent INTEGER,photos TEXT)"
          );
      },
      version: 1,
    );
  }

  void InsertCourrier(courrier cr) async{
    final Database? db = await database;
    await db!.insert(
        'courrier',
        cr.toMap(),
      conflictAlgorithm:ConflictAlgorithm.replace,
    );
  }

  void UpdateCourrier(courrier cr) async{
    final Database? db = await database;
    await db!.update(
        "courrier",
        cr.toMap(),
      where: "objet=?",whereArgs: [cr.objet],
    );
  }

  void DeleteCourrier(String objet) async{
    final Database? db = await database;
    await db!.delete(
      "courrier",
      where: "objet=?",whereArgs: [objet],
    );
  }
  Future<List<courrier>> courriers() async{
    final Database? db = database as Database?;
    final List<Map<String,dynamic>> maps =  db!.query('courrier') as List<Map<String, dynamic>>;
    List<courrier> cr=List.generate(maps.length, (i) {
      return courrier.fromMap(maps[i]);
    });
    if(cr.isEmpty){
      for(courrier cr in defaultCourrier){
        InsertCourrier(cr);
      }
      cr=defaultCourrier.cast<courrier>();
    }
      return cr;
  }
    List<courrier> defaultCourrier=[
        courrier(
          "type",
          "objet",
          "expiditeur",
          "destinataire",
          "date",
          "tags",
          false,
          "photos",
        ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
      courrier(
        "type",
        "objet",
        "expiditeur",
        "destinataire",
        "date",
        "tags",
        false,
        "photos",
      ),
    ];
}