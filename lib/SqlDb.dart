

import 'package:collapsible_navigation_drawer_example/model/courrier.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb{
  static Database? _db;
  Future<Database?> get db async{
    if(_db==null){
      _db=await initialDb();
      return _db;
    }else{
      return _db;
    }

  }
  initialDb() async{
    String databasepath= await getDatabasesPath();
    String path=join(databasepath,'stage_estm.db');
    Database mydb=await openDatabase(path,onCreate: _onCreate,version: 21,onUpgrade: _onUpgrade);
    return mydb;
  }
  test(Database db) async{
    // await db!.execute('''
    //   ALTER TABLE "courrier" ADD "id_user" INTEGER
    // ''');
    // print('success');
    // await db!.execute('''
    //   ALTER TABLE "courrier" ADD "archive" INTEGER
    // ''');
    // await db!.execute('''
    //   ALTER TABLE "user" ADD "photo" TEXT
    // ''');
    // await db!.execute('''
    //   CREATE TABLE "photos"(
    //     "id" INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT,
    //     "id_courrier" INTEGER NOT NULL,
    //     "im1" TEXT ,
    //     "im2" TEXT ,
    //     "im3" TEXT ,
    //     "im4" TEXT ,
    //     "im5" TEXT ,
    //     "im6" TEXT ,
    //     "im7" TEXT ,
    //     "im8" TEXT ,
    //     "im9" TEXT ,
    //     "im10" TEXT
    //     )
    // ''');
    print('success1');
  }
  _onCreate(Database db,int version) async{
    await db.execute('''
      CREATE TABLE "courrier"(
        "id" INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT,
        "id_user" INTEGER NOT NULL,
        "type" TEXT NOT NULL,
        "objet" TEXT NOT NULL,
        "expiditeur" TEXT,
        "destinataire" TEXT,
        "date" TEXT,
        "tags" TEXT,
        "photos" TEXT,
        "urgent" INTEGER
        )
    ''');
    await db.execute('''
    //   CREATE TABLE "user"(
    //     "id" INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT,
    //     "cin" TEXT NOT NULL,
    //     "nom" TEXT NOT NULL,
    //     "prenom" TEXT NOT NULL,
    //     "email" TEXT NOT NULL,
    //     "adresse" TEXT NOT NULL,
    //     "mot_de_passe" TEXT NOT NULL,
    //     "telephone" TEXT NOT NULL
    //     )
    // ''');
    await db.execute('''
      CREATE TABLE "photos"(
        "id" INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT,
        "id_courrier" INTEGER NOT NULL,
        "im1" TEXT ,
        "im2" TEXT ,
        "im3" TEXT ,
        "im4" TEXT ,
        "im5" TEXT ,
        "im6" TEXT ,
        "im7" TEXT ,
        "im8" TEXT ,
        "im9" TEXT ,
        "im10" TEXT
        )
    ''');
    print("onCreate====================");
  }
  _onUpgrade(Database db ,int oldversion,int newversion) async{
    // await db.execute('''
    //   CREATE TABLE "photos"(
    //     "id" INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT,
    //     "id_courrier" INTEGER NOT NULL,
    //     "im1" VARBINARY ,
    //     "im2" VARBINARY ,
    //     "im3" VARBINARY ,
    //     "im4" VARBINARY ,
    //     "im5" VARBINARY ,
    //     "im6" VARBINARY ,
    //     "im7" VARBINARY ,
    //     "im8" VARBINARY ,
    //     "im9" VARBINARY ,
    //     "im10" VARBINARY
    //     )
    // ''');
    // await db.execute('''
    //   DROP TABLE user
    // ''');
    await db.execute('''
      CREATE TABLE "user"(
        "id" INTEGER NOT NULL  PRIMARY KEY AUTOINCREMENT,
        "cin" TEXT NOT NULL,
        "nom" TEXT NOT NULL,
        "prenom" TEXT NOT NULL,
        "email" TEXT NOT NULL,
        "adresse" TEXT NOT NULL,
        "mot_de_passe" TEXT NOT NULL,
        "telephone" TEXT NOT NULL,
        "photo" VARBINARY
        )
    ''');
    print("onUpgrade====================");
  }
  readData(String sql) async{
    Database? mydb=await db;
    List<Map> response=await mydb!.rawQuery(sql);
    return response;
  }
  getId(courrier cr)async{
    Database? mydb=await db;
    List<Map> response=await mydb!.rawQuery("SELECT id FROM courrier WHERE objet="+cr.objet+" AND type="+cr.type+" AND date="+cr.date+" AND expiditeur="+cr.expiditeur+" AND destinataire="+cr.destinataire);
    return response;
  }
  insertData(String sql) async{
    Database? mydb=await db;
    int response=(await mydb!.rawInsert(sql) )as int;
    return response;
  }
  updateData(String sql) async{
    Database? mydb=await db;
    int response=await mydb!.rawUpdate(sql);
    return response;
  }
  deleteData(String sql) async{
    Database? mydb=await db;
    int response=(await mydb!.rawDelete(sql)) as int;
    return response;
  }

  user_readData(String sql) async{
    Database? mydb=await db;
    List<Map> response=await mydb!.rawQuery(sql);
    return response;
  }
  user_existance(String sql) async{
    Database? mydb=await db;
    int response=(await mydb!.rawQuery(sql)) as int;
    return response;
  }
  user_insertData(String sql) async{
    Database? mydb=await db;
    int response=await mydb!.rawInsert(sql);
    return response;
  }
  user_updateData(String sql) async{
    Database? mydb=await db;
    int response=await mydb!.rawUpdate(sql);
    return response;
  }
  user_deleteData(String sql) async{
    Database? mydb=await db;
    int response=await mydb!.rawDelete(sql);
    return response;
  }
}