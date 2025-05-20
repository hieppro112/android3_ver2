import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'sqflite_db3');
    var database = await openDatabase(path, version: 3, onCreate: (db, version) {
      _onCreatingDatabase(db, version);
    },);
    return database;
  }
}

_onCreatingDatabase(Database database, int version)async {
  await database.execute('''
CREATE TABLE roomHotel (
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    name   TEXT,
    status TEXT,
    image  TEXT
);''');

await database.execute('''CREATE TABLE customertable (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name     TEXT,
    sdt      TEXT,
    cccd     TEXT,
    ngayvao  TEXT,
    ngayra   TEXT,
    id_phong INTEGER REFERENCES roomHotel (id) 
);''');
}
