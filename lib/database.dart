import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class ProductDB {
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

  static const String trx = 'data_trx';
  static const String trxBrg = 'kode_barang';
  static const String trxAmount = 'total_beli';
  static const String trxTotalHarga = 'total_harga';

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
        $namabarang text not null,
        $gambarbarang text not null)
      ''');

      await db.execute('''
      create table $trx ( 
        $id integer primary key autoincrement, 
        $trxBrg text not null,
        $trxAmount text not null,
        $trxTotalHarga text not null)
      ''');
    });
  }

  static Future<void> batchInput() async {
    var barnag = [
      Barang("1234", "Baju", ""),
      Barang("12345", "Sepatu", ""),
    ];
    var stok = [
      Stok("1234", 20, 1),
      Stok("12345", 15, 0),
    ];
    await Future.wait(barnag.map((e) async {
      await insert(tableDataBarangName, {
        "$kodebarang": e.kode,
        "$namabarang": e.nama,
        "$gambarbarang": e.gambar,
      });
    }));
    await Future.wait(stok.map((e) async {
      await insert(datastok, {
        "$idbarang": e.id_barang,
        "$totalbarang": e.total_barang,
        "$jenisstok": e.jenis_stok,
      });
    }));
  }

  static Future<bool> insert(
      String tableName, Map<String, dynamic> user) async {
    int res = await db.insert(tableName, user);
    return res == 1;
  }

  static Future<List<Map<String, dynamic>>?> getAllProduct() async {
    final List<Map> maps = await db.rawQuery(
        "SELECT $tableDataBarangName.$kodebarang, $tableDataBarangName.$namabarang, $datastok.$totalbarang, $datastok.$jenisstok FROM $tableDataBarangName INNER JOIN $datastok ON $tableDataBarangName.$kodebarang = $datastok.$idbarang");
    if (maps.isNotEmpty) {
      return maps
          .map((e) => {
                'kode_barang': e[kodebarang],
                'nama_barang': e[namabarang],
                'jenis_stok': e[jenisstok],
                'total_barang': e[totalbarang],
              })
          .toList();
    } else {
      return null;
    }
  }

  // static Future<User?> getUser(int id) async {
  //   final List<Map> maps =
  //       await db.query(tableName, where: '$id = ?', whereArgs: [id]);
  //   if (maps.isNotEmpty) {
  //     return User.fromJson(maps.first as Map<String, dynamic>);
  //   }
  //   return null;
  // }

  // static Future<User?> getUserByEmail(String email) async {
  //   final List<Map> maps =
  //       await db.query(tableName, where: '$_email = ?', whereArgs: [email]);
  //   if (maps.isNotEmpty) {
  //     return User.fromJson(maps.first as Map<String, dynamic>);
  //   }
  //   return null;
  // }
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

join(String databasePath, String dbName) {}
