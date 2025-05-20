
import 'package:giadienver1/database/database_connecting.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;

  Repository(){
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _databaseConnection.setDatabase();

  if (_database == null) {
    throw Exception("Database not initialized properly!");
  }

  return _database!;
}

  //insert rooom 

  insertData(table,data) async{
    var connection = await database;
    return await connection.insert(table, data);
  }

  //read room 
  readData(table) async{
    var connection = await database;
    return await connection.query(table);
  }

  //add customer
  isertCustomer(table,data) async{
    var connection = await database;
    return await connection.insert(table, data);
  }

  //read customer
  readCustomer(table) async{
    var connection = await database;
    return await connection.query(table);
  }

  Future<List<Map<String, dynamic>>> thongtinkhachhang(int idPhong) async {
  var connection = await database;
  return await connection.query(
    'customertable',
    where: 'id_phong = ?',
    whereArgs: [idPhong],
  );
}

//xoa thong tin khi thanh toán 
Future<void> xoaCustomer(int id) async {
  var connection = await database;
  await connection.delete('customertable', where: 'id = ?', whereArgs: [id]);
}

//sua thong tin khach hang
Future<void> updateCustomer(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
  var connection = await database;
  await connection.update(table, data, where: where, whereArgs: whereArgs);
}


  // Lay ds cus
  Future<List<Map<String, dynamic>>> layDanhSachLienLac() async {
    var connection = await database;
    return await connection.query(
      'customertable',
      columns: ['id', 'id_phong', 'name', 'cccd', 'sdt'],
    );
  }


}