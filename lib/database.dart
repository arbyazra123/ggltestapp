import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  static late Database db;

  static const String dbName = 'trx.db';
  static const String id = 'id';
  static const String tableDataBarangName = 'data_barang';
  
  static const String kodebarang = 'kode_barang';
  static const String namabarang = 'nama_barang';
  static const String gambarbarang = 'gambar_barang';

  static const String datastok = 'data_stok';
  static const String idbarang = 'id_barang';
  static const String totalbarang = 'total_barang';
  static const String jenisstok = 'jenis_stok';

  static Future<void> open() async {
    var path = await initDeleteDb(dbName);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $datastok ( 
  $id integer primary key autoincrement, 
  $idbarang text not null,
  $totalbarang text not null,
  $jenisstok text not null)
  
''');
      await db.execute('''
create table $tableDataBarangName ( 
  $id integer primary key autoincrement, 
  $kodebarang text not null,
  $idbarang text not null,
  $gambarbarang text not null)
  
''');
    });
  }

  static Future<bool> insert(User user) async {
    var isExists = await getUserByEmail(user.email!);
    if (isExists != null) {
      return false;
    }
    int res = await db.insert(tableName, user.toJson());
    return res == 1;
  }

  static Future<User?> getUser(int id) async {
    final List<Map> maps =
        await db.query(tableName, where: '$id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  static Future<User?> getUserByEmail(String email) async {
    final List<Map> maps =
        await db.query(tableName, where: '$_email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first as Map<String, dynamic>);
    }
    return null;
  }
}


Future<String> initDeleteDb(String dbName) async {
  final databasePath = await getDatabasesPath();
  // print(databasePath);
  final path = join(databasePath, dbName);

  // make sure the folder exists
  // ignore: avoid_slow_async_io
  if (await Directory(dirname(path)).exists()) {
    await deleteDatabase(path);
  } else {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  return path;
}

join(String databasePath, String dbName) {
}